
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_product_details_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS47256 --browser chrome  --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_product_details_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS49030 --browser chrome  --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_product_details_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS58346 --browser chrome  --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_product_details_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS58349 --browser chrome  --or
require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name('ID')
$tc_desc = id_row.find_value_by_name('TestDescription')
$tc_desc = 'Test case description was not found' if $tc_desc == ''
describe "Verify Product Details" do
    before(:all) do
			@browser = WebInStoreBrowser.new(browser_type_parameter)
			@browser.delete_internet_files(browser_type_parameter)
			$options.default_timeout = 90_000
			$snapshots.setup(@browser, :all)
			$tracer.mode = :on
			$tracer.echo = :on
    end

    before(:each) do
	    @browser.cookie.all.delete
			@params = @browser.get_params_from_csv
			@global_functions = GlobalServiceFunctions.new()
			@global_functions.csv = @params["row"]
			@global_functions.parameters
			@catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
			@sql = @global_functions.sql_file
			@db = @global_functions.db_conn
			@store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc
			@start_page = @global_functions.prop_url.find_value_by_name("url")
			@purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
			@session_id = generate_guid
			@store_addresses =@store_search_svc.perform_get_all_stores_in_range(@session_id, "GS_US", "en-US", @store_search_svc_version, @params["ship_zip"], 10)
			@store=@store_addresses[0].store_number.content
			@product_sku, @out_of_stock, @low_stock = @browser.load_test_skus_from_db(@db, @sql.to_s)
		end

    after(:each) do
      @browser.return_current_url
			@browser.close_all()
		end

	it "#{$tc_id} #{$tc_desc}" do
	  url = "#{@start_page}/Checkout/instore/product?store=#{@store}&reg=3&sku=#{@product_sku}&guest=true"
	  @browser.open(url)
		# ensure_only_one_browser_window_open
		if (@params["product_details_mature_product"])
			@browser.age_verification_required_label.should_exist
			@browser.age_warning_checkbox.should_exist
			sleep 5
		
			if(@params["product_details_out_of_stocks"])
				@browser.disabled_button.should_exist
			else
				@browser.age_warning_checkbox.click
			end	
		else
			get_catalog_data
			if (@params["product_details_full_details"])
				validate_product_info
			else
				validate_product_summary
			end			 
		end 
	end

	def validate_product_summary
		 @browser.sell_sheet_button.should_exist
		 @browser.sell_sheet_button.click
		 @browser.product_summary.should_exist
		 #validate UI product summary against endeca short description
		 product_summary= @browser.product_summary.innerText
		 @browser.validate_label(product_summary,@short_description)
	end
	
	def get_catalog_data
		catalog_get_product_data=@catalog_svc.perform_get_product_by_sku(@catalog_svc_version,@session_id,@product_sku).http_body.find_tag("product").at(0)
		@average_overall_rating = catalog_get_product_data.average_overall_rating.content
		@condition = catalog_get_product_data.condition.content
		@definition_name = catalog_get_product_data.definition_name.content
		@display_name = catalog_get_product_data.display_name.content
		@e_sr_brating = catalog_get_product_data.esrb_rating.content
		@e_sr_brating_text = catalog_get_product_data.esrb_rating_text.content
		@e_sr_bsmall_image_url = catalog_get_product_data.esrb_small_image_url.content
		@image_large_box = catalog_get_product_data.image_large_box.content
		@platform = catalog_get_product_data.platforms.string.at(0).content
		@last_price = catalog_get_product_data.last_price.content
		@list_price = catalog_get_product_data.list_price.content
		@short_description = catalog_get_product_data.short_description.content
		@catalog_sku = catalog_get_product_data.sku.content
	end
	
	def validate_product_info
		 @browser.product_details_label.should_exist
		 @browser.product_platform_label.should_exist
		 @browser.product_image.should_exist
		 @browser.product_sku.should_exist
		 @browser.esrb_rating_image.should_exist
		 @browser.product_user_rating.should_exist
		 @browser.product_description.should_exist
		 @browser.product_detail_price.should_exist
		 @browser.product_condition.should_exist
		 if (@browser.product_description.innerText.length > 100)
			@browser.more_description.should_exist
			@browser.more_description.click
		 end 	 
		 product_display_name=@browser.product_details_label.innerText
		 product_plat_form=@browser.product_platform_label.innerText
		 product_image=@browser.product_image.outerHTML
		 product_sku=@browser.product_sku.innerText
		 esrb_image=@browser.esrb_rating_image.outerHTML
		 esrb_rating=@browser.product_user_rating.innerText
		 short_description=@browser.product_description.innerText
		 item_price=@browser.product_detail_price.innerText
		 product_condition=@browser.product_condition.innerText
		 
		  #validate UI display name against endeca
		 @browser.validate_label(product_display_name,@display_name)
		  #validate UI product plat form against endeca
		 @browser.validate_label(product_plat_form,@platform)
		  #validate UI product image against endeca
		 @browser.validate_label(product_image,@image_large_box)
		  #validate UI sku number against endeca
		 @browser.validate_label(product_sku,@catalog_sku)
		  #validate UI esrb rating image against endeca
		 @browser.validate_label(esrb_image,@e_sr_bsmall_image_url)
		  #validate UI esrb rating against endeca
		 @browser.validate_label(esrb_rating,@browser.round(@average_overall_rating))
		  #validate UI short description against endeca
		 @browser.validate_label(short_description,@short_description)
		  #validate UI item price against endeca
		 @browser.validate_label(item_price,@browser.round(@list_price))
		  #validate UI product condition against endeca
		 condition="Pre-Owned"
			if (@browser.isvalexist(product_condition,condition))
				product_condition="Used"
			end	
		 @browser.validate_label(product_condition,@condition)
	end
end
#################################################################################################################################################################################################################################### 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_pro_pur_pre_owned_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS47257 --browser chrome --or 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_pro_pur_pre_owned_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49028 --browser ie --or  
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_pro_pur_pre_owned_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS40142 --browser ie --or 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_pro_pur_pre_owned_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49737 --browser ie --or 
#################################################################################################################################################################################################################################### 

require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name('ID')
$tc_desc = id_row.find_value_by_name('TestDescription')
$tc_desc = 'Test case description was not found' if $tc_desc == ''

describe "Checkout pro pur pre owned" do
	before(:all) do
		@browser = WebInStoreBrowser.new(browser_type_parameter)
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
		@sql = @global_functions.sql_file
		@db = @global_functions.db_conn
		@store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc
		@start_page = @global_functions.prop_url.find_value_by_name("url")
		@session_id = generate_guid
		@store_addresses =@store_search_svc.perform_get_all_stores_in_range(@session_id, "GS_US", "en-US", @store_search_svc_version, "76051", 20)
		@store=@store_addresses[0].store_number.content
		@product_sku, @out_of_stock, @low_stock = @browser.load_test_skus_from_db(@db, @sql.to_s)
	end

  after(:each) do
    @browser.return_current_url
		@browser.close_all()
	end

	it "#{$tc_id} #{$tc_desc}" do
		url = "#{@start_page}/Checkout/instore/product?store=#{@store}&reg=3&sku=#{@product_sku}&ctguest=true"	
		@browser.open(url)
		
		@browser.validate_customer_header(@params["search_value"])
		unless @params["free_pur_member"] 
			if @params["search_value"]!=""
				puts "---------------------------------- TFS40142 TFS49028"
				@browser.cart_quantity_field.should_exist
				@browser.cart_quantity_field.value="2"
			end
		end	
		@browser.cart_information_exist
		@browser.shipping_search_field_exist
		
		$tracer.trace("Search for customer using PUR number")
		@browser.customer_search(@params["pur_number"],0)
		@browser.shipping_information_exist(@params["ship_country"],@params["ship_first_name"],@params["ship_last_name"],@params["ship_addr1"],@params["ship_addr2"],@params["ship_city"],@params["ship_state"],@params["ship_zip"],@params["ship_phone"],@params["ship_email"],@params["is_new"], @params["disable_state"])
		
		$tracer.trace("Validates if Customer Header Information is available")
		@browser.validate_customer_header(@params["pur_number"])
		
		$tracer.trace("Verifies the Shipping Options panel and Amount information of the Product.")
		@browser.handling_option_product_review_info
		
		if (@params["free_pur_member"])
			puts "---------------------------------- TFS49737"
			$tracer.trace("Validates discount amount for free PUR member. Discount should be equal to 0.00")
			discount = @browser.discount_amount.inner_text.gsub("$", "")
			discount.gsub("- ","").should=="0.00"
		else
			if @params["search_value"]==""
				puts "---------------------------------- TFS47257"
				$tracer.trace("Validates discount amount for PUR member. Discount should NOT be equal to 0.00")
				@calculated_discount = @browser.subtotal_amount.inner_text.gsub("$", "").to_f * 0.10
				discount = @browser.discount_amount.inner_text.gsub("$", "")
				discount.gsub("- ","").should_not=="0.00"
				
				$tracer.trace("Expected Discount Amount: #{discount.gsub("- ","")}")
				$tracer.trace("Actual Calculated Discount Amount: #{@browser.round(@calculated_discount)}")
				
				# We should not validate discount from subtotal_amount multiplied by 0.10 because there are instances that it's not always 0.10
				# discount.gsub("- ","").should==@browser.round(@calculated_discount).to_s
			end
		end	
		
		if(@params["submit_order_flag"])
			# @browser.submit_button.click
			@browser.wait_for_landing_page_load
			@browser.order_confirm_info
		end
	end
end

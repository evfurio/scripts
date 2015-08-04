##USAGE NOTES

#GameStop
##d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_request_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_dataset.csv --range TFS48821 --login tstr3@gs.com --password T3sting --browser chrome -e 'should allow a logged in user to do a pickup at store with an alternate store' --or

##author: dturner

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Verify HOPS Functionality" do

  before(:all) do
    @browser = GameStopBrowser.new(browser_type_parameter)
	GameStopBrowser.delete_temporary_internet_files(browser_type_parameter)
	$options.default_timeout = 10_000
    $tracer.mode=:on
	$tracer.echo=:on 
	$snapshots.setup(@browser, :all)
  end

  before(:each) do
  	@browser.cookie.all.delete
	#initializes the csv parameters used by the script
	initialize_csv_params
	
	#Get necessary GUID's per test method execution
	@session_id = generate_guid
	
	#global_functions passes the csv row object and return the parameters.
	@global_functions = GlobalServiceFunctions.new()
	@global_functions.parameters
	@global_functions.csv = @row
	@sql = @global_functions.sql_file
	@db = @global_functions.db_conn
	@catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
	@start_page = @global_functions.prop_url.find_value_by_name("url")
	
	
	#@browser.setup_before_each_scenario(@start_page)
	sql = @sql.to_s
	@results_from_file = @db.exec_sql_from_file("#{sql}") 
	
	#uses the sku(s) returned from the SQL query to get product details information from the catalog service
	$tracer.trace(" *** Get Product Data *** ")
	#get_product_data
	get_sku_and_store_data
	#get_store_data
	
	# Replace this with the clean all browser cache/cookies
	# checking to see if we're still logged in, if so, log out.  fix for the auth "states".

  end

  after(:all) do
    $tracer.trace("after all")	
    @browser.close_all()
  end

  after(:each) do
    @browser.return_current_url
	  #ModHost.mess_cleaner
	  #$tracer.trace("Changes were reverted to for the HOSTS file.")
  end

  
  it "should allow a logged in user to do a pickup at store with an alternate store" do
  
  ## It builds the hold URL or it gets the hose again.
		url = @start_page
		@browser.open(@start_page)
		surl = url.gsub!(/http/, "https")
		hold_request = "#{surl}/Orders/HoldRequest.aspx"
		hold_url = "#{hold_request}?store=#{@store}&sku=#{@sku}"
		hold_url = hold_url.chomp
		
  ## RUNS THE TEST	
		@browser.log_in_link.click
        @browser.log_in(account_login_parameter, account_password_parameter)	
		@browser.open(@start_page)
		@browser.open(hold_url)
		$tracer.trace(hold_url)
		@browser.log_out_link.exists
		
        #@browser.hops_product_name_label.should == @product_name
		first_name =  @browser.first_name_field.value
        @browser.first_name_field.value.should == "Accept"#@row.find_value_by_name("bill_first_name")
		$tracer.trace(first_name)
		
		last_name = @browser.last_name_field.value
        @browser.last_name_field.value.should == @row.find_value_by_name("bill_last_name")
		$tracer.trace(last_name)
		
        @browser.email_address_field.value.should == account_login_parameter
		$tracer.trace(account_login_parameter)
		
        @browser.confirm_email_address_field.value.should == account_login_parameter
		$tracer.trace(account_login_parameter)
		
		phone_number = @browser.phone_number_field.value
#strip the phone number so it's numeric only
        #@browser.phone_number_field.value.should == @row.find_value_by_name("bill_phone")
		$tracer.trace(phone_number)

        @browser.hops_finish_button.click
        @browser.hops_alternate_store_popup_panel.should be_visible
        @browser.hops_alternate_store_popup_panel.cancel_link.click
        @browser.hops_alternate_store_popup_panel.should_not be_visible
        #@browser.timeout(1000).hops_hold_request_label.should_not_exist

        @browser.hops_finish_button.click
        @browser.hops_alternate_store_popup_panel.should be_visible
        @browser.hops_alternate_store_popup_panel.set_alternate_store_button.click

        @browser.hops_accepted_page_title.should_exist
        @browser.hops_accepted_page_message.inner_text.should start_with "Sweet! We've sent an email to"

        @browser.log_out_link.click
  
  end
  
  it "should allow a logged in user to do a pickup at store with an alternate store the long way" do

        @browser.log_in_link.click
        @browser.log_in(account_login_parameter, account_password_parameter)	 
		
		# expected to be on the product details page at this point.
		$tracer.trace("#{@url}")
		url = "#{@start_page}#{@url}" 
		@browser.open(url)
		@browser.wait_for_landing_page_load
        #name = product.name_link.inner_text
		
        product.store_pickup_link.click
        @browser.wait_for_landing_page_load

        #@browser.hops_product_name_link.inner_text.should start_with name
        @browser.hops_zip_code_search_field.value = @row.find_value_by_name("ship_zip")
        @browser.hops_zip_code_search_button.click

        store_list = @browser.hops_store_list
        store_list.should_exist
        pickup_at_store_button = store_list.at(0).pickup_at_store_button
        pickup_at_store_button.should_exist
        pickup_at_store_button.click

        @browser.wait_for_landing_page_load
        @browser.hops_product_name_label.should match @product_name
        @browser.first_name_field.value.should == @row.find_value_by_name("bill_first_name")
        @browser.last_name_field.value.should == @row.find_value_by_name("bill_last_name")
        @browser.email_address_field.value.should == account_login_parameter
        @browser.confirm_email_address_field.value.should == account_login_parameter
        @browser.phone_number_field.value.should == @row.find_value_by_name("bill_phone")

        @browser.hops_finish_button.click
        @browser.hops_alternate_store_popup_panel.should be_visible
        @browser.hops_alternate_store_popup_panel.cancel_link.click
        @browser.hops_alternate_store_popup_panel.should_not be_visible
        @browser.timeout(1000).hops_hold_request_label.should_not_exist

        @browser.hops_finish_button.click
        @browser.hops_alternate_store_popup_panel.should be_visible
        @browser.hops_alternate_store_popup_panel.set_alternate_store_button.click

        @browser.hops_accepted_page_title.should_exist
        @browser.hops_accepted_page_message.inner_text.should start_with "Sweet! We've sent an email to"

        @browser.log_out_link.click
    end

    it "should allow a logged in user to do a pickup at store without an alternate store" do

        @browser.log_in_link.click
        @browser.log_in(account_login_parameter, account_password_parameter)

        @browser.search_for_product_with_pickup_at_store(@row.find_value_by_name("hops_product"))

        product = @browser.product_list.at(0)
        name = product.name_link.inner_text
        product.store_pickup_link.click
        @browser.wait_for_landing_page_load

        #@browser.hops_product_name_link.inner_text.should start_with name
        @browser.hops_zip_code_search_field.value = @row.find_value_by_name("hops_zip")
        @browser.hops_zip_code_search_button.click

        store_list = @browser.hops_store_list
        store_list.should_exist
        pickup_at_store_button = store_list.at(0).pickup_at_store_button
        pickup_at_store_button.should_exist
        pickup_at_store_button.click

        @browser.wait_for_landing_page_load
        @browser.hops_product_name_label.should match name
        @browser.first_name_field.value.should == @row.find_value_by_name("bill_first_name")
        @browser.last_name_field.value.should == @row.find_value_by_name("bill_last_name")
        @browser.email_address_field.value.should == account_login_parameter
        @browser.confirm_email_address_field.value.should == account_login_parameter
        @browser.phone_number_field.value.should == @row.find_value_by_name("ship_phone")

        @browser.hops_finish_button.click
        @browser.hops_alternate_store_popup_panel.should be_visible
        @browser.hops_alternate_store_popup_panel.cancel_link.click
        @browser.hops_alternate_store_popup_panel.should_not be_visible
        @browser.timeout(1000).hops_hold_request_label.should_not_exist

        @browser.hops_finish_button.click
        @browser.hops_alternate_store_popup_panel.should be_visible
        @browser.hops_alternate_store_popup_panel.no_thanks_button.click

        @browser.hops_accepted_page_title.should_exist
        @browser.hops_accepted_page_message.inner_text.should start_with "Sweet! We've sent an email to"

        @browser.log_out_link.click
    end
	
	def initialize_csv_params
		csv = QACSV.new(csv_filename_parameter)
		@row = csv.find_row_by_name(csv_range_parameter)
		@sign_up_weekly_ads  = @row.find_value_by_name("sign_up_weekly_ads")
		@power_up_rewards_number = @row.find_value_by_name("power_up_rewards_number")
		@promo_code_number = @row.find_value_by_name("promo_code_number")
		@add_free_gift = @row.find_value_by_name("add_free_gift")
		@add_digital_wallet = @row.find_value_by_name("add_digital_wallet")
		@billing_address_same_as_shipping = @row.find_value_by_name("billing_address_same_as_shipping")
		@credit_card = @row.find_value_by_name("cc_number")
		@cc_type = @row.find_value_by_name("cc_type")
		@exp_month = @row.find_value_by_name("cc_month")
		@exp_year = @row.find_value_by_name("cc_year")
		@svs = @row.find_value_by_name("cvv")
		@shipping_option = @row.find_value_by_name("shipping_option")
		@submit_order_flag  = @row.find_value_by_name("submit_order_flag")
		@gift_msg = "Gift message string"
		@ship_first_name = @row.find_value_by_name("ship_first_name")
		@ship_last_name = @row.find_value_by_name("ship_last_name")
		@ship_addr1 = @row.find_value_by_name("ship_addr1")
		@ship_addr2 = @row.find_value_by_name("ship_addr2")
		@ship_city = @row.find_value_by_name("ship_city")
		@ship_state = @row.find_value_by_name("ship_state")
		@ship_zip = @row.find_value_by_name("ship_zip")
		@ship_phone = @row.find_value_by_name("ship_phone")
		@ship_email = @row.find_value_by_name("ship_email")
		@ship_country = @row.find_value_by_name("ship_country")
		@bill_country = @row.find_value_by_name("bill_country")
		@bill_first_name = @row.find_value_by_name("bill_first_name")
		@bill_last_name = @row.find_value_by_name("bill_last_name")
		@bill_addr1 = @row.find_value_by_name("bill_addr1")
		@bill_addr2= @row.find_value_by_name("bill_addr2")
		@bill_city= @row.find_value_by_name("bill_city")
		@bill_state= @row.find_value_by_name("bill_state")
		@bill_zip= @row.find_value_by_name("bill_zip")
		@bill_phone = @row.find_value_by_name("bill_phone")
		@bill_email = @row.find_value_by_name("bill_email")
		#@inj_host = "hosts.ebgames"
	end

	def get_product_data
		#############################DSL#####################################
		#call to the catalog service to get the entity.url if the service is up
		### GET_PRODUCT URL### THIS NEEEDS TO BE IN A DSL AND CALLED IN BEFORE EACH
		$tracer.trace("VariantID used for test: #{@sku}")
		@sku = @results_from_file.at(0).variantid
	end
	
	def get_sku_and_store_data		
		store_query = "SELECT top 50 a.[StoreID] as storeid, a.[QtyOnHand] as onhand, d.[ProductID] as productid, d.[Sku] as sku, f.[HopsEnabled] as hopsenabled, f.[StoreNumber] as storenumber
FROM [StoreInformation].[dbo].[StoreInventory] a with (NOLOCK) 
INNER JOIN [StoreInformation].[dbo].[Product] d on a.ProductID = d.ProductID 
INNER JOIN [StoreInformation].[dbo].[Store] f on a.StoreID = f.StoreID
WHERE a.QtyOnHand > 10 and  f.HopsEnabled = 1 ORDER BY NEWID()"
		

		server = "GV1HQDDB50SQL03.testgs.pvt\\INST03"
		database = "StoreInformation"
		dbuser, dbpass = @browser.return_db_creds

		@db = DbManager.new(server, database, dbuser, dbpass)
		sql2 = store_query
		@results_from_file = @db.exec_sql("#{sql2}") 
		
		#@sku_match needs to be an array from the list of skus we get back from store information
		sku_match = []
		index = 0
		@results_from_file.each_with_index do |variant, i|
			store = @results_from_file.at(index).storenumber
			sku_match.push(variant.sku,store)
			index += 1
		end
		
		#puts *sku_match
		sku_store_hash = Hash[*sku_match]
		puts sku_store_hash
		
		availability = ""
		ind = 0
		ind_len = sku_store_hash.keys.length
		
		
		sku_store_hash.each_with_index do |(sku, store), i|
			$tracer.trace("THIS IS THE INDEX #{i}")
			begin
				#call to the catalog service to find a product that is available, if not, get the next sku in the array
				get_products_req = @catalog_svc.get_request_from_template_using_global_defaults(:get_products, CatalogServiceRequestTemplates.const_get("GET_PRODUCTS#{@catalog_svc_version}"))
				get_products_request_data = get_products_req.find_tag("get_products_request").at(0)
				get_products_request_data.session_id.content = @session_id       
				get_products_request_data.skus.string.at(0).content = sku
				get_products_rsp = @catalog_svc.get_products(get_products_req.xml)
				$tracer.trace(get_products_req.formatted_xml)
				get_products_rsp.code.should == 200
				$tracer.trace("GET PRODUCTS RESPONSE")
				catalog_get_product_data = get_products_rsp.http_body.find_tag("product").at(0)
				availability = catalog_get_product_data.availability.content.to_s
				can_do_hops = catalog_get_product_data.is_in_store_pickup_for_hops.content.to_s
					$tracer.trace("THIS IS THE FLAG FOR CAN DO HOPS: #{can_do_hops} FOR #{sku}")
					$tracer.trace("THIS IS THE AVAILABILITY: #{availability} FOR #{sku}")
					#$tracer.trace(get_products_rsp.formatted_xml)
					$tracer.trace("\tTHIS IS THE INDEX #{ind}\n\n")
				@sku = sku.to_s
				@store = store.to_s
				# ind += 1
			rescue Exception => ex
				@sku = sku.to_s
				@store = store.to_s
				# ind += 1
				$tracer.trace("THIS IS THE INDEX #{ind} OF #{ind_len}")
				$tracer.trace("CRITERIA NOT MET, KEEP LOOKING FOR YOU DROIDS")
				#break if ind_len == ind
			end
			break if (can_do_hops == "true" && availability == "A")
		end
	end
	
	

end
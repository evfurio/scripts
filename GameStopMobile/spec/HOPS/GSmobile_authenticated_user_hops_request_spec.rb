##########################################################################################################################################################################################################################################################################
## EXECUTE IF ShowHopsPURandCC is TRUE
##
## Calling parameters from command line
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\HOPS\GSmobile_authenticated_user_hops_request_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\HOPS\mobile_hops_dataset.csv  --range HOPS01  --login tstr3@gs.com --password T3sting  --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url MQA_GS  --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_hops_product.sql  --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog"  --browser chrome -e 'GS Mobile RequestHops as AuthenticatedUser when ShowHopsPURandCC is TRUE' --or
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\HOPS\GSmobile_authenticated_user_hops_request_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\HOPS\mobile_hops_dataset.csv  --range HOPS01  --login without_billing@test.com --password T3sting  --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url MQA_GS  --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_hops_product.sql  --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog"  --browser chrome -e 'GS Mobile RequestHops as AuthenticatedUser when ShowHopsPURandCC is TRUE' --or
##
## Calling parameters from csv
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\HOPS\GSmobile_authenticated_user_hops_request_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\HOPS\mobile_hops_dataset.csv  --range HOPS01  --login tstr3@gs.com --password T3sting  --browser chrome -e 'GS Mobile RequestHops as AuthenticatedUser when ShowHopsPURandCC is TRUE' --or
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\HOPS\GSmobile_authenticated_user_hops_request_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\HOPS\mobile_hops_dataset.csv  --range HOPS01  --login without_billing@test.com --password T3sting  --browser chrome -e 'GS Mobile RequestHops as AuthenticatedUser when ShowHopsPURandCC is TRUE' --or
##
##########################################################################################################################################################################################################################################################################
## EXECUTE IF ShowHopsPURandCC is FALSE
##
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\HOPS\GSmobile_authenticated_user_hops_request_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\HOPS\mobile_hops_dataset.csv  --range HOPS04  --login tstr3@gs.com --password T3sting  --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url MQA2_GS  --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_hops_product.sql  --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog"  --browser chrome -e 'GS Mobile RequestHops as AuthenticatedUser when ShowHopsPURandCC is FALSE' --or
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\HOPS\GSmobile_authenticated_user_hops_request_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\HOPS\mobile_hops_dataset.csv  --range HOPS04  --login without_billing@test.com --password T3sting  --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url MQA2_GS  --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_hops_product.sql  --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog"  --browser chrome -e 'GS Mobile RequestHops as AuthenticatedUser when ShowHopsPURandCC is FALSE' --or
##
##########################################################################################################################################################################################################################################################################


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"

describe "Verify HOPS Functionality in GS Mobile" do

  before(:all) do
	#added a second parameter to set 'use_insecure_content' to TRUE
    @browser = GameStopMobileBrowser.new(browser_type_parameter, true)
	$options.default_timeout = 10_000
    $tracer.mode=:on
	$tracer.echo=:on 
	$snapshots.setup(@browser, :all)
  end

  before(:each) do
  	@browser.cookie.all.delete

	#initializes the csv parameters used by the script
	initialize_csv_params
	
	#get necessary GUID's per test method execution
	@session_id = generate_guid
	
	#gets the csv parameters
	csv = QACSV.new(csv_filename_parameter)
	@row = csv.find_row_by_name(csv_range_parameter)	
	@global_functions = GlobalServiceFunctions.new()
	@global_functions.csv = @row
	@global_functions.parameters
	@start_page = @global_functions.prop_url.find_value_by_name("url")
	@store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc
	@catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
	
	@radius_in_km = "20"
	@store_addresses = @store_search_svc.perform_get_all_stores_in_range(@session_id, "GS_US", "en-US", @store_search_svc_version, @hops_zip, @radius_in_km)
	i = 0
	while i < @store_addresses.length
		if i == @store_addresses.length - 1
			@store = "#{@store_addresses[i].store_number.content }"
		else
			@store = "#{@store_addresses[i].store_number.content }" + ", "
		end
		@stores_in_range = "#{@stores_in_range}" + "#{@store}" 
		i = i + 1
	end 
	
	get_sku_and_store_data
	@product_url = "/Catalog/Sku/#{@sku}"
	#@product_url = "/Catalog/Product/#{@product}"
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    $tracer.trace("after all")	
    @browser.close_all()
  end
    
   it "GS Mobile RequestHops as AuthenticatedUser when ShowHopsPURandCC is TRUE" do
		#Open Gamestop Mobile start page
		@browser.open(@start_page)
		
		#Click the "View Cart" button
		@browser.view_cart_button.click
		
		#Click the "Logout" link if exists
		@browser.log_out_link.click if @browser.log_out_link.exists == true
		
		#Click the "Login" link
		@browser.log_in_link.click
		
		#Click the "Log Into My Account" button
		@browser.log_into_my_account_button.click
		
		#Enter Login Credentials.
		@browser.enter_login_credentials(account_login_parameter, account_password_parameter)
		
		#Click the "Log In" button
		@browser.user_login_button.click
		
		#Remove items from the cart
		@browser.empty_new_cart
		
		#Click the "Continue Shopping" button
		@browser.continue_shopping_button.click

		#Click the "Filter" button from GS Mobile Browse page
		@browser.store_pickup_search_button.click	
		
		#Click "Availability" to expand
		@browser.availability_slide.click
		
		#Click the "PickUp@Store" radio button
		@browser.availability_pickup_store[2].click
		sleep 2
		
		#Then Click "Submit" button at the bottom
		@browser.submit_button.click	
		@browser.wait_for_landing_page_load
		sleep 2
		
		#Alternative way for getting a product available in store near our Location
		@browser.open("#{@start_page}#{@product_url}")

		#Validate if "PICKUP@STORE" button exists / Click "PICKUP@STORE" button
		@browser.new_store_pickup_hops_button.should_exist
		@browser.new_store_pickup_hops_button.click
		@browser.wait_for_landing_page_load
		
		#Click the "Store Pickup" button @ https://m.qa.gamestop.com/PickUpAtStore/101480/32.9033485/-97.0880734
		@browser.store_pickup_hops_checkout.click
		@browser.wait_for_landing_page_load
		
		#Enter Hops User Information 
		@browser.first_name_hops_field.value = @hops_first_name
		@browser.last_name_hops_field.value = @hops_last_name
		@browser.email_address_hops_field.value = @hops_email if @browser.email_address_hops_field.value == ""
		@browser.confirm_email_address_hops_field.value = @hops_email if @browser.confirm_email_address_hops_field.value == ""
		@browser.phone_number_hops_field.value = @hops_phone
				
		#Validate if user is PUR || NonPUR
		if @browser.powerup_number_hops_field.value == ""
			@browser.not_a_member_hops.click
			@browser.credit_card_selector_hops.should_exist
			@browser.credit_card_number_hops_field.should_exist
			@browser.credit_card_selector_hops.value = @cc_type
			@browser.credit_card_number_hops_field.value = @cc_number
			@browser.credit_card_selector_hops.value.should_not == ""
			@browser.credit_card_number_hops_field.value.should_not == ""
		else
			@browser.powerup_number_hops_field.should_exist
			@browser.powerup_number_hops_field.value.should_not == ""
		end
	
		#Click the "Finish" button
		@browser.finish_hops_button.click
		sleep 5
		
		#Validate if Hops Request is successful
		@expected_result = true
		actual_result = (@browser.submit_success_section.call("style.display").eql?("block") ? true : false )
		actual_result.should == @expected_result
	end
	
	
   it "GS Mobile RequestHops as AuthenticatedUser when ShowHopsPURandCC is FALSE" do
		@browser.open(@start_page)
		@browser.view_cart_button.click
		@browser.log_out_link.click if @browser.log_out_link.exists == true
		@browser.log_in_link.click
		@browser.log_into_my_account_button.click
		@browser.enter_login_credentials(account_login_parameter, account_password_parameter)
		@browser.user_login_button.click
		@browser.empty_new_cart
		@browser.continue_shopping_button.click

		@browser.store_pickup_search_button.click	
		@browser.availability_slide.click
		@browser.availability_pickup_store[2].click
		sleep 2
		@browser.submit_button.click	
		@browser.wait_for_landing_page_load
		sleep 2
		
		#Alternative way for getting a product available in store near our Location
		@browser.open("#{@start_page}#{@product_url}")

		#Validate if "PICKUP@STORE" button exists / Click "PICKUP@STORE" button
		@browser.new_store_pickup_hops_button.should_exist
		@browser.new_store_pickup_hops_button.click
		@browser.wait_for_landing_page_load
		
		#Click the "Store Pickup" button @ https://m.qa.gamestop.com/PickUpAtStore/101480/32.9033485/-97.0880734
		@browser.store_pickup_hops_checkout.click
		@browser.wait_for_landing_page_load
		
		#Enter Hops User Information 
		@browser.first_name_hops_field.value = @hops_first_name
		@browser.last_name_hops_field.value = @hops_last_name
		@browser.email_address_hops_field.value = @hops_email if @browser.email_address_hops_field.value == ""
		@browser.confirm_email_address_hops_field.value = @hops_email if @browser.confirm_email_address_hops_field.value == ""
		@browser.phone_number_hops_field.value = @hops_phone
				
		#Validate if PUR and CC options exist
		@browser.powerup_number_hops_field.should_not_exist
		
		#Click the "Finish" button
		@browser.finish_hops_button.click
		sleep 5
		
		#Validate if Hops Request is successful
		@expected_result = true
		actual_result = (@browser.submit_success_section.call("style.display").eql?("block") ? true : false )
		actual_result.should == @expected_result
	end

	
	def initialize_csv_params
		csv = QACSV.new(csv_filename_parameter)
		@row = csv.find_row_by_name(csv_range_parameter)
		@power_up_number = @row.find_value_by_name("powerup_number")
		@cc_type = @row.find_value_by_name("cc_type")
		@cc_number = @row.find_value_by_name("cc_number")
		@hops_first_name = @row.find_value_by_name("hops_first_name")
		@hops_last_name = @row.find_value_by_name("hops_last_name")
		@hops_email = @row.find_value_by_name("hops_email")
		@hops_zip= @row.find_value_by_name("hops_zip")
		@hops_phone = @row.find_value_by_name("hops_phone")
	end
	
	def get_sku_and_store_data	
		@store_numbers = @stores_in_range.to_s
		
		store_query = "SELECT top 100 
							a.[StoreID] as storeid, 
							a.[QtyOnHand] as onhand, 
							d.[ProductID] as productid, 
							d.[Sku] as sku, 
							f.[HopsEnabled] as hopsenabled, 
							f.[StoreNumber] as storenumber
						FROM [StoreInformation].[dbo].[StoreInventory] a with (NOLOCK) 
								INNER JOIN [StoreInformation].[dbo].[Product] d on a.ProductID = d.ProductID 
								INNER JOIN [StoreInformation].[dbo].[Store] f on a.StoreID = f.StoreID
						WHERE a.QtyOnHand > 3 and  f.HopsEnabled = 1 and f.StoreNumber in (#{@store_numbers})
						ORDER BY NEWID()"
		
		
		server = "GV1HQDDB50SQL03.testgs.pvt\\INST03"
		database = "StoreInformation"
		dbuser = "s_dbtfstest"
		dbpass = "Gamestop.1"
		
		$tracer.trace("#{store_query}")
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
				get_products_rsp = @catalog_svc.perform_get_product_by_sku(@catalog_svc_version, @session_id, sku)
				$tracer.trace("GET PRODUCTS RESPONSE")
				catalog_get_product_data = get_products_rsp.http_body.find_tag("product").at(0)
				availability = catalog_get_product_data.availability.content.to_s
				can_do_hops = catalog_get_product_data.is_in_store_pickup_for_hops.content.to_s
					$tracer.trace("THIS IS THE FLAG FOR CAN DO HOPS: #{can_do_hops} FOR #{sku}")
					$tracer.trace("THIS IS THE AVAILABILITY: #{availability} FOR #{sku}")
					$tracer.trace("\tTHIS IS THE INDEX #{ind}\n\n")
				@sku = sku.to_s
				@store = store.to_s
			rescue Exception => ex
				@sku = sku.to_s
				@store = store.to_s
				$tracer.trace("THIS IS THE INDEX #{ind} OF #{ind_len}")
				$tracer.trace("CRITERIA NOT MET, KEEP LOOKING FOR YOU DROIDS")
			end
			break if (can_do_hops == "true" && availability == "A")
		end
	end

end
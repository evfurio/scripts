## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\GSmobile_guest_checkout_HOPS_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\mobile_dataset.csv  --range TFS70172  --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()
$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
USER_AGENT_STR = "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"


describe "GS Mobile HOPS in Checkout as Guest" do

  before(:all) do
    if browser_type_parameter == "chrome"
      @browser = WebBrowser.new(browser_type_parameter, true)
    else
      @browser = WebBrowser.new(browser_type_parameter)
    end
		@browser.delete_internet_files(browser_type_parameter)
		$options.default_timeout = 10_000
		$snapshots.setup(@browser, :all)
		
		#Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @account_svc, @account_svc_version = $global_functions.account_svc
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
    @store_search_svc, @store_search_svc_version = $global_functions.storesearch_svc

    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9090"
    $proxy = @browser.start_proxy_server(9090)
    @browser.set_user_agent_header($proxy, USER_AGENT_STR)
  end

  before(:each) do
		@browser.cookie.all.delete
		@session_id = generate_guid
		@radius_in_km = "20"
		@store_addresses = @store_search_svc.perform_get_all_stores_in_range(@session_id, "GS_US", "en-US", @store_search_svc_version, @params["billing_zip"], @radius_in_km)
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
		catalog_rsp = @catalog_svc.perform_get_product_by_sku(@catalog_svc_version, @session_id, @sku)
		esrbrating = catalog_rsp.http_body.find_tag("product").at(0).esrb_rating.content.to_s
		condition = catalog_rsp.http_body.find_tag("product").at(0).condition.content.to_s
		@product_url = "/Catalog/Sku/#{@sku}"
		
		@matured_product = esrbrating.eql?("M") ? true : false
		@physical_product = condition.eql?("Digital") ? false : true
		@browser.open(@start_page)
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.stop_proxy_server($proxy)
    @browser.close_all()
  end
    
   it "#{$tc_id} #{$tc_desc}" do
		@browser.view_cart_button.click
		@browser.wait_for_landing_page_load
		@browser.empty_new_cart   
		@browser.continue_shopping_button.click
		@browser.wait_for_landing_page_load
		@browser.store_pickup_search_button.click	
		@browser.wait_for_landing_page_load
		@browser.availability_slide.click
		@browser.wait_for_landing_page_load
		@browser.gsm_filter_submit_button.click	
		@browser.wait_for_landing_page_load

		$tracer.trace("Get Products")
		@browser.open("#{@start_page}#{@product_url}")		
		if @browser.product_price_list.at(0).add_to_cart_button.innerText == 'Add to Cart'
			@browser.product_price_list.at(0).add_to_cart_button.click
		else
			@browser.product_price_list.at(1).add_to_cart_button.click
		end
		@browser.wait_for_landing_page_load
		
		@browser.promotion_code_field.value = @params["promo_code"]
		@browser.promotion_code_apply_button.click
		@browser.wait_for_landing_page_load
	
		unless @params["continue_checkout"]
			$tracer.trace("This will not proceed with Checkout")
			@browser.update_products_quantity()
			@browser.add_products_to_cart(@results_from_file, @start_page, @params)
			@browser.validate_pur(@params)
		else
		
			if @params["use_paypal_at_cart"]
        @browser.paypal_chkout_button.click
        $tracer.trace("Log Into PayPal")
        @browser.retry_until_found(lambda{@browser.paypal_test_acct_login_field.exists != false}, 10)
        @browser.paypal_test_acct_login_field.value = "davidturner@gamestop.com"
				@browser.paypal_test_acct_password_field.value = "4baV239056"
				@browser.paypal_test_acct_login_button.click
				sleep 3
			else		
				$tracer.trace("Continue Secure Checkout")
				@browser.continue_checkout_button_handling.click
				@browser.wait_for_landing_page_load
				$tracer.trace("How Do You Want To Checkout? screen")
				@browser.buy_as_guest_button.click
				@browser.wait_for_landing_page_load
			end

			if @params["use_paypal_at_cart"]
				$tracer.trace("Continue through PayPal")
        @browser.retry_until_found(lambda{@browser.paypal_test_acct_continue_button.exists != false}, 10)
				@browser.paypal_test_acct_continue_button.click
				sleep 3
				@browser.seventeen_or_older_button.click if @matured_product

				#Handling options only apply to physical products
				if @physical_product
					$tracer.trace("Handling Options screen")				
					@browser.chkout_handling_options_label.should_exist
					@browser.shipping_handling_option_label.find.input[0].click
					@browser.chkout_handling_method_buttons.value.should include "Online coupons and PayPal can't be used." 
					@browser.wait_for_landing_page_load
				end
			else
				$tracer.trace("Age Check screen")
				if @matured_product
					@browser.seventeen_or_older_button.click
					@browser.wait_for_landing_page_load
				end
				
				if @physical_product 
					$tracer.trace("Shipping Address screen")
					@browser.show_order_summary_link.click
					
					@browser.enter_address_plus_email(@params["first_name"], @params["last_name"], @params["shipping_line1"], @params["shipping_city"], @params["shipping_state"], @params["shipping_zip"], @params["shipping_phone"], @params["shipping_email"]) 
									
					if @params["billing_address_same_as_shipping"]
						@browser.chkout_same_address_checkbox.checked = true
					else
						$tracer.trace("Billing Address screen")
						@browser.continue_checkout_button_handling.click
						@browser.wait_for_landing_page_load
						@browser.show_order_summary_link.click
						@browser.enter_billship_address(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"])           
					end
					@browser.continue_checkout_button_handling.click
					@browser.wait_for_landing_page_load
					
					$tracer.trace("Handling Options screen")
					@browser.show_order_summary_link.click
					@browser.chkout_gift_message_field.value = "Gift Message Box should only contain 50 characters"
					@browser.chkout_gift_message_field.value.length.should_not > 50
					
					@browser.chkout_handling_options_label.should_exist
					@browser.shipping_handling_option_label.find.input[0].click
					@browser.chkout_handling_method_buttons.value.should include "Online coupons and PayPal can't be used." if @params["promo_code"] != ''
					@browser.wait_for_landing_page_load
				end
				
				sleep 3
				is_visible_find_store_button = (@browser.hops_find_store_button.call("style.display").eql?("none") ? false : true )
				is_visible_find_store_button.should == true
				@browser.hops_find_store_button.click
				@browser.wait_for_landing_page_load
				
				# There's an instance that it's redirecting to store list. Keeping an eye on it!
				@browser.retry_until_found(lambda{@browser.mgs_hops_search_zip.exists != false}, 10)
				@browser.mgs_hops_search_zip.should_exist
				@browser.mgs_hops_search_zip.value = '76051'
				@browser.send_keys(KeyCodes::KEY_RETURN)
				
				@browser.mgs_hops_stores_section.should_exist
				@browser.retry_until_found(lambda{@browser.mgs_hops_store_list.at(0).exists != false}, 10)
				@browser.mgs_hops_store_list.at(0).click
				@browser.wait_for_landing_page_load
				if @browser.mgs_hops_store_list.at(0).hold_new_button.exists == true
					@browser.mgs_hops_store_list.at(0).hold_new_button.click
				else
					@browser.mgs_hops_store_list.at(0).hold_pre_owned_button.click
				end
				@browser.wait_for_landing_page_load
				
				#Enter Hops User Information 
				@browser.enter_personal_info_plus_email(@params["first_name"], @params["last_name"], @params["shipping_email"], @params["shipping_phone"])
				@browser.wait_for_landing_page_load
				@browser.mgs_hops_continue_button.click
				@browser.wait_for_landing_page_load
				@browser.mgs_hops_confirm_button.click
				sleep 3
				
				#Validate if Hops Request is successful
				$tracer.trace("Hops Request is successful.")
				@browser.mgs_hops_request_sent_message.should be_visible
				@browser.mgs_hops_request_sent_message.innerText.should == 'Your Hold Request Has Been Sent!'
				
				@browser.mgs_hops_order_confirm_message.should be_visible
				@browser.mgs_hops_order_confirm_message.innerText.should == 'An email will be sent when your product is ready'
			end		
		end
	end
		
	def get_sku_and_store_data	
		@store_numbers = @stores_in_range.to_s
		
		store_query = "SELECT top 100 a.[StoreID] as storeid, a.[QtyOnHand] as onhand, d.[ProductID] as productid, d.[Sku] as sku, f.[HopsEnabled] as hopsenabled, f.[StoreNumber] as storenumber
									FROM [StoreInformation].[dbo].[StoreInventory] a with (NOLOCK) 
									INNER JOIN [StoreInformation].[dbo].[Product] d on a.ProductID = d.ProductID 
									INNER JOIN [StoreInformation].[dbo].[Store] f on a.StoreID = f.StoreID
									WHERE a.QtyOnHand > 10 and  f.HopsEnabled = 1 and f.StoreNumber in (#{@store_numbers})
									ORDER BY NEWID()"
 			
		server = "GV1HQDDB50SQL03.testgs.pvt\\INST03"
		database = "StoreInformation"
		
		$tracer.trace("#{store_query}")
		@db = DbManager.new(server, database)
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
				@sku = sku.to_s
				@store = store.to_s
      rescue Exception => ex
        @sku = sku.to_s
        @store = store.to_s
        $tracer.trace("THIS IS THE INDEX #{i} OF #{ind_len}")
        $tracer.trace("CRITERIA NOT MET, KEEP LOOKING FOR YOU DROIDS")
      end
       break if (can_do_hops == "true" && availability == "A")
		end
	end
	
end
# USAGE NOTES
# Checkout as an Authenitcated User
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_HOPS_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv  --range TFS70734  --browser chrome  --or


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "HOPS in Checkout as Authenticated User" do
  before(:all) do
    @browser = WebBrowser.new(browser_type_parameter)
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
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
	end

  before(:each) do
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
		
		$tracer.trace("Get products")
    get_sku_and_store_data		
		catalog_rsp = @catalog_svc.perform_get_product_by_sku(@catalog_svc_version, @session_id, @sku)
		esrbrating = catalog_rsp.http_body.find_tag("product").at(0).esrb_rating.content.to_s
		condition = catalog_rsp.http_body.find_tag("product").at(0).condition.content.to_s
		@product_url = catalog_rsp.http_body.find_tag("product").at(0).url.content
		
		@matured_product = esrbrating.eql?("M") ? true : false
		@physical_product = condition.eql?("Digital") ? false : true
		@browser.open(@start_page)
		
		@open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
		@cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
		@cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)
    
		if @params["load_ship_addr_from_profile"] || @params["load_bill_addr_from_profile"]
      @shipping_addresses, @billing_address = @profile_svc.perform_get_addresses(@open_id, @session_id, 'GS_US', @profile_svc_version)
		end
	end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    @browser.log_in_link.click
    @browser.log_in(@login, @password)
    @browser.empty_new_cart 
		sleep 2

		@browser.open("#{@start_page}#{@product_url}")

    @browser.buy_first_panel.add_to_cart_button.exists == true ? @browser.buy_first_panel.add_to_cart_button.click : @browser.buy_second_panel.add_to_cart_button.click
    @browser.wait_for_landing_page_load
    @browser.upsell_checkout_button.click if @browser.upsell_modal_popup.exists == true
    @browser.wait_for_landing_page_load
				
		$tracer.trace("Check subtotal and total")
		subtotal = @browser.check_cart_subtotal_and_discount(@params)
		@browser.validate_certona_recommendation if @params['validate_certona_cart'] == true

		$tracer.trace("THIS IS THE ENTRY TO PAYPAL IN THE CART")
		if @params["use_paypal_at_cart"]
			@browser.paypal_chkout_button.click
			# Log into PayPal sandbox
			$tracer.trace("Log Into PayPal")
			@browser.paypal_sandbox_login
			sleep 3
		else
			@browser.continue_checkout_button.click
			@browser.wait_for_landing_page_load
		end

    # Mature or Adult Audience confirmation page
    if @matured_product || @matured_product_svc
      @browser.handle_mature_product_screen(@params) unless @params["use_paypal_at_cart"]
    end

    if @params["use_paypal_at_cart"]
      $tracer.trace("Continue through PayPal")
      @browser.paypal_test_acct_continue_button.click
			sleep 3
      @browser.handle_mature_product_screen(@params) if @matured_product
    else
			if @physical_product
        @browser.wait_for_landing_page_load

        if @params["load_ship_addr_from_profile"]
          $tracer.trace("Load Shipping Address Info From Profile.")
          @browser.check_checkout_shipping_fields_exist
        else
          $tracer.trace("Enter Shipping Address Info.")
          @browser.fill_out_shipping_form(@params)
        end
				@browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)

        # Billing Address and shipping address same
        if @params["billing_address_same_as_shipping"]
          @browser.same_address_checkbox.click
          @browser.continue_checkout_button.click
        else
          @browser.continue_checkout_button.click
          @browser.wait_for_landing_page_load
          if @params["load_bill_addr_from_profile"]
            $tracer.trace("Load Billing Address Info From Profile.")
            @browser.check_checkout_billing_fields_exist
          else
            $tracer.trace("Enter Billing Address Info.")
            sleep 3
            @browser.fill_out_billing_form(@params)
          end
          @browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
          @browser.continue_checkout_button.click
          @browser.wait_for_landing_page_load
        end
      end
		end
		
		$tracer.trace("Handling Options")
		@browser.handling_method_buttons.value = @params["shipping_option"]
		if @params["promo_code_number"].empty? == false or @params["use_paypal_at_cart"] == true
			@browser.handling_method_buttons.value.should include "Find and purchase your item in a store today!"
			@browser.handling_method_buttons.value.should include "Online coupons and PayPal can't be used."
		end
		@browser.wait_for_landing_page_load
			
    @browser.hops_find_store_button.click
		@browser.wait_for_landing_page_load
  
		if @browser.hops_no_stores_popup.exists == true
			popup_visible = (@browser.hops_no_stores_popup.call("style.display").eql?("none") ? true : false )
			unless popup_visible == true
				@browser.hops_no_stores_button.click
				@browser.wait_for_landing_page_load
			end
			# This will remove the default value in the textbox so there won't be instances where hops_zip is being joined to the default value.
			@browser.hops_zip_code_search_field.value = ''
			@browser.hops_zip_code_search_field.value = @params['hops_zip']
			@browser.wait_for_landing_page_load
			@browser.hops_zip_code_search_button.click
			sleep 5
			
			a = 0
			while a < @browser.hops_store_list.length
				item = @browser.hops_store_list.at(a)
				item.pickup_at_store_button.should_exist
				if a == @browser.hops_store_list.length
					item.pickup_at_store_button.click
				end
				a = a + 1
			end
		end
		
		@browser.first_name_field.value = @params['bill_first_name']
    @browser.last_name_field.value = @params['bill_last_name']
    @browser.email_address_field.value = @params['bill_email']
    @browser.confirm_email_address_field.value = @params['bill_email']
    @browser.phone_number_field.value = @params['bill_phone']
    
		@browser.hops_finish_button.click
    @browser.wait_for_landing_page_load

		if @browser.hops_alternate_store_popup_panel.exists
			@browser.hops_alternate_store_popup_panel.set_alternate_store_button.click
			@browser.wait_for_landing_page_load
    end

    @browser.retry_until_found(lambda{@browser.hops_accepted_page_title.exists != false}, 10)
    @browser.hops_accepted_page_title.should_exist
    @browser.hops_accepted_page_message.inner_text.should start_with "Sweet! We've sent an email to"
		sleep 5
		
		# Validate CART
		@browser.cart_badge.innerText.should == ""
		@browser.my_cart_button.click
		@browser.wait_for_landing_page_load
		@browser.cart_list.length.should == 0
	
  end

	
	def get_sku_and_store_data
    store_query = "SELECT top 100 a.[StoreID] as storeid, a.[QtyOnHand] as onhand, d.[ProductID] as productid, d.[Sku] as sku, f.[HopsEnabled] as hopsenabled, f.[StoreNumber] as storenumber
										FROM [StoreInformation].[dbo].[StoreInventory] a with (NOLOCK) 
										INNER JOIN [StoreInformation].[dbo].[Product] d on a.ProductID = d.ProductID 
										INNER JOIN [StoreInformation].[dbo].[Store] f on a.StoreID = f.StoreID
										WHERE a.QtyOnHand > 2 and  f.HopsEnabled = 1 ORDER BY NEWID()"

		server = "GV1HQDDB50SQL03.testgs.pvt\\INST03"
    database = "StoreInformation"
		
		@db = DbManager.new(server, database)
    sql2 = store_query
    @results_from_file = @db.exec_sql("#{sql2}")

    #@sku_match needs to be an array from the list of skus we get back from store information
    sku_match = []
    index = 0
    @results_from_file.each_with_index do |variant, i|
      store = @results_from_file.at(index).storenumber
      sku_match.push(variant.sku, store)
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
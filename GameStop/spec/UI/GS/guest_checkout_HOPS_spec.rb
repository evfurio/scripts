##USAGE NOTES
##
##d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_HOPS_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS70733  --browser chrome  --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "HOPS In Checkout as Guest" do
  before(:all) do
    @browser = GameStopBrowser.new(browser_type_parameter)
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
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    @browser.open("#{@start_page}#{@product_url}")

    if @browser.buy_first_panel.add_to_cart_button.exists == true
      @browser.buy_first_panel.check_availability_lnk.exists == true ? @browser.buy_first_panel.add_to_cart_button.click : @browser.buy_second_panel.add_to_cart_button.click
    else
      @browser.buy_second_panel.add_to_cart_button.click
    end

    @browser.wait_for_landing_page_load
    @browser.upsell_checkout_button.click if @browser.upsell_modal_popup.exists == true
    @browser.wait_for_landing_page_load
		
		$tracer.trace("Check subtotal and total")
    subtotal = @browser.check_cart_subtotal_and_discount(@params)
		@browser.validate_certona_recommendation if @params['validate_certona_cart'] == true
    
		 if @params["use_paypal_at_cart"]
      @browser.paypal_chkout_button.click
      # Log into PayPal sandbox
      $tracer.trace("Log Into PayPal")
      @browser.paypal_sandbox_login
    else
      @browser.continue_checkout_button.click
      $tracer.trace("Click Checkout As Guest")
      @browser.chkoutbuy_as_guest_button.click
    end

    # Mature or Adult Audience confirmation page
    if @matured_product
			@browser.handle_mature_product_screen(@params) unless @params["use_paypal_at_cart"]
		end
		
		if @params["use_paypal_at_cart"]
      $tracer.trace("Continue through PayPal")
      @browser.retry_until_found(lambda{@browser.paypal_test_acct_continue_button.exists != false}, 10)
      @browser.paypal_test_acct_continue_button.click
      sleep 3
			@browser.handle_mature_product_screen(@params) if @matured_product
			@browser.wait_for_landing_page_load
    else
			if @physical_product
				@browser.wait_for_landing_page_load
				$tracer.trace("Fill Out Shipping Address Form")
				@browser.fill_out_shipping_form(@params)
				@browser.wait_for_landing_page_load

				# Billing Address and shipping address same
				if @params["billing_address_same_as_shipping"]
					@browser.same_address_checkbox.click
					@browser.continue_checkout_button.click
				else
					@browser.continue_checkout_button.click
					sleep 3
					$tracer.trace("Billing Address Info (Physical).")
					@browser.fill_out_billing_form(@params)
					@browser.continue_checkout_button.click
				end
				@browser.wait_for_landing_page_load
			end
		end
		
		$tracer.trace("Handling Options")
		@browser.handling_method_buttons.value = @params["shipping_option"]
		if @params["promo_code_number"] != "" || @params["use_paypal_at_cart"]
			@browser.handling_method_buttons.value.should include "Find and purchase your item in a store today!"
			@browser.handling_method_buttons.value.should include "Online coupons and PayPal can't be used."
		end
		
		# Assert: HOPS More Info
		@browser.handling_method_buttons.hops_more_info.click
		@browser.wait_for_landing_page_load
		is_visible = (@browser.hops_more_info_list.call("style.display").eql?("block") ? true : false )
    is_visible.should == true
		@browser.hops_more_info_list.li[0].innerText.should include "1.  Find your item in a store and submit your request.  You will receive an email from the store when your order is available!"
		@browser.hops_more_info_list.li[2].innerText.should include "2.  You will not be charged for your item(s) until you pay in-store."
		@browser.hops_more_info_list.li[4].innerText.should include "3.  PayPal and/or online discount coupons cannot be used for Pick Up At Store orders."
		@browser.hops_more_info_list.li[6].innerText.should include "4.  Product availability subject to final store approval."
		@browser.hops_more_info_list.li[8].innerText.should include "5.  Orders placed after store closing will be worked the following business day."
		@browser.hops_more_info_list.li[10].innerText.should include "6.  Remember we buy your used games and more!  Bring trades to save money!"
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Availability section in Handling page should be empty.")
		is_visible = (@browser.hops_availability_link.call("style.display").eql?("none") ? false : true )
		is_visible.should == false
    @browser.hops_find_store_button.click
		@browser.wait_for_landing_page_load
		
		popup_visible = (@browser.hops_no_stores_popup.call("style.display").eql?("none") ? true : false )
		unless popup_visible == true
      @browser.hops_no_stores_button.click
      @browser.wait_for_landing_page_load
    end
		@browser.hops_zip_code_search_field.value = ''
		@browser.hops_zip_code_search_field.value = @params['ship_zip']
		@browser.wait_for_landing_page_load
    @browser.hops_zip_code_search_button.click

    @browser.retry_until_found(lambda{@browser.hops_store_list.exists != false}, 10)
    @browser.hops_store_list.length.should > 0
    @browser.hops_store_list.at(0).pickup_at_store_button.click

    @browser.retry_until_found(lambda{@browser.first_name_field.exists != false}, 10)
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

    @browser.retry_until_found(lambda{@browser.hops_accepted_page_h1.exists != false}, 10)
    @browser.hops_accepted_page_h1.should_exist
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

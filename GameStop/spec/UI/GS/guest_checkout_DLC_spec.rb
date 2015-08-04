
#Author### - dturner
#Modified  - Robert Ramirez
# 1/7/2012, New checkout script utilizting ATS tags and logic
# 1/8/2012, Assumptions:  Pre-existing user/login with biling and shipping addresses
# 1/29/2012, DT - Broke Authenicated and Guest user paths into their own test methods to reduce conditional logic complexities
# 
# USAGE NOTES

# Checkout as Guest
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_DLC_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48603  --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Guest Checkout DLC" do
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
		#uses the sku(s) returned from the SQL query to get product details information from the catalog service
		$tracer.trace("Get products")
	  @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
		@browser.open(@start_page)
  end

  after(:each) do
    @browser.return_current_url
  end

	after(:all) do
		@browser.close_all()
	end
  
	it "#{$tc_id} #{$tc_desc}" do
	
		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, '', @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)

    @browser.add_powerup_rewards_number(@params)
		$tracer.trace("Check subtotal and total")
		subtotal = @browser.check_cart_subtotal_and_discount(@params)
	  
		@browser.paypal_chkout_button.should_exist
    @browser.validate_certona_recommendation if @params['validate_certona_cart'] == true
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		@browser.chkoutbuy_as_guest_button.click

		# Mature or Adult Audience confirmation page
		if @matured_product
			@browser.handle_mature_product_screen(@params)
		end
			
		# Check for digital product alone - no shipping page will exists	
		@browser.wait_for_landing_page_load
				
		#Sign up for Weekly ad, offers and more
		@browser.chkoutweeklyadoffers_label.click if @params["sign_up_weekly_ads"]
		
		# Billing Address and shipping address same
		$tracer.trace("Enter Billing Address Info.")
		@browser.fill_out_billing_form(@params)
		@browser.chkoutpurchaseemail_label.value = @params["bill_email"]
		@browser.chkoutconfirmemail_bill_to_label.value = @params["bill_email"]
	  @browser.continue_checkout_button.click
				
		#Checkout - Payment Options
		$tracer.trace("Payment Options")
		@browser.wait_for_landing_page_load
		
		@browser.order_summary_subtotal.should_exist
		@browser.order_summary_tax.should_exist
		@browser.handling_with_discount_amount.should_exist
		@browser.handling_with_discount_amount.innerText.should == "FREE!"
		@browser.order_summary_total.should_exist
		@browser.paypal_payment_selector.should_exist
	  
		order_summary_subtotal = money_string_to_decimal(@browser.order_summary_subtotal.innerText) 
		order_summary_tax = money_string_to_decimal(@browser.order_summary_tax.innerText) 
		order_summary_total = money_string_to_decimal(@browser.order_summary_total.innerText)
	  
		total = order_summary_subtotal + order_summary_tax 
		order_summary_total.should == total
		
		if @params["svs"].empty?
		    $tracer.trace("Enter Credit Card Info")
		    @browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])
		else
		    $tracer.trace("Pay with Gift Card")
		    svs_balance = @purchase_order_svc.perform_get_svs_balance(@params["svs"], @params["pin"], @session_id, @purchase_order_svc_version)
				@browser.enter_svs_info(@params["svs"], @params["pin"], svs_balance, order_summary_total)
				sleep 5
    end 
		
		#Submit the order only if the value of submit_order_flag from csv file is 'true'
		if @params["submit_order_flag"]
			order_num = @browser.submit_and_confirm_order(@params, @condition)
			@browser.confirm_order_details_panel.ordered_product_label.should_exist
		  @browser.confirm_order_details_panel.ordered_availability_label.should_exist
			@browser.check_confirmation_page_subtotal(subtotal)
			  
			@browser.confirm_billing_address_panel.confirm_billing_first_name_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_last_name_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_addr1_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_city_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_state_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_zip_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_country_label.should_exist
		  
			@browser.confirm_payment_panel.confirm_payment_type_label.should_exist
			@browser.confirm_payment_panel.confirm_payment_number_label.should_exist
			
			$tracer.trace("Call purchase order service to get order information")
      get_purchase_order_by_tracking_number_rsp = @purchase_order_svc.perform_get_placed_order(@session_id, "GS_US", "en-US", order_num, @purchase_order_svc_version)

			#get_purchase_order_by_tracking_number_rsp =  @purchase_order_svc.perform_get_purchase_order_by_tracking_number(@session_id, "GS_US", "en-US", order_num, @purchase_order_svc_version)

			$tracer.trace(get_purchase_order_by_tracking_number_rsp.http_body.formatted_xml) 
			get_purchase_order_by_tracking_number_rsp.code.should == 200
			
			
			customer_billing = get_purchase_order_by_tracking_number_rsp.http_body.find_tag("customer").bill_to
        
				customer_billing.city.content.should == @params["bill_city"]
				customer_billing.line1.content.should == @params["bill_addr1"]
				customer_billing.postal_code.content.should == @params["bill_zip"]
				customer_billing.state.content.should == @browser.state_abbriviation(@params["bill_state"])
				customer_billing.first_name.content.should == @params["bill_first_name"]
				customer_billing.last_name.content.should == @params["bill_last_name"]
		
	
			shipment = get_purchase_order_by_tracking_number_rsp.http_body.find_tag("shipments").shipment[0]
			
				shipment.ship_to.city.content.upcase.should == @params["ship_city"].upcase
				shipment.ship_to.line1.content.upcase.should  == @params["ship_addr1"].upcase
				shipment.ship_to.postal_code.content.should == @params["ship_zip"].upcase
				shipment.ship_to.state.content.should == @browser.state_abbriviation(@params["ship_state"])
				shipment.ship_to.first_name.content.should == @params["ship_first_name"]
				shipment.ship_to.last_name.content.should == @params["ship_last_name"]
			
		end
	end
  
end

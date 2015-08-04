#USAGE - This script is for testing authenticated user scenarios that require purchasing of products with AOW.
#############################################################################################################################################################################################################################################################
# d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_AOW_spec.rb  --login qa_ui_testing1@4test.com --password T3sting --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range AOW01 --browser chrome  --or #
#############################################################################################################################################################################################################################################################

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Authenticated User Checkout Product with AOW" do
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
    @shipping_svc, @shipping_svc_version = $global_functions.shipping_svc
  end

	before(:each) do
    @browser.delete_all_cookies_and_verify
		@session_id = generate_guid
	end

  after(:each) do
    @browser.return_current_url
  end

	after(:all) do
		@browser.close_all()
	end
  
	it "#{$tc_id} #{$tc_desc}" do
		$tracer.trace(" *** Clear Cart *** ")
    @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
		@cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
    @cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)
		
		@product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
		
		@browser.open(@start_page)
		@browser.log_in_link.click
    @browser.log_in(@login, @password)
    @browser.empty_new_cart
    sleep 3
		
		# Temporary created a standalone function b/c the sku being used for AOW fails on velocity check
		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, @cart_id, @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
		
		@browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
		@browser.add_powerup_rewards_number(@params)
    $tracer.trace("Check subtotal and total")
    subtotal = @browser.check_cart_subtotal_and_discount(@params)
    @browser.wait_for_landing_page_load
		@browser.paypal_chkout_button.should_exist
    @browser.continue_checkout_button.click
    @browser.wait_for_landing_page_load
		
		if @physical_product == true
			$tracer.trace("Fill Out Shipping Address Form")
			@browser.fill_out_shipping_form(@params)
			# Billing Address and shipping address same
			if @params["billing_address_same_as_shipping"]
				@browser.same_address_checkbox.click
				@browser.continue_checkout_button.click
			else
				@browser.continue_checkout_button.click
				@browser.wait_for_landing_page_load
				$tracer.trace("Billing Address Info (Physical).")
				@browser.fill_out_billing_form(@params)
				@browser.continue_checkout_button.click
			end
		else
			$tracer.trace("Billing Address Info (Digital).")
			@browser.fill_out_billing_form(@params)
			@browser.chkoutpurchaseemail_label.value = @params["bill_email"]
			@browser.continue_checkout_button.click
		end
		
		$tracer.trace("Handling Options")
		@browser.wait_for_landing_page_load
		if @params["add_free_gift"] == true
			@browser.gift_card_message_checkbox.click
			@browser.create_gift_card_message.value = @params["gift_msg"]
			gift_message = @browser.create_gift_card_message.value
		end
		@browser.continue_checkout_button.click			
		
		#Checkout - Payment Options
		$tracer.trace("Payment Options")
		@browser.wait_for_landing_page_load
		
		@browser.preview_order_button.should_exist
		if @params["add_free_gift"] == true
			@browser.preview_order_button.click
			# Assert GiftCard message created from Handling Options page against the GiftCard message displayed in Payment page.
			@browser.gift_card_message.innerText.should == gift_message
		end
		
		order_summary_total = money_string_to_decimal(@browser.order_summary_total.innerText)
		@browser.paypal_payment_selector.should_exist

		@browser.wallet_label.value = "-- Select a Card--" if @browser.wallet_label.exists
		if @params["svs"].empty?
			$tracer.trace("Enter Credit Card Info")
			@browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])
		else
			$tracer.trace("Pay with Gift Card")
			svs_balance = @purchase_order_svc.perform_get_svs_balance(@params["svs"], @params["pin"], @session_id, @purchase_order_svc_version)
			@browser.enter_svs_info(@params["svs"], @params["pin"], svs_balance, order_summary_total)
			sleep 1
		end

		#Submit the order only if the value of submit_order_flag from csv file is 'true'
		if @params["submit_order_flag"]
			$tracer.trace("Submitted Order")			
			@browser.submit_and_confirm_order(@params, 'GiftCard')
			@browser.check_confirmation_page_subtotal(subtotal)
			
			@browser.confirm_order_note.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_first_name_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_last_name_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_addr1_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_city_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_state_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_zip_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_country_label.should_exist

			@browser.confirm_payment_panel.confirm_payment_type_label.should_exist
			@browser.confirm_payment_panel.confirm_payment_number_label.should_exist 
		end

	end		
end
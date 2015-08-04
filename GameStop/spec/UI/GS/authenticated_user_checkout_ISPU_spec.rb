# USAGE - Authenticated checkout scencario for ISPU, aka Web Reservations, aka Pre-order PickUp@Store
# TODO - Consolidate functionality into base checkout script for both guest and authenticated
################################################################################################################################################################################################
# d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_ISPU_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48617 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --browser chrome  --or #
################################################################################################################################################################################################
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()
#populates the test method "it 'should test ISPU in checkout' do " with values from the CSV
$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Authenticated User Checkout In-Store Pick-Up" do
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
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
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
    @browser.open(@start_page)
    $tracer.trace("Get products from database and check for product velocity limits")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id) unless @params["renew_pur"]
		$tracer.trace(" *** Clear Authetnicated User Cart *** ")
    @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
    @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
		@cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)
		if @params["load_ship_addr_from_profile"] || @params["load_bill_addr_from_profile"]
      @shipping_addresses, @billing_address = @profile_svc.perform_get_addresses(@open_id, @session_id, 'GS_US', @profile_svc_version)
		end

    @browser.log_in_link.click
    @browser.log_in(@login, @password)
		sleep 5
		
    $tracer.trace("Add Products to Cart")
    $tracer.trace("THIS IS THE PRODUCT URLs #{@product_urls}")
    @browser.add_products_to_cart_by_url_ispu(@product_urls, @start_page, @condition, @params, @db_result)

    @browser.add_powerup_rewards_number(@params)
		$tracer.trace("Check subtotal and total")
    subtotal = @browser.check_cart_subtotal_and_discount(@params)
		
    @browser.paypal_chkout_button.should_not_exist
		
		# Validate Certona recommendation cartridge on the cart
    @browser.validate_certona_recommendation if @params['validate_certona_cart'] == true
			
    @browser.continue_checkout_button.click

    if @matured_product || @matured_product_svc
      $tracer.trace("Mature or Adult Audience confirmation page")
      @browser.handle_mature_product_screen(@params)
    end

    if @params["load_bill_addr_from_profile"]
      $tracer.trace("Load Billing Address Info From Profile.")
      @browser.check_checkout_billing_fields_exist
    else
      $tracer.trace("Enter Billing Address Info.")
      @browser.fill_out_billing_form(@params)
		end
    @browser.validate_cookies_and_tags(@params)
    @browser.continue_checkout_button.click

    $tracer.trace("Handling Options/Select Store")
    @browser.wait_for_landing_page_load

    $tracer.trace("Enter Store Information")
    @browser.enter_store_handling_options(@params)
		@browser.ispu_phone_number.value = @params["bill_phone"]
    @browser.continue_checkout_button.click

    #Checkout - Payment Options
    $tracer.trace("Payment Options")
    @browser.wait_for_landing_page_load
    @browser.validate_cookies_and_tags(@params)
		
		# Assert: Paypal radio button should not be visible for ISPU
		$tracer.trace("Paypal Payment should NOT be available for ISPU.")
    @browser.payment_options_radio_button.length.should == 1

    # FIXME : This won't work because the value is 0 for handling.  need to fix on game_stop_checkout_dsl.rb line 196 without breaking exising scripts.
    @browser.validate_payment_options_and_total(@condition, @physical_product, @params)
    order_summary_total = money_string_to_decimal(@browser.order_summary_total.innerText)

    if @params["pay_from_digital_wallet"]
      @browser.enter_digital_wallet_info(@digital_wallet_svc, @digital_wallet_version, @open_id, @params)
    else
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
    end

    #Submit the order only if the value of submit_order_flag from csv file is 'true'
    if @params["submit_order_flag"]
      $tracer.trace("Submitted Order")
      order_num = @browser.submit_and_confirm_order(@params, @condition)
      @browser.check_confirmation_page_subtotal(subtotal) unless @params["renew_pur"]

      # Is this a physical product? An order note and at least shipping address should exist. Not for DLC.
      if @physical_product
        $tracer.trace("Order Note")
        @browser.confirm_order_note.should_exist
      end
      @browser.check_confirmation_page_payment_method(@params["use_paypal_at_cart"] || @params["use_paypal_at_payment"])

      $tracer.trace("Call purchase order service to get order information")
      get_purchase_order_by_tracking_number_rsp = @purchase_order_svc.perform_get_placed_order(@session_id, "GS_US", "en-US", order_num, @purchase_order_svc_version)

      $tracer.trace(get_purchase_order_by_tracking_number_rsp.http_body.formatted_xml)
      get_purchase_order_by_tracking_number_rsp.code.should == 200
      get_purchase_order_by_tracking_number_rsp.http_body.find_tag("owner_id").content.should == @cart_id

      # Billing information not present for PayPal
      if !@params["use_paypal_at_cart"] && !@params["use_paypal_at_payment"]
        customer_billing = get_purchase_order_by_tracking_number_rsp.http_body.find_tag("customer").bill_to
        if @params["load_bill_addr_from_profile"]
          @browser.check_address_equivalence(customer_billing, @billing_address)
        else
          @browser.check_address_equivalence_against_params(customer_billing, @params)
        end
      end

      @browser.check_store_equivalence_against_params(@params)
      @browser.confirm_payment_panel.confirm_payment_type_label.should_exist
      @browser.confirm_payment_panel.confirm_payment_number_label.should_exist
    end
  end
end
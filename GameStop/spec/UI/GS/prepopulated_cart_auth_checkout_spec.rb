# USAGE NOTES
# Checkout as an Authenitcated User
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\prepopulated_cart_auth_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv --url QA_GS --browser chrome --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\prepopulated_cart_auth_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --browser chrome --or

#If using Paypal in QA3 to test: Add: --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA3_Paypal1
# and set @start_page = "http://qa3.gamestop.com" if (@params["use_paypal_at_cart"] || @params["use_paypal_at_payment"])

#CERT TESTING
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\prepopulated_cart_auth_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFSCERT01 --login cert_test@gamestop.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "CERT_Catalog" --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv --url CERT_GS --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env CERT_GS --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Prepopulated Cart - Authenticated User Checkout" do
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
    $tracer.trace(" *** Clear Cart *** ")
    @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
    @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
		@cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    if @params["load_ship_addr_from_profile"] || @params["load_bill_addr_from_profile"]
      @shipping_addresses, @billing_address = @profile_svc.perform_get_addresses(@open_id, @session_id, 'GS_US', @profile_svc_version)
    end

    $tracer.trace("Add to cart by service invocation")
    @matured_product, @physical_product = @browser.add_products_to_cart_by_service(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id, @cart_id, @cart_svc, @cart_svc_version)
    @browser.open("#{@start_page}/Checkout")
		@browser.log_in_link.click
		@browser.log_in(@login, @password)
		sleep 1

    product_price = @browser.cart_list.at(0).price

    @browser.add_powerup_rewards_number(@params)
		$tracer.trace("Check subtotal and total")
    subtotal = @browser.check_cart_subtotal_and_discount(@params)
		
		@browser.validate_cookies_and_tags(@params)
		@browser.wait_for_landing_page_load

    if @params["use_paypal_at_cart"]
      @browser.paypal_chkout_button.click
      # Log into PayPal sandbox
      $tracer.trace("Log Into PayPal")
      @browser.paypal_sandbox_login
      #Need to validate information on this page.  Impulse DSL- need to get that code imported into our DSL

      sleep 3
    else
      @browser.continue_checkout_button.click
			@browser.validate_cookies_and_tags(@params)
    end

    @browser.wait_for_landing_page_load

    # Mature or Adult Audience confirmation page
    if @matured_product
      @browser.handle_mature_product_screen(@params)
    end

    if @params["use_paypal_at_cart"]
      $tracer.trace("Continue through PayPal")
      @browser.paypal_test_acct_continue_button.click
      #Should be back on the gamestop.com handling options page now
      sleep 3

      #Handling options only apply to physical products
      if @physical_product
        $tracer.trace("Handling Options")
        @browser.enter_handling_options(@params)
      end
    else
      # Check for digital product alone - no shipping page will exist (alt check: @browser.chkoutweeklyadoffers_label.exists)
      if @physical_product
        @browser.wait_for_landing_page_load

        if @params["load_ship_addr_from_profile"]
          $tracer.trace("Load Shipping Address Info From Profile.")
          @browser.check_checkout_shipping_fields_exist
        else
          $tracer.trace("Enter Shipping Address Info.")
          @browser.fill_out_shipping_form(@params)
        end

        #Sign up for Weekly ad, offers and more
        $tracer.trace("Sign up for weekly ads? #{@params["sign_up_weekly_ads"] ? "Yes" : "No"}")
        @browser.chkoutweeklyadoffers_label.click if @params["sign_up_weekly_ads"]

        # Billing Address and shipping address same
        if @billing_address_same_as_shipping
          @browser.same_address_checkbox.click
          @browser.continue_checkout_button.click
        else
          @browser.continue_checkout_button.click
          #Verify Checkout page (Billing Address Info)
          @browser.wait_for_landing_page_load
          if @params["load_bill_addr_from_profile"]
            $tracer.trace("Load Billing Address Info From Profile.")
            @browser.check_checkout_billing_fields_exist
          else
            $tracer.trace("Enter Billing Address Info.")
            sleep 1
            @browser.fill_out_billing_form(@params)
          end
          @browser.continue_checkout_button.click
          #Checkout - Handling Options
          sleep 1
        end
        $tracer.trace("Handling Options")
        @browser.wait_for_landing_page_load
        @browser.enter_handling_options(@params)
      else
        #Verify Checkout page (Billing Address Info)
        $tracer.trace("Billing Address Info.")
        @browser.wait_for_landing_page_load
        @browser.check_checkout_billing_fields_exist
        @browser.continue_checkout_button.click
      end

      #Checkout - Payment Options
      $tracer.trace("Payment Options")
      @browser.wait_for_landing_page_load
      @browser.validate_payment_options_and_total(@condition = nil, @physical_product, @params)

      if @params["pay_from_digital_wallet"]
        @browser.enter_digital_wallet_info(@digital_wallet_svc, @digital_wallet_version, @open_id, @params)
      elsif @params["use_paypal_at_payment"]
        @browser.paypal_payment_selector.click
        @browser.paypal_chkout_button.click
        # Log into PayPal sandbox
        $tracer.trace("Log Into PayPal")
        @browser.paypal_sandbox_login

        $tracer.trace("Continue through PayPal")
        @browser.paypal_test_acct_continue_button.click
        #Should be back on the gamestop.com handling options page now
        sleep 3
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

      @browser.chkoutadd_digital_wallet.click if @params["add_digital_wallet"]
    end

    #Submit the order only if the value of submit_order_flag from csv file is 'true'
    if @params["submit_order_flag"]
      $tracer.trace("Submitted Order")
      #order_num = @browser.submit_and_confirm_order
      @browser.submit_order

      #The order confirmation page can take a few seconds longer than most pages to load.  The retry logic will repeat for 30 seconds on the second or until the html element is found on the page.
      #retry_until_found can be found in the DSL game_stop_common_functions.rb
      @browser.retry_until_found(lambda{@browser.order_confirmation_label.exists != false})
      @browser.order_confirmation_label.should_exist
      order_num = @browser.order_confirmation_number

      @browser.check_confirmation_page_subtotal(subtotal)

      $tracer.report(order_num)
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

      shipment = get_purchase_order_by_tracking_number_rsp.http_body.find_tag("shipments").shipment[0]
      if @params["load_ship_addr_from_profile"]
        i = 0
        while i < @shipping_addresses.length
          $tracer.trace("Retrieves the Default Shipping Address")
          sleep 2
          if @shipping_addresses[i].is_default.content == true
            @browser.check_address_equivalence(shipment, @shipping_addresses[i])
          end
          i = i + 1
        end
      else
        @browser.check_address_equivalence_against_params(shipment.ship_to, @params)
      end
    end
  end

end
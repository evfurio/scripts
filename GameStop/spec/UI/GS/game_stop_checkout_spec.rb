# USAGE NOTES
# Checkout as an Authenitcated User
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\game_stop_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --browser chrome --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\game_stop_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --browser chrome --or
# More examples in the Readme.txt

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Authenticated User Checkout" do
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
    #NOTE : Adding this to do some benchmarks on runtime with getting info from Octopus
    #TODO : May need to add exception handling in case octopus is down as this shouldn't stop a test from running
    @before_env_name, @before_release_id = @browser.get_octopus_release
    $tracer.report("Environment : #{@before_env_name}, Release ID : #{@before_release_id}")
    $tracer.trace("#{@env_name}; #{@release_id}")
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @after_env_name, @after_release_id = @browser.get_octopus_release
    $tracer.report("Environment : #{@after_env_name}, Release ID : #{@after_release_id}")
    @browser.close_all()
    #TODO : May need to add exception handling in case octopus is down as this shouldn't stop a test from running
  end

  it "#{$tc_id} #{$tc_desc}" do

    # GET THE CURRENT STATE OF THE APPLICATION UNDER TEST

    #TYPE OF USER
    #GUEST
      #ALL PROFILE INFORMATION IS PULLED FROM THE DATASET

    #EXISTING
      #USER EXISTS
        #ENROLLED PUR MEMBER?
          #FREE OR PRO
        #ACTIVATED PUR MEMBER?
          #FREE OR PRO
          #HAS POINTS?
        #EXPIRED PUR MEMBER?
          #PRO to FREE
        #HAS SHIPPING ADDRESS?
          #Number of addresses
          #Locations
          #Preferred?
        #HAS BILLING ADDRESS?
          #Number of addresses
          #Locations
          #Preferred?
        #HAS MAILING ADDRESS?
    #NEW


    #GET CART INFORMATION FOR EXISTING USERS
    #GET THE CART ID
    @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)


    @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)

    # GET PRODUCTS BY ATTRIBUTE
    $tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id) unless @params["renew_pur"]


    # Added Subscribe and Unsubscribe to Mailing List operations from Profile Service Ver 2
    #@unsubscribe = @profile_svc.perform_unsubscribe_to_mailing_list(@login, @session_id, 'GS_US', 'en-US', @profile_svc_version)
    #@subscribe = @profile_svc.perform_subscribe_to_mailing_list(@login, @session_id, 'GS_US', 'en-US', @profile_svc_version)

    @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)

    $tracer.trace(@cart_id)
    @cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)

    if @params["do_linkshare"] #|| @params["do_ef"]
      $tracer.trace("Enter site as a Linkshare affiliate")
      @browser.open($global_functions.prop_url.find_value_by_name("affiliate_url"))
    else
      @browser.open(@start_page)
    end
    @browser.validate_cookies_and_tags(@params)
    @browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)

    if @params["do_merge_cart"]
      $tracer.trace("Add to cart by service for Merge Cart Scenario")
      @matured_product_svc, @physical_product_svc = @browser.add_products_to_cart_by_service(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id, @cart_id, @cart_svc, @cart_svc_version)
    end

    if @params["load_ship_addr_from_profile"] || @params["load_bill_addr_from_profile"]
      $tracer.trace("Get profile information for addresses")
      @shipping_addresses, @billing_address = @profile_svc.perform_get_addresses(@open_id, @session_id, 'GS_US', @profile_svc_version)
    end

    @browser.log_in_link.click
    @browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
    @browser.log_in(@login, @password)

    # Removed because this functionality was put into it's own script
    #@browser.check_adroll_on_other_pages(@params, @start_page) if @params["do_adroll"]

    if @params["renew_pur"]
      $tracer.trace("PUR Renewal")
      pur_renewal_url = @browser.add_renewal_sku_to_cart_by_url(@params["renewal_type"], @start_page)
      @physical_pur = true # This is always true b/c both renewal type (Physical and Digital) are being shipped to address.
      @browser.open(pur_renewal_url)
    else
      @browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, @cart_id, @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
      sleep 2
      @browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)

      @browser.add_powerup_rewards_number(@params)
      $tracer.trace("Check subtotal and total")
      subtotal = @browser.check_cart_subtotal_and_discount(@params)

      #HACK : Adroll test adds a pre-order product and selects pick up at store, paypal is disabled in this case.
      #TODO : Handle the cart conditions by evaluating what products are added
      @browser.paypal_chkout_button.should_exist unless @params["do_adroll"] || @params["do_ispu"]

      # Validate account if PUR Pro or PUR Free
      pur_number = @browser.powerup_rewards_number_field.value
      ########################################################################################################################################################################
      # HACK - We're using 3976 to trick the system in QA to allow us to register new PUR accounts all the way to Brierley.  Until we have something better, this will remain.
      is_pur = @browser.validate_pur_account(pur_number)
      ########################################################################################################################################################################

      #TODO : This situation can cause false positives when assessing failures as not all Used items will give a discount.  We need to force this through the product query.
      if @condition.include?("USED") && is_pur == true
        discount_amount_from_cart.should_exist unless pur_number[0, 4] == '3975'
      end

      # Validate Certona recommendation cartridge on the cart
      @browser.validate_certona_recommendation if @params['validate_certona_cart'] == true

      $tracer.trace("THIS IS THE ENTRY TO PAYPAL IN THE CART")
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
        @browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
      end
    end

    @browser.wait_for_landing_page_load

    # Mature or Adult Audience confirmation page
    if @matured_product || @matured_product_svc
      @browser.handle_mature_product_screen(@params) unless @params["use_paypal_at_cart"]
    end

    if @params["use_paypal_at_cart"]
      $tracer.trace("Continue through PayPal")
      @browser.paypal_test_acct_continue_button.click
      sleep 3
      $tracer.trace("----------RETURN TO GAMESTOP.COM AgeConfirmation page if MaturedProduct and/or HandlingOptions page if PhysicalProduct----------")
      @browser.handle_mature_product_screen(@params) if @matured_product
      @browser.enter_handling_options(@params) if @physical_product
    else
      # Check for digital product alone - no shipping page will exist (alt check: @browser.chkoutweeklyadoffers_label.exists)
      if @physical_product || @physical_pur
#TODO : Determine the test flags at time of initializing the test data.  We can collect the information needed and reduce the confusion
#       in this chunk of code so we know whether to insert values into fields or not.
        if @params["load_ship_addr_from_profile"]
          $tracer.trace("Load Shipping Address Info From Profile.")
          @browser.check_checkout_shipping_fields_exist
#TODO : Get shipping address from profile service and validate the address is populated
        else
          $tracer.trace("Enter Shipping Address Info.")
          @browser.fill_out_shipping_form(@params)
        end

        @browser.validate_cookies_and_tags(@params)
        @browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)

        #Sign up for Weekly ad, offers and more
        $tracer.trace("Sign up for weekly ads? #{@params["sign_up_weekly_ads"] ? "Yes" : "No"}")
        @browser.chkoutweeklyadoffers_label.click if @params["sign_up_weekly_ads"]

        # Billing Address and shipping address same
        if @params["billing_address_same_as_shipping"]
          $tracer.report("Use same address for billing and shipping")
          @browser.same_address_checkbox.click
          @browser.continue_checkout_button.click
        else
          @browser.continue_checkout_button.click
          #Verify Checkout page (Billing Address Info)
          @browser.wait_for_landing_page_load
          if @params["load_bill_addr_from_profile"]
            $tracer.report("Load Billing Address Info From Profile.")
            @browser.check_checkout_billing_fields_exist
          else
            $tracer.report("Enter Billing Address Info.")
            @browser.fill_out_billing_form(@params)
          end
          @browser.validate_cookies_and_tags(@params)
          @browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
          @browser.continue_checkout_button.click
          #Checkout - Handling Options
          sleep 1
        end
        $tracer.trace("Handling Options")
        @browser.wait_for_landing_page_load
        i = 0
        while i < @browser.handling_options_page_panel.length
          panel = @browser.handling_options_page_panel.at(i)
          if  panel.title.innerText.eql? ("Items Shipping to Your Address")
            $tracer.trace("Handling Options for available product")

            @browser.wait_for_landing_page_load
            cart_rsp = @cart_svc.perform_get_cart_and_return_message(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)
            cart_items = cart_rsp.http_body.find_tag("line_items").at(0).item

            get_available_shipping_methods_rsp = @shipping_svc.perform_get_shipping_methods_thru_cart(@session_id, @cart_id, @shipping_svc_version, @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @browser.state_abbriviation(@params["ship_state"]), @params["ship_zip"], @browser.country_code(@params["ship_country"]), @params["promo_code_number"], cart_items)
            calculated_shipping_methods = get_available_shipping_methods_rsp.http_body.find_tag("calculated_shipment").at(0).shipping_methods.calculated_shipping_method
            calculated_shipping_method = nil

            calculated_shipping_methods.each_with_index do |shipping_method, i|
              $tracer.trace("#{shipping_method.shipping_cost.content} - #{shipping_method.display_name.content} - #{shipping_method.description.content}")
              if shipping_method.display_name.content == @params["shipping_option"]
                calculated_shipping_method = calculated_shipping_methods[i]
              end
            end
            if calculated_shipping_methods.length > 1
              panel.handling_method_buttons.value = calculated_shipping_method.display_name.content
              panel.handling_method_buttons.value = calculated_shipping_method.description.content
							$tracer.trace("Selected Shipping Method :: #{calculated_shipping_method.display_name.content} - #{calculated_shipping_method.description.content}")
            else
							$tracer.trace("This is the only available Shipping Method :: #{calculated_shipping_methods[0].display_name.content}")
            end
          elsif  panel.title.innerText.eql? ("Pick Up At Store")
            $tracer.trace("Choose Store For ISPU product")
            panel.choose_store_link.click
            sleep 5
            @browser.search_store_adress.should_exist
            @browser.search_store_adress.value = @params["ship_zip"]
            @browser.search_store_adress_button.should_exist
            @browser.search_store_adress_button.click
            sleep 5
            @browser.choose_store_button.should_exist
            @browser.choose_store_button.click
            @browser.wait_for_landing_page_load
            @browser.ispu_phone_number.value = @params["bill_phone"]
          end
          i = i +1
        end
        @browser.continue_checkout_button.click
      else
        #Verify Checkout page (Billing Address Info)
        $tracer.trace("Billing Address Info.")
        @browser.wait_for_landing_page_load
        @browser.validate_cookies_and_tags(@params)
        @browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
        @browser.check_checkout_billing_fields_exist
        @browser.continue_checkout_button.click
      end

      #Checkout - Payment Options
      $tracer.trace("Payment Options")
      @browser.wait_for_landing_page_load
      @browser.validate_cookies_and_tags(@params)
      @browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
      @browser.validate_payment_options_and_total(@condition, @physical_product, @params)
      order_summary_total = money_string_to_decimal(@browser.order_summary_total.innerText)
      @browser.paypal_payment_selector.should_exist

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
        sleep 2
      else
        @browser.wallet_label.value = "-- Select a Card--" if @browser.wallet_label.exists

        #FIXME : This doesn't feel right.  Should have a flag to tell the test to use SVS or not.
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
      sleep 5
    end

    # ChangePaymentMethod Scenarios
    if @params["use_paypal_at_cart"]
      paypal_is_visible = (@browser.paypal_payment_info.call("style.display").eql?("none") ? false : true)
      paypal_is_visible.should == true
      if @params["do_change_payment"]
        @browser.change_payment_method_link.click
        @browser.wait_for_landing_page_load
        if @params["use_paypal_at_payment"]
          $tracer.trace("Use PAYPAL from Cart then change PAYPAL at Payment")
          @browser.paypal_payment_selector.click
          @browser.paypal_chkout_button.click
          @browser.paypal_sandbox_login
          @browser.paypal_test_acct_continue_button.click
          sleep 2
        else
          $tracer.trace("Change Payment from PAYPAL to CreditCart")
          @browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])
        end
      end
    end

    #Submit the order only if the value of submit_order_flag from csv file is 'true'
    if @params["submit_order_flag"]
      $tracer.trace("Submitted Order")
      order_num = @browser.submit_and_confirm_order(@params, @condition)
      @browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
      @browser.check_confirmation_page_subtotal(subtotal) unless @params["renew_pur"]

      # Is this a physical product? An order note and at least shipping address should exist. Not for DLC.
      if @physical_product
        $tracer.trace("Order Note")
        @browser.confirm_order_note.should_exist
      end

      #FIXME : This line never gets executed unless it's a paypal payment type at cart or payment screen
      @browser.check_confirmation_page_payment_method(@params["use_paypal_at_cart"] || @params["use_paypal_at_payment"]) unless @params["do_change_payment"]

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

      get_purchase_order_by_tracking_number_rsp.http_body.find_tag("shipments").shipment.each do |shipment_address|
        @shipment = shipment_address if shipment_address.type.content.eql? ("ShipToAddress")
      end

      if @params["load_ship_addr_from_profile"]
        i = 0
        while i < @shipping_addresses.length
          sleep 2
          if @shipping_addresses[i].is_default.content == true
            $tracer.trace("Asserting address equivalence for shipping address")
            @browser.check_address_equivalence(@shipment, @shipping_addresses[i])
          end
          i = i + 1
        end
      else
        @browser.check_shipping_address_equivalence_against_params(@shipment.ship_to, @params)
      end
    end
  end
end
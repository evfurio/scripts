## Calling all test data from csv
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\GSmobile_guest_visit_pixel_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\mobile_dataset.csv  --range TFS100750  --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "GS Mobile Guest Validate Visit Pixel scripts" do

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
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
  end

  before(:each) do
    @browser.cookie.all.delete
    @session_id = generate_guid
    sql = @sql.to_s
    @results_from_file = @db.exec_sql_from_file("#{sql}")
    @browser.open(@start_page)

  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do

    $tracer.trace("TC100750 - Check for visit pixel script on the home page")
    @browser.validate_analytics(@params)

    $tracer.trace("TC100752 - Check for visit pixel script on the search page")
    @browser.search_field.value="mario kart 8"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.wait_for_landing_page_load
    @browser.validate_analytics(@params)

    $tracer.trace("TC100755 - Check for visit pixel script on the guided search page")
    @browser.sort_option_selector.value="Release Date"
    sleep(1)
    @browser.validate_analytics(@params)

    $tracer.trace("TC100760 - Check for visit pixel script on the store search page")
    @browser.search_field.value=""
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.wait_for_landing_page_load
    @browser.validate_analytics(@params)

    $tracer.trace("TC100761 - Check for visit pixel script on cart")
    @browser.view_cart_button.click
    @browser.wait_for_landing_page_load
    @browser.validate_analytics(@params)
    @browser.empty_new_cart
    @browser.continue_shopping_button.click
    @browser.wait_for_landing_page_load
    @browser.validate_analytics(@params)
    @browser.store_pickup_search_button.click
    @browser.wait_for_landing_page_load
    @browser.availability_slide.click
    @browser.wait_for_landing_page_load
    @browser.gsm_filter_submit_button.click
    @browser.wait_for_landing_page_load
    @browser.validate_analytics(@params)

    $tracer.trace("TC100751 -  Check for visit pixel script on the product detail page")
    $tracer.trace("Get Products")
    @matured_product, @physical_product = @browser.add_products_to_cart(@results_from_file, @start_page, @params)

    unless @params["continue_checkout"]
      $tracer.trace("TFS100773 - Check for visit pixel script on giftcard.")
      @browser.open("#{@start_page}/GiftCard")
      @browser.send_keys(KeyCodes::KEY_ENTER)
      @browser.wait_for_landing_page_load
      @browser.validate_analytics(@params)

      $tracer.trace("TFS100783 - Check for visit pixel script on weekly ads.")
      @browser.open("#{@start_page}/Home/WeeklyAd")
      @browser.send_keys(KeyCodes::KEY_ENTER)
      @browser.wait_for_landing_page_load
      @browser.validate_analytics(@params)

      $tracer.trace("TFS100771 - Check for visit pixel script on order info.")
      @browser.open("#{@start_page}/Orders/OrderHistory")
      @browser.send_keys(KeyCodes::KEY_ENTER)
      @browser.wait_for_landing_page_load
      @browser.validate_analytics(@params)

    else
      $tracer.trace("Continue Secure Checkout")
      @browser.continue_checkout_button_handling.click
      @browser.wait_for_landing_page_load
      @browser.validate_analytics(@params)

      $tracer.trace("TC100765 - Check for visit pixel script on checkout: login.")
      $tracer.trace("How Do You Want To Checkout? screen")
      @browser.buy_as_guest_button.click
      @browser.wait_for_landing_page_load
      @browser.validate_analytics(@params)

      $tracer.trace("Age Check screen")
      if @matured_product
        @browser.seventeen_or_older_button.click unless @params["use_paypal_at_cart"]
        @browser.wait_for_landing_page_load
        @browser.validate_analytics(@params)
      end

      if @physical_product
        $tracer.trace("TC100768 - Check for visit pixel script on checkout: shipping address.")
        $tracer.trace("Shipping Address screen")
        @browser.show_order_summary_link.click
        @browser.enter_address_plus_email(@params["first_name"], @params["last_name"], @params["shipping_line1"], @params["shipping_city"], @params["shipping_state"], @params["shipping_zip"], @params["shipping_phone"], @params["shipping_email"])
        @browser.validate_analytics(@params)

        $tracer.trace("TC100770 - Check for visit pixel script on checkout: billing address.")
        if @params["billing_address_same_as_shipping"]
          @browser.chkout_same_address_checkbox.checked = true
        else
          $tracer.trace("Billing Address screen")
          @browser.continue_checkout_button_handling.click
          @browser.wait_for_landing_page_load
          @browser.show_order_summary_link.click
          @browser.enter_billship_address(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"])
        end
        @browser.validate_analytics(@params)

        @browser.continue_checkout_button_handling.click
        @browser.wait_for_landing_page_load

        $tracer.trace("TC100767 - Check for visit pixel script on checkout: handling options.")
        $tracer.trace("Handling Options screen")
        @browser.show_order_summary_link.click

        @browser.chkout_gift_message_field.value = "Gift Message Box should only contain 50 characters"
        @browser.chkout_gift_message_field.value.length.should_not > 50

        @browser.chkout_handling_options_label.should_exist
        @browser.shipping_handling_option_label.find.input[1].click   #Standard
        @browser.validate_analytics(@params)

        @browser.continue_checkout_button_handling.click
        @browser.wait_for_landing_page_load

        $tracer.trace("TC100766 - Check for visit pixel script on payment.")
        $tracer.trace("Payment Options screen")
        @browser.validate_analytics(@params)
        @browser.show_order_summary_link.click
        @browser.unused_promocode_message.should_not_exist

        if @params["use_paypal_at_payment"]
          @browser.paypal_payment_option.click
          @browser.paypal_continue_button.click
          @browser.wait_for_landing_page_load

          $tracer.trace("Log Into PayPal")
          @browser.paypal_sandbox_login
          $tracer.trace("Continue through PayPal")
          @browser.paypal_test_acct_continue_button.click
          sleep 3
        else
          @browser.cc_payment_option.click
          @browser.wait_for_landing_page_load
          if @params["svs_number"].empty?
            $tracer.trace("Pay With A Credit Card")

            if @params["change_existing_address"]
              $tracer.trace("Change address Link on Payment Page")
              @browser.change_address_payment_page_link.click
              @browser.enter_billship_address(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"])
              if not @physical_product
                #if DLC, the system will ask for Email address
                @browser.chkout_email_address_field.value = @params["billing_email"]
                @browser.chkout_billing_confirm_email_address_field.value = @params["billing_email"]
              end
              @browser.continue_checkout_button_handling.click
              @browser.wait_for_landing_page_load
              @browser.retry_until_found(lambda{@browser.cc_payment_option.exists != false})
              @browser.cc_payment_option.click
              @browser.wait_for_landing_page_load
            end
            $tracer.trace("Enter Credit Card Info")
            @browser.enter_credit_card_info(@params["cc_type"], @params["cc_number"], @params["exp_month"], @params["exp_year"], @params["cvv"])

          else
            $tracer.trace("Pay With A PowerUp Rewards, Trade Card, or Gift Cards")
            @browser.chkout_gift_card_field.value = @params["svs_number"]
            @browser.chkout_gift_card_pin_field.value = @params["svs_pin"]
            @browser.gift_card_apply_button.click
            @browser.wait_for_landing_page_load
            @browser.validate_svs(@params)
          end
        end
      end
    end
  end
end


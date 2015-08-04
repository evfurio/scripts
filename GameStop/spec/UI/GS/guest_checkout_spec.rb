# USAGE NOTES:                                                                                                                                                                                           #
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql --browser chrome --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Guest Checkout" do
  before(:all) do
		#Set proxy for the web driver
    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9091"
    $proxy = ProxyServerManager.new(9091)
		
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
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
  end

  before(:each) do
		$proxy.inspect
    $proxy.start
    sleep 5
		
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
    $tracer.trace("Get products")
		unless @params["sku"] == ""
			@product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_csv(@velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
    else
			@product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
		end

		$proxy.start_capture(true)
		
    if @params["do_linkshare"] || @params["do_ef"]
      @browser.open($global_functions.prop_url.find_value_by_name("affiliate_url"))
			@ef_id = @browser.get_ef_id(@browser.url_data.full_url) if @params["do_ef"]
    else
      @browser.open(@start_page)
    end
    @browser.validate_cookies_and_tags(@params)
  end

  after(:each) do
    # @browser.stop_capture($proxy)
		$proxy.stop
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    $proxy.start_capture(true)
		@browser.check_adroll_on_other_pages(@params, @start_page) if @params["do_adroll"]
		
		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, '', @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
		
    #product_price = @browser.cart_list.at(0).price
    @browser.add_powerup_rewards_number(@params)
		$tracer.trace("Check subtotal and total")
    subtotal = @browser.check_cart_subtotal_and_discount(@params)

    #HACK
    # TODO : interegate the cart to know whether there are PR products to be picked up at store, this disables paypal
		@browser.paypal_chkout_button.should_exist unless @params["do_adroll"]
    @browser.validate_certona_recommendation if @params['validate_certona_cart'] == true
    @browser.wait_for_landing_page_load

    if @params["use_paypal_at_cart"]
      @browser.paypal_chkout_button.click
      # Log into PayPal sandbox
      $tracer.trace("Log Into PayPal")
      @browser.paypal_sandbox_login
    else
      @browser.continue_checkout_button.click
      @browser.validate_cookies_and_tags(@params)
      $tracer.trace("Click Checkout As Guest")
      @browser.chkoutbuy_as_guest_button.click
    end

    # Mature or Adult Audience confirmation page
    if @matured_product
      if @params["is_under_age"]
				@browser.under_seventeen_button.click
				$tracer.trace("GameStopCartDSL : #{@browser.cart_info_message.innerText}")
				@browser.cart_info_message.innerText.should == 'The mature-rated items in your cart have been removed.'
				subtotal = @browser.check_cart_subtotal_and_discount(@params)
				@browser.continue_checkout_button.click
				@browser.wait_for_landing_page_load
				@browser.chkoutbuy_as_guest_button.click
			else
				@browser.handle_mature_product_screen(@params) unless @params["use_paypal_at_cart"]
			end			
    end

    if @params["use_paypal_at_cart"]
      $tracer.trace("Continue through PayPal")
      @browser.retry_until_found(lambda{@browser.paypal_test_acct_continue_button.exists != false}, 10)
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
        $tracer.trace("Fill Out Shipping Address Form")
        @browser.fill_out_shipping_form(@params)
        @browser.validate_cookies_and_tags(@params)
        @browser.wait_for_landing_page_load

        #Sign up for Weekly ad, offers and more
        $tracer.trace("Sign up for weekly ads? #{@params["sign_up_weekly_ads"] ? "Yes" : "No"}")
        @browser.chkoutweeklyadoffers_label.click if @params["sign_up_weekly_ads"]

        # Billing Address and shipping address same
        if @params["billing_address_same_as_shipping"]
          @browser.same_address_checkbox.click
          @browser.continue_checkout_button.click

        else
          @browser.continue_checkout_button.click
          sleep 4
          $tracer.trace("Billing Address Info (Physical).")
          @browser.fill_out_billing_form(@params)
          @browser.validate_cookies_and_tags(@params)
          @browser.continue_checkout_button.click
        end

        @browser.enter_handling_options(@params)
      else
        $tracer.trace("Billing Address Info (Digital).")
        @browser.fill_out_billing_form(@params)
        @browser.chkoutpurchaseemail_label.value = @params["bill_email"]
        @browser.chkoutconfirmemail_bill_to_label.value = @params["bill_email"]
        @browser.validate_cookies_and_tags(@params)
        @browser.continue_checkout_button.click
        sleep 4
      end

      $tracer.trace("Payment Options")
      @browser.wait_for_landing_page_load
      @browser.validate_cookies_and_tags(@params)
      @browser.validate_payment_options_and_total(@condition, @physical_product, @params)
      order_summary_total = money_string_to_decimal(@browser.order_summary_total.innerText)
			@browser.paypal_payment_selector.should_exist

      if @params["use_paypal_at_payment"]
        @browser.enter_paypal_info
      else
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
    end
		
		# ChangePaymentMethod Scenarios
		if @params["use_paypal_at_cart"]
			@browser.retry_until_found(lambda{@browser.paypal_payment_info.exists != false}, 20)
      paypal_is_visible = (@browser.paypal_payment_info.call("style.display").eql?("none") ? false : true)
      paypal_is_visible.should == true
			@browser.change_payment_method(@params) if @params["do_change_payment"]
		end
		
    #Submit the order only if the value of submit_order_flag from csv file is 'true'
    if @params["submit_order_flag"]
      order_num = @browser.submit_and_confirm_order(@params, @condition)
			@browser.get_ef_cookies(@ef_id) if @params["do_ef"]	
      using_paypal = @params["use_paypal_at_cart"] || @params["use_paypal_at_payment"]

			capture_data = $proxy.get_capture
			# $tracer.trace(capture_data.formatted_json)
			$proxy.stop_capture
						
      #@browser.check_create_account_popup_fields_exist(@params)
      @browser.check_confirmation_page_subtotal(subtotal)

      # Is this a physical product? An order note, shipping address, and (maybe) billing address should exist. Not for DLC.
      if @physical_product
        $tracer.trace("Order Note")
        @browser.confirm_order_note.should_exist

        if !using_paypal
          $tracer.trace("Confirm Billing Address")
          @browser.check_billing_address_fields_exist
        end

        $tracer.trace("Confirm Shipping Address")
				i=0
				has_digital = false
				while i < @condition.length
					has_digital = (@condition[i].upcase.include?('DIGITAL') ? true : false) unless has_digital
					i+=1
				end
				@browser.check_shipping_address_fields_exist unless has_digital
      else
				if @params["use_paypal_at_cart"] 
					omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), @browser.url_data.full_url)
					@browser.get_payment_mode_from_query_strings(omniture_list) 
				end
			end

      @browser.check_confirmation_page_payment_method(using_paypal)
    end
  end
end
# USAGE NOTES
# Created specifically to handle DLC checkout scenarios
# Checkout as an Authenitcated User
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_DLC_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48596 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting  --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Authenticated User DLC Checkout" do
  before(:all) do
    @browser = WebBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 30_000
    $snapshots.setup(@browser, :all)

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

    $tracer.report('Clean Up: Clear Cart if user has an existing cart')
    @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
    @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
		@cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)

    @browser.open(@start_page)
		@browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)

    if @params['load_ship_addr_from_profile'] || @params['load_bill_addr_from_profile']
      $tracer.trace("Load address from profile for Shipping: #{@params['load_ship_addr_from_profile']} or Billing: #{@params['load_bill_addr_from_profile']}")
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
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)

    @browser.log_in_link.click
		@browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
		@browser.log_in(@login, @password)

		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, @cart_id, @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
		@browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)

    @browser.add_powerup_rewards_number(@params)
    $tracer.trace("Check subtotal and total")
    subtotal = @browser.check_cart_subtotal_and_discount(@params)

		# Validate Certona recommendation cartridge on the cart
    @browser.validate_certona_recommendation if @params['validate_certona_cart'] == true
    @browser.wait_for_landing_page_load
		@browser.paypal_chkout_button.should_exist
    @browser.continue_checkout_button.click
    @browser.wait_for_landing_page_load

    # Mature or Adult Audience confirmation page
    if @matured_product
      @browser.handle_mature_product_screen(@params)
    end

    # Check for digital product alone - no shipping page will exists
    @browser.wait_for_landing_page_load

    #Sign up for Weekly ad, offers and more
    $tracer.trace("Sign up for weekly ads? #{@params["sign_up_weekly_ads"] ? "Yes" : "No"}")
    @browser.chkoutweeklyadoffers_label.click if @params["sign_up_weekly_ads"]

    # Billing Address and shipping address same
    if @params["load_bill_addr_from_profile"]
      $tracer.trace("Load Billing Address Info From Profile.")
      @browser.check_checkout_billing_fields_exist
    else
      $tracer.trace("Enter Billing Address Info.")
      @browser.fill_out_billing_form(@params)
    end
		@browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
    @browser.continue_checkout_button.click
		
		@error = false
		unless @params["bill_country"] == 'United States of America'
			@browser.error_msg_panel.should_exist == true
			$tracer.report("Error msg should be displayed:" + @browser.error_msg_panel.innerText)
			@error = true
		end

		unless @error == true 
			#Checkout - Payment Options
			$tracer.trace("Payment Options")
			sleep 5
			@browser.order_summary_subtotal.should_exist
			@browser.order_summary_tax.should_exist
			@browser.retry_until_found(lambda{@browser.handling_with_discount_amount.exists != false}, 20)
			@browser.handling_with_discount_amount.should_exist
			$tracer.trace("------------------------ #{@browser.handling_with_discount_amount.innerText}")
			@browser.handling_with_discount_amount.innerText.should == "FREE!"
			@browser.order_summary_total.should_exist
			@browser.paypal_payment_selector.should_exist
			@browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
			order_summary_subtotal = money_string_to_decimal(@browser.order_summary_subtotal.innerText)
			order_summary_tax = money_string_to_decimal(@browser.order_summary_tax.innerText)
			order_summary_total = money_string_to_decimal(@browser.order_summary_total.innerText)

			total = order_summary_subtotal + order_summary_tax
			order_summary_total.should == total

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

			@browser.chkoutadd_digital_wallet.click if @add_digital_wallet

			#Submit the order only if the value of submit_order_flag from csv file is 'true'
			if @params["submit_order_flag"]
				$tracer.trace("Submitted Order")
				order_num = @browser.submit_and_confirm_order(@params, @condition)
				@browser.check_confirmation_page_subtotal(subtotal)
				@browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
				# TODO : PC DOWNLOADS - NEED TO CONFIRM THE ORDER CONFIRMATION FOR PC DOWNLOAD CODES

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

				$tracer.trace("Call purchase order service to get order information")
				get_purchase_order_by_tracking_number_rsp = @purchase_order_svc.perform_get_placed_order(@session_id, "GS_US", "en-US", order_num, @purchase_order_svc_version)

				$tracer.trace(get_purchase_order_by_tracking_number_rsp.http_body.formatted_xml)
				get_purchase_order_by_tracking_number_rsp.code.should == 200

				get_purchase_order_by_tracking_number_rsp.http_body.find_tag("owner_id").content.should == @cart_id

				customer_billing = get_purchase_order_by_tracking_number_rsp.http_body.find_tag("customer").bill_to
				if @params["load_bill_addr_from_profile"]
					@browser.check_address_equivalence(customer_billing, @billing_address)
				else
					@browser.check_address_equivalence_against_params(customer_billing, @params)
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


end

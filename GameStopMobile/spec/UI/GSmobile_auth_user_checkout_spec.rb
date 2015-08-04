## Parameters added in the command line
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\GSmobile_auth_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\mobile_dataset.csv  --range TFS47465  --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting  --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url MQA_GS  --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql  --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog"  --browser chrome --or

## Calling all test data from csv
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\GSmobile_auth_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\mobile_dataset.csv  --range TFS47425 --browser chrome --or
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\GSmobile_auth_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\mobile_dataset.csv  --range Paypal01 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()
$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
USER_AGENT_STR = "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"

describe "GS Mobile Authenticated User Checkout" do

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

    @account_svc, @account_svc_version = $global_functions.account_svc
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
		@purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc

    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9090"
    $proxy = @browser.start_proxy_server(9090)
    @browser.set_user_agent_header($proxy, USER_AGENT_STR)
  end

  before(:each) do
		@browser.delete_all_cookies_and_verify
		@session_id = generate_guid
		sql = @sql.to_s
		@results_from_file = @db.exec_sql_from_file("#{sql}")  
		@browser.open(@start_page)
		@browser.validate_analytics(@params)
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.stop_proxy_server($proxy)
    @browser.close_all()
  end
    
   it "#{$tc_id} #{$tc_desc}" do
    @browser.empty_user_cart(@login, @password, @session_id, @account_svc, @account_svc_version, @profile_svc, @profile_svc_version, @cart_svc, @cart_svc_version)
		@browser.view_cart_button.click
		@browser.log_in_link.click
		@browser.enter_login_credentials(@login, @password)
		@browser.user_login_button.click
		@browser.validate_analytics(@params)		
		@browser.continue_shopping_button.click
		@browser.store_pickup_search_button.click	
		@browser.availability_slide.click
		@browser.gsm_filter_submit_button.click	
		@browser.wait_for_landing_page_load

		$tracer.trace("Get Products")
		@matured_product, @physical_product = @browser.add_products_to_cart(@results_from_file, @start_page, @params)
		@browser.validate_pur(@params)
		
		#Proceed with checkout if True
		if not @params["continue_checkout"]
			$tracer.trace("This will not proceed with Checkout")
			@browser.update_products_quantity()
		else
			if @params["use_paypal_at_cart"]
				$tracer.trace("THIS IS THE ENTRY TO PAYPAL IN THE CART")
        @browser.paypal_chkout_button.click
        $tracer.trace("Log Into PayPal")
        @browser.paypal_sandbox_login
			else		
				$tracer.trace("Continue Secure Checkout")
				@browser.continue_checkout_button_handling.click
				@browser.wait_for_landing_page_load
			end
			
			$tracer.trace("Age Check screen")
			if @matured_product
				@browser.seventeen_or_older_button.click unless @params["use_paypal_at_cart"]
				@browser.wait_for_landing_page_load
			end
			
			if @params["use_paypal_at_cart"]
				$tracer.trace("Continue through PayPal")
        @browser.retry_until_found(lambda{@browser.paypal_test_acct_continue_button.exists != false}, 10)
				@browser.paypal_test_acct_continue_button.click
				sleep 3
				@browser.seventeen_or_older_button.click if @matured_product

				#Handling options only apply to physical products
				if @physical_product
					$tracer.trace("Handling Options screen")				
					@browser.chkout_handling_options_label.should_exist
					@browser.shipping_handling_option_label.find.input[1].click #Standard
					@browser.wait_for_landing_page_load
					@browser.continue_checkout_button_handling.click
					@browser.wait_for_landing_page_load
				end
			else
				if @physical_product 
					$tracer.trace("Shipping Address screen")
					if @browser.chkout_select_existing_address.inner_text.length == 0
						@browser.enter_address(@params["first_name"], @params["last_name"], @params["shipping_line1"], @params["shipping_city"], @params["shipping_state"], @params["shipping_zip"], @params["shipping_phone"]) 
					end
					if @params["change_existing_address"]
					# TODO - this needs to have an action taken!!!!
					end
					
					@browser.show_order_summary_link.click
									
					if @params["billing_address_same_as_shipping"]
						@browser.chkout_same_address_checkbox.checked = true
					else
						$tracer.trace("Billing Address screen")
						@browser.continue_checkout_button_handling.click
						@browser.wait_for_landing_page_load
						@browser.show_order_summary_link.click
						sleep 5
						if @browser.chkout_select_existing_billing_address.inner_text.length == 0  
							@browser.enter_billship_address(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"])           
						end
					end
					@browser.continue_checkout_button_handling.click
					@browser.wait_for_landing_page_load
					
					$tracer.trace("Handling Options screen")
					@browser.show_order_summary_link.click

					@browser.chkout_gift_message_field.value = "Gift Message Box should only contain 50 characters"
					@browser.chkout_gift_message_field.value.length.should_not > 50
					
					@browser.chkout_handling_options_label.should_exist
					@browser.shipping_handling_option_label.find.input[1].click   #Standard
					
				else
					$tracer.trace("Billing Address screen - DLC Product")
					@browser.show_order_summary_link.click
					
					if @browser.chkout_select_existing_billing_address.inner_text.length == 0
						@browser.enter_address(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"])           
						
					end
				end
				@browser.continue_checkout_button_handling.click
				@browser.wait_for_landing_page_load
				
				$tracer.trace("Payment Options screen") 
				@browser.show_order_summary_link.click
				@browser.unused_promocode_message.should_not_exist
				
				if @params["use_paypal_at_payment"]
					@browser.paypal_payment_option.click
					@browser.paypal_continue_button.click
					@browser.wait_for_landing_page_load
					
					$tracer.trace("Log Into PayPal")
					@browser.paypal_sandbox_login
					$tracer.trace("Continue through PayPal")
          @browser.retry_until_found(lambda{@browser.paypal_test_acct_continue_button.exists != false}, 10)
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
							if @browser.chkout_select_existing_billing_address.inner_text.length >= 2
								@browser.chkout_modify_existing_address.click
								@browser.chkout_enter_billing_address.click
								@browser.enter_billship_address_plus_country(@params["billing_country"], @params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"])              
								if not @physical_product
									#if DLC, the system will ask for Email address
									@browser.chkout_email_address_field.value = @params["billing_email"]
								end
							end
							@browser.continue_checkout_button_handling.click
							@browser.wait_for_landing_page_load
							@browser.retry_until_found(lambda{@browser.cc_payment_option.exists != false})
							@browser.cc_payment_option.click
							@browser.wait_for_landing_page_load
						end
						#################
						$tracer.trace("Enter Credit Card Info") 
						@browser.chkout_digital_wallet_selector.value = "-- Select a Card--" if @browser.chkout_digital_wallet_selector.exists
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
			
			if @params["submit_order"]
				@browser.submit_order
				if not @params["valid_pur_svs_cc"]
					$tracer.trace("Please enter a valid credit card number.") 
					@browser.confirm_invalid_cc_warning
				else
					$tracer.trace("Order Confirmation screen")
          @browser.retry_until_found(lambda{@browser.cc_payment_option.exists != false})
					@browser.validate_order_prefix("(5|8)1")
					@browser.validate_analytics(@params)	
					# @browser.take_snapshot
				end
			end
		end
	end
end
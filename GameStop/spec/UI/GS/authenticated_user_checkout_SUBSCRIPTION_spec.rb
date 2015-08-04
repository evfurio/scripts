# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_SUBSCRIPTION_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS57593 --browser chrome --or

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
		$tracer.trace("Get products")
		@results_from_file = ["859997","859998"]
		@matured_product = false
	  @product_urls = Array.new
		number_of_products = @results_from_file.length
				
		while @product_urls.length < number_of_products
			@results_from_file.each do |sku|
				@product_urls << @catalog_svc.perform_get_product_url(@catalog_svc_version, @session_id, sku)
				get_products_rsp = @catalog_svc.perform_get_product_by_sku(@catalog_svc_version, @session_id, sku)
				@matured_product = (get_products_rsp.http_body.find_tag("esrbrating").content.eql?("M") ? true : false ) if !@matured_product
				@physical_product = (get_products_rsp.http_body.find_tag("condition").content.eql?("Digital") ? false : true ) if !@physical_product
			end 
			if @product_urls.length < number_of_products
				@results_from_file = ["859997","859998"]
			end
		end
		
		@open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
		@cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
		$tracer.trace(" *** Clear Cart *** ")
		@cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)
		@browser.open(@start_page)
		
		@browser.log_in_link.click
    @browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
    @browser.log_in(@login, @password)
    @browser.empty_new_cart unless @params["do_merge_cart"]
		sleep 2
		
		@product_urls.each do |url|
			$tracer.trace("Product Url: #{url}")
			@browser.open("#{@start_page}#{url}")
			@browser.buy_first_panel.add_to_cart_button.click
			@browser.wait_for_landing_page_load
			@browser.cart_list.at(0).remove_button.should_exist # Validate item exists in the cart
			
			#Validation 1 - Check if update link doesn't exist in browser
			cart_update_link = false
			$tracer.trace("Validate if UPDATE LINK Exists ::: #{@browser.cart_list.at(0).update_link.exists}")
			cart_update_link.should == @browser.cart_list.at(0).update_link.exists
		end
    
		product_price = @browser.cart_list.at(0).price

    @browser.add_powerup_rewards_number(@params)
		$tracer.trace("Check subtotal and total")
		subtotal = @browser.check_cart_subtotal_and_discount(@params)
		
		@browser.wait_for_landing_page_load
		
		if @params["use_paypal_at_cart"]
			@browser.paypal_chkout_button.click
        # Log into PayPal sandbox
        $tracer.trace("Log Into PayPal")
				@browser.paypal_sandbox_login
        sleep 3
		else
			@browser.continue_checkout_button.click
		end
		@browser.wait_for_landing_page_load
		
		# Mature or Adult Audience confirmation page
		if @matured_product
			@browser.wait_for_landing_page_load
			@browser.seventeen_or_older_button.click
		end
		
		if @params["use_paypal_at_cart"]
			$tracer.trace("Continue through PayPal")
			@browser.paypal_test_acct_continue_button.click
			#Should be back on the gamestop.com handling options page now
			sleep 3
			$tracer.trace("----------RETURN TO GAMESTOP.COM AgeConfirmation page if MaturedProduct and/or HandlingOptions page if PhysicalProduct----------")     
			@browser.handle_mature_product_screen(@params) if @matured_product
      @browser.enter_handling_options(@params) if @physical_product				
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
				if @params["billing_address_same_as_shipping"]
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
				@browser.chkoutgift_message_field.should_exist	
				
				#Validation 2 - Handling options should not exist thus commenting the line below
				#@browser.enter_chkchandling_options_info(@shipping_option, @add_free_gift, @gift_msg)
			else
				#Verify Checkout page (Billing Address Info)
				$tracer.trace("Billing Address Info.")
				@browser.wait_for_landing_page_load
        @browser.validate_cookies_and_tags(@params)
				@browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
        @browser.check_checkout_billing_fields_exist
        @browser.continue_checkout_button.click
			end
			@browser.continue_checkout_button.click
		
			#Checkout - Payment Options
			$tracer.trace("Payment Options")
			@browser.wait_for_landing_page_load
			@browser.preview_order_button.should_exist
			
			@browser.order_summary_subtotal.should_exist
			@browser.order_summary_tax.should_exist
			@browser.handling_with_discount_amount.innerText.should == 'FREE!'
			@browser.order_summary_total.should_exist
		  
			order_summary_subtotal = money_string_to_decimal(@browser.order_summary_subtotal.innerText) 
			order_summary_tax = money_string_to_decimal(@browser.order_summary_tax.innerText) 
			
			# Validation 3 - Handling should be "FREE!" and must have a value of 0 (which is needed for the computation 
			order_summary_handling = 0
						
			$tracer.trace( "physical_product ::: #{@physical_product}")
			$tracer.trace( "order_summary_handling::: #{order_summary_handling}")
			$tracer.trace( "order_summary_subtotal::: #{@browser.order_summary_subtotal.innerText}")
			$tracer.trace( "order_summary_tax::: #{@browser.order_summary_tax.innerText}")
								
			order_summary_total = money_string_to_decimal(@browser.order_summary_total.innerText)
			order_summary_discount = BigDecimal.new("0")
			order_summary_discount = money_string_to_decimal(@browser.confirmation_page_discount.innerText) if @browser.confirmation_page_discount.exists
			total = order_summary_subtotal + order_summary_tax + order_summary_handling - order_summary_discount
			
			$tracer.trace( "total::: #{total}")
			
			$snapshots.setup(@browser, :all)
			order_summary_total.should == total
			
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
		
		#Submit the order only if the value of submit_order_flag from csv file is 'true'
		if @params["submit_order_flag"]
			$tracer.trace("Submitted Order")
			order_num = @browser.submit_and_confirm_order(@params, 'New')
			using_paypal = @params["use_paypal_at_cart"] || @params["use_paypal_at_payment"]
			@browser.check_confirmation_page_subtotal(subtotal) 
			
			if @physical_product
        $tracer.trace("Order Note")
        @browser.confirm_order_note.should_exist
        if !using_paypal
          $tracer.trace("Confirm Billing Address")
          @browser.check_billing_address_fields_exist
        end
      end
      @browser.check_confirmation_page_payment_method(using_paypal)
		end
	end
  
	
end

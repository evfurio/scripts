################################################################################################################################################################################################
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_MIXED_PRODUCTS_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48616 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --browser chrome --or #
################################################################################################################################################################################################
  
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
		
		$tracer.trace(' *** Clear Cart *** ')
    @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, account_login_parameter, account_password_parameter, @account_svc_version)
    @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
		@cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)
    @browser.open(@start_page)
		
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
		$tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)

    @browser.log_in_link.click
		@browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
		@browser.log_in(account_login_parameter, account_password_parameter)
		sleep 5
    @browser.empty_new_cart
		
		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, @cart_id, @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
		
		$tracer.trace("Open Gift Cards Page")
		@browser.gift_cards_link.click
		@browser.wait_for_landing_page_load
		
		gift_card_type = @params["GC_TYPE"].split("|")
    gift_card_amnt = @params["GC_AMNT"].split("|")
		gift_card_qty = @params["GC_QTY"].split("|")
		ctr = 0
		@total_amount = 0
		@physical_product = false
		@gc_is_other = false
		
		while ctr < gift_card_type.length do
			$tracer.trace("The default Card Type should be Digital Card.")
			digital_card_checked = @browser.choose_gift_card.at(ctr).digital_gift_card.call("checked")
			digital_card_checked.should == true
			
			if gift_card_type[ctr] == 'GiftCard'
				@browser.choose_gift_card.at(ctr).physical_gift_card.click
				@physical_product = true
			else
				@browser.choose_gift_card.at(ctr).digital_gift_card.click
			end

			$tracer.trace("The default Amount should be $10.")
			@browser.purchase_gift_card.at(ctr).gift_card_amounts.option[0].innerText.gsub('$', '').strip.should == '10'
			a = 0
			while a < @browser.purchase_gift_card.at(ctr).gift_card_amounts.option.length
				if @browser.purchase_gift_card.at(ctr).gift_card_amounts.option[a].innerText.gsub('$', '').strip == gift_card_amnt[ctr]
					@browser.purchase_gift_card.at(ctr).gift_card_amounts.option[a].click
					if @browser.purchase_gift_card.at(ctr).gift_card_amounts.option[a].innerText.include?('Other')
						@browser.purchase_gift_card.at(ctr).other_gift_amount.value = @params['GC_OTHER_AMNT']
						@other_amount = @browser.purchase_gift_card.at(ctr).other_gift_amount.value
						@gc_is_other = true
					end
				end
				a+=1
			end
				
			@browser.purchase_gift_card.at(ctr).gift_card_quantity.value = gift_card_qty[ctr] unless @params["GC_QTY"] == ''
			if @browser.purchase_gift_card.at(ctr).other_gift_amount.value == ''
				@calc_given_amount = gift_card_amnt[ctr].to_i * @browser.purchase_gift_card.at(ctr).gift_card_quantity.value.to_i
				@total_amount += @calc_given_amount
			else
				@calc_other_amount = @other_amount.to_i * @browser.purchase_gift_card.at(ctr).gift_card_quantity.value.to_i
				@total_amount += @calc_other_amount
			end			
			$tracer.trace("Total Gift Card Amount  :::::   #{@total_amount}")
			
			ctr+=1
			@browser.add_another_gift_card_button.click unless ctr==gift_card_type.length 
			@browser.wait_for_landing_page_load
		end
		@browser.add_gift_card_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Go through each item in the cart and set shipping method for ISPU")
		i = 0
		while i <  @browser.cart_list.length
			cart_item = @browser.cart_list.at(i)
			cart_item.remove_button.should_exist # Validate item exists in the cart
			cart_item.shipping_option_buttons.should_exist
			cart_item.availability_link.should_exist
			cart_item.shipping_option_buttons.value = "PickUpAtStore" if cart_item.availability_link.innerText.include?("Pre-order")
			i = i +1
		end

    @browser.add_powerup_rewards_number(@params)
		$tracer.trace("Check subtotal and total")
		subtotal = @browser.check_cart_subtotal_and_discount(@params)
		    
		@browser.continue_checkout_button.click
		
		if @matured_product
			$tracer.trace("Age verification for mature product")
			@browser.seventeen_or_older_button.click
		end		
		
		$tracer.trace("Fill out a shipping form if it exists.")	
		@browser.wait_for_landing_page_load
		$tracer.trace("Fill Out Shipping Address Form")
		@browser.fill_out_shipping_form(@params)
		@browser.wait_for_landing_page_load

		#Sign up for Weekly ad, offers and more
		$tracer.trace("Sign up for weekly ads? #{@params["sign_up_weekly_ads"] ? "Yes" : "No"}")
		@browser.chkoutweeklyadoffers_label.click if @params["sign_up_weekly_ads"]

		# Billing Address and shipping address same
		if @params["billing_address_same_as_shipping"]
			@browser.same_address_checkbox.click
		else
			@browser.continue_checkout_button.click
			sleep 4
			$tracer.trace("Billing Address Info (Physical).")
			@browser.fill_out_billing_form(@params)
		end		
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load		

		$tracer.trace("Handling Options")
		i = 0
		while i <  @browser.handling_options_page_panel.length
			panel = @browser.handling_options_page_panel.at(i)
			if  panel.title.innerText.eql? ("Items Shipping to Your Address")
				$tracer.trace("Handling Options for available product")
				panel.handling_method_buttons.value = @params["shipping_option"]
			elsif  panel.title.innerText.eql? ("Pick Up At Store")
				$tracer.trace("Choose Store For ISPU product")
				panel.choose_store_link.click
				sleep 5
				@browser.search_store_adress.should_exist
				@browser.search_store_adress.value = @params["ship_zip"]
				@browser.search_store_adress_button.should_exist
				@browser.search_store_adress_button.click
				# IMPORTANT: sleep is needed here to allow store search result to load before clicking on "choose store" link 
				sleep 5
				@browser.choose_store_button.should_exist
				@browser.choose_store_button.click
				@browser.wait_for_landing_page_load	
				@browser.ispu_phone_number.value = @params["bill_phone"]
			end
			i = i +1
		end
		
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
	  
		#Checkout - Payment Options
		$tracer.trace("Payment Options")
		@browser.validate_payment_options_and_total(@condition, @physical_product, @params)
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
			order_num = @browser.submit_and_confirm_order(@params, @condition)
			using_paypal = @params["use_paypal_at_cart"] || @params["use_paypal_at_payment"]
		  @browser.check_confirmation_page_subtotal(subtotal)
						
			$tracer.trace("Order Note")
			@browser.confirm_order_note.should_exist

			$tracer.trace("Confirm Billing Address")
			@browser.check_billing_address_fields_exist
      
      @browser.check_confirmation_page_payment_method(using_paypal) 
		end
	end
	
end
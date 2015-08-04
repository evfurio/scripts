
#Author### - dturner
#Modified  - Robert Ramirez
# 1/7/2012, New checkout script utilizting ATS tags and logic
# 1/8/2012, Assumptions:  Pre-existing user/login with biling and shipping addresses
# 1/29/2012, DT - Broke Authenicated and Guest user paths into their own test methods to reduce conditional logic complexities
# 3/01/2013, MK - moved authenticated user test into a separate file. Added assertions to check cart items, amounts and totals.
# $snapshots.setup(@browser, :all) 
# C:\Users\Public\d_con_output
	
################################################################################################################################################################################################
#                                                                                                                                                                                              # 
# d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_MIXED_PRODUCTS_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48615 --browser chrome --or #
#                                                                                                                                                                                              # 
################################################################################################################################################################################################
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
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
		$tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
    @browser.open(@start_page)
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do 
		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, '', @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
		
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
		@browser.chkoutbuy_as_guest_button.click
		
		if @matured_product
			$tracer.trace("Age verification for mature product")
			@browser.seventeen_or_older_button.click
		end		
		
		$tracer.trace("Fill out a shipping form if it exists.")	
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
        else
          @browser.continue_checkout_button.click
          sleep 4
          $tracer.trace("Billing Address Info (Physical).")
          @browser.fill_out_billing_form(@params)
          @browser.validate_cookies_and_tags(@params)
        end		
				
			$tracer.trace("Handling Options")
			@browser.continue_checkout_button.click
			@browser.wait_for_landing_page_load
		end
		
		i = 0
		while i <  @browser.handling_options_page_panel.length
			panel = @browser.handling_options_page_panel.at(i)
			if  panel.title.innerText.eql? ("Items Shipping to Your Address")
				$tracer.trace("Handling Options for available product")
				panel.handling_method_buttons.value = @params["shipping_option"]
			elsif  panel.title.innerText.eql? ("Pick Up At Store")
				$tracer.trace("Choose Store For ISPU product")
				panel.choose_store_link.click
				@browser.wait_for_landing_page_load
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
	  
		#Checkout - Payment Options
		$tracer.trace("Payment Options")
		@browser.wait_for_landing_page_load
		@browser.validate_payment_options_and_total(@condition, @physical_product, @params)
		@browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])

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

#Author### - dturner
#Modified  - Robert Ramirez
# 1/7/2012, New checkout script utilizting ATS tags and logic
# 1/8/2012, Assumptions:  Pre-existing user/login with biling and shipping addresses
# 1/29/2012, DT - Broke Authenicated and Guest user paths into their own test methods to reduce conditional logic complexities
# 3/01/2013, MK - moved authenticated user test into a separate file. Added assertions to check cart items, amounts and totals.
# 
################################################################################################################################################################################################
#                                                                                                                                                                                              # 
# d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48613 --browser chrome  --or #
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

describe "Guest Checkout GiftCard" do
	before(:all) do
		@browser = WebBrowser.new(browser_type_parameter)
		@browser.delete_internet_files(browser_type_parameter)
		$options.default_timeout = 10_000
		$snapshots.setup(@browser, :all)
		
		#Get the parameters from the csv dataset
    @params = $global_functions.csv
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
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
		
		### Error Handling for Gift Cards
		@error_on_other_amount = @browser.validate_gc_other_amount(@other_amount) if @gc_is_other
		# @error_on_qty_and_total = @browser.validate_gc_quantity(@params["GC_QTY"]) unless @browser.continue_checkout_button.exists == true
		if gift_card_type.length > 1 
			@error_on_total_amount = @browser.validate_gc_total_amount(@total_amount) unless @browser.continue_checkout_button.exists == true
		else
			@error_on_qty_and_total = @browser.validate_gc_quantity(@params["GC_QTY"]) unless @browser.continue_checkout_button.exists == true
		end

		# Proceed to Cart page and Continue checkout if @is_error is false
		if @error_on_other_amount!=true && @error_on_qty_and_total!=true && @error_on_total_amount!=true
			cart_total = @browser.calculate_cart_total
			subtotal = @browser.cart_subtotal_value.inner_text
			@browser.paypal_chkout_button.should_exist
			@browser.continue_checkout_button.click
			@browser.wait_for_landing_page_load	
			@browser.chkoutbuy_as_guest_button.click
			@browser.wait_for_landing_page_load
			
			if @physical_product == true
				$tracer.trace("Fill Out Shipping Address Form")
				@browser.fill_out_shipping_form(@params)
				# Billing Address and shipping address same
        if @params["billing_address_same_as_shipping"]
          @browser.same_address_checkbox.click
          @browser.continue_checkout_button.click
        else
          @browser.continue_checkout_button.click
          @browser.wait_for_landing_page_load
          $tracer.trace("Billing Address Info (Physical).")
          @browser.fill_out_billing_form(@params)
          @browser.continue_checkout_button.click
        end
      else
        $tracer.trace("Billing Address Info (Digital).")
        @browser.fill_out_billing_form(@params)
        @browser.chkoutpurchaseemail_label.value = @params["bill_email"]
        @browser.chkoutconfirmemail_bill_to_label.value = @params["bill_email"]
        @browser.continue_checkout_button.click
      end
			
			$tracer.trace("Handling Options")
			@browser.wait_for_landing_page_load
			@browser.continue_checkout_button.click			
			
			$tracer.trace("Payment Options")
			@browser.retry_until_found(lambda{@browser.order_summary_subtotal.exists != false}, 10)
			@browser.order_summary_subtotal.should_exist
			@browser.order_summary_tax.should_exist
			@browser.handling_with_discount_amount.should_exist
			@browser.order_summary_total.should_exist
			@browser.paypal_payment_selector.should_exist
			
			order_summary_subtotal = money_string_to_decimal(@browser.order_summary_subtotal.innerText) 
			order_summary_tax = money_string_to_decimal(@browser.order_summary_tax.innerText) 
			order_summary_total = money_string_to_decimal(@browser.order_summary_total.innerText)
			
			total = order_summary_subtotal + order_summary_tax 
			order_summary_total.should == total
			
			if @params["svs"].empty?
				$tracer.trace("Enter Credit Card Info")
				@browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])
			else
				$tracer.trace("Pay with Gift Card")
				svs_balance = @purchase_order_svc.perform_get_svs_balance(@params["svs"], @params["pin"], @session_id, @purchase_order_svc_version)
				@browser.enter_svs_info(@params["svs"], @params["pin"], svs_balance, order_summary_total)
				sleep 5
			end 

			#Submit the order only if the value of submit_order_flag from csv file is 'true'
			if @params["submit_order_flag"]
				$tracer.trace("Submitted Order")			
				@browser.submit_order
				@browser.validate_create_account_modal(@params)
				@browser.check_confirmation_page_subtotal(subtotal.gsub(/[$]/, '').to_f)
				
				@browser.confirm_order_note.should_exist
				
				@browser.confirm_billing_address_panel.confirm_billing_first_name_label.should_exist
				@browser.confirm_billing_address_panel.confirm_billing_last_name_label.should_exist
				@browser.confirm_billing_address_panel.confirm_billing_addr1_label.should_exist
				@browser.confirm_billing_address_panel.confirm_billing_city_label.should_exist
				@browser.confirm_billing_address_panel.confirm_billing_state_label.should_exist
				@browser.confirm_billing_address_panel.confirm_billing_zip_label.should_exist
				@browser.confirm_billing_address_panel.confirm_billing_country_label.should_exist
				 
				if @params["GC_TYPE"] == "GiftCard"
					@browser.confirm_shipping_address_panel.confirm_shipping_first_name_label.should_exist
					@browser.confirm_shipping_address_panel.confirm_shipping_last_name_label.should_exist
					@browser.confirm_shipping_address_panel.confirm_shipping_addr1_label.should_exist
					@browser.confirm_shipping_address_panel.confirm_shipping_city_label.should_exist
					@browser.confirm_shipping_address_panel.confirm_shipping_state_label.should_exist
					@browser.confirm_shipping_address_panel.confirm_shipping_zip_label.should_exist
					@browser.confirm_shipping_address_panel.confirm_shipping_country_label.should_exist
				end
				@browser.confirm_payment_panel.confirm_payment_type_label.should_exist
				@browser.confirm_payment_panel.confirm_payment_number_label.should_exist 
			end
		end	
			
	end

end
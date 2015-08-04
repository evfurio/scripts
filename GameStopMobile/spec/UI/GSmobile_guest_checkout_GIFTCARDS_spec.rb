## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\GSmobile_guest_checkout_GIFTCARDS_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\mobile_dataset.csv  --range GC01  --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "GSMobile GiftCards" do

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
		@browser.delete_all_cookies_and_verify
		@session_id = generate_guid
		@browser.open(@start_page)
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end
    
  it "#{$tc_id} #{$tc_desc}" do
		$tracer.trace("Open Gift Cards Page")
		@browser.search_field.value = 'gift card'
		@browser.send_keys(KeyCodes::KEY_RETURN)
		@browser.buy_gift_card_link.click
		
		gift_card_type = @params["GC_TYPE"].split("|")
    gift_card_amnt = @params["GC_AMNT"].split("|")
		ctr = 0
		@total_amount = 0
		@is_error = false
		while ctr < gift_card_type.length do
			$tracer.trace("The default Card Type should be Digital Card.")
			@browser.card_type_list.option[0].value.should == 'GiftCertificate'
			i = 0
			while i < @browser.card_type_list.option.length
				if @browser.card_type_list.option[i].value == gift_card_type[ctr]
					@browser.card_type_list.option[i].click
				end
				i+=1
			end
			@physical_product = true if gift_card_type[ctr] == 'GiftCard'

			$tracer.trace("The default Amount should be $10.")
			@browser.gift_amount_list.option[0].value.should == '10'
			a = 0
			while a < @browser.gift_amount_list.option.length
				if @browser.gift_amount_list.option[a].value == gift_card_amnt[ctr]
					@browser.gift_amount_list.option[a].click
					if @browser.gift_amount_list.option[a].value == 'Other'
						@browser.amount_text.value = @params['GC_OTHER_AMNT']
						@other_amount = @browser.amount_text.value.to_i
						case @other_amount
						when 0..9
							@browser.amount_error_message.innerText.should == '$10 Minimum Amount'
							$tracer.report("Error Message  ::: #{@browser.amount_error_message.innerText}    Got: $#{@other_amount}")
							@browser.wait_for_landing_page_load
							@is_error = true
						when 10..500
							$tracer.trace("OTHER Amount entered is within range.")
						else
							@browser.amount_error_message.innerText.should == '$500 Maximum Amount'
							$tracer.report("Error Message  ::: #{@browser.amount_error_message.innerText}    Got: $#{@other_amount}")
							@browser.wait_for_landing_page_load
							@is_error = true
						end
					end
				end
				a+=1
			end
			
			@browser.quantity_text.value = @params['GC_QTY'] 
			if @browser.quantity_text.value.include? "."
				@browser.quantity_error_message.innerText.should == 'Only whole numbers allowed'
				$tracer.report("Error Message  ::: #{@browser.quantity_error_message.innerText}    Got: #{@browser.quantity_text.value}")
				@browser.wait_for_landing_page_load
				@is_error = true
			else
				if @browser.quantity_text.value.to_i > 10
					@browser.quantity_error_message.innerText.should == 'Maximum Quantity is 10'
					$tracer.report("Error Message  :::  #{@browser.quantity_error_message.innerText}    Got: #{@browser.quantity_text.value.to_i}")
					@browser.wait_for_landing_page_load
					@is_error = true
				else
					$tracer.trace("Calculate Total amount.")
					if @browser.amount_text.value == '' 
						$tracer.trace("Gift Amount  ::: #{@browser.gift_amount_list.value.to_i}          Quantity  ::: #{@browser.quantity_text.value.to_i}")
						@amount = (@browser.gift_amount_list.value.to_i *	@browser.quantity_text.value.to_i)
					else
						$tracer.trace("OTHER Amount  ::: #{@browser.amount_text.value.to_i}          Quantity  ::: #{@browser.quantity_text.value.to_i}")
						@amount = (@browser.amount_text.value.to_i *	@browser.quantity_text.value.to_i)
					end
					$tracer.trace("This is the current amount  :::  #{@total_amount}")
					@total_amount = @total_amount + @amount
					
					$tracer.trace("Amount to be added to the current amount  :::  #{@amount}")
					if @total_amount > 500 && @other_amount <= 500
						@browser.quantity_error_message.innerText.should == 'Total not to Exceed $500' 
						$tracer.report("Error Message  :::  #{@browser.quantity_error_message.innerText}    Got: $#{@total_amount}")
						@browser.wait_for_landing_page_load
						@is_error = true
					end
				end	
			end
			ctr+=1
			@browser.a.id("addAnother").click unless ctr==gift_card_type.length 
			@browser.wait_for_landing_page_load
		end

		@browser.add_gc_to_cart.click if @is_error == false
		sleep 5
		
		if @params["continue_checkout"]
			$tracer.trace("Continue Secure Checkout")
			@browser.continue_checkout_button_handling.click
			@browser.wait_for_landing_page_load
			
			$tracer.trace("How Do You Want To Checkout? screen")
			@browser.buy_as_guest_button.click
			@browser.wait_for_landing_page_load
			
			if @physical_product 
				$tracer.trace("Shipping Address screen")
				@browser.show_order_summary_link.click
				@browser.enter_address_plus_email(@params["first_name"], @params["last_name"], @params["shipping_line1"], @params["shipping_city"], @params["shipping_state"], @params["shipping_zip"], @params["shipping_phone"], @params["shipping_email"]) 

				if @params["billing_address_same_as_shipping"]
					@browser.chkout_same_address_checkbox.checked = true
				else
					$tracer.trace("Billing Address screen")
					@browser.continue_checkout_button_handling.click
					@browser.wait_for_landing_page_load
					@browser.show_order_summary_link.click
					@browser.enter_billship_address(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"])           
				end
				@browser.continue_checkout_button_handling.click
				@browser.wait_for_landing_page_load
				
			else
				$tracer.trace("Billing Address screen - DLC Product")
				@browser.continue_checkout_button_handling.click
				@browser.wait_for_landing_page_load
				@browser.show_order_summary_link.click
				@browser.enter_billing_address_plus_email(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"], @params["billing_email"])           
				@browser.continue_checkout_button_handling.click
				@browser.wait_for_landing_page_load
			end

			$tracer.trace("Handling Options screen")
			@browser.continue_checkout_button_handling.click
			@browser.wait_for_landing_page_load

			$tracer.trace("Payment Options screen") 
			@browser.show_order_summary_link.click
			@browser.unused_promocode_message.should_not_exist
			
			@browser.cc_payment_option.click
			@browser.wait_for_landing_page_load
			if @params["svs_number"].empty?
				$tracer.trace("Pay With A Credit Card") 
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
			
			if @params["submit_order"]
				@browser.submit_order
				if not @params["valid_pur_svs_cc"]
					$tracer.trace("Please enter a valid credit card number.") 
					@browser.confirm_invalid_cc_warning
				else
					$tracer.trace("Order Confirmation screen") 
					@browser.validate_order_prefix("(5|8)1")
					@browser.validate_analytics(@params)
				end
			end
		end		
			
	end
end
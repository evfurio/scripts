require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

describe "Mass Orders Checkout" do
   csv = QACSV.new(csv_filename_parameter)
   @rows = csv.range(1, csv.max_row)
   
   # declaring the column #s which product ids appear between - columns 6-8 are the product ids.  This is needed to build the url strings to load the product into the cart
   	FIRST_PROD_IDX = 6
	LAST_PROD_IDX = 10

    before(:all) do
		dir = get_results_directory_name
		filename = dir + "/order_info.txt"
		@file = File.new(filename,"w")
        $options.default_timeout = 30_000

		@file.puts('Scenario Name,User Name, Tender Type, Order Number, Gift User, Gift Message')

		@start_page = "https://impulsestore.gamestop.com"
        @browser = ImpulseBrowser.new(browser_type_parameter)
		
        $snapshots.setup(@browser, :all)
        $tracer.mode = :on
        $tracer.echo = :on
				
		# # Log into PayPal sandbox
		# @browser.open("https://developer.paypal.com/cgi-bin/devscr?cmd=_logout")
		
		# # @browser.paypal_master_login_link.click
		# @browser.paypal_master_email_field.value = ""
		# @browser.paypal_master_email_field.value = "jonathanlafortune@gamestop.com"
		# @browser.paypal_master_password_field.value = "Tennis33"
		# @browser.paypal_master_login_button.click
		

    end

    before(:each) do
		@browser.open("#{@start_page}/cart")
		
		        # empty cart if logged in or not logged in
        @browser.empty_cart
		@browser.empty_cart_label.should_exist
        # # empty cart on guest (note: could have been already emptied)
        # @browser.log_out_cart_cl
        # @browser.empty_cart

		
			  @browser.open("https://impulsestore.gamestop.com/logout/")
    end
	
	after(:each) do

	
    end

    after(:all) do
		@file.close unless @file.nil?
        $tracer.trace("after :all")
        @browser.close_all
    end

    @rows.each do |row|
     
		# Define input values
		
		# currency_code = row.find_value_by_name("Currency Code")
	    scenario_name = row.find_value_by_name("Scenario")
	 
		# user_name_exists = row.find_value_by_name("PurchaserUserName")		
		fraud_flag = row.find_value_by_name("FraudFlag")
		gift_flag = row.find_value_by_name("Gift")
		discount = row.find_value_by_name("Discount")
		first_name = row.find_value_by_name("FirstName")
		last_name = row.find_value_by_name("LastName")
		company_name = row.find_value_by_name("Company")
		billing_street = row.find_value_by_name("BillingStreet")
		billing_city = row.find_value_by_name("BillingCity")
		billing_state_abrv = row.find_value_by_name("BillingState")
		billing_zip = row.find_value_by_name("BillingZip")
		tender_type1 = row.find_value_by_name("Tender1")
		tender_type2 = row.find_value_by_name("Tender2")
		tender_type3 = row.find_value_by_name("Tender3")
		pur_account = row.find_value_by_name("PUR")		
		
		# using the billing state abbreviation from the csv, determine the actual billing state to select from the dropdown in account information      
        case billing_state_abrv
			when "AA"
                billing_state = "Armed Forces America"
            when "AB"
				billing_state = "Alberta"
            when "AE"
				billing_state = "Armed Forces Other Areas"
            when "AK"
				billing_state = "Alaska"
            when "AL"
				billing_state = "Alabama"
            when "AP"
				billing_state = "Armed Forces Pacific"
			when "AR"
				billing_state = "Arkansas"
            when "AS"
				billing_state = "American Samoa"
            when "AZ"
				billing_state = "Arizona"
            when "BC"
				billing_state = "British Columbia"
			when "CA"
				billing_state = "California"
            when "CO"
				billing_state = "Colorado"
            when "CT"
				billing_state = "Connecticut"
            when "DC"
				billing_state = "District of Columbia"
            when "DE"
				billing_state = "Delaware"
            when "FL"
				billing_state = "Florida"
			when "FM"
				billing_state = "Micronesia"
			when "GA"
				billing_state = "Georgia"
			when "GU"
				billing_state = "Guam"
			when "HI"
				billing_state = "Hawaii"
			when "IA"
				billing_state = "Iowa"
			when "ID"
				billing_state = "Idaho"
			when "IL"
				billing_state = "Illinois"
			when "IN"
				billing_state = "Indiana"
			when "KS"
				billing_state = "Kansas"
			when "KY"
				billing_state = "Kentucky"
			when "LA"
				billing_state = "Louisiana"
			when "MA"
				billing_state = "Massachusetts"
			when "MB"
				billing_state = "Manitoba"
			when "MD"
				billing_state = "Maryland"
			when "ME"
				billing_state = "Maine"
			when "MH"
				billing_state = "Marshall Islands"
			when "MI"
				billing_state = "Michigan"
			when "MN"
				billing_state = "Minnesota"
			when "MO"
				billing_state = "Missouri"
			when "MP"
				billing_state = "Northern Mariana Islands"
			when "MS"
				billing_state = "Mississippi"
			when "MT"
				billing_state = "Montana"
			when "NB"
				billing_state = "New Brunswick"
			when "NC"
				billing_state = "North Carolina"
			when "ND"
				billing_state = "North Dakota"
			when "NE"
				billing_state = "Nebraska"
			when "NF"
				billing_state = "Newfoundland"
			when "NH"
				billing_state = "New Hampshire"
			when "NJ"
				billing_state = "New Jersey"
			when "NM"
				billing_state = "New Mexico"
			when "NS"
				billing_state = "Nova Scotia"
			when "NT"
				billing_state = "Northwest Territories"
			when "NV"
				billing_state = "Nevada"
			when "NY"
				billing_state = "New York"
			when "OH"
				billing_state = "Ohio"
			when "OK"
				billing_state = "Oklahoma"
			when "ON"
				billing_state = "Ontario"
			when "OR"
				billing_state = "Oregon"
			when "PA"
				billing_state = "Pennsylvania"
			when "PE"
				billing_state = "Prince Edward Island"
			when "PR"
				billing_state = "Puerto Rico"
			when "PW"
				billing_state = "Palau"
			when "QC"
				billing_state = "Quebec"
			when "RI"
				billing_state = "Rhode Island"
			when "SC"
				billing_state = "South Carolina"
			when "SD"
				billing_state = "South Dakota"
			when "SK"
				billing_state = "Saskatchewan"
			when "TN"
				billing_state = "Tennessee"
			when "TX"
				billing_state = "Texas"
			when "UT"
				billing_state = "Utah"
			when "VA"
				billing_state = "Virginia"
			when "VI"
				billing_state = "Virgin Islands"
			when "VT"
				billing_state = "Vermont"
			when "WA"
				billing_state = "Washington"
			when "WI"
				billing_state = "Wisconsin"
			when "WV"
				billing_state = "West Virginia"
			when "WY"
				billing_state = "Wyoming"
			when "YK"
				billing_state = "Yukon"
		end

		it "should successfully complete order  #{scenario_name}" do

			# Define the Purchase email address
			if fraud_flag == 'Y'
				def auto_generate_impulse_username(t = nil)
					t ||= Time.now
					return "ottomatin" + t.strftime("%Y%m%d_%H%M%S_%3N") + "@gspcauto.fav.cc"
				end
			else
				def auto_generate_impulse_username(t = nil)
					t ||= Time.now
					return "ottomatinNOFRAUD12345" + t.strftime("%Y%m%d_%H%M%S_%3N") + "@gspcauto.fav.cc"
				end
			end
			
		    user_name = auto_generate_impulse_username
			password = 'Manh0le1'
			
			# # Setup for PayPal
			# if tender_type1 == 'PayPal'
			    # # Make sure user is logged out of PayPal test store
				# @browser.open("https://sandbox.paypal.com")
					# if @browser.paypal_personal_tab.exists
					   # then  @browser.paypal_logout_link.click
					# end
			# end
			
			# view cart in order to change IP address first - go directly for performance increase
            # @browser.open("https://impulsestore.gamestop.com/cart.aspx")

            # # Country IP Address
            # @browser.ip_address_field.value = row.find_value_by_name("IP")
            # @browser.submit_button.click
            # #@browser.submit_button.click

            # Add product(s) to cart using specified url			
			list = [ ]
			for i in FIRST_PROD_IDX..LAST_PROD_IDX do
				list << row.find_value_at(i)
			end
			puts "lists contents: " + list.join(", ")
			
			for j in 0..(list.length - 1) do
				puts j.to_s
				puts list[j]
				if list[j] ==""
					puts "here"
					break
				end
				@browser.open("https://impulsestore.gamestop.com/cart.aspx?add&productID=#{list [j]}&theme=impulse")
			end
			
			# Verify the user is on the cart
			@browser.my_cart_label.should_exist			
			
			# If a coupon code is in the CSV file then add it to the cart
			unless discount == "None"
				@browser.coupon_field.value = discount
				@browser.apply_coupon_button.click
				@browser.cart_remove_coupon_link.should_exist
			end			
			
			# Click the Login link - NOT the continue button
			@browser.login_link.click
			
			# Create a new user
			@browser.create_account(user_name, password)
            
			# Verify the success page is displayed
            @browser.success_page_label.should_exist
            @browser.come_on_in_button.click			
			
			# Verify cart page is displayed
			@browser.my_cart_label.should_exist			
			@browser.cart_logout_link.should_exist
			@browser.cart_my_account_link.should_exist
			
			# If a PUR Account is in the CSV file then add it to the cart
			unless pur_account == "None"
				# Verify the PUR Card can be applied to the cart successfully
				@browser.cart_pur_number_field.value = pur_account
				@browser.cart_pur_save_button.click
				@browser.cart_pur_saved_label.should_exist
				@browser.cart_pur_number_label.should_exist
			end				
			
			# Check whether the order is a gft order and follow the process depending on which flow is used
			if gift_flag == "Y"
			
				# Define the giftee email address
				def auto_generate_impulse_gift_username(t = nil)
					t ||= Time.now
					return "giftee" + t.strftime("%Y%m%d_%H%M%S_%3N")  + "@gspcauto.fav.cc"
				end
				
				gift_user_name = auto_generate_impulse_gift_username
				gift_message = row.find_value_by_name("GiftMessage")
				
				# Click the Purchase as Gift button
				@browser.purchase_as_gift_button.click
				
				# Enter Shipping/Billing Information
				@browser.billing_information_label.should_exist
				@browser.first_name_field.value = first_name
				@browser.last_name_field.value = last_name
				@browser.company_field.value = company_name				
				#@browser.company_billing_info_field.value = company_name
				@browser.street_address_field.value = billing_street
				@browser.city_field.value = billing_city
				@browser.state_selector.value = billing_state
				@browser.zip_code_field.value = billing_zip
				@browser.phone_number_field.value = "999-999-9999"
				
				# Enter Gift Information
				@browser.email_or_nickname_field.value = gift_user_name
				@browser.confirm_email_or_nickname_field.value = gift_user_name
				@browser.message_field.value = gift_message

				else
				
				gift_user_name = 'none'
				gift_message = 'none'
			
				# Click on Checkout button
				@browser.checkout_button.click
			
				# Enter Shipping/Billing Information
				@browser.billing_information_label.should_exist
				@browser.first_name_field.value = first_name
				@browser.last_name_field.value = last_name
				
				@browser.company_field.value = company_name				
				#@browser.company_billing_info_field.value = company_name
				@browser.street_address_field.value = billing_street
				@browser.city_field.value = billing_city
				@browser.state_selector.value = billing_state
				@browser.zip_code_field.value = billing_zip
				@browser.phone_number_field.value = "999-999-9999"			
		
			end
			
		
			# Click continue button on billing info/gift page
			@browser.continue_button.click	

			@browser.checkout_payment_information_label.should_exist
			
			if tender_type1 == 'PayPal'
				# Select PayPal button and continue
				@browser.input.id("_Content__RadioPaymentMethodPaypal").click # needs finder/ATS class tag for PayPal radio button
				@browser.continue_button.click
				
				
				# # Check if Impulse  Sandbox test store is displayed
				# if @browser.url.include? "express-checkout&token="
				
				# else
				
				# end
				
				# # Log into PayPal sandbox
				# @browser.paypal_master_login_link.click
				# @browser.paypal_master_email_field.value = ""
				# @browser.paypal_master_email_field.value = "jonathanlafortune@gamestop.com"
				# @browser.paypal_master_password_field.value = "Tennis33"
				# @browser.paypal_master_login_button.click
				
				
				
				# Make sure user is logged out of PayPal test store
				@browser.open("https://www.sandbox.paypal.com/us/cgi-bin/webscr?cmd=_login-submit")
				if @browser.paypal_personal_tab.exists
				   then  @browser.paypal_logout_link.click
				else 
					@browser.paypal_master_login_link.click
				end
				
				# Log into PayPal sandbox
				@browser.paypal_master_email_field.value = "clovasgs@gmail.com"
				@browser.paypal_master_password_field.value = "Gamestop24"
				@browser.paypal_master_login_button.click
				
				# Go back to Cart page now that user is logged in with master acct
				@browser.open("https://impulsestore.gamestop.com/cart")
				
				# # Now that user is logged into main PayPal sandbox, repeat process in cart
				@browser.checkout_button.click
				@browser.payment_method_buttons.value = "Pay using PayPal"
				@browser.continue_button.click
				
				# User is taken to sandbox test store b/c they're already logged into the main test area
				@browser.paypal_test_acct_login_field.value = "clovas_1307123304_per@gmail.com"
				@browser.paypal_test_acct_password_field.value = "Gamestop24"
				@browser.paypal_test_acct_login_button.click
				
				# verify user is logged in and on the specify payment/shipping/billing info page
				@browser.paypal_shipping_address_panel.exists
				
				# select a payment shipping address (a test account can have multiple shipping addresses...)
				@browser.paypal_test_acct_continue_button.click
				
				# user should be taken back to store on the review/submit page
				@browser.img.className("/image_paypal/").exists #needs impulse store finder / ATS class tag
			else
				# Enter Tender Information
				case tender_type1 
					when "Visa"
						@browser.credit_card_selector.value = "Visa"
						@browser.credit_card_number_field.value = "4012888888881881"
						@browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
						@browser.credit_card_month_selector.value = "12"
						@browser.credit_card_year_selector.value = "2015"
						@browser.credit_card_security_code_field.value = "gs01"
						
					when "Discover"
						@browser.credit_card_selector.value = "DiscoverCard"
						@browser.credit_card_number_field.value = "6011000990139424"
						@browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
						@browser.credit_card_month_selector.value = "12"
						@browser.credit_card_year_selector.value = "2015"
						@browser.credit_card_security_code_field.value = "gs01"
						
					when  "American Express"
						@browser.credit_card_selector.value = "American Express"
						@browser.credit_card_number_field.value = "378734493671000"
						@browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
						@browser.credit_card_month_selector.value = "12"
						@browser.credit_card_year_selector.value = "2015"
						@browser.credit_card_security_code_field.value = "gs01"				
					
					when  "MasterCard"
						@browser.credit_card_selector.value = "MasterCard"
						@browser.credit_card_number_field.value = "5105105105105100"
						@browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
						@browser.credit_card_month_selector.value = "12"
						@browser.credit_card_year_selector.value = "2015"
						@browser.credit_card_security_code_field.value = "gs01"				
						
					when "Gift Card"
						@browser.store_gift_card_number_field.value = "6364911004999900255"
						@browser.store_gift_card_pin_field.value = "0800"
						@browser.store_apply_gift_card_button.click
						
					when "Loyalty"
						@browser.store_gift_card_number_field.value = "6364913881999900338"
						@browser.store_gift_card_pin_field.value = "2015"
						@browser.store_apply_gift_card_button.click

				end
			end

			
			#Check if there is a second payment type of Gift Card or Loyalty Card
			case tender_type2 
				when "Visa"
					@browser.credit_card_selector.value = "Visa"
					@browser.credit_card_number_field.value = "4012888888881881"
					@browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
					@browser.credit_card_month_selector.value = "12"
					@browser.credit_card_year_selector.value = "2015"
					@browser.credit_card_security_code_field.value = "gs01"
					
				when "Discover"
					@browser.credit_card_selector.value = "DiscoverCard"
					@browser.credit_card_number_field.value = "6011000990139424"
					@browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
					@browser.credit_card_month_selector.value = "12"
					@browser.credit_card_year_selector.value = "2015"
					@browser.credit_card_security_code_field.value = "gs01"
					
				when  "American Express"
					@browser.credit_card_selector.value = "American Express"
					@browser.credit_card_number_field.value = "378734493671000"
					@browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
					@browser.credit_card_month_selector.value = "12"
					@browser.credit_card_year_selector.value = "2015"
					@browser.credit_card_security_code_field.value = "gs01"	
				
				when  "MasterCard"
					@browser.credit_card_selector.value = "MasterCard"
					@browser.credit_card_number_field.value = "5105105105105100"
					@browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
					@browser.credit_card_month_selector.value = "12"
					@browser.credit_card_year_selector.value = "2015"
					@browser.credit_card_security_code_field.value = "gs01"									
					
				when "Gift Card"
					@browser.store_gift_card_number_field.value = "6364911004999900255"
					@browser.store_gift_card_pin_field.value = "0800"
					@browser.store_apply_gift_card_button.click
					
				when "Loyalty"
					@browser.store_gift_card_number_field.value = "6364913881999900338"
					@browser.store_gift_card_pin_field.value = "2015"
					@browser.store_apply_gift_card_button.click
			
			end
			
			#Check if there is a third payment type of Gift Card or Loyalty Card
			case tender_type3 
				when "Visa"
					@browser.credit_card_selector.value = "Visa"
					@browser.credit_card_number_field.value = "4012888888881881"
					@browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
					@browser.credit_card_month_selector.value = "12"
					@browser.credit_card_year_selector.value = "2015"
					@browser.credit_card_security_code_field.value = "gs01"
					
				when "Discover"
					@browser.credit_card_selector.value = "DiscoverCard"
					@browser.credit_card_number_field.value = "6011000990139424"
					@browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
					@browser.credit_card_month_selector.value = "12"
					@browser.credit_card_year_selector.value = "2015"
					@browser.credit_card_security_code_field.value = "gs01"
					
				when  "American Express"
					@browser.credit_card_selector.value = "American Express"
					@browser.credit_card_number_field.value = "378734493671000"
					@browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
					@browser.credit_card_month_selector.value = "12"
					@browser.credit_card_year_selector.value = "2015"
					@browser.credit_card_security_code_field.value = "gs01"	
					
				when  "MasterCard"
					@browser.credit_card_selector.value = "MasterCard"
					@browser.credit_card_number_field.value = "5105105105105100"
					@browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
					@browser.credit_card_month_selector.value = "12"
					@browser.credit_card_year_selector.value = "2015"
					@browser.credit_card_security_code_field.value = "gs01"								
					
				when "Gift Card"
					@browser.store_gift_card_number_field.value = "6364911004999900255"
					@browser.store_gift_card_pin_field.value = "0800"
					@browser.store_apply_gift_card_button.click
					
				when "Loyalty"
					@browser.store_gift_card_number_field.value = "6364913881999900338"
					@browser.store_gift_card_pin_field.value = "2015"
					@browser.store_apply_gift_card_button.click
			
			end
			
            if tender_type1 != 'PayPal'
				@browser.continue_button.click
			end

            # checkout review
            @browser.checkout_review_and_submit_label.should_exist
			
            @browser.submit_order_button.click

			# Retrieve Order #
			link = @browser.order_number_link
			link.should_exist
			$tracer.trace("Scenario: " + scenario_name)
			$tracer.trace("Order Number: " + link.innerText)

			@file.puts(scenario_name + ',' + user_name + ',' + tender_type1 + ',' + link.innerText + ',' + gift_user_name + ',' + gift_message )
			# @file.puts(scenario_name)
			# @file.puts(link.innerText)	
			
			@browser.order_details_button.click			
				
			# Output HTML and snapshot
			@browser.create_snapshot_and_html

            # determine omniture data value
            src = @browser.source
		
			if src.include? "Your order is queued for processing."
				# If the Order is Frauded
				$tracer.trace("Fraud Queue Order")		
			end
			
        end

    end
end



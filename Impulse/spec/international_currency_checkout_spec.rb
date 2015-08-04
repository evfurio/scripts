require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

   # Returns the Currency Type Label (Cart)
  def currency_cart_label_3
    $tracer.trace( "I am Here" )
	$tracer.trace(__method__)
    return ToolTag.new(self.span.className("/currency/"), __method__)
  end

describe "International Currency Checkout" do
   csv = QACSV.new(csv_filename_parameter)
   @rows = csv.range(1, csv.max_row)

    before(:all) do
        $options.default_timeout = 30_000

        @start_page = "http://www.impulsedriven.com"
        if os_name == "darwin"
            @browser = ImpulseBrowser.new.safari
        else
            @browser = ImpulseBrowser.new.ie
        end

        $snapshots.setup(@browser, :all)
        $tracer.mode = :on
        $tracer.echo = :on
    end

    before(:each) do
      @browser.open("https://impulsestore.gamestop.com/cart.aspx?clear")
	 
	 def auto_generate_impulse_username(t = nil)
		t ||= Time.now
     return "ottomatin+intl" + t.strftime("%H%M%S_%3N")  + "@gmail.com"
     end
	  
    end
	
	after(:each) do
			@browser.open("https://impulsestore.gamestop.com/logout/")
	
    end

    after(:all) do
        $tracer.trace("after :all")
        @browser.close_all
    end

    @rows.each do |row|
       currency_code = row.find_value_by_name("Currency Code")

        it "should successfully purchase product using an international currency #{currency_code}" do
		
		    user_name = auto_generate_impulse_username
			password = 'Manh0le1'
			first_name = 'Otto'
			last_name = 'Matinne'
            
			# view cart in order to change IP address first - go directly for performance increase
            @browser.open("https://impulsestore.gamestop.com/cart.aspx")

            # Country IP Address
            @browser.ip_address_field.value = row.find_value_by_name("IP")
            @browser.submit_button.click
            #@browser.submit_button.click

            # Add product to cart using specified url
            product_id = row.find_value_by_name("Product 1")
            @browser.open("https://impulsestore.gamestop.com/cart.aspx?add&productID=#{product_id}&theme=impulse")

			currency_type = row.find_value_by_name("Currency Code")
			@browser.currency_label.innerText.should include "#{currency_type}"
			$tracer.trace("currency - #{currency_type}")

			# $tracer.trace("I AM HERE!!!!!")
			
			# currency_type = row.find_value_by_name("Currency Code")
					# $tracer.trace("currency - #{currency_type}")
			
			# cart_currency=@browser.currency_cart_label_3.innerText
					# $tracer.trace("cart currency - #{cart_currency}")
			
			# # @browser.currency_cart_label.innerText == /currency_type/
			# $tracer.trace("Currency Type: " + @browser.currency_cart_label.innerText)

			@browser.checkout_button.click
            # login
            # @browser.login_link.click
            # @browser.email_address_field.value = row.find_value_by_name("User ID")
            # @browser.password_field.value = row.find_value_by_name("Password")
            # @browser.sign_in_button.click
			
			# @browser.continue_button.click	
			@browser.create_account_button.click
		    @browser.email_address_field.value = user_name
			@browser.confirm_email_address_field.value = user_name
			@browser.password_field.value = password
			@browser.confirm_password_field.value = password
			@browser.promotions_and_special_offers_opt_in_checkbox.checked = false
			@browser.continue_button.click	


			
			# Kept for use with new user setup
			# @browser.first_name_field.value = first_name
			# @browser.last_name_field.value = last_name
			# @browser.street_address_field.value = "123 High Point Dr"
			# @browser.city_field.value = "Irving"
			# @browser.state_selector.value = "Texas"
			# @browser.zip_code_field.value = "75038"
			#@browser.phone_number_field.value = "999-999-9999"
			@browser.billing_information_label.should_exist
			@browser.enter_address(
				first_name,
				last_name,
				"111 High Point Dr",
				"Irving",
				"Texas",
				"75038",
				"214-555-1212",
				row.find_value_by_name("Country Name")
			)

			
			@browser.continue_button.click

            # use rewards card for payment (defaulted as long as $$ exist on card -- NOTE: this get around fraud rules)
			# Enter CC Info
        @browser.checkout_payment_information_label.should_exist
        @browser.enter_credit_card_info(
            "American Express",
            "371449635398431",
            "#{first_name} #{last_name}",
            "12",
            "2013",
            "gs01"
        )
			
            @browser.continue_button.click

            # checkout review
            @browser.checkout_review_and_submit_label.should_exist
            @browser.submit_order_button.click

			# Retrieve Order #
			link = @browser.order_number_link
			link.should_exist
			$tracer.trace("Order Number: " + link.innerText)
				
			# Output HTML and snapshot
			@browser.create_snapshot_and_html

            # determine omniture data value
            src = @browser.source

		
			if src.include? "Your order is queued for processing."
				# If the Order is Frauded
				# Check to ensure Omniture gs.products section does not exist
				$tracer.trace("Fraud Queue -  Omniture Data should not be Sent")		
				src.should_not == /gs.products/
				pending("Fraud Order - Omniture Data not sent")
			else
				# If the Order is Processed Successfully
				omniture_product_str = /(gs.products\s*=\s*')(.*)'/.match(src)[2].strip
				omniture_price = omniture_product_str.split(';')[3].strip
			
				$tracer.trace("omniture price = #{omniture_price}")
				
				expected_omniture_price = row.find_value_by_name("Omniture Price").strip
				
				$tracer.trace("expected omniture price = #{expected_omniture_price}")
				expected_omniture_price.should == omniture_price
			end
			
			
        end

    end
end



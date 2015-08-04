require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

describe "Omniture PageName Variable Suite" do
    csv = QACSV.new(csv_filename_parameter)
    @rows = csv.range(1, csv.max_row)

    before(:all) do
        $options.default_timeout = 30_000

        @start_page = "https://impulsestore.gamestop.com"
        @browser = ImpulseBrowser.new(browser_type_parameter)

        $snapshots.setup(@browser, :all)
        $tracer.mode = :on
        $tracer.echo = :on
    end

    before(:each) do
        @browser.open("#{@start_page}/cart")
        @browser.log_out_cart
		@browser.open("https://qa1.impulsestore.gamestop.com/logout/")
        @browser.empty_cart

        # def auto_generate_impulse_username(t = nil)
        # t ||= Time.now
        # return "ottomatin+" + t.strftime("%H%M%S_%3N")  + "@gmail.com"
        # end

    end

    after(:all) do
        $tracer.trace("after :all")
        @browser.close_all
    end

    @rows.each do |row|
        impulse_page = row.find_value_by_name("ImpulsePageName")
        omniture_variable_name = row.find_value_by_name("OmniturePageName")
        page_url= row.find_value_by_name("PageURL")

        it "should verify the Omniture PageName Variable on the #{impulse_page}" do
            @browser.open("#{page_url}")

            # Output HTML and snapshot
            @browser.create_snapshot_and_html

            # determine omniture data value
            src = @browser.source

            omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
            omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

            $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

            expected_omniture_pagename_var = ("#{omniture_variable_name}")

            $tracer.trace("Expected Omniture PageName Variable = #{expected_omniture_pagename_var}")

            omniture_pagename_var.should == expected_omniture_pagename_var

        end

    end


    it "should verify the Omniture PageName Variable on the Impulse Age Gate Failure page" do
        @browser.open("http://www.impulsedriven.com/deus3")

        $tracer.trace("continue_button")
        tag = ToolTag.new(@browser.input.value("/Submit/"), "submit_button")
        tag.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # determine omniture data value
        src = @browser.source

        omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
        omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

        $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

        expected_omniture_pagename_var =  ("im: age gate fail: deus ex human revolution [po]")

        $tracer.trace("Expected Omniture PageName Variable = #{expected_omniture_pagename_var}")

        omniture_pagename_var.should == expected_omniture_pagename_var

    end

    # # it "should verify the Omniture PageName Variable on the Impulse Redemption Success page" do
    # # @browser.open("https://impulsestore.gamestop.com/login")

    # # # Output HTML and snapshot
    # # @browser.create_snapshot_and_html

    # # # determine omniture data value
    # # src = @browser.source

    # # omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
    # # omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

    # # $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

    # # expected_omniture_pagename_var =  ("im: redemption: redemption success")

    # # $tracer.trace("Expected Omniture PageName Variable = #{omniture_pagename_var}")

    # # omniture_pagename_var.should == expected_omniture_pagename_var

    # # end

    it "should verify the Omniture PageName Variable on the Impulse Checkout - Login page" do
        @browser.open("https://impulsestore.gamestop.com/cart.aspx?add&productID=ESD-IMP-W1309&theme=impulse")

        @browser.my_cart_label.should_exist
        @browser.checkout_button.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # determine omniture data value
        src = @browser.source

		
		omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
        omniture_pagename_var = omniture_pagename_str.split(';')[0].strip
        
		# the following breakout of the omniture pagename variable uses " instead of '
        # omniture_pagename_str = /(gs.pageName\s*=\s*")(.*)"/.match(src)[2].strip
        # omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

        $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

        expected_omniture_pagename_var =  ("im: checkout: login")

        $tracer.trace("Expected Omniture PageName Variable = #{expected_omniture_pagename_var}")

        omniture_pagename_var.should == expected_omniture_pagename_var

    end

    it "should verify the Omniture PageName Variable on the Impulse Checkout - Billing & Shipping page" do
        @browser.open("https://impulsestore.gamestop.com/cart.aspx?add&productID=ESD-IMP-W1309&theme=impulse")

        @browser.my_cart_label.should_exist
        @browser.create_account_link.click

        def auto_generate_impulse_username(t = nil)
            t ||= Time.now
            return "ottomatin" + t.strftime("%Y%m%d_%H%M%S_%3N") + "@gspcauto.fav.cc"
                end

        user_name = auto_generate_impulse_username
        password = 'Manh0le1'
        first_name = 'Otto'
        last_name = 'Matin'

        @browser.create_account(user_name, password)

        @browser.success_page_label.should_exist
        @browser.continue_button.click

        @browser.view_cart_link.click

        #Click Checkout
        @browser.checkout_button.click	

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # determine omniture data value
        src = @browser.source

        omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
        omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

        $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

        expected_omniture_pagename_var =  ("im: checkout: billing and shipping")

        $tracer.trace("Expected Omniture PageName Variable = #{expected_omniture_pagename_var}")

        omniture_pagename_var.should == expected_omniture_pagename_var


    end

    it "should verify the Omniture PageName Variable on the Impulse Checkout - Payment Method page" do
        @browser.open("https://impulsestore.gamestop.com/cart.aspx?add&productID=ESD-IMP-W1309&theme=impulse")

        @browser.my_cart_label.should_exist
        @browser.create_account_link.click

        def auto_generate_impulse_username(t = nil)
            t ||= Time.now
            return "ottomatin" + t.strftime("%Y%m%d_%H%M%S_%3N") + "@gspcauto.fav.cc"
        end

        user_name = auto_generate_impulse_username
        password = 'Manh0le1'
        first_name = 'Otto'
        last_name = 'Matin'

        @browser.create_account(user_name, password)

        @browser.success_page_label.should_exist
        @browser.continue_button.click

        @browser.view_cart_link.click

        #Click Checkout
        @browser.checkout_button.click	

        # Kept for use with new user setup
        @browser.first_name_field.value = first_name
        @browser.last_name_field.value = last_name
        @browser.street_address_field.value = "123 High Point Dr"
        @browser.city_field.value = "Irving"
        @browser.state_selector.value = "Texas"
        @browser.zip_code_field.value = "75038"
        @browser.phone_number_field.value = "999-999-9999"
        @browser.continue_button.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # determine omniture data value
        src = @browser.source

        omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
        omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

        $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

        expected_omniture_pagename_var =  ("im: checkout: payment method")
        $tracer.trace("Expected Omniture PageName Variable = #{expected_omniture_pagename_var}")

        omniture_pagename_var.should == expected_omniture_pagename_var

    end

    it "should verify the Omniture PageName Variable on the Impulse Checkout - Review & Submit page" do
        @browser.open("https://impulsestore.gamestop.com/cart.aspx?add&productID=ESD-IMP-W1309&theme=impulse")

        @browser.my_cart_label.should_exist
        @browser.create_account_link.click

        def auto_generate_impulse_username(t = nil)
            t ||= Time.now
            return "ottomatin" + t.strftime("%Y%m%d_%H%M%S_%3N") + "@gspcauto.fav.cc"
        end

        user_name = auto_generate_impulse_username
        password = 'Manh0le1'
        first_name = 'Otto'
        last_name = 'Matin'

        @browser.create_account(user_name, password)

        @browser.success_page_label.should_exist
        @browser.continue_button.click

        @browser.view_cart_link.click

        #Click Checkout
        @browser.checkout_button.click	

        # Kept for use with new user setup
        @browser.first_name_field.value = first_name
        @browser.last_name_field.value = last_name
        @browser.street_address_field.value = "123 High Point Dr"
        @browser.city_field.value = "Irving"
        @browser.state_selector.value = "Texas"
        @browser.zip_code_field.value = "75038"
        @browser.phone_number_field.value = "999-999-9999"
        @browser.continue_button.click

        # Enter CC Info
        @browser.credit_card_selector.value = "Visa"
        @browser.credit_card_number_field.value = "4222222222222"
        @browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
        @browser.credit_card_month_selector.value = "03"
        @browser.credit_card_year_selector.value = "2014"
        @browser.credit_card_security_code_field.value = "gs01"
        @browser.continue_button.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # determine omniture data value
        src = @browser.source

        omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
        omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

        $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

        expected_omniture_pagename_var =  ("im: checkout: review & submit")
        $tracer.trace("Expected Omniture PageName Variable = #{expected_omniture_pagename_var}")

        omniture_pagename_var.should == expected_omniture_pagename_var

    end

    it "should verify the Omniture PageName Variable on the Impulse Checkout - Order Confirmation page" do
        @browser.open("https://impulsestore.gamestop.com/cart.aspx?add&productID=ESD-IMP-W1309&theme=impulse")

        @browser.my_cart_label.should_exist
        @browser.create_account_link.click

        def auto_generate_impulse_username(t = nil)
            t ||= Time.now
            return "ottomatin" + t.strftime("%Y%m%d_%H%M%S_%3N") + "@gspcauto.fav.cc"
        end

        user_name = auto_generate_impulse_username
        password = 'Manh0le1'
        first_name = 'Otto'
        last_name = 'Matin'

        @browser.create_account(user_name, password)

        @browser.success_page_label.should_exist
        @browser.continue_button.click

        @browser.view_cart_link.click

        #Click Checkout
        @browser.checkout_button.click

        # Kept for use with new user setup
        @browser.first_name_field.value = first_name
        @browser.last_name_field.value = last_name
        @browser.street_address_field.value = "123 High Point Dr"
        @browser.city_field.value = "Irving"
        @browser.state_selector.value = "Texas"
        @browser.zip_code_field.value = "75038"
        @browser.phone_number_field.value = "999-999-9999"
        @browser.continue_button.click

        # Enter CC Info
        @browser.credit_card_selector.value = "Visa"
        @browser.credit_card_number_field.value = "4222222222222"
        @browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
        @browser.credit_card_month_selector.value = "03"
        @browser.credit_card_year_selector.value = "2014"
        @browser.credit_card_security_code_field.value = "gs01"
        @browser.continue_button.click

        @browser.submit_order_button.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # determine omniture data value
        src = @browser.source

        omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
        omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

        $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

        expected_omniture_pagename_var =  ("im: checkout: order confirmation")
        $tracer.trace("Expected Omniture PageName Variable = #{expected_omniture_pagename_var}")

        omniture_pagename_var.should == expected_omniture_pagename_var

    end

    it "should verify the Omniture PageName Variable on the Impulse My Account - My Account page" do
        @browser.open("https://impulsestore.gamestop.com/cart.aspx?theme=impulse3")

        @browser.login_link.click
        @browser.log_in("ottomatin@gmail.com", "Manh0le1")

        @browser.cart_my_account_link.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # determine omniture data value
        src = @browser.source

        omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
        omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

        $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

        expected_omniture_pagename_var =  ("im: my account: my account")
        $tracer.trace("Expected Omniture PageName Variable = #{expected_omniture_pagename_var}")

        omniture_pagename_var.should == expected_omniture_pagename_var

    end	

    it "should verify the Omniture PageName Variable on the Impulse My Account - Update Billing Info page" do
        @browser.open("https://impulsestore.gamestop.com/cart.aspx?theme=impulse3")

        @browser.login_link.click
        @browser.log_in("ottomatin@gmail.com", "Manh0le1")

        @browser.cart_my_account_link.click

        @browser.change_billing_information_link.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # determine omniture data value
        src = @browser.source

        omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
        omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

        $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

        expected_omniture_pagename_var =  ("im: my account: update billing info")
        $tracer.trace("Expected Omniture PageName Variable = #{expected_omniture_pagename_var}")

        omniture_pagename_var.should == expected_omniture_pagename_var

    end

    # # it "should verify the Omniture PageName Variable on the Impulse My Account - Change Password page" do
    # # @browser.open("https://impulsestore.gamestop.com/cart.aspx?theme=impulse3")

    # # @browser.login_link.click
    # # @browser.email_address_field.value = "ottomatin@gmail.com"
    # # @browser.password_field.value = "Manh0le1"
    # # @browser.sign_in_button.click	

    # # @browser.cart_my_account_link.click

    # # @browser.change_password_link.click

    # # # Output HTML and snapshot
    # # @browser.create_snapshot_and_html

    # # # determine omniture data value
    # # src = @browser.source

    # # omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
    # # omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

    # # $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

    # # expected_omniture_pagename_var =  ("im: my account: change password")
    # # $tracer.trace("Expected Omniture PageName Variable = #{expected_omniture_pagename_var}")

    # # omniture_pagename_var.should == expected_omniture_pagename_var

    # # end	

    it "should verify the Omniture PageName Variable on the Impulse My Account - Past Orders page" do
        @browser.open("https://impulsestore.gamestop.com/cart.aspx?theme=impulse3")

        @browser.login_link.click
        @browser.log_in("ottomatin@gmail.com", "Manh0le1")

        @browser.cart_my_account_link.click

        @browser.print_invoices_link.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # determine omniture data value
        src = @browser.source

        omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
        omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

        $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

        expected_omniture_pagename_var =  ("im: my account: past orders")
        $tracer.trace("Expected Omniture PageName Variable = #{expected_omniture_pagename_var}")

        omniture_pagename_var.should == expected_omniture_pagename_var

    end

    it "should verify the Omniture PageName Variable on the Impulse My Account - Gift Cards page" do
        @browser.open("https://impulsestore.gamestop.com/cart.aspx?theme=impulse3")

        @browser.login_link.click
        @browser.log_in("ottomatin@gmail.com", "Manh0le1")

        @browser.cart_my_account_link.click

        @browser.view_unredeemed_gift_cards_link.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # determine omniture data value
        src = @browser.source

        omniture_pagename_str = /(gs.pageName\s*=\s*')(.*)'/.match(src)[2].strip
        omniture_pagename_var = omniture_pagename_str.split(';')[0].strip

        $tracer.trace("Omniture PageName Variable = #{omniture_pagename_var}")

        expected_omniture_pagename_var =  ("im: my account: gift card")
        $tracer.trace("Expected Omniture PageName Variable = #{expected_omniture_pagename_var}")

        omniture_pagename_var.should == expected_omniture_pagename_var

    end


end

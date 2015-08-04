require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"


describe "Impulse Store Smoke Suite" do

    before(:all) do
        csv = QACSV.new(csv_filename_parameter)
        @row = csv.find_row_by_name(csv_range_parameter)

        # Environment Prefix to use in URLs
        @web_env_prefix = ("http://" + @row.find_value_by_name("Env_Prefix"))
        @secure_env_prefix = ("https://" + @row.find_value_by_name("Env_Prefix"))

        # URL domains to use and validate against
        @web_domain = "www.impulsedriven.com/"
        @store_domain = "impulsestore.gamestop.com/"
        @developer_domain = "developer.impulsedriven.com/"

        @start_page = (@secure_env_prefix + @store_domain + "cart.aspx")
        @cart_logout =  "#{@secure_env_prefix}#{@store_domain}logout"
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
        @browser.open(@start_page)

        # # empty cart if logged in or not logged in
        # @browser.empty_cart

        # empty cart on guest (note: could have been already emptied)
        @browser.open(@cart_logout)
        @browser.log_out_cart
        @browser.empty_cart

        def auto_generate_impulse_username(t = nil)
            t ||= Time.now
            # return "ottomatin_" + t.strftime("%H%M%S") + "@gspcauto.fav.cc"
            return "ottomatin_" + t.strftime("%Y%m%d_%H%M%S") + @row.find_value_by_name("Server")  + "@gspcauto.fav.cc"
        end

    end

    after(:each) do

    end

    after(:all) do
        $tracer.trace("after :all")
        @browser.close_all
    end

    it "should buy a product using CC with coupon and a new account during checkout process" do
        WebSpec.default_timeout 10000

        user_name = auto_generate_impulse_username
        password = 'Manh0le1'
        first_name = 'Otto'
        last_name = 'Matin'

        @browser.open(@start_page)

        # Verify cart is empty
        @browser.my_cart_label.should_exist
        @browser.empty_cart_label.should_exist

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # Add Really Big Sky to cart
        @browser.open(@secure_env_prefix + @store_domain +"cart.aspx?add&productID=" +  @row.find_value_by_name("ProductID") + "&theme=impulse")

        # Verify the product is in the cart
        # @browser.product_in_cart_label.should_exist

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

=begin
        # Add a coupon
        case @row.find_value_by_name("Env_Prefix")
        when "qa1."
            @browser.coupon_field.value = @row.find_value_by_name("Order_Wide_Coupon")
            @browser.apply_coupon_button.click
            @browser.discounts_label.should_exist
            #@browser.discount_amount_panel.innerText.should  == @row.find_value_by_name("Order_Wide_Coupon_Amount")
        when "dev1."
            @browser.coupon_field.value = @row.find_value_by_name("Order_Wide_Coupon")
            @browser.apply_coupon_button.click
            @browser.discounts_label.should_exist
            #@browser.discount_amount_panel.innerText.should  == @row.find_value_by_name("Order_Wide_Coupon_Amount")
        when "dev2."
            @browser.coupon_field.value = @row.find_value_by_name("Order_Wide_Coupon")
            @browser.apply_coupon_button.click
            @browser.discounts_label.should_exist
            #@browser.discount_amount_panel.innerText.should  == @row.find_value_by_name("Order_Wide_Coupon_Amount")
        else
            # Currently no coupon in Prod
        end
=end

        # Click Checkout
        @browser.checkout_button.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        #Create New User
        @browser.create_account(user_name, password)
		
        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        @browser.success_page_label.should_exist
        @browser.continue_button.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # Kept for use with new user setup
        @browser.first_name_field.value = first_name
        @browser.last_name_field.value = last_name
        @browser.street_address_field.value = "123 High Point Dr"
        @browser.city_field.value = "Irving"
        @browser.state_selector.value = "Texas"
        @browser.zip_code_field.value = "75038"
        @browser.phone_number_field.value = "999-999-9999"

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        @browser.continue_button.click

        # Enter CC Info
        @browser.credit_card_selector.value = "Visa"
        @browser.credit_card_number_field.value = "4222222222222"
        @browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
        @browser.credit_card_month_selector.value = "03"
        @browser.credit_card_year_selector.value = "2014"
        @browser.credit_card_security_code_field.value = "gs01"

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        @browser.continue_button.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        # Submit the Order
        @browser.submit_order_button.click

        # Output HTML and snapshot
        @browser.create_snapshot_and_html

        #sleep 10000
        link = @browser.order_number_link
        link.should_exist
        $tracer.trace("Order Number: " + link.innerText)
        sleep 5
        # @browser.source().include?("Order Status").should == false

        # Empty cart in preparation for next test
        @browser.open(@secure_env_prefix + @store_domain + "cart.aspx")
        @browser.cart_logout_link.click
        @browser.empty_cart

    end

    # it "should create an account then buy a product using GameStop Gift Card and PUR account and coupon" do
        # WebSpec.default_timeout 10000

        # user_name = auto_generate_impulse_username
        # password = 'Manh0le1'
        # first_name = 'Otto'
        # last_name = 'Matin'

        # @browser.open(@start_page)

        # # Verify cart is empty
        # @browser.my_cart_label.should_exist
        # @browser.empty_cart_label.should_exist

        # # # Output HTML and snapshot
        # # @browser.create_snapshot_and_html

        # # Click Create account button
        # @browser.create_account_link.click

        # # # Output HTML and snapshot
        # # @browser.create_snapshot_and_html

        # #Create New User
        # @browser.create_account(user_name, password)

        # @browser.success_page_label.should_exist
        # @browser.continue_button.click

        # # # Output HTML and snapshot
        # # @browser.create_snapshot_and_html

        # # Verify cart is empty
        # @browser.my_cart_label.should_exist
        # @browser.empty_cart_label.should_exist

        # # Add Really Big Sky to cart
        # @browser.open(@secure_env_prefix + @store_domain +"cart.aspx?add&productID=" +  @row.find_value_by_name("ProductID") + "&theme=impulse")

        # # # Output HTML and snapshot
        # # @browser.create_snapshot_and_html

        # # Verify the PUR Card can be applied to the cart successfully
        # @browser.cart_pur_number_field.value = @row.find_value_by_name("PUR_Account")
        # @browser.cart_pur_save_button.click
        # @browser.cart_pur_saved_label.innerText.should == "PowerUp succesfully saved."

        # # # Output HTML and snapshot
        # # @browser.create_snapshot_and_html

# =begin
        # # Add a coupon
        # case @row.find_value_by_name("Env_Prefix")
        # when "qa1."
            # @browser.coupon_field.value = @row.find_value_by_name("Order_Wide_Coupon")
            # @browser.apply_coupon_button.click
            # @browser.discounts_label.should_exist
            # #@browser.discount_amount_panel.innerText.should  == @row.find_value_by_name("Order_Wide_Coupon_Amount")
        # when "dev1."
            # @browser.coupon_field.value = @row.find_value_by_name("Order_Wide_Coupon")
            # @browser.apply_coupon_button.click
            # @browser.discounts_label.should_exist
            # #@browser.discount_amount_panel.innerText.should  == @row.find_value_by_name("Order_Wide_Coupon_Amount")
        # when "dev2."
            # @browser.coupon_field.value = @row.find_value_by_name("Order_Wide_Coupon")
            # @browser.apply_coupon_button.click
            # @browser.discounts_label.should_exist
            # #@browser.discount_amount_panel.innerText.should  == @row.find_value_by_name("Order_Wide_Coupon_Amount")
        # else
            # # Currently no coupon in Prod
        # end
# =end

        # # # Output HTML and snapshot
        # # @browser.create_snapshot_and_html

        # # Verify the product is in the cart
        # # @browser.product_in_cart_label.should_exist

        # #Click Checkout
        # @browser.checkout_button.click

        # # Kept for use with new user setup
        # @browser.first_name_field.value = first_name
        # @browser.last_name_field.value = last_name
        # @browser.street_address_field.value = "123 High Point Dr"
        # @browser.city_field.value = "Irving"
        # @browser.state_selector.value = "Texas"
        # @browser.zip_code_field.value = "75038"
        # @browser.phone_number_field.value = "999-999-9999"

        # # # Output HTML and snapshot
        # # @browser.create_snapshot_and_html

        # @browser.continue_button.click

        # # Enter GS GC Info
        # @browser.store_gift_card_number_field.value = @row.find_value_by_name("SVS_Account")
        # @browser.store_gift_card_pin_field.value = @row.find_value_by_name("SVS_PIN")

        # # # Output HTML and snapshot
        # # @browser.create_snapshot_and_html

        # @browser.store_apply_gift_card_button.click

        # # # Output HTML and snapshot
        # # @browser.create_snapshot_and_html

        # @browser.continue_button.click

        # # # Output HTML and snapshot
        # # @browser.create_snapshot_and_html

        # @browser.submit_order_button.click

        # # # Output HTML and snapshot
        # # @browser.create_snapshot_and_html

        # link = @browser.order_number_link
        # link.should_exist
        # $tracer.trace("Order Number: " + link.innerText)
        # sleep 5
        # @browser.source().include?("Order Status").should == false

    # end

end






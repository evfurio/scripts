require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"

describe "Sanity Test" do
    before(:all) do
        $options.default_timeout = 90_000
        #@start_page = "http://qa.ebgames.com/Checkout/instore/product?store=420&reg=3&pur=3876234510006&sku=240434&ctguest=true"

        $tracer.mode = :on
        $tracer.echo = :on
    end

    before(:each) do
        #@browser.setup_before_each_scenario(@start_page)
        @browser = WebInStoreBrowser.new(browser_type_parameter)

    end

    after(:each) do
        @browser.close_all()
    end

    after(:all) do
        $tracer.trace("after all")
    end

    it "should verify all finders exists" do

        url = "http://qa.ebgames.com/Checkout/instore/product?store=420&reg=3&pur=3876234510006&sku=804000&ctguest=true"
        # ensure_only_one_browser_window_open
        @browser.open(url)
        # wait_for_landing_page_load
        # @browser.search_field("Halo")
        @browser.search_all_button.should_exist
        # @browser.search_all_button.flash
        @browser.search_exp_selection_button.should_exist
        # @browser.search_online_button.flash
        @browser.search_field.should_exist
        # @browser.search_field.flash
        @browser.gamestop_logo.should_exist
        # @browser.gslogo.flash
        @browser.clear_customer_info_button.should_exist
        # @browser.clear_customer_info.flash
        @browser.best_sellers_button.should_exist
        # @browser.best_sellers_link.flash
        @browser.order_lookup_button.should_exist
        # @browser.order_lookup_link.flash
        @browser.view_cart_button.should_exist
        # @browser.view_cart_button.flash
        @browser.customer_info.should_exist
        @browser.esc_to_close_label.should_exist

        url = "http://qa.ebgames.com/Checkout/instore/product?sku=952919"
        @browser.open(url)

        @browser.age_verification_required_label.should_exist
        # @browser.age_warning_message.flash
        @browser.age_warning_checkbox.should_exist
        # @browser.age_warning_checkbox.flash
        @browser.esrb_rating_image.should_exist
        # @browser.esrb_rating_img.flash
        @browser.also_available_label.should_exist
        # @browser.also_available_label.flash
        @browser.product_details_button.should_exist
        # @browser.product_details_button.flash

        url = "http://qa.ebgames.com/Checkout/instore/product?sku=800971"
        @browser.open(url)

        @browser.product_details_label.should_exist
        # @browser.product_details_label.flash
        @browser.product_name.should_exist
        # @browser.product_name_label.flash
        @browser.product_sku.should_exist
        # @browser.product_sku.flash
        @browser.quantity_field.should_exist
        # @browser.quantity_label.flash
        @browser.add_to_cart_button.should_exist
        # @browser.add_to_cart_button.flash
        @browser.product_condition.should_exist
        # @browser.item_condition_label.flash
        @browser.product_price.should_exist
        # @browser.item_price_label.flash
        @browser.product_description.should_exist
        # @browser.item_short_description.flash
        @browser.product_image.should_exist
        # @browser.product_image.flash
        @browser.product_user_rating.should_exist
        # @browser.user_rating_label.flash
        @browser.checkout_button.should_exist
        # @browser.checkout_button.flash

        @browser.add_to_cart_button.click
        @browser.added_to_cart_label.should_exist
        # @browser.item_added_to_cart_label.flash

        @browser.checkout_button.click

        @browser.cart_label.should_exist
        @browser.subtotal_label.should_exist
        @browser.subtotal_ammount.should_exist
        @browser.discount_label.should_exist
        @browser.discount_ammount.should_exist
        @browser.order_total_label.should_exist
        @browser.order_total_ammount.should_exist
        @browser.cart_note.should_exist
        @browser.update_button.should_exist

        cart_list = @browser.cart_list
        item = cart_list.at(0)
        item.product_title.should_exist
        item.product_price.should_exist
        item.quantity_field.should_exist
        item.product_sku.should_exist
        item.delete_button.should_exist

        @browser.continue_button.click

        @browser.shipping_information_label.should_exist

        @browser.country_selector.should_exist
        @browser.first_name_field.should_exist
        @browser.last_name_field.should_exist
        @browser.address_line_1_field.should_exist
        @browser.address_line_2_field.should_exist
        @browser.city_field.should_exist
        @browser.state_selector.should_exist
        @browser.postal_code_field.should_exist
        @browser.phone_field.should_exist
        @browser.email_field.should_exist
        @browser.confirm_email_field.should_exist

        @browser.address_verification_checkbox.should_exist
        @browser.address_verification_checkbox.checked = "true"

        @browser.clear_all_fields_button.should_exist

        @browser.continue_button.click
        @browser.address_verification_checkbox.checked = "true"
        @browser.continue_button.click

        @browser.cart_message.should_exist

        @browser.shipping_options_label.should_exist

        # FIX: needed implementation
        #@browser.handling_method_buttons.should_exist
        #options = @browser.handling_method_buttons
        #options.value = "Two Day"

        @browser.gift_message_checkbox.should_exist
        @browser.gift_message_field.should_exist
        @browser.address_information_label.should_exist
        @browser.first_name.should_exist
        @browser.last_name.should_exist
        @browser.address_line1.should_exist
        @browser.address_city.should_exist
        @browser.address_state.should_exist
        @browser.address_postal_code.should_exist
        @browser.address_email.should_exist

        @browser.subtotal_label.should_exist
        @browser.subtotal_ammount.should_exist
        @browser.shipping_method_label.should_exist
        @browser.shipping_method.should_exist
        @browser.sales_tax_label.should_exist
        @browser.sales_tax_ammount.should_exist
        @browser.discount_label.should_exist
        @browser.discount_ammount.should_exist
        @browser.order_total_label.should_exist
        @browser.order_total_ammount.should_exist

        @browser.submit_button.should_exist

    end

    it "should verify all finders exist on Shipping page" do
        WebSpec.default_timeout 5000

        url = "http://qa.ebgames.com/Checkout/instore/product?store=420&reg=3"
        @browser.open(url)

        url = "http://qa.ebgames.com/Checkout/instore/product?sku=800971"
        @browser.open(url)

        @browser.add_to_cart_button.click
        @browser.checkout_button.click
        @browser.checkout_button.click

        @browser.customer_search_label.should_exist
        @browser.search_last_name_field.should_exist
        @browser.search_postal_code_field.should_exist
        @browser.search_phone_field.should_exist
        @browser.search_email_field.should_exist
        @browser.search_pur_field.should_exist
        @browser.search_go_button.should_exist

    end

    it "should verify order lookup" do
        @browser.open("https://qa.ebgames.com/Checkout/instore/Order/Search")

        @browser.last_name_field.should_exist
        @browser.postal_code_field.should_exist
        @browser.order_field.should_exist
        @browser.phone_field.should_exist
        @browser.email_field.should_exist
        @browser.pur_field.should_exist
        @browser.go_button.should_exist
    end

    it "should verify search" do
        @browser.open("https://qa.ebgames.com/Checkout/instore/Product/Search?searchtype=1&searchtext=lego")

        @browser.search_results_label.should_exist
        list = @browser.product_list
        item = list.at(0)
        item.product_title.should_exist
        item.product_title_link.should_exist
        item.product_price.should_exist
        item.product_details_button.should_exist
        item.product_sku.should_exist

        item.product_title_link.click
    end

end

require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"
require 'date'

describe "Fraud Order" do

    before(:all) do

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
        @browser.browser(0).open(@start_page)
    end

    after(:all) do
        $tracer.trace("after :all")
        @browser.close_all
    end

    it "should cause order to be placed in fraud queue, then successfully processed" do
        @browser.search_field.value = "Drive A Steam Train"
        @browser.search_button.click

        # product search list
        product = @browser.product_list.at(0)
        product.should_exist
        product.product_title_link.click

        @browser.add_to_cart_button.click

        @browser.create_account_link.click

        # create account -- see checkout_suite_spec for possible use of name_generator
        #   TODO: modify to use a utility method in generating a unique email address
        unique_user = "gs.testinguser+#{DateTime.now.strftime("%m%d%y%H%M%S")}@gmail.com"
        @browser.email_address_field.value = unique_user
        @browser.confirm_email_address_field.value = unique_user
        @browser.password_field.value = "impulse#2011"
        @browser.confirm_password_field.value = "impulse#2011"
        @browser.promotions_and_special_offers_opt_in_checkbox.checked = false
        @browser.continue_button.click

        # continue with checkout by viewing cart
        @browser.view_cart_link.click
        @browser.checkout_button.click

        # billing information
        @browser.billing_information_label.should_exist
        @browser.enter_address(
            "Test",
            "User1",
            "5615 High Point Dr",
            "Irving",
            "Texas",
            "75038",
            "214-555-1212"
        )
        @browser.continue_button.click

        # checkout using credit card
        @browser.checkout_payment_information_label.should_exist
        @browser.enter_credit_card_info(
            "American Express",
            "371449635398431",
            "Test User1",
            "12",
            "2013",
            "123"
        )
        @browser.continue_button.click

        # checkout review
        @browser.checkout_review_and_submit_label.should_exist
        @browser.submit_order_button.click

        # verify processing (fraud) and get order id
        @browser.order_status_processing_label.should_exist
        order_id = @browser.order_number_link.inner_text
        $tracer.trace("order id: #{order_id}")

        # check fraud queue page, and verify it exists
        @browser.open("https://impulsestoreadmin.gamestop.com/admin/FraudQueue.aspx")
        @browser.fraud_queue_label.should_exist
        fraud_list = @browser.fraud_queue_list
        fraud_list.find(order_id).should_exist

        # "process order" for order id
        @browser.open("https://impulsestoreadmin.gamestop.com/Admin/FraudQueue.aspx?process=&orderid=#{order_id}&usetestserver=1")

        # check fraud queue page, and verify that it no longer exists
        @browser.open("https://impulsestoreadmin.gamestop.com/admin/FraudQueue.aspx")
        @browser.fraud_queue_label.should_exist
        fraud_list = @browser.fraud_queue_list
        fraud_list.should_not_find(order_id) == true

        # verify order status is completed (Processed) in the fraud queue reports
        @browser.view_fraud_queue_history_link.click
        @browser.fraud_queue_reports_label.should_exist
        @browser.submit_button.click

        @browser.fraudulent_order_history_label.should_exist
        fraud_history_list = @browser.fraud_order_history_list
        fraud_history_item = fraud_history_list.find(order_id)
        fraud_history_item.should_exist
        fraud_history_item.processed_label.inner_text.strip.should == "Processed"

    end

end

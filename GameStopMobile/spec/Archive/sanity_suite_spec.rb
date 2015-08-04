require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"

describe "Sanity Test" do
  before(:all) do
    $tracer.echo = :on
    csv = QACSV.new(csv_filename_parameter)
    @row = csv.find_row_by_name(csv_range_parameter)

    @start_page = @row.find_value_by_name("url")
    @browser = GameStopMobileBrowser.new
    @browser.setup_before_all_scenarios
  end

  before(:each) do
    @browser.setup_before_each_scenario(@start_page)
  end

  after(:all) do
    $tracer.trace("after all")
    @browser.close_all()
  end

  it "should be able to buy as a guest with the same shipping and billing address" do
    @browser.empty_cart
    @browser.search_for_product(@row.find_value_by_name("available_product_2"))
    @browser.product_list.at(0).name_link.click
    @browser.wait_for_landing_page_load
    @browser.product_price_list.at(0).add_to_cart_button.click
    @browser.wait_for_landing_page_load
    @browser.continue_secure_checkout_button.click
    @browser.wait_for_landing_page_load
    @browser.buy_as_guest_button.click
    @browser.wait_for_landing_page_load
    @browser.seventeen_or_older_button.click
    @browser.wait_for_landing_page_load
    @browser.enter_address_plus_email(
      @row.find_value_by_name("ship_first_name"),
      @row.find_value_by_name("ship_last_name"),
      @row.find_value_by_name("ship_addr1"),
      @row.find_value_by_name("ship_city"),
      @row.find_value_by_name("ship_state"),
      @row.find_value_by_name("ship_zip"),
      @row.find_value_by_name("ship_phone"),
      account_login_parameter
    )
    @browser.same_address_checkbox.checked = true
    @browser.continue_checkout_button.click
    @browser.handling_options_label.should_exist
    @browser.handling_method_buttons.value.should == nil
    @browser.handling_method_buttons.value = @row.find_value_by_name("shipping_option")
    @browser.continue_checkout_button.click
    @browser.wait_for_landing_page_load
    @browser.enter_credit_card_info(
      @row.find_value_by_name("cc_type"),
      @row.find_value_by_name("cc_number"),
      @row.find_value_by_name("cc_month"),
      @row.find_value_by_name("cc_year")
    )
    @browser.complete_checkout_button.click
    @browser.wait_for_landing_page_load
    @browser.validate_order_prefix("51")
  end

  it "should be able to buy as a guest with a different shipping and billing address" do
    @browser.empty_cart
    @browser.search_for_product(@row.find_value_by_name("available_product_1"))
    @browser.product_list.at(0).name_link.click
    @browser.wait_for_landing_page_load
    @browser.product_price_list.at(0).add_to_cart_button.click
    @browser.wait_for_landing_page_load
    @browser.continue_secure_checkout_button.click
    @browser.wait_for_landing_page_load
    @browser.buy_as_guest_button.click
    @browser.wait_for_landing_page_load
    @browser.shipping_address_label.should_exist
    @browser.enter_address_plus_email(
      @row.find_value_by_name("ship_first_name"),
      @row.find_value_by_name("ship_last_name"),
      @row.find_value_by_name("ship_addr1"),
      @row.find_value_by_name("ship_city"),
      @row.find_value_by_name("ship_state"),
      @row.find_value_by_name("ship_zip"),
      @row.find_value_by_name("ship_phone"),
      account_login_parameter
    )
    @browser.continue_checkout_button.click
    @browser.wait_for_landing_page_load
    @browser.billing_address_label.should_exist
    @browser.enter_address(
      @row.find_value_by_name("bill_first_name"),
      @row.find_value_by_name("bill_last_name"),
      @row.find_value_by_name("bill_addr1"),
      @row.find_value_by_name("bill_city"),
      @row.find_value_by_name("bill_state"),
      @row.find_value_by_name("bill_zip"),
      @row.find_value_by_name("bill_phone")
    )
    @browser.continue_checkout_button.click
    @browser.wait_for_landing_page_load
    @browser.handling_options_label.should_exist
    @browser.handling_method_buttons.value.should == nil
    @browser.handling_method_buttons.value = @row.find_value_by_name("shipping_option")
    @browser.continue_checkout_button.click
    @browser.wait_for_landing_page_load
    @browser.enter_credit_card_info(
      @row.find_value_by_name("cc_type"),
      @row.find_value_by_name("cc_number"),
      @row.find_value_by_name("cc_month"),
      @row.find_value_by_name("cc_year")
    )
    @browser.complete_checkout_button.click
    @browser.wait_for_landing_page_load
    @browser.validate_order_prefix("51")
  end


end

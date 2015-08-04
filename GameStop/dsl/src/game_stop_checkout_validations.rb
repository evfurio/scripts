# Author:: Ecommerce QA
# Copyright:: Copyright (c) 2014 GameStop, Inc.
# Not for external distribution.

module GameStopCheckoutValidations

  # Verify receipt of an order number and that it matches the expected result.
  # === Parameters
  # _prefix_:: the first two digits of an order number, identifying the site and order type.
  # Currently only used in the checkout Gift Card scenario scripts
  # TODO: Deprecate this method
  def validate_order_prefix(prefix)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    create_acct_modal_panel.modal_close_button.click if create_acct_modal_panel.exists
    retry_until_found(lambda{order_confirmation_label.exists != false}, 10)
    order_confirmation_label.should_exist
    order_num = order_confirmation_number
    order_num.should match(prefix + ENDING_DIGITS_PATTERN)
  end

  def validate_create_account_modal(params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    retry_until_found(lambda{create_acct_modal_panel.exists != false}, 20)
    create_acct_modal_panel.should_exist
    retry_until_found(lambda{create_acct_modal_panel.modal_close_button.exists != false}, 10)
    create_acct_modal_panel.modal_close_button.click
    wait_for_landing_page_load
  end

  #If an order has either just download or digital products the order number prefix is 8
  #If an order has physical and digital and/or digital products it is considered mixed and the prefix is 8
  #Mobile prefix is 5 but we're not ready for that yet
  #Physical orders have a prefix of 4
  def validate_order_confirmation(params, condition)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

    retry_until_found(lambda{order_confirmation_label.exists != false}, 20)
    # order_confirmation_label.should_exist
    order_num = order_confirmation_number

    if condition.include? 'Digital'
      prefix = "8"
    elsif condition.include? 'Download'
      prefix = "8"
    else
      prefix = "4"
    end

    $tracer.report("Order number : #{order_num}")
    order_num.should match(prefix + ENDING_DIGITS_PATTERN)
    return order_num
  end

  # Validates shipping address info on the Handling Options page
  # TODO : Refactor for ats-paymentbillingaddr validation on the payment page
  def validate_payment_bill_address(params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #addr-firstname
    review_first_name_label.should_exist
    review_last_name_label.should_exist
    review_address1_label.should_exist
    review_city_label.should_exist
    review_state_label.should_exist
    review_postal_code_label.should_exist
    review_country_label.should_exist
    review_phone_label.should_exist
  end

  # TODO : Refactor for ats-paymentshippingaddr validation on the payment page
  def validate_payment_ship_address(params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #addr-firstname
    review_first_name_label.should_exist
    review_last_name_label.should_exist
    review_address1_label.should_exist
    review_city_label.should_exist
    review_state_label.should_exist
    review_postal_code_label.should_exist
    review_country_label.should_exist
    review_phone_label.should_exist
  end

  # TODO: Break this up to calculation functions and seperate the validations here
  def validate_payment_options_and_total(condition, physical_product, params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    retry_until_found(lambda{order_summary_subtotal.exists != false}, 10)
    preview_order_button.should_exist
    order_summary_subtotal.should_exist
    order_summary_tax.should_exist

    # Updated the logic for getting the handling and handling_disc values since FREE handling now also applies to physical products.
    order_summary_handling.exists ? handling = true : handling = false
    handling_with_discount_amount.exists ? handling_disc = true : handling_disc = false
    order_summary_total.should_exist
    sleep 3

    order_summary_subtotal_figure = money_string_to_decimal(order_summary_subtotal.innerText)
    order_summary_tax_figure = money_string_to_decimal(order_summary_tax.innerText)

    # This will be "FREE!" if it's not a physical product
    unless condition.class != "Array"
      $tracer.report("WARNING : Condition Variable returned #{condition.inspect} as a #{condition.class}\n The order number was not confirmed for this order")
    end

    # REVIEW - Need to make sure this is working with multiple products.  In theory if any product is considered physical product then the flag is set and the correct handling is used
    order_summary_handling_figure = (
    if handling
      money_string_to_decimal(order_summary_handling.innerText)
    elsif handling_disc
      handling_with_discount_amount.innerText == "FREE!"
      handling_with_discount_figure = "FREE!"
      0
    else
      handling_with_discount_figure = "No discount."
      0
    end)

    order_summary_total_figure = money_string_to_decimal(order_summary_total.innerText)
    order_summary_discount_figure = confirmation_page_discount.exists ? money_string_to_decimal(confirmation_page_discount.innerText) : BigDecimal.new("0")
    test_total = order_summary_subtotal_figure + order_summary_tax_figure + order_summary_handling_figure + order_summary_discount_figure

    $tracer.report("Order Subtotal: #{order_summary_subtotal_figure.to_f}")
    $tracer.report("Order Estimated Tax: #{order_summary_tax_figure.to_f}")
    $tracer.report("Order Handling: #{order_summary_handling_figure.to_f}")
    $tracer.report("Order Handling with Discount: #{handling_with_discount_figure.to_f}")
    $tracer.report("Order Discount: #{order_summary_discount_figure.to_f}")
    $tracer.report("Order Summary Total: #{order_summary_total_figure.to_f}")
    $tracer.report("Test Calculation Figure to Compare: #{test_total.to_f}")

    order_summary_total_figure.should == test_total
  end

  def check_checkout_shipping_fields_exist
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    chkcountry_label.should_exist
    chkoutfirstname_label.should_exist
    chkoutlastname_label.should_exist
    chkoutaddress1_label.should_exist
    chkoutaddress2_label.should_exist
    chkoutcity_label.should_exist
    chkoutstate_label.should_exist
    chkoutzip_label.should_exist
    chkoutphonenumber_label.should_exist
    #shouldn't there be an email address field here?
  end

  def check_checkout_billing_fields_exist
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    chkcountry_label.should_exist
    chkoutfirstname_label.should_exist
    chkoutlastname_label.should_exist
    chkoutaddress1_label.should_exist
    chkoutaddress2_label.should_exist
    chkoutcity_label.should_exist
    chkoutstate_label.should_exist
    chkoutzip_label.should_exist
    chkoutphonenumber_label.should_exist
  end

  def check_billing_address_fields_exist
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    confirm_billing_address_panel.confirm_billing_first_name_label.should_exist
    confirm_billing_address_panel.confirm_billing_last_name_label.should_exist
    confirm_billing_address_panel.confirm_billing_addr1_label.should_exist
    confirm_billing_address_panel.confirm_billing_city_label.should_exist
    #confirm_billing_address_panel.confirm_billing_state_label.should_exist
    confirm_billing_address_panel.confirm_billing_zip_label.should_exist
    confirm_billing_address_panel.confirm_billing_country_label.should_exist
  end

  def check_shipping_address_fields_exist
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    confirm_shipping_address_panel.confirm_shipping_first_name_label.should_exist
    confirm_shipping_address_panel.confirm_shipping_last_name_label.should_exist
    confirm_shipping_address_panel.confirm_shipping_addr1_label.should_exist
    confirm_shipping_address_panel.confirm_shipping_city_label.should_exist
    #confirm_shipping_address_panel.confirm_shipping_state_label.should_exist
    confirm_shipping_address_panel.confirm_shipping_zip_label.should_exist
    #confirm_shipping_address_panel.confirm_shipping_country_label.should_exist
  end

  def check_create_account_popup_fields_exist(params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #create_acct_modal_panel.modal_create_account_button.should_exist
    create_acct_modal_panel.modal_close_button.click
    wait_for_landing_page_load
  end

  def check_confirmation_page_subtotal(subtotal)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    i = 0
    calclulted_sub_total = BigDecimal.new("0")
    while i < confirm_order_details_panel.length
      panel = confirm_order_details_panel.at(i)
      a = 0
      while a < panel.get_items.length
        item = panel.get_items.at(a)
        a = a + 1
        item.ordered_product_label.should_exist
        item.ordered_availability_label.should_exist
        item.ordered_quantity_label.should_exist
        calclulted_sub_total = calclulted_sub_total + money_string_to_decimal(item.ordered_price_label.innerText)
      end
      i = i + 1
    end

    if order_discount_total.exists
      confirmation_discount = BigDecimal.new("0")
      confirmation_discount_total = BigDecimal.new("0")
      a = 0
      while confirm_order_discount_panel.length > a
        confirmation_discount = money_string_to_decimal(confirm_order_discount_panel.at(a).get_discount_amount.innerText)
        confirmation_discount_total += confirmation_discount
        a += 1
      end
      calclulted_sub_total = calclulted_sub_total - confirmation_discount_total
    end

    $tracer.trace("Calculated Sub Total On Order Confirmation Page :::: #{calclulted_sub_total.to_f.to_s} SubTotal:  #{subtotal.to_f.to_s}")
    calclulted_sub_total.should == subtotal
  end

  def check_confirmation_page_payment_method(using_paypal)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    if using_paypal
      $tracer.trace("Confirm Payment Method/Contact Info")
      confirm_payment_panel.confirm_paypal_payment_method_label.should_exist
      confirm_payment_panel.confirm_paypal_contact_info_msg.should_exist
    else
      $tracer.trace("Confirm Payment Type/Number")
      confirm_payment_panel.confirm_payment_type_label.should_exist
      confirm_payment_panel.confirm_payment_number_label.should_exist
    end
  end

  def check_address_equivalence(first, second)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    first.city.content.upcase.should == second.city.content.upcase
    first.line1.content.upcase.should == second.address_line1.content.upcase
    first.postal_code.content.should == second.postal_code.content
    first.state.content.should == second.state_or_province.content
    first.first_name.content.upcase.should == second.recipient_first_name.content.upcase
    first.last_name.content.upcase.should == second.recipient_last_name.content.upcase
  end

  def check_address_equivalence_against_params(address, params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    address.city.content.upcase.should == params["bill_city"].upcase
    address.line1.content.upcase.should == params["bill_addr1"].upcase
    address.postal_code.content.should == params["bill_zip"]
    address.state.content.should == state_abbriviation(params["bill_state"])
    address.first_name.content.upcase.should == params["bill_first_name"].upcase
    address.last_name.content.upcase.should == params["bill_last_name"].upcase
  end

  def check_shipping_address_equivalence_against_params(address, params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    address.city.content.upcase.should == params["ship_city"].upcase
    address.line1.content.upcase.should == params["ship_addr1"].upcase
    address.postal_code.content.should == params["ship_zip"]
    address.state.content.should == state_abbriviation(params["ship_state"].strip) if params["ship_state"] != ''
    address.first_name.content.upcase.should == params["ship_first_name"].upcase
    address.last_name.content.upcase.should == params["ship_last_name"].upcase
  end

  def check_store_equivalence_against_params(params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    confirm_handling_method_panel.should_exist
    $tracer.trace(confirm_handling_method_panel.innerText)
    confirm_handling_method_panel.innerText.include?("Pick Up At Store").should == true
  end

  # Assert existence of Paypal in Payment Screen
  def validate_paypal_payment_option
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    actual_result = (payment_options_radio_button[1].call("style.display").eql?("none") ? true : false )
    return actual_result
  end
end
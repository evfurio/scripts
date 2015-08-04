module WebInStoreCommonDSL

  # Takes an initialized QACSV instance
  def initialize_params_from_csv(csv_file, csv_range)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    row = csv_file.find_row_by_name(csv_range)
    params = {
        "row" => row,
        "id" => row.find_value_by_name("ID"),
        "project" => row.find_value_by_name("Project"),
        "testdescription" => row.find_value_by_name("TestDescription"),
        "client_channel" => row.find_value_by_name("client_channel"),
        "ship_first_name" => row.find_value_by_name("ship_first_name"),
        "ship_last_name" => row.find_value_by_name("ship_last_name"),
        "ship_addr1" => row.find_value_by_name("ship_addr1"),
        "ship_addr2" => row.find_value_by_name("ship_addr2"),
        "ship_city" => row.find_value_by_name("ship_city"),
        "ship_state" => row.find_value_by_name("ship_state"),
        "ship_zip" => row.find_value_by_name("ship_zip"),
        "ship_phone" => row.find_value_by_name("ship_phone"),
        "ship_email" => row.find_value_by_name("ship_email"),
        "order_number" => row.find_value_by_name("order_number"),
        "ship_country" => row.find_value_by_name("ship_country"),
        "pur_number" => row.find_value_by_name("power_up_rewards_number"),
        "category_drop_down_test" => row.find_value_by_name("category_drop_down_test"),
        "category_drop_down_value" => row.find_value_by_name("category_drop_down_value"),
        "search_value" => row.find_value_by_name("search_value"),
        "order_look_up_track_order_status" => row.find_value_by_name("order_look_up_track_order_status"),
        "order_look_up_search_pur_no" => row.find_value_by_name("order_look_up_search_pur_no"),
        "order_look_up_search_order_no" => row.find_value_by_name("order_look_up_search_order_no"),
        "ups_shipped" => row.find_value_by_name("ups_shipped"),
        "ups_delivered" => row.find_value_by_name("ups_delivered"),
        "shipping_search_lname_zip" => row.find_value_by_name("shipping_search_lname_zip"),
        "shipping_search_email" => row.find_value_by_name("shipping_search_email"),
        "shipping_search_pur_no" => row.find_value_by_name("shipping_search_pur_no"),
        "product_details_full_details" => row.find_value_by_name("product_details_full_details"),
        "product_details_out_of_stocks" => row.find_value_by_name("product_details_out_of_stocks"),
        "product_details_mature_product" => row.find_value_by_name("product_details_mature_product"),
        "sku" => row.find_value_by_name("sku"),
        "promo_code" => row.find_value_by_name("promo_code"),
        "percent_off" => row.find_value_by_name("percent_off"),
        "dollar_amount_off" => row.find_value_by_name("dollar_amount_off"),
        "shipping_option" => row.find_value_by_name("shipping_option"),
        "submit_order_flag" => row.find_value_by_name("submit_order_flag"),
        "free_pur_member" => row.find_value_by_name("free_pur_member"),
        "is_new" => row.find_value_by_name("is_new"),
        "disable_state" => row.find_value_by_name("disable_state")

    }
  end

  # Returns the paramaters from csv
  def get_params_from_csv
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    return initialize_params_from_csv(QACSV.new(csv_filename_parameter), csv_range_parameter)
  end

  # Wait for 5 seconds
  def wait_for_landing_page_load(timeout_ms = 3000)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.trace(__method__)
    sleep timeout_ms/1000
    return nil
  end

  # Gets the skus from db
  def load_test_skus_from_db(db, sql)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    out_of_stock = false
    low_stock = false
    $tracer.trace("Gets the info of first SKU from database.   ----#{sql}")
    results_from_file = db.exec_sql_from_file("#{sql}")
    sku = results_from_file.at(0).SKU
    if results_from_file.at(0).OnHandQuantity < 10
      if results_from_file.at(0).OnHandQuantity == 0
        out_of_stock = true
      else
        low_stock = true
      end
    end
    return sku, out_of_stock, low_stock
  end

  # Searches for a product and checks if result is sorted to Best Selling
  def validate_search_result(params)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    search_field.value = params["search_value"]
    search_button.should_exist
    search_button.click
    wait_for_landing_page_load
    sort_best_selling.should_exist
  end

  ##This method will retrieve shipping information based on search criteria.
  def customer_search(search_text, option_flag)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    if (option_flag==0)
      search_customer_by_pur.should_exist
      search_customer_by_pur.value=search_text.to_s
    else
      search_email_field.should_exist
      search_email_field.value=search_text.to_s
    end
    search_customer_button.should_exist
    search_customer_button.click
    select_customer_button.should_exist
    select_customer_button.click

  end

  ##This method will validate the existence of finders in handling option page.
  def handling_option_product_review_info
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    shipping_options_label.should_exist
    gift_message_checkbox.should_exist
    gift_message_field.should_exist
    address_information_label.should_exist
    first_name.should_exist
    last_name.should_exist
    address_line1.should_exist
    address_city.should_exist
    address_postal_code.should_exist
    address_email.should_exist
    subtotal_label.should_exist
    subtotal_amount.should_exist
    shipping_method_label.should_exist
    shipping_method.should_exist

    sales_tax_label.should_exist
    sales_tax_amount.should_exist
    discount_label.should_exist
    discount_amount.should_exist
    order_total_label.should_exist
    order_total_amount.should_exist
    shipping_cost.should_exist

    shipping_page_subtotal = subtotal_amount.innerText.gsub("$", "").to_f
    shipping_page_discount_amount = discount_amount.innerText.gsub("- $", "").to_f
    shipping_page_shipping_cost = shipping_cost.innerText.gsub("$", "").to_f

    if sales_tax_amount.length >1
      shipping_page_tax = sales_tax_amount[1].innerText.gsub("$", "").to_f
      sub_total_after_discount=sales_tax_amount[0].innerText.gsub("$", "").to_f
    else
      shipping_page_tax = sales_tax_amount.inner_text.gsub("$", "").to_f
      sub_total_after_discount="0.00"
    end
    shipping_page_total = order_total_amount.inner_text.gsub("$", "").to_f
    $tracer.trace("****** Shipping Options Page Total ******")
    $tracer.trace("::::::::::::::::::::::::::Shipping Page Sub Total #{shipping_page_subtotal}")
    $tracer.trace("::::::::::::::::::::::::::Shipping Page Discount Amount #{shipping_page_discount_amount}")
    $tracer.trace("::::::::::::::::::::::::::Shipping Page Shipping Cost + #{shipping_page_shipping_cost}")
    $tracer.trace("::::::::::::::::::::::::::Shipping Page SubToal after Discount #{sub_total_after_discount}")
    $tracer.trace("::::::::::::::::::::::::::Shipping Page Sales Tax + #{shipping_page_tax}")
    $tracer.trace("::::::::::::::::::::::::::Shipping Page Order Total #{shipping_page_total}")
    #Validate Order Total
    shipping_expected_total = (shipping_page_subtotal - shipping_page_discount_amount + shipping_page_shipping_cost + shipping_page_tax).round(2).to_s
    shipping_page_total.to_s.should == shipping_expected_total

    i = 0
    shipping_page_calculated_sub_total = 0
    while i < product_list.length
      item = product_list.at(i)
      item.product_title.should_exist
      item.product_price.should_exist
      item.quantity_field.should_exist
      item.product_sku.should_exist
      shipping_page_calculated_sub_total += item.product_price.inner_text.gsub("$", "").to_f
      i += 1
    end
    #validate Total Amount
    $tracer.trace("::::::::::::::::::::::::::Shipping calculated_sub_total #{shipping_page_calculated_sub_total.round(2).to_s}")
    shipping_page_subtotal.to_s.should == shipping_page_calculated_sub_total.round(2).to_s

    $tracer.trace("Shipping Page Expected Total: #{shipping_expected_total}")
    $tracer.trace("Shipping Page Actual Total: #{shipping_page_total}")
    shipping_page_total.to_s.should == shipping_expected_total
    submit_button.should_exist
    submit_button.click

  end

  ##This method will validate the existence of confirmation order finders.
  def order_confirm_info
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    submit_button.click
    wait_for_landing_page_load
    order_number.should_exist
    bar_code.should_exist

    order_confirmation_page_subtotal = subtotal_amount.inner_text.gsub("$", "").to_f
    order_confirmation_page_discount_amount = discount_amount.inner_text.gsub("- $", "").to_f
    order_confirmation_page_shipping_cost = shipping_cost.inner_text.gsub("$", "").to_f

    if sales_tax_amount.length >1
      order_confirmation_page_tax = sales_tax_amount[1].innerText.gsub("$", "").to_f
      sub_total_after_discount=sales_tax_amount[0].innerText.gsub("$", "").to_f
    else
      order_confirmation_page_tax = sales_tax_amount.inner_text.gsub("$", "").to_f
      sub_total_after_discount="0.00"
    end
    order_confirmation_page_total = order_total_amount.inner_text.gsub("$", "").to_f
    $tracer.trace("****** Order Confirmation Page Total ******")
    $tracer.trace("::::::::::::::::::::::::::Order Confirmation Page Sub Total #{order_confirmation_page_subtotal}")
    $tracer.trace("::::::::::::::::::::::::::Order Confirmation Page Discount Amount #{order_confirmation_page_discount_amount}")
    $tracer.trace("::::::::::::::::::::::::::Order Confirmation Page Shipping Cost + #{order_confirmation_page_shipping_cost}")
    $tracer.trace("::::::::::::::::::::::::::Order Confirmation Page SubToal after Discount #{sub_total_after_discount}")
    $tracer.trace("::::::::::::::::::::::::::Order Confirmation Page Sales Tax + #{order_confirmation_page_tax}")
    $tracer.trace("::::::::::::::::::::::::::Order Confirmation Page Order Total #{order_confirmation_page_total}")
    #Validate Order Total
    order_confirmation_expected_total = (order_confirmation_page_subtotal - order_confirmation_page_discount_amount + order_confirmation_page_shipping_cost + order_confirmation_page_tax).round(2).to_s
    order_confirmation_page_total.to_s.should == order_confirmation_expected_total
    i = 0
    order_confirmation_page_calculated_sub_total = 0
    while i < order_items.length
      item = order_items.at(i)
      item.product_title.should_exist
      item.product_price.should_exist
      item.quantity_field.should_exist
      order_confirmation_page_calculated_sub_total += item.product_price.inner_text.gsub("$", "").to_f
      i += 1
    end
    #validate Total Amount
    order_confirmation_page_subtotal.to_s.should == order_confirmation_page_calculated_sub_total.to_s
    $tracer.trace("Order Confirmation Page Expected Total: #{order_confirmation_expected_total}")
    $tracer.trace("Order Confirmation Page Actual Total: #{order_confirmation_page_total}")
    order_confirmation_page_total.to_s.should == order_confirmation_expected_total

    address_email.should_exist
    address_city.should_exist
    address_line1.should_exist
    first_name.should_exist
    last_name.should_exist
    subtotal_label.should_exist
    subtotal_amount.should_exist
    discount_amount.should_exist
    order_total_amount.should_exist
    sales_tax_amount.should_exist
    shipping_cost.should_exist

  end

  ##This method will validate the shipping information search criteria fields.
  def shipping_search_field_exist
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    search_last_name_field.should_exist
    search_postal_code_field.should_exist
    search_phone_field.should_exist
    search_email_field.should_exist
  end

  ##This method will validate the existence of shipping information finders as well as adding new shipping address.
  def shipping_information_exist(ship_country, ship_first_name, ship_last_name, ship_addr1, ship_addr2, ship_city, ship_state, ship_zip, ship_phone, ship_email, is_new, disable_state)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    shipping_information_label.should_exist
    country_selector.should_exist
    first_name_field.should_exist
    last_name_field.should_exist
    address_line_1_field.should_exist
    address_line_2_field.should_exist
    city_field.should_exist
    state_selector.should_exist
    postal_code_field.should_exist
    phone_field.should_exist
    email_field.should_exist
    confirm_email_field.should_exist

    if (is_new)
      shipping_information_label.should_exist
      country_selector.value =ship_country
      country_selector.call("onchange()")
      first_name_field.value = ship_first_name
      last_name_field.value = ship_last_name
      address_line_1_field.value = ship_addr1
      address_line_2_field.value = ship_addr2
      city_field.value = ship_city
      if (!disable_state)
        state_selector.value = ship_state
      end
      postal_code_field.value = ship_zip
      phone_field.value = ship_phone
      email_field.value = ship_email
      confirm_email_field.value = ship_email

    end
    continue_button.click
    shipping_add_addconfm_button.click if shipping_add_addconfm_button.exists
  end

  ##This method will validate the existence of cart information finders.
  def cart_information_exist
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")

    add_to_cart_button.click
    added_to_cart_label.should_exist
    subtotal_label.should_exist
    subtotal_amount.should_exist
    discount_label.should_exist
    discount_amount.should_exist
    order_total_label.should_exist
    order_total_amount.should_exist
    cart_note.should_exist
    update_button.should_exist

    cart_product_price =line_item_price.inner_text
    cart_product_qty = line_item_quantity.value
    cart_subtotal = subtotal_amount.inner_text.gsub("$", "")
    cart_discount = discount_amount.inner_text.gsub("$", "")
    cart_total = order_total_amount.inner_text.gsub("$", "")
    $tracer.trace("****** Cart List******")
    $tracer.trace("::::::::::::::::::::::::::Product Price #{cart_product_price}")
    $tracer.trace("::::::::::::::::::::::::::Product Quantity #{cart_product_qty}")
    $tracer.trace("::::::::::::::::::::::::::Cart Subtotal #{cart_subtotal}")
    $tracer.trace("::::::::::::::::::::::::::Cart Discount #{cart_discount}")
    $tracer.trace("::::::::::::::::::::::::::Cart Total #{cart_total}")
    i = 0
    cart_calculated_sub_total=0
    while i < cart_list.length

      item = cart_list.at(i)
      item.line_item_title.should_exist
      item.line_item_price.should_exist
      item.line_item_quantity.should_exist
      item.line_item_sku.should_exist
      item.delete_button.should_exist
      $tracer.trace("Line Item Price no. #{i+1}). #{item.line_item_price.inner_text.gsub("$", "").to_f } Quantity : #{item.line_item_quantity.value.to_i} ")
      cart_calculated_sub_total += item.line_item_price.inner_text.gsub("$", "").to_f
      i += 1

    end
    #Validate cart order total
    cart_discount=cart_discount.gsub("- ", "")
    cart_subtotal.should == round(cart_calculated_sub_total).to_s
    cart_total.should == round((cart_subtotal.to_f - cart_discount.to_f)).to_s
    $tracer.trace ("Calculated Cart Sub Total :#{cart_calculated_sub_total}")
    $tracer.trace("Cart Discount :#{cart_discount.to_f}")
    $tracer.trace("Cart Order Total :#{cart_total}")
    continue_button.should_exist
    continue_button.click
  end

  def validate_item_level_coupon_by_amount(promo_code)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    order_promo_code_field.should_exist
    apply_promo_button.should_exist
    order_promo_code_field.value=promo_code
    apply_promo_button.click
  end

  ##This method will validate the existence of UI Label.
  def validate_label(script_text, expectedstrresult)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    expected_result=true
    if (isvalexist(script_text, expectedstrresult))
      actualstrresult=expectedstrresult
    else
      actualstrresult=script_text
    end


    $tracer.trace("Expected Result : #{expectedstrresult}")
    $tracer.trace("Actual Result : #{actualstrresult}")

    actual_result = (expectedstrresult == actualstrresult ? true : false)
    actual_result.should==expected_result
  end

  ##This method will validate delivery estimate date for shipping method.
  def validate_delivery_estimate_date(date_from, date_to)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    expected=true
    expected.should==handling_method_buttons.isexist(date_from)
    expected.should==handling_method_buttons.isexist(date_to)
  end

  ##This method will validate shipping option method.
  def validate_shipping_method(ship_option)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    expected=true
    expected.should==handling_method_buttons.isexist("Value")
    expected.should==handling_method_buttons.isexist("Standard")
    expected.should==handling_method_buttons.isexist("One Day")
    expected.should==handling_method_buttons.isexist("Two Day")

    if (ship_option.to_i==4)
      handling_method_buttons.value="One Day"

    end
    if (ship_option.to_i==3)
      handling_method_buttons.value="Two Day"
    end
    if (ship_option.to_i==2)
      handling_method_buttons.value="Standard"
    end
    if (ship_option.to_i==1)
      handling_method_buttons.value="Value"
    end
  end

  ##This method will validate the existence of search label values.
  def isvalexist(script_text_val, str_search)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    isexist=true
    script_var= script_text_val[str_search]

    if (script_var==nil)
      isexist=false
    else
      isexist=true
    end

    return isexist
  end

  ##This method is already deprecated
  def get_length_of_order_number(order_number)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    ordernumber=order_number.gsub(/\s+/, "")
    ordernumber=ordernumber.gsub(/[OrderNumber:]/, '')
    return ordernumber.length
  end

  ##This method will get the order number.
  def get_order_number(order_number)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    ordernumber=order_number.gsub(/\s+/, "")
    ordernumber=ordernumber.gsub(/[OrderNumber:]/, '')
    return ordernumber
  end

  ##This method will remove spaces from the group of strings.
  def trim(str_value)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    result = str_value.gsub(/\s+/, "")
    return result
  end

  ##This method will validate customer header info if it exist or not.
  def validate_customer_header(expected_result)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    expectedresult=expected_result
    scripttext=customer_info.innerText
    scripttext.should include expected_result
    # validate_label(scripttext,expectedresult)
  end

  ##This method will compute the estimate delivery date for Value shipping option.
  def get_estimate_delivery_date_value
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    current_date=DateTime.now
    current_date = current_date.strftime("%Y-%m-%d")
    today = Date.parse(current_date)
    sunday=1
    saturday=1
    from_day=today+6+get_week_end(today, today+6)

    if (from_day.wday >0 && from_day.wday < 6)
      to_day=compute_weekend(from_day+5+sunday+saturday)
    end

    if (from_day.wday==6)
      from_day=from_day + sunday + 1
      to_day=compute_weekend(from_day+5+sunday+saturday)
    end

    if (from_day.wday==0)
      from_day=from_day+sunday
      to_day=compute_weekend(from_day+5)
    end

    date_from="#{from_day.mon}/#{concat_date(from_day.mday)}"
    date_to="#{to_day.mon}/#{concat_date(to_day.mday)}"

    return date_from, date_to

  end

  ##This method will get the additional days if date falls on weekend.
  def get_week_end(currentdate, m_day)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    saturday=0
    sunday=0
    monday=1

    while currentdate <= m_day

      if (currentdate.wday==6)
        saturday+=1
      end

      if (currentdate.wday==0)
        sunday+=1
      end

      currentdate+=1
    end
    return saturday+sunday
  end

  ##This method will get the additional weekend days.
  def compute_weekend(m_day)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    saturday=1
    sunday=1
    mday=m_day
    if (m_day.wday==6)
      mday=m_day+saturday+sunday
    end

    if (m_day.wday==0)
      mday=m_day+sunday
    end

    return mday

  end

  ##This method will compute the estimate delivery date for Standard shipping option.
  def get_estimate_delivery_date_standard
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    current_date=DateTime.now
    current_date = current_date.strftime("%Y-%m-%d")
    today = Date.parse(current_date)
    sunday=1
    saturday=1
    from_day=today+4

    if (from_day.wday==4)
      to_day=from_day+1+saturday+sunday
    else
      if (from_day.wday==5)
        to_day=from_day+2+saturday+sunday
      else
        if (from_day.wday==6)
          from_day=from_day+saturday+sunday
          to_day=from_day+2
        else
          if (from_day.wday==0)
            from_day=from_day+saturday+sunday
            to_day=from_day+2
          else
            to_day=from_day+2
          end
        end
      end
    end
    date_from="#{concat_date(from_day.mon)}/#{concat_date(from_day.mday)}"
    date_to="#{concat_date(to_day.mon)}/#{concat_date(to_day.mday)}"

    return date_from, date_to
  end

  ##This method will compute the estimate delivery date for USA One Day shipping option.
  def get_estimate_delivery_date_one_day
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    current_date=DateTime.now
    current_date = current_date.strftime("%Y-%m-%d")
    today = Date.parse(current_date)
    sunday=1
    saturday=1

    if (today.wday < 5 && today.wday > 0)
      from_day=today+1
      if (from_day.wday==5)
        to_day=from_day+1+saturday+sunday
      else
        to_day=today+2
      end
    end
    if (today.wday==5)
      from_day=today+1+saturday+sunday
      to_day=today+2+saturday+sunday
    end
    if (today.wday==6)
      from_day=today+sunday+1
      to_day=today+sunday+2
    end
    if (today.wday==0)
      from_day=today+1
      to_day=today+2
    end


    date_from="#{concat_date(from_day.mon)}/#{concat_date(from_day.mday)}"
    date_to="#{concat_date(to_day.mon)}/#{concat_date(to_day.mday)}"

    return date_from, date_to

  end

  ##This method will compute the estimate delivery date for USA Two Days shipping option.
  def get_estimate_delivery_date_two_days
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    current_date=DateTime.now
    current_date = current_date.strftime("%Y-%m-%d")
    today = Date.parse(current_date)
    sunday=1
    saturday=1
    puts "----------------------------  #{today.wday}"
    if (today.wday < 4 && today.wday > 0)
      from_day=today+2
      if (from_day.wday==5)
        to_day=from_day+1+saturday+sunday
      else
        to_day=today+3
      end
    end
    if (today.wday==4)
      from_day=today+2+saturday+sunday
      to_day=today+3+saturday+sunday
    end
    if (today.wday==5)
      from_day=today+2+saturday+sunday
      to_day=today+3+saturday+sunday
    end
    if (today.wday==6)
      from_day=today+sunday+2
      to_day=today+sunday+3
    end
    if (today.wday==0)
      from_day=today+2
      to_day=today+3
    end
    date_from="#{concat_date(from_day.mon)}/#{concat_date(from_day.mday)}"
    date_to="#{concat_date(to_day.mon)}/#{concat_date(to_day.mday)}"

    return trim(date_from), date_to
  end

  ##This method will add 0 if the date day/month is single character only.
  def concat_date(m_date)
    $tracer.trace("WebInStoreCommonDSL : #{__method__}, Line : #{__LINE__}")
    if (m_date.to_s.length==1)
      return "0#{m_date}"
    else
      return m_date
    end
  end

  def round (value)
    return sprintf('%.2f', value)
  end
end
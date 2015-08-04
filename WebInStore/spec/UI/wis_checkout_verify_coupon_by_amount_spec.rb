# encoding: utf-8
#################################################################################################################################################################################################################################### 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_verify_coupon_by_amount_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS49663 --browser chrome --or 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_verify_coupon_by_amount_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS49664 --browser chrome --or 
#################################################################################################################################################################################################################################### 

require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name('ID')
$tc_desc = id_row.find_value_by_name('TestDescription')
$tc_desc = 'Test case description was not found' if $tc_desc == ''

describe "Checkout Product level coupon by amount" do

  before(:all) do
    @browser = WebInStoreBrowser.new(browser_type_parameter)
    $options.default_timeout = 90_000
    $snapshots.setup(@browser, :all)
    $tracer.mode = :on
    $tracer.echo = :on
  end

  before(:each) do
    @browser.cookie.all.delete
    @params = @browser.get_params_from_csv
    @global_functions = GlobalServiceFunctions.new()
    @global_functions.csv = @params["row"]
    @global_functions.parameters
    @sql = @global_functions.sql_file
    @db = @global_functions.db_conn
    @session_id = generate_guid
    @store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc
    @start_page = @global_functions.prop_url.find_value_by_name("url")
    @store_addresses =@store_search_svc.perform_get_all_stores_in_range(@session_id, "GS_US", "en-US", @store_search_svc_version, @params["ship_zip"], 10)
    @store=@store_addresses[0].store_number.content
    @product_sku, @out_of_stock, @low_stock = @browser.load_test_skus_from_db(@db, @sql.to_s)
  end

  after(:each) do
    @browser.return_current_url
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    url = "#{@start_page}/Checkout/instore/product?store=#{@store}&reg=3"
    @browser.open(url)

    @browser.search_field.value=@product_sku
    @browser.search_button.should_exist
    @browser.search_button.click
    item = @browser.product_search_list.at(0)
    item.product_details_button.should_exist
    item.product_details_button.click

    @browser.add_to_cart_button.click
    @browser.added_to_cart_label.should_exist
    @browser.subtotal_label.should_exist
    @browser.subtotal_amount.should_exist
    @browser.discount_label.should_exist
    @browser.discount_amount.should_exist
    @browser.order_total_label.should_exist
    @browser.order_total_amount.should_exist
    @browser.cart_note.should_exist
    @browser.update_button.should_exist

    cart_product_price = @browser.line_item_price.inner_text
    cart_product_qty = @browser.line_item_quantity.value
    cart_subtotal = @browser.subtotal_amount.inner_text.gsub("$", "")
    cart_discount = @browser.discount_amount.inner_text.gsub("$", "")
    cart_total = @browser.order_total_amount.inner_text.gsub("$", "")
    $tracer.trace("****** Cart List******")
    $tracer.trace("::::::::::::::::::::::::::Product Price #{cart_product_price}")
    $tracer.trace("::::::::::::::::::::::::::Product Quantity #{cart_product_qty}")
    $tracer.trace("::::::::::::::::::::::::::Cart Subtotal #{cart_subtotal}")
    $tracer.trace("::::::::::::::::::::::::::Cart Discount #{cart_discount}")
    $tracer.trace("::::::::::::::::::::::::::Cart Total #{cart_total}")


    i = 0
    cart_calculated_sub_total=0
    while i < @browser.cart_list.length
      item = @browser.cart_list.at(i)
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
    cart_subtotal.should == @browser.round(cart_calculated_sub_total).to_s
    cart_total.should == @browser.round((cart_subtotal.to_f - cart_discount.to_f)).to_s
    $tracer.trace ("Calculated Cart Sub Total :#{cart_calculated_sub_total}")
    $tracer.trace("Cart Discount :#{cart_discount.to_f}")
    $tracer.trace("Cart Order Total :#{cart_total}")

    @browser.continue_button.should_exist
    @browser.continue_button.click
    @browser.customer_search(@params["ship_email"], 1)
    #This method consists of Shipping page labels and validations.
    @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
    @browser.wait_for_landing_page_load
    #Validate Handling options page labels.
    validate_handling_option
    #Validate Discount
    validate_discount_total_order
    if (@params["submit_order_flag"])
      # @browser.submit_button.click
      #This method consists of Web Order Confirmation page labels and validations.
      @browser.order_confirm_info
    end
  end

  def validate_discount_total_order
    subtotal_amount = @browser.subtotal_amount.inner_text.gsub("$", "").to_f
    shipping_cost = @browser.shipping_cost.innerText.gsub("$", "").to_f
    if @browser.sales_tax_amount.length >1
      sales_tax_amount = @browser.sales_tax_amount[1].innerText.gsub("$", "").to_f
      sub_total_after_discount=@browser.sales_tax_amount[0].innerText.gsub("$", "").to_f
    else
      sales_tax_amount = @browser.sales_tax_amount.inner_text.gsub("$", "").to_f
      sub_total_after_discount="0.00"
    end
    $tracer.trace("Subtotal Amount #{subtotal_amount}")
    subtotal_after_discount=@browser.round(@browser.sales_tax_amount[0].innerText.gsub("$", "").to_f)
    $tracer.trace("Subtotal Amount After Discount #{subtotal_after_discount}")

    discount = @browser.discount_amount.inner_text.gsub("$", "")
    discount=discount.gsub("- ", "")

    $tracer.trace("Expected Discount Amount : #{@browser.round(discount)}")
    $tracer.trace("Actual Discount Amount : #{@browser.round(@params["dollar_amount_off"].to_f)}")
    #Validate Discount Amount
    @browser.round(discount).should_not == 0


    $tracer.trace("Discount Amount : #{discount}")
    calculated_discount= subtotal_amount.to_f - discount.to_f
    $tracer.trace("Calculated Total Amount After Discount : #{@browser.round(calculated_discount)}")
    @browser.round(calculated_discount).should==subtotal_after_discount

    order_total = @browser.order_total_amount.inner_text.gsub("$", "").to_f
    expected_order_total = (subtotal_amount - discount.to_f + shipping_cost + sales_tax_amount).round(2).to_s

    $tracer.trace("Expected Total Order Amount: #{expected_order_total}")
    $tracer.trace("Actual Total Order Amount: #{order_total}")
    order_total.to_s.should == expected_order_total

  end

  def validate_handling_option
    @browser.shipping_options_label.should_exist
    @browser.gift_message_checkbox.should_exist
    @browser.gift_message_field.should_exist
    @browser.address_information_label.should_exist
    @browser.first_name.should_exist
    @browser.last_name.should_exist
    @browser.address_line1.should_exist
    @browser.address_city.should_exist
    @browser.address_postal_code.should_exist
    @browser.address_email.should_exist
    @browser.subtotal_label.should_exist
    @browser.subtotal_amount.should_exist
    @browser.shipping_method_label.should_exist
    @browser.shipping_method.should_exist
    @browser.sales_tax_label.should_exist
    @browser.sales_tax_amount.should_exist
    @browser.discount_label.should_exist
    @browser.discount_amount.should_exist
    @browser.order_total_label.should_exist
    @browser.order_total_amount.should_exist
    @browser.shipping_cost.should_exist
    @browser.wait_for_landing_page_load
    shipping_page_subtotal = @browser.subtotal_amount.innerText.gsub("$", "").to_f
    shipping_page_discount_amount = @browser.discount_amount.innerText.gsub("- $", "").to_f
    shipping_page_shipping_cost = @browser.shipping_cost.innerText.gsub("$", "").to_f

    if @browser.sales_tax_amount.length >1
      shipping_page_tax = @browser.sales_tax_amount[1].innerText.gsub("$", "").to_f
      sub_total_after_discount=@browser.sales_tax_amount[0].innerText.gsub("$", "").to_f
    else
      shipping_page_tax = @browser.sales_tax_amount.inner_text.gsub("$", "").to_f
      sub_total_after_discount="0.00"
    end
    shipping_page_total = @browser.order_total_amount.inner_text.gsub("$", "").to_f
    $tracer.trace("****** Shipping Options Page Total ******")
    $tracer.trace("::::::::::::::::::::::::::Shipping Page Sub Total #{shipping_page_subtotal}")
    $tracer.trace("::::::::::::::::::::::::::Shipping Page Discount Amount #{shipping_page_discount_amount}")
    $tracer.trace("::::::::::::::::::::::::::Shipping Page Shipping Cost + #{shipping_page_shipping_cost}")
    $tracer.trace("::::::::::::::::::::::::::Shipping Page Sales Tax + #{shipping_page_tax}")
    $tracer.trace("::::::::::::::::::::::::::Shipping Page Order Total #{shipping_page_total}")
    #Validate Order Total
    shipping_expected_total = (shipping_page_subtotal - shipping_page_discount_amount + shipping_page_shipping_cost + shipping_page_tax).round(2).to_s
    $tracer.trace("Shipping Page Expected Total: #{shipping_expected_total}")
    $tracer.trace("Shipping Page Actual Total: #{shipping_page_total}")
    shipping_page_total.to_s.should == shipping_expected_total

    shipping_page_calculated_sub_total = 0
    i = 0
    while i < @browser.product_list.length
      item = @browser.product_list.at(i)
      item.product_title.should_exist
      item.product_price.should_exist
      item.quantity_field.should_exist
      item.product_sku.should_exist
      shipping_page_calculated_sub_total += item.product_price.inner_text.gsub("$", "").to_f
      i += 1

    end
    #validate Sub Total Amount
    shipping_page_subtotal.to_s.should == shipping_page_calculated_sub_total.to_s
    @browser.order_promo_code_field.should_exist
    @browser.apply_promo_button.should_exist
    @browser.order_promo_code_field.value=@params["promo_code"]
    @browser.apply_promo_button.click
    @browser.wait_for_landing_page_load
    #Validate promo code.
    @browser.validate_label(@browser.trim(@browser.order_promo_code.innerText), @browser.trim(@params["search_value"]))
    @browser.submit_button.should_exist
  end

end

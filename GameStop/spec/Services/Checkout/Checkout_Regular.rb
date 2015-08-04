#####################################################################
###USAGE NOTES
### Run this script using the following command
###
###  **Authenticated User, Checkout ALL RUN TIME PARAMETERS IN THE COMMAND LINE
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_regular.rb --login qa_srvcs_atmtn@qagsecomprod.oib.com --password T3sting --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range TFS47096 --or
###
###  **Guest User, Checkout ONLY REQUIRED PARAMETERS IN THE COMMAND LINE
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_regular.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range TFS44309 --svc %QAAUTOMATION_SCRIPTS%\Common\config\endpoints.csv --svc_env QA_V1 --or
###
###  **Authenticated User, Checkout ONLY REQUIRED PARAMETERS IN THE COMMAND LINE
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_regular.rb --login qa_srvcs_atmtn@qagsecomprod.oib.com --password T3sting --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range TFS44309 --or
###Author: dturner/rsickles

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()
$tc_desc = $global_functions.desc
$tc_id = $global_functions.id


describe "GameStop Ecomm Services Checkout Scenarios" do

  $options.http_proxy = "localhost"
  $options.http_proxy_port = "8888"

  before(:all) do
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @account_svc, @account_svc_version = $global_functions.account_svc
    @common_functions = $global_functions.common_function_link
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @shipping_svc, @shipping_svc_version = $global_functions.shipping_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
    @tax_svc, @tax_svc_version = $global_functions.tax_svc
    @payment_svc, @payment_svc_version = $global_functions.payment_svc
    @store_search_svc, @store_search_svc_version = $global_functions.storesearch_svc
  end

  before(:each) do
    @session_id = generate_guid
    @transaction_uuid = generate_guid
    @reference_number = generate_guid

    @open_id = nil
    @results_from_file = @db.exec_sql_from_file(@sql.to_s)

    #set instance variables for csv driven data elements
    report_summary
    initialize_shipping_addr_params
    initialize_billing_addr_params

    #Returns the user_id for authenticated or guest users - ties the cart and purchase order to a specific user
    #@user_id = @account_svc.perform_authorization_and_return_message(@session_id, @login, @password, @account_svc_version) if @is_guest
    @login = @login.downcase unless @login.nil?

    if @login.blank?
      @user_id, @token = @account_svc.perform_authorize_anonymous(@session_id, @login, @password, @account_svc_version)
      @owner_id = generate_guid
      $tracer.report("Guest user")
    end

    if @login == "register"
      @login, @password = @account_svc.create_new_user(@session_id, @login, @password, @account_svc_version)
      $tracer.report("Registered user: \n\tuser: #{@login}, \n\tpassword: #{@password}")
    end

    if (!@login.blank?)
      @is_guest = false
      @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
      @profile_svc.perform_get_addresses(@open_id, @session_id, @params["ClientChannel"], @profile_svc_version)
      @owner_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, @params["ClientChannel"], @profile_svc_version)
      @cart_svc.perform_empty_cart(@session_id, @owner_id, 'GS_US', 'en-US', @cart_svc_version)
    else
      @is_guest = true
      @owner_id = generate_guid
    end
  end

  it "#{$tc_id} #{$tc_desc}" do
      @calculated_shipping_cost = 0
      @total_tax = 0
      sku_qty_list = []

      @results_from_file.each_with_index do |sku, i|
        qty = i == 2 ? 1 + @params["QtyIncrease"].to_i : 1
        sku_qty_list.push(sku.variantid, qty)
      end

      @cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list, @params["ClientChannel"], @params["Locale"], @cart_svc_version)
      line_item_ids = @cart_svc.perform_get_cart_and_return_guids(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @cart_svc_version)
      ispu = true
      if ispu
        $tracer.trace("CHANGE FULFILLMENT CHANNEL OF LINEITEMS FROM SHIPTOADDRESS TO INSTOREPICKUP")
        @cart_svc.perform_modify_line_item_fulfillment_channels_and_return_message(@session_id, @owner_id, *line_item_ids, @params["ShipmentType"], @params["ClientChannel"], @params["Locale"], @cart_svc_version)
      end

      #TODO : Cart manipulation
      #TODO : Apply discount to cart
      #TODO : Apply PUR Free/Pro to cart
      #TODO : Remove product from cart
      #TODO : Clear all from cart

      ### PURCHASE ORDER ###
      $tracer.trace("CREATE_PURCHASE_ORDER_FROM_CART")
      create_purchase_order_rsp = @purchase_order_svc.perform_create_purchase_order_from_cart(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @purchase_order_svc_version)
      #get the response data for later comparisons
      create_purchase_cart_items = create_purchase_order_rsp.http_body.find_tag("line_items").at(0)
      purchase_order_shipment_ids = create_purchase_order_rsp.http_body.find_tag("shipment_id")
      purchase_order_shipment_groups = create_purchase_order_rsp.http_body.find_tag("shipment")

      $tracer.trace("ADD_CHANNEL_ATTRIBUTES_TO_PURCHASE_ORDER")
      @purchase_order_svc.perform_add_channel_attributes_to_purchase_order(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @params["Brand"], get_ip, @purchase_order_svc_version)

      if ispu
        store_address = @store_search_svc.perform_find_stores_in_range(@session_id, @params["ClientChannel"], @params["Locale"], @store_search_svc_version)
        ### ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS FOR EACH SHIPMENT GROUP ###
        @purchase_order_svc.perform_add_store_addresses_to_shipments(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @purchase_order_svc_version, @params, store_address, purchase_order_shipment_ids)
      else
        $tracer.trace("ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS FOR EACH SHIPMENT GROUP")
        @purchase_order_svc.perform_add_shipping_addresses_to_shipments(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @purchase_order_svc_version, @params, purchase_order_shipment_ids)
      end

      $tracer.trace("ADD_CUSTOMER_TO_PURCHASE_ORDER")
      @purchase_order_svc.perform_add_customer_to_purchase_order(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @purchase_order_svc_version, @open_id, @is_guest, @params)

      if ispu
        ### GET_AVAILABLE_SHIPPING_METHODS FOR EACH SHIPMENT GROUP ###
        @shipping_cost = Hash.new
        get_available_shipping_methods_rsp = @shipping_svc.perform_get_available_shipping_methods_ispu(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @shipping_svc_version, @params, store_address, purchase_order_shipment_groups)
        # choosing the first available shipping option
        calculated_shipping_method = get_available_shipping_methods_rsp.http_body.find_tag("calculated_shipment").at(0).shipping_methods.calculated_shipping_method.at(0)
        ### ADD_SHIPPING_METHODS_TO_SHIPMENTS ###
        create_purchase_order_rsp.http_body.find_tag("shipment").each_with_index do |po_shipment, i|
          shipment_id = po_shipment.shipment_id.content
          @shipping_cost[shipment_id] = calculated_shipping_method.shipping_cost.content

          @purchase_order_svc.perform_add_shipping_methods_to_shipments(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], shipment_id, calculated_shipping_method, @purchase_order_svc_version)
        end
      else
        ### SHIPPING ###
        $tracer.trace("GET_AVAILABLE_SHIPPING_METHODS FOR EACH SHIPMENT GROUP")
        @shipping_cost = Hash.new
        get_available_shipping_methods_rsp = @shipping_svc.perform_get_available_shipping_methods(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @shipping_svc_version, @params, purchase_order_shipment_groups)

        calculated_shipping_methods = get_available_shipping_methods_rsp.http_body.find_tag("calculated_shipment").at(0).shipping_methods.calculated_shipping_method
        calculated_shipping_method = nil

        calculated_shipping_methods.each_with_index do |x, i|
          $tracer.trace(x.display_name.content)
          if x.display_name.content == @params["shipping_option"]
            calculated_shipping_method = calculated_shipping_methods[i]
          end
        end
      end

      $tracer.trace("ADD_SHIPPING_METHODS_TO_SHIPMENTS")
      create_purchase_order_rsp.http_body.find_tag("shipment").each_with_index do |po_shipment, i|
        shipment_id = po_shipment.shipment_id.content

        @shipping_cost[shipment_id] = calculated_shipping_method.shipping_cost.content
        @purchase_order_svc.perform_add_shipping_methods_to_shipments(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], shipment_id, calculated_shipping_method, @purchase_order_svc_version)
      end

      $tracer.trace("CALCULATE_TAX")
      if ispu
        calculate_tax_rsp = @tax_svc.perform_calculate_tax_for_ispu(@session_id, @params["ClientChannel"], @params["Locale"], @params["Currency"], @params, store_address, @cart_svc_version, purchase_order_shipment_groups, @shipping_cost, @results_from_file.at(0).taxabilitycode)
      else
        calculate_tax_rsp = @tax_svc.perform_calculate_tax(@session_id, @params["ClientChannel"], @params["Locale"], @params["Currency"], @params, @cart_svc_version, purchase_order_shipment_groups, @shipping_cost, @results_from_file.at(0).taxabilitycode)
      end

      ### PURCHASE ORDER ###
      $tracer.trace("VALIDATE_PURCHASE_ORDER2")
      validate_purchase_order_rsp = @purchase_order_svc.perform_validate_purchase_order2(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @purchase_order_svc_version)
      messages_data = validate_purchase_order_rsp.http_body.find_tag("messages").at(0)
      messages_data.purchase_order_validation_message.each do |msg|
        if msg.message.content.include?("verification of mature")
          $tracer.trace("CONFIRM_AGE_GATE")
          @purchase_order_svc.perform_confirm_age_gate(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @cart_svc_version)
          break # no need to confirm age gate more than once
        end if msg.message.exists
      end if messages_data.purchase_order_validation_message.exists == true

      $tracer.trace("GET_PURCHASE_ORDER")
      get_purchase_order_rsp = @purchase_order_svc.perform_get_purchase_order(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @purchase_order_svc_version)

      #@payment_svc.perform_check_fraud(@session_id, @owner_id, @payment_svc, @params, get_purchase_order_rsp, @payment_svc_version)

      @purchase_order_id = get_purchase_order_rsp.http_body.find_tag("purchase_order_id").at(0).content
      total = get_purchase_order_rsp.http_body.find_tag("total").content
      get_purchase_order_rsp.http_body.find_tag("result").content.should == "Success"
      $tracer.trace("PURCHASE")

      #if the "Checkout" flag in the dataset csv has any value other than "true" the script will not complete checkout.
      if @params['Checkout']
        $tracer.trace("PAYMENT OPTIONS")
        if @params['pay_type'].downcase == "svs"
          $tracer.report("Paid with SVS")
          purchase_rsp = @purchase_order_svc.perform_purchase_with_svs_card(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @params, @purchase_order_svc_version)
        end

        if @params['pay_type'].downcase == "generate"
          # Tokenize the payment
          cc = @common_functions.generate_credit_card_svc("generate")
          $tracer.report(cc[:cnum])
          cc_enum = @payment_svc.credit_card_type_mapping(cc)
          $tracer.report(cc_enum)
          data = @payment_svc.hash_the_data(cc, @params, date_time = nil, @transaction_uuid, @reference_number)
          $tracer.report(data.inspect)
          signature, date = @payment_svc.call_for_signature(data, @transaction_uuid, @reference_number, @params["BillEmail"])
          $tracer.report("#{signature} #{date}")
          data2 = @payment_svc.hash_the_data(cc, @params, date, @transaction_uuid, @reference_number)
          $tracer.report("#{data2.inspect}")
          token_resp = @payment_svc.call_to_silent_pay(@transaction_uuid, @reference_number, @params["BillEmail"], signature, date, data2, cc, cc_enum, sprintf('%.2f', total.to_f))
          $tracer.report(token_resp.inspect)
          payment_token = token_resp.forms[0]["payment_token"]
          token_resp.forms[0]["reason_code"].should == "100"
          # The Generate Credit Card method will report the new credit card information in the special report summary
          purchase_rsp = @purchase_order_svc.perform_purchase_with_generated_credit_card(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @params, @purchase_order_svc_version, @params["BillEmail"], @common_functions, total, cc, cc_enum, payment_token)
        end

        if @params['pay_type'].downcase == "cc"
          $tracer.report("Paid with Credit Card defined in dataset")
          purchase_rsp = @purchase_order_svc.perform_purchase_with_credit_card(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @params, @purchase_order_svc_version, @login, @common_functions, total)
        end

        if @params['pay_type'].downcase == "mixed"
          $tracer.report("NOT IMPLEMENTED YET")
          # TODO : Support mixed tender types - SVS + Credit Card
        end

        if @params['pay_type'].downcase == "wallet"
          $tracer.report("NOT IMPLEMENTED YET")
          # TODO : Call to the payment gateway to get the digital wallet for the user checking out.  This should only be valid for existing users.
        end

        $tracer.trace("Validates that the purchase was successfully posted after applying the payment method details")
        purchase_rsp.http_body.find_tag("purchase_successful").content.should == 'true'

        $tracer.trace("Get the order confirmation number for later validation")
        order_tracking_number = purchase_rsp.http_body.find_tag("order_tracking_number").content
        $tracer.report("Order Number: #{order_tracking_number}")
        $tracer.trace("Expected Totals")
        expected_subtotal = BigDecimal("0")
        expected_shipping_cost = BigDecimal("0")
        expected_total_tax = BigDecimal("0")

        calculate_tax_rsp.http_body.find_tag("line_items").each do |item|
          item.line_item.each_with_index do |item|
            #unless item.description.content == "Digital"
            expected_shipping_cost += money_string_to_decimal(item.shipping_cost.content)
            expected_total_tax += money_string_to_decimal(item.tax.content) + money_string_to_decimal(item.shipping_tax.content)
            #end
          end
        end

        create_purchase_order_rsp.http_body.find_tag("line_items").each do |item|
          item.line_item.each_with_index do |item|
            expected_subtotal += money_string_to_decimal(item.list_price.content)*money_string_to_decimal(item.quantity.content)
          end
        end

        #expected_total_tax  += money_string_to_decimal(calculate_tax_rsp.http_body.find_tag("tax").at(0).content)
        $tracer.trace("Actual totals")
        actual_total_tax = money_string_to_decimal(purchase_rsp.http_body.find_tag("total_tax").content)
        actual_total = money_string_to_decimal(purchase_rsp.http_body.find_tag("purchase_order").total.content)
        actual_subtotal = money_string_to_decimal(purchase_rsp.http_body.find_tag("purchase_order").sub_total.content)
        actual_shipping = money_string_to_decimal(purchase_rsp.http_body.find_tag("total_shipping_cost").content)
        actual_discount = money_string_to_decimal(purchase_rsp.http_body.find_tag("total_discount").content)

        expected_total = expected_subtotal + expected_shipping_cost + expected_total_tax - actual_discount

        $tracer.trace("expected tax: #{expected_total_tax.to_f} - actual : #{actual_total_tax.to_f}")
        $tracer.trace("expected subtotal: #{expected_subtotal.to_f} - actual : #{actual_subtotal.to_f}")
        $tracer.trace("expected shipping: #{expected_shipping_cost.to_f}  - actual #{actual_shipping.to_f}")
        $tracer.trace("actual discount   #{actual_discount.to_f}")
        $tracer.trace("expected total: #{expected_total.to_f} - actual : #{actual_total.to_f}")

        $tracer.trace("Assertion Collection")
        $tracer.trace("Assert actual tax is same as expected tax")
        actual_total_tax.should == expected_total_tax

        $tracer.trace("Assert actual sub-total is same as expected sub-total")
        actual_subtotal.should == expected_subtotal

        $tracer.trace("Assert actual total is same as expected total")
        actual_total.should == expected_total

        #Assert details_extension table has orders placed with @params['SVS'] payment
        #Remember split orders will append a 'D' or 'P' for the split
        $tracer.report("\nPurchase order submitted")
        $tracer.trace("GET_PURCHASE_ORDER_BY_TRACKING_NUMBER")
        $tracer.trace("If the purchase is successful then retrieves the purchase order by tracking number")
        @purchase_order_svc.perform_get_placed_order(@session_id, @params["ClientChannel"], @params["Locale"], order_tracking_number, @purchase_order_svc_version) if purchase_rsp.http_body.find_tag("purchase_successful").content == "true"
      end
  end

  def report_summary
    #standard service data
    $tracer.report("Brand : #{@params['Brand']}")
    $tracer.report("Client Channel : #{@params['ClientChannel']}")
    $tracer.report("locale : #{@params['Locale']}")
    $tracer.report("currency : #{@params['Currency']}")
    $tracer.report("Qty Increase? : #{@params['QtyIncrease']}")
    $tracer.report("Open ID : #{@open_id}")

    #discount information
    $tracer.report("Loyalty Card : #{@params['LoyaltyCardNumber']}")
    $tracer.report("Promo Code : #{@params['PromoCode']}")

    #payment information
    $tracer.report("Payment Type : #{@params['pay_type']}")
    if @params['pay_type'].downcase == "cc"
      $tracer.report("Credit Card : #{@params['CreditCard']}")
      $tracer.report("CC Type : #{@params['CCType']}")
      $tracer.report("CC Month : #{@params['ExpMonth']}")
      $tracer.report("CC Year : #{@params['ExpYear']}")
      $tracer.report("CVV : #{@params['CVV']}")
    end

    if @params['pay_type'].downcase == "svs"
      $tracer.report("SVS Account : #{@params['SVS']}")
      $tracer.report("SVS PIN : #{@params['PIN']}")
    end

    $tracer.report("Shipment Type : #{@params['ShipmentType']}")
    $tracer.report("Handling Option : #{@params['shipping_option']}")
    $tracer.report("Complete Checkout? : #{@params['Checkout']}")
  end

  # TODO : Move these to call an address data pool
  def initialize_shipping_addr_params
    #shipping address information
    @ship_email = @params["ShipEmail"]
    @ship_phone = @params["ShipPhone"]
    @ship_city = @params["ShipCity"]
    @ship_country_code = @params["ShipCountryCode"]
    @ship_line1 = @params["ShipLine1"]
    @ship_line2 = @params["ShipLine2"]
    @ship_postal_code = @params["ShipPostalCode"]
    @ship_state = @params["ShipState"]
    @ship_first_name = @params["ShipFirstName"]
    @ship_last_name = @params["ShipLastName"]
    @ship_address_id = generate_guid
  end

  # TODO : Move these to call an address data pool
  def initialize_billing_addr_params
    #billing address information
    @bill_email = @params["BillEmail"]
    @bill_phone = @params["BillPhone"]
    @bill_city = @params["BillCity"]
    @bill_country_code = @params["BillCountryCode"]
    @bill_line1 = @params["BillLine1"]
    @bill_line2 = @params["BillLine2"]
    @bill_postal_code = @params["BillPostalCode"]
    @bill_state = @params["BillState"]
    @bill_first_name = @params["BillFirstName"]
    @bill_last_name = @params["BillLastName"]
    @bill_address_id = generate_guid
  end

end



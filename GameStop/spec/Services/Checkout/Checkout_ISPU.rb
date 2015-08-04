###################################################################################
###This script is used to checkout single or multiple In Store Pick Up products
####################################################################################

###USAGE NOTES
### Run this script using the following command

###  **Guest User, Checkout ONLY REQUIRED PARAMETERS IN THE COMMAND LINE
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_ISPU.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range "TFS46048" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1  --or
###
###  **Authenticated User, Checkout ONLY REQUIRED PARAMETERS IN THE COMMAND LINE
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_ISPU.rb --login qa_srvcs_atmtn@qagsecomprod.oib.com --password T3sting --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range "TFS46047"  --or


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

describe "GameStop Checkout Scenario Tests" do

  before(:all) do
#We will initialize our connections and data sets for the test by taking the option parameters passed by the command line 
    $tracer.mode = :on
    $tracer.echo = :on
  end

  before(:each) do
    #get the --csv parameter and read the file, --range identifies the row of data to use per test case
    #range will now define the TFS ID to use in relation to the MTM test case created.

    csv = QACSV.new(csv_filename_parameter)
    @row = csv.find_row_by_name(csv_range_parameter)

    #initialize the services to be used for the test
    @global_functions = GlobalServiceFunctions.new()
    @global_functions.csv = @row
    @global_functions.parameters
    #@global_functions.csv_params
    @sql = @global_functions.sql_file
    @db = @global_functions.db_conn
    @cart_svc, @cart_service_version = @global_functions.cart_svc
    @account_svc, @account_svc_version = @global_functions.account_svc
    @purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
    @shipping_svc, @shipping_svc_version = @global_functions.shipping_svc
    #@icheckout_svc = @global_functions.checkout_svc
    @tax_svc, @tax_svc_version = @global_functions.tax_svc
    @store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc


#user name and password are provided throught the command line parameter
#if no user name or password are provided the script will authorize the user as anonymous

#generate a new session id guid.  the generate_guid function uses uuidtools to generate guids on the fly.
    @session_id = generate_guid

#get the user name and password provided using the --login and --password parameters if provided.
#if the parameters were not passed the script will assume you want to authorize anonymously
#TODO - if the parameters are passed and the user is not registered, register the new user and authorize
    user_name, user_password = nil
    begin
      user_name = account_login_parameter
      user_password = account_password_parameter
    rescue Exception => ex
      account_login_parameter = nil
    end

#get results from the sql file
    sql = @sql.to_s
    @results_from_file = @db.exec_sql_from_file(sql)

#passes parameters to the DSL to get the ownerid.  the ownerid is used throughout the remainder of the script as the identifier for the cart/purchaseorder
    @owner_id = @account_svc.perform_authorization_and_return_owner_id(@session_id, user_name, user_password, @account_svc_version)

    #set instance variables for csv driven data elements
    initialize_csv_params

    #checks to ensure the cart is empty before proceeding
    @cart_svc.perform_empty_cart(@session_id, @owner_id, @client_channel, @locale, @cart_service_version)
  end


#[TestMethod]
  it "should Checkout using dataset defined" do
    iteration = 0
    count = 0
    orders = 50

    while count < orders do
#Add products to cart
#set the variantid's from the query results
      @calculated_shipping_cost = 0
      @expected_total_tax = 0
      sku_qty_list = []

      @results_from_file.each_with_index do |sku, i|
        # statement you see below is called ternary operation (?:). It's equivalent to the if/esle statement . The bellow can be wrirren as
        # qty = o
        # if  i == 2
        #     qty = 1 + @qty_increase.to_i
        # else
        #     qty = 1
        # end
        qty = i == 2 ? 1 + @qty_increase.to_i : 1
        sku_qty_list.push(sku.variantid, qty)
      end

      @cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list, @client_channel, @locale, @cart_service_version)
      line_item_ids = @cart_svc.perform_get_cart_and_return_guids(@session_id, @owner_id, @client_channel, @locale, @cart_service_version)

      #Change the fulfillment channel of all cart lineitems from ShipToAddress to InStorePickUp
      @cart_svc.perform_modify_line_item_fulfillment_channels_and_return_message(@session_id, @owner_id, *line_item_ids, @shipment_type, @client_channel, @locale, @cart_service_version)

      ######################
      ### PURCHASE ORDER ###
      ######################

      ### CREATE_PURCHASE_ORDER_FROM_CART ###

      create_purchase_order_rsp = @purchase_order_svc.perform_create_purchase_order_from_cart(@session_id, @owner_id, @client_channel, @locale, @purchase_order_svc_version)
      #get the response data for later comparisons
      create_purchase_cart_items = create_purchase_order_rsp.http_body.find_tag("line_items").at(0)
      purchase_order_shipment_ids = create_purchase_order_rsp.http_body.find_tag("shipment_id")
      purchase_order_shipment_groups = create_purchase_order_rsp.http_body.find_tag("shipment")

      ### ADD_CHANNEL_ATTRIBUTES_TO_PURCHASE_ORDER ###

      @purchase_order_svc.perform_add_channel_attributes_to_purchase_order(@session_id, @owner_id, @client_channel, @locale, @brand, get_ip, @purchase_order_svc_version)

      ###################
      ### STORE SEARCH###
      ###################

      ### FIND_STORES_IN_RANGE ###

      store_address = @store_search_svc.perform_find_stores_in_range(@session_id, @client_channel, @locale, @store_search_svc_version)

      ### ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS FOR EACH SHIPMENT GROUP ###
      @purchase_order_svc.perform_add_store_addresses_to_shipments(@session_id, @owner_id, @client_channel, @locale, @purchase_order_svc_version, @row, store_address, purchase_order_shipment_ids)

      ### ADD_CUSTOMER_TO_PURCHASE_ORDER ###
      @purchase_order_svc.perform_add_customer_to_purchase_order(@session_id, @owner_id, @client_channel, @locale, @purchase_order_svc_version, openid, is_guest, @row)

      ################
      ### SHIPPING ###
      ################

      ### GET_AVAILABLE_SHIPPING_METHODS FOR EACH SHIPMENT GROUP ###

      @shipping_cost = Hash.new

      get_available_shipping_methods_rsp = @shipping_svc.perform_get_available_shipping_methods_ispu(@session_id, @owner_id, @client_channel, @locale, @shipping_svc_version, @row, store_address, purchase_order_shipment_groups)

      # choosing the first available shipping option
      calculated_shipping_method = get_available_shipping_methods_rsp.http_body.find_tag("calculated_shipment").at(0).shipping_methods.calculated_shipping_method.at(0)


      ### ADD_SHIPPING_METHODS_TO_SHIPMENTS ###
      create_purchase_order_rsp.http_body.find_tag("shipment").each_with_index do |po_shipment, i|
        shipment_id = po_shipment.shipment_id.content
        @shipping_cost[shipment_id] = calculated_shipping_method.shipping_cost.content

        @purchase_order_svc.perform_add_shipping_methods_to_shipments(@session_id, @owner_id, @client_channel, @locale, shipment_id, calculated_shipping_method, @purchase_order_svc_version)
      end

      ### CALCULATE_TAX ###

      calculate_tax_rsp = @tax_svc.perform_calculate_tax_for_InStorePickUp(@session_id, @client_channel, @locale, @currency, @row, store_address, @cart_svc_version, purchase_order_shipment_groups, @shipping_cost, @results_from_file.at(0).taxabilitycode)


      ######################
      ### PURCHASE ORDER ###
      ######################

      ### VALIDATE_PURCHASE_ORDER2 ###

      validate_purchase_order_rsp = @purchase_order_svc.perform_validate_purchase_order2(@session_id, @owner_id, @client_channel, @locale, @purchase_order_svc_version)

      # search validation and search if age gate is needed.

      messages_data = validate_purchase_order_rsp.http_body.find_tag("messages").at(0)
      if messages_data.purchase_order_validation_message.exists == true
        messages_data.purchase_order_validation_message.each do |msg|
          if msg.message.exists
            if msg.message.content.include?("verification of mature")

              ### CONFIRM_AGE_GATE ###

              @purchase_order_svc.perform_confirm_age_gate(@session_id, @owner_id, @client_channel, @locale, @cart_svc_version)

              break # no need to confirm age gate more than once
            end
          end
        end
      end

      ### GET_PURCHASE_ORDER ###

      get_purchase_order_rsp = @purchase_order_svc.perform_get_purchase_order(@session_id, @owner_id, @client_channel, @locale, @purchase_order_svc_version)

      get_purchase_order_rsp.http_body.find_tag("result").content.should == "Success"


      ### PURCHASE ###
      #if the "Checkout" flag in the dataset csv has any value other than "true" the script will not complete checkout.
      if @complete_checkout == "true"

        purchase_rsp = @purchase_order_svc.perform_purchase_with_credit_card(@session_id, @owner_id, @client_channel, @locale, @row, @purchase_order_svc_version)
        purchase_rsp.http_body.find_tag("purchase_successful").content.should == "true"
        #Get the order confirmation number for later validation
        order_tracking_number = purchase_rsp.http_body.find_tag("order_tracking_number").content

        #Expected Totals
        expected_subtotal = BigDecimal.new("0")
        expected_shipping_cost = BigDecimal.new("0")
        expected_total_tax = BigDecimal.new("0")

        calculate_tax_rsp.http_body.find_tag("line_items").each do |item|
          item.line_item.each_with_index do |item|
            expected_shipping_cost += money_string_to_decimal(item.shipping_cost.content)
            expected_total_tax += money_string_to_decimal(item.tax.content) + money_string_to_decimal(item.shipping_tax.content)
          end

        end

        create_purchase_order_rsp.http_body.find_tag("line_items").each do |item|
          item.line_item.each_with_index do |item|
            expected_subtotal = expected_subtotal + money_string_to_decimal(item.list_price.content)*money_string_to_decimal(item.quantity.content)
          end
        end

        expected_total = expected_subtotal + expected_shipping_cost + expected_total_tax

        #Actual totals
        actual_total_tax = money_string_to_decimal(purchase_rsp.http_body.find_tag("total_tax").content)
        actual_total = money_string_to_decimal(purchase_rsp.http_body.find_tag("purchase_order").total.content)
        actual_shipping = money_string_to_decimal(purchase_rsp.http_body.find_tag("total_shipping_cost").content)
        actual_subtotal = money_string_to_decimal(purchase_rsp.http_body.find_tag("purchase_order").sub_total.content)

        puts "**************************************************************************************************************"
        puts "expected tax: #{expected_total_tax.to_f} - actual : #{actual_total_tax.to_f}"
        puts "expected subtotal: #{expected_subtotal.to_f} - actual : #{actual_subtotal.to_f}"
        puts "expected shipping: #{expected_shipping_cost.to_f} - actual : #{actual_shipping.to_f}"
        puts "expected total: #{expected_total.to_f} - actual : #{actual_total.to_f}"
        puts "**************************************************************************************************************"


        ##########################
        ## Assertion Collection ##
        ##########################

        #assert actual tax is same as expected tax

        actual_total_tax.should == expected_total_tax

        #assert actual sub-total is same as expected sub-total
        actual_subtotal.should == expected_subtotal

        #assert actual total is same as expected total
        actual_total.should == expected_total

        #assert shipping
        expected_shipping_cost.should == actual_shipping

        ###GET_PURCHASE_ORDER_BY_TRACKING_NUMBER###

        #If the purchase is successful then retrieves the purchase order by tracking number
        if purchase_rsp.http_body.find_tag("purchase_successful").content == "true"
          @purchase_order_svc.perform_get_placed_order(@session_id, @client_channel, @locale, order_tracking_number, @purchase_order_svc_version)
          #@purchase_order_svc.perform_get_purchase_order_by_tracking_number(@session_id, @client_channel, @locale, order_tracking_number, @purchase_order_svc_version)
        end
      end
    end
  end

  def initialize_csv_params
    @testcaseid = @row.find_value_by_name("ID")
    $tracer.trace("TFS Test Case ID: #{@testcaseid}")

    @testdesc = @row.find_value_by_name("TestDescription")
    $tracer.trace("Test Description: #{@testdesc}")

    #standard service data
    @brand = @row.find_value_by_name("Brand")
    $tracer.trace("brand : #{@brand}")
    @client_channel = @row.find_value_by_name("ClientChannel")
    $tracer.trace("Client Channel : #{@client_channel}")
    @locale = @row.find_value_by_name("Locale")
    $tracer.trace("locale : #{@locale}")
    @currency = @row.find_value_by_name("Currency")
    $tracer.trace("currency : #{@currency}")

    #discounts
    @loyalty_card_number = @row.find_value_by_name("LoyaltyCardNumber")
    @loyalty_card_id = @row.find_value_by_name("LoyaltyCardId")
    @promo_code = @row.find_value_by_name("PromoCode")

    #payments
    @credit_card = @row.find_value_by_name("CreditCard")
    @cc_type = @row.find_value_by_name("CCType")
    @exp_month = @row.find_value_by_name("ExpMonth")
    @exp_year = @row.find_value_by_name("ExpYear")
    @svs = @row.find_value_by_name("SVS")
    @pin = @row.find_value_by_name("PIN")
    @cvv = @row.find_value_by_name("CVV")
    @shipment_type = @row.find_value_by_name("ShipmentType")
    @complete_checkout = @row.find_value_by_name("Checkout")
    @qty_increase = @row.find_value_by_name("QtyIncrease")

    $tracer.trace("Complete Checkout? : #{@complete_checkout}")

    #shipping address information
    @ship_email = @row.find_value_by_name("ShipEmail")
    @ship_phone = @row.find_value_by_name("ShipPhone")
    @ship_city = @row.find_value_by_name("ShipCity")
    @ship_country_code = @row.find_value_by_name("ShipCountryCode")
    @ship_line1 = @row.find_value_by_name("ShipLine1")
    @ship_line2 = @row.find_value_by_name("ShipLine2")
    @ship_postal_code = @row.find_value_by_name("ShipPostalCode")
    @ship_state = @row.find_value_by_name("ShipState")
    @ship_first_name = @row.find_value_by_name("ShipFirstName")
    @ship_last_name = @row.find_value_by_name("ShipLastName")
    @ship_address_id = generate_guid

    #billing address information
    @bill_email = @row.find_value_by_name("BillEmail")
    @bill_phone = @row.find_value_by_name("BillPhone")
    @bill_city = @row.find_value_by_name("BillCity")
    @bill_country_code = @row.find_value_by_name("BillCountryCode")
    @bill_line1 = @row.find_value_by_name("BillLine1")
    @bill_line2 = @row.find_value_by_name("BillLine2")
    @bill_postal_code = @row.find_value_by_name("BillPostalCode")
    @bill_state = @row.find_value_by_name("BillState")
    @bill_first_name = @row.find_value_by_name("BillFirstName")
    @bill_last_name = @row.find_value_by_name("BillLastName")
    @bill_address_id = generate_guid
  end
end



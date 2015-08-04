#####################################################################
###USAGE NOTES
###Run this script using the following command
###############################################################################################################################################################################################################
###                                       Single execution in QA2 using an available product (not digital or download)                                                                                       ###
###############################################################################################################################################################################################################

### *******  Authenticated User, Checkout WITH ALL RUN TIME PARAMETERS *******
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\Checkout_with_SVS.rb --login qa_srvcs_atmtn@qagsecomprod.oib.com --password T3sting --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range "TFS45293" --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --or
###
###  ******* Guest User, Checkout  WITH ALL RUN TIME PARAMETERS *******
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\Checkout_with_SVS.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv  --range "TFS45294" --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --or
###
### *******  Authenticated User, Checkout WITH ONLY REQUIRED RUN TIME PARAMETERS *******
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\Checkout_with_SVS.rb --login qa_srvcs_atmtn@qagsecomprod.oib.com --password T3sting --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range "TFS45293" --or
###
###  ******* Guest User, Checkout  WITH ONLY REQUIRED TIME PARAMETERS *******
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\Checkout_with_SVS.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv  --range "TFS45294"  --or
###
### Additional sceanrios can be constructed by manipulating the data input.
### Facilitates authenticated and anonymous checkout.  To run as an authenticated session use the following parameters: --login user@test.com --password P@55w0rd!
### 
###Author: dturner/rsickles

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()
$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "GameStop Checkout Scenario Tests" do

  before(:all) do
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @account_svc, @account_svc_version = $global_functions.account_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @shipping_svc, @shipping_svc_version = $global_functions.shipping_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
    @tax_svc, @tax_svc_version = $global_functions.tax_svc
    @payment_svc, @payment_svc_version = $global_functions.payment_svc
  end

  before(:each) do
		@session_id = generate_guid
    @open_id = nil
    @results_from_file = @db.exec_sql_from_file(@sql.to_s)

    #set instance variables for csv driven data elements
    report_summary
    initialize_shipping_addr_params
    initialize_billing_addr_params

		@login = @login.downcase unless @login.nil?
		@login = nil if @login == ""

    if @login.nil?
      @user_id, @token = @account_svc.perform_authorize_anonymous(@session_id, @login, @password, @account_svc_version)
      @owner_id = generate_guid
      $tracer.report("Guest user")
    end

    if @login == "register"
      @login, @password = @account_svc.create_new_user(@session_id, @login, @password, @account_svc_version)
      $tracer.report("Registered user: \n\tuser: #{@login}, \n\tpassword: #{@password}")
    end

    if (@login != nil)
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

    sku_qty_list = []
    @results_from_file.each_with_index do |sku, i|
      qty = i == 2 ? 1 + @qty_increase.to_i : 1
      sku_qty_list.push(sku.variantid, qty)
    end
    @cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list, @params["ClientChannel"], @params["Locale"], @cart_svc_version)
    ### PURCHASE ORDER ###

    ### CREATE_PURCHASE_ORDER_FROM_CART ###
    create_purchase_order_rsp = @purchase_order_svc.perform_create_purchase_order_from_cart(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @purchase_order_svc_version)
		#get the response data for later comparisons
    create_purchase_cart_items = create_purchase_order_rsp.http_body.find_tag("line_items").at(0)
    purchase_order_shipment_ids = create_purchase_order_rsp.http_body.find_tag("shipment_id")
    purchase_order_shipment_groups = create_purchase_order_rsp.http_body.find_tag("shipment")

    ### ADD_CHANNEL_ATTRIBUTES_TO_PURCHASE_ORDER ###
    @purchase_order_svc.perform_add_channel_attributes_to_purchase_order(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @params["Brand"], get_ip, @purchase_order_svc_version)
    ### ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS ###
    @purchase_order_svc.perform_add_shipping_addresses_to_shipments(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @purchase_order_svc_version, @params, purchase_order_shipment_ids)
    ### ADD_CUSTOMER_TO_PURCHASE_ORDER ###
    # @purchase_order_svc.perform_add_customer_to_purchase_order(@session_id, @owner_id, @client_channel, @locale, @purchase_order_svc_version, @row)
		@purchase_order_svc.perform_add_customer_to_purchase_order(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @purchase_order_svc_version, @open_id, @is_guest, @params)
		### SHIPPING ###

    ### GET_AVAILABLE_SHIPPING_METHODS ###
    @shipping_cost = Hash.new
    get_available_shipping_methods_rsp = @shipping_svc.perform_get_available_shipping_methods(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @shipping_svc_version, @params, purchase_order_shipment_groups)
		# choosing the first available shipping option
    calculated_shipping_method = get_available_shipping_methods_rsp.http_body.find_tag("calculated_shipment").at(0).shipping_methods.calculated_shipping_method.at(0)

    ### ADD_SHIPPING_METHODS_TO_SHIPMENTS ###
    create_purchase_order_rsp.http_body.find_tag("shipment").each_with_index do |po_shipment, i|
      shipment_id = po_shipment.shipment_id.content
      @shipping_cost[shipment_id] = calculated_shipping_method.shipping_cost.content
      @purchase_order_svc.perform_add_shipping_methods_to_shipments(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], shipment_id, calculated_shipping_method, @purchase_order_svc_version)
		end

    ### CALCULATE_TAX ###
    calculate_tax_rsp = @tax_svc.perform_calculate_tax(@session_id, @params["ClientChannel"], @params["Locale"], @params["Currency"], @params, @cart_svc_version, purchase_order_shipment_groups, @shipping_cost, @results_from_file.at(0).taxabilitycode)
    ### PURCHASE ORDER ###

    ### VALIDATE_PURCHASE_ORDER2 ###
    validate_purchase_order_rsp = @purchase_order_svc.perform_validate_purchase_order2(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @purchase_order_svc_version)
    # search validation and search if age gate is needed.
    messages_data = validate_purchase_order_rsp.http_body.find_tag("messages").at(0)
    messages_data.purchase_order_validation_message.each do |msg|
      if msg.message.content.include?("verification of mature")
        ### CONFIRM_AGE_GATE ###
        @purchase_order_svc.perform_confirm_age_gate(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @cart_svc_version)
        break # no need to confirm age gate more than once
      end if msg.message.exists
    end if messages_data.purchase_order_validation_message.exists == true

    ### GET_PURCHASE_ORDER ###
    get_purchase_order_rsp = @purchase_order_svc.perform_get_purchase_order(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @purchase_order_svc_version)
    get_purchase_order_rsp.http_body.find_tag("result").content.should == "Success"

    ### PURCHASE ###
    #if the "Checkout" flag in the dataset csv has any value other than "true" the script will not complete checkout.
    if @complete_checkout == "true"
      purchase_rsp = @purchase_order_svc.perform_purchase_with_svs_card(@session_id, @owner_id, @params["ClientChannel"], @params["Locale"], @params, @purchase_order_svc_version)
      purchase_rsp.http_body.find_tag("purchase_successful").content.should == "true"
      #Get the order confirmation number for later validation
      order_tracking_number = purchase_rsp.http_body.find_tag("order_tracking_number").content
      #Expected Totals
      expected_subtotal = BigDecimal("0")
      expected_shipping_cost = BigDecimal("0")
      expected_total_tax = BigDecimal("0")

      calculate_tax_rsp.http_body.find_tag("line_items").each do |item|
        item.line_item.each_with_index do |item|
          expected_shipping_cost += money_string_to_decimal(item.shipping_cost.content)
          expected_total_tax += money_string_to_decimal(item.tax.content) + money_string_to_decimal(item.shipping_tax.content)
        end
      end

      create_purchase_order_rsp.http_body.find_tag("line_items").each do |item|
        item.line_item.each_with_index do |item|
          expected_subtotal += money_string_to_decimal(item.list_price.content)*money_string_to_decimal(item.quantity.content)
        end
      end

      expected_total = expected_subtotal + expected_shipping_cost + expected_total_tax
      #Actual totals
      actual_total_tax = money_string_to_decimal(purchase_rsp.http_body.find_tag("total_tax").content)
      actual_total = money_string_to_decimal(purchase_rsp.http_body.find_tag("purchase_order").total.content)
      actual_subtotal = money_string_to_decimal(purchase_rsp.http_body.find_tag("purchase_order").sub_total.content)
      actual_shipping = money_string_to_decimal(purchase_rsp.http_body.find_tag("total_shipping_cost").content)

      puts "**************************************************************************************************************"
      puts "expected tax: #{expected_total_tax.to_f} - actual : #{actual_total_tax.to_f}"
      puts "expected subtotal: #{expected_subtotal.to_f} - actual : #{actual_subtotal.to_f}"
      puts "expected subtotal: #{expected_shipping_cost.to_f} - actual : #{actual_shipping.to_f}"
      puts "expected total: #{expected_total.to_f} - actual : #{actual_total.to_f}"
      puts "**************************************************************************************************************"

      ## Assertion Collection ##
      #assert actual tax is same as expected tax
      actual_total_tax.should == expected_total_tax
      #assert actual sub-total is same as expected sub-total
      actual_subtotal.should == expected_subtotal
      #assert actual total is same as expected total
      actual_total.should == expected_total
      #assert shipping
      expected_shipping_cost.should == actual_shipping

      #Assert details_extension table has orders placed with @svs payment
      #Remember split orders will append a 'D' or 'P' for the split

      ###GET_PURCHASE_ORDER_BY_TRACKING_NUMBER###
      #If the purchase is successful then retrieves the purchase order by tracking number
      if purchase_rsp.http_body.find_tag("purchase_successful").content == "true"
        @purchase_order_svc.perform_get_placed_order(@session_id, @params["ClientChannel"], @params["Locale"], order_tracking_number, @purchase_order_svc_version) if purchase_rsp.http_body.find_tag("purchase_successful").content == "true"
      end
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
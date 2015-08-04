require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

describe "GameStop SOAP Cart Services Tests" do

    before(:all) do
        $tracer.mode = :on
        $tracer.echo = :on

        @cart_svc = CartService.new("http://qa.services.gamestop.com/Ecom/Orders/Cart/v1/CartService.svc?wsdl")
        @account_svc = AccountService.new("http://qa.services.gamestop.com/Ecom/Customers/Account/v1/AccountService.svc?wsdl")
        @purchase_order_svc = PurchaseOrderService.new("http://qa.services.gamestop.com/Ecom/Orders/PurchaseOrder/v1/PurchaseOrderService.svc?wsdl")
        @shipping_svc = ShippingService.new("http://qa.services.gamestop.com/Ecom/Orders/Fulfillment/Shipping/v1/ShippingService.svc?wsdl")
        @icheckout_svc = ICheckoutService.new("http://qa.services.gamestop.com/Ecom/Orders/Checkout/v1/CheckoutService.xamlx?wsdl")

        tax_svc_config = SoapAgentConfig.new
        tax_svc_config.set_end_point("https://qa.services.gamestop.com/Ecom/Orders/Tax/v1/TaxService.svc")
        @tax_svc = TaxService.new("http://qa.services.gamestop.com/Ecom/Orders/Tax/v1/TaxService.svc?wsdl", tax_svc_config)
    end

    before(:each) do
        @session_id = generate_guid
        user_name, user_password = nil

        begin
            user_name = account_login_parameter
            user_password = account_password_parameter
        rescue Exception => ex
            account_login_parameter = nil
        end

        @owner_id = @account_svc.perform_authorization_and_return_owner_id(@session_id, user_name, user_password)
        @cart_svc.perform_empty_cart(@session_id, @owner_id)
    end

    it "should add US billing US shipping address and checkout" do
        address_id = generate_guid

        sku_qty_list = [640161,1,640263,1] #,640328,1,640330,1,230791,1]
        @cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list)

        ######################
        ### PURCHASE ORDER ###
        ######################

        ### CREATE_PURCHASE_ORDER_FROM_CART ###

        create_purchase_order_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:create_purchase_order_from_cart)

        create_purchase_order_data = create_purchase_order_req.find_tag("create_purchase_order_from_cart_request").at(0)
        create_purchase_order_data.session_id.content = @session_id
        create_purchase_order_data.owner_id.content = @owner_id

        $tracer.trace(create_purchase_order_req.formatted_xml)

        create_purchase_order_rsp = @purchase_order_svc.create_purchase_order_from_cart(create_purchase_order_req.xml)

        create_purchase_order_rsp.code.should == 200

        $tracer.trace(create_purchase_order_rsp.http_body.formatted_xml)

        shipment_id = create_purchase_order_rsp.http_body.find_tag("shipment_id").at(0).content

        # hold this for later comparisons, etc
        create_purchase_cart_items = create_purchase_order_rsp.http_body.find_tag("line_items").at(0)

        ### ADD_CHANNEL_ATTRIBUTES_TO_PURCHASE_ORDER ###

        add_channel_attributes_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_channel_attributes_to_purchase_order, PurchaseOrderServiceRequestTemplates::ADD_CHANNEL_ATTRIBUTES_TO_PURCHASE_ORDER_WITH_ONLINE_CHANNEL_SPECIFIC_DATA)

        add_channel_attributes_req.find_tag("session_id").at(0).content = @session_id  # oddly found in header
        add_channel_attributes_req.find_tag("owner_id").at(0).content = @owner_id

        channel_attributes_data = add_channel_attributes_req.find_tag("channel_attributes").at(0)
        channel_attributes_data.brand.content = "GS"
        channel_attributes_data.client_ip.content = get_ip
        channel_attributes_data.geo_latitude.remove_self
        channel_attributes_data.geo_longitude.remove_self

        $tracer.trace(add_channel_attributes_req.formatted_xml)

        add_channel_attributes_rsp = @purchase_order_svc.add_channel_attributes_to_purchase_order(add_channel_attributes_req.xml)

        add_channel_attributes_rsp.code.should == 200

        $tracer.trace(add_channel_attributes_rsp.http_body.formatted_xml)

        ### ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS ###

        add_shipping_address_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_shipping_addresses_to_shipments,  PurchaseOrderServiceRequestTemplates::ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS_WITH_ADDRESS )

        add_shipping_address_req.find_tag("session_id").at(0).content = @session_id
        add_shipping_address_req.find_tag("owner_id").at(0).content = @owner_id

        shipments_data = add_shipping_address_req.find_tag("shipments").at(0)

        address_shipment_data = shipments_data.address_shipment
        address_shipment_data.email_address.content = "gstester_dcon@gamestop.com"
        address_shipment_data.phone_number.content = "8177227093"
        address_shipment_data.shipment_id.content = shipment_id

        address_data = address_shipment_data.address
        address_data.address_id.content = address_id
        address_data.city.content = "Grapevine"
        address_data.country_code.content = "US"
        address_data.line1.content = "625 Westport Pkwy"
        address_data.line2.content = nil
        address_data.postal_code.content = "76051"
        address_data.state.content = "TX"
        address_data.first_name.content = "DCon"
        address_data.last_name.content = "Tester"

        $tracer.trace(add_shipping_address_req.formatted_xml)

        add_shipping_address_rsp = @purchase_order_svc.add_shipping_addresses_to_shipments(add_shipping_address_req.xml)

        add_shipping_address_rsp.code.should == 200

        $tracer.trace(add_shipping_address_rsp.http_body.formatted_xml)

        add_shipping_address_rsp.http_body.find_tag("status").at(0).content.should == "Success"

        ### ADD_CUSTOMER_TO_PURCHASE_ORDER ###

        add_customer_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_customer_to_purchase_order)

        add_customer_req.find_tag("session_id").at(0).content = @session_id
        add_customer_req.find_tag("owner_id").at(0).content = @owner_id

        customer_data = add_customer_req.find_tag("customer").at(0)
        customer_data.email_address.content = "gstester_dcon@gamestop.com"
        customer_data.loyalty_card_number.content = nil
        customer_data.loyalty_customer_id.content = nil
        customer_data.phone_number.content = "8177227093"

        bill_to_data = customer_data.bill_to
        bill_to_data.address_id.content = address_id
        bill_to_data.city.content = "Grapevine"
        bill_to_data.country_code.content = "US"
        bill_to_data.line1.content = "625 Westport Pkwy"
        bill_to_data.line2.content = nil
        bill_to_data.postal_code.content = "76051"
        bill_to_data.state.content = "TX"
        bill_to_data.first_name.content = "DCon"
        bill_to_data.last_name.content = "Tester"

        $tracer.trace(add_customer_req.formatted_xml)

        add_customer_rsp = @purchase_order_svc.add_customer_to_purchase_order(add_customer_req.xml)

        add_customer_rsp.code.should == 200

        $tracer.trace(add_customer_rsp.http_body.formatted_xml)

        ################
        ### SHIPPING ###
        ################

        ### GET_AVAILABLE_SHIPPING_METHODS ###

        get_available_shipping_methods_req = @shipping_svc.get_request_from_template_using_global_defaults(:get_available_shipping_methods)

        get_available_shipping_methods_req.find_tag("session_id").at(0).content = @session_id  # oddly found in header

        get_available_shipping_methods_data = get_available_shipping_methods_req.find_tag("get_available_shipping_methods_request").at(0)
        get_available_shipping_methods_data.customer_id.content = @owner_id # BOB ????????
        get_available_shipping_methods_data.customer_loyalty_number.content = nil
        get_available_shipping_methods_data.promocodes.string.remove_self  # since we aren't using a promocode, remove the entry


        shipments_data = get_available_shipping_methods_req.find_tag("shipments").at(0)

        # add items using cart data
        create_purchase_cart_items.line_item.each_with_index do | item, i |

            line_item = shipments_data.shipment.at(0).line_items.line_item.at(i)

            line_item.line_item_id.content = item.line_item_id.content
            line_item.list_price.content = item.list_price.content
            line_item.quantity.content = item.quantity.content
            line_item.sku.content = item.sku.content

            # if needed clone the last line_item in order to add another from the cart
            if create_purchase_cart_items.line_item.length > shipments_data.shipment.at(0).line_items.line_item.length
                shipments_data.shipment.at(0).line_items.line_item.at(i).clone_as_sibling
            end
        end

        ship_to_data = shipments_data.shipment.at(0).ship_to.at(0)
        ship_to_data.address_id.content = address_id
        ship_to_data.city.content = "Grapevine"
        ship_to_data.country_code.content = "US"
        ship_to_data.line1.content = "625 Westport Pkwy"
        ship_to_data.line2.content = nil
        ship_to_data.postal_code.content = "76051"
        ship_to_data.state.content = "TX"

        shipments_data.shipment.at(0).shipment_id.content = shipment_id
        shipments_data.shipment.at(0).shipment_type.content = "ShipToAddress"

        $tracer.trace(get_available_shipping_methods_req.formatted_xml)

        get_available_shipping_methods_rsp = @shipping_svc.get_available_shipping_methods(get_available_shipping_methods_req.xml)

        get_available_shipping_methods_rsp.code.should == 200

        $tracer.trace(get_available_shipping_methods_rsp.http_body.formatted_xml)

        shipping_methods_data = get_available_shipping_methods_rsp.http_body.find_tag("calculated_shipment").at(0).shipping_methods

        # to be used when adding shipping methods to shipment
        shipping_method_name = shipping_methods_data.calculated_shipping_method.at(0).display_name.content
        shipping_method_id = shipping_methods_data.calculated_shipping_method.at(0).shipping_method_id.content
        shipping_method_cost = shipping_methods_data.calculated_shipping_method.at(0).shipping_cost.content

        ######################
        ### PURCHASE ORDER ###
        ######################

        ### ADD_SHIPPING_METHODS_TO_SHIPMENTS ###

        add_shipping_methods_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_shipping_methods_to_shipments)

        add_shipping_methods_req.find_tag("session_id").at(0).content = @session_id
        add_shipping_methods_req.find_tag("owner_id").at(0).content = @owner_id

        shipments_data = add_shipping_methods_req.find_tag("shipments").at(0)

        shipping_method_shipment_data = shipments_data.shipping_method_shipment.at(0)
        shipping_method_shipment_data.gift_message.content = nil
        shipping_method_shipment_data.shipment_id.content = shipment_id
        shipping_method_shipment_data.shipping_cost.content = shipping_method_cost
        shipping_method_shipment_data.shipping_method_id.content = shipping_method_id

        $tracer.trace(add_shipping_methods_req.formatted_xml)

        add_shipping_methods_rsp = @purchase_order_svc.add_shipping_methods_to_shipments(add_shipping_methods_req.xml)

        add_shipping_methods_rsp.code.should == 200

        ### VALIDATE_PURCHASE_ORDER2 ###

        validate_purchase_order_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:validate_purchase_order2)

        validate_purchase_order_req.find_tag("session_id").at(0).content = @session_id  # oddly found in header
        validate_purchase_order_req.find_tag("owner_id").at(0).content = @owner_id

        $tracer.trace(validate_purchase_order_req.formatted_xml)

        validate_purchase_order_rsp = @purchase_order_svc.validate_purchase_order2(validate_purchase_order_req.xml)

        validate_purchase_order_rsp.code.should == 200

        $tracer.trace(validate_purchase_order_rsp.http_body.formatted_xml)

        # search validation and search if age gate is needed.
        messages_data = validate_purchase_order_rsp.http_body.find_tag("messages").at(0)
        messages_data.purchase_order_validation_message.each do |msg|
            if msg.message.exists
                if msg.message.content.include?("verification of mature")

                    ### CONFIRM_AGE_GATE ###
                    confirm_age_gate_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:confirm_age_gate)

                    confirm_age_gate_req.find_tag("session_id").at(0).content = @session_id
                    confirm_age_gate_req.find_tag("owner_id").at(0).content = @owner_id

                    $tracer.trace(confirm_age_gate_req.formatted_xml)

                    confirm_age_gate_rsp = @purchase_order_svc.confirm_age_gate(confirm_age_gate_req.xml)

                    confirm_age_gate_rsp.code.should == 200

                    $tracer.trace(confirm_age_gate_rsp.http_body.formatted_xml)

                    break # no need to confirm age gate more than once
                end
            end
        end

        ###########
        ### TAX ###
        ###########

        ### CALCULATE_TAX ###

        calculate_tax_req = @tax_svc.get_request_from_template_using_global_defaults(:calculate_tax)

        calculate_tax_req.find_tag("session_id").at(0).content = @session_id

        tax_data = calculate_tax_req.find_tag("calculate_tax_request").at(0)
        tax_data.client_country.content = "en-US"
        tax_data.currency.content = "USD"
        tax_data.client_transaction_number.content = Random.rand(100000...999999)

        shipment_data = tax_data.shipments.shipment.at(0)

        bill_to_data = shipment_data.bill_to
        bill_to_data.address_id.content = address_id
        bill_to_data.city.content = "Grapevine"
        bill_to_data.country_code.content = "US"
        bill_to_data.county.content = nil
        bill_to_data.line1.content = "625 Westport Pkwy"
        bill_to_data.line2.content = nil
        bill_to_data.postal_code.content = "76051"
        bill_to_data.state.content = "TX"

        create_purchase_cart_items.line_item.each_with_index do | item, i |

            line_item = shipment_data.line_items.line_item.at(i)

            line_item.description.content = item.product_type.content
            line_item.line_item_id.content = item.line_item_id.content
            line_item.quantity.content = item.quantity.content
            line_item.shipping_cost.content = item.shipping_cost.content
            line_item.shipping_tax.content = item.shipping_tax.content
            line_item.sku.content = item.sku.content
            line_item.tax.content = item.tax.content
            line_item.taxability_code.content = "PHYSICAL_SOFTWARE"   ## where does this come from?
            line_item.unit_price_with_discounts.content = ("%.2f" % (BigDecimal(item.extended_price.content.to_s) / BigDecimal(item.quantity.content.to_s)))

            # if needed clone the last line_item in order to add another from the cart
            if create_purchase_cart_items.line_item.length > shipment_data.line_items.line_item.length
                line_item.clone_as_sibling
            end
        end

        ship_to_data = shipment_data.ship_to
        ship_to_data.address_id.content = address_id
        ship_to_data.city.content = "Grapevine"
        ship_to_data.country_code.content = "US"
        ship_to_data.county.content = nil
        ship_to_data.line1.content = "625 Westport Pkwy"
        ship_to_data.line2.content = nil
        ship_to_data.postal_code.content = "76051"
        ship_to_data.state.content = "TX"

        shipment_data.shipment_id.content = shipment_id
        shipment_data.shipping_cost.content = shipping_method_cost # no tax on shipping? or is it per state?
        shipment_data.shipping_tax.content = 0
        shipment_data.tax.remove_self
        shipment_data.purchase_date.remove_self

        $tracer.trace(calculate_tax_req.formatted_xml)

        calculate_tax_rsp = @tax_svc.calculate_tax(calculate_tax_req.xml)

        calculate_tax_rsp.code.should == 200

        $tracer.trace(calculate_tax_rsp.http_body.formatted_xml)

        calculate_tax_line_items = calculate_tax_rsp.http_body.find_tag("line_items").at(0)


        ######################
        ### PURCHASE ORDER ###
        ######################

        ### ADD_TAX_TO_LINE_ITEMS ###

        add_tax_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_tax_to_line_items)

        add_tax_req.find_tag("session_id").at(0).content = @session_id
        add_tax_req.find_tag("owner_id").at(0).content = @owner_id

        add_tax_data = add_tax_req.find_tag("add_tax_to_line_items_request").at(0)

        calculate_tax_line_items.line_item.each_with_index do | item, i |
            line_item_tax = add_tax_data.line_items.line_item_tax.at(i)

            line_item_tax.line_item_id.content = item.line_item_id.content
            line_item_tax.shipping_tax.content = item.shipping_tax.content
            line_item_tax.tax.content = item.tax.content

            if calculate_tax_line_items.line_item.length > add_tax_data.line_items.line_item_tax.length
                line_item_tax.clone_as_sibling
            end
        end

        $tracer.trace(add_tax_req.formatted_xml)

        add_tax_rsp = @purchase_order_svc.add_tax_to_line_items(add_tax_req.xml)

        add_tax_rsp.code.should == 200

        $tracer.trace(add_tax_rsp.http_body.formatted_xml)

        status_results = add_tax_rsp.http_body.find_tag("status")
        calculate_tax_line_items.line_item.length.should == status_results.length

        status_results.each do | tax_status |
            tax_status.content.should == "Success"
        end

        ### ADD_PAYMENT_TO_PURCHASE_ORDER ###

        add_payment_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_payment_to_purchase_order, PurchaseOrderServiceRequestTemplates::ADD_PAYMENT_TO_PURCHASE_ORDER_WITH_CREDIT_CARD_PAYMENT_METHOD)

        add_payment_req.find_tag("session_id").at(0).content = @session_id
        add_payment_req.find_tag("purchase_order_owner_id").at(0).content = @owner_id

        add_payment_data = add_payment_req.find_tag("payment_methods").at(0)
        payment_method_data = add_payment_data.payment_method.at(0)
        payment_method_data.is_tokenized.content = true
        payment_method_data.payment_account_number.content = "6011186767363105"
        payment_method_data.expiration_month.content = "08"
        payment_method_data.expiration_year.content = "14"
        payment_method_data.type.content = "Discover"

        billing_address_data = payment_method_data.billing_address
        billing_address_data.address_id.content = address_id
        billing_address_data.city.content = "Grapevine"
        billing_address_data.country_code.content = "US"
        billing_address_data.line1.content = "625 Westport Pkwy"
        billing_address_data.line2.content = nil
        billing_address_data.postal_code.content = "76051"
        billing_address_data.state.content = "TX"
        billing_address_data.first_name.content = "DCon"
        billing_address_data.last_name.content = "Tester"

        $tracer.trace(add_payment_req.formatted_xml)

        add_payment_rsp = @purchase_order_svc.add_payment_to_purchase_order(add_payment_req.xml)

        add_payment_rsp.code.should == 200

        $tracer.trace(add_payment_rsp.http_body.formatted_xml)

        add_payment_rsp.http_body.find_tag("status").content.should == "Success"

        ### GET_PURCHASE_ORDER ###

        get_purchase_order_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:get_purchase_order)

        get_purchase_order_req.find_tag("session_id").at(0).content = @session_id
        get_purchase_order_req.find_tag("owner_id").at(0).content = @owner_id

        $tracer.trace(get_purchase_order_req.formatted_xml)

        get_purchase_order_rsp = @purchase_order_svc.get_purchase_order(get_purchase_order_req.xml)

        get_purchase_order_rsp.code.should == 200

        $tracer.trace(get_purchase_order_rsp.http_body.formatted_xml)

        get_purchase_order_rsp.http_body.find_tag("result").content.should == "Success"

        ### VALIDATE_PURCHASE_ORDER2 ###

        validate_purchase_order_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:validate_purchase_order2)

        validate_purchase_order_req.find_tag("session_id").at(0).content = @session_id  # oddly found in header
        validate_purchase_order_req.find_tag("owner_id").at(0).content = @owner_id

        $tracer.trace(validate_purchase_order_req.formatted_xml)

        validate_purchase_order_rsp = @purchase_order_svc.validate_purchase_order2(validate_purchase_order_req.xml)

        validate_purchase_order_rsp.code.should == 200

        $tracer.trace(validate_purchase_order_rsp.http_body.formatted_xml)

        ##################
        ### ICHECKOUT ####
        ##################

        ### PURCHASE ###

        purchase_req = @icheckout_svc.get_request_from_template_using_global_defaults(:purchase)

        purchase_req.find_tag("session_id").at(0).content = @session_id
        purchase_req.find_tag("purchase_order_owner_id").at(0).content = @owner_id

        $tracer.trace(purchase_req.formatted_xml)

        purchase_rsp = @icheckout_svc.purchase(purchase_req.xml)

        purchase_rsp.code.should == 200

        $tracer.trace(purchase_rsp.http_body.formatted_xml)

        purchase_rsp.http_body.find_tag("purchase_successful").content.should == "true"

        purchase_rsp.http_body.find_tag("total").content.should == "103.8800"

    end

end



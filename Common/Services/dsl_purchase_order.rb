require 'URI'

module GameStopPurchaseOrderServiceDSL

  def perform_create_purchase_order_from_cart(session_id, owner_id, client_channel, locale, version)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    create_purchase_order_req = self.get_request_from_template_using_global_defaults(:create_purchase_order_from_cart, PurchaseOrderServiceRequestTemplates.const_get("CREATE_PURCHASE_ORDER_FROM_CART#{version}"))
    create_purchase_order_req.find_tag("client_channel").content = client_channel
    create_purchase_order_req.find_tag("locale").content = locale
    create_purchase_order_data = create_purchase_order_req.find_tag("create_purchase_order_from_cart_request").at(0)
    create_purchase_order_data.session_id.content = session_id
    create_purchase_order_data.owner_id.content = owner_id
    create_purchase_order_req.find_tag("targeting_context").items.name_value_property.remove_self
    $tracer.trace(create_purchase_order_req.formatted_xml)
    create_purchase_order_rsp = self.create_purchase_order_from_cart(create_purchase_order_req.xml)
    create_purchase_order_rsp.code.should == 200
    $tracer.trace(create_purchase_order_rsp.http_body.formatted_xml)
    return create_purchase_order_rsp
  end

  def perform_add_channel_attributes_to_purchase_order(session_id, owner_id, client_channel, locale, brand, get_ip, version)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    add_channel_attributes_req = self.get_request_from_template_using_global_defaults(:add_channel_attributes_to_purchase_order, PurchaseOrderServiceRequestTemplates.const_get("ADD_CHANNEL_ATTRIBUTES_TO_PURCHASE_ORDER_WITH_ONLINE_CHANNEL_SPECIFIC_DATA#{version}"))
    add_channel_attributes_req.find_tag("session_id").at(0).content = session_id # oddly found in header
    add_channel_attributes_req.find_tag("owner_id").at(0).content = owner_id
    add_channel_attributes_req.find_tag("client_channel").content = client_channel
    add_channel_attributes_req.find_tag("locale").content = locale
    channel_attributes_data = add_channel_attributes_req.find_tag("channel_attributes").at(0)
    channel_attributes_data.brand.content = brand
    channel_attributes_data.client_ip.content = get_ip
    channel_attributes_data.geo_latitude.remove_self
    channel_attributes_data.geo_longitude.remove_self
    $tracer.trace(add_channel_attributes_req.formatted_xml)
    add_channel_attributes_rsp = self.add_channel_attributes_to_purchase_order(add_channel_attributes_req.xml)
    add_channel_attributes_rsp.code.should == 200
    $tracer.trace(add_channel_attributes_rsp.http_body.formatted_xml)
  end

  def perform_add_email_addresses_to_shipments(session_id, owner_id, client_channel, locale, version, params, purchase_order_shipment_groups)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    add_shipping_email_address_req = self.get_request_from_template_using_global_defaults(:add_email_addresses_to_shipments, PurchaseOrderServiceRequestTemplates.const_get("ADD_EMAIL_ADDRESSES_TO_SHIPMENTS#{version}"))
    add_shipping_email_address_req.find_tag("session_id").content = session_id
    add_shipping_email_address_req.find_tag("owner_id").content = owner_id
    add_shipping_email_address_req.find_tag("client_channel").content = client_channel
    add_shipping_email_address_req.find_tag("locale").content = locale

    purchase_order_shipment_groups.each_with_index do |po_shipment, p|
      shipment_id = po_shipment.shipment_id.content
      add_shipping_email_address_req.find_tag("email_address_shipment").at(0).clone_as_sibling if p > 0
      email_address_data = add_shipping_email_address_req.find_tag("email_address_shipment").at(p)
      email_address_data.email_address.content = params["ShipEmail"]
      email_address_data.shipment_id.content = shipment_id
    end

    $tracer.trace(add_shipping_email_address_req.formatted_xml)
    add_email_address_rsp = self.add_email_addresses_to_shipments(add_shipping_email_address_req.xml)
    add_email_address_rsp.code.should == 200
  end

  def perform_add_shipping_addresses_to_shipments(session_id, owner_id, client_channel, locale, version, params, purchase_order_shipment_groups)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    add_shipping_address_req = self.get_request_from_template_using_global_defaults(:add_shipping_addresses_to_shipments, PurchaseOrderServiceRequestTemplates.const_get("ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS_WITH_ADDRESS#{version}"))
    add_shipping_address_req.find_tag("session_id").at(0).content = session_id
    add_shipping_address_req.find_tag("owner_id").at(0).content = owner_id
    add_shipping_address_req.find_tag("client_channel").content = client_channel
    add_shipping_address_req.find_tag("locale").content = locale

    purchase_order_shipment_groups.each_with_index do |shipment_id, i|
      add_shipping_address_req.find_tag("shipments").at(0).address_shipment.at(0).clone_as_sibling if i > 0
      address_shipment_data = add_shipping_address_req.find_tag("address_shipment").at(i)
      address_shipment_data.email_address.content = params["ShipEmail"]
      address_shipment_data.phone_number.content = params["ShipPhone"]
      address_shipment_data.shipment_id.content = shipment_id.content
      address_data = address_shipment_data.address
      address_data.address_id.content = generate_guid
      address_data.city.content = params["ShipCity"]
      address_data.country_code.content = params["ShipCountryCode"]
      address_data.line1.content = params["ShipLine1"]
      address_data.line2.content = params["ShipLine2"]
      address_data.postal_code.content = params["ShipPostalCode"]
      address_data.state.content = params["ShipState"]
      address_data.first_name.content = params["ShipFirstName"]
      address_data.last_name.content = params["ShipLastName"]
    end

    $tracer.trace(add_shipping_address_req.formatted_xml)
    add_shipping_address_rsp = self.add_shipping_addresses_to_shipments(add_shipping_address_req.xml)
    add_shipping_address_rsp.code.should == 200
    $tracer.trace(add_shipping_address_rsp.http_body.formatted_xml)
    add_shipping_address_rsp.http_body.find_tag("status").at(0).content.should == "Success"
  end

  def perform_add_shipping_addresses_to_shipments_with_user(session_id, owner_id, client_channel, locale, version, params, purchase_order_shipment_groups, user_name)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    @user_name = user_name
    add_shipping_address_req = self.get_request_from_template_using_global_defaults(:add_shipping_addresses_to_shipments, PurchaseOrderServiceRequestTemplates.const_get("ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS_WITH_ADDRESS#{version}"))
    add_shipping_address_req.find_tag("session_id").at(0).content = session_id
    add_shipping_address_req.find_tag("owner_id").at(0).content = owner_id
    add_shipping_address_req.find_tag("client_channel").content = client_channel
    add_shipping_address_req.find_tag("locale").content = locale

    purchase_order_shipment_groups.each_with_index do |shipment_id, i|
      add_shipping_address_req.find_tag("shipments").at(0).address_shipment.at(0).clone_as_sibling if i > 0
      address_shipment_data = add_shipping_address_req.find_tag("address_shipment").at(i)
      address_shipment_data.email_address.content = @user_name
      address_shipment_data.phone_number.content = params["ShipPhone"]
      address_shipment_data.shipment_id.content = shipment_id.content
      address_data = address_shipment_data.address
      address_data.address_id.content = generate_guid
      address_data.city.content = params["ShipCity"]
      address_data.country_code.content = params["ShipCountryCode"]
      address_data.line1.content = params["ShipLine1"]
      address_data.line2.content = params["ShipLine2"]
      address_data.postal_code.content = params["ShipPostalCode"]
      address_data.state.content = params["ShipState"]
      address_data.first_name.content = params["ShipFirstName"]
      address_data.last_name.content = params["ShipLastName"]
    end

    $tracer.trace(add_shipping_address_req.formatted_xml)
    add_shipping_address_rsp = self.add_shipping_addresses_to_shipments(add_shipping_address_req.xml)
    add_shipping_address_rsp.code.should == 200
    $tracer.trace(add_shipping_address_rsp.http_body.formatted_xml)
    add_shipping_address_rsp.http_body.find_tag("status").at(0).content.should == "Success"
  end


  def perform_add_store_addresses_to_shipments(session_id, owner_id, client_channel, locale, version, params, store_address, purchase_order_shipment_groups)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    add_shipping_address_req = self.get_request_from_template_using_global_defaults(:add_shipping_addresses_to_shipments, PurchaseOrderServiceRequestTemplates.const_get("ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS_WITH_STOREADDRESS#{version}"))
    add_shipping_address_req.find_tag("session_id").at(0).content = session_id
    add_shipping_address_req.find_tag("owner_id").at(0).content = owner_id
    add_shipping_address_req.find_tag("client_channel").content = client_channel
    add_shipping_address_req.find_tag("locale").content = locale

    purchase_order_shipment_groups.each_with_index do |shipment_id, i|
      add_shipping_address_req.find_tag("shipments").at(0).address_shipment.at(0).clone_as_sibling if i > 0
      address_shipment_data = add_shipping_address_req.find_tag("address_shipment").at(i)
      address_shipment_data.email_address.content = params["ShipEmail"]
      address_shipment_data.phone_number.content = params["ShipPhone"]
      address_shipment_data.shipment_id.content = shipment_id.content
      $tracer.trace(store_address)
      address_data = address_shipment_data.address
      address_data.address_id.content = generate_guid
      address_data.city.content = store_address["store_city"]
      address_data.country_code.content = store_address["store_country_code"]
      address_data.line1.content = store_address["store_line1"]
      address_data.line2.content = nil
      address_data.postal_code.content = store_address["store_zip"]
      address_data.state.content = store_address["store_state"]
      address_data.mall_name.content = store_address["store_mall_name"]
      address_data.store_number.content = store_address["store_number"]
      address_data.store_phone_number.content = store_address["store_phone_number"]
    end

    $tracer.trace(add_shipping_address_req.formatted_xml)
    add_shipping_address_rsp = self.add_shipping_addresses_to_shipments(add_shipping_address_req.xml)
    add_shipping_address_rsp.code.should == 200
    $tracer.trace(add_shipping_address_rsp.http_body.formatted_xml)
    add_shipping_address_rsp.http_body.find_tag("status").at(0).content.should == "Success"
  end

  def perform_add_shipping_methods_to_shipments(session_id, owner_id, client_channel, locale, shipment_id, calculated_shipping_method, version)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    add_shipping_methods_req = self.get_request_from_template_using_global_defaults(:add_shipping_methods_to_shipments, PurchaseOrderServiceRequestTemplates.const_get("ADD_SHIPPING_METHODS_TO_SHIPMENTS#{version}"))

    add_shipping_methods_req.find_tag("session_id").at(0).content = session_id
    add_shipping_methods_req.find_tag("owner_id").at(0).content = owner_id
    add_shipping_methods_req.find_tag("client_channel").at(0).content = client_channel
    add_shipping_methods_req.find_tag("locale").at(0).content = locale

    shipments_data = add_shipping_methods_req.find_tag("shipments").at(0)

    shipping_method_shipment_data = shipments_data.shipping_method_shipment.at(0)
    shipping_method_shipment_data.gift_message.content = nil
    shipping_method_shipment_data.shipment_id.content = shipment_id
    shipping_method_shipment_data.shipping_cost.content = calculated_shipping_method.shipping_cost.content
    shipping_method_shipment_data.shipping_method_id.content = calculated_shipping_method.shipping_method_id.content

    $tracer.trace(add_shipping_methods_req.formatted_xml)

    add_shipping_methods_rsp = self.add_shipping_methods_to_shipments(add_shipping_methods_req.xml)

    add_shipping_methods_rsp.code.should == 200
    $tracer.trace(add_shipping_methods_rsp.http_body.formatted_xml)
  end

  def perform_add_new_customer_to_purchase_order(session_id, owner_id, client_channel, locale, version, params, user)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    add_customer_req = self.get_request_from_template_using_global_defaults(:add_customer_to_purchase_order, PurchaseOrderServiceRequestTemplates.const_get("ADD_CUSTOMER_TO_PURCHASE_ORDER#{version}"))
    add_customer_req.find_tag("session_id").at(0).content = session_id
    add_customer_req.find_tag("owner_id").at(0).content = owner_id
    add_customer_req.find_tag("client_channel").content = client_channel
    add_customer_req.find_tag("locale").content = locale
    customer_data = add_customer_req.find_tag("customer").at(0)

    #Removing references to the billemail from the CSV.  Need this to be the email that is used in the script, unless nil.  DLC guest scripts will still need this set.
    customer_data.email_address.content = user

    #Need this to read the CSV, if empty it should be nil.  Right now we can't do anything with these options.
    customer_data.loyalty_card_number.content = nil
    customer_data.loyalty_customer_id.content = nil
    customer_data.phone_number.content = params["BillPhone"]

    bill_to_data = customer_data.bill_to
    bill_to_data.address_id.content = generate_guid
    bill_to_data.city.content = params["BillCity"]
    bill_to_data.country_code.content = params["BillCountryCode"]
    bill_to_data.line1.content = params["BillLine1"]
    bill_to_data.line2.content = params["BillLine2"]
    bill_to_data.postal_code.content = params["BillPostalCode"]
    bill_to_data.state.content = params["BillState"]
    bill_to_data.first_name.content = params["BillFirstName"]
    bill_to_data.last_name.content = params["BillLastName"]

    $tracer.trace(add_customer_req.formatted_xml)
    add_customer_rsp = self.add_customer_to_purchase_order(add_customer_req.xml)
    add_customer_rsp.code.should == 200
    $tracer.trace(add_customer_rsp.http_body.formatted_xml)
  end

  def perform_add_customer_to_purchase_order(session_id, owner_id, client_channel, locale, version, openid, is_guest, params)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    add_customer_req = self.get_request_from_template_using_global_defaults(:add_customer_to_purchase_order, PurchaseOrderServiceRequestTemplates.const_get("ADD_CUSTOMER_TO_PURCHASE_ORDER#{version}"))
    add_customer_req.find_tag("session_id").at(0).content = session_id
    add_customer_req.find_tag("owner_id").at(0).content = owner_id
    add_customer_req.find_tag("client_channel").content = client_channel
    add_customer_req.find_tag("locale").content = locale
    customer_data = add_customer_req.find_tag("customer").at(0)

    #Removing references to the billemail from the CSV.  Need this to be the email that is used in the script, unless nil.  DLC guest scripts will still need this set.

    customer_data.email_address.content = params["BillEmail"]

    #Need this to read the CSV, if empty it should be nil.  Right now we can't do anything with these options.
    customer_data.loyalty_card_number.content = nil
    customer_data.loyalty_customer_id.content = nil
    customer_data.is_guest_checkout.content = is_guest
    customer_data.loyalty_tier.content = "Unspecified"
    customer_data.phone_number.content = params["BillPhone"]
    customer_data.open_id_claimed_identifier.content = openid

    bill_to_data = customer_data.bill_to
    bill_to_data.address_id.content = generate_guid
    bill_to_data.format_validated.content = true
    bill_to_data.city.content = params["BillCity"]
    bill_to_data.country_code.content = params["BillCountryCode"]
    bill_to_data.line1.content = params["BillLine1"]
    bill_to_data.line2.content = params["BillLine2"]
    bill_to_data.postal_code.content = params["BillPostalCode"]
    bill_to_data.state.content = params["BillState"]
    bill_to_data.first_name.content = params["BillFirstName"]
    bill_to_data.last_name.content = params["BillLastName"]

    $tracer.trace(add_customer_req.formatted_xml)
    add_customer_rsp = self.add_customer_to_purchase_order(add_customer_req.xml)
    add_customer_rsp.code.should == 200
    $tracer.trace(add_customer_rsp.http_body.formatted_xml)
  end

  def perform_confirm_age_gate(session_id, owner_id, client_channel, locale, version)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # use template to generate a request dot object for the cart service confirm_age_gate operation
    confirm_age_gate_req = self.get_request_from_template_using_global_defaults(:confirm_age_gate, PurchaseOrderServiceRequestTemplates.const_get("CONFIRM_AGE_GATE#{version}"))
    confirm_age_gate_data = confirm_age_gate_req.find_tag("confirm_age_gate_request").at(0)
    confirm_age_gate_data.owner_id.content = owner_id
    confirm_age_gate_data.session_id.content = session_id
    confirm_age_gate_data.client_channel.content = client_channel
    confirm_age_gate_data.locale.content = locale
    $tracer.trace(confirm_age_gate_req.formatted_xml)
    confirm_age_gate_rsp = self.confirm_age_gate(confirm_age_gate_req.xml)
    confirm_age_gate_rsp.code.should == 200
    $tracer.trace(confirm_age_gate_rsp.http_body.formatted_xml)
  end

  def perform_get_purchase_order_by_tracking_number(session_id, client_channel, locale, order_num, version)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_purchase_order_by_tracking_number_req = self.get_request_from_template_using_global_defaults("get_purchase_order_by_tracking_number", PurchaseOrderServiceRequestTemplates.const_get("GET_PURCHASE_ORDER_BY_TRACKING_NUMBER#{version}"))
    get_purchase_order_by_tracking_number_req.find_tag("targeting_context").items.name_value_property.remove_self
    get_purchase_order_by_tracking_number_req.find_tag("session_id").at(0).content = session_id
    get_purchase_order_by_tracking_number_req.find_tag("client_channel").at(0).content = client_channel
    get_purchase_order_by_tracking_number_req.find_tag("locale").at(0).content = locale
    get_purchase_order_by_tracking_number_req.find_tag("order_tracking_number").at(0).content = order_num
    puts get_purchase_order_by_tracking_number_req.formatted_xml
    get_purchase_order_by_tracking_number_rsp = self.get_purchase_order_by_tracking_number(get_purchase_order_by_tracking_number_req.xml)

    $tracer.trace(get_purchase_order_by_tracking_number_rsp.http_body.formatted_xml)
    get_purchase_order_by_tracking_number_rsp.code.should == 200
    get_purchase_order_by_tracking_number_rsp.http_body.find_tag("order_tracking_number").content.should == order_num
    get_purchase_order_by_tracking_number_rsp
  end

  def perform_get_placed_order(session_id, client_channel, locale, order_num, version)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_placed_order_req = self.get_request_from_template_using_global_defaults("get_placed_order", PurchaseOrderServiceRequestTemplates.const_get("GET_PLACED_ORDER#{version}"))
    get_placed_order_req.find_tag("targeting_context").items.name_value_property.remove_self
    get_placed_order_req.find_tag("session_id").at(0).content = session_id
    get_placed_order_req.find_tag("client_channel").at(0).content = client_channel
    get_placed_order_req.find_tag("locale").at(0).content = locale
    get_placed_order_req.find_tag("order_tracking_number").at(0).content = order_num
    $tracer.trace(get_placed_order_req.formatted_xml)
    get_placed_order_rsp = self.get_placed_order(get_placed_order_req.xml)
    $tracer.trace(get_placed_order_rsp.http_body.formatted_xml)
    get_placed_order_rsp.code.should == 200
    get_placed_order_rsp.http_body.find_tag("order_tracking_number").content.should == order_num
    get_placed_order_rsp
  end

  def perform_validate_purchase_order2(session_id, owner_id, client_channel, locale, version)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    validate_purchase_order_req = self.get_request_from_template_using_global_defaults(:validate_purchase_order2, PurchaseOrderServiceRequestTemplates.const_get("VALIDATE_PURCHASE_ORDER2#{version}"))

    validate_purchase_order_req.find_tag("session_id").at(0).content = session_id # oddly found in header
    validate_purchase_order_req.find_tag("owner_id").at(0).content = owner_id
    validate_purchase_order_req.find_tag("targeting_context").items.name_value_property.remove_self
    validate_purchase_order_req.find_tag("client_channel").content = client_channel
    validate_purchase_order_req.find_tag("locale").content = locale

    $tracer.trace(validate_purchase_order_req.formatted_xml)
    validate_purchase_order_rsp = self.validate_purchase_order2(validate_purchase_order_req.xml)
    validate_purchase_order_rsp.code.should == 200
    $tracer.trace(validate_purchase_order_rsp.http_body.formatted_xml)

    return validate_purchase_order_rsp
  end

  def perform_get_purchase_order(session_id, owner_id, client_channel, locale, version)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_purchase_order_req = self.get_request_from_template_using_global_defaults(:get_purchase_order, PurchaseOrderServiceRequestTemplates.const_get("GET_PURCHASE_ORDER#{version}"))
    get_purchase_order_req.find_tag("targeting_context").items.name_value_property.remove_self
    get_purchase_order_req.find_tag("session_id").at(0).content = session_id
    get_purchase_order_req.find_tag("owner_id").at(0).content = owner_id
    get_purchase_order_req.find_tag("client_channel").content = client_channel
    get_purchase_order_req.find_tag("locale").content = locale

    $tracer.trace(get_purchase_order_req.formatted_xml)
    get_purchase_order_rsp = self.get_purchase_order(get_purchase_order_req.xml)
    get_purchase_order_rsp.code.should == 200
    $tracer.trace(get_purchase_order_rsp.http_body.formatted_xml)

    return get_purchase_order_rsp
  end

  def perform_purchase_with_credit_card(session_id, owner_id, client_channel, locale, params, version, login, common_functions, total)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    token = create_token(params, cc = nil, login, total)
    purchase_req = self.get_request_from_template_using_global_defaults(:purchase, PurchaseOrderServiceRequestTemplates.const_get("PURCHASE_WITH_CREDIT_CARD#{version}"))
    purchase_req.find_tag("session_id").at(0).content = session_id
    purchase_req.find_tag("purchase_order_owner_id").at(0).content = owner_id
    purchase_req.find_tag("client_channel").at(0).content = client_channel
    purchase_req.find_tag("locale").at(0).content = locale
    # HACK : Trying to pass an existing fingerprint
    purchase_req.find_tag("device_fingerprint").remove_self
    purchase_req.find_tag("shipping_address_has_changed").content = false
    purchase_req.find_tag("electronic_account").remove_self
    purchase_req.find_tag("stored_value_payment_methods").remove_self
    purchase_req.find_tag("targeting_context").items.name_value_property.remove_self
    #purchase_req.find_tag("targeting_context").items.name_value_property.name.content = "Locale"
    #purchase_req.find_tag("targeting_context").items.name_value_property.value.content = "en-US"

    purchase_data = purchase_req.find_tag("purchase_request").at(0)
    billaddr = purchase_data.credit_card.billing_address
      billaddr.first_name.content = params['BillFirstName']
      billaddr.last_name.content = params['BillLastName']
      billaddr.address_id.content = generate_guid
      billaddr.city.content = params['BillCity']
      billaddr.country_code.content = params['BillCountryCode']
      billaddr.format_validated.content = true
      billaddr.line1.content = params['BillLine1']
      billaddr.line2.content = params['BillLine2']
      billaddr.postal_code.content = params['BillPostalCode']
      billaddr.state.content = params['BillState']
    purchase_data.credit_card.is_tokenized.content = true
    purchase_data.credit_card.is_wallet_payment_method.content = false
    purchase_data.credit_card.payment_account_number.content = token #params["CreditCard"]
    purchase_data.credit_card.expiration_month.content = params["ExpMonth"]
    purchase_data.credit_card.expiration_year.content = params["ExpYear"]
    purchase_data.credit_card.at(0).type.content = params["CCType"]
    purchase_data.credit_card.csc.content = params["CVV"]

    $tracer.trace(purchase_req.formatted_xml)
    purchase_rsp = self.purchase(purchase_req.xml)
    purchase_rsp.code.should == 200
    $tracer.trace(purchase_rsp.http_body.formatted_xml)

    return purchase_rsp
  end

  #Added random month, year, cctype and cc generation if the dataset passes "generate" as the cctype.  otherwise it generates the specific cctype as defined in the dataset.
  def perform_purchase_with_generated_credit_card(session_id, owner_id, client_channel, locale, params, version, login, common_functions, total, cc, cc_enum, token)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    ctype = cc[:ctype].to_s
    $tracer.report("Paid with Generated Credit Card: #{cc.inspect}")
    card_type = ctype.slice(0, 1).capitalize + ctype.slice(1..-1)


    purchase_req = self.get_request_from_template_using_global_defaults(:purchase, PurchaseOrderServiceRequestTemplates.const_get("PURCHASE_WITH_CREDIT_CARD#{version}"))
    purchase_req.find_tag("session_id").at(0).content = session_id
    purchase_req.find_tag("purchase_order_owner_id").at(0).content = owner_id
    purchase_req.find_tag("client_channel").at(0).content = client_channel
    purchase_req.find_tag("locale").at(0).content = locale

    purchase_req.find_tag("device_fingerprint").remove_self
    purchase_req.find_tag("shipping_address_has_changed").content = false
    purchase_req.find_tag("electronic_account").remove_self
    purchase_req.find_tag("stored_value_payment_methods").remove_self
    purchase_req.find_tag("targeting_context").items.name_value_property.remove_self
    #purchase_req.find_tag("targeting_context").items.name_value_property.name.content = "Locale"
    #purchase_req.find_tag("targeting_context").items.name_value_property.value.content = "en-US"

    purchase_data = purchase_req.find_tag("purchase_request").at(0)
    credit_card = purchase_data.credit_card.at(0)
    credit_card.billing_address.first_name.content = params['BillFirstName']
    credit_card.billing_address.last_name.content = params['BillLastName']
    credit_card.billing_address.address_id.content = generate_guid
    credit_card.billing_address.city.content = params['BillCity']
    credit_card.billing_address.country_code.content = params['BillCountryCode']
    credit_card.billing_address.format_validated.content = true
    credit_card.billing_address.line1.content = params['BillLine1']
    credit_card.billing_address.line2.content = params['BillLine2']
    credit_card.billing_address.postal_code.content = params['BillPostalCode']
    credit_card.billing_address.state.content = params['BillState']
    purchase_data.credit_card.is_tokenized.content = true
    purchase_data.credit_card.is_wallet_payment_method.content = false

    #purchase_data.credit_card.payment_account_number.content = cc[:cnum]
    purchase_data.credit_card.payment_account_number.content = token
    purchase_data.credit_card.expiration_month.content = cc[:expmnth]
    purchase_data.credit_card.expiration_year.content = cc[:expyr]
    purchase_data.credit_card.at(0).type.content = card_type #cc[:ctype]
    purchase_data.credit_card.csc.content = cc[:cvv]

    $tracer.trace(purchase_req.formatted_xml)
    purchase_rsp = self.purchase(purchase_req.xml)
    purchase_rsp.code.should == 200
    $tracer.trace(purchase_rsp.http_body.formatted_xml)

    dump_to_csv = "false"
    #dump to csv? -------------------------TODO ---------------------------- PUT THIS INTO THE DATASET CSV
    if dump_to_csv == "true"
      header = []
      test_info = []
      header << "username, password, cc_number, cc_exp_month, cc_exp_year, cctype, cvv"
      test_info << "'#{username}','#{password}','#{cc[:cnum]}','#{cc[:expmnth]}','#{cc[:expyr]}','#{cc[:ctype]}','#{cc[:cvv]}'"
      path = "#{ENV['QAAUTOMATION_SCRIPTS']}/users_cards/"
      Dir.mkdir(path) unless File.exists?(path)

      test_info.each do |i|
        csv_builder(test_info)
        CSV.open("#{path}\\users_and_cards.csv", "a") do |csv|
          csv << @data
        end
      end
    end

    return purchase_rsp
  end

  def csv_builder(tst_info)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    test_info = tst_info.join(",")
    csv_data = "#{test_info}"

    # The parser just converts these into an array of CSV cells
    array_of_csv_cells = CSV.parse csv_data

    # The first CVS params are the headings
    @data = array_of_csv_cells.shift.map { |rd| rd.to_s }

    # Convert the array of CSV cells into an Array of Hashes
    products_in_structures = array_of_csv_cells.map do |cells|
      hsh = {}
      (cells.map { |cell| cell.to_s }).each_with_index do |cell_str, index|
        hsh[index] = cell_str
      end
      hsh
    end
    return @data
  end


  def perform_purchase_with_svs_card(session_id, owner_id, client_channel, locale, params, version)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    purchase_req = self.get_request_from_template_using_global_defaults(:purchase, PurchaseOrderServiceRequestTemplates.const_get("PURCHASE_WITH_SVS_CARD#{version}"))
    purchase_req.find_tag("session_id").content = session_id
    purchase_req.find_tag("purchase_order_owner_id").content = owner_id
    purchase_req.find_tag("client_channel").content = client_channel
    purchase_req.find_tag("locale").content = locale
    purchase_req.find_tag("targeting_context").items.name_value_property.remove_self

    purchase_data = purchase_req.find_tag("purchase_request").at(0)
    purchase_data.stored_value_payment_methods.stored_value_payment_method.is_tokenized.content = "false"
    purchase_data.stored_value_payment_methods.stored_value_payment_method.is_wallet_payment_method.content = "false"
    purchase_data.stored_value_payment_methods.stored_value_payment_method.payment_account_number.content = params["SVS"]
    purchase_data.stored_value_payment_methods.stored_value_payment_method.pin.content = params["PIN"]

    $tracer.trace(purchase_req.formatted_xml)
    purchase_rsp = self.purchase(purchase_req.xml)
    purchase_rsp.code.should == 200
    $tracer.trace(purchase_rsp.http_body.formatted_xml)

    return purchase_rsp
  end


  def perform_get_svs_balance(card_number, pin, session_id, version)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_balance_req = self.get_request_from_template_using_global_defaults(:get_stored_value_balances, PurchaseOrderServiceRequestTemplates.const_get("GET_STORED_VALUE_BALANCE#{version}"))
    get_balance_req.find_tag("session_id").content = session_id
    payment_method = get_balance_req.find_tag("stored_value_payment_method")
    payment_method.pin.content = pin
    payment_method.payment_account_number.content = card_number
    payment_method.is_tokenized.content = "false"
    payment_method.is_wallet_payment_method.content = "false"
    $tracer.trace(get_balance_req.formatted_xml)

    rsp = self.get_stored_value_balances(get_balance_req.xml)

    rsp.code.should == 200

    $tracer.trace(rsp.http_body.formatted_xml)
    return BigDecimal.new(rsp.http_body.find_tag("balance").content)
  end

  def verify_operations(purchase_order_svc)
    $tracer.trace("GameStopPurchaseOrderServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace(purchase_order_svc)
    purchase_order_svc.include?(:add_channel_attributes_to_purchase_order) == true
    purchase_order_svc.include?(:add_customer_to_purchase_order) == true
    purchase_order_svc.include?(:add_promotions_to_purchase_order) == true
    purchase_order_svc.include?(:remove_promotions_from_purchase_order) == true
    purchase_order_svc.include?(:add_email_addresses_to_shipments) == true
    purchase_order_svc.include?(:add_shipping_addresses_to_shipments) == true
    purchase_order_svc.include?(:add_shipping_methods_to_shipments) == true
    purchase_order_svc.include?(:update_stored_value_payments) == true
    purchase_order_svc.include?(:add_tax_to_line_items) == true
    purchase_order_svc.include?(:add_physical_fraud_evaluation) == true
    purchase_order_svc.include?(:add_digital_fraud_evaluation) == true
    purchase_order_svc.include?(:get_purchase_order) == true
    purchase_order_svc.include?(:get_tracking_details_by_tracking_number) == true
    purchase_order_svc.include?(:create_purchase_order_from_cart) == true
    purchase_order_svc.include?(:validate_purchase_order) == true
    purchase_order_svc.include?(:validate_purchase_order2) == true
    purchase_order_svc.include?(:confirm_age_gate) == true
    purchase_order_svc.include?(:purchase) == true
    purchase_order_svc.include?(:get_placed_order) == true
    purchase_order_svc.include?(:get_stored_value_balances) == true
    purchase_order_svc.include?(:cancel_and_refund_order) == true
    return true
  end
end



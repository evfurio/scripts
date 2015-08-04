# == Overview
# This module is specific to soap services and contains qa d-con script writer dsl's.
# It is mixed into ShippingService, as a monkey patch, in the dsl.rb file.

module GameStopShippingServiceDSL

  def perform_get_available_shipping_methods(session_id, owner_id, client_channel, locale, version, params, purchase_order_shipment_groups)
    $tracer.trace("GameStopShippingServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_available_shipping_methods_req = self.get_request_from_template_using_global_defaults(:get_available_shipping_methods, ShippingServiceRequestTemplates.const_get("GET_AVAILABLE_SHIPPING_METHODS#{version}"))

    get_available_shipping_methods_req.find_tag("session_id").at(0).content = session_id # oddly found in header
    get_available_shipping_methods_req.find_tag("targeting_context").items.name_value_property.remove_self
    get_available_shipping_methods_req.find_tag("client_channel").content = client_channel
    get_available_shipping_methods_req.find_tag("locale").content = locale
    promo_code = params["PromoCode"]

    get_available_shipping_methods_data = get_available_shipping_methods_req.find_tag("get_available_shipping_methods_request").at(0)
    get_available_shipping_methods_data.customer_id.content = owner_id
    get_available_shipping_methods_data.customer_loyalty_number.content = nil

    if !promo_code.empty?
      get_available_shipping_methods_data.promocodes.at(0).string.content = promo_code
    else
      get_available_shipping_methods_data.promocodes.remove_self # since we aren't using a promocode, remove the entry
    end

    purchase_order_shipment_groups.each_with_index do |po_shipment, i|

      get_available_shipping_methods_req.find_tag("shipment").at(0).clone_as_sibling if i > 0

      shipment_id = po_shipment.shipment_id.content
      shipments_data = get_available_shipping_methods_req.find_tag("shipment").at(i)

      po_shipment.line_items.line_item.each_with_index do |item, a|

        shipments_data.line_items.line_item.at(0).clone_as_sibling if a > 0

        line_item = shipments_data.line_items.line_item.at(a)
        line_item.line_item_id.content = item.line_item_id.content
        line_item.list_price.content = item.list_price.content
        line_item.quantity.content = item.quantity.content
        line_item.sku.content = item.sku.content
      end

      ship_to_data = shipments_data.ship_to.at(0)
      ship_to_data.address_id.content = generate_guid
      ship_to_data.city.content = params["ShipCity"]
      ship_to_data.country_code.content = params["ShipCountryCode"]
      ship_to_data.line1.content = params["ShipLine1"]
      ship_to_data.line2.content = nil
      ship_to_data.postal_code.content = params["ShipPostalCode"]
      ship_to_data.state.content = params["ShipState"]

      shipments_data.shipment_id.content = shipment_id
      shipments_data.shipment_type.content = params["ShipmentType"]
    end

    $tracer.trace(get_available_shipping_methods_req.formatted_xml)

    get_available_shipping_methods_rsp = self.get_available_shipping_methods(get_available_shipping_methods_req.xml)

    get_available_shipping_methods_rsp.code.should == 200

    $tracer.trace(get_available_shipping_methods_rsp.http_body.formatted_xml)
    return get_available_shipping_methods_rsp
  end

  def perform_get_available_shipping_methods_ispu(session_id, owner_id, client_channel, locale, version, params, store_address, purchase_order_shipment_groups)
    $tracer.trace("GameStopShippingServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_available_shipping_methods_req = self.get_request_from_template_using_global_defaults(:get_available_shipping_methods, ShippingServiceRequestTemplates.const_get("GET_AVAILABLE_SHIPPING_METHODS#{version}"))

    get_available_shipping_methods_req.find_tag("session_id").at(0).content = session_id # oddly found in header
    get_available_shipping_methods_req.find_tag("targeting_context").items.name_value_property.remove_self
    get_available_shipping_methods_req.find_tag("client_channel").content = client_channel
    get_available_shipping_methods_req.find_tag("locale").content = locale
    promo_code = params["PromoCode"]

    get_available_shipping_methods_data = get_available_shipping_methods_req.find_tag("get_available_shipping_methods_request").at(0)
    get_available_shipping_methods_data.customer_id.content = owner_id
    get_available_shipping_methods_data.customer_loyalty_number.content = nil

    if !promo_code.empty?
      get_available_shipping_methods_data.promocodes.at(0).string.content = promo_code
    else
      get_available_shipping_methods_data.promocodes.remove_self # since we aren't using a promocode, remove the entry
    end

    purchase_order_shipment_groups.each_with_index do |po_shipment, i|

      get_available_shipping_methods_req.find_tag("shipment").at(0).clone_as_sibling if i > 0

      shipment_id = po_shipment.shipment_id.content
      shipments_data = get_available_shipping_methods_req.find_tag("shipment").at(i)

      po_shipment.line_items.line_item.each_with_index do |item, a|

        shipments_data.line_items.line_item.at(0).clone_as_sibling if a > 0

        line_item = shipments_data.line_items.line_item.at(a)
        line_item.line_item_id.content = item.line_item_id.content
        line_item.list_price.content = item.list_price.content
        line_item.quantity.content = item.quantity.content
        line_item.sku.content = item.sku.content
      end

      ship_to_data = shipments_data.ship_to.at(0)
      ship_to_data.address_id.content = generate_guid
      ship_to_data.city.content = store_address["store_city"]
      ship_to_data.country_code.content = store_address["store_country_code"]
      ship_to_data.line1.content = store_address["store_line1"]
      ship_to_data.line2.content = nil
      ship_to_data.postal_code.content = store_address["store_zip"]
      ship_to_data.state.content = store_address["store_state"]

      shipments_data.shipment_id.content = shipment_id
      #shipments_data.shipment_type.content = params["ShipmentType"]
      shipments_data.shipment_type.content = "InStorePickup"
    end

    $tracer.trace(get_available_shipping_methods_req.formatted_xml)

    get_available_shipping_methods_rsp = self.get_available_shipping_methods(get_available_shipping_methods_req.xml)

    get_available_shipping_methods_rsp.code.should == 200

    $tracer.trace(get_available_shipping_methods_rsp.http_body.formatted_xml)
    return get_available_shipping_methods_rsp
  end

  def verify_operations(shipping_svc)
    $tracer.trace("GameStopShippingServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace(shipping_svc)
    shipping_svc.include?(:get_allowed_ship_to_countries) == true
    shipping_svc.include?(:get_available_fulfillment_channels) == true
    shipping_svc.include?(:get_available_shipping_methods) == true
    shipping_svc.include?(:get_shipping_method_definitions) == true
    shipping_svc.include?(:validate_address) == true
    return true
  end


  # Created a separate method so that there won't be a ton of impact on other tests particularly service tests
  def perform_get_shipping_methods_thru_cart(session_id, cart_id, version, ship_addr1, ship_addr2, ship_city, ship_state, ship_zip, ship_country, promo_code, cart_items)
    $tracer.trace("GameStopShippingServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_available_shipping_methods_req = self.get_request_from_template_using_global_defaults(:get_available_shipping_methods, ShippingServiceRequestTemplates.const_get("GET_AVAILABLE_SHIPPING_METHODS#{version}"))
    get_available_shipping_methods_req.find_tag("session_id").at(0).content = session_id
    get_available_shipping_methods_req.find_tag("targeting_context").items.name_value_property.remove_self
    get_available_shipping_methods_req.find_tag("client_channel").content = 'GS-US'
    get_available_shipping_methods_req.find_tag("locale").content = 'en-US'

    get_available_shipping_methods_data = get_available_shipping_methods_req.find_tag("get_available_shipping_methods_request").at(0)
    get_available_shipping_methods_data.customer_id.content = cart_id
    get_available_shipping_methods_data.customer_loyalty_number.content = nil

    if !promo_code.empty?
      get_available_shipping_methods_data.promocodes.at(0).string.content = promo_code
    else
      get_available_shipping_methods_data.promocodes.remove_self
    end

    cart_items.each_with_index do |cart, i|
      get_available_shipping_methods_req.find_tag("shipment").at(0).clone_as_sibling if i > 0
      shipments_data = get_available_shipping_methods_req.find_tag("shipment").at(i)

      line_item = shipments_data.line_items.line_item.at(0)
      line_item.line_item_id.content = cart.line_item_id.content
      line_item.list_price.content = cart.list_price.content
      line_item.quantity.content = cart.quantity.content
      line_item.sku.content = cart.sku.content

      ship_to_data = shipments_data.ship_to.at(0)
      ship_to_data.address_id.content = generate_guid
      ship_to_data.city.content = ship_city
      ship_to_data.country_code.content = ship_country
      ship_to_data.line1.content = ship_addr1
      ship_to_data.line2.content = ship_addr2
      ship_to_data.postal_code.content = ship_zip
      ship_to_data.state.content = ship_state
      shipments_data.shipment_id.content = generate_guid #shipment_id
      shipments_data.shipment_type.content = 'ShipToAddress' #shipment_type
    end

    $tracer.trace(get_available_shipping_methods_req.formatted_xml)
    get_available_shipping_methods_rsp = self.get_available_shipping_methods(get_available_shipping_methods_req.xml)
    get_available_shipping_methods_rsp.code.should == 200
    $tracer.trace(get_available_shipping_methods_rsp.http_body.formatted_xml)
    return get_available_shipping_methods_rsp
  end

end



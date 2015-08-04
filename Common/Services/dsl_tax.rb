module GameStopTaxServiceDSL

  def perform_calculate_tax(session_id, client_channel, locale, currency, row, version, purchase_order_shipment_groups, shipping_cost, taxabilitycode)
    $tracer.trace("GameStopTaxServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

    calculate_tax_req = self.get_request_from_template_using_global_defaults("calculate_tax", TaxServiceRequestTemplates.const_get("CALCULATE_TAX#{version}"))

    calculate_tax_req.find_tag("session_id").at(0).content = session_id
    calculate_tax_req.find_tag("client_channel").content = client_channel

    tax_data = calculate_tax_req.find_tag("calculate_tax_request").at(0)
    tax_data.client_country.content = locale
    tax_data.currency.content = currency
    tax_data.client_transaction_number.content = Random.rand(100000...999999)
    po_date = Time.now
    po_date = po_date.strftime("%Y-%m-%dT%H:%M:%S.000-06:00")
    puts purchase_order_shipment_groups
    purchase_order_shipment_groups.each_with_index do |po_shipment, p|

      shipment_id = po_shipment.shipment_id.content

      calculate_tax_req.find_tag("shipment").at(0).clone_as_sibling if p > 0

      tax_shipment_data = calculate_tax_req.find_tag("shipments").shipment.at(p)

      bill_to_data = tax_shipment_data.bill_to
      bill_to_data.address_id.content = generate_guid
      bill_to_data.city.content = row.find_value_by_name("BillCity")
      bill_to_data.country_code.content = row.find_value_by_name("BillCountryCode")
      bill_to_data.county.content = nil
      bill_to_data.line1.content = row.find_value_by_name("BillLine1")
      bill_to_data.line2.content = nil
      bill_to_data.postal_code.content = row.find_value_by_name("BillPostalCode")
      bill_to_data.state.content = row.find_value_by_name("BillState")

      po_shipment.line_items.line_item.each_with_index do |item, b|
        tax_shipment_data.line_items.line_item.at(0).clone_as_sibling if b > 0
        line_item = tax_shipment_data.line_items.line_item.at(b)

        line_item.description.content = item.product_type.content
        line_item.line_item_id.content = item.line_item_id.content
        line_item.quantity.content = item.quantity.content
        line_item.shipping_cost.content = item.shipping_cost.content
        line_item.shipping_tax.content = item.shipping_tax.content
        line_item.sku.content = item.sku.content
        line_item.tax.content = item.tax.content
        line_item.taxability_code.content = taxabilitycode
        line_item.unit_price_with_discounts.content = ("%.2f" % (BigDecimal(item.extended_price.content.to_s) / BigDecimal(item.quantity.content.to_s)))

      end

      ship_to_data = tax_shipment_data.ship_to
      ship_to_data.address_id.content = generate_guid
      ship_to_data.city.content = row.find_value_by_name("ShipCity")
      ship_to_data.country_code.content = row.find_value_by_name("ShipCountryCode")
      ship_to_data.county.content = nil
      ship_to_data.line1.content = row.find_value_by_name("ShipLine1")
      ship_to_data.line2.content = nil
      ship_to_data.postal_code.content = row.find_value_by_name("ShipPostalCode")
      ship_to_data.state.content = row.find_value_by_name("ShipState")

      tax_shipment_data.purchase_date.content = po_date
      tax_shipment_data.shipment_id.content = shipment_id
      tax_shipment_data.shipping_cost.content = shipping_cost[shipment_id] # no tax on shipping? or is it per state?
      tax_shipment_data.shipping_tax.content = 0
      tax_shipment_data.tax.content = 0
    end

    $tracer.trace(calculate_tax_req.formatted_xml)
    calculate_tax_rsp = self.calculate_tax(calculate_tax_req.xml)
    calculate_tax_rsp.code.should == 200
    $tracer.trace(calculate_tax_rsp.http_body.formatted_xml)
    return calculate_tax_rsp
  end

  def perform_calculate_tax_for_ispu(session_id, client_channel, locale, currency, params, store_address, version, purchase_order_shipment_groups, shipping_cost, taxabilitycode)
    $tracer.trace("GameStopTaxServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    calculate_tax_req = self.get_request_from_template_using_global_defaults("calculate_tax", TaxServiceRequestTemplates.const_get("CALCULATE_TAX#{version}"))

    calculate_tax_req.find_tag("session_id").at(0).content = session_id
    calculate_tax_req.find_tag("client_channel").content = client_channel

    tax_data = calculate_tax_req.find_tag("calculate_tax_request").at(0)
    tax_data.client_country.content = locale
    tax_data.currency.content = currency
    tax_data.client_transaction_number.content = Random.rand(100000...999999)
    po_date = Time.now
    po_date = po_date.strftime("%Y-%m-%dT%H:%M:%S.000-06:00")
    puts purchase_order_shipment_groups
    purchase_order_shipment_groups.each_with_index do |po_shipment, p|

      shipment_id = po_shipment.shipment_id.content

      calculate_tax_req.find_tag("shipment").at(0).clone_as_sibling if p > 0

      tax_shipment_data = calculate_tax_req.find_tag("shipments").shipment.at(p)

      bill_to_data = tax_shipment_data.bill_to
      bill_to_data.address_id.content = generate_guid
      bill_to_data.city.content = params["BillCity"]
      bill_to_data.country_code.content = params["BillCountryCode"]
      bill_to_data.county.content = nil
      bill_to_data.line1.content = params["BillLine1"]
      bill_to_data.line2.content = nil
      bill_to_data.postal_code.content = params["BillPostalCode"]
      bill_to_data.state.content = params["BillState"]

      po_shipment.line_items.line_item.each_with_index do |item, b|
        tax_shipment_data.line_items.line_item.at(0).clone_as_sibling if b > 0
        line_item = tax_shipment_data.line_items.line_item.at(b)

        line_item.description.content = item.product_type.content
        line_item.line_item_id.content = item.line_item_id.content
        line_item.quantity.content = item.quantity.content
        line_item.shipping_cost.content = item.shipping_cost.content
        line_item.shipping_tax.content = item.shipping_tax.content
        line_item.sku.content = item.sku.content
        line_item.tax.content = item.tax.content
        line_item.taxability_code.content = taxabilitycode
        line_item.unit_price_with_discounts.content = ("%.2f" % (BigDecimal(item.extended_price.content.to_s) / BigDecimal(item.quantity.content.to_s)))

      end

      ship_to_data = tax_shipment_data.ship_to
      ship_to_data.address_id.content = generate_guid
      ship_to_data.city.content = store_address["store_city"]
      ship_to_data.country_code.content = store_address["store_country_code"]
      ship_to_data.county.content = nil
      ship_to_data.line1.content = store_address["store_line1"]
      ship_to_data.line2.content = nil
      ship_to_data.postal_code.content = store_address["store_zip"]
      ship_to_data.state.content = store_address["store_state"]

      tax_shipment_data.purchase_date.content = po_date
      tax_shipment_data.shipment_id.content = shipment_id
      tax_shipment_data.shipping_cost.content = shipping_cost[shipment_id] # no tax on shipping? or is it per state?
      tax_shipment_data.shipping_tax.content = 0
      tax_shipment_data.tax.content = 0
    end

    $tracer.trace(calculate_tax_req.formatted_xml)
    calculate_tax_rsp = self.calculate_tax(calculate_tax_req.xml)
    calculate_tax_rsp.code.should == 200
    $tracer.trace(calculate_tax_rsp.http_body.formatted_xml)
    return calculate_tax_rsp
  end

  def verify_operations(tax_svc)
    $tracer.trace("GameStopTaxServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace(tax_svc)
    tax_svc.include?(:calculate_tax) == true
    return true
  end
end
		
		



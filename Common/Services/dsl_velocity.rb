# == Overview
# This module is specific to soap services and contains qa d-con script writer dsl's.
# It is mixed into ProfileService, as a monkey patch, in the dsl.rb file.

module GameStopVelocityServiceDSL


  def velocity_check (session_id, user_id, email, sku, ship_addr1, ship_addr2, ship_city, ship_state, ship_county, ship_zip, ship_country, bill_addr1, bill_addr2, bill_city, bill_state, bill_county, bill_zip, bill_country, version)
    $tracer.trace("GameStopVelocityServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    velocity_check_req = self.get_request_from_template_using_global_defaults(:product_velocity_check, VelocityServiceRequestTemplates.const_get("PRODUCT_VELOCITY_CHECK#{version}"))
    velocity_check_req.find_tag("session_id").content = session_id
    velocity_check_req.find_tag("email").content = email
    velocity_check_req.find_tag("product_velocity_days").content = 30
    velocity_check_req.find_tag("profile_id").content = user_id
    velocity_check_req.find_tag("sku").string.content = sku
    velocity_shipping_address = velocity_check_req.find_tag("shipping_address").at(0)
    velocity_shipping_address.address_id.content = generate_guid
    velocity_shipping_address.city.content = ship_city
    velocity_shipping_address.country_code.content = ship_country
    velocity_shipping_address.state.content = ship_state
    velocity_shipping_address.county.content = ship_county
    velocity_shipping_address.line1.content = ship_addr1
    velocity_shipping_address.line2.content = ship_addr2
    velocity_shipping_address.postal_code.content = ship_zip

    velocity_billing_address = velocity_check_req.find_tag("billing_address").at(0)
    velocity_billing_address.address_id.content = generate_guid
    velocity_billing_address.city.content = bill_city
    velocity_billing_address.country_code.content = bill_country
    velocity_billing_address.state.content = bill_state
    velocity_billing_address.county.content = bill_county
    velocity_billing_address.line1.content = bill_addr1
    velocity_billing_address.postal_code.content = bill_zip
    velocity_billing_address.line2.content = bill_addr2

    $tracer.trace(velocity_check_req.formatted_xml)

    velocity_check_rsp = self.product_velocity_check(velocity_check_req.xml)

    $tracer.trace(velocity_check_rsp.http_body.formatted_xml)
    return velocity_check_rsp.http_body.find_tag("velocity_status").content
  end

  def verify_operations(velocity_svc)
    $tracer.trace("GameStopVelocityServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace(velocity_svc)
    velocity_svc.include?(:velocity_check) == true
    return true
  end

end
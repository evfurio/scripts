# == Overview
# This module is specific to soap services and contains qa d-con script writer dsl's.

module GameStopStoreSearchServiceDSL

  def perform_find_stores_in_range(session_id, client_channel, locale, version)
    $tracer.trace("GameStopStoreSearchServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    find_stores_in_range_req = self.get_request_from_template_using_global_defaults(:find_stores_in_range, StoreSearchServiceRequestTemplates.const_get("FIND_STORES_IN_RANGE#{version}"))

    find_stores_in_range_req.find_tag("session_id").content = session_id # oddly found in header
    find_stores_in_range_req.find_tag("client_channel").content = client_channel
    find_stores_in_range_req.find_tag("locale").content = locale

    find_stores_data = find_stores_in_range_req.find_tag("find_stores_in_range_request").at(0)
    find_stores_data.address.content = '03062'
    find_stores_data.country_code.content = 'US'
    find_stores_data.radius_in_kilometers.content = '10'

    $tracer.trace(find_stores_in_range_req.formatted_xml)

    find_stores_in_range_rsp = self.find_stores_in_range(find_stores_in_range_req.xml)

    find_stores_in_range_rsp.code.should == 200

    #$tracer.trace(find_stores_in_range_rsp.http_body.formatted_xml)

    store_address = Hash.new

    store_address["store_city"] = find_stores_in_range_rsp.http_body.find_tag("address").at(0).city.content
    store_address["store_country_code"] = find_stores_in_range_rsp.http_body.find_tag("address").at(0).country_code.content
    store_address["store_line1"] = find_stores_in_range_rsp.http_body.find_tag("address").at(0).line1.content
    store_address["store_zip"] = find_stores_in_range_rsp.http_body.find_tag("address").at(0).zip.content
    store_address["store_state"] = find_stores_in_range_rsp.http_body.find_tag("address").at(0).state.content
    store_address["store_mall_name"] = find_stores_in_range_rsp.http_body.find_tag("store").at(0).mall.content
    store_address["store_number"] = find_stores_in_range_rsp.http_body.find_tag("store").at(0).store_number.content
    store_address["store_phone_number"] = find_stores_in_range_rsp.http_body.find_tag("store").at(0).phone_number.content

    return store_address
  end

  def perform_get_all_stores_in_range(session_id, client_channel, locale, version, zip, radius)
    $tracer.trace("GameStopStoreSearchServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    store_list = Array.new
    find_stores_in_range_req = self.get_request_from_template_using_global_defaults(:find_stores_in_range, StoreSearchServiceRequestTemplates.const_get("FIND_STORES_IN_RANGE#{version}"))

    find_stores_in_range_req.find_tag("session_id").content = session_id # oddly found in header
    find_stores_in_range_req.find_tag("client_channel").content = client_channel
    find_stores_in_range_req.find_tag("locale").content = locale

    find_stores_data = find_stores_in_range_req.find_tag("find_stores_in_range_request").at(0)
    find_stores_data.address.content = zip
    find_stores_data.country_code.content = 'US'
    find_stores_data.radius_in_kilometers.content = radius

    $tracer.trace(find_stores_in_range_req.formatted_xml)

    find_stores_in_range_rsp = self.find_stores_in_range(find_stores_in_range_req.xml)

    find_stores_in_range_rsp.code.should == 200

    #$tracer.trace(find_stores_in_range_rsp.http_body.formatted_xml)

    find_stores_in_range_rsp.http_body.find_tag("store").each do |find_stores_data|
      store_list << find_stores_data
    end

    return store_list
  end

  def verify_operations(storesearch_svc)
    $tracer.trace("GameStopStoreSearchServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace(storesearch_svc)
    storesearch_svc.include?(:find_stores_in_range) == true
    storesearch_svc.include?(:find_stores_in_range_by_geocode) == true
  end

end


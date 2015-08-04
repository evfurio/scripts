module GameStopTradeValueServiceDSL

  def perform_search_device (version, session_id, client_channel, locale, concept, keyword)
    $tracer.trace("GameStopTradeValueServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    device_details = nil

    search_device_req = self.get_request_from_template_using_global_defaults(:search_device, TradeValueServiceRequestTemplates.const_get("SEARCH_DEVICE#{version}"))

    device_data = search_device_req.find_tag("search_device_request").at(0)

    device_data.session_id.content = session_id
    device_data.client_channel.content = client_channel
    device_data.locale.content = locale
    device_data.concept.content = concept
    device_data.key_word.content = keyword

    $tracer.trace(search_device_req.formatted_xml)
    search_device_rsp = self.search_device(search_device_req.xml)
    search_device_rsp.code.should == 200

    $tracer.trace(search_device_rsp.http_body.formatted_xml)

    search_device_rsp.http_body.find_tag("endeca_record").each do |device_data|
      #shipping_address_list << device_data  if device_data.address_name.content.eql? ("Shipping")
      device_details = device_data if device_data.sku.content.eql? ("907016")
    end

    return device_details
  end


  def get_address_by_user_id(user_id, session_id, client_channel, version)
    $tracer.trace("GameStopTradeValueServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    shipping_address_list = Array.new
    billing_address = nil
    get_address_by_userid_req = self.get_request_from_template_using_global_defaults(:get_addresses, ProfileServiceRequestTemplates.const_get("GET_ADDRESS_BY_USER_ID#{version}"))

    address_data = get_address_by_userid_req.find_tag("get_addresses_request").at(0)
    address_data.client_channel.content = client_channel
    address_data.session_id.content = session_id
    address_data.user_id.content = user_id

    $tracer.trace(get_address_by_userid_req.formatted_xml)
    address_data_rsp = self.get_addresses(get_address_by_userid_req.xml)
    address_data_rsp.code.should == 200

    $tracer.trace(address_data_rsp.http_body.formatted_xml)

    # hold this for later comparisons, etc

    address_data_rsp.http_body.find_tag("address").each do |address_data|
      shipping_address_list << address_data if address_data.address_name.content.eql? ("Shipping")
      billing_address = address_data if address_data.address_name.content.eql? ("Billing")
    end

    return shipping_address_list, billing_address
  end


end
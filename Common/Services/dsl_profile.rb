# == Overview
# This module is specific to soap services and contains qa d-con script writer dsl's.
# It is mixed into ProfileService, as a monkey patch, in the dsl.rb file.

module GameStopProfileServiceDSL

  def perform_get_profile_by_open_id(open_id, session_id, client_channel, version)
    $tracer.trace("GameStopProfileServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_profile_by_open_id_req = self.get_request_from_template_using_global_defaults(:get_profile_by_open_id, ProfileServiceRequestTemplates.const_get("GET_PROFILE_BY_OPEN_ID#{version}"))

    profile_data = get_profile_by_open_id_req.find_tag("get_profile_by_open_id_request").at(0)
    profile_data.client_channel.content = client_channel
    profile_data.session_id.content = session_id
    profile_data.open_id.content = open_id

    $tracer.trace(get_profile_by_open_id_req.formatted_xml)
    profile_data_rsp = self.get_profile_by_open_id(get_profile_by_open_id_req.xml)
    profile_data_rsp.code.should == 200

    $tracer.trace(profile_data_rsp.http_body.formatted_xml)
    return profile_data_rsp
  end

  def perform_get_cart_id(open_id, session_id, client_channel, version)
    $tracer.trace("GameStopProfileServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_cart_id_rsp = perform_get_profile_by_open_id(open_id, session_id, client_channel, version)
    cart_id = get_cart_id_rsp.http_body.find_tag("cart_id").content
    $tracer.trace("Get CartId ::  #{cart_id}")
    return cart_id
  end

  def perform_get_addresses(open_id, session_id, client_channel, version)
    $tracer.trace("GameStopProfileServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_addresses_rsp = perform_get_profile_by_open_id(open_id, session_id, client_channel, version)
    shipping_addresses = Array.new
    billing_address = nil
    get_addresses_rsp.http_body.find_tag("address").each do |address_data|
      shipping_addresses << address_data if address_data.address_type.content.include?("Shipping")
      billing_address = address_data if address_data.address_type.content.include?("Billing")
    end

    $tracer.trace("Get Shipping and Billing Addresses")
    return shipping_addresses, billing_address
  end

  def perform_subscribe_to_mailing_list(email, session_id, client_channel, locale, version)
    $tracer.trace("GameStopProfileServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    subscribe_to_mailing_list_req = self.get_request_from_template_using_global_defaults(:subscribe_to_mailing_list, ProfileServiceRequestTemplates.const_get("SUBSCRIBE_TO_MAILING_LIST#{version}"))

    subscribe_data = subscribe_to_mailing_list_req.find_tag("subscribe_to_mailing_list_request").at(0)
    subscribe_data.client_channel.content = client_channel
    subscribe_data.locale.content = locale
    subscribe_data.session_id.content = session_id
    subscribe_data.email_address.content = email

    $tracer.trace(subscribe_to_mailing_list_req.formatted_xml)
    subscribe_data_rsp = self.subscribe_to_mailing_list(subscribe_to_mailing_list_req.xml)
    subscribe_data_rsp.code.should == 200

    $tracer.trace(subscribe_data_rsp.http_body.formatted_xml)

    return subscribe_data_rsp

  end

  def perform_unsubscribe_to_mailing_list(email, session_id, client_channel, locale, version)
    $tracer.trace("GameStopProfileServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    unsubscribe_to_mailing_list_req = self.get_request_from_template_using_global_defaults(:unsubscribe_to_mailing_list, ProfileServiceRequestTemplates.const_get("UNSUBSCRIBE_TO_MAILING_LIST#{version}"))

    unsubscribe_data = unsubscribe_to_mailing_list_req.find_tag("unsubscribe_from_mailing_list_request").at(0)
    unsubscribe_data.client_channel.content = client_channel
    unsubscribe_data.locale.content = locale
    unsubscribe_data.session_id.content = session_id
    unsubscribe_data.email_address.content = email

    $tracer.trace(unsubscribe_to_mailing_list_req.formatted_xml)
    unsubscribe_data_rsp = self.unsubscribe_to_mailing_list(unsubscribe_to_mailing_list_req.xml)
    unsubscribe_data_rsp.code.should == 200

    $tracer.trace(unsubscribe_data_rsp.http_body.formatted_xml)

    return unsubscribe_data_rsp

  end

  #GET_ADDRESS_BY_USER_ID
  # USAGE:
  # shipping_addresses, billing_address = @profile_svc.get_address_by_user_id(@user_id, @session_id,"GS_US", @profile_svc_version)


  def get_address_by_user_id(user_id, session_id, client_channel, version)
    $tracer.trace("GameStopProfileServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    shipping_address_list = []
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
      shipping_address_list << address_data if address_data.address_name.content.include?("Shipping")
      billing_address = address_data if address_data.address_name.content.include?("Billing")
    end

    return shipping_address_list, billing_address
  end

  def get_store_address_by_user_id(open_id, session_id, client_channel, version)
    $tracer.trace("GameStopProfileServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_profile_by_open_id_req = self.get_request_from_template_using_global_defaults(:get_profile_by_open_id, ProfileServiceRequestTemplates.const_get("GET_PROFILE_BY_OPEN_ID#{version}"))
    profile_data = get_profile_by_open_id_req.find_tag("get_profile_by_open_id_request").at(0)
    profile_data.client_channel.content = client_channel
    profile_data.session_id.content = session_id
    profile_data.open_id.content = open_id
    $tracer.trace(get_profile_by_open_id_req.formatted_xml)
    profile_data_rsp = self.get_profile_by_open_id(get_profile_by_open_id_req.xml)
    profile_data_rsp.code.should == 200
    $tracer.trace(profile_data_rsp.http_body.formatted_xml)

    # OPTIMIZE : I'm tired and this is taking too long.  Revisit to make this more efficient.
    store_list = []
    store_attr = []
    #"store_number, phone_number, mall_name, address_line1, address_line2, city, state, zip, country"
    profile_data_rsp.http_body.find_tag("preferred_store").each do |store_data|
      #Store Attributes to determine what store to return for use.
      # if home store, return addr, if default, return addr, if format not validated, don't use.  ect...

      store_attr << store_data.is_home_store[0].content
      store_attr << store_data.is_default[0].content
      store_attr << store_data.format_validated[0].content
      store_attr << store_data.preferred_store_id[0].content

      #Store & Address Information
      store_list << store_data.store_number[0].content
      #store_list << store_data.phone_number.phone_id[0].content
      store_list << store_data.phone_number.phone_number[0].content
      #store_list << store_data.phone_number.phone_number_type[0].content
      store_list << store_data.mall_name[0].content
      store_list << store_data.address_line1[0].content
      store_list << store_data.address_line2[0].content
      store_list << store_data.city[0].content
      store_list << store_data.state_or_province[0].content
      store_list << store_data.postal_code[0].content
      store_list << store_data.country[0].content
    end

    return store_list
  end

  # TODO : Deprecate method
  def obsolete_get_store_address_by_user_id(user_id, session_id, client_channel, version)
    $tracer.trace("GameStopProfileServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    store_address = nil
    get_address_by_userid_req = self.get_request_from_template_using_global_defaults(:get_addresses, ProfileServiceRequestTemplates.const_get("GET_ADDRESS_BY_USER_ID#{version}"))

    address_data = get_address_by_userid_req.find_tag("get_addresses_request").at(0)
    address_data.client_channel.content = client_channel
    address_data.session_id.content = session_id
    address_data.user_id.content = user_id

    $tracer.trace(get_address_by_userid_req.formatted_xml)
    address_data_rsp = self.get_addresses(get_address_by_userid_req.xml)
    address_data_rsp.code.should == 200
    $tracer.trace(address_data_rsp.http_body.formatted_xml)
    address_data_rsp.http_body.find_tag("address").each do |address_data|
      store_address = address_data if address_data.address_type.content.eql? ("StoreAddress")
    end

    return store_address
  end

  def get_profile(user_id, session_id, client_channel, version)
    $tracer.trace("GameStopProfileServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_user_profile_req = self.get_request_from_template_using_global_defaults(:get_user_profile, ProfileServiceRequestTemplates.const_get("GET_USER_PROFILE#{version}"))

    profile_data = get_user_profile_req.find_tag("get_user_profile_request").at(0)
    profile_data.client_channel.content = client_channel
    profile_data.session_id.content = session_id
    profile_data.user_id.content = user_id

    $tracer.trace(get_user_profile_req.formatted_xml)
    profile_data_rsp = self.get_user_profile(get_user_profile_req.xml)
    profile_data_rsp.code.should == 200

    $tracer.trace(profile_data_rsp.http_body.formatted_xml)

    return profile_data_rsp

  end

  #SAVE_ADDRESSES_SHIPPING_ADDRESS
  #SAVE_ADDRESSES_BILLING_ADDRESS
  def save_addresses
    $tracer.trace("GameStopProfileServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  #SAVE_ADDRESSES_STORE_ADDRESS
  def save_addresses_store_address
    $tracer.trace("GameStopProfileServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def verify_operations(profile_svc)
    $tracer.trace("GameStopProfileServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace(@profile_svc)
    profile_svc.include?(:save_addresses) == true
    profile_svc.include?(:get_profile_by_open_id) == true
    profile_svc.include?(:subscribe_to_mailing_list) == true
    profile_svc.include?(:unsubscribe_to_mailing_list) == true
    profile_svc.include?(:set_home_store_number) == true
    profile_svc.include?(:update_commerce_profile) == true
    return true
  end

end
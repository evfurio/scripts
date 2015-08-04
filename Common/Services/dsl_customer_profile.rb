# == Overview
# This module is specific to soap services and contains qa d-con script writer dsl's.
# It is mixed into CustomerProfileService, as a monkey patch, in the dsl.rb file.

module CustomerProfileServiceDSL

  def generate_address_from_pool(state_code, profile_id, open_id, is_default, address_type)
      address = GlobalFunctions.get_random_address_from_pool(state_code)

      address[:profile_id] = profile_id
      address[:open_id_claimed_identifier] = open_id
      address[:is_default] = is_default
      address[:address_type] = address_type

      return address

  end

  def convert_to_loyalty_enrollment_address(address)
    loyalty_address = {}

    loyalty_address['addr_line1'] = address[:address_line1]
    loyalty_address['addr_line2'] = address[:address_line2]
    loyalty_address['city'] = address[:city]
    loyalty_address['state'] = address[:state_or_province]
    loyalty_address['postal_code'] = address[:postal_code]
    loyalty_address['country'] = address[:country]

    # FIXME: assume for now it's US.
    loyalty_address['country_code'] = 'US'
    loyalty_address['locale'] = 'en-US'

    return loyalty_address
  end

  def create_address_req(address)
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")

    create_addr_req = self.get_request_from_template_using_global_defaults(:create_address, CustomerProfileServiceRequestTemplates.const_get("CREATE_ADDRESS"))
    create_addr_req.find_tag("address_line1").content = address[:address_line1]
    create_addr_req.find_tag("address_line2").content = address[:address_line2]
    create_addr_req.find_tag("city").content = address[:city]
    create_addr_req.find_tag("state_or_province").content = address[:state_or_province]
    create_addr_req.find_tag("postal_code").content = address[:postal_code]
    create_addr_req.find_tag("country").content = address[:country]
    create_addr_req.find_tag("address_type").content = address[:address_type]
    create_addr_req.find_tag("profile_id").content = address[:profile_id] unless address[:profile_id].nil?
    create_addr_req.find_tag("open_id_claimed_identifier").content = address[:open_id_claimed_identifier]
    create_addr_req.find_tag("is_default").content = address[:is_default]
    create_addr_req.find_tag("is_validated").content = 'true'

    init_header(create_addr_req)
    remove_unused_elements(create_addr_req)
    $tracer.trace(create_addr_req.formatted_xml)

    create_addr_rsp = self.create_address(create_addr_req.xml)
    create_addr_rsp.code.should == 200

    $tracer.trace(create_addr_rsp.http_body.formatted_xml)

    $tracer.report("should #{__method__}")


    return create_addr_rsp
  end

  def create_phone(phone)
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")

    create_phone_req = self.get_request_from_template_using_global_defaults(:create_phone, CustomerProfileServiceRequestTemplates.const_get("CREATE_PHONE"))
    create_phone_req.find_tag("open_id_claimed_identifier").content = phone[:open_id]
    create_phone_req.find_tag("phone_number").content = phone[:number]
    $tracer.trace(create_phone_req.formatted_xml)
    create_phone_rsp = self.create_address(create_phone_req.xml)
    create_phone_rsp.code.should == 200

    $tracer.trace(create_phone_rsp.http_body.formatted_xml)

    $tracer.report("should #{__method__}")
  end


  def create_preferred_store
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def create_profile_req(open_id)
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")

    create_profile_req = self.get_request_from_template_using_global_defaults(:create_profile, CustomerProfileServiceRequestTemplates.const_get("CREATE_PROFILE"))
    create_profile_req.find_tag("open_id_claimed_identifier").content = open_id
    init_header(create_profile_req)
    remove_elements = %w(birth_date addresses phones preferred_stores overrides data_verifications)
    remove_unused_elements(create_profile_req, remove_elements)

    $tracer.trace(create_profile_req.formatted_xml)
    create_profile_rsp = self.create_profile(create_profile_req.xml)
    create_profile_rsp.code.should == 200

    $tracer.trace(create_profile_rsp.http_body.formatted_xml)
    $tracer.report("should #{__method__}")

    return create_profile_rsp.http_body.find_tag("profile_id").content
  end

  def delete_address
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def delete_phone
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def delete_preferred_store
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def get_extended_profile_by_open_id
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def get_profile_by_card_number
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def get_profile_by_profile_id
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def get_version
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def search_profile_by_email
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def search_profile_by_last_name_and_zip
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def search_profile_by_open_id
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def search_profile_by_phone_number
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def update_address
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def update_phone
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def update_preferred_store
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def update_profile
    $tracer.trace("CustomerProfileServiceDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.report("should #{__method__}")
  end

  def remove_unused_elements(req, remove_elements=nil)
    req.find_tag('key_value_pairs').remove_self
    req.find_tag('security_token').remove_self

    remove_elements.each {|e| req.find_tag(e).remove_self} unless remove_elements.nil?

    # Remove any elements that still have a '?', i.e. they have not been set
    all_elements = req.__send__(:find_tag_to_depth, /.*/, nil)
    all_elements.each {|e| e.remove_self if e.respond_to?(:content) && e.content == '?'}
  end

  def init_header(req)
    req.find_tag('machine_name').content = Socket.gethostname
    req.find_tag('locale').content = 'en-US'
    req.find_tag('time_zone').content = 'true'
    req.find_tag('country_code').content = 'US'
  end
end
# == Overview
# This module is specific to soap services and contains qa d-con script writer dsl's.

module LoyaltyEnrollmentServiceDSL

  def update_loyalty_address_with_non_address_info(loyalty_address = {}, first_name = nil, last_name = nil, phone_number = nil, pur_tier = nil, is_default = 'true', store_number = nil)
    loyalty_address['is_default_addr'] = is_default

    loyalty_address['first_name'] = first_name unless first_name.nil?
    loyalty_address['last_name'] = last_name unless last_name.nil?
    loyalty_address['phone_number'] = phone_number unless phone_number.nil?
    loyalty_address['store_number'] = store_number unless store_number.nil?

    unless pur_tier.nil?
      loyalty_address['pur_tier'] = (pur_tier.upcase == "FREE") ? '3875' : '3876'
    end

    return loyalty_address
  end

  # Enrollment service that auto generates email address and randomly generates a new PUR card number. Returns email address and card number successfully enrolled.
  # Validates enrolled user exists in the database.
  # === Parameters:
  # _first_name_:: User's first name found in both personal info and address
  # _last_name_:: User's last name found in both personal info and address
  # _address_line1_:: Address line 1 value for mailing address
  # _address_line2_:: Address line 2 value for mailing address (can be nil)
  # _city_:: City value for mailing address
  # _state_:: State value for mailing address
  # _zip_:: Zip (postal code) value for mailing address
  # _country_:: Country value for mailing address
  # _phone_number_:: Phone number value for mailing address
  # _birth_date_:: Birth date value that displays in personal info and during step 2 for PUR activation
  # _store_number_:: Store number value that displays in Stores
  # _tier_:: Paid vs free PUR membership (3876 or 3875 respectively)

  def enroll_pur_user(params)
    $tracer.trace("LoyaltyEnrollmentServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    first_name = params['first_name']
    last_name = params['last_name']
    is_default_addr = params['is_default_addr']
    address_line1 = params['addr_line1']
    address_line2 = params['addr_line2']
    city = params['city']
    state = params['state']
    zip = params['postal_code']
    country = params['country']
    country_code = params['country_code']
    locale = params['locale']
    phone_number = params['phone_number']
    #birth_date = params['birth_date']
    month_range = %w(01 02 03 04 05 06 07 08 09 10 11 12).sample
    if month_range == "02"
      # Purposefully omitting leap years because they're stupid.  Will add later.
      day_range = %w(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28).sample
    elsif month_range == "01" || "03" || "05" || "07" || "08" || "10" || "12"
      day_range = %w(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 31).sample
    else
      day_range = %w(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30).sample
    end
    t = Time.now
    time_stamp = t.strftime("%FT%T.0000000-06:00")
    time = t.strftime("%T")
    date = t.strftime("%F")

    birth_yr_range = Random.new.rand(1900..1996).to_s
    birth_date = "#{birth_yr_range}-#{month_range}-#{day_range}T#{time}.0000000-06:00"
    store_number = params['store_number']
    tier = params['pur_tier']
    new_flag = params['generate_user_name']

    if Config::CONFIG['target_os'] != "darwin"
      machine_name = Socket.gethostname
    else
      machine_name = "d-con automation"
    end

    db = DbManager.new("GV1HQQDB50SQL01.testgs.pvt\\INST01", "Membership")

    # Sets flag to determine if auto generated card number exists
    card_exists = false
    @named = {
        :purfree => {:prefixes => ['3975'], :size => 13},
        :purpaid => {:prefixes => ['3976'], :size => 13}
    }
    # Loop to generate a non-existing loyalty card number
    while card_exists == false do

      if tier == '3876'
        cctype = "purpaid"

      elsif tier == '3875'
        cctype = "purfree"
      else
        $tracer.trace("No PUR Card Generated, please check that the tier is correct")
        cctype = nil
      end
      membership_number = CreditCard.method_missing("#{cctype}", @named)

      #Check if generated card number exists in MembershipCard db
      confirm_results = db.exec_sql("SELECT MembershipID FROM Membership.dbo.MembershipCard WHERE CardNumber = '" + membership_number + "';")

      if confirm_results != nil
        $tracer.trace("Card number exists")
        $tracer.trace("DB RESULTS: " + confirm_results.at(0).MembershipID.to_s)
        card_exists = false
      elsif
      $tracer.trace("Card number does not exist")
        card_exists = true
      end
    end

    $tracer.trace("Card number: " + membership_number)

    # Generate a new email address
    (new_flag == true) ? email = auto_generate_username(nil, "#{params['email_domain']}", "#{params['email_prefix']}") : email = params['email']
    #email = auto_generate_username(nil, "#{params['email_domain']}", "#{params['email_prefix']}")
    $tracer.report("Email address: #{email}")

    #Defines the service template to use
    pur_enrollment_request = self.get_request_from_template(LoyaltyMembershipServiceRequestTemplates::ENROLL_CUSTOMER_FOR_MEMBERSHIP)

    # Sets request values
    header = pur_enrollment_request.envelope.header.message_headers
    header.machine_name.content = machine_name

    key_value_pair_list = header.key_value_pairs.at(0)

    key_value_pair_list.key_value_pair.at(0).key.content = "channeltype"
    key_value_pair_list.key_value_pair.at(0).value.content = "PointOfSale"
    key_value_pair_list.key_value_pair.at(0).clone_as_sibling
    key_value_pair_list.key_value_pair.at(1).key.content = "storenumber"
    key_value_pair_list.key_value_pair.at(1).value.content = store_number

    header.culture_info.locale.content = locale
    header.culture_info.time_zone.content = "true"
    header.culture_info.country_code.content = country_code

    # Purposefully misspelled - do not correct
    header.secutiry_token.content = nil

    body = pur_enrollment_request.envelope.body.enroll_customer_for_membership_request.customer
    address_list = body.find_tag("addresses").at(0)
    address_list.address.at(0).address_guid.content = nil
    address_list.address.at(0).address_id.remove_self
    address_list.address.at(0).address_line1.content = address_line1
    address_list.address.at(0).address_line2.content = address_line2
    address_list.address.at(0).address_line3.content = nil
    address_list.address.at(0).address_line4.content = nil
    #Address type HOME maps to MAILING
    address_list.address.at(0).address_type.content = "Home"
    address_list.address.at(0).city.content = city
    address_list.address.at(0).company_name.content = nil
    address_list.address.at(0).country.content = country
    address_list.address.at(0).county.content = nil
    address_list.address.at(0).first_name.content = first_name
    address_list.address.at(0).is_default.content = is_default_addr
    address_list.address.at(0).last_name.content = last_name
    address_list.address.at(0).postal_code.content = zip
    address_list.address.at(0).state_or_province.content = state

    body.date_of_birth.content = nil
    body.edge_card_discount_number.content = nil
    body.display_name.content = nil
    body.email_address.content = email
    body.email_opt_out.content = nil
    body.first_name.content = first_name
    body.gender.remove_self
    phones_list = body.find_tag("phones").at(0)
    phones_list.phone.at(0).home_phone_number.content = phone_number
    phones_list.phone.at(0).mobile_phone_number.content = nil
    phones_list.phone.at(0).primary_phone.content = "Home"
    phones_list.phone.at(0).work_phone_number.content = nil
    body.home_store_number.remove_self # MAY NEED TO ADD BACK
    body.identifications.remove_self
    body.issued_user.content = nil
    body.last_name.content = last_name
    body.loyalty_info.valid_loyalty_membership.remove_self
    body.loyalty_info.card_status.remove_self
    body.loyalty_info.detailed_card_status.remove_self
    body.loyalty_info.detailed_membership_status.remove_self
    body.loyalty_info.end_date.remove_self
    body.loyalty_info.failed_login_attempts.remove_self
    body.loyalty_info.is_locked_out.content = "false"
    body.loyalty_info.login_time_stamp.content = "#{date}T#{time}.0000000-06:00"
    body.loyalty_info.loyalty_card_number.content = membership_number
    body.loyalty_info.membership_id.remove_self
    body.loyalty_info.membership_status.remove_self
    body.loyalty_info.online_account_status.remove_self
    body.loyalty_info.roles.remove_self
    body.loyalty_info.tier.content = tier

    body.loyalty_info.tier_expiration_date.content = "#{t.strftime("%Y").to_i + 1}-#{t.strftime("%m")}-#{t.strftime("%d")}T#{time}.0000000-06:00"
    body.loyalty_info.tier_sign_up_date.content = "#{date}T#{time}.0000000-06:00"
    body.loyalty_info.total_power_up_savings.remove_self
    body.membership_ids.remove_self
    body.middle_name.content = nil
    body.prefix.content = nil
    body.race.remove_self
    body.suffix.content = nil
    body.title.content = nil
    body.user_name.content = nil
    body.customer_activities.content = nil
    body.valid_email_address.remove_self
    body.membership_type.remove_self

    # Formats the request in xml format
    $tracer.trace(pur_enrollment_request.formatted_xml)

    # Returns response from submitted request
    pur_enrollment_response = self.enroll_customer_for_membership(pur_enrollment_request.xml)
    # Validates response code is successful
    $tracer.trace("response: " + pur_enrollment_response.code.to_s)
    pur_enrollment_response.code.should == 200
    $tracer.trace(pur_enrollment_response.http_body.formatted_xml)
    # Retrieves profile ID from the status message in the response
    status_result = pur_enrollment_response.http_body.find_tag("status").at(0).content
    pur_profile_id = status_result.to_s[35, 44]
    $tracer.report("Profile ID for querying Membership Database: " + pur_profile_id)
    # Validates in Membership db that the user is enrolled
    results = db.exec_sql("SELECT MembershipID, MembershipStatusID FROM Membership.dbo.Membership WHERE MembershipID IN (SELECT MembershipID FROM Profile.KeyMap.CustomerKey WHERE ProfileID = '" + pur_profile_id + "');")
    $tracer.report("Customer Id, AKA Membership Id: " + results.at(0).MembershipID.to_s)
    customer_id = results.at(0).MembershipID.to_s
    results.at(0).MembershipID.should > 0
    results.at(0).MembershipStatusID.should == 2
    $tracer.report("Enrolled email: " + email)
    $tracer.report("Card Number: " + membership_number)

    return email, membership_number, pur_profile_id, customer_id
  end

  def enroll_existing_user(params, email)
    $tracer.trace("LoyaltyEnrollmentServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    first_name = params['first_name']
    last_name = params['last_name']
    is_default_addr = params['is_default_addr']
    address_line1 = params['addr_line1']
    address_line2 = params['addr_line2']
    city = params['city']
    state = params['state']
    zip = params['postal_code']
    country = params['country']
    country_code = params['country_code']
    locale = params['locale']
    phone_number = params['phone_number']
    store_number = params['store_number']
    tier = params['pur_tier']

    t = Time.now
    time = t.strftime("%T")
    date = t.strftime("%F")

    machine_name = "d-con automation"
=begin
    if Config::CONFIG['target_os'] != "darwin"
      machine_name = Socket.gethostname
    else
      machine_name = "d-con automation"
    end

    db = DbManager.new("GV1HQQDB50SQL01.testgs.pvt\\INST01", "Membership")
=end

    # Sets flag to determine if auto generated card number exists
    card_exists = false
    @named = {
        :purfree => {:prefixes => ['3975'], :size => 13},
        :purpaid => {:prefixes => ['3976'], :size => 13}
    }
    # Loop to generate a non-existing loyalty card number
    while card_exists == false do

      if tier == '3876'
        cctype = "purpaid"
        cctype = "purfree"
      else
        $tracer.trace("No PUR Card Generated, please check that the tier is correct")
        cctype = nil
      end
      membership_number = CreditCard.method_missing("#{cctype}", @named)
      card_exists = true

      #Check if generated card number exists in MembershipCard db
=begin
      confirm_results = db.exec_sql("SELECT MembershipID FROM Membership.dbo.MembershipCard WHERE CardNumber = '" + membership_number + "';")

      if confirm_results != nil
        $tracer.trace("Card number exists")
        $tracer.trace("DB RESULTS: " + confirm_results.at(0).MembershipID.to_s)
        card_exists = false
      elsif
      $tracer.trace("Card number does not exist")
        card_exists = true
      end
=end
    end

    $tracer.trace("Card number: " + membership_number)
    $tracer.report("Email address: #{email}")

    #Defines the service template to use
    pur_enrollment_request = self.get_request_from_template(LoyaltyMembershipServiceRequestTemplates::ENROLL_CUSTOMER_FOR_MEMBERSHIP)

    # Sets request values
    header = pur_enrollment_request.envelope.header.message_headers
    header.machine_name.content = machine_name

    key_value_pair_list = header.key_value_pairs.at(0)

    key_value_pair_list.key_value_pair.at(0).key.content = "channeltype"
    key_value_pair_list.key_value_pair.at(0).value.content = "PointOfSale"
    key_value_pair_list.key_value_pair.at(0).clone_as_sibling
    key_value_pair_list.key_value_pair.at(1).key.content = "storenumber"
    key_value_pair_list.key_value_pair.at(1).value.content = store_number

    header.culture_info.locale.content = locale
    header.culture_info.time_zone.content = "true"
    header.culture_info.country_code.content = country_code

    # Purposefully misspelled - do not correct
    header.secutiry_token.content = nil
    body = pur_enrollment_request.envelope.body.enroll_customer_for_membership_request.customer
    address_list = body.find_tag("addresses").at(0)
    address_list.address.at(0).address_guid.content = nil
    address_list.address.at(0).address_id.remove_self
    address_list.address.at(0).address_line1.content = address_line1
    address_list.address.at(0).address_line2.content = address_line2
    address_list.address.at(0).address_line3.content = nil
    address_list.address.at(0).address_line4.content = nil
    #Address type HOME maps to MAILING
    address_list.address.at(0).address_type.content = "Home"
    address_list.address.at(0).city.content = city
    address_list.address.at(0).company_name.content = nil
    address_list.address.at(0).country.content = country
    address_list.address.at(0).county.content = nil
    address_list.address.at(0).first_name.content = first_name
    address_list.address.at(0).is_default.content = is_default_addr
    address_list.address.at(0).last_name.content = last_name
    address_list.address.at(0).postal_code.content = zip
    address_list.address.at(0).state_or_province.content = state

    body.date_of_birth.content = nil
    body.edge_card_discount_number.content = nil
    body.display_name.content = nil
    body.email_address.content = email
    body.email_opt_out.content = nil
    body.first_name.content = first_name
    body.gender.remove_self
    phones_list = body.find_tag("phones").at(0)
    phones_list.phone.at(0).home_phone_number.content = phone_number
    phones_list.phone.at(0).mobile_phone_number.content = nil
    phones_list.phone.at(0).primary_phone.content = "Home"
    phones_list.phone.at(0).work_phone_number.content = nil
    body.home_store_number.remove_self # MAY NEED TO ADD BACK
    body.identifications.remove_self
    body.issued_user.content = nil
    body.last_name.content = last_name
    body.loyalty_info.valid_loyalty_membership.remove_self
    body.loyalty_info.card_status.remove_self
    body.loyalty_info.detailed_card_status.remove_self
    body.loyalty_info.detailed_membership_status.remove_self
    body.loyalty_info.end_date.remove_self
    body.loyalty_info.failed_login_attempts.remove_self
    body.loyalty_info.is_locked_out.content = "false"
    body.loyalty_info.login_time_stamp.content = "#{date}T#{time}.0000000-06:00"
    body.loyalty_info.loyalty_card_number.content = membership_number
    body.loyalty_info.membership_id.remove_self
    body.loyalty_info.membership_status.remove_self
    body.loyalty_info.online_account_status.remove_self
    body.loyalty_info.roles.remove_self
    body.loyalty_info.tier.content = tier

    body.loyalty_info.tier_expiration_date.content = "#{t.strftime("%Y").to_i + 1}-#{t.strftime("%m")}-#{t.strftime("%d")}T#{time}.0000000-06:00"
    body.loyalty_info.tier_sign_up_date.content = "#{date}T#{time}.0000000-06:00"
    body.loyalty_info.total_power_up_savings.remove_self
    body.membership_ids.remove_self
    body.middle_name.content = nil
    body.prefix.content = nil
    body.race.remove_self
    body.suffix.content = nil
    body.title.content = nil
    body.user_name.content = nil
    body.customer_activities.content = nil
    body.valid_email_address.remove_self
    body.membership_type.remove_self

    # Formats the request in xml format
    $tracer.trace(pur_enrollment_request.formatted_xml)

    # Returns response from submitted request
    pur_enrollment_response = self.enroll_customer_for_membership(pur_enrollment_request.xml)
    # Validates response code is successful
    $tracer.trace("response: " + pur_enrollment_response.code.to_s)
    pur_enrollment_response.code.should == 200

    $tracer.trace(pur_enrollment_response.http_body.formatted_xml)
    # Retrieves profile ID from the status message in the response
    status_result = pur_enrollment_response.http_body.find_tag("status").at(0).content
    pur_profile_id = status_result.to_s[35, 44]
    $tracer.report("Profile ID for querying Membership Database: " + pur_profile_id)
    # Validates in Membership db that the user is enrolled
=begin
    results = db.exec_sql("SELECT MembershipID, MembershipStatusID FROM Membership.dbo.Membership WHERE MembershipID IN (SELECT MembershipID FROM Profile.KeyMap.CustomerKey WHERE ProfileID = '" + pur_profile_id + "');")
    $tracer.report("Customer Id, AKA Membership Id: " + results.at(0).MembershipID.to_s)
    customer_id = results.at(0).MembershipID.to_s
    results.at(0).MembershipID.should > 0
    results.at(0).MembershipStatusID.should == 2
    $tracer.report("Enrolled email: " + email)
    $tracer.report("Card Number: " + membership_number)
=end
    return email, membership_number, pur_profile_id
  end

  def brierley_enroll_member(params, customer_id, email, membership_number)
    $tracer.trace("LoyaltyEnrollmentServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    t = Time.now.strftime("%")
    time_stamp = ("#{t.month}/#{t.day}/#{t.year} #{t.hour}:#{t.minutes}:#{t.seconds} #{t.strftime("%p")}")
    exp_time_stamp = ("#{t.month}/#{t.day}/#{t.year + 1} #{t.hour}:#{t.minutes}:#{t.seconds} #{t.strftime("%p")}")
    brierley_enroll_member = self.get_request_from_template(LoyaltyMembershipServiceRequestTemplates::BRIERLEY_ENROLL_MEMBER)

    enroll_member = brierley_enroll_member.envelope.body.enroll_member_request_part
    customer = enroll_member.customer.at(0)
    customer.customer_id.content = customer_id
    customer.first_name.content = params['first_name']
    customer.middle_name.content = nil
    customer.last_name.content = params['last_name']
    customer.email_address.content = email
    customer.phone_number = params['phone_number']
    loyalty_info = customer.loyalty_info.at(0)
    loyalty_info.loyalty_card_number.content = membership_number
    loyalty_info.tier.content = params['pur_tier']
    loyalty_info.tier_sign_up_date.content = time_stamp
    loyalty_info.tier_expiration_date.content = exp_time_stamp
    loyalty_info.loyalty_card_status.content = "Activated"
    loyalty_info.membership_status.content = "Activated"
    customer.online_account_status.content = "Ok"
    customer.is_locked_out.content = "False"
    event_request_info = enroll_member.event_request_info.at(0)
    event_request_info.event_guid.content = generate_guid
    event_request_info.time_stamp.content = time_stamp
    event_request_info.channel_type.content = "PointOfSale"
    event_request_info.store_id.content = params['store_number']
  end


  def activate_pur_membership(params, membership_number, open_id)
    $tracer.trace("LoyaltyEnrollmentServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    country_code = params['country_code']
    locale = params['locale']

    activate_member_request = self.get_request_from_template(LoyaltyMembershipServiceRequestTemplates::ACTIVATE_MEMBERSHIP)

    # Sets request values
    header = activate_member_request.envelope.header.message_headers
    if Config::CONFIG['target_os'] != "darwin"
      machine_name = Socket.gethostname
    else
      machine_name = "d-con automation"
    end
    header.machine_name.content = machine_name

    key_value_pair_list = header.key_value_pairs.at(0)
    key_value_pair_list.key_value_pair.at(0).key.content = "channeltype"
    key_value_pair_list.key_value_pair.at(0).value.content = "PointOfSale"
    key_value_pair_list.key_value_pair.at(0).clone_as_sibling
    key_value_pair_list.key_value_pair.at(1).key.content = "storenumber"
    key_value_pair_list.key_value_pair.at(1).value.content = params['store_number']

    header.culture_info.locale.content = locale
    header.culture_info.time_zone.content = "true"
    header.culture_info.country_code.content = country_code

    header.find_tag("secutiry_token").at(0).content = ""

    body = activate_member_request.envelope.body.activate_customer_membership_request
    body.loyalty_card_number.content = membership_number
    body.open_id_claimed_identifier.content = open_id
    body.card_status.content = "Linked"

    # Formats the request in xml format
    $tracer.trace(activate_member_request.formatted_xml)

    # $tracer.trace(@loyalty_membership.operations)
    # Returns response from submitted request
    activate_membership_rsp = self.activate_customer_membership(activate_member_request.xml)
    activate_membership_rsp.code.should == 200

    $tracer.trace(activate_membership_rsp.http_body.formatted_xml)

    status_result = activate_membership_rsp.http_body.find_tag("status").at(0).content
    $tracer.trace("Activation status : #{status_result}")
    return status_result
  end

  def activate_loyalty_membership(params, membership_number, customer_id, profile_id, open_id, membership_svc)
    $tracer.trace("LoyaltyEnrollmentServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    activate_loyalty_mem_request = self.get_request_from_template(LoyaltyMembershipServiceRequestTemplates::ACTIVATE_LOYALTY_MEMBERSHIP)

    header = activate_loyalty_mem_request.envelope.header.at(0)
    if Config::CONFIG['target_os'] != "darwin"
      machine_name = Socket.gethostname
    else
      machine_name = "d-con automation"
    end
    header.machine_name.content = machine_name
    header.correlation_id.remove_self

    body = activate_loyalty_mem_request.envelope.body.activate_membership_request
    body.card_number.content = membership_number
    body.membership_id.content = customer_id
    body.open_id_claimed_identifier.content = open_id

    $tracer.trace(activate_loyalty_mem_request.formatted_xml)

    activate_loyalty_mem_rsp = membership_svc.activate_membership(activate_loyalty_mem_request.xml)
    activate_loyalty_mem_rsp.code.should == 200

    $tracer.trace(activate_loyalty_mem_rsp.http_body.formatted_xml)

    db = DbManager.new("GV1HQQDB50SQL01.testgs.pvt\\INST01", "Membership")
    results = db.exec_sql("SELECT MembershipID, MembershipStatusID FROM Membership.dbo.Membership WHERE MembershipID IN (SELECT MembershipID FROM Profile.KeyMap.CustomerKey WHERE ProfileID = '" + profile_id + "');")
    $tracer.report("Customer Id: " + results.at(0).MembershipID.to_s)
    results.at(0).MembershipID.should > 0
    results.at(0).MembershipStatusID.should == 1
    if results.at(0).MembershipStatusID == 1
      status = true
    end

    return status
  end

end


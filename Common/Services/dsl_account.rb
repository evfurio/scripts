# == Overview
# This module is specific to soap services and contains qa d-con script writer dsl's.
# It is mixed into AccountService, as a monkey patch, in the dsl.rb file.

module GameStopAccountServiceDSL

  # Request authorization of a specified user.  If the specified user name is nil, then anonymous
  # authorization is requested.  The response message will be returned from operation authorize_anonymous
  # or authorize, accordingly.
  # === Parameters:
  # _session_id_:: session guid
  # _user_name_:: name of the user to be authorized (if nil (default), then anonymous authorization is performed)
  # _user_password_:: password of the user to be authorized (unused if user_name is nil (default))
  def perform_authorization_and_return_message(session_id, user_name, user_password, version)
    $tracer.trace("GameStopAccountServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    authorize_req, authorize_rsp = nil, nil
    authorize_data = nil

    # check to see if authorization is for a particular user, or should be anon.
    if user_name.nil?
      # anonymous authorization
      authorize_req = self.get_request_from_template_using_global_defaults(:authorize_anonymous, AccountServiceRequestTemplates.const_get("AUTHORIZE_ANONYMOUS#{version}"))

      authorize_data = authorize_req.find_tag("authorize_anonymous_request").at(0)
      authorize_data.client_anonymous_user_id.content = nil
    else
      # user authorization
      authorize_req = self.get_request_from_template_using_global_defaults(:authorize, AccountServiceRequestTemplates.const_get("AUTHORIZE#{version}"))

      authorize_data = authorize_req.find_tag("authorize_request").at(0)
      authorize_data.username.content = user_name
      authorize_data.password.content = user_password
    end

    authorize_data.session_id.content = session_id

    $tracer.trace(authorize_req.formatted_xml)

    # call the account service authorize operation
    if user_name.nil?
      # anonymous authorization
      authorize_rsp = self.authorize_anonymous(authorize_req.xml)
      authorize_result = authorize_rsp.http_body.find_tag("authorization_result").at(0)
      authorize_result.status.content.should == "Authorized"
      #return authorize_result.user_id.content, @is_guest = true
    else
      # user authorization
      authorize_rsp = self.authorize(authorize_req.xml)
      authorize_result = authorize_rsp.http_body.find_tag("authorization_result").at(0)
      authorize_result.status.content.should == "Authorized"
      #return authorize_result.user_id.content, @is_guest = false
    end

    $tracer.trace(authorize_rsp.http_body.get_received_message)
    $tracer.trace(authorize_rsp.http_body.formatted_xml)
    return authorize_rsp
  end

  def perform_authorize_anonymous(session_id, user_name, user_password, version)
    $tracer.trace("GameStopAccountServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    authorize_req = self.get_request_from_template_using_global_defaults(:authorize_anonymous, AccountServiceRequestTemplates.const_get("AUTHORIZE_ANONYMOUS#{version}"))
    $tracer.trace(authorize_req.formatted_xml)
    authorize_data = authorize_req.find_tag("authorize_anonymous_request").at(0)
    authorize_data.session_id.content = session_id
    authorize_data.client_anonymous_user_id.content = nil

    # anonymous authorization
    authorize_rsp = self.authorize_anonymous(authorize_req.xml)
    authorize_result = authorize_rsp.http_body.find_tag("authorization_result").at(0)
    authorize_result.status.content.should == "Authorized"
    user_id = authorize_result.user_id
    token = authorize_result.token

    return user_id, token
  end

  # Request authorization of a specified user.  If the specified user name is nil, then anonymous
  # authorization is requested.  A user id (owner id) will be returned.
  # === Parameters:
  # _session_id_:: session guid
  # _user_name_:: name of the user to be authorized (if nil (default), then anonymous authorization is performed)
  # _user_password_:: password of the user to be authorized (unused if user_name is nil (default))
  def perform_authorization_and_return_owner_id(session_id, user_name = nil, user_password = "", version)
    $tracer.trace("GameStopAccountServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    authorize_rsp = perform_authorization_and_return_message(session_id, user_name, user_password, version)

    # verify we receive a 200
    authorize_rsp.code.should == 200

    # find "authorization_result" in the response messsage received, and verify user is authorized
    authorize_result = authorize_rsp.http_body.find_tag("authorization_result").at(0)
    authorize_result.status.content.should == "Authorized"
    # return owner_id (user_id).. this will be used to add products to cart, etc.

    return authorize_result.user_id.content
  end

  def perform_authorization_and_return_user_and_open_id(session_id, user_name = nil, user_password = "", version)
    $tracer.trace("GameStopAccountServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    authorize_rsp = perform_authorization_and_return_message(session_id, user_name, user_password, version)

    # verify we receive a 200
    authorize_rsp.code.should == 200
    # find "authorization_result" in the response messsage received, and verify user is authorized
    authorize_result = authorize_rsp.http_body.find_tag("authorization_result").at(0)
    authorize_result.status.content.should == "Authorized"
    # return owner_id (user_id).. this will be used to add products to cart, etc.

    return authorize_result.authenticator_user_id.content
  end

  def perform_authorization_and_return_open_id(session_id, user_name = nil, user_password = "", version)
    $tracer.trace("GameStopAccountServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    authorize_rsp = perform_authorization_and_return_message(session_id, user_name, user_password, version)

    # verify we receive a 200
    authorize_rsp.code.should == 200
    # find "authorization_result" in the response messsage received, and verify user is authorized
    authorize_result = authorize_rsp.http_body.find_tag("authorization_result").at(0)
    authorize_result.status.content.should == "Authorized"
    # return owner_id (user_id).. this will be used to add products to cart, etc.

    return authorize_result.authenticator_user_id.content
  end

  def perform_authorization_with_open_id(session_id, openid, version)
    $tracer.trace("GameStopAccountServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    authorize_req = self.get_request_from_template_using_global_defaults(:authorize_by_open_id, AccountServiceRequestTemplates.const_get("AUTHORIZE_OPEN_ID#{version}"))
    authorize_data = authorize_req.find_tag("authorize_open_id_request").at(0)
    authorize_data.open_id_claimed_identifier.content = openid
    authorize_data.session_id.content = session_id

    authorize_rsp = self.authorize_by_open_id(authorize_req.xml)
    authorize_rsp.code.should == 200
    $tracer.trace(authorize_rsp.http_body.formatted_xml)
    authorize_result = authorize_rsp.http_body.find_tag("authorization_open_id_result").at(0)
    email_address = authorize_result.email_address.content

    return email_address
  end

  #Request to register a new user.  If the specified user already exists, fail the test.

  def create_new_user(session_id, user_name, user_password, version)
    $tracer.trace("GameStopAccountServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    if user_name == 'register'
      this = [('a'..'z'), ('A'..'Z'), (1..10)].map { |i| i.to_a }.flatten
      idnew = (0...10).map { this[rand(this.length)] }.join

      user_name = "svc_autogen#{idnew}@qagsecomprod.oib.com"
      $tracer.report("#{__method__} : #{user_name}")
    end

    user_password = "T3sting!" if user_password.nil?

    user_password = $global_functions.password_generator(10) if user_password == "generate"

    register_req = self.get_request_from_template_using_global_defaults(:register_account, AccountServiceRequestTemplates.const_get("REGISTER_ACCOUNT#{version}"))

    register_data = register_req.find_tag("register_account_request").at(0)
    register_data.username.content = user_name
    $tracer.trace(user_name)
    $tracer.report("#{__method__} : #{user_name}")
    register_data.password.content = user_password
    $tracer.trace(user_password)
    register_data.session_id.content = session_id
    register_data.user_id.content = generate_guid

    register_rsp = self.register_account(register_req.xml)
    register_rsp.code.should == 200

    register_result = register_rsp.http_body.find_tag("register_account_result").at(0)
    register_result.register_account_status.content.should == "Successful"
    userid_rsp = register_result.user_id.content


    $tracer.trace(register_rsp.http_body.get_received_message)
    $tracer.trace(register_rsp.http_body.formatted_xml)

    return user_name, user_password
  end

  def create_new_user_return_credentials(userid, session_id, user_name, user_password, version)
    $tracer.trace("GameStopAccountServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    credentials = []

    if user_name.nil?
      this = [('a'..'z'), ('A'..'Z'), (1..10)].map { |i| i.to_a }.flatten
      idnew = (0...10).map { this[rand(this.length)] }.join

      user_name = "svc_autogen#{idnew}@qagsecomprod.oib.com"
      $tracer.report("#{__method__} : #{user_name}")
    end

    user_password = "T3sting" if user_password.nil?

    user_password = $global_functions.password_generator(10) if user_password == "generate"


    register_req = self.get_request_from_template_using_global_defaults(:register_account, AccountServiceRequestTemplates.const_get("REGISTER_ACCOUNT#{version}"))

    register_data = register_req.find_tag("register_account_request").at(0)
    register_data.username.content = user_name
    $tracer.trace(user_name)
    $tracer.report("#{__method__} : #{user_name}")
    register_data.password.content = user_password
    $tracer.trace(user_password)
    register_data.session_id.content = session_id
    register_data.user_id.content = userid
    $tracer.trace(register_req.formatted_xml)
    register_rsp = self.register_account(register_req.xml)
    register_rsp.code.should == 200

    register_result = register_rsp.http_body.find_tag("register_account_result").at(0)
    register_result.register_account_status.content.should == "Successful"
    userid_rsp = register_result.user_id.content


    $tracer.trace(register_rsp.http_body.get_received_message)
    $tracer.trace(register_rsp.http_body.formatted_xml)

    credentials.push(user_name, user_password)

    return *credentials
  end

  def verify_operations(account_svc)
    $tracer.trace("GameStopAccountServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace(account_svc)
    account_svc.include?(:authorize).should == true
    account_svc.include?(:authorize_anonymous).should == true
    account_svc.include?(:is_anonymous).should == true
    account_svc.include?(:is_authorized).should == true
    account_svc.include?(:register_account).should == true
    account_svc.include?(:reset_password).should == true
    return true
  end

end


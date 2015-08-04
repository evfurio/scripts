# == Overview
# This module is specific to soap services and contains qa d-con script writer dsl's.
# It is mixed into MultipassService, as a monkey patch, in the dsl.rb file.

module MultipassServiceDSL
  def create_new_user(user_name, user_password, email_address)
    $tracer.trace("MultipassServiceDSL : #{__method__}, Line : #{__LINE__}")

    add_user_req = self.get_request_from_template_using_global_defaults(:add_issued_user, MultipassServiceRequestTemplates.const_get("ADD_ISSUED_USER"))
    add_user_req.find_tag("user_name").content = user_name
    add_user_req.find_tag("password").content = user_password
    add_user_req.find_tag("email_address").content = email_address
    add_user_req.find_tag("email_is_valid").content = 'true'

    #Remove unused elements
    add_user_req.find_tag("client_id").remove_self
    add_user_req.find_tag("user_id").remove_self

    $tracer.trace(add_user_req.formatted_xml)
    add_user_rsp = self.add_issued_user(add_user_req.xml)
    add_user_rsp.code.should == 200

    $tracer.trace(add_user_rsp.http_body.formatted_xml)

    $tracer.report("should #{__method__}")
    return add_user_rsp.http_body.find_tag("open_id_claimed_identifier").content
  end

  def create_id_using_multipass
    $tracer.trace("dm_test_spec : #{__method__}, Line : #{__LINE__}")

    # Generate email and password
    this = [('a'..'z'), ('A'..'Z'), (1..10)].map { |i| i.to_a }.flatten
    idnew = (0...10).map { this[rand(this.length)] }.join
    user_name = "svc_autogen#{idnew}@qagsecomprod.oib.com"
    @global_functions = GlobalFunctions.new()
    user_password = @global_functions.password_generator(10)
    email_address = user_name

    open_id = create_new_user(user_name, user_password, email_address)
    $tracer.trace("Open ID for user #{user_name} is #{open_id}")
    return open_id, user_name, user_password

  end
end
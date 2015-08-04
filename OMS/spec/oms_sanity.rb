# d-Con C:\QAAutomationScripts\OMS\spec\oms_sanity.rb --no_rdb --or

qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']
require "#{qaautomation_scripts_dir}/OMS/dsl/src/dsl"

describe "OMS Create Order Sanity Check" do
  before(:all) do

# Usage - Sterling.new - this will connect, authenticate and login (authorize) to the Sterling OMS API using default parameters
#    :env_prog_id => 'OMS'
#    :env_user_id => 'admin'
#    :login_id => 'admin'
#    :password => 'password'
#    :vendor_file => 'resources/vendor.properties'
#    :yif_httpapi_url => 'https://gv1hqqomsw03.testgs.pvt:8443/smcfs/interop/InteropHttpServlet'
#    :yif_httpapi_userid => 'admin'
#    :yif_httpapi_password => 'password'
# Any of these can be overriden by calling as follows:
# @api = Sterling.new({:prog_id => 'my prog', :user_id => 'my user id', :login_id => 'my logid id', :password => 'my password', :vendor_file => 'path/to/vendor.properties', :yif_httpapi_url => "https://usr/to/sterling/api", :yif_httpapi_userid => 'yif user id', :yif_httpapi_password => 'yif password'})

    @api = Sterling.new
  end

  it "should create,schedule,trigger payment,release and ship an order" do
    $tracer.trace("Create Order")
    # Create order
    request = @api.get_request_from_template(OMSTemplates::CREATE_ORDER_SAMPLE)

    # Set request data here .............. using a complete order for functional test

    $tracer.trace(request.formatted_xml)

    # Create order
    response = @api.create_order(request)
    # Get order header key ann number from response
    order_header_key = response.order.order_header_key.value
    order_num = response.order.order_no.value
    $tracer.trace(response.formatted_xml)

    # Get order details and verify a few items
    request = @api.get_request_from_template(OMSTemplates::ORDER_DETAILS)
    request.order.order_header_key.value = order_header_key
    response = @api.get_order_details(request)

    response.order.order_lines.order_line.item.item_desc.value.should == 'Logitech G930 Wireless Gaming Headset'
    response.order.order_lines.order_line.person_info_ship_to.e_mail_id.value.should == 'svc_qa_auto@qagsecomprod.oib.com'
    response.order.payment_methods.payment_method.credit_card_no.value.should == 'A9654B78D7EF4241'
    response.order.overall_totals.line_sub_total.value.should == '159.99'

    # Schedule order
    request = @api.get_request_from_template(OMSTemplates::SCHEDULE_ORDER)
    request.schedule_order.prime_line_no.value = request.schedule_order.sub_line_no.value = '1'
    request.schedule_order.order_header_key.value = order_header_key
    $tracer.trace(request.formatted_xml)
    response = @api.schedule_order(request)
    $tracer.trace(response.formatted_xml)

    # Trigger payment collection
    request = @api.get_request_from_template(OMSTemplates::MULTI_API)
    request.multi_api.api.name.value = 'triggerAgent'
    request.multi_api.api.input.trigger_agent.criteria_id.value = 'PAYMENT_EXECUTION'
    $tracer.trace(request.formatted_xml)
    response = request.multi_api(request)
    $tracer.trace(response.formatted_xml)

    # Wait until payment has been authorized or timeout
    request = @api.get_request_from_template(OMSTemplates::ORDER_DETAILS)
    request.order.order_header_key.value = order_header_key
    $tracer.trace(request.formatted_xml)
    response = @api.wait_until_condition_met(:get_order_details,request) {|resp_xml|
      $tracer.trace('WAITING FOR AUTHORIZATION')
      resp_xml.order.payment_status.value == 'AUTHORIZED'
    }
    $tracer.trace(response.formatted_xml)

    # Release order
    request = @api.get_request_from_template(OMSTemplates::RELEASE_ORDER)
    #request.release_order.order_no.value = order_info[:order_num]
    request.release_order.order_header_key.value = order_header_key
    $tracer.trace(request.formatted_xml)
    response = @api.release_order(request)
    $tracer.trace(response.formatted_xml)

    # Ship and confirm order via service inf_shipped_update
    request = @api.get_request_from_template(OMSTemplates::INF_SHIPPED_UPDATE)
    request.order_line_status.order_no.value = order_num
    shipment_line = request.find_tag('shipment_line')
    shipment_line.at(0).order_no.value = order_num
    shipment_line.at(1).order_no.value = order_num
    $tracer.trace(request.formatted_xml)
    response = @api.execute_flow(request, 'inf_ShippedUpdate')
    $tracer.trace(response.formatted_xml)

  end
end

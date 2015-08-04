module GameStopDigitalContentServiceDSL

  def perform_get_digital_content_code_and_instructions(create_purchase_cart_items, version)
    $tracer.trace("GameStopDigitalContentServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_digital_code_req = self.get_request_from_template_using_global_defaults(:get_digital_content_code_and_instructions, DigitalContentServiceRequestTemplates.const_get("GET_DIGITAL_CONTENT_CODE_AND_INSTRUCTIONS#{version}"))

    create_purchase_cart_items.each do |item|
      item.line_item.each_with_index do |item|

        get_digital_code_req.find_tag("line_item_id").guid.content = item.line_item_id.content
        get_digital_code_req.find_tag("machine_name").content = "gmqa0001"
        get_digital_code_req.find_tag("country_code").content = "US"

        $tracer.trace(get_digital_code_req.formatted_xml)
        get_code_rsp = self.get_digital_content_code_and_instructions(get_digital_code_req.xml)

        get_code_rsp.code.should == 200
        $tracer.trace(get_code_rsp.http_body.formatted_xml)

        digital_content = get_code_rsp.http_body.find_tag("digital_content_info")

        begin
          code = digital_content.digital_content_code.content
          code.empty?.should == false

        rescue Exception => ex
          $tracer.trace("Code was not generated")
          raise "Digital Code was not generated"
        end

        begin
          instr = get_code_rsp.http_body.find_tag("digital_content_installation_instructions").content
          instr.empty?.should == false
          (instr.include?("TO REDEEM YOUR")).should == false
        rescue Exception => ex
          $tracer.trace("instructions are missing ")
          raise "No Instructions were generated"
        end


      end
    end
  end

  def verify_operations(digitalcontent_svc)
    $tracer.trace("GameStopDigitalContentServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace(digitalcontent_svc)
    digitalcontent_svc.include?(:fulfill_digital_content) == true
    digitalcontent_svc.include?(:get_inventory_availability) == true
    digitalcontent_svc.include?(:get_digital_content_code_and_instructions) == true
  end

end


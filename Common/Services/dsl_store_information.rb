# == Overview
# This module is specific to soap services and contains qa d-con script writer dsl's.
# It is mixed into StoreInformationService, as a monkey patch, in the dsl.rb file.

module GameStopStoreInformationServiceDSL

	def perform_is_service_alive()
		$tracer.trace("GameStopStoreInformationServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    is_service_alive_req = self.get_request_from_template_using_global_defaults(:is_service_alive, StoreInformationServiceRequestTemplates.const_get("IS_SERVICE_ALIVE"))

		$tracer.trace(is_service_alive_req.formatted_xml)
    is_service_alive_rsp = self.is_service_alive(is_service_alive_req.xml)
    is_service_alive_rsp.code.should == 200

    $tracer.trace(is_service_alive_rsp.http_body.formatted_xml)
    return is_service_alive_rsp
	end
		
	def perform_get_store_information(store_id, store_number)
		$tracer.trace("GameStopStoreInformationServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_store_information_req = self.get_request_from_template_using_global_defaults(:get_store_information, StoreInformationServiceRequestTemplates.const_get("GET_STORE_INFORMATION"))

		store_information = get_store_information_req.find_tag("get_store_information").at(0)
		store_information.request.machine_name.content = "roBert"
    store_information.request.country_code.content = "US"
    store_information.request.store_id.content = store_id
    store_information.request.store_number.content = store_number
		
		$tracer.trace(get_store_information_req.formatted_xml)
    get_store_information_rsp = self.get_store_information(get_store_information_req.xml)
    get_store_information_rsp.code.should == 200

    $tracer.trace(get_store_information_rsp.http_body.formatted_xml)
    return get_store_information_rsp
	end
	
	def perform_get_stores_by_zip_code(zip)
    $tracer.trace("GameStopStoreInformationServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    get_stores_by_zip_code_req = self.get_request_from_template_using_global_defaults(:get_stores_by_zip_code, StoreInformationServiceRequestTemplates.const_get("GET_STORES_BY_ZIP_CODE"))

		store_info_data = get_stores_by_zip_code_req.find_tag("get_stores_by_zip_code").at(0)
		store_info_data.request.machine_name.content = "roBert"
    store_info_data.request.radial_distance.unit_of_measure_type.content = "Mile"
    store_info_data.request.radial_distance.value.content = "5"
    store_info_data.request.zip_code.content = zip
		
		$tracer.trace(get_stores_by_zip_code_req.formatted_xml)
    store_info_data_rsp = self.get_stores_by_zip_code(get_stores_by_zip_code_req.xml)
    store_info_data_rsp.code.should == 200

    $tracer.trace(store_info_data_rsp.http_body.formatted_xml)
    return store_info_data_rsp
  end
	
end
# == Overview
# This module is specific to soap services and contains qa d-con script writer dsl's.

module ConfigurationDataServiceDSL

  # Configuration service accepts configuration key(s) and returns the value(s) as seen in Grand Central.
  # This service is read only and does not change any configurations.
  # === Parameters:
  # config_key_list:: List of configuration keys to have their values retrieved
  def get_config_value(config_key_list)
    $tracer.trace("ConfigurationDataServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

    #Defines the service template to use
    get_config_value_request = self.get_request_from_template(ConfigurationDataServiceRequestTemplates::GET_CONFIGURATION_VALUES)
    # Sets request values
    body = get_config_value_request.envelope.body.get_configuration_values_request
    # Clones the Key element based on the number of keys provided
      (0...(config_key_list.length - 1)).each do
        body.keys.string.clone_as_sibling
      end

    # Sets each of the cloned attribute with key value(s) being requested
    body.keys.string.each_with_index do |config_key_element, i|
      config_key_element.content = config_key_list[i]
      $tracer.trace("Config Key Value Request: #{config_key_element.content}")
    end

    # Formats the request in xml format
    $tracer.trace(get_config_value_request.formatted_xml)

    # Returns response from submitted request
    get_config_value_response = self.get_configuration_values(get_config_value_request.xml)
    # Validates response code is successful
    $tracer.trace("Response: " + get_config_value_response.code.to_s)
    get_config_value_response.code.should == 200
    $tracer.trace(get_config_value_response.http_body.formatted_xml)

    # Puts returned config key value(s) into an array
    config_value_list = []
    get_config_value_response.http_body.find_tag("value").each do |string_element|
      config_value_list << string_element.content
    end

    $tracer.trace("Config value: #{config_value_list}")

    return config_value_list
  end
end
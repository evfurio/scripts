# == Overview
# This module is specific to soap services and contains qa d-con script writer dsl's.
# It is mixed into SoapServices, as a monkey patch, in the dsl.rb file.

module GameStopSoapServicesDSL

    # Returns the request dot object generated from a user specified soap
    # template, using global service defaults
    # === Parameters:
    # _operation_:: user specified soap operation
    # _operation_template:: template pertaining to soap operation, default to nil -- which
    #                       will cause a "lookup" of an already defined template.  NOTE: the
    #                       default template must match the operation name, but upcase.
    def get_request_from_template_using_global_defaults(operation, operation_template = nil)
        # if an operation template has not been provided as a parameter, retrieve the existing
        # template.  NOTE: this matches the operation in name, but uppercase.  An exception
        # will be raised if one could not be located.
        if operation_template.nil?

            operation_template = Module.const_get("#{self.class.name}RequestTemplates").const_get(operation.to_s.upcase)

        end

        request = get_request_from_template(operation_template)

        # NOTE: this is retrieved directly from the wsdl (<wsa:To>)
        to_data = request.envelope.header.find_tag("to")
        to_data.at(0).content = @client.end_point_uri.full_url unless to_data.empty?

        # NOTE: this is retrieved directly from the wsdl (<wsa:Action>)
        action_data = request.envelope.header.find_tag("action")
				
        action_data.at(0).content = @client.get_service_operation_uri(operation.to_s) unless action_data.empty?

        client_channel_data = request.find_tag("client_channel")
        client_channel_data.at(0).content = "GS_US" unless client_channel_data.empty?

        locale_data = request.find_tag("locale")
        locale_data.at(0).content = "en-US" unless locale_data.empty?

        return request
    end
end

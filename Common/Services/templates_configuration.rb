module ConfigurationDataServiceRequestTemplates

GET_CONFIGURATION_VALUES = <<eos
<soap:Envelope xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://gamestop.com/configuration/data/v1">
 <soap:Body>
    <v1:GetConfigurationValuesRequest>
      <v1:ClientChannel>?</v1:ClientChannel>
      <v1:Keys>
        <arr:string>?</arr:string>
      </v1:Keys>
    </v1:GetConfigurationValuesRequest>
  </soap:Body>
</soap:Envelope>
eos

end


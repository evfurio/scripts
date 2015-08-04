module StoreSearchServiceRequestTemplates

FIND_STORES_IN_RANGE = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/stores/search/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
      <v1:SessionID>?</v1:SessionID>
      <v1:ClientChannel>?</v1:ClientChannel>
	  <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
	  <wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:FindStoresInRangeRequest>
         <!--Optional:-->
         <v1:Address>?</v1:Address>
         <!--Optional:-->
         <v1:CountryCode>?</v1:CountryCode>
         <!--Optional:-->
         <v1:RadiusInKilometers>?</v1:RadiusInKilometers>
      </v1:FindStoresInRangeRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_ASSEMBLY_INFO = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/stores/search/v1">
		<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:Action soap:mustUnderstand="1">http://gamestop.com/stores/search/v1/GetAssemblyInfo</wsa:Action>
			<wsa:To soap:mustUnderstand="1">?</wsa:To>
		</soap:Header>
		<soap:Body>
			<v1:GetAssemblyInfo/>
		</soap:Body>
	</soap:Envelope>
eos

end

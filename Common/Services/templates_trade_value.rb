module TradeValueServiceRequestTemplates

SEARCH_DEVICE = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/merchandising/TradeValue/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/merchandising/TradeValue/v1/SearchDevice</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:SearchDeviceRequest>
         <v1:ClientChannel>?</v1:ClientChannel>
		 <v1:Concept>?</v1:Concept>
         <v1:KeyWord>?</v1:KeyWord>
         <v1:Locale>?</v1:Locale>
		 <v1:SessionID>?</v1:SessionID>
      </v1:SearchDeviceRequest>
   </soap:Body>
</soap:Envelope>
eos
GET_ASSEMBLY_INFO = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/merchandising/TradeValue/v1">
	<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/merchandising/TradeValue/v1/GetAssemblyInfo</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
	</soap:Header>
	<soap:Body>
		<v1:GetAssemblyInfo/>
	</soap:Body>
</soap:Envelope>
eos
end

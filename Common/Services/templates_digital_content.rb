module DigitalContentServiceRequestTemplates

FULFILL_DIGITAL_CONTENT = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/fulfillment/digitalcontent/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:FulfillDigitalContentRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:CountryCode>?</v1:CountryCode>
         <!--Optional:-->
         <v1:LineItemId>?</v1:LineItemId>
         <!--Optional:-->
         <v1:SKU>?</v1:SKU>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
         <!--Optional:-->
         <v1:TransactionId>?</v1:TransactionId>
      </v1:FulfillDigitalContentRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_DIGITAL_CONTENT_CODE_AND_INSTRUCTIONS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/fulfillment/digitalcontent/v1" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:GetDigitalContentCodeAndInstructionsRequest>
         <!--Optional:-->
         <v1:CountryCode>?</v1:CountryCode>
         <!--Optional:-->
         <v1:LineItemId>
            <!--Zero or more repetitions:-->
            <arr:guid>?</arr:guid>
         </v1:LineItemId>
         <!--Optional:-->
         <v1:MachineName>?</v1:MachineName>
      </v1:GetDigitalContentCodeAndInstructionsRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_ASSEMBLY_INFO = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/fulfillment/digitalcontent/v1">
		<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:Action soap:mustUnderstand="1">http://gamestop.com/orders/fulfillment/digitalcontent/v1/GetAssemblyInfo</wsa:Action>
			<wsa:To soap:mustUnderstand="1">?</wsa:To>
		</soap:Header>
		<soap:Body>
			<v1:GetAssemblyInfo/>
		</soap:Body>
	</soap:Envelope>
eos

end

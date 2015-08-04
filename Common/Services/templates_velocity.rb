module VelocityServiceRequestTemplates

PRODUCT_VELOCITY_CHECK = <<eos 
   <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/history/velocity/v1" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <v1:SessionID>?</v1:SessionID>
        <v1:ClientChannel>?</v1:ClientChannel>
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
   <soap:Body>
      <v1:ProductVelocityCheckRequest>
         <v1:Billing_Address>
            <v1:AddressID>?</v1:AddressID>
            <v1:City>?</v1:City>
            <v1:CountryCode>?</v1:CountryCode>
            <v1:County>?</v1:County>
            <v1:Line1>?</v1:Line1>
            <v1:Line2>?</v1:Line2>
            <v1:PostalCode>?</v1:PostalCode>
            <v1:State>?</v1:State>
         </v1:Billing_Address>
         <v1:Email>?</v1:Email>
         <v1:Locale>?</v1:Locale>
         <v1:ProductVelocityDays>?</v1:ProductVelocityDays>
         <v1:ProfileID>?</v1:ProfileID>
         <v1:SKU>
            <arr:string>?</arr:string>
         </v1:SKU>
         <v1:Shipping_Address>
            <v1:AddressID>?</v1:AddressID>
            <v1:City>?</v1:City>
            <v1:CountryCode>?</v1:CountryCode>
            <v1:County>?</v1:County>
            <v1:Line1>?</v1:Line1>
            <v1:Line2>?</v1:Line2>
            <v1:PostalCode>?</v1:PostalCode>
            <v1:State>?</v1:State>
         </v1:Shipping_Address>
      </v1:ProductVelocityCheckRequest>
   </soap:Body>
</soap:Envelope>
eos


GET_ASSEMBLY_INFO = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/history/velocity/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
   <wsa:Action>http://gamestop.com/orders/history/velocity/v1/GetAssemblyInfo</wsa:Action>
   <wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:GetAssemblyInfo/>
   </soap:Body>
</soap:Envelope>
eos
end
module DigitalWalletServiceRequestTemplates

DELETE_DIGITAL_WALLET_PAYMENT_METHODS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/digitalwallet/v1" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
   <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
   <wsa:To soap:mustUnderstand="1">?</wsa:To>   
   </soap:Header>
   <soap:Body>
      <v1:DeleteDigitalWalletPaymentMethodsRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:OpenIDClaimedIdentifier>?</v1:OpenIDClaimedIdentifier>
         <!--Optional:-->
         <v1:PaymentMethodTokens>
            <!--Zero or more repetitions:-->
            <arr:string>?</arr:string>
         </v1:PaymentMethodTokens>
      </v1:DeleteDigitalWalletPaymentMethodsRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_DIGITAL_WALLETS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/digitalwallet/v1" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
   <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
   <wsa:To soap:mustUnderstand="1">?</wsa:To>   
   </soap:Header>
   <soap:Body>
      <v1:GetDigitalWalletsRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:OpenIDClaimedIdentifiers>
            <!--Zero or more repetitions:-->
            <arr:string>?</arr:string>
         </v1:OpenIDClaimedIdentifiers>
      </v1:GetDigitalWalletsRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_ASSEMBLY_INFO = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/digitalwallet/v1">
	<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
	<wsa:Action soap:mustUnderstand="1">http://gamestop.com/digitalwallet/v1/GetAssemblyInfo</wsa:Action>
	<wsa:To soap:mustUnderstand="1">?</wsa:To>
	</soap:Header>
	<soap:Body>
	<v1:GetAssemblyInfo/>
	</soap:Body>
	</soap:Envelope>
eos
end

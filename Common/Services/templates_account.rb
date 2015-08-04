module AccountServiceRequestTemplates

AUTHORIZE = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/account/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:AuthorizeRequest>
            <v1:ClientChannel>?</v1:ClientChannel>
            <v1:Password>?</v1:Password>
            <v1:SessionID>?</v1:SessionID>
            <v1:Username>?</v1:Username>
        </v1:AuthorizeRequest>
    </soap:Body>
</soap:Envelope>
eos

AUTHORIZE_ANONYMOUS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/account/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:AuthorizeAnonymousRequest>
            <v1:ClientAnonymousUserID>?</v1:ClientAnonymousUserID>
            <v1:ClientChannel>?</v1:ClientChannel>
            <v1:SessionID>?</v1:SessionID>
        </v1:AuthorizeAnonymousRequest>
    </soap:Body>
</soap:Envelope>
eos

AUTHORIZE_OPEN_ID = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/account/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:AuthorizeOpenIdRequest>
         <v1:ClientChannel>?</v1:ClientChannel>
         <v1:OpenIdClaimedIdentifier>?</v1:OpenIdClaimedIdentifier>
         <v1:SessionID>?</v1:SessionID>
      </v1:AuthorizeOpenIdRequest>
   </soap:Body>
</soap:Envelope>
eos

IS_ANONYMOUS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/account/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
		</soap:Header>
   <soap:Body>
      <v1:IsAnonymousRequest>
         <!--Optional:-->
         <v1:AuthorizationToken>?</v1:AuthorizationToken>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
      </v1:IsAnonymousRequest>
   </soap:Body>
</soap:Envelope>
eos

IS_AUTHORIZED = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/account/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
   <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
   <wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:IsAuthorizedRequest>
         <!--Optional:-->
         <v1:AuthorizationToken>?</v1:AuthorizationToken>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
      </v1:IsAuthorizedRequest>
   </soap:Body>
</soap:Envelope>
eos

REGISTER_ACCOUNT = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/account/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
   <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
   <wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:RegisterAccountRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:Password>?</v1:Password>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
         <!--Optional:-->
         <v1:UserID>?</v1:UserID>
         <!--Optional:-->
         <v1:Username>?</v1:Username>
      </v1:RegisterAccountRequest>
   </soap:Body>
</soap:Envelope>
eos

RESET_PASSWORD = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/account/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
   <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
   <wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:ResetPasswordRequest>
         <!--Optional:-->
         <v1:Brand>?</v1:Brand>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:Locale>?</v1:Locale>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
         <!--Optional:-->
         <v1:Username>?</v1:Username>
      </v1:ResetPasswordRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_ASSEMBLY_INFO = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/account/v1">
	<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
	<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
	<wsa:To soap:mustUnderstand="1">?</wsa:To>
	</soap:Header>
	<soap:Body>
		<v1:GetAssemblyInfo/>
	</soap:Body>
	</soap:Envelope>
eos

end

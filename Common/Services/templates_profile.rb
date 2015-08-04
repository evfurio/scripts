module ProfileServiceRequestTemplates

GET_ADDRESS_BY_USER_ID = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/GetAddressesByUserID</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:GetAddressesRequest>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:SessionID>?</v1:SessionID>
			 <v1:UserID>?</v1:UserID>
		  </v1:GetAddressesRequest>
	   </soap:Body>
	</soap:Envelope>
eos

GET_ASSEMBLY_INFO = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/account/v1/GetAssemblyInfo</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To></soap:Header>
	   <soap:Body>
		  <v1:GetAssemblyInfo/>
	   </soap:Body>
	</soap:Envelope>
eos

GET_LOYALTY_NUMBER_PUR = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/GetLoyaltyNumber</wsa:Action>
   <wsa:To soap:mustUnderstand="1">?</wsa:To></soap:Header>
   <soap:Body>
      <v1:GetLoyaltyNumberRequest>
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--type: LoyaltyCardType - enumeration: [EdgeCard,PowerUpCard]-->
         <v1:LoyaltyCardType>PowerUpCard</v1:LoyaltyCardType>
         <v1:SessionID>?</v1:SessionID>
         <v1:UserID>?</v1:UserID>
      </v1:GetLoyaltyNumberRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_LOYALTY_NUMBER_EDGE = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/GetLoyaltyNumber</wsa:Action>
   <wsa:To soap:mustUnderstand="1">?</wsa:To></soap:Header>
   <soap:Body>
      <v1:GetLoyaltyNumberRequest>
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--type: LoyaltyCardType - enumeration: [EdgeCard,PowerUpCard]-->
         <v1:LoyaltyCardType>EdgeCard</v1:LoyaltyCardType>
         <v1:SessionID>?</v1:SessionID>
         <v1:UserID>?</v1:UserID>
      </v1:GetLoyaltyNumberRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_PAYMENT_METHODS_CREDIT_CARD = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/GetPaymentMethods</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:GetPaymentMethodsRequest>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:Locale>?</v1:Locale>
			 <!--type: PaymentMethodType - enumeration: [CreditCard,GiftCard,Other]-->
			 <v1:PaymentMethodType>CreditCard</v1:PaymentMethodType><v1:SessionID>?</v1:SessionID>
		  </v1:GetPaymentMethodsRequest>
	   </soap:Body>
	</soap:Envelope>
eos

GET_PAYMENT_METHODS_GIFT_CARD = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/GetPaymentMethods</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:GetPaymentMethodsRequest>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:Locale>?</v1:Locale>
			 <!--type: PaymentMethodType - enumeration: [CreditCard,GiftCard,Other]-->
			 <v1:PaymentMethodType>GiftCard</v1:PaymentMethodType><v1:SessionID>?</v1:SessionID>
		  </v1:GetPaymentMethodsRequest>
	   </soap:Body>
	</soap:Envelope>
eos

GET_PAYMENT_METHODS_OTHER = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/GetPaymentMethods</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:GetPaymentMethodsRequest>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:Locale>?</v1:Locale>
			 <!--type: PaymentMethodType - enumeration: [CreditCard,GiftCard,Other]-->
			 <v1:PaymentMethodType>Other</v1:PaymentMethodType><v1:SessionID>?</v1:SessionID>
		  </v1:GetPaymentMethodsRequest>
	   </soap:Body>
	</soap:Envelope>
eos

GET_USER_CREDIT_CARDS = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/GetUserCreditCards</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:GetUserCreditCardsRequest>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:SessionID>?</v1:SessionID>
			 <v1:UserID>?</v1:UserID>
		  </v1:GetUserCreditCardsRequest>
	   </soap:Body>
	</soap:Envelope>
eos

GET_USER_PROFILE = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/GetUserProfile</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:GetUserProfileRequest>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:SessionID>?</v1:SessionID>
			 <v1:UserID>?</v1:UserID>
		  </v1:GetUserProfileRequest>
	   </soap:Body>
	</soap:Envelope>
eos

SAVE_ADDRESSES_SHIPPING_ADDRESS = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/SaveAddresses</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:SaveAddressesRequest>
			 <v1:Addresses>
				<v1:Address>
				   <v1:AddressName>?</v1:AddressName>
				   <!--type: AddressType - enumeration: [ShippingAddress,BillingAddress,StoreAddress,EmailAddress,Other]-->
				   <v1:AddressType>ShippingAddress</v1:AddressType>
				   <v1:City>?</v1:City>
				   <v1:CountryCode>?</v1:CountryCode>
				   <v1:CountryName>?</v1:CountryName>
				   <v1:Email>?</v1:Email>
				   <v1:FirstName>?</v1:FirstName>
				   <v1:FormatValidated>?</v1:FormatValidated>
				   <v1:HasExtendedZip>?</v1:HasExtendedZip>
				   <v1:ID>?</v1:ID>
				   <v1:LastName>?</v1:LastName>
				   <v1:Line1>?</v1:Line1>
				   <v1:Line2>?</v1:Line2>
				   <v1:PhoneNumber>
					  <v1:CountryCode>?</v1:CountryCode>
					  <v1:Extension>?</v1:Extension>
					  <v1:ID>?</v1:ID>
					  <v1:Phone>?</v1:Phone>
					  <!--type: PhoneNumberType - enumeration: [HomePhone,WorkPhone,MobilePhone,Other]-->
					  <v1:PhoneNumberType>?</v1:PhoneNumberType>
				   </v1:PhoneNumber>
				   <v1:State>?</v1:State>
				   <v1:StoreNumber>?</v1:StoreNumber>
				   <v1:Zip>?</v1:Zip>
				   <v1:isDefaultShippingAddress>?</v1:isDefaultShippingAddress>
				</v1:Address>
			 </v1:Addresses>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:SessionID>?</v1:SessionID>
			 <v1:UserID>?</v1:UserID>
		  </v1:SaveAddressesRequest>
	   </soap:Body>
	</soap:Envelope>
eos

SAVE_ADDRESSES_BILLING_ADDRESS = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/SaveAddresses</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:SaveAddressesRequest>
			 <v1:Addresses>
				<v1:Address>
				   <v1:AddressName>?</v1:AddressName>
				   <!--type: AddressType - enumeration: [ShippingAddress,BillingAddress,StoreAddress,EmailAddress,Other]-->
				   <v1:AddressType>BillingAddress</v1:AddressType>
				   <v1:City>?</v1:City>
				   <v1:CountryCode>?</v1:CountryCode>
				   <v1:CountryName>?</v1:CountryName>
				   <v1:Email>?</v1:Email>
				   <v1:FirstName>?</v1:FirstName>
				   <v1:FormatValidated>?</v1:FormatValidated>
				   <v1:HasExtendedZip>?</v1:HasExtendedZip>
				   <v1:ID>?</v1:ID>
				   <v1:LastName>?</v1:LastName>
				   <v1:Line1>?</v1:Line1>
				   <v1:Line2>?</v1:Line2>
				   <v1:PhoneNumber>
					  <v1:CountryCode>?</v1:CountryCode>
					  <v1:Extension>?</v1:Extension>
					  <v1:ID>?</v1:ID>
					  <v1:Phone>?</v1:Phone>
					  <!--type: PhoneNumberType - enumeration: [HomePhone,WorkPhone,MobilePhone,Other]-->
					  <v1:PhoneNumberType>?</v1:PhoneNumberType>
				   </v1:PhoneNumber>
				   <v1:State>?</v1:State>
				   <v1:StoreNumber>?</v1:StoreNumber>
				   <v1:Zip>?</v1:Zip>
				   <v1:isDefaultShippingAddress>?</v1:isDefaultShippingAddress>
				</v1:Address>
			 </v1:Addresses>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:SessionID>?</v1:SessionID>
			 <v1:UserID>?</v1:UserID>
		  </v1:SaveAddressesRequest>
	   </soap:Body>
	</soap:Envelope>
eos

SAVE_ADDRESSES_STORE_ADDRESS = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/SaveAddresses</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:SaveAddressesRequest>
			 <v1:Addresses>
				<v1:Address>
				   <v1:AddressName>?</v1:AddressName>
				   <!--type: AddressType - enumeration: [ShippingAddress,BillingAddress,StoreAddress,EmailAddress,Other]-->
				   <v1:AddressType>StoreAddress</v1:AddressType>
				   <v1:City>?</v1:City>
				   <v1:CountryCode>?</v1:CountryCode>
				   <v1:CountryName>?</v1:CountryName>
				   <v1:Email>?</v1:Email>
				   <v1:FirstName>?</v1:FirstName>
				   <v1:FormatValidated>?</v1:FormatValidated>
				   <v1:HasExtendedZip>?</v1:HasExtendedZip>
				   <v1:ID>?</v1:ID>
				   <v1:LastName>?</v1:LastName>
				   <v1:Line1>?</v1:Line1>
				   <v1:Line2>?</v1:Line2>
				   <v1:PhoneNumber>
					  <v1:CountryCode>?</v1:CountryCode>
					  <v1:Extension>?</v1:Extension>
					  <v1:ID>?</v1:ID>
					  <v1:Phone>?</v1:Phone>
					  <!--type: PhoneNumberType - enumeration: [HomePhone,WorkPhone,MobilePhone,Other]-->
					  <v1:PhoneNumberType>?</v1:PhoneNumberType>
				   </v1:PhoneNumber>
				   <v1:State>?</v1:State>
				   <v1:StoreNumber>?</v1:StoreNumber>
				   <v1:Zip>?</v1:Zip>
				   <v1:isDefaultShippingAddress>?</v1:isDefaultShippingAddress>
				</v1:Address>
			 </v1:Addresses>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:SessionID>?</v1:SessionID>
			 <v1:UserID>?</v1:UserID>
		  </v1:SaveAddressesRequest>
	   </soap:Body>
	</soap:Envelope>
eos

SAVE_ADDRESSES_EMAIL_ADDRESS = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/SaveAddresses</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:SaveAddressesRequest>
			 <v1:Addresses>
				<v1:Address>
				   <v1:AddressName>?</v1:AddressName>
				   <!--type: AddressType - enumeration: [ShippingAddress,BillingAddress,StoreAddress,EmailAddress,Other]-->
				   <v1:AddressType>EmailAddress</v1:AddressType>
				   <v1:City>?</v1:City>
				   <v1:CountryCode>?</v1:CountryCode>
				   <v1:CountryName>?</v1:CountryName>
				   <v1:Email>?</v1:Email>
				   <v1:FirstName>?</v1:FirstName>
				   <v1:FormatValidated>?</v1:FormatValidated>
				   <v1:HasExtendedZip>?</v1:HasExtendedZip>
				   <v1:ID>?</v1:ID>
				   <v1:LastName>?</v1:LastName>
				   <v1:Line1>?</v1:Line1>
				   <v1:Line2>?</v1:Line2>
				   <v1:PhoneNumber>
					  <v1:CountryCode>?</v1:CountryCode>
					  <v1:Extension>?</v1:Extension>
					  <v1:ID>?</v1:ID>
					  <v1:Phone>?</v1:Phone>
					  <!--type: PhoneNumberType - enumeration: [HomePhone,WorkPhone,MobilePhone,Other]-->
					  <v1:PhoneNumberType>?</v1:PhoneNumberType>
				   </v1:PhoneNumber>
				   <v1:State>?</v1:State>
				   <v1:StoreNumber>?</v1:StoreNumber>
				   <v1:Zip>?</v1:Zip>
				   <v1:isDefaultShippingAddress>?</v1:isDefaultShippingAddress>
				</v1:Address>
			 </v1:Addresses>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:SessionID>?</v1:SessionID>
			 <v1:UserID>?</v1:UserID>
		  </v1:SaveAddressesRequest>
	   </soap:Body>
	</soap:Envelope>
eos

SAVE_ADDRESSES_OTHER_ADDRESS = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/SaveAddresses</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:SaveAddressesRequest>
			 <v1:Addresses>
				<v1:Address>
				   <v1:AddressName>?</v1:AddressName>
				   <!--type: AddressType - enumeration: [ShippingAddress,BillingAddress,StoreAddress,EmailAddress,Other]-->
				   <v1:AddressType>Other</v1:AddressType>
				   <v1:City>?</v1:City>
				   <v1:CountryCode>?</v1:CountryCode>
				   <v1:CountryName>?</v1:CountryName>
				   <v1:Email>?</v1:Email>
				   <v1:FirstName>?</v1:FirstName>
				   <v1:FormatValidated>?</v1:FormatValidated>
				   <v1:HasExtendedZip>?</v1:HasExtendedZip>
				   <v1:ID>?</v1:ID>
				   <v1:LastName>?</v1:LastName>
				   <v1:Line1>?</v1:Line1>
				   <v1:Line2>?</v1:Line2>
				   <v1:PhoneNumber>
					  <v1:CountryCode>?</v1:CountryCode>
					  <v1:Extension>?</v1:Extension>
					  <v1:ID>?</v1:ID>
					  <v1:Phone>?</v1:Phone>
					  <!--type: PhoneNumberType - enumeration: [HomePhone,WorkPhone,MobilePhone,Other]-->
					  <v1:PhoneNumberType>?</v1:PhoneNumberType>
				   </v1:PhoneNumber>
				   <v1:State>?</v1:State>
				   <v1:StoreNumber>?</v1:StoreNumber>
				   <v1:Zip>?</v1:Zip>
				   <v1:isDefaultShippingAddress>?</v1:isDefaultShippingAddress>
				</v1:Address>
			 </v1:Addresses>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:SessionID>?</v1:SessionID>
			 <v1:UserID>?</v1:UserID>
		  </v1:SaveAddressesRequest>
	   </soap:Body>
	</soap:Envelope>
eos

SAVE_LOYALTY_NUMBER_PUR = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/SaveLoyaltyNumber</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:SaveLoyaltyNumberRequest>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:LoyaltyCard>
				<v1:CardNumber>?</v1:CardNumber>
				<!--type: LoyaltyCardType - enumeration: [EdgeCard,PowerUpCard]-->
				<v1:CardType>PowerUpCard</v1:CardType>
			 </v1:LoyaltyCard>
			 <v1:SessionID>?</v1:SessionID>
			 <v1:UserID>?</v1:UserID>
		  </v1:SaveLoyaltyNumberRequest>
	   </soap:Body>
	</soap:Envelope>
eos

SAVE_LOYALTY_NUMBER_EDGE = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/SaveLoyaltyNumber</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:SaveLoyaltyNumberRequest>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:LoyaltyCard>
				<v1:CardNumber>?</v1:CardNumber>
				<!--type: LoyaltyCardType - enumeration: [EdgeCard,PowerUpCard]-->
				<v1:CardType>EdgeCard</v1:CardType>
			 </v1:LoyaltyCard>
			 <v1:SessionID>?</v1:SessionID>
			 <v1:UserID>?</v1:UserID>
		  </v1:SaveLoyaltyNumberRequest>
	   </soap:Body>
	</soap:Envelope>
eos

SAVE_USER_CREDIT_CARDS = <<eos
	<!-- THIS IS DONE THROUGH THE DIGITAL WALLET SERVICE -->
eos

SUBSCRIBE_TO_MAILING_LIST = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/customers/profile/v1">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/customers/profile/v1/SubscribeToMailingList</wsa:Action>
	   <wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
	   <soap:Body>
		  <v1:SubscribeToMailingListRequest>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:EmailAddress>?</v1:EmailAddress>
			 <v1:Locale>?</v1:Locale>
			 <v1:SessionID>?</v1:SessionID>
		  </v1:SubscribeToMailingListRequest>
	   </soap:Body>
	</soap:Envelope>
eos

end
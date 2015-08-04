module PaymentServiceRequestTemplates

SAVE_PAYMENT_METHODS_TO_WALLET_V2 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v2/payment">
	   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
	   <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
       <wsa:To soap:mustUnderstand="1">?</wsa:To>  
	   </soap:Header>
	   <soap:Body>
		  <pay:SavePaymentMethodsToWalletRequest>
			 <pay:ClientChannel>?</pay:ClientChannel>
			 <pay:CreditCard>
				<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
				<pay:CreditCardNumber>?</pay:CreditCardNumber>
				<pay:ExpirationMonth>?</pay:ExpirationMonth>
				<pay:ExpirationYear>?</pay:ExpirationYear>
				<pay:NameOnCard>?</pay:NameOnCard>
				<pay:Type>?</pay:Type>
			 </pay:CreditCard>
			 <pay:OpenIDClaimedIdentifier>?</pay:OpenIDClaimedIdentifier>
			 <pay:PayPalAccount>
				<pay:AgreementNumber>?</pay:AgreementNumber>
				<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
			 </pay:PayPalAccount>
		  </pay:SavePaymentMethodsToWalletRequest>
	   </soap:Body>
	</soap:Envelope>
eos

SAVE_PAYMENT_METHODS_WITH_CREDIT_CARD_V2 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v2/payment">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>  
   </soap:Header>
	<soap:Body>
		<pay:SavePaymentMethodsRequest>
			<pay:ClientChannel>?</pay:ClientChannel>
			<pay:CreditCard>
				<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
				<pay:CreditCardNumber>?</pay:CreditCardNumber>
				<pay:ExpirationMonth>?</pay:ExpirationMonth>
				<pay:ExpirationYear>?</pay:ExpirationYear>
				<pay:NameOnCard>?</pay:NameOnCard>
				<!--type: CreditCardType - enumeration: [Visa,MasterCard,AmericanExpress,Discover,JCB,Diners]-->
				<pay:Type>?</pay:Type>
			</pay:CreditCard>
			<!--Optional:-->
			<pay:GiftCards>
				<pay:GiftCard>
					<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
					<pay:StoredValueCardNumber>?</pay:StoredValueCardNumber>
				</pay:GiftCard>
			</pay:GiftCards>
			<pay:PayPalAccount>
				<pay:AgreementNumber>?</pay:AgreementNumber>
				<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
			</pay:PayPalAccount>
		</pay:SavePaymentMethodsRequest>
	</soap:Body>
</soap:Envelope>
eos

SAVE_PAYMENT_METHODS_WITH_GIFT_CARD_V2 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v2/payment">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>  
   </soap:Header>
   <soap:Body>
      <pay:SavePaymentMethodsRequest>
         <!--Optional:-->
         <pay:ClientChannel>?</pay:ClientChannel>
         <!--Optional:-->
         <pay:PaymentMethods>
            <!--Zero or more repetitions:-->
            <pay:PaymentMethod xsi:type="pay:StoredValueCard" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<!--Optional:-->
			<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
			<!--Optional:-->
			<pay:StoredValueCardNumber>?</pay:StoredValueCardNumber>
			</pay:PaymentMethod>
         </pay:PaymentMethods>
      </pay:SavePaymentMethodsRequest>
   </soap:Body>
</soap:Envelope>
eos

AUTHORIZE_PAYMENT_AND_CHECK_FRAUD_V2 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v2/payment">
	<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>  
	</soap:Header>
	<soap:Body>
		<pay:AuthorizationPaymentAndCheckFraudRequest>
			<pay:ClientChannel>?</pay:ClientChannel>
			<!--Optional:-->
			<pay:FraudCheckInformation>
				<!--Optional:-->
				<pay:Identification>
					<!--Optional:-->
					<pay:BrowserCookie>?</pay:BrowserCookie>
					<!--Optional:-->
					<pay:ClientIP>?</pay:ClientIP>
					<!--Optional:-->
					<pay:DeviceFingerprint>?</pay:DeviceFingerprint>
					<!--Optional:-->
					<pay:IsRegisteredUser>?</pay:IsRegisteredUser>
					<!--Optional:-->
		
					<!--Optional:-->
					<pay:UserProfile>
						<!--Optional:-->
						<pay:AccountId>?</pay:AccountId>
						<!--Optional:-->
						<pay:CustomerId>?</pay:CustomerId>
						<!--Optional:-->
						<pay:EmailAddress>?</pay:EmailAddress>
						<!--Optional:-->
						<pay:FailedTransactionsWindowBeginTime>?</pay:FailedTransactionsWindowBeginTime>
						<!--Optional:-->
						<pay:FailedTransactionsWindowEndTime>?</pay:FailedTransactionsWindowEndTime>
						<!--Optional:-->
						<pay:FirstName>?</pay:FirstName>
						<!--Optional:-->
						<pay:FirstPurchaseDate>?</pay:FirstPurchaseDate>
						<!--Optional:-->
						<pay:HashedPassword>?</pay:HashedPassword>
						<!--Optional:-->
						<pay:LastAddressChangedDate>?</pay:LastAddressChangedDate>
						<!--Optional:-->
						<pay:LastLoginDate>?</pay:LastLoginDate>
						<!--Optional:-->
						<pay:LastName>?</pay:LastName>
						<!--Optional:-->
						<pay:LastPurchaseDate>?</pay:LastPurchaseDate>
						<!--Optional:-->
						<pay:LifetimePurchaseAmount>?</pay:LifetimePurchaseAmount>
						<!--Optional:-->
						<pay:LoyaltyNumber>?</pay:LoyaltyNumber>
						<!--Optional:-->
						<pay:LoyaltyRegistrationDate>?</pay:LoyaltyRegistrationDate>
						<!--Optional:-->
						<pay:MiddleName>?</pay:MiddleName>
						<!--Optional:-->
						<pay:RegisteredDate>?</pay:RegisteredDate>
						<!--Optional:-->
						<pay:RegisteredIPAddress>?</pay:RegisteredIPAddress>
						<!--Optional:-->
						<pay:TotalNumberSuccessfulTransactions>?</pay:TotalNumberSuccessfulTransactions>
					</pay:UserProfile>
				</pay:Identification>
				<!--Optional:-->
				<pay:Transaction>
					<!--Optional:-->
					<pay:AffiliateCode>?</pay:AffiliateCode>
					<!--Optional:-->
					<pay:Currency>?</pay:Currency>
					<pay:OrderStatus>?</pay:OrderStatus>
					
					<pay:Shipments>
						<!--Zero or more repetitions:-->
						<pay:Shipment>
							<!--Optional:-->
							<pay:FulfillmentChannel>?</pay:FulfillmentChannel>
							<!--Optional:-->
							<pay:IsGift>?</pay:IsGift>
							<!--Optional:-->
														
							<!--Optional:-->
							<pay:ShipmentId>?</pay:ShipmentId>
							<!--Optional:-->
							<pay:ShippingCost>?</pay:ShippingCost>
							<!--Optional:-->
							<pay:ShippingEmailAddress>?</pay:ShippingEmailAddress>
							<!--Optional:-->
							<pay:ShippingMethod>?</pay:ShippingMethod>
							<!--Optional:-->
							<pay:ShippingTax>?</pay:ShippingTax>
							<!--Optional:-->
							<pay:Tax>?</pay:Tax>
						</pay:Shipment>
					</pay:Shipments>
					<!--Optional:-->
					<pay:ShippingAmount>?</pay:ShippingAmount>
					<!--Optional:-->
					<pay:TaxAmount>?</pay:TaxAmount>
					<!--Optional:-->
					<pay:TotalAmount>?</pay:TotalAmount>
					<!--Optional:-->
					<pay:TransactionDate>?</pay:TransactionDate>
					<!--Optional:-->
					<pay:TransactionId>?</pay:TransactionId>
				</pay:Transaction>
			</pay:FraudCheckInformation>
			<!--Optional:-->
			<pay:Payment>
				<!--Optional:-->
				<pay:Amount>?</pay:Amount>
				<!--Optional:-->
				<pay:BillingAddress>
					<!--Optional:-->
					<pay:City>?</pay:City>
					<!--Optional:-->
					<pay:CountryCode>?</pay:CountryCode>
					<!--Optional:-->
					<pay:Line1>?</pay:Line1>
					<!--Optional:-->
					<pay:Line2>?</pay:Line2>
					<!--Optional:-->
					<pay:PhoneNumber>?</pay:PhoneNumber>
					<!--Optional:-->
					<pay:PostalCode>?</pay:PostalCode>
					<!--Optional:-->
					<pay:State>?</pay:State>
					<!--Optional:-->
					<pay:FirstName>?</pay:FirstName>
					<!--Optional:-->
					<pay:LastName>?</pay:LastName>
				</pay:BillingAddress>
				<!--Optional:-->
				<pay:CSC>?</pay:CSC>
				<!--Optional:-->
				<pay:Currency>?</pay:Currency>
				<!--Optional:-->
				<pay:EmailAddress>?</pay:EmailAddress>
				<!--Optional:-->
				<pay:Token>?</pay:Token>
			</pay:Payment>
			<!--Optional:-->
			<pay:ReferenceNumber>?</pay:ReferenceNumber>
		</pay:AuthorizationPaymentAndCheckFraudRequest>
		</soap:Body>
</soap:Envelope>
eos

AUTHORIZE_PAYMENT_V2 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymandandfraud/v2/payment">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>  
	</soap:Header>
   <soap:Body>
      <pay:AuthorizationPaymentRequest>
         <!--Optional:-->
		 <pay:ClientChannel>?</pay:ClientChannel>
         <pay:Payment>
            <!--Optional:-->
            <pay:Amount>?</pay:Amount>
            <!--Optional:-->
            <pay:BillingAddress>
               <!--Optional:-->
               <pay:City>?</pay:City>
               <!--Optional:-->
               <pay:CountryCode>?</pay:CountryCode>
               <!--Optional:-->
               <pay:Line1>?</pay:Line1>
               <!--Optional:-->
               <pay:Line2>?</pay:Line2>
               <!--Optional:-->
               <pay:PhoneNumber>?</pay:PhoneNumber>
               <!--Optional:-->
               <pay:PostalCode>?</pay:PostalCode>
               <!--Optional:-->
               <pay:State>?</pay:State>
               <!--Optional:-->
               <pay:FirstName>?</pay:FirstName>
               <!--Optional:-->
               <pay:LastName>?</pay:LastName>
            </pay:BillingAddress>
            <!--Optional:-->
            <pay:CSC>?</pay:CSC>
            <!--Optional:-->
            <pay:Currency>?</pay:Currency>
            <!--Optional:-->
            <pay:EmailAddress>?</pay:EmailAddress>
            <!--Optional:-->
            <pay:Token>?</pay:Token>
         </pay:Payment>
         <!--Optional:-->
         <pay:ReferenceNumber>?</pay:ReferenceNumber>
      </pay:AuthorizationPaymentRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_STORED_VALUE_BALANCES_V2 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymandandfraud/v2/payment">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>  
	</soap:Header>
   <soap:Body>
      <pay:GetStoredValueBalancesRequest>
         <!--Optional:-->
         <pay:ClientChannel>?</pay:ClientChannel>
         <!--Optional:-->
         <pay:StoredValueCard>
            <!--Zero or more repetitions:-->
            <pay:CheckBalanceGiftCard>
               <!--Optional:-->
               <pay:Pin>?</pay:Pin>
               <!--Optional:-->
               <pay:StoredValueCardNumber>?</pay:StoredValueCardNumber>
            </pay:CheckBalanceGiftCard>
         </pay:StoredValueCard>
      </pay:GetStoredValueBalancesRequest>
   </soap:Body>
</soap:Envelope>
eos

REVERSE_AUTHORIZATIONS_V2 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymandandfraud/v2/payment">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>  
	</soap:Header>
   <soap:Body>
      <pay:ReverseAuthorizationRequest>
         <!--Optional:-->
         <pay:AuthorizationIdentifier>?</pay:AuthorizationIdentifier>
		 <pay:ClientChannel>?</pay:ClientChannel>
         <!--Optional:-->
         <pay:ReferenceNumber>?</pay:ReferenceNumber>
      </pay:ReverseAuthorizationRequest>
   </soap:Body>
</soap:Envelope>
eos

SAVE_TOKENS_TO_WALLET_V2 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymandandfraud/v2/payment" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>  
	</soap:Header>
   <soap:Body>
      <pay:SaveTokensToWalletRequest>
         <!--Optional:-->
         <pay:ClientChannel>?</pay:ClientChannel>
         <!--Optional:-->
         <pay:OpenIDClaimedIdentifier>?</pay:OpenIDClaimedIdentifier>
         <!--Optional:-->
         <pay:Tokens>
            <!--Zero or more repetitions:-->
            <arr:string>?</arr:string>
         </pay:Tokens>
      </pay:SaveTokensToWalletRequest>
   </soap:Body>
</soap:Envelope>
eos

VALIDATE_PAYMENT_METHOD_TOKENS_V2 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymandandfraud/v2/payment" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>  
	</soap:Header>
   <soap:Body>
      <pay:ValidatePaymentMethodTokensRequest>
         <!--Optional:-->
         <pay:ClientChannel>?</pay:ClientChannel>
         <!--Optional:-->
         <pay:PaymentMethodTokens>
            <!--Zero or more repetitions:-->
            <arr:string>?</arr:string>
         </pay:PaymentMethodTokens>
      </pay:ValidatePaymentMethodTokensRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_ASSEMBLY_INFO_V2 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/paymentandfraud/v2/payment">
		<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v2/payment/GetAssemblyInfo</wsa:Action>
			<wsa:To soap:mustUnderstand="1">?</wsa:To>
		</soap:Header>
		<soap:Body>
			<v1:GetAssemblyInfo/>
		</soap:Body>
	</soap:Envelope>
eos

end

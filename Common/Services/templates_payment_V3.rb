module PaymentServiceRequestTemplates

SAVE_PAYMENT_METHODS_TO_WALLET_V3 = <<eos
    <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v3/payment">
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
				 <pay:ElectronicAccount>
					<pay:AccountType>?</pay:AccountType>
					<pay:AgreementNumber>?</pay:AgreementNumber>
					<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
				 </pay:ElectronicAccount>
				 <pay:StoredValueCard>
					<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
					<pay:StoredValueCardNumber>?</pay:StoredValueCardNumber>
				 </pay:StoredValueCard>	
				 <pay:OpenIDClaimedIdentifier>?</pay:OpenIDClaimedIdentifier>
			  </pay:SavePaymentMethodsToWalletRequest>
		   </soap:Body>
    </soap:Envelope>
eos

SAVE_PAYMENT_METHODS_WITH_CREDIT_CARD_V3 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v3/payment">
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
			 <pay:StoredValueCard>
				<!--Zero or more repetitions:-->
				<pay:StoredValueCard>
				   <!--Optional:-->
				   <pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
				   <!--Optional:-->
				   <pay:StoredValueCardNumber>?</pay:StoredValueCardNumber>
				</pay:StoredValueCard>
			 </pay:StoredValueCard>
			<pay:PayPalAccount>
				<pay:AgreementNumber>?</pay:AgreementNumber>
				<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
			</pay:PayPalAccount>
		</pay:SavePaymentMethodsRequest>
	</soap:Body>
</soap:Envelope>
eos

SAVE_PAYMENT_METHODS_WITH_GIFT_CARD_V3 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v3/payment">
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

CHECK_FRAUD_V3 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v3/payment">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>  
   </soap:Header>
   <soap:Body>
      <pay:CheckFraudRequest>
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
               <pay:ClientTransactionId>?</pay:ClientTransactionId>
               <!--Optional:-->
               <pay:CreditCard>
                  <!--Optional:-->
                  <pay:Amount>?</pay:Amount>
                  <!--Optional:-->
                  <pay:BillingAddress>
                     <!--Optional:-->
                     <pay:City>?</pay:City>
                     <!--Optional:-->
                     <pay:CountryCode>?</pay:CountryCode>
                     <!--Optional:-->
                     <pay:County>?</pay:County>
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
                  <pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
                  <!--Optional:-->
                  <pay:Currency>?</pay:Currency>
				  <!--Optional:-->
					<pay:Discounts>
						<!--Zero or more repetitions:-->
						<pay:Discount>
							<!--Optional:-->
							<pay:Amount>?</pay:Amount>
							<!--Optional:-->
							<pay:CouponCode>
								<!--Optional:-->
								<pay:Code>?</pay:Code>
								<!--Optional:-->
								<pay:Description>?</pay:Description>
							</pay:CouponCode>
							<!--Optional:-->
							<pay:DiscountLevel>?</pay:DiscountLevel>
							<!--Optional:-->
							<pay:LineItemId>?</pay:LineItemId>
						</pay:Discount>
					</pay:Discounts>
                  <!--Optional:-->
                  <pay:EmailAddress>?</pay:EmailAddress>
                  <!--Optional:-->
                  <pay:ExpirationMonth>?</pay:ExpirationMonth>
                  <!--Optional:-->
                  <pay:ExpirationYear>?</pay:ExpirationYear>
                  <!--Optional:-->
                  <pay:Identifier>?</pay:Identifier>
                  <!--Optional:-->
                  <pay:NameOnCard>?</pay:NameOnCard>
                  <!--Optional:-->
                  <pay:Type>?</pay:Type>
               </pay:CreditCard>
               <!--Optional:-->
               <pay:Currency>?</pay:Currency>
               <!--Optional:-->
               <pay:ElectronicAccountPayment>
                  <!--Optional:-->
                  <pay:AccountEmailAddress>?</pay:AccountEmailAddress>
                  <!--Optional:-->
                  <pay:AccountStatus>?</pay:AccountStatus>
                  <!--Optional:-->
                  <pay:AccountType>?</pay:AccountType>
                  <!--Optional:-->
                  <pay:Amount>?</pay:Amount>
                  <!--Optional:-->
                  <pay:BillingAddress>
                     <!--Optional:-->
                     <pay:City>?</pay:City>
                     <!--Optional:-->
                     <pay:CountryCode>?</pay:CountryCode>
                     <!--Optional:-->
                     <pay:County>?</pay:County>
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
                  <pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
                  <!--Optional:-->
                  <pay:Currency>?</pay:Currency>
                  <!--Optional:-->
                  <pay:Identifier>?</pay:Identifier>
               </pay:ElectronicAccountPayment>
               <!--Optional:-->
               <pay:OrderStatus>?</pay:OrderStatus>
			   <!--Optional:-->
               <pay:Products>
                  <!--Zero or more repetitions:-->
                  <pay:Product>
                     <!--Optional:-->
                     <pay:AvailableDate>?</pay:AvailableDate>
                     <!--Optional:-->
                     <pay:Description>?</pay:Description>
                     <!--Optional:-->
                     <pay:DeveloperName>?</pay:DeveloperName>
                     <!--Optional:-->
                     <pay:Genres>
                        <!--Zero or more repetitions:-->
                        <pay:Genre>
                           <!--Optional:-->
                           <pay:Id>?</pay:Id>
                           <!--Optional:-->
                           <pay:Name>?</pay:Name>
                        </pay:Genre>
                     </pay:Genres>
                     <!--Optional:-->
                     <pay:Name>?</pay:Name>
                     <!--Optional:-->
                     <pay:ProductId>?</pay:ProductId>
                     <!--Optional:-->
                     <pay:ProductType>?</pay:ProductType>
                     <!--Optional:-->
                     <pay:Properties>
                        <!--Zero or more repetitions:-->
                        <pay:NameValueProperty>
                           <!--Optional:-->
                           <pay:Name>?</pay:Name>
                           <!--Optional:-->
                           <pay:Value>?</pay:Value>
                        </pay:NameValueProperty>
                     </pay:Properties>
                     <!--Optional:-->
                     <pay:PublisherName>?</pay:PublisherName>
                     <!--Optional:-->
                     <pay:Rating>?</pay:Rating>
                     <!--Optional:-->
                     <pay:ReleaseDate>?</pay:ReleaseDate>
                     <!--Optional:-->
                     <pay:Sku>?</pay:Sku>
                     <!--Optional:-->
                     <pay:UnitPrice>?</pay:UnitPrice>
                  </pay:Product>
               </pay:Products>
               <!--Optional:-->
               <pay:Shipments>
                  <!--Zero or more repetitions:-->
                  <pay:Shipment>
                     <!--Optional:-->
                     <pay:FulfillmentChannel>?</pay:FulfillmentChannel>
                     <!--Optional:-->
                     <pay:IsGift>?</pay:IsGift>  
					 <!--Optional:-->
                     <pay:LineItems>
                        <!--Zero or more repetitions:-->
                        <pay:LineItem>
                           <!--Optional:-->
                           <pay:Description>?</pay:Description>
                           <!--Optional:-->
                           <pay:LineItemId>?</pay:LineItemId>
                           <!--Optional:-->
                           <pay:Quantity>?</pay:Quantity>
                           <!--Optional:-->
                           <pay:ShippingCost>?</pay:ShippingCost>
                           <!--Optional:-->
                           <pay:ShippingTax>?</pay:ShippingTax>
                           <!--Optional:-->
                           <pay:Sku>?</pay:Sku>
                           <!--Optional:-->
                           <pay:Tax>?</pay:Tax>
                           <!--Optional:-->
                           <pay:TotalAmount>?</pay:TotalAmount>
                           <!--Optional:-->
                           <pay:UnitPriceWithDiscounts>?</pay:UnitPriceWithDiscounts>
                        </pay:LineItem>
                     </pay:LineItems>
					 <!--Optional:-->
						<pay:ShipTo>
							<!--Optional:-->
							<pay:City>?</pay:City>
							<!--Optional:-->
							<pay:CountryCode>?</pay:CountryCode>
							<!--Optional:-->
							<pay:County>?</pay:County>
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
						</pay:ShipTo>
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
               <pay:StoredValueCards>
                  <!--Zero or more repetitions:-->
                  <pay:StoredValuePayment>
                     <!--Optional:-->
                     <pay:Amount>?</pay:Amount>
                     <!--Optional:-->
                     <pay:Balance>?</pay:Balance>
                     <!--Optional:-->
                     <pay:BillingAddress>
                        <!--Optional:-->
                        <pay:City>?</pay:City>
                        <!--Optional:-->
                        <pay:CountryCode>?</pay:CountryCode>
                        <!--Optional:-->
                        <pay:County>?</pay:County>
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
                     <pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
                     <!--Optional:-->
                     <pay:Currency>?</pay:Currency>
                     <!--Optional:-->
                     <pay:Identifier>?</pay:Identifier>
                     <!--Optional:-->
                     <pay:Pin>?</pay:Pin>
                  </pay:StoredValuePayment>
               </pay:StoredValueCards>
               <!--Optional:-->
               <pay:TaxAmount>?</pay:TaxAmount>
               <!--Optional:-->
               <pay:TotalAmount>?</pay:TotalAmount>
               <!--Optional:-->
               <pay:TransactionDate>?</pay:TransactionDate>
            </pay:Transaction>
         </pay:FraudCheckInformation>
      </pay:CheckFraudRequest>
   </soap:Body>
</soap:Envelope>
eos

AUTHORIZE_PAYMENT_V3 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymandandfraud/v3/payment">
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

GET_STORED_VALUE_BALANCES_V3 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymandandfraud/v3/payment">
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

REVERSE_AUTHORIZATIONS_V3 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymandandfraud/v3/payment">
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

SAVE_TOKENS_TO_WALLET_V3 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymandandfraud/v3/payment" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
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

VALIDATE_PAYMENT_METHOD_TOKENS_V3 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymandandfraud/v3/payment" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
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

GET_ASSEMBLY_INFO_V3 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/paymentandfraud/v3/payment">
		<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v3/payment/GetAssemblyInfo</wsa:Action>
			<wsa:To soap:mustUnderstand="1">?</wsa:To>
		</soap:Header>
		<soap:Body>
			<v1:GetAssemblyInfo/>
		</soap:Body>
	</soap:Envelope>
eos
end

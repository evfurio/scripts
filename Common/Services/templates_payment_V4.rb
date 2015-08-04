module PaymentServiceRequestTemplates

  AUTH_AND_SETTLE_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/Charge</wsa:Action>
			<wsa:To soap:mustUnderstand="1">?</wsa:To>
		 </soap:Header>
		 <soap:Body>
				<pay:AuthAndSettleRequest>
					 <!--Optional:-->
					 <pay:ClientChannel>?</pay:ClientChannel>
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
							<pay:EmailAddress>?</pay:EmailAddress>
							<!--Optional:-->
							<pay:ExpirationMonth>?</pay:ExpirationMonth>
							<!--Optional:-->
							<pay:ExpirationYear>?</pay:ExpirationYear>
							<!--Optional:-->
							<pay:FinancingCode>?</pay:FinancingCode>
							<!--Optional:-->
							<pay:Identifier>?</pay:Identifier>
							<!--Optional:-->
							<pay:NameOnCard>?</pay:NameOnCard>
							<!--Optional:-->
							<pay:Type>?</pay:Type>
					 </pay:CreditCard>
					 <!--Optional:-->
					 <pay:ElectronicAccountPayment>
							<!--Optional:-->
							<pay:AccountEmailAddress>?</pay:AccountEmailAddress>
							<!--Optional:-->
							<pay:AccountType>?</pay:AccountType>
							<!--Optional:-->
							<pay:Amount>?</pay:Amount>
							<!--Optional:-->
							<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
							<!--Optional:-->
							<pay:Currency>?</pay:Currency>
							<!--Optional:-->
							<pay:Identifier>?</pay:Identifier>
					 </pay:ElectronicAccountPayment>
					 <!--Optional:-->
					 <pay:ReferenceNumber>?</pay:ReferenceNumber>
					 <!--Optional:-->
					 <pay:StoredValueCard>
							<!--Optional:-->
							<pay:Amount>?</pay:Amount>
							<!--Optional:-->
							<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
							<!--Optional:-->
							<pay:Currency>?</pay:Currency>
							<!--Optional:-->
							<pay:Identifier>?</pay:Identifier>
							<!--Optional:-->
							<pay:Pin>?</pay:Pin>
					 </pay:StoredValueCard>
				</pay:AuthAndSettleRequest>
		 </soap:Body>
	</soap:Envelope>
eos

  AUTHORIZE_PAYMENT_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/AuthorizePayment</wsa:Action>
			<wsa:To soap:mustUnderstand="1">?</wsa:To>
		 </soap:Header>
		 <soap:Body>
				<pay:AuthorizePaymentRequest>
					 <!--Optional:-->
					 <pay:ClientChannel>?</pay:ClientChannel>
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
							<pay:EmailAddress>?</pay:EmailAddress>
							<!--Optional:-->
							<pay:ExpirationMonth>?</pay:ExpirationMonth>
							<!--Optional:-->
							<pay:ExpirationYear>?</pay:ExpirationYear>
							<!--Optional:-->
							<pay:FinancingCode>?</pay:FinancingCode>
							<!--Optional:-->
							<pay:Identifier>?</pay:Identifier>
							<!--Optional:-->
							<pay:NameOnCard>?</pay:NameOnCard>
							<!--Optional:-->
							<pay:Type>?</pay:Type>
					 </pay:CreditCard>
					 <!--Optional:-->
					 <pay:ElectronicAccountPayment>
							<!--Optional:-->
							<pay:AccountEmailAddress>?</pay:AccountEmailAddress>
							<!--Optional:-->
							<pay:AccountType>?</pay:AccountType>
							<!--Optional:-->
							<pay:Amount>?</pay:Amount>
							<!--Optional:-->
							<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
							<!--Optional:-->
							<pay:Currency>?</pay:Currency>
							<!--Optional:-->
							<pay:Identifier>?</pay:Identifier>
					 </pay:ElectronicAccountPayment>
					 <!--Optional:-->
					 <pay:MessageId>?</pay:MessageId>
					 <!--Optional:-->
					 <pay:ReferenceNumber>?</pay:ReferenceNumber>
					 <!--Optional:-->
					 <pay:StoredValueCard>
							<!--Optional:-->
							<pay:Amount>?</pay:Amount>
							<!--Optional:-->
							<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
							<!--Optional:-->
							<pay:Currency>?</pay:Currency>
							<!--Optional:-->
							<pay:Identifier>?</pay:Identifier>
							<!--Optional:-->
							<pay:Pin>?</pay:Pin>
					 </pay:StoredValueCard>
				</pay:AuthorizePaymentRequest>
		 </soap:Body>
	</soap:Envelope>
eos

  # CANCEL_V4 = <<eos
  # eos

  CHECK_FRAUD_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			 <wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/CheckFraud</wsa:Action>
			 <wsa:To soap:mustUnderstand="1">?</wsa:To>
		 </soap:Header>
		 <soap:Body>
				<pay:CheckFraudRequest>
					 <!--Optional:-->
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
								 <pay:PhysicalLocation>
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
								 </pay:PhysicalLocation>
								 <!--Optional:-->
								 <pay:UserProfile>
										<!--Optional:-->
										<pay:AccountId>?</pay:AccountId>
										<!--Optional:-->
										<pay:CustomerId>?</pay:CustomerId>
										<!--Optional:-->
										<pay:DefaultBillingAddress>
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
										</pay:DefaultBillingAddress>
										<!--Optional:-->
										<pay:EmailAddress>?</pay:EmailAddress>
										<!--Optional:-->
										<pay:FailedTransactions>
											 <!--Zero or more repetitions:-->
											 <pay:Transaction>
													<!--Optional:-->
													<pay:AffiliateCode>?</pay:AffiliateCode>
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
													<pay:ClientTransactionId>?</pay:ClientTransactionId>
													<!--Optional:-->
													<pay:CreditCard>
														 <!--Optional:-->
														 <pay:Amount>?</pay:Amount>
														 <!--Optional:-->
														 <pay:CSC>?</pay:CSC>
														 <!--Optional:-->
														 <pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
														 <!--Optional:-->
														 <pay:Currency>?</pay:Currency>
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
														 <pay:ProcessorTransactionId>?</pay:ProcessorTransactionId>
														 <!--Optional:-->
														 <pay:Type>?</pay:Type>
													</pay:CreditCard>
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
														 <pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
														 <!--Optional:-->
														 <pay:Currency>?</pay:Currency>
														 <!--Optional:-->
														 <pay:Identifier>?</pay:Identifier>
													</pay:ElectronicAccountPayment>
													<!--Optional:-->
													<pay:NuDataResponse>
														 <!--Optional:-->
														 <pay:DeviceFingerprint>?</pay:DeviceFingerprint>
														 <!--Optional:-->
														 <pay:DeviceUID>?</pay:DeviceUID>
														 <!--Optional:-->
														 <pay:FlowID>?</pay:FlowID>
														 <!--Optional:-->
														 <pay:Score>?</pay:Score>
														 <!--Optional:-->
														 <pay:ScoreDetails>
																<!--Zero or more repetitions:-->
																<pay:NameValueProperty>
																	 <!--Optional:-->
																	 <pay:Name>?</pay:Name>
																	 <!--Optional:-->
																	 <pay:Value>?</pay:Value>
																</pay:NameValueProperty>
														 </pay:ScoreDetails>
														 <!--Optional:-->
														 <pay:ScoreSignatures>
																<!--Zero or more repetitions:-->
																<arr:string>?</arr:string>
														 </pay:ScoreSignatures>
														 <!--Optional:-->
														 <pay:StatusCode>?</pay:StatusCode>
														 <!--Optional:-->
														 <pay:StatusMessage>?</pay:StatusMessage>
													</pay:NuDataResponse>
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
																<pay:Message>?</pay:Message>
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
													<pay:ShippingAddressChanged>?</pay:ShippingAddressChanged>
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
										</pay:FailedTransactions>
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
										<pay:RegisteredDate>?</pay:RegisteredDate>
										<!--Optional:-->
										<pay:RegisteredIPAddress>?</pay:RegisteredIPAddress>
										<!--Optional:-->
										<pay:TotalNumberSuccessfulTransactions>?</pay:TotalNumberSuccessfulTransactions>
								 </pay:UserProfile>
							</pay:Identification>
							<!--Optional:-->
							<pay:SessionId>?</pay:SessionId>
							<!--Optional:-->
							<pay:Transaction>
								 <!--Optional:-->
								 <pay:AffiliateCode>?</pay:AffiliateCode>
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
								 <pay:ClientTransactionId>?</pay:ClientTransactionId>
								 <!--Optional:-->
								 <pay:CreditCard>
										<!--Optional:-->
										<pay:Amount>?</pay:Amount>
										<!--Optional:-->
										<pay:CSC>?</pay:CSC>
										<!--Optional:-->
										<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
										<!--Optional:-->
										<pay:Currency>?</pay:Currency>
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
										<pay:ProcessorTransactionId>?</pay:ProcessorTransactionId>
										<!--Optional:-->
										<pay:Type>?</pay:Type>
								 </pay:CreditCard>
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
										<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
										<!--Optional:-->
										<pay:Currency>?</pay:Currency>
										<!--Optional:-->
										<pay:Identifier>?</pay:Identifier>
								 </pay:ElectronicAccountPayment>
								 <!--Optional:-->
								 <pay:NuDataResponse>
										<!--Optional:-->
										<pay:DeviceFingerprint>?</pay:DeviceFingerprint>
										<!--Optional:-->
										<pay:DeviceUID>?</pay:DeviceUID>
										<!--Optional:-->
										<pay:FlowID>?</pay:FlowID>
										<!--Optional:-->
										<pay:Score>?</pay:Score>
										<!--Optional:-->
										<pay:ScoreDetails>
											 <!--Zero or more repetitions:-->
											 <pay:NameValueProperty>
													<!--Optional:-->
													<pay:Name>?</pay:Name>
													<!--Optional:-->
													<pay:Value>?</pay:Value>
											 </pay:NameValueProperty>
										</pay:ScoreDetails>
										<!--Optional:-->
										<pay:ScoreSignatures>
											 <!--Zero or more repetitions:-->
											 <arr:string>?</arr:string>
										</pay:ScoreSignatures>
										<!--Optional:-->
										<pay:StatusCode>?</pay:StatusCode>
										<!--Optional:-->
										<pay:StatusMessage>?</pay:StatusMessage>
								 </pay:NuDataResponse>
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
											 <pay:Message>?</pay:Message>
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
								 <pay:ShippingAddressChanged>?</pay:ShippingAddressChanged>
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

  # CLOSE_ORDER_V4 = <<eos
  # eos

  CREATE_VENDOR_AGREEMENT_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
				<wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/CreateVendorAgreement</wsa:Action>
				<wsa:To soap:mustUnderstand="1">?</wsa:To>
	   </soap:Header>
		 <soap:Body>
				<pay:CreateVendorAgreementRequest>
					 <!--Optional:-->
					 <pay:ClientChannel>?</pay:ClientChannel>
					 <!--Optional:-->
					 <pay:ElectronicAccount>
							<!--Optional:-->
							<pay:AccountEmailAddress>?</pay:AccountEmailAddress>
							<!--Optional:-->
							<pay:AccountType>?</pay:AccountType>
							<!--Optional:-->
							<pay:Amount>?</pay:Amount>
							<!--Optional:-->
							<pay:BrandSettings>
								 <!--Optional:-->
								 <pay:BrandColor>?</pay:BrandColor>
								 <!--Optional:-->
								 <pay:FailureUrl>?</pay:FailureUrl>
								 <!--Optional:-->
								 <pay:LogoURL>?</pay:LogoURL>
								 <!--Optional:-->
								 <pay:ReturnUrl>?</pay:ReturnUrl>
								 <!--Optional:-->
								 <pay:SuccessUrl>?</pay:SuccessUrl>
							</pay:BrandSettings>
							<!--Optional:-->
							<pay:Currency>?</pay:Currency>
							<!--Optional:-->
							<pay:OrderItems>
								 <!--Zero or more repetitions:-->
								 <pay:OrderItem>
										<!--Optional:-->
										<pay:ProductDescription>?</pay:ProductDescription>
										<!--Optional:-->
										<pay:ProductName>?</pay:ProductName>
										<!--Optional:-->
										<pay:ProductPrice>?</pay:ProductPrice>
										<!--Optional:-->
										<pay:ProductQuantity>?</pay:ProductQuantity>
										<!--Optional:-->
										<pay:Sku>?</pay:Sku>
								 </pay:OrderItem>
							</pay:OrderItems>
							<!--Optional:-->
							<pay:ShippingAddress>
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
							</pay:ShippingAddress>
							<!--Optional:-->
							<pay:ShippingAmount>?</pay:ShippingAmount>
							<!--Optional:-->
							<pay:ShippingDiscount>?</pay:ShippingDiscount>
							<!--Optional:-->
							<pay:TaxAmount>?</pay:TaxAmount>
					 </pay:ElectronicAccount>
					 <!--Optional:-->
					 <pay:Identifier>?</pay:Identifier>
					 <!--Optional:-->
					 <pay:Recurring>?</pay:Recurring>
					 <!--Optional:-->
					 <pay:ReferenceNumber>?</pay:ReferenceNumber>
					 <!--Optional:-->
					 <pay:SessionId>?</pay:SessionId>
				</pay:CreateVendorAgreementRequest>
		 </soap:Body>
	</soap:Envelope>
eos

  CREDIT_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/Credit</wsa:Action>
			<wsa:To soap:mustUnderstand="1">?</wsa:To>
		 </soap:Header>
		 <soap:Body>
				<pay:CreditRequest>
					 <!--Optional:-->
					 <pay:Amount>?</pay:Amount>
					 <!--Optional:-->
					 <pay:ClientChannel>?</pay:ClientChannel>
					 <!--Optional:-->
					 <pay:CreditCard>
							<!--Optional:-->
							<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
							<!--Optional:-->
							<pay:CreditCardNumber>?</pay:CreditCardNumber>
							<!--Optional:-->
							<pay:ExpirationMonth>?</pay:ExpirationMonth>
							<!--Optional:-->
							<pay:ExpirationYear>?</pay:ExpirationYear>
							<!--Optional:-->
							<pay:NameOnCard>?</pay:NameOnCard>
							<!--Optional:-->
							<pay:Type>?</pay:Type>
					 </pay:CreditCard>
					 <!--Optional:-->
					 <pay:Currency>?</pay:Currency>
					 <!--Optional:-->
					 <pay:ReferenceNumber>?</pay:ReferenceNumber>
				</pay:CreditRequest>
		 </soap:Body>
	</soap:Envelope>
eos

  # GET_ENHANCED_STORE_VALUE_BALANCES = <<eos
  # eos

  GET_STORED_VALUE_BALANCES_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment">
		<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/GetStoredValueBalances</wsa:Action>
			<wsa:To soap:mustUnderstand="1">?</wsa:To>
		</soap:Header>
		<soap:Body>
			<pay:GetStoredValueBalanceRequest>
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
			</pay:GetStoredValueBalanceRequest>
		 </soap:Body>
	</soap:Envelope>
eos

  # GET_STORED_VALUE_BALANCES_BY_LOYALTY_CARD_NUMBER_V4 = <<eos
  # eos

  GET_VENDOR_AGREEMENT_DETAILS_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			 <wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/GetVendorAgreementDetails</wsa:Action>
			 <wsa:To soap:mustUnderstand="1">?</wsa:To>
		 </soap:Header>
		 <soap:Body>
				<pay:GetVendorAgreementDetailsRequest>
					 <!--Optional:-->
					 <pay:ClientChannel>?</pay:ClientChannel>
					 <!--Optional:-->
					 <pay:ReferenceNumber>?</pay:ReferenceNumber>
				</pay:GetVendorAgreementDetailsRequest>
		 </soap:Body>
	</soap:Envelope>
eos

  # INITIALIZE_PAYMENT_V4 = <<eos
  # eos

  ISSUE_STORED_VALUE_CARD_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			 <wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/IssueStoredValueCard</wsa:Action>
			 <wsa:To soap:mustUnderstand="1">?</wsa:To>
		 </soap:Header>
		 <soap:Body>
				<pay:IssueStoredValueCardRequest>
					 <!--Optional:-->
					 <pay:ClientChannel>?</pay:ClientChannel>
					 <!--Optional:-->
					 <pay:Currency>?</pay:Currency>
					 <!--Optional:-->
					 <pay:Identifier>?</pay:Identifier>
					 <!--Optional:-->
					 <pay:IssueAmount>?</pay:IssueAmount>
					 <!--Optional:-->
					 <pay:ReferenceNumber>?</pay:ReferenceNumber>
				</pay:IssueStoredValueCardRequest>
		 </soap:Body>
	</soap:Envelope>
eos

  # REFUND_V4 = <<eos
  # eos

  # REVERSE_AUTHORIZATIONS_V4 = <<eos
  # eos

  SAVE_PAYMENT_METHODS_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			 <wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/SavePaymentMethods</wsa:Action>
			 <wsa:To soap:mustUnderstand="1">?</wsa:To>
		 </soap:Header>
		 <soap:Body>
				<pay:SavePaymentMethodsRequest>
					 <!--Optional:-->
					 <pay:ClientChannel>?</pay:ClientChannel>
					 <!--Optional:-->
					 <pay:CreditCard>
							<!--Optional:-->
							<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
							<!--Optional:-->
							<pay:CreditCardNumber>?</pay:CreditCardNumber>
							<!--Optional:-->
							<pay:ExpirationMonth>?</pay:ExpirationMonth>
							<!--Optional:-->
							<pay:ExpirationYear>?</pay:ExpirationYear>
							<!--Optional:-->
							<pay:NameOnCard>?</pay:NameOnCard>
							<!--Optional:-->
							<pay:Type>?</pay:Type>
					 </pay:CreditCard>
					 <!--Optional:-->
					 <pay:ElectronicAccount>
							<!--Optional:-->
							<pay:AccountType>?</pay:AccountType>
							<!--Optional:-->
							<pay:AgreementNumber>?</pay:AgreementNumber>
							<!--Optional:-->
							<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
					 </pay:ElectronicAccount>
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
				</pay:SavePaymentMethodsRequest>
		 </soap:Body>
	</soap:Envelope>
eos

  SAVE_PAYMENT_METHODS_TO_WALLET_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			 <wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/SavePaymentMethodsToWallet</wsa:Action>
			 <wsa:To soap:mustUnderstand="1">?</wsa:To>
		 </soap:Header>
		 <soap:Body>
				<pay:SavePaymentMethodsToWalletRequest>
					 <!--Optional:-->
					 <pay:ClientChannel>?</pay:ClientChannel>
					 <!--Optional:-->
					 <pay:CreditCard>
							<!--Optional:-->
							<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
							<!--Optional:-->
							<pay:CreditCardNumber>?</pay:CreditCardNumber>
							<!--Optional:-->
							<pay:ExpirationMonth>?</pay:ExpirationMonth>
							<!--Optional:-->
							<pay:ExpirationYear>?</pay:ExpirationYear>
							<!--Optional:-->
							<pay:NameOnCard>?</pay:NameOnCard>
							<!--Optional:-->
							<pay:Type>?</pay:Type>
					 </pay:CreditCard>
					 <!--Optional:-->
					 <pay:ElectronicAccount>
							<!--Optional:-->
							<pay:AccountType>?</pay:AccountType>
							<!--Optional:-->
							<pay:AgreementNumber>?</pay:AgreementNumber>
							<!--Optional:-->
							<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
					 </pay:ElectronicAccount>
					 <!--Optional:-->
					 <pay:OpenIDClaimedIdentifier>?</pay:OpenIDClaimedIdentifier>
					 <!--Optional:-->
					 <pay:StoredValueCard>
							<!--Optional:-->
							<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
							<!--Optional:-->
							<pay:StoredValueCardNumber>?</pay:StoredValueCardNumber>
					 </pay:StoredValueCard>
				</pay:SavePaymentMethodsToWalletRequest>
		 </soap:Body>
	</soap:Envelope>
eos

  SAVE_TOKENS_TO_WALLET_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			 <wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/SaveTokensToWallet</wsa:Action>
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

  # SETTLE_V4 = <<eos
  # eos

  TRANSFER_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			 <wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/Transfer</wsa:Action>
			 <wsa:To soap:mustUnderstand="1">?</wsa:To>
		 </soap:Header>
		 <soap:Body>
				<pay:TransferRequest>
					 <!--Optional:-->
					 <pay:ClientChannel>?</pay:ClientChannel>
					 <!--Optional:-->
					 <pay:OrderNumber>?</pay:OrderNumber>
					 <!--Optional:-->
					 <pay:Recipients>
							<!--Zero or more repetitions:-->
							<arr:string>?</arr:string>
					 </pay:Recipients>
					 <!--Optional:-->
					 <pay:RefundAmount>?</pay:RefundAmount>
					 <!--Optional:-->
					 <pay:StoreNumber>?</pay:StoreNumber>
					 <!--Optional:-->
					 <pay:TransferrerCardNumber>?</pay:TransferrerCardNumber>
				</pay:TransferRequest>
		 </soap:Body>
	</soap:Envelope>
eos

  VALIDATE_PAYMENT_METHOD_TOKENS_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			 <wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/ValidatePaymentMethodTokens</wsa:Action>
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

  VALIDATE_VENDOR_AGREEMENT_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			 <wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/ValidateVendorAgreement</wsa:Action>
			 <wsa:To soap:mustUnderstand="1">?</wsa:To>
		 </soap:Header>
		 <soap:Body>
				<pay:ValidateVendorAgreementRequest>
					 <!--Optional:-->
					 <pay:AgreementContent>?</pay:AgreementContent>
					 <!--Optional:-->
					 <pay:ClientChannel>?</pay:ClientChannel>
					 <!--Optional:-->
					 <pay:ReferenceNumber>?</pay:ReferenceNumber>
				</pay:ValidateVendorAgreementRequest>
		 </soap:Body>
	</soap:Envelope>
eos

  CREATE_TOKEN_V4 = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:pay="http://gamestop.com/paymentandfraud/v4/payment" xmlns:gam="http://schemas.datacontract.org/2004/07/GameStop.Ecom.PaymentAndFraud.Messages.Payment.v4">
	<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/paymentandfraud/v4/payment/CreateToken</wsa:Action></soap:Header>
		<soap:Body>
			<pay:CreateTokenRequest>
			<!--Optional:-->
				<pay:CreditCards>
				<!--Zero or more repetitions:-->
						<gam:CreateTokenCreditCard>
								<!--Optional:-->
								<pay:ClientPaymentMethodID>?</pay:ClientPaymentMethodID>
								<!--Optional:-->
								<pay:CreditCardNumber>?</pay:CreditCardNumber>
								<!--Optional:-->
								<pay:ExpirationMonth>?</pay:ExpirationMonth>
								<!--Optional:-->
								<pay:ExpirationYear>?</pay:ExpirationYear>
								<!--Optional:-->
								<pay:NameOnCard>?</pay:NameOnCard>
								<!--Optional:-->
								<pay:Type>?</pay:Type>
						<!--Optional:-->
					<gam:ReferenceId>?</gam:ReferenceId>
					</gam:CreateTokenCreditCard>
         </pay:CreditCards>
		</pay:CreateTokenRequest>
   </soap:Body>
	</soap:Envelope>
eos

end

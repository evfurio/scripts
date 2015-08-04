module PurchaseOrderServiceRequestTemplates

ADD_EMAIL_ADDRESSES_TO_SHIPMENTS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
   <soap:Body>
      <v1:AddEmailAddressesToShipmentsRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:Locale>?</v1:Locale>
         <!--Optional:-->
         <v1:OwnerID>?</v1:OwnerID>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
         <!--Optional:-->
         <v1:Shipments>
            <!--Zero or more repetitions:-->
            <v1:EmailAddressShipment>
               <!--Optional:-->
               <v1:EmailAddress>?</v1:EmailAddress>
               <!--Optional:-->
               <v1:ShipmentID>?</v1:ShipmentID>
            </v1:EmailAddressShipment>
         </v1:Shipments>
      </v1:AddEmailAddressesToShipmentsRequest>
   </soap:Body>
</soap:Envelope>
eos

CREATE_PURCHASE_ORDER_FROM_CART = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">http://gamestop.com/orders/purchaseorder/v1/createpurchaseorderfromcart</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:CreatePurchaseOrderFromCartRequest>
            <v1:ClientChannel>?</v1:ClientChannel>           
            <v1:Locale>?</v1:Locale>            
            <v1:OwnerID>?</v1:OwnerID>            
            <v1:SessionID>?</v1:SessionID>
			<v1:TargetingContext>
				<v1:Items>
					<v1:NameValueProperty>
					<v1:Name>?</v1:Name>
					<v1:Value>?</v1:Value>
					</v1:NameValueProperty>
				</v1:Items>
			</v1:TargetingContext>
        </v1:CreatePurchaseOrderFromCartRequest>
    </soap:Body>
</soap:Envelope>
eos

VALIDATE_PURCHASE_ORDER2 = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <v1:SessionID>?</v1:SessionID>
        <v1:Locale>?</v1:Locale>
        <v1:ClientChannel>?</v1:ClientChannel>
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:ValidatePurchaseOrder2Request>            
            <v1:OwnerID>?</v1:OwnerID>
			<v1:TargetingContext>
				<v1:Items>
					<v1:NameValueProperty>
					<v1:Name>?</v1:Name>
					<v1:Value>?</v1:Value>
					</v1:NameValueProperty>
				</v1:Items>
			</v1:TargetingContext>
        </v1:ValidatePurchaseOrder2Request>
    </soap:Body>
</soap:Envelope>
eos

ADD_CHANNEL_ATTRIBUTES_TO_PURCHASE_ORDER_WITH_ONLINE_CHANNEL_SPECIFIC_DATA = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <v1:SessionID>?</v1:SessionID>
        <v1:Locale>?</v1:Locale>
        <v1:ClientChannel>?</v1:ClientChannel>
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body><v1:AddChannelAttributesToPurchaseOrderRequest>
            <v1:ChannelAttributes xsi:type="v1:OnlineChannelSpecificData" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">                
                <v1:Brand>?</v1:Brand>                
                <v1:ClientIP>?</v1:ClientIP>               
                <v1:GeoLatitude>?</v1:GeoLatitude>               
                <v1:GeoLongitude>?</v1:GeoLongitude>
            </v1:ChannelAttributes>            
            <v1:OwnerID>?</v1:OwnerID>
        </v1:AddChannelAttributesToPurchaseOrderRequest>
    </soap:Body>
</soap:Envelope>
eos

ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS_WITH_ADDRESS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:AddShippingAddressesToShipmentsRequest>      
            <v1:ClientChannel>?</v1:ClientChannel>            
            <v1:Locale>?</v1:Locale>            
            <v1:OwnerID>?</v1:OwnerID>           
            <v1:SessionID>?</v1:SessionID>            
            <v1:Shipments>
                <!--Zero or more repetitions:-->
                <v1:AddressShipment>                    
                    <v1:Address xsi:type="v1:Address" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">                        
                        <v1:AddressID>?</v1:AddressID>                       
                        <v1:City>?</v1:City>                       
                        <v1:CountryCode>?</v1:CountryCode>                       
                        <v1:Line1>?</v1:Line1>                       
                        <v1:Line2>?</v1:Line2>                       
                        <v1:PostalCode>?</v1:PostalCode>                        
                        <v1:State>?</v1:State>                        
                        <v1:FirstName>?</v1:FirstName>                        
                        <v1:LastName>?</v1:LastName>
                    </v1:Address>                    
                    <v1:EmailAddress>?</v1:EmailAddress>                    
                    <v1:PhoneNumber>?</v1:PhoneNumber>                    
                    <v1:ShipmentID>?</v1:ShipmentID>
                </v1:AddressShipment>
            </v1:Shipments>
        </v1:AddShippingAddressesToShipmentsRequest>
    </soap:Body>
</soap:Envelope>
eos

ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS_WITH_STOREADDRESS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:AddShippingAddressesToShipmentsRequest>           
            <v1:ClientChannel>?</v1:ClientChannel>           
            <v1:Locale>?</v1:Locale>          
            <v1:OwnerID>?</v1:OwnerID>           
            <v1:SessionID>?</v1:SessionID>            
            <v1:Shipments>
                <!--Zero or more repetitions:-->
                <v1:AddressShipment>                    
                    <v1:Address xsi:type="v1:StoreAddress" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">                       
                        <v1:AddressID>?</v1:AddressID>                       
                        <v1:City>?</v1:City>                       
                        <v1:CountryCode>?</v1:CountryCode>                       
                        <v1:Line1>?</v1:Line1>                       
                        <v1:Line2>?</v1:Line2>                        
                        <v1:PostalCode>?</v1:PostalCode>                        
                        <v1:State>?</v1:State>                        
                        <v1:MallName>?</v1:MallName>                        
                        <v1:StoreNumber>?</v1:StoreNumber>
						<v1:StorePhoneNumber>?</v1:StorePhoneNumber>
                    </v1:Address>                    
                    <v1:EmailAddress>?</v1:EmailAddress>                   
                    <v1:PhoneNumber>?</v1:PhoneNumber>                    
                    <v1:ShipmentID>?</v1:ShipmentID>
                </v1:AddressShipment>
            </v1:Shipments>
        </v1:AddShippingAddressesToShipmentsRequest>
    </soap:Body>
</soap:Envelope>
eos

ADD_CUSTOMER_TO_PURCHASE_ORDER = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <v1:SessionID>?</v1:SessionID>
        <v1:Locale>?</v1:Locale>
        <v1:ClientChannel>?</v1:ClientChannel>
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:AddCustomerToPurchaseOrderRequest>           
            <v1:Customer>
              <v1:BillTo>
                 <v1:AddressID>?</v1:AddressID>
                 <v1:City>?</v1:City>
                 <v1:CountryCode>?</v1:CountryCode>
                 <v1:FormatValidated>?</v1:FormatValidated>
                 <v1:Line1>?</v1:Line1>
                 <v1:Line2>?</v1:Line2>
                 <v1:PostalCode>?</v1:PostalCode>
                 <v1:State>?</v1:State>
                 <v1:FirstName>?</v1:FirstName>
                 <v1:LastName>?</v1:LastName>
              </v1:BillTo>
              <v1:EmailAddress>?</v1:EmailAddress>
              <v1:IsGuestCheckout>?</v1:IsGuestCheckout>
              <v1:LoyaltyCardNumber>?</v1:LoyaltyCardNumber>
              <v1:LoyaltyCustomerID>?</v1:LoyaltyCustomerID>
              <v1:LoyaltyTier>?</v1:LoyaltyTier>
              <v1:OpenIdClaimedIdentifier>?</v1:OpenIdClaimedIdentifier>
              <v1:PhoneNumber>?</v1:PhoneNumber>
           </v1:Customer>
            <v1:OwnerID>?</v1:OwnerID>
        </v1:AddCustomerToPurchaseOrderRequest>
    </soap:Body>
</soap:Envelope>
eos

ADD_SHIPPING_METHODS_TO_SHIPMENTS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:AddShippingMethodsToShipmentsRequest>  
            <v1:ClientChannel>?</v1:ClientChannel>
            <v1:Locale>?</v1:Locale>
            <v1:OwnerID>?</v1:OwnerID>
            <v1:SessionID>?</v1:SessionID>
            <v1:Shipments>
                <!--Zero or more repetitions:-->
                <v1:ShippingMethodShipment> 
                    <v1:GiftMessage>?</v1:GiftMessage>  
                    <v1:ShipmentID>?</v1:ShipmentID>
                    <v1:ShippingCost>?</v1:ShippingCost>
                    <v1:ShippingMethodID>?</v1:ShippingMethodID>
                </v1:ShippingMethodShipment>
            </v1:Shipments>
        </v1:AddShippingMethodsToShipmentsRequest>
    </soap:Body>
</soap:Envelope>
eos

CONFIRM_AGE_GATE = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:ConfirmAgeGateRequest> 
            <v1:ClientChannel>?</v1:ClientChannel>
            <v1:Locale>?</v1:Locale>
            <v1:OwnerID>?</v1:OwnerID>
            <v1:SessionID>?</v1:SessionID>
        </v1:ConfirmAgeGateRequest>
    </soap:Body>
</soap:Envelope>
eos

ADD_TAX_TO_LINE_ITEMS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:AddTaxToLineItemsRequest> 
            <v1:ClientChannel>?</v1:ClientChannel> 
            <v1:LineItems>
                <!--Zero or more repetitions:-->
                <v1:LineItemTax> 
                    <v1:LineItemID>?</v1:LineItemID>
                    <v1:ShippingTax>?</v1:ShippingTax>   
                    <v1:Tax>?</v1:Tax>
                </v1:LineItemTax>
            </v1:LineItems>
            <v1:Locale>?</v1:Locale>
            <v1:OwnerID>?</v1:OwnerID>
            <v1:SessionID>?</v1:SessionID>
        </v1:AddTaxToLineItemsRequest>
    </soap:Body>
</soap:Envelope>
eos

ADD_PAYMENT_TO_PURCHASE_ORDER_WITH_CREDIT_CARD_PAYMENT_METHOD = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:AddPaymentToPurchaseOrderRequest>
            <v1:ClientChannel>?</v1:ClientChannel>
            <v1:Locale>?</v1:Locale>
            <v1:PaymentMethods>
                <!--Zero or more repetitions:-->
                <v1:PaymentMethod xsi:type="v1:CreditCardPaymentMethod" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">  
                    <v1:IsTokenized>?</v1:IsTokenized>
                    <v1:PaymentAccountNumber>?</v1:PaymentAccountNumber>
                    <v1:BillingAddress>  
                        <v1:AddressID>?</v1:AddressID>  
                        <v1:City>?</v1:City>
                        <v1:CountryCode>?</v1:CountryCode>
                        <v1:Line1>?</v1:Line1> 
                        <v1:Line2>?</v1:Line2>   
                        <v1:PostalCode>?</v1:PostalCode>  
                        <v1:State>?</v1:State> 
                        <v1:FirstName>?</v1:FirstName>
                        <v1:LastName>?</v1:LastName>
                    </v1:BillingAddress>
                    <v1:ExpirationMonth>?</v1:ExpirationMonth>
                    <v1:ExpirationYear>?</v1:ExpirationYear>
                    <v1:Type>?</v1:Type>
                </v1:PaymentMethod>
            </v1:PaymentMethods>
            <v1:PurchaseOrderOwnerId>?</v1:PurchaseOrderOwnerId>
            <v1:SessionID>?</v1:SessionID>
        </v1:AddPaymentToPurchaseOrderRequest>
    </soap:Body>
</soap:Envelope>
eos

GET_PURCHASE_ORDER = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:GetPurchaseOrderRequest>
            <v1:ClientChannel>?</v1:ClientChannel>
            <v1:Locale>?</v1:Locale>
            <v1:OwnerID>?</v1:OwnerID>
            <v1:SessionID>?</v1:SessionID>
			<v1:TargetingContext>
            <v1:Items>
               <v1:NameValueProperty>
                  <v1:Name>?</v1:Name>
                  <v1:Value>?</v1:Value>
               </v1:NameValueProperty>
            </v1:Items>
         </v1:TargetingContext>
        </v1:GetPurchaseOrderRequest>
    </soap:Body>
</soap:Envelope>
eos

GET_PLACED_ORDER = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:GetPlacedOrderRequest>
            <v1:ClientChannel>?</v1:ClientChannel>
            <v1:Locale>?</v1:Locale>
			<v1:OrderTrackingNumber></v1:OrderTrackingNumber>
            <v1:SessionID>?</v1:SessionID>
			<v1:TargetingContext>
				<v1:Items>
				   <v1:NameValueProperty>
					  <v1:Name>?</v1:Name>
					  <v1:Value>?</v1:Value>
				   </v1:NameValueProperty>
				</v1:Items>
			</v1:TargetingContext>
        </v1:GetPlacedOrderRequest>
    </soap:Body>
</soap:Envelope>
eos

GET_PURCHASE_ORDER_BY_TRACKING_NUMBER = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:GetPurchaseOrderByTrackingNumberRequest>
         <v1:ClientChannel>?</v1:ClientChannel>
         <v1:Locale>?</v1:Locale>
         <v1:OrderTrackingNumber>?</v1:OrderTrackingNumber>
         <v1:SessionID>?</v1:SessionID>
		 <v1:TargetingContext>
            <v1:Items>
               <v1:NameValueProperty>
                  <v1:Name>?</v1:Name>
                  <v1:Value>?</v1:Value>
               </v1:NameValueProperty>
            </v1:Items>
         </v1:TargetingContext>
      </v1:GetPurchaseOrderByTrackingNumberRequest>
   </soap:Body>
</soap:Envelope>
eos

PURCHASE_WITH_CREDIT_CARD = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1" xmlns:v11="http://gamestop.com/orders/checkout/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
   <wsa:To soap:mustUnderstand="1">?</wsa:To>
      <v1:SessionID>?</v1:SessionID>
      <v1:Locale>?</v1:Locale>
      <v1:ClientChannel>?</v1:ClientChannel>
   <wsa:Action soap:mustUnderstand="1">http://gamestop.com/orders/purchaseorder/v1/Purchase</wsa:Action></soap:Header>
   <soap:Body>
      <v11:PurchaseRequest>
         <v1:CreditCard>
            <v1:IsTokenized>?</v1:IsTokenized>
            <v1:IsWalletPaymentMethod>?</v1:IsWalletPaymentMethod>
            <v1:PaymentAccountNumber>?</v1:PaymentAccountNumber>
            <v1:BillingAddress>
               <v1:AddressID>?</v1:AddressID>
               <v1:City>?</v1:City>
               <v1:CountryCode>?</v1:CountryCode>
               <v1:FormatValidated>?</v1:FormatValidated>
               <v1:Line1>?</v1:Line1>
               <v1:Line2>?</v1:Line2>
               <v1:PostalCode>?</v1:PostalCode>
               <v1:State>?</v1:State>
               <v1:FirstName>?</v1:FirstName>
               <v1:LastName>?</v1:LastName>
            </v1:BillingAddress>
            <v1:CSC>?</v1:CSC>
            <v1:ExpirationMonth>?</v1:ExpirationMonth>
            <v1:ExpirationYear>?</v1:ExpirationYear>
            <v1:Type>?</v1:Type>
         </v1:CreditCard>
         <v1:DeviceFingerprint>?</v1:DeviceFingerprint>
         <v1:ElectronicAccount>?</v1:ElectronicAccount>
         <v1:PurchaseOrderOwnerID>?</v1:PurchaseOrderOwnerID>
         <v1:ShippingAddressHasChanged>?</v1:ShippingAddressHasChanged>
         <v1:StoredValuePaymentMethods>?</v1:StoredValuePaymentMethods>
         <v1:TargetingContext>
            <v1:Items>
               <v1:NameValueProperty>
                  <v1:Name>?</v1:Name>
                  <v1:Value>?</v1:Value>
               </v1:NameValueProperty>
            </v1:Items>
         </v1:TargetingContext>
      </v11:PurchaseRequest>
   </soap:Body>
</soap:Envelope>
eos

PURCHASE_WITH_CREDIT_CARD_OLD = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1" xmlns:v11="http://gamestop.com/orders/checkout/v1" xmlns:gam="http://schemas.datacontract.org/2004/07/GameStop.Ecom.Orders.Messages.PurchaseOrder.v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
      <v1:SessionID>?</v1:SessionID>
      <v1:Locale>?</v1:Locale>
      <v1:ClientChannel>?</v1:ClientChannel>
	  <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
      <wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v11:PurchaseRequest>
         <v1:CreditCard>
            <v1:BillingAddress>?</v1:BillingAddress>
            <v1:IsTokenized>?</v1:IsTokenized>
            <v1:IsWalletPaymentMethod>?</v1:IsWalletPaymentMethod>
            <v1:PaymentAccountNumber>?</v1:PaymentAccountNumber>
            <v1:CSC>?</v1:CSC> 
            <v1:ExpirationMonth>?</v1:ExpirationMonth>
            <v1:ExpirationYear>?</v1:ExpirationYear>
            <v1:Type>?</v1:Type>
         </v1:CreditCard>
         <v1:ElectronicAccount>?</v1:ElectronicAccount>
		 <v1:PurchaseOrderOwnerID>?</v1:PurchaseOrderOwnerID>
     <v1:ShippingAddressHasChanged>?</v1:ShippingAddressHasChanged>
     <v1:StoredValuePaymentMethods>?</v1:StoredValuePaymentMethods>
     <v1:DeviceFingerprint>?</v1:DeviceFingerprint>
			<v1:TargetingContext>
				<v1:Items>
					<v1:NameValueProperty>
					  <v1:Name>?</v1:Name>
					  <v1:Value>?</v1:Value>
					</v1:NameValueProperty>
				</v1:Items>
			</v1:TargetingContext>
      </v11:PurchaseRequest>
   </soap:Body>
</soap:Envelope>
eos

PURCHASE_WITH_SVS_CARD = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1" xmlns:v11="http://gamestop.com/orders/checkout/v1" xmlns:gam="http://schemas.datacontract.org/2004/07/GameStop.Ecom.Orders.Messages.PurchaseOrder.v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
      <v1:SessionID>?</v1:SessionID>
      <v1:Locale>?</v1:Locale>
      <v1:ClientChannel>?</v1:ClientChannel>
	  <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
      <wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v11:PurchaseRequest>
		 <v1:PurchaseOrderOwnerID>?</v1:PurchaseOrderOwnerID>
         <v1:StoredValuePaymentMethods>
            <!--Zero or more repetitions:-->
            <v1:StoredValuePaymentMethod>
				<v1:IsTokenized>?</v1:IsTokenized>
				<v1:IsWalletPaymentMethod>?</v1:IsWalletPaymentMethod>
				<v1:PaymentAccountNumber>?</v1:PaymentAccountNumber>
				<v1:Pin>?</v1:Pin>
			</v1:StoredValuePaymentMethod>
         </v1:StoredValuePaymentMethods>
		<v1:TargetingContext>
			<v1:Items>
				<v1:NameValueProperty>
				<v1:Name>?</v1:Name>
				<v1:Value>?</v1:Value>
				</v1:NameValueProperty>
			</v1:Items>
		</v1:TargetingContext>
      </v11:PurchaseRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_ASSEMBLY_INFO = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
	<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
	<wsa:Action soap:mustUnderstand="1">http://gamestop.com/orders/purchaseorder/v1/GetAssemblyInfo</wsa:Action>
	<wsa:To soap:mustUnderstand="1">?</wsa:To>
	</soap:Header>
	<soap:Body>
	<v1:GetAssemblyInfo/>
	</soap:Body>
	</soap:Envelope>
eos

GET_STORED_VALUE_BALANCE = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/purchaseorder/v1">
	     <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
        </soap:Header>
	   <soap:Body>
		  <v1:GetStoredValueBalanceRequest>
			 <v1:ClientChannel>?</v1:ClientChannel>
			 <v1:SessionID>?</v1:SessionID>
			 <v1:StoredBalanceCards>
				<v1:StoredValuePaymentMethod>
				   <v1:IsTokenized>?</v1:IsTokenized>
				   <v1:IsWalletPaymentMethod>?</v1:IsWalletPaymentMethod>
				   <v1:PaymentAccountNumber>?</v1:PaymentAccountNumber>
				   <v1:Pin>?</v1:Pin>
				</v1:StoredValuePaymentMethod>
			 </v1:StoredBalanceCards>
		  </v1:GetStoredValueBalanceRequest>
	   </soap:Body>
	</soap:Envelope>
eos
end

module ShippingServiceRequestTemplates

GET_AVAILABLE_SHIPPING_METHODS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/fulfillment/shipping/v1" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays"
xmlns:gam="http://schemas.datacontract.org/2004/07/GameStop.Ecom.Orders.Messages.PurchaseOrder.v1" xmlns:v11="http://gamestop.com/orders/purchaseorder/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <v1:SessionID>?</v1:SessionID>
        <v1:Locale>?</v1:Locale>
        <v1:ClientChannel>?</v1:ClientChannel>
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:GetAvailableShippingMethodsRequest>
            <!--Optional:-->
            <v1:CustomerID>?</v1:CustomerID>
            <!--Optional:-->
            <v1:CustomerLoyaltyNumber>?</v1:CustomerLoyaltyNumber>
            <!--Optional:-->
            <v1:Promocodes>
                <!--Zero or more repetitions:-->
                <arr:string>?</arr:string>
            </v1:Promocodes>
            <!--Optional:-->
            <v1:Shipments>
                <!--Zero or more repetitions:-->
                <v1:Shipment>
                    <!--Optional:-->
                    <v1:LineItems>
                        <!--Zero or more repetitions:-->
                        <v1:LineItem>
                            <!--Optional:-->
                            <v1:LineItemID>?</v1:LineItemID>
                            <!--Optional:-->
                            <v1:ListPrice>?</v1:ListPrice>
                            <!--Optional:-->
                            <v1:Quantity>?</v1:Quantity>
                            <!--Optional:-->
                            <v1:Sku>?</v1:Sku>
                        </v1:LineItem>
                    </v1:LineItems>
                    <!--Optional:-->
                    <v1:ShipTo>
                        <!--Optional:-->
                        <v1:AddressID>?</v1:AddressID>
                        <!--Optional:-->
                        <v1:City>?</v1:City>
                        <!--Optional:-->
                        <v1:CountryCode>?</v1:CountryCode>
                        <!--Optional:-->
                        <v1:Line1>?</v1:Line1>
                        <!--Optional:-->
                        <v1:Line2>?</v1:Line2>
                        <!--Optional:-->
                        <v1:PostalCode>?</v1:PostalCode>
                        <!--Optional:-->
                        <v1:State>?</v1:State>
                    </v1:ShipTo>
                    <!--Optional:-->
                    <v1:ShipmentID>?</v1:ShipmentID>
                    <!--Optional:-->
                    <v1:ShipmentType>?</v1:ShipmentType>
                </v1:Shipment>
            </v1:Shipments>
			<v1:TargetingContext>
               <v1:Items>
                    <v1:NameValueProperty>
					     <v1:Name>?</v1:Name>
						 <v1:Value>?</v1:Value>
                    </v1:NameValueProperty>
                </v1:Items>
            </v1:TargetingContext>
        </v1:GetAvailableShippingMethodsRequest>
    </soap:Body>
</soap:Envelope>
eos

GET_ASSEMBLY_INFO = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/fulfillment/shipping/v1">
	<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
	<wsa:Action soap:mustUnderstand="1">http://gamestop.com/orders/shipping/v1/GetAssemblyInfo</wsa:Action>
	<wsa:To soap:mustUnderstand="1">?</wsa:To>
	</soap:Header>
	<soap:Body>
	<v1:GetAssemblyInfo/>
	</soap:Body>
	</soap:Envelope>
eos
end

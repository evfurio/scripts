module TaxServiceRequestTemplates

CALCULATE_TAX = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/tax/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:CalculateTaxRequest>
            <!--Optional:-->
            <v1:ClientChannel>?</v1:ClientChannel>
            <!--Optional:-->
            <v1:ClientCountry>?</v1:ClientCountry>
            <!--Optional:-->
            <v1:ClientTransactionNumber>?</v1:ClientTransactionNumber>
            <!--Optional:-->
            <v1:Currency>?</v1:Currency>
            <!--Optional:-->
            <v1:SessionId>?</v1:SessionId>
            <!--Optional:-->
            <v1:Shipments>
                <!--Zero or more repetitions:-->
                <v1:Shipment>
                    <!--Optional:-->
                    <v1:BillTo>
                        <!--Optional:-->
                        <v1:AddressId>?</v1:AddressId>
                        <!--Optional:-->
                        <v1:City>?</v1:City>
                        <!--Optional:-->
                        <v1:CountryCode>?</v1:CountryCode>
                        <!--Optional:-->
                        <v1:County>?</v1:County>
                        <!--Optional:-->
                        <v1:Line1>?</v1:Line1>
                        <!--Optional:-->
                        <v1:Line2>?</v1:Line2>
                        <!--Optional:-->
                        <v1:PostalCode>?</v1:PostalCode>
                        <!--Optional:-->
                        <v1:State>?</v1:State>
                    </v1:BillTo>
                    <!--Optional:-->
                    <v1:LineItems>
                        <!--Zero or more repetitions:-->
                        <v1:LineItem>
                            <!--Optional:-->
                            <v1:Description>?</v1:Description>
                            <!--Optional:-->
                            <v1:LineItemId>?</v1:LineItemId>
                            <!--Optional:-->
                            <v1:Quantity>?</v1:Quantity>
                            <!--Optional:-->
                            <v1:ShippingCost>?</v1:ShippingCost>
                            <!--Optional:-->
                            <v1:ShippingTax>?</v1:ShippingTax>
                            <!--Optional:-->
                            <v1:Sku>?</v1:Sku>
                            <!--Optional:-->
                            <v1:Tax>?</v1:Tax>
                            <!--Optional:-->
                            <v1:TaxabilityCode>?</v1:TaxabilityCode>
                            <!--Optional:-->
                            <v1:UnitPriceWithDiscounts>?</v1:UnitPriceWithDiscounts>
                        </v1:LineItem>
                    </v1:LineItems>
                    <!--Optional:-->
                    <v1:PurchaseDate>?</v1:PurchaseDate>
                    <!--Optional:-->
                    <v1:ShipTo>
                        <!--Optional:-->
                        <v1:AddressId>?</v1:AddressId>
                        <!--Optional:-->
                        <v1:City>?</v1:City>
                        <!--Optional:-->
                        <v1:CountryCode>?</v1:CountryCode>
                        <!--Optional:-->
                        <v1:County>?</v1:County>
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
                    <v1:ShipmentId>?</v1:ShipmentId>
                    <!--Optional:-->
                    <v1:ShippingCost>?</v1:ShippingCost>
                    <!--Optional:-->
                    <v1:ShippingTax>?</v1:ShippingTax>
                    <!--Optional:-->
                    <v1:Tax>?</v1:Tax>
                </v1:Shipment>
            </v1:Shipments>
        </v1:CalculateTaxRequest>
    </soap:Body>
</soap:Envelope>
eos

GET_ASSEMBLY_INFO = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/tax/v1">
		<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:Action soap:mustUnderstand="1">http://gamestop.com/orders/tax/v1/GetAssemblyInfo</wsa:Action>
			<wsa:To soap:mustUnderstand="1">?</wsa:To>
		</soap:Header>
		<soap:Body>
			<v1:GetAssemblyInfo/>
		</soap:Body>
	</soap:Envelope>
eos

end


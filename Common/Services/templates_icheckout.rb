module ICheckoutServiceRequestTemplates

PURCHASE = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/checkout/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <v1:SessionID>?</v1:SessionID>
        <v1:Locale>?</v1:Locale>
        <v1:ClientChannel>?</v1:ClientChannel>
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:PurchaseRequest>
            <!--Optional:-->
            <v1:PurchaseOrderOwnerID>?</v1:PurchaseOrderOwnerID>
        </v1:PurchaseRequest>
    </soap:Body>
</soap:Envelope>
eos


end

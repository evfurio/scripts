module CartServiceRequestTemplates

ADD_PRODUCTS_TO_CART = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:AddProductsToCartRequest>
            <v1:ClientChannel>?</v1:ClientChannel>
            <v1:Locale>en-US</v1:Locale>
            <v1:OwnerID>?</v1:OwnerID>
            <v1:Products>
                <!--Zero or more repetitions:-->
                <v1:Product>
                    <v1:Quantity>?</v1:Quantity>
                    <v1:Sku>?</v1:Sku>
                </v1:Product>
            </v1:Products>
            <v1:SessionID>?</v1:SessionID>
        </v1:AddProductsToCartRequest>
    </soap:Body>
</soap:Envelope>
eos

GET_CART = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:GetCartRequest>
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
        </v1:GetCartRequest>
    </soap:Body>
</soap:Envelope>
eos

REMOVE_PRODUCTS_FROM_CART = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:RemoveProductsFromCartRequest>
            <v1:ClientChannel>?</v1:ClientChannel>
            <v1:LineItemIDs>
                <!--Zero or more repetitions:-->
                <arr:guid>?</arr:guid>
            </v1:LineItemIDs>
            <v1:Locale>?</v1:Locale>
            <v1:OwnerID>?</v1:OwnerID>
            <v1:SessionID>?</v1:SessionID>
        </v1:RemoveProductsFromCartRequest>
    </soap:Body>
</soap:Envelope>
eos

ADD_PROMOTIONS_TO_CART = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:AddPromotionsToCartRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:Locale>?</v1:Locale>
         <!--Optional:-->
         <v1:OwnerID>?</v1:OwnerID>
         <!--Optional:-->
         <v1:Promotions>
            <!--Zero or more repetitions:-->
            <v1:Promotion>
               <!--Optional:-->
               <v1:Code>?</v1:Code>
            </v1:Promotion>
         </v1:Promotions>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
      </v1:AddPromotionsToCartRequest>
   </soap:Body>
</soap:Envelope>
eos

ADD_STORED_VALUE_PRODUCTS_TO_CART = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:AddStoredValueProductsToCartRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:Locale>?</v1:Locale>
         <!--Optional:-->
         <v1:OwnerID>?</v1:OwnerID>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
         <!--Optional:-->
         <v1:StoredValueProducts>
            <!--Zero or more repetitions:-->
            <v1:StoredValueProduct>
               <!--Optional:-->
               <v1:Amount>?</v1:Amount>
               <!--Optional:-->
               <v1:Quantity>?</v1:Quantity>
               <!--Optional:-->
               <v1:Sku>?</v1:Sku>
            </v1:StoredValueProduct>
         </v1:StoredValueProducts>
      </v1:AddStoredValueProductsToCartRequest>
   </soap:Body>
</soap:Envelope>
eos

APPLY_LOYALTY_NUMBER_TO_CART = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:ApplyLoyaltyNumberToCartRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:Locale>?</v1:Locale>
         <!--Optional:-->
         <v1:LoyaltyNumber>?</v1:LoyaltyNumber>
         <!--Optional:-->
         <v1:OwnerID>?</v1:OwnerID>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
      </v1:ApplyLoyaltyNumberToCartRequest>
   </soap:Body>
</soap:Envelope>
eos

CONFIRM_AGE_GATE = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:ConfirmAgeGateRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:Locale>?</v1:Locale>
         <!--Optional:-->
         <v1:OwnerID>?</v1:OwnerID>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
      </v1:ConfirmAgeGateRequest>
   </soap:Body>
</soap:Envelope>
eos

MIGRATE_CART = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:MigrateCartRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:Locale>?</v1:Locale>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
         <!--Optional:-->
         <v1:SourceOwnerID>?</v1:SourceOwnerID>
         <!--Optional:-->
         <v1:TargetOwnerID>?</v1:TargetOwnerID>
      </v1:MigrateCartRequest>
   </soap:Body>
</soap:Envelope>
eos


MODIFY_LINE_ITEM_FULFILLMENT_CHANNELS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:ModifyLineItemFulfillmentChannelsRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:FulfillmentChannelModifications>
            <!--Zero or more repetitions:-->
            <v1:FulfillmentChannelModification>
               <!--Optional:-->
               <v1:Channel>?</v1:Channel>
               <!--Optional:-->
               <v1:LineItemID>?</v1:LineItemID>
            </v1:FulfillmentChannelModification>
         </v1:FulfillmentChannelModifications>
         <!--Optional:-->
         <v1:Locale>?</v1:Locale>
         <!--Optional:-->
         <v1:OwnerID>?</v1:OwnerID>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
      </v1:ModifyLineItemFulfillmentChannelsRequest>
   </soap:Body>
</soap:Envelope>
eos

MODIFY_LINE_ITEM_QUANTITIES = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:ModifyLineItemQuantitiesRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:Locale>?</v1:Locale>
         <!--Optional:-->
         <v1:OwnerID>?</v1:OwnerID>
         <!--Optional:-->
         <v1:QuantityModifications>
            <!--Zero or more repetitions:-->
            <v1:QuantityModification>
               <!--Optional:-->
               <v1:LineItemID>?</v1:LineItemID>
               <!--Optional:-->
               <v1:Quantity>?</v1:Quantity>
            </v1:QuantityModification>
         </v1:QuantityModifications>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
      </v1:ModifyLineItemQuantitiesRequest>
   </soap:Body>
</soap:Envelope>
eos

REMOVE_LOYALTY_NUMBER_FROM_CART = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:RemoveLoyaltyNumberFromCartRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:Locale>?</v1:Locale>
         <!--Optional:-->
         <v1:OwnerID>?</v1:OwnerID>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
      </v1:RemoveLoyaltyNumberFromCartRequest>
   </soap:Body>
</soap:Envelope>
eos

REMOVE_PROMOTIONS_FROM_CART = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:RemovePromotionsFromCartRequest>
         <!--Optional:-->
         <v1:ClientChannel>?</v1:ClientChannel>
         <!--Optional:-->
         <v1:Locale>?</v1:Locale>
         <!--Optional:-->
         <v1:OwnerID>?</v1:OwnerID>
         <!--Optional:-->
         <v1:Promotions>
            <!--Zero or more repetitions:-->
            <v1:Promotion>
               <!--Optional:-->
               <v1:Code>?</v1:Code>
            </v1:Promotion>
         </v1:Promotions>
         <!--Optional:-->
         <v1:SessionID>?</v1:SessionID>
      </v1:RemovePromotionsFromCartRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_ASSEMBLY_INFO = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/orders/cart/v1">
	<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
	<wsa:Action soap:mustUnderstand="1">http://gamestop.com/orders/cart/v1/GetAssemblyInfo</wsa:Action>
	<wsa:To soap:mustUnderstand="1">?</wsa:To>
	</soap:Header>
	<soap:Body>
	<v1:GetAssemblyInfo/>
	</soap:Body>
	</soap:Envelope>
eos
end

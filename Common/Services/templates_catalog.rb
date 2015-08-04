module CatalogServiceRequestTemplates

GET_PRODUCTS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/merchandising/catalog/v1" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
    <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
        <wsa:To soap:mustUnderstand="1">?</wsa:To>
    </soap:Header>
    <soap:Body>
        <v1:GetProductsRequest>
            <v1:ClientChannel>?</v1:ClientChannel>
            <v1:Locale>?</v1:Locale>
            <v1:SessionID>?</v1:SessionID>
            <v1:Skus>
                <!--Zero or more repetitions:-->
                <arr:string>?</arr:string>
            </v1:Skus>
        </v1:GetProductsRequest>
    </soap:Body>
</soap:Envelope>
eos

GET_INVENTORY_LEVEL = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/merchandising/catalog/v1" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:GetInventoryLevelRequest>
         <v1:ClientChannel>?</v1:ClientChannel>
         <v1:Locale>?</v1:Locale>
         <v1:SessionID>?</v1:SessionID>
         <v1:Skus>
            <arr:string>?</arr:string>
         </v1:Skus>
      </v1:GetInventoryLevelRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_PRODUCT_LIST_BY_WILD_CARD = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/merchandising/catalog/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:GetWildCardResultRequest>
         <v1:ClientChannel>?</v1:ClientChannel>
         <v1:Locale>?</v1:Locale>
         <v1:NoOfProductsToBeDisplayed>?</v1:NoOfProductsToBeDisplayed>
         <v1:onlineOnly>?</v1:onlineOnly>
         <v1:terms>?</v1:terms>
      </v1:GetWildCardResultRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_PRODUCT_VARIANT_BY_SKU = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/merchandising/catalog/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <v1:GetProductVariantBySKURequest>
         <v1:ClientChannel>?</v1:ClientChannel>
         <v1:Locale>?</v1:Locale>
         <v1:SKU>?</v1:SKU>
      </v1:GetProductVariantBySKURequest>
   </soap:Body>
</soap:Envelope>
eos

GET_PRODUCT_RECOMMENDATIONS = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/merchandising/catalog/v1">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
		<wsa:Action soap:mustUnderstand="1">?</wsa:Action>
		<wsa:To soap:mustUnderstand="1">?</wsa:To>   
   </soap:Header>
   <soap:Body>
      <v1:GetProductRecomendationRequest>
         <v1:ClientChannel>?</v1:ClientChannel>
         <v1:Locale>?</v1:Locale>
         <v1:NumberOfRecomendations>?</v1:NumberOfRecomendations>
         <v1:OnlineOnly>?</v1:OnlineOnly>
      </v1:GetProductRecomendationRequest>
   </soap:Body>
</soap:Envelope>
eos

GET_PRODUCTS_BY_SEARCH = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/merchandising/catalog/v1">
	<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action soap:mustUnderstand="1">http://gamestop.com/merchandising/catalog/v1/GetProductsBySearch</wsa:Action>
	<wsa:To soap:mustUnderstand="1">?</wsa:To>
	</soap:Header>
	<soap:Body>
      <v1:GetProductsBySearchRequest>
         <v1:ClientChannel>?</v1:ClientChannel>
         <v1:IsInStock>?</v1:IsInStock>
         <v1:IsOnlineOnly>?</v1:IsOnlineOnly>
         <v1:Locale>?</v1:Locale>
         <v1:PageIndex>?</v1:PageIndex>
         <v1:PageSize>?</v1:PageSize><v1:SearchFilters>
            <v1:SearchFilter>
               <!--type: FilterType - enumeration: [Category,Condition,Availability,ESRB,Platform,Price,Rating,Products]-->
               <v1:FilterType>?</v1:FilterType>
               <v1:FilterValues>?</v1:FilterValues>
            </v1:SearchFilter>
         </v1:SearchFilters>
         <v1:SearchTerm>?</v1:SearchTerm>
         <v1:SortKey>?</v1:SortKey>
         <!--type: SortOrder - enumeration: [Ascending,Descending]-->
         <v1:SortOrder>?</v1:SortOrder>
      </v1:GetProductsBySearchRequest>
	</soap:Body>
	</soap:Envelope>
eos

GET_ASSEMBLY_INFO = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/merchandising/catalog/v1">
	<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
	<wsa:Action soap:mustUnderstand="1">http://gamestop.com/merchandising/catalog/v1/GetAssemblyInfo</wsa:Action>
	<wsa:To soap:mustUnderstand="1">?</wsa:To>
	</soap:Header>
	<soap:Body>
	<v1:GetAssemblyInfo/>
	</soap:Body>
	</soap:Envelope>
eos

GET_NAVIGATION_FILTER_BY_TYPE = <<eos
	<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/merchandising/catalog/v1">
		 <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
				<wsa:Action soap:mustUnderstand="1">http://gamestop.com/merchandising/catalog/v1/GetNavigationFilterByType</wsa:Action>
				<wsa:To soap:mustUnderstand="1">?</wsa:To>
		 </soap:Header>
		 <soap:Body>
				<v1:GetNavigationFilterByTypeRequest>
					 <v1:ClientChannel>?</v1:ClientChannel>
					 <v1:FilterType>?</v1:FilterType>
					 <v1:Locale>?</v1:Locale>
				</v1:GetNavigationFilterByTypeRequest>
		 </soap:Body>
	</soap:Envelope>
eos
end

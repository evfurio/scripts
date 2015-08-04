qaautomation_dir = ENV['QAAUTOMATION_FILES']
require "#{qaautomation_dir}/dsl/GameStop/src/Services/game_stop_services_requires"

# Returns request xml for get_adjusted_line_item_prices_request, single item
# === Parameters:
# _sku_obj_:: object containing :session_id, :customer_id, :customer_loyalty_number, :line_item_id, :product_type, :quantity, :shipping_option, :requested_promo_code, :sku, :price_result
def get_adjusted_line_item_prices_request_xml(sku_obj)
    xml_template = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:v1="http://gamestop.com/merchandising/pricing/v1" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
      <v1:SessionId>#{sku_obj.session_id}</v1:SessionId>
      <v1:Locale>en-US</v1:Locale>
      <v1:ClientChannel>GS_US</v1:ClientChannel>
    <wsa:Action soap:mustUnderstand="1">http://gamestop.com/merchandising/pricing/v1/GetAdjustedPrice</wsa:Action><wsa:To soap:mustUnderstand="1">http://qa.services.gamestop.com/Ecom/Merchandising/Pricing/v1/PricingService.svc</wsa:To>
	</soap:Header>
   <soap:Body>
      <v1:GetAdjustedLineItemPricesRequest>
         <!--Optional:-->
         <v1:CustomerID>#{sku_obj.customer_id}</v1:CustomerID>
         <!--Optional:-->
         <v1:CustomerLoyaltyNumber>#{sku_obj.customer_loyalty_number}</v1:CustomerLoyaltyNumber>
         <!--Optional:-->
         <v1:LineItems>
            <!--Zero or more repetitions:-->
            <v1:PricingLineItem>
               <!--Optional:-->
               <v1:GiftAmount xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>
               <v1:LineItemID>#{sku_obj.line_item_id}</v1:LineItemID>
               <v1:ProductType>#{sku_obj.product_type}</v1:ProductType>
               <v1:Quantity>#{sku_obj.quantity}</v1:Quantity>
               <v1:ShippingOption>#{sku_obj.shipping_option}</v1:ShippingOption>
               <v1:Sku>#{sku_obj.sku}</v1:Sku>
            </v1:PricingLineItem>
         </v1:LineItems>
         <!--Optional:-->
         <v1:RequestedPromoCodes>
                <arr:string>#{sku_obj.requested_promo_code}</arr:string>
         </v1:RequestedPromoCodes>
      </v1:GetAdjustedLineItemPricesRequest>
   </soap:Body>
</soap:Envelope>
eos

    return xml_template
end


describe "GameStop SOAP Pricing Service get_adjusted_line_item_prices Test" do
### Struct is still required but I'd like the sku_array to be populated by either database or csv.
### in this case I'd like to use csv.

    # Create a Pricing structure to store data
    Sku = Struct.new("Sku", :session_id, :customer_id, :customer_loyalty_number, :line_item_id, :product_type, :quantity, :shipping_option, :requested_promo_code, :sku, :price_result)

    # Create instances of the Pricing structure and add data, placing each instance into the array 
    @sku_array = []
    @sku_array << Sku.new(generate_guid, generate_guid, "3875345620001", generate_guid, "Product", "1", "ShipToAddress", "welcome", "270434", "5.99")
    @sku_array << Sku.new(generate_guid, generate_guid, "3875345620001", generate_guid, "Product", "1", "ShipToAddress", "welcome", "270434", "2.99")


    before(:all) do
        $tracer.mode = :on
        $tracer.echo = :on

        # instantiate PricingService
        @client = PricingService.new("http://qa.services.gamestop.com/Ecom/Merchandising/Pricing/v1/PricingService.svc?wsdl")
    end

    it "should contain get_adjusted_line_item_prices operation" do
        @client.operations.include?(:get_adjusted_line_item_prices).should be_true
    end

    # Loop pricing sku array
    @sku_array.each do |item|
        it "should request line item price for sku #{item.sku}" do

            # Generate request xml, and call get_adjusted_line_item_price operation on the service
            request_xml = get_adjusted_line_item_prices_request_xml()
            response = @client.get_adjusted_line_item_prices(request_xml)

            # places response message in xml form into trace file
            $tracer.trace(response.body.raw)

            # verify http response status
            response.code.should == 200

			puts response.to_s
            adjusted_item = response.body.find_tag("adjusted_line_item").at(0)
            # alternative to above find_tag():  adjusted_item = response.body.get_adjusted_line_item_prices_reply.line_items.adjusted_line_item.at(0)

            adjusted_item.line_item_id.content.should == item.line_item_id
            adjusted_item.adjusted_line_item_subtotal.content.should == item.price_result
            adjusted_item.line_item_discount_amount.content.should == "0"
            adjusted_item.line_item_subtotal.content.should == item.price_result
            adjusted_item.list_price.content.should == item.price_result
            adjusted_item.product_type.content.should == item.product_type
            adjusted_item.quantity.content.should == item.quantity
            adjusted_item.shipping_option.content.should == item.shipping_option
            adjusted_item.sku.content.should == item.sku


            unapplied_discounts = response.body.find_tag("discount").at(0)
            # alternative to above find_tag():  unapplied_discounts = response.body.get_adjusted_line_item_prices_reply.unapplied_discounts.discount.at(0)

            unapplied_discounts.discount_name.content.should match /#{item.requested_promo_code}/i
            unapplied_discounts.promo_code.content.should match /#{item.requested_promo_code}/i

        end
    end
end




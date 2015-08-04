#################################################################################################################
###This script is used to checkout single or multiple available Pre-owned games by applying PUR number
#################################################################################################################
###USAGE NOTES
### This script can be run for 3 different scenarios. 1. Appy pro PUR for lineitem discount and points, 2. Apply free PUR for only points 3. Apply expired pro pur for only points
### Run this script using the following commands for single or multi cart checkout

###  **Pro PUR member, lineitem discount is applied and points are applied.
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\Services\Checkout\WIS_Checkout_with_PUR.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\Services\Checkout\wis_checkout_dataset.csv --range "TFS46297"  --or
###
###  **Free PUR member, NO lineitem discount is applied. Only points are applied
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\Services\Checkout\WIS_Checkout_with_PUR.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\Services\Checkout\wis_checkout_dataset.csv --range "TFS46299"  --or

###  **Expired pro PUR member, NO lineitem discount is applied. Only points are applied
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\Services\Checkout\WIS_Checkout_with_PUR.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\Services\Checkout\wis_checkout_dataset.csv --range "TFS46301"  --or


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

describe "WIS Checkout Scenario Tests" do

    before(:all) do
#We will initialize our connections and data sets for the test by taking the option parameters passed by the command line 
        $tracer.mode = :on
        $tracer.echo = :on
	end

    before(:each) do	
		#get the --csv parameter and read the file, --range identifies the row of data to use per test case
		#range will now define the TFS ID to use in relation to the MTM test case created.	
		
		csv = QACSV.new(csv_filename_parameter)
		@row = csv.find_row_by_name(csv_range_parameter)
		
		#initialize the services to be used for the test
		@global_functions = GlobalServiceFunctions.new()
		@global_functions.csv = @row
		@global_functions.parameters
		#@global_functions.csv_params
		@sql = @global_functions.sql_file
		@db = @global_functions.db_conn
		@cart_svc, @cart_svc_version = @global_functions.cart_svc
		#@account_svc = @global_functions.account_svc  --not needed for WIS orders since they are guest orders only
		@purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
		@shipping_svc, @shipping_svc_version = @global_functions.shipping_svc
		@tax_svc, @tax_svc_version = @global_functions.tax_svc
		@store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc
		@digital_content_svc, @digital_content_svc_version = @global_functions.digitalcontent_svc
		
#generate a new session id and owner id guid.  the generate_guid function uses uuidtools to generate guids on the fly.
        @session_id = generate_guid
		@owner_id = generate_guid
		
#get results from the sql file
		sql = @sql.to_s
		@results_from_file = @db.exec_sql_from_file(sql) 
		
		#set instance variables for csv driven data elements
		initialize_csv_params
		
		#checks to ensure the cart is empty before proceeding
        @cart_svc.perform_empty_cart(@session_id, @owner_id, @client_channel, @locale, @cart_svc_version)
    end
	
	
#[TestMethod]
    it "should Checkout using dataset defined" do
	
#Add products to cart
		#set the variantid's from the query results
		@calculated_shipping_cost = 0
		@total_tax = 0
		sku_qty_list = []
		
		@results_from_file.each_with_index do |sku, i|
		   			# statement you see below is called ternary operation (?:). It's equivalent to the if/esle statement . The bellow can be wrirren as 
			# qty = o 
			# if  i == 2
			#     qty = 1 + @qty_increase.to_i  
			# else
			#     qty = 1
			# end
			qty = i == 2 ? 1 + @qty_increase.to_i : 1 
		    sku_qty_list.push(sku.SKU,qty) 
		end
		
		@cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list, @client_channel, @locale, @cart_svc_version)
		#apply free value shipping discount promo code
		add_promotion_to_cart_result = @cart_svc.perform_add_promotions_to_cart_and_return_message(@session_id, @owner_id, @promo_code, @client_channel, @locale, @cart_svc_version)
		#verify that promo code is applied to the cart successfully
		add_promotion_to_cart_result.should == "Added"
		
		#apply pro PUR number to the cart
		response = @cart_svc.perform_apply_loyalty_number_to_cart(@session_id, @owner_id, @loyalty_card_number, @client_channel, @locale, @cart_svc_version)
		
		discount_result = response.http_body.find_tag("apply_loyalty_for_discount_result").at(0).content
		$tracer.trace("---------Discount Result :: #{discount_result}")
		points_result = response.http_body.find_tag("apply_loyalty_for_points_result").at(0).content
		
		#Discount is applied only for pro pur and the value would be 'Applied'. For free pur, result would be 'NotQualified' and for expired pur, result would be 'Expired'. 
		#Threfore checking for any of these 3 values since the same script runs for different types of PURs.
		discount_result_status = ['Applied','NotQualified','Expired']
		discount_result_status.include?(discount_result).should == true
		#points should be applied for any pur including free and expired
		points_result.should == 'Applied'
		
        ######################
        ### PURCHASE ORDER ###
        ######################

        ### CREATE_PURCHASE_ORDER_FROM_CART ###

        create_purchase_order_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:create_purchase_order_from_cart, PurchaseOrderServiceRequestTemplates.const_get("CREATE_PURCHASE_ORDER_FROM_CART#{@purchase_order_svc_version}"))

        create_purchase_order_data = create_purchase_order_req.find_tag("create_purchase_order_from_cart_request").at(0)
        create_purchase_order_data.session_id.content = @session_id
        create_purchase_order_data.owner_id.content = @owner_id
		create_purchase_order_data.client_channel.content = @client_channel
		
		create_purchase_order_data.targeting_context.items.name_value_property.remove_self

        $tracer.trace(create_purchase_order_req.formatted_xml)

        create_purchase_order_rsp = @purchase_order_svc.create_purchase_order_from_cart(create_purchase_order_req.xml)

        create_purchase_order_rsp.code.should == 200

        $tracer.trace(create_purchase_order_rsp.http_body.formatted_xml)

        # hold this for later comparisons, etc
        create_purchase_cart_items = create_purchase_order_rsp.http_body.find_tag("line_items").at(0)

        ### ADD_CHANNEL_ATTRIBUTES_TO_PURCHASE_ORDER ###

        add_channel_attributes_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_channel_attributes_to_purchase_order, PurchaseOrderServiceRequestTemplates.const_get("ADD_CHANNEL_ATTRIBUTES_TO_PURCHASE_ORDER_WITH_ONLINE_CHANNEL_SPECIFIC_DATA#{@purchase_order_svc_version}"))

        add_channel_attributes_req.find_tag("session_id").at(0).content = @session_id  # oddly found in header
        add_channel_attributes_req.find_tag("owner_id").at(0).content = @owner_id
		add_channel_attributes_req.find_tag("client_channel").at(0).content = @client_channel
        channel_attributes_data = add_channel_attributes_req.find_tag("channel_attributes").at(0)
        channel_attributes_data.brand.content = @brand
        channel_attributes_data.client_ip.content = get_ip
        channel_attributes_data.geo_latitude.remove_self
        channel_attributes_data.geo_longitude.remove_self

        $tracer.trace(add_channel_attributes_req.formatted_xml)

        add_channel_attributes_rsp = @purchase_order_svc.add_channel_attributes_to_purchase_order(add_channel_attributes_req.xml)

        add_channel_attributes_rsp.code.should == 200

        $tracer.trace(add_channel_attributes_rsp.http_body.formatted_xml)
		
		### FIND_STORES_IN_RANGE ###
		
		find_stores_in_range_req = @store_search_svc.get_request_from_template_using_global_defaults(:find_stores_in_range, StoreSearchServiceRequestTemplates.const_get("FIND_STORES_IN_RANGE#{@store_search_svc_version}"))
		
        find_stores_in_range_req.find_tag("session_id").at(0).content = @session_id  # oddly found in header
        find_stores_in_range_req.find_tag("client_channel").at(0).content = @client_channel 

        find_stores_data = find_stores_in_range_req.find_tag("find_stores_in_range_request").at(0)
        find_stores_data.address.content = '75038'
        find_stores_data.country_code.content = 'US'
        find_stores_data.radius_in_kilometers.content = '10'
        

        $tracer.trace(find_stores_in_range_req.formatted_xml)

        find_stores_in_range_rsp = @store_search_svc.find_stores_in_range(find_stores_in_range_req.xml)

        find_stores_in_range_rsp.code.should == 200

        $tracer.trace(find_stores_in_range_rsp.http_body.formatted_xml)
		
		store_city = find_stores_in_range_rsp.http_body.find_tag("address").at(0).city.content
		store_country_code = find_stores_in_range_rsp.http_body.find_tag("address").at(0).country_code.content
		store_line1 = find_stores_in_range_rsp.http_body.find_tag("address").at(0).line1.content
		#store_line2 = find_stores_in_range_rsp.http_body.find_tag("address").at(0).line2.content
		store_zip = find_stores_in_range_rsp.http_body.find_tag("address").at(0).zip.content
		store_state = find_stores_in_range_rsp.http_body.find_tag("address").at(0).state.content
		store_mall_name = find_stores_in_range_rsp.http_body.find_tag("store").at(0).mall.content
		store_number = find_stores_in_range_rsp.http_body.find_tag("store").at(0).store_number.content
		store_phone_number = find_stores_in_range_rsp.http_body.find_tag("store").at(0).phone_number.content
		

        ### ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS FOR EACH SHIPMENT GROUP ###
		
        add_shipping_address_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_shipping_addresses_to_shipments,  PurchaseOrderServiceRequestTemplates.const_get("ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS_WITH_ADDRESS#{@purchase_order_svc_version}") )

		add_shipping_address_req.find_tag("session_id").at(0).content = @session_id
		add_shipping_address_req.find_tag("client_channel").at(0).content = @client_channel
		add_shipping_address_req.find_tag("owner_id").at(0).content = @owner_id

		
		create_purchase_order_rsp.http_body.find_tag("shipment_id").each_with_index do |shipment_id, i|
			
			add_shipping_address_req.find_tag("shipments").at(0).address_shipment.at(0).clone_as_sibling if i > 0
			
			address_shipment_data = add_shipping_address_req.find_tag("address_shipment").at(i)
			
			address_shipment_data.email_address.content = @ship_email
			address_shipment_data.phone_number.content = @ship_phone
			address_shipment_data.shipment_id.content = shipment_id.content

			address_data = address_shipment_data.address
			address_data.address_id.content = @ship_address_id
			address_data.city.content = @ship_city
			address_data.country_code.content = @ship_country_code
			address_data.line1.content = @ship_line1
			address_data.line2.content = nil
			address_data.postal_code.content = @ship_postal_code
			address_data.state.content = @ship_state
			address_data.first_name.content = @ship_first_name
			address_data.last_name.content = @ship_last_name

		end
		
		$tracer.trace(add_shipping_address_req.formatted_xml)

		add_shipping_address_rsp = @purchase_order_svc.add_shipping_addresses_to_shipments(add_shipping_address_req.xml)

		add_shipping_address_rsp.code.should == 200

		$tracer.trace(add_shipping_address_rsp.http_body.formatted_xml)

		add_shipping_address_rsp.http_body.find_tag("status").at(0).content.should == "Success"
        
        ### ADD_CUSTOMER_TO_PURCHASE_ORDER ###
        add_customer_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_customer_to_purchase_order, PurchaseOrderServiceRequestTemplates.const_get("ADD_CUSTOMER_TO_PURCHASE_ORDER#{@purchase_order_svc_version}") )

        add_customer_req.find_tag("session_id").at(0).content = @session_id
				add_customer_req.find_tag("client_channel").at(0).content = @client_channel
        add_customer_req.find_tag("owner_id").at(0).content = @owner_id
				add_customer_req.find_tag("locale").content = @locale

        customer_data = add_customer_req.find_tag("customer").at(0)
        customer_data.email_address.content = @bill_email
        customer_data.loyalty_card_number.content = @loyalty_card_number
        customer_data.loyalty_customer_id.content = nil
        customer_data.phone_number.content = store_phone_number
				customer_data.is_guest_checkout.content = false
				customer_data.loyalty_tier.content = "Unspecified"
		
        bill_to_data = customer_data.bill_to
        bill_to_data.address_id.content = @bill_address_id
        bill_to_data.city.content = store_city
        bill_to_data.country_code.content = store_country_code
        bill_to_data.line1.content = store_line1
        bill_to_data.line2.content = nil
        bill_to_data.postal_code.content = store_zip
        bill_to_data.state.content = store_state
        bill_to_data.first_name.content = @bill_first_name
        bill_to_data.last_name.content = @bill_last_name
				bill_to_data.format_validated.content = true
				
        $tracer.trace(add_customer_req.formatted_xml)
        add_customer_rsp = @purchase_order_svc.add_customer_to_purchase_order(add_customer_req.xml)
        add_customer_rsp.code.should == 200
        $tracer.trace(add_customer_rsp.http_body.formatted_xml)

        ################
        ### SHIPPING ###
        ################

        ### GET_AVAILABLE_SHIPPING_METHODS FOR EACH SHIPMENT GROUP ###
		
		@shipping_cost = Hash.new
		get_available_shipping_methods_req = @shipping_svc.get_request_from_template_using_global_defaults(:get_available_shipping_methods,ShippingServiceRequestTemplates.const_get("GET_AVAILABLE_SHIPPING_METHODS#{@shipping_svc_version}"))

		get_available_shipping_methods_req.find_tag("session_id").at(0).content = @session_id
		get_available_shipping_methods_req.find_tag("client_channel").at(0).content = @client_channel	# oddly found in header

		get_available_shipping_methods_data = get_available_shipping_methods_req.find_tag("get_available_shipping_methods_request").at(0)
		get_available_shipping_methods_data.customer_id.content = @owner_id # BOB ????????
		get_available_shipping_methods_data.customer_loyalty_number.content = @loyalty_card_number
		get_available_shipping_methods_data.promocodes.string.content = @promo_code
		#get_available_shipping_methods_data.promocodes.string.remove_self
		get_available_shipping_methods_data.targeting_context.items.name_value_property.remove_self
				
		create_purchase_order_rsp.http_body.find_tag("shipment").each_with_index do |po_shipment, i|
			
			get_available_shipping_methods_req.find_tag("shipment").at(0).clone_as_sibling if i > 0
			
		    shipment_id = po_shipment.shipment_id.content 
			shipments_data = get_available_shipping_methods_req.find_tag("shipment").at(i)
			
			po_shipment.line_items.line_item.each_with_index do |item, a|
			
			    shipments_data.line_items.line_item.at(0).clone_as_sibling if a > 0
				
				line_item =  shipments_data.line_items.line_item.at(a)
				line_item.line_item_id.content = item.line_item_id.content
                line_item.list_price.content = item.extended_price.content
                line_item.quantity.content = item.quantity.content
                line_item.sku.content = item.sku.content
			end
			
			ship_to_data = shipments_data.ship_to.at(0)
			ship_to_data.address_id.content = @ship_address_id
			ship_to_data.city.content = @ship_city
			ship_to_data.country_code.content = @ship_country_code
			ship_to_data.line1.content = @ship_line1
			ship_to_data.line2.content = nil
			ship_to_data.postal_code.content = @ship_postal_code
			ship_to_data.state.content = @ship_state
				
			shipments_data.shipment_id.content = shipment_id
            shipments_data.shipment_type.content = @shipment_type
		end
		
		$tracer.trace(get_available_shipping_methods_req.formatted_xml)

		get_available_shipping_methods_rsp = @shipping_svc.get_available_shipping_methods(get_available_shipping_methods_req.xml)

		get_available_shipping_methods_rsp.code.should == 200

		$tracer.trace(get_available_shipping_methods_rsp.http_body.formatted_xml)

        # choosing the first available shipping option 
        calculated_shipping_method = get_available_shipping_methods_rsp.http_body.find_tag("calculated_shipment").at(0).shipping_methods.calculated_shipping_method.at(1)
				
		
		### ADD_SHIPPING_METHODS_TO_SHIPMENTS ###
		create_purchase_order_rsp.http_body.find_tag("shipment").each_with_index do |po_shipment, i|
			shipment_id = po_shipment.shipment_id.content 
			add_shipping_methods_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_shipping_methods_to_shipments, PurchaseOrderServiceRequestTemplates.const_get("ADD_SHIPPING_METHODS_TO_SHIPMENTS#{@purchase_order_svc_version}"))

			add_shipping_methods_req.find_tag("session_id").at(0).content = @session_id
			add_shipping_methods_req.find_tag("owner_id").at(0).content = @owner_id
			add_shipping_methods_req.find_tag("client_channel").at(0).content = @client_channel

			shipments_data = add_shipping_methods_req.find_tag("shipments").at(0)

			shipping_method_shipment_data = shipments_data.shipping_method_shipment.at(0)
			shipping_method_shipment_data.gift_message.content = nil
			shipping_method_shipment_data.shipment_id.content = shipment_id
			shipping_method_shipment_data.shipping_cost.content = calculated_shipping_method.shipping_cost.content
			shipping_method_shipment_data.shipping_method_id.content = calculated_shipping_method.shipping_method_id.content
            @shipping_cost[shipment_id] = calculated_shipping_method.shipping_cost.content
			$tracer.trace(add_shipping_methods_req.formatted_xml)
			
			
			add_shipping_methods_rsp = @purchase_order_svc.add_shipping_methods_to_shipments(add_shipping_methods_req.xml)
			
			add_shipping_methods_rsp.code.should == 200
		end	
			
		### CALCULATE_TAX ###
			
		calculate_tax_req = @tax_svc.get_request_from_template_using_global_defaults(:calculate_tax)

		calculate_tax_req.find_tag("session_id").at(0).content = @session_id
		calculate_tax_req.find_tag("client_channel").at(0).content = @client_channel

		tax_data = calculate_tax_req.find_tag("calculate_tax_request").at(0)
		tax_data.client_country.content = @locale
		tax_data.currency.content = @currency
		po_date = Time.now
		po_date = po_date.strftime("%Y-%m-%dT%H:%M:%S.000-06:00")
		tax_data.client_transaction_number.content = Random.rand(100000...999999)

        create_purchase_order_rsp.http_body.find_tag("shipment").each_with_index do |po_shipment, p|

		    shipment_id = po_shipment.shipment_id.content
			
			calculate_tax_req.find_tag("shipment").at(0).clone_as_sibling if p > 0 
			
			tax_shipment_data = calculate_tax_req.find_tag("shipments").shipment.at(p)

			bill_to_data = tax_shipment_data.bill_to
			bill_to_data.address_id.content = @bill_address_id
			bill_to_data.city.content = @bill_city
			bill_to_data.country_code.content = @bill_country_code
			bill_to_data.county.content = nil
			bill_to_data.line1.content = @bill_line1
			bill_to_data.line2.content = nil
			bill_to_data.postal_code.content = @bill_postal_code
			bill_to_data.state.content = @bill_state
			
			po_shipment.line_items.line_item.each_with_index do | item, b |
                tax_shipment_data.line_items.line_item.at(0).clone_as_sibling if b > 0
                line_item = tax_shipment_data.line_items.line_item.at(b)
				
				line_item.description.content = item.product_type.content
				line_item.line_item_id.content = item.line_item_id.content
				line_item.quantity.content = item.quantity.content
				line_item.shipping_cost.content = item.shipping_cost.content
				line_item.shipping_tax.content = item.shipping_tax.content
				line_item.sku.content = item.sku.content
				line_item.tax.content = item.tax.content
#TODO###########################################################################################				
				tax_code = @results_from_file.at(0).taxabilitycode
				line_item.taxability_code.content = tax_code  
##getting this from the database but haven't set this up for multiple products as of yet
				line_item.unit_price_with_discounts.content = ("%.2f" % (BigDecimal(item.extended_price.content.to_s) / BigDecimal(item.quantity.content.to_s)))
				
            end
			
			ship_to_data = tax_shipment_data.ship_to
			ship_to_data.address_id.content = @ship_address_id
			ship_to_data.city.content = @ship_city
			ship_to_data.country_code.content = @ship_country_code
			ship_to_data.county.content = nil
			ship_to_data.line1.content = @ship_line1
			ship_to_data.line2.content = nil
			ship_to_data.postal_code.content = @ship_postal_code
			ship_to_data.state.content = @ship_state
			
			tax_shipment_data.purchase_date.content = po_date
			tax_shipment_data.shipment_id.content = shipment_id
			tax_shipment_data.shipping_cost.content = @shipping_cost[shipment_id] # no tax on shipping? or is it per state?
			tax_shipment_data.shipping_tax.content = 0
			tax_shipment_data.tax.content = 0
			
			
		end 
		
		
		$tracer.trace(calculate_tax_req.formatted_xml)

		calculate_tax_rsp = @tax_svc.calculate_tax(calculate_tax_req.xml)

		calculate_tax_rsp.code.should == 200
		
		$tracer.trace(calculate_tax_rsp.http_body.formatted_xml)
			
		
        ######################
        ### PURCHASE ORDER ###
        ######################

        ### VALIDATE_PURCHASE_ORDER2 ###

        validate_purchase_order_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:validate_purchase_order2, PurchaseOrderServiceRequestTemplates.const_get("VALIDATE_PURCHASE_ORDER2#{@purchase_order_svc_version}"))

        validate_purchase_order_req.find_tag("session_id").at(0).content = @session_id  # oddly found in header
        validate_purchase_order_req.find_tag("owner_id").at(0).content = @owner_id
		validate_purchase_order_req.find_tag("client_channel").at(0).content = @client_channel	
		validate_purchase_order_req.find_tag("targeting_context").items.name_value_property.remove_self

        $tracer.trace(validate_purchase_order_req.formatted_xml)

        validate_purchase_order_rsp = @purchase_order_svc.validate_purchase_order2(validate_purchase_order_req.xml)

        validate_purchase_order_rsp.code.should == 200
    
        $tracer.trace(validate_purchase_order_rsp.http_body.formatted_xml)
		puts validate_purchase_order_rsp.http_body.formatted_xml

        # search validation and search if age gate is needed.
        

		messages_data = validate_purchase_order_rsp.http_body.find_tag("messages").at(0)
			if messages_data.purchase_order_validation_message.exists == true
			messages_data.purchase_order_validation_message.each do |msg|
				if msg.message.exists
					if msg.message.content.include?("verification of mature")

						### CONFIRM_AGE_GATE ###
						confirm_age_gate_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:confirm_age_gate, PurchaseOrderServiceRequestTemplates.const_get("CONFIRM_AGE_GATE#{@purchase_order_svc_version}"))

						confirm_age_gate_req.find_tag("session_id").at(0).content = @session_id
						confirm_age_gate_req.find_tag("owner_id").at(0).content = @owner_id
						confirm_age_gate_req.find_tag("client_channel").at(0).content = @client_channel

						$tracer.trace(confirm_age_gate_req.formatted_xml)

						confirm_age_gate_rsp = @purchase_order_svc.confirm_age_gate(confirm_age_gate_req.xml)

						confirm_age_gate_rsp.code.should == 200

						$tracer.trace(confirm_age_gate_rsp.http_body.formatted_xml)

						break # no need to confirm age gate more than once
					end
				end
			end
		end
        
        ### GET_PURCHASE_ORDER ###

        get_purchase_order_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:get_purchase_order,  PurchaseOrderServiceRequestTemplates.const_get("GET_PURCHASE_ORDER#{@purchase_order_svc_version}"))

        get_purchase_order_req.find_tag("session_id").at(0).content = @session_id
        get_purchase_order_req.find_tag("owner_id").at(0).content = @owner_id
		get_purchase_order_req.find_tag("client_channel").at(0).content = @client_channel
		get_purchase_order_req.find_tag("targeting_context").items.name_value_property.remove_self

        $tracer.trace(get_purchase_order_req.formatted_xml)

        get_purchase_order_rsp = @purchase_order_svc.get_purchase_order(get_purchase_order_req.xml)

        get_purchase_order_rsp.code.should == 200

        $tracer.trace(get_purchase_order_rsp.http_body.formatted_xml)
		
		puts get_purchase_order_rsp.http_body.formatted_xml

        get_purchase_order_rsp.http_body.find_tag("result").content.should == "Success"

		
		### PURCHASE ###  - before applying the payment. Purchase should not be successful since payment is not applied.
        purchase_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:purchase, PurchaseOrderServiceRequestTemplates.const_get("PURCHASE_WITH_SVS_CARD#{@purchase_order_svc_version}"))
			
		purchase_req.find_tag("session_id").at(0).content = @session_id
		purchase_req.find_tag("client_channel").at(0).content = @client_channel
		purchase_req.find_tag("purchase_order_owner_id").at(0).content = @owner_id
		purchase_req.find_tag("targeting_context").items.name_value_property.remove_self
		
		purchase_req.find_tag("stored_value_payment_methods").stored_value_payment_method.remove_self
		
		$tracer.trace(purchase_req.formatted_xml)

		purchase_rsp = @purchase_order_svc.purchase(purchase_req.xml)

		purchase_rsp.code.should == 200

		$tracer.trace(purchase_rsp.http_body.formatted_xml)

		purchase_rsp.http_body.find_tag("purchase_successful").content.should == "false"

		### FULFILL_DIGITAL_CONTENT ###
		
		fulfill_digital_content_req = @digital_content_svc.get_request_from_template_using_global_defaults(:fulfill_digital_content, DigitalContentServiceRequestTemplates.const_get("FULFILL_DIGITAL_CONTENT#{@digital_content_svc_version}"))
		
		fulfill_digital_content_data = fulfill_digital_content_req.find_tag("fulfill_digital_content_request").at(0)
        fulfill_digital_content_data.session_id.content = @session_id  
		fulfill_digital_content_data.client_channel.content = @client_channel 
		fulfill_digital_content_data.country_code.content = @ship_country_code
		fulfill_digital_content_data.line_item_id.content = @digital_lineitem_id
		
		#this is the digital sku that gives the virtual gift card which is used for purchase later
		fulfill_digital_content_data.sku.content = '337001'
		
		fulfill_digital_content_data.transaction_id.content = @transaction_id
        
        $tracer.trace(fulfill_digital_content_req.formatted_xml)

        fulfill_digital_content_rsp = @digital_content_svc.fulfill_digital_content(fulfill_digital_content_req.xml)

        fulfill_digital_content_rsp.code.should == 200

        $tracer.trace(fulfill_digital_content_rsp.http_body.formatted_xml)
				
		content_code = fulfill_digital_content_rsp.http_body.find_tag("content_code").content
				
		#Assertions
		fulfill_digital_content_rsp.http_body.find_tag("dlc_response_type").content.should == 'Success'
		#There is a open bug where the service response is misspelled as 'Availabile' instead of 'Available'. Needs to be replaced with 'Available' after it gets corrected otherwise script would break.
		fulfill_digital_content_rsp.http_body.find_tag("availability_level").content.should == 'Availabile'
		
	
		##########################
		## Assertion Collection ##
		##########################
		
		#Need to put this function into a DSL
		#Assert totals
		#expected_total
		#actual_total
		#estimated tax line item + shipping
		#actual_total before discount
		#actual_total after discount
		
			
		### PURCHASE ###
		#if the "Checkout" flag in the dataset csv has any value other than "true" the script will not complete checkout.
		if @complete_checkout == "true"
	
			purchase_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:purchase, PurchaseOrderServiceRequestTemplates.const_get("PURCHASE_WITH_SVS_CARD#{@purchase_order_svc_version}"))
			
			purchase_req.find_tag("session_id").at(0).content = @session_id
			purchase_req.find_tag("client_channel").at(0).content = @client_channel
			purchase_req.find_tag("purchase_order_owner_id").at(0).content = @owner_id
			purchase_req.find_tag("targeting_context").items.name_value_property.remove_self
			
			purchase_data = purchase_req.find_tag("purchase_request").at(0)
			purchase_data.stored_value_payment_methods.stored_value_payment_method.is_tokenized.content = "false"
			purchase_data.stored_value_payment_methods.stored_value_payment_method.is_wallet_payment_method.content = "false"
			purchase_data.stored_value_payment_methods.stored_value_payment_method.payment_account_number.content = content_code
			purchase_data.stored_value_payment_methods.stored_value_payment_method.pin.content = '1234'
			
			$tracer.trace(purchase_req.formatted_xml)

			purchase_rsp = @purchase_order_svc.purchase(purchase_req.xml)

			purchase_rsp.code.should == 200

			$tracer.trace(purchase_rsp.http_body.formatted_xml)

			purchase_rsp.http_body.find_tag("purchase_successful").content.should == "true"
			
			#assert actual subtotal is same as expected subtotal
			expected_subtotal = 0
			calculated_shipping_cost = 0
			total_tax = 0
			expected_totaldiscount = 0
			
			calculate_tax_rsp.http_body.find_tag("line_items").at(0).line_item.each do |item|
			    calculated_shipping_cost  += item.shipping_cost.content.to_f
			end
			total_tax  += calculate_tax_rsp.http_body.find_tag("tax").at(0).content.to_f.round(2)

			create_purchase_order_rsp.http_body.find_tag("line_items").each do |item|
			    item.line_item.each_with_index  do | item |
                  expected_subtotal += (item.list_price.content.to_f*item.quantity.content.to_f)
				end  
			end
			
			create_purchase_order_rsp.http_body.find_tag("line_items").each do |item|
			    item.line_item.each_with_index  do | item |
                  expected_totaldiscount += item.discount_amount.content.to_f
				end  
			end
			#assert total tax is same as tax returned from tax service
			
			purchase_rsp.http_body.find_tag("total_tax").content.should == total_tax.to_s
			
			actual_subtotal = round(purchase_rsp.http_body.find_tag("purchase_order").sub_total.content)
			actual_subtotal.should == round(expected_subtotal)
			
			#assert actual total is same as expected total
			actual_total = round(purchase_rsp.http_body.find_tag("purchase_order").total.content)
			expected_total = round(expected_subtotal.to_f - expected_totaldiscount.to_f + calculated_shipping_cost.to_f  + total_tax.to_f) 
			actual_total.should == expected_total
			
			#Get the order confirmation number
			order_tracking_number = purchase_rsp.http_body.find_tag("order_tracking_number").content
			
		#Assert details_extension table has orders placed with @svs payment
		#Remember split orders will append a 'D' or 'P' for the split
		
			###GET_PURCHASE_ORDER_BY_TRACKING_NUMBER###
			
			#If the purchase is successful then retrieves the purchase order by tracking number
			if purchase_rsp.http_body.find_tag("purchase_successful").content == "true"
				get_purchase_order_by_tracking_number_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:get_purchase_order_by_tracking_number, PurchaseOrderServiceRequestTemplates.const_get("GET_PURCHASE_ORDER_BY_TRACKING_NUMBER#{@purchase_order_svc_version}"))
				
				get_purchase_order_by_tracking_number_req.find_tag("session_id").at(0).content = @session_id
				get_purchase_order_by_tracking_number_req.find_tag("client_channel").at(0).content = @client_channel
				get_purchase_order_by_tracking_number_req.find_tag("order_tracking_number").at(0).content = order_tracking_number
				get_purchase_order_by_tracking_number_req.find_tag("targeting_context").items.name_value_property.remove_self			
				
				$tracer.trace(get_purchase_order_by_tracking_number_req.formatted_xml)

				get_purchase_order_by_tracking_number_rsp = @purchase_order_svc.get_purchase_order_by_tracking_number(get_purchase_order_by_tracking_number_req.xml)

				get_purchase_order_by_tracking_number_rsp.code.should == 200

				$tracer.trace(get_purchase_order_by_tracking_number_rsp.http_body.formatted_xml)
				get_purchase_order_by_tracking_number_rsp.http_body.find_tag("order_tracking_number").content.should == order_tracking_number
						
			end

		end
	end
	
	def initialize_csv_params
		@testcaseid = @row.find_value_by_name("ID")
		$tracer.trace("TFS Test Case ID: #{@testcaseid}")
		
		@testdesc = @row.find_value_by_name("TestDescription")
		$tracer.trace("Test Description: #{@testdesc}")
		
		#standard service data
		@brand = @row.find_value_by_name("Brand")
		$tracer.trace("brand : #{@brand}")
		@client_channel = @row.find_value_by_name("ClientChannel")
		$tracer.trace("Client Channel : #{@client_channel}")
		@locale = @row.find_value_by_name("Locale")
		$tracer.trace("locale : #{@locale}")
		@currency = @row.find_value_by_name("Currency")
		$tracer.trace("currency : #{@currency}")
		
		#discounts
		@loyalty_card_number = @row.find_value_by_name("LoyaltyCardNumber")
		@loyalty_card_id = @row.find_value_by_name("LoyaltyCardId")
		@promo_code = @row.find_value_by_name("PromoCode")
		
		#payments
		
		@shipment_type = @row.find_value_by_name("ShipmentType")
		@complete_checkout = @row.find_value_by_name("Checkout")
		@qty_increase = @row.find_value_by_name("QtyIncrease")
		
		$tracer.trace("Complete Checkout? : #{@complete_checkout}")
		
		#shipping address information
		@ship_email = @row.find_value_by_name("ShipEmail")
		@ship_phone = @row.find_value_by_name("ShipPhone")
		@ship_city = @row.find_value_by_name("ShipCity")
		@ship_country_code = @row.find_value_by_name("ShipCountryCode")
		@ship_line1 = @row.find_value_by_name("ShipLine1")
		@ship_line2 = @row.find_value_by_name("ShipLine2")
		@ship_postal_code = @row.find_value_by_name("ShipPostalCode")
		@ship_state = @row.find_value_by_name("ShipState")
		@ship_first_name = @row.find_value_by_name("ShipFirstName")
		@ship_last_name = @row.find_value_by_name("ShipLastName")
		@ship_address_id = generate_guid
		@digital_lineitem_id = generate_guid
		@transaction_id = generate_guid
		
		#billing address information
		@bill_email = @row.find_value_by_name("BillEmail")
		@bill_phone = @row.find_value_by_name("BillPhone")
		@bill_city = @row.find_value_by_name("BillCity")
		@bill_country_code = @row.find_value_by_name("BillCountryCode")
		@bill_line1 = @row.find_value_by_name("BillLine1")
		@bill_line2 = @row.find_value_by_name("BillLine2")
		@bill_postal_code = @row.find_value_by_name("BillPostalCode")
		@bill_state = @row.find_value_by_name("BillState")
		@bill_first_name = @row.find_value_by_name("BillFirstName")
		@bill_last_name = @row.find_value_by_name("BillLastName")	
		@bill_address_id = generate_guid
	end
	
	def round (value)
	    return  sprintf('%.2f', value)
	end
	
end



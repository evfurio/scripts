#####################################################################
###USAGE NOTES
###Run this script using the following command
### Single execution in QA using an available product (not digital or download), **Authenticated User, Checkout
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\Checkout_with_DigitalWalletCard.rb --login shahzebkhan@gamestop.com --password khan321 --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range "TFS45295" --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --or
### if the user login is changed then credit card details and token from the digital wallet for that user needs to be updated in the script. 
###
### Single execution in DEV using an available product (not digital or download), **Authenticated User, Checkout
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\Checkout_with_DigitalWalletCard.rb --login shahzebkhan@gamestop.com --password khan321 --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range "TFS45295" --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "DEV_Catalog" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env DEV_V1 --or
###
###############################################################################################################################################################################################################
###                                       Single execution in QA2 using an available product (not digital or download)                                                                                       ###
###############################################################################################################################################################################################################
### ******* Authenticated User, Checkout WITH ALL RUNTIME PARAMETERS SPECIFIED *******
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\Checkout_with_DigitalWalletCard.rb --login shahzebkhan@gamestop.com --password khan321 --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range "TFS45295" --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA2_V1 --or
###
### *******  Authenticated User, Checkout, WITH  ONLY REQUIRED RUNTIME PARAMETERS SPECIFIED ******* 
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\Checkout_with_DigitalWalletCard.rb --login shahzebkhan@gamestop.com --password khan321 --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range "TFS45295"   --or
###
### ******* Guest User, Checkout WITH ALL RUNTIME PARAMETERS SPECIFIED *******
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\Checkout_with_DigitalWalletCard.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range "TFS45295" --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA2_V1 --or
###
### *******  Guest User, Checkout, WITH  ONLY REQUIRED RUNTIME PARAMETERS SPECIFIED ******* 
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\Checkout_with_DigitalWalletCard.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range "TFS45295"   --or


###
###Author: sreddy

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

describe "GameStop Checkout Scenario Tests" do

    before(:all) do
        $tracer.mode = :on
        $tracer.echo = :on
    end

    before(:each) do
	
		csv = QACSV.new(csv_filename_parameter)
		@row = csv.find_row_by_name(csv_range_parameter)
#initialize the services to be used for the test
		@global_functions = GlobalServiceFunctions.new()
		@global_functions.csv = @row
		@global_functions.parameters
		@sql = @global_functions.sql_file
		@db = @global_functions.db_conn
		@cart_svc, @cart_svc_version = @global_functions.cart_svc
		@account_svc, @account_svc_version  = @global_functions.account_svc
		@purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
		@shipping_svc, @shipping_svc_version = @global_functions.shipping_svc
		#@icheckout_svc = @global_functions.checkout_svc
		@tax_svc, @tax_svc_version = @global_functions.tax_svc
#user name and password are provided throught the command line parameter
#if no user name or password are provided the script will authorize the user as anonymous

#generate a new session id guid.  the generate_guid function uses uuidtools to generate guids on the fly.
        @session_id = generate_guid
		
        #get the user name and password provided using the --login and --password parameters if provided.
	    #if the parameters were not passed the script will assume you want to authorize anonymously
        #TODO - if the parameters are passed and the user is not registered, register the new user and authorize
        user_name, user_password = nil
        begin
            user_name = account_login_parameter
            user_password = account_password_parameter
        rescue Exception => ex
            account_login_parameter = nil
        end
		
        sql = @sql.to_s
		@results_from_file = @db.exec_sql_from_file(sql)
		
        #passes parameters to the DSL to get the ownerid.  the ownerid is used throughout the remainder of the script as the identifier for the cart/purchaseorder
		@owner_id = @account_svc.perform_authorization_and_return_owner_id(@session_id, user_name, user_password, @account_svc_version)
        
		#set instance variables for csv driven data elements
	    initialize_csv_params
        
		#checks to ensure the cart is empty before proceeding
        @cart_svc.perform_empty_cart(@session_id, @owner_id, @client_channel, @locale, @cart_svc_version)
    end
	
	
#[TestMethod]
    it "should Checkout using dataset defined" do
		
		############################
		### ADD PRODUCTS TO CART ###
		############################
		#set the variantid's from the query results
			
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
			sku_qty_list.push(sku.variantid,qty) 
		end
		@cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list, @client_channel, @locale, @cart_svc_version)
		
		######################
		### PURCHASE ORDER ###
		######################

		### CREATE_PURCHASE_ORDER_FROM_CART ###
		
		create_purchase_order_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:create_purchase_order_from_cart, PurchaseOrderServiceRequestTemplates.const_get("CREATE_PURCHASE_ORDER_FROM_CART#{@purchase_order_svc_version}"))
		create_purchase_order_req.find_tag("session_id").content = @session_id  
        create_purchase_order_req.find_tag("owner_id").content = @owner_id
        create_purchase_order_req.find_tag("client_channel").content = @client_channel
	    create_purchase_order_req.find_tag("targeting_context").items.name_value_property.remove_self

		$tracer.trace(create_purchase_order_req.formatted_xml)
		
		create_purchase_order_rsp = @purchase_order_svc.create_purchase_order_from_cart(create_purchase_order_req.xml)
		create_purchase_order_rsp.code.should == 200

        $tracer.trace(create_purchase_order_rsp.http_body.formatted_xml)

        ### ADD_CHANNEL_ATTRIBUTES_TO_PURCHASE_ORDER ###
        
		add_channel_attributes_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_channel_attributes_to_purchase_order, PurchaseOrderServiceRequestTemplates.const_get("ADD_CHANNEL_ATTRIBUTES_TO_PURCHASE_ORDER_WITH_ONLINE_CHANNEL_SPECIFIC_DATA#{@purchase_order_svc_version}"))
        add_channel_attributes_req.find_tag("session_id").content = @session_id  # oddly found in header
        add_channel_attributes_req.find_tag("owner_id").content = @owner_id
        add_channel_attributes_req.find_tag("client_channel").content = @client_channel
		
        channel_attributes_data = add_channel_attributes_req.find_tag("channel_attributes").at(0)
        channel_attributes_data.brand.content = @brand
        channel_attributes_data.client_ip.content = get_ip
        channel_attributes_data.geo_latitude.remove_self
        channel_attributes_data.geo_longitude.remove_self

        $tracer.trace(add_channel_attributes_req.formatted_xml)

        add_channel_attributes_rsp = @purchase_order_svc.add_channel_attributes_to_purchase_order(add_channel_attributes_req.xml)

        add_channel_attributes_rsp.code.should == 200

        $tracer.trace(add_channel_attributes_rsp.http_body.formatted_xml)

        ### ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS. ###
        
		add_shipping_address_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_shipping_addresses_to_shipments,  PurchaseOrderServiceRequestTemplates.const_get( "ADD_SHIPPING_ADDRESSES_TO_SHIPMENTS_WITH_ADDRESS#{@purchase_order_svc_version}"))
			  
		add_shipping_address_req.find_tag("session_id").content = @session_id
		add_shipping_address_req.find_tag("owner_id").content = @owner_id 
        add_shipping_address_req.find_tag("client_channel").content = @client_channel
		
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

        add_customer_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_customer_to_purchase_order, PurchaseOrderServiceRequestTemplates.const_get("ADD_CUSTOMER_TO_PURCHASE_ORDER#{@purchase_order_svc_version}"))
        add_customer_req.find_tag("session_id").content = @session_id
        add_customer_req.find_tag("owner_id").content = @owner_id
		add_customer_req.find_tag("client_channel").content = @client_channel

        customer_data = add_customer_req.find_tag("customer").at(0)
        customer_data.email_address.content = @bill_email
        customer_data.loyalty_card_number.content = nil
        customer_data.loyalty_customer_id.content = nil
        customer_data.phone_number.content = @bill_phone

        bill_to_data = customer_data.bill_to
        bill_to_data.address_id.content = @bill_address_id
        bill_to_data.city.content = @bill_city
        bill_to_data.country_code.content = @bill_country_code
        bill_to_data.line1.content = @bill_line1
        bill_to_data.line2.content = nil
        bill_to_data.postal_code.content = @bill_postal_code
        bill_to_data.state.content = @bill_state
        bill_to_data.first_name.content = @bill_first_name
        bill_to_data.last_name.content = @bill_last_name

        $tracer.trace(add_customer_req.formatted_xml)

        add_customer_rsp = @purchase_order_svc.add_customer_to_purchase_order(add_customer_req.xml)

        add_customer_rsp.code.should == 200

        $tracer.trace(add_customer_rsp.http_body.formatted_xml)

        ################
        ### SHIPPING ###
        ################

        ### GET_AVAILABLE_SHIPPING_METHODS ###
        get_available_shipping_methods_req = @shipping_svc.get_request_from_template_using_global_defaults(:get_available_shipping_methods,ShippingServiceRequestTemplates.const_get("GET_AVAILABLE_SHIPPING_METHODS#{@shipping_svc_version}"))
		get_available_shipping_methods_req.find_tag("session_id").content = @session_id  # oddly found in header
        get_available_shipping_methods_req.find_tag("client_channel").content = @client_channel
		get_available_shipping_methods_req.find_tag("targeting_context").items.name_value_property.remove_self
		
		get_available_shipping_methods_data = get_available_shipping_methods_req.find_tag("get_available_shipping_methods_request").at(0)
		get_available_shipping_methods_data.customer_id.content = @owner_id # BOB ????????
		get_available_shipping_methods_data.customer_loyalty_number.content = nil
		get_available_shipping_methods_data.promocodes.string.remove_self  # since we aren't using a promocode, remove the entry
		@shipment_cost = Hash.new
		
		create_purchase_order_rsp.http_body.find_tag("shipment").each_with_index do |po_shipment, i|
		
		    get_available_shipping_methods_req.find_tag("shipment").at(0).clone_as_sibling if i > 0
			
		    shipment_id = po_shipment.shipment_id.content 
			shipments_data = get_available_shipping_methods_req.find_tag("shipment").at(i)
			
			po_shipment.line_items.line_item.each_with_index do |item, a|
			    
				shipments_data.line_items.line_item.at(0).clone_as_sibling if a > 0
		
				line_item =  shipments_data.line_items.line_item.at(a)
				line_item.line_item_id.content = item.line_item_id.content
                line_item.list_price.content = item.list_price.content
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
		
		add_shipping_methods_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:add_shipping_methods_to_shipments, PurchaseOrderServiceRequestTemplates.const_get("ADD_SHIPPING_METHODS_TO_SHIPMENTS#{@purchase_order_svc_version}"))
		add_shipping_methods_req.find_tag("session_id").content = @session_id
		add_shipping_methods_req.find_tag("owner_id").content = @owner_id
	    add_shipping_methods_req.find_tag("client_channel").content = @client_channel
        
		### ADD_SHIPPING_METHODS_TO_SHIPMENTS ###
        create_purchase_order_rsp.http_body.find_tag("shipment").each_with_index do |po_shipment, i|
		    add_shipping_methods_req.find_tag("shipments").at(0).shipping_method_shipment(0).clone_as_sibling if i > 0
		     
			shipment_id = po_shipment.shipment_id.content 
			shipping_methods_data = get_available_shipping_methods_rsp.http_body.find_tag("calculated_shipment").at(0).shipping_methods
			shipping_method_shipment_data = add_shipping_methods_req.find_tag("shipments").at(0).shipping_method_shipment.at(i)
			shipping_method_shipment_data.gift_message.content = nil
			shipping_method_shipment_data.shipment_id.content = shipment_id
			shipping_method_shipment_data.shipping_cost.content = shipping_methods_data.calculated_shipping_method.at(0).shipping_cost.content
			shipping_method_shipment_data.shipping_method_id.content = shipping_methods_data.calculated_shipping_method.at(0).shipping_method_id.content
			
			@shipment_cost[shipment_id] = shipping_methods_data.calculated_shipping_method.at(0).shipping_cost.content
        end
		
		$tracer.trace(add_shipping_methods_req.formatted_xml)
		add_shipping_methods_rsp = @purchase_order_svc.add_shipping_methods_to_shipments(add_shipping_methods_req.xml)
			
		add_shipping_methods_rsp.code.should == 200
			
		#####################
        ### CALCULATE_TAX ###
        #####################
			
		calculate_tax_req = @tax_svc.get_request_from_template_using_global_defaults(:calculate_tax, TaxServiceRequestTemplates.const_get("CALCULATE_TAX#{@tax_svc_version}"))
        calculate_tax_req.find_tag("session_id").at(0).content = @session_id
		calculate_tax_req.find_tag("client_channel").at(0).content = @client_channel
		
        tax_data = calculate_tax_req.find_tag("calculate_tax_request").at(0)
        tax_data.client_country.content = @locale
        tax_data.currency.content = @currency
        tax_data.client_transaction_number.content = Random.rand(100000...999999)
	    po_date = Time.now
		po_date = po_date.strftime("%Y-%m-%dT%H:%M:%S.000-06:00")
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
	
                tax_code = @results_from_file.at(0).taxabilitycode			
				line_item.taxability_code.content = tax_code
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
			
			$tracer.trace(calculate_tax_req.formatted_xml)
			tax_shipment_data.purchase_date.content = po_date
			tax_shipment_data.shipment_id.content = shipment_id
			tax_shipment_data.shipping_cost.content = @shipment_cost[shipment_id] # shipping_methods_data.calculated_shipping_method.at(0).shipping_cost.content # no tax on shipping? or is it per state?
			tax_shipment_data.shipping_tax.content = 0
			tax_shipment_data.tax.content = 0
				
		end 
		
		$tracer.trace(calculate_tax_req.formatted_xml)
		calculate_tax_rsp = @tax_svc.calculate_tax(calculate_tax_req.xml)
        calculate_tax_rsp.code.should == 200
		
		$tracer.trace(calculate_tax_rsp.http_body.formatted_xml)
		
        ######################
        ### PURCHASE ORDER ###
        ################################
        ### VALIDATE_PURCHASE_ORDER2 ###
        ################################ 
        validate_purchase_order_req =  @purchase_order_svc.get_request_from_template_using_global_defaults(:validate_purchase_order2, PurchaseOrderServiceRequestTemplates.const_get("VALIDATE_PURCHASE_ORDER2#{@purchase_order_svc_version}"))

        validate_purchase_order_req.find_tag("session_id").content = @session_id  # oddly found in header
        validate_purchase_order_req.find_tag("owner_id").content = @owner_id
        validate_purchase_order_req.find_tag("targeting_context").items.name_value_property.remove_self
		 validate_purchase_order_req.find_tag("client_channel").content = @client_channel
		
		$tracer.trace(validate_purchase_order_req.formatted_xml)

        validate_purchase_order_rsp = @purchase_order_svc.validate_purchase_order2(validate_purchase_order_req.xml)

        validate_purchase_order_rsp.code.should == 200
    
        $tracer.trace(validate_purchase_order_rsp.http_body.formatted_xml)

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
        get_purchase_order_req.find_tag("session_id").content = @session_id
        get_purchase_order_req.find_tag("owner_id").content = @owner_id
		get_purchase_order_req.find_tag("client_channel").content = @client_channel
        get_purchase_order_req.find_tag("targeting_context").items.name_value_property.remove_self
		
        $tracer.trace(get_purchase_order_req.formatted_xml)

        get_purchase_order_rsp = @purchase_order_svc.get_purchase_order(get_purchase_order_req.xml)

        get_purchase_order_rsp.code.should == 200

		$tracer.trace(get_purchase_order_rsp.http_body.formatted_xml)
        get_purchase_order_rsp.http_body.find_tag("result").content.should == "Success"

        ### VALIDATE_PURCHASE_ORDER2 ###

        validate_purchase_order_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:validate_purchase_order2, PurchaseOrderServiceRequestTemplates.const_get("VALIDATE_PURCHASE_ORDER2#{@purchase_order_svc_version}"))
        validate_purchase_order_req.find_tag("session_id").content = @session_id  # oddly found in header
        validate_purchase_order_req.find_tag("owner_id").content = @owner_id
		validate_purchase_order_req.find_tag("client_channel").content = @client_channel
        validate_purchase_order_req.find_tag("targeting_context").items.name_value_property.remove_self
        
		$tracer.trace(validate_purchase_order_req.formatted_xml)
        validate_purchase_order_rsp = @purchase_order_svc.validate_purchase_order2(validate_purchase_order_req.xml)

        validate_purchase_order_rsp.code.should == 200

        $tracer.trace(validate_purchase_order_rsp.http_body.formatted_xml)
		
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
			purchase_req = @purchase_order_svc.get_request_from_template_using_global_defaults(:purchase, PurchaseOrderServiceRequestTemplates.const_get("PURCHASE_WITH_CREDIT_CARD#{@purchase_order_svc_version}"))
 			purchase_req.find_tag("session_id").content = @session_id
			purchase_req.find_tag("purchase_order_owner_id").content = @owner_id
			purchase_req.find_tag("client_channel").content = @client_channel
			purchase_req.find_tag("targeting_context").items.name_value_property.remove_self
			
			credit_card = purchase_req.find_tag("purchase_request").credit_card
			credit_card.is_tokenized.content = "true"
			credit_card.is_wallet_payment_method.content = "true"
			### These below hard coded values are taken from digital wallet for user shahzebkhan@gamestop.com. 
			###if the user login is changed then credit card details and token from the digital wallet for that user needs to be updated in the script. 
			credit_card.payment_account_number.content = 'VNYNQKIG5G5L1111'
			credit_card.expiration_month.content = '05'
			credit_card.expiration_year.content = '2014'
			credit_card.at(0).type.content = 'Visa'
			credit_card.csc.content = @cvv
           
			$tracer.trace(purchase_req.formatted_xml)

			purchase_rsp = @purchase_order_svc.purchase(purchase_req.xml)

			purchase_rsp.code.should == 200

			$tracer.trace(purchase_rsp.http_body.formatted_xml)
			
		
			purchase_rsp.http_body.find_tag("purchase_successful").content.should == "true"
			
			#Expected Totals
			calculated_shipping_cost = BigDecimal("0")
			expected_total_tax  = BigDecimal("0")
			expected_subtotal = BigDecimal("0")

			
			calculate_tax_rsp.http_body.find_tag("line_items").at(0).line_item.each do |item|
		        calculated_shipping_cost  += money_string_to_decimal(item.shipping_cost.content)
		    end
			
			expected_total_tax  += money_string_to_decimal(calculate_tax_rsp.http_body.find_tag("tax").at(0).content)
		    create_purchase_order_rsp.http_body.find_tag("line_items").each do |item|
			    item.line_item.each_with_index  do | item |
                  expected_subtotal += money_string_to_decimal(item.list_price.content)*money_string_to_decimal(item.quantity.content)
				end  
			end
			
			discount = money_string_to_decimal(purchase_rsp.http_body.find_tag("total_discount").content)
			expected_total = expected_subtotal + calculated_shipping_cost + expected_total_tax - discount
			
			#Actual Totals
			actual_subtotal = money_string_to_decimal(purchase_rsp.http_body.find_tag("purchase_order").sub_total.content)
			actual_total = money_string_to_decimal(purchase_rsp.http_body.find_tag("purchase_order").total.content)
			actual_total_shipping = money_string_to_decimal(purchase_rsp.http_body.find_tag("purchase_order").total_shipping_cost.content)
			actual_total_tax = money_string_to_decimal(purchase_rsp.http_body.find_tag("purchase_order").total_tax.content)
		   
    		puts "**************************************************************************************************************"
			puts "expected tax: #{expected_total_tax.to_f} - actual : #{actual_total_tax.to_f}"
			puts "expected subtotal: #{expected_subtotal.to_f} - actual : #{actual_subtotal.to_f}"
			puts "expected total: #{expected_total.to_f} - actual : #{actual_total.to_f}"	
			puts "**************************************************************************************************************"
			
			#assert actual total is same as expected total 
			actual_subtotal.should == expected_subtotal
			actual_total_shipping.should == calculated_shipping_cost
			actual_total_tax.should == expected_total_tax
			actual_total.should == expected_total 
			
			#Get the order confirmation number
			order_tracking_number = purchase_rsp.http_body.find_tag("order_tracking_number").content
		

				
		#Assert details_extension table has orders placed with svs payment
		#Remember split orders will append a 'D' or 'P' for the split
		
			###GET_PURCHASE_ORDER_BY_TRACKING_NUMBER###
			
			#If the purchase is successful then retrieves the purchase order by tracking number
			if purchase_rsp.http_body.find_tag("purchase_successful").content == "true"
			   
				@purchase_order_svc.perform_get_placed_order(@session_id, @client_channel, @locale, order_tracking_number, @purchase_order_svc_version)
				#get_purchase_order_by_tracking_number_rsp.http_body.find_tag("order_tracking_number").content.should == order_tracking_number
						
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
		@credit_card = @row.find_value_by_name("CreditCard")
		@cc_type = @row.find_value_by_name("CCType")
		@exp_month = @row.find_value_by_name("ExpMonth")
		@exp_year = @row.find_value_by_name("ExpYear")
		@svs = @row.find_value_by_name("SVS")
		@pin = @row.find_value_by_name("PIN")
		@cvv = @row.find_value_by_name("CVV")
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
	
	
end



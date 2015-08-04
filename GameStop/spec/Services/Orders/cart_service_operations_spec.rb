############################Usage Notes###############
#Run each scenario in this script seperately using the command mentioned above every scenario. This is because some of these scenarios require diffrent SQLs and different input data.
#######################################################
###Author - SR/DT
###Reconstructing the operations tests to handle multiple products adds and line items
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44321 -e 'should migrate cart' --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "GameStop SOAP Cart Services Tests" do

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
	   
	   initialize_csv_params
	   
	   #get results from the sql file
	   #sql = @sql.to_s
	   @results_from_file = @db.exec_sql_from_file("#{@sql}")

	   @cart_svc.perform_empty_cart(@session_id, @owner_id, @client_channel, @locale, @cart_svc_version)
   end

   #new command args for MTM
   #d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44301 -e "should add products to cart" --or
   
   #overrides for manual test execution
	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44301 -e "should add products to cart" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or 

### ADD_PRODUCTS_TO_CART ###	
	it "should add products to cart" do	
		sku_qty_list = []
		al = results_from_file.count
    sku = @sku
		results_from_file.each_with_index do |sku, i|
			if al == 0 
				@ind = 0 
			else 
				@ind = al - 1
			end
			qty = i == @ind ? 1 + @qty_increase.to_i : 1 
		    sku_qty_list.push(sku.variantid,qty)
		end

    @cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list, @client_channel, @locale, @cart_svc_version)
		$tracer.trace("ADD_PRODUCTS_TO_CART")
		$tracer.trace("TFSID: #{@id}")
		$tracer.trace("Test Case Description: #{@test_case_desc}")
		$tracer.trace("Client Channel: #{@client_channel}")
		$tracer.trace("Local: #{@locale}")
		$tracer.trace("Brand: #{@brand}")
		$tracer.trace("SessionId: #{@session_id}")
		$tracer.trace("OwnerId: #{@owner_id}")
		$tracer.trace("No. of SKUs Added to Cart: #{al}")
		
    end
	
	
	#new command args for MTM
	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44304 -e "should get products and lineitem ids from a cart"
	
	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44304 -e "should get products and lineitem ids from a cart" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or

### GET_PRODUCTS ###
    it "should get products and lineitem ids from a cart" do
		sku_qty_list = []
		
		@results_from_file.each_with_index do |sku, i|
		    qty = i == 2 ? 1 + @qty_increase.to_i : 1 
		    sku_qty_list.push(sku.variantid,qty) 
		end
		
		#set the variantid's from the query results
		sku0 = results_from_file.at(0).variantid
		sku1 = results_from_file.at(1).variantid
				
        sku_qty_list = [sku0,1, sku1,1] #,640328,1,640330,1,230791,1]
		
        @cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list, client_channel, locale)
		line_item_ids = @cart_svc.perform_get_cart_and_return_guids(@session_id, @owner_id, client_channel, locale)
				
    end
	
	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44305 -e "should remove products and empty the cart" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or
	it "should remove products and empty the cart" do

        ### REMOVE_PRODUCTS_FROM_CART ###

		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
        #get results from the sql file
		sql = @sql.to_s
		results_from_file = @db.exec_sql_from_file("#{sql}")
	
		#set the variantid's from the query results
		sku0 = results_from_file.at(0).variantid
		sku1 = results_from_file.at(1).variantid
				
        sku_qty_list = [sku0,1, sku1,1] #,640328,1,640330,1,230791,1]
		
        @cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list, client_channel, locale)
		line_item_ids = @cart_svc.perform_get_cart_and_return_guids(@session_id, @owner_id, client_channel, locale)
		remove_products_from_cart = @cart_svc.perform_remove_products_from_cart_and_return_message(@session_id, @owner_id, *line_item_ids, client_channel, locale)
		line_item_after_empty_cart = @cart_svc.perform_get_cart_and_return_items(@session_id, @owner_id, client_channel, locale)
		#assertion to make sure that cart is empty
		line_item_after_empty_cart.item.exists.should == false
		
    end
	
	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44306 -e "should modify cart lineitem quantity" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or
	it "should modify cart lineitem quantity" do

        ### MODIFY_LINE_ITEM_QUANTITIES ###

		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
        #get results from the sql file
		sql = @sql.to_s
		results_from_file = @db.exec_sql_from_file("#{sql}")
	
		#set the variantid's from the query results
		sku0 = results_from_file.at(0).variantid
		sku1 = results_from_file.at(1).variantid
		qty = 1				
        sku_qty_list = [sku0,qty,sku1,qty] #,640328,1,640330,1,230791,1]
        @cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list, client_channel, locale)
		#get the lineitemids
		line_item_ids = @cart_svc.perform_get_cart_and_return_guids(@session_id, @owner_id, client_channel, locale)
		line_item1 = line_item_ids[0]	
		line_item2 = line_item_ids[1]
		updated_qty = qty + 2
		lineitem_qty_list = [line_item1,updated_qty,line_item2,updated_qty]
		resp = @cart_svc.perform_modify_line_item_quantities_and_return_message(@session_id, @owner_id, *lineitem_qty_list, client_channel, locale)
		resp.http_body.find_tag("modified_quantity").at(0).content.should == "3"
		resp.http_body.find_tag("modified_quantity").at(1).content.should == "3"
				
    end

	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44307 -e "should modify lineitem fulfillment channel for ISPU from ShipToAddress to InStorePickUp" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\Get_PreOrder_Products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or
	it "should modify lineitem fulfillment channel for ISPU from ShipToAddress to InStorePickUp" do

        ### MODIFY_LINE_ITEM_FULFILLMENT_CHANNELS ###
		
		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
		#get results from the sql file
		sql = @sql.to_s
		results_from_file = @db.exec_sql_from_file("#{sql}")
	
		#set the variantid's from the query results
		sku0 = results_from_file.at(0).SKU
		sku_qty_list = [sku0,1] #,640328,1,640330,1,230791,1]
		@cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list, client_channel, locale)
		line_item_id = @cart_svc.perform_get_cart_and_return_guids(@session_id, @owner_id, client_channel, locale)
		fulfillment_channel = @row.find_value_by_name("ShipmentType")
		result = @cart_svc.perform_modify_line_item_fulfillment_channels_and_return_message(@session_id, @owner_id, *line_item_id, fulfillment_channel, client_channel, locale)
		result.should == "Success"
			
    end

	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44308 -e "should not modify lineitem fulfillment channel for non ISPU from ShipToAddress to InStorePickUp" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\Get_PreOrder_Products_NO_InStorePickUp.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or
	it "should not modify lineitem fulfillment channel for non ISPU from ShipToAddress to InStorePickUp" do

        ### MODIFY_LINE_ITEM_FULFILLMENT_CHANNELS ###
		
		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
        #get results from the sql file
		sql = @sql.to_s
		results_from_file = @db.exec_sql_from_file("#{sql}")
	
		#set the variantid's from the query results
		sku0 = results_from_file.at(0).SKU
		sku_qty_list = [sku0,1] #,640328,1,640330,1,230791,1]
        @cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list, client_channel, locale)
		line_item_id = @cart_svc.perform_get_cart_and_return_guids(@session_id, @owner_id, client_channel, locale)
		fulfillment_channel = @row.find_value_by_name("ShipmentType")
		result = @cart_svc.perform_modify_line_item_fulfillment_channels_and_return_message(@session_id, @owner_id, *line_item_id, fulfillment_channel, client_channel, locale)
		result.should == "InvalidChannel"
		
    end
	
	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44311 -e "should add a promotion to the cart" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or
	it "should add a promotion to the cart" do
		
		### ADD_PROMOTIONS_TO_CART ###
		
		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
        promotion_code = @row.find_value_by_name("PromoCode")
		result = @cart_svc.perform_add_promotions_to_cart_and_return_message(@session_id, @owner_id, promotion_code, client_channel, locale)
		result.should == "Added"
					
    end

	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44312 -e "should remove a promotion from cart" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or
	it "should remove a promotion from cart" do
		
		### REMOVE_PROMOTIONS_FROM_CART ###
		
		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
		promotion_code = @row.find_value_by_name("PromoCode")
		result = @cart_svc.perform_add_promotions_to_cart_and_return_message(@session_id, @owner_id, promotion_code, client_channel, locale)
		result.should == "Added"
		@cart_svc.perform_remove_promotions_from_cart(@session_id, @owner_id, promotion_code, client_channel, locale)			
    end

	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44314 -e "should apply pro loyalty number to cart" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or
	it "should apply pro loyalty number to cart" do
		
		### APPLY_LOYALTY_NUMBER_TO_CART ###
		
		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
		loyalty_number = @row.find_value_by_name("LoyaltyCardNumber")
		response = @cart_svc.perform_apply_loyalty_number_to_cart(@session_id, @owner_id, loyalty_number, client_channel, locale)
		
		discount_result = response.http_body.find_tag("apply_loyalty_for_discount_result").at(0).content
		points_result = response.http_body.find_tag("apply_loyalty_for_points_result").at(0).content
		discount_result.should == "Applied"
		points_result.should == "Applied"
				
    end

	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44315 -e "should apply free loyalty number to cart" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or
	it "should apply free loyalty number to cart" do

        ### APPLY_LOYALTY_NUMBER_TO_CART ###
		
		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
		loyalty_number = @row.find_value_by_name("LoyaltyCardNumber")
        response = @cart_svc.perform_apply_loyalty_number_to_cart(@session_id, @owner_id, loyalty_number, client_channel, locale)
		
		discount_result = response.http_body.find_tag("apply_loyalty_for_discount_result").at(0).content
		points_result = response.http_body.find_tag("apply_loyalty_for_points_result").at(0).content
		discount_result.should == "NotQualified"
		points_result.should == "Applied"		
    end
	
	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44316 -e "should remove pro loyalty number from cart" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or
	it "should remove pro loyalty number from cart" do

        ### REMOVE_LOYALTY_NUMBER_FROM_CART ###
		
		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
		loyalty_number = @row.find_value_by_name("LoyaltyCardNumber")
		response = @cart_svc.perform_apply_loyalty_number_to_cart(@session_id, @owner_id, loyalty_number, client_channel, locale)
		
		discount_result = response.http_body.find_tag("apply_loyalty_for_discount_result").at(0).content
		points_result = response.http_body.find_tag("apply_loyalty_for_points_result").at(0).content
		discount_result.should == "Applied"
		points_result.should == "Applied"
		@cart_svc.perform_remove_loyalty_number_from_cart(@session_id, @owner_id, client_channel, locale)			
    end
	
	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44317 -e "should remove free loyalty number from cart" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or	
	it "should remove free loyalty number from cart" do

        ### REMOVE_LOYALTY_NUMBER_FROM_CART ###
		
		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
		loyalty_number = @row.find_value_by_name("LoyaltyCardNumber")
        response = @cart_svc.perform_apply_loyalty_number_to_cart(@session_id, @owner_id, loyalty_number, client_channel, locale)
		
		discount_result = response.http_body.find_tag("apply_loyalty_for_discount_result").at(0).content
		points_result = response.http_body.find_tag("apply_loyalty_for_points_result").at(0).content
		discount_result.should == "NotQualified"
		points_result.should == "Applied"	
		@cart_svc.perform_remove_loyalty_number_from_cart(@session_id, @owner_id, client_channel, locale)			
    end

######################## This does not work yet - waiting on a DSL method from David #######	
	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44318 -e "should add a physical gift card to the cart" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\Get_PhysicalGiftCard_Sku.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or
	it "should add a physical gift card to the cart" do

        ### ADD_STORED_VALUE_PRODUCTS_TO_CART ###
		
		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
		#get results from the sql file
		sql = @sql.to_s
		results_from_file = @db.exec_sql_from_file("#{sql}")
	
		#set the variantid's from the query results
		sku0 = results_from_file.at(0).sku
		qty = 1
		amount = 5.00		
        #sku_qty_amount_list = [sku0,1, 5.00]
        response = @cart_svc.perform_add_stored_value_products_to_cart(@session_id, @owner_id, sku0, qty, amount, client_channel, locale )
		result = response.http_body.find_tag("add_product_result").at(0).content
		result == 'Success'
		
    end
	
	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44319 -e "should add a digital gift card to the cart" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\Get_DigitalGiftCertificate_Sku.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or
	it "should add a digital gift card to the cart" do

        ### ADD_STORED_VALUE_PRODUCTS_TO_CART ###
		
		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
		#get results from the sql file
		sql = @sql.to_s
		results_from_file = @db.exec_sql_from_file("#{sql}")
	
		#set the variantid's from the query results
		sku0 = results_from_file.at(0).sku
		qty = 1
		amount = 5.00		
        #sku_qty_amount_list = [sku0,1, 5.00]
        response = @cart_svc.perform_add_stored_value_products_to_cart(@session_id, @owner_id, sku0, qty, amount, client_channel, locale )
		result = response.http_body.find_tag("add_product_result").at(0).content
		result == 'Success'	
    end
######################## This does not work yet - waiting on a DSL method from David #######	
	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44320 -e "should confirm age gate" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --or
	it "should confirm age gate" do
	
	    ### CONFIRM_AGE_GATE ###
		
		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
		
		@cart_svc.perform_confirm_age_gate(@session_id, @owner_id, client_channel, locale)
		
    end

	#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cart_service_operations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Orders\cartservice_dataset.csv --range TFS44321 -e "should migrate cart" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env QA_Catalog --or
	it "should migrate cart" do

	    ### MIGRATE_CART ###
	
		#get the standard service data from csv file
		client_channel = @row.find_value_by_name("ClientChannel")
	    locale = @row.find_value_by_name("Locale")
        
		#get results from the sql file
		sql = @sql.to_s
		results_from_file = @db.exec_sql_from_file("#{sql}")
	
		#set the variantid's from the query results
		sku0 = results_from_file.at(0).variantid
		sku1 = results_from_file.at(1).variantid
				
        sku_qty_list1 = [sku0,1] #,640328,1,640330,1,230791,1]
		sku_qty_list2 = [sku1,1] #,640328,1,640330,1,230791,1]
		
        #create the first cart
		@cart_svc.perform_add_products_to_cart(@session_id, @owner_id, *sku_qty_list1, client_channel, locale, @cart_svc_version)
					
		#create the second cart
		@cart_svc.perform_add_products_to_cart(@target_session_id, @target_owner_id, *sku_qty_list2, client_channel, locale, @cart_svc_version)
				
		response = @cart_svc.perform_migrate_cart(@target_session_id, @owner_id, @target_owner_id, client_channel, locale, @cart_svc_version)
		result = response.http_body.find_tag("add_product_result").at(0).content
		added_sku = response.http_body.find_tag("sku").at(0).content
		existing_sku = response.http_body.find_tag("sku").at(1).content
		
		#assert to make sure that cart is migrated and the new cart shows both the sku's
		result.should == 'Success'
		added_sku == sku0
		existing_sku == sku1
			
   end

   def initialize_csv_params
	   @session_id = generate_guid
	   @owner_id = generate_guid
	   @target_session_id = generate_guid
	   @target_owner_id = generate_guid
	   @id = @row.find_value_by_name("ID")
	   @test_case_desc = @row.find_value_by_name("TestCaseDescription")
	   @client_channel = @row.find_value_by_name("ClientChannel")
	   @locale = @row.find_value_by_name("Locale")
	   @brand = @row.find_value_by_name("Brand")
	   @loyalty_number = @row.find_value_by_name("LoyaltyCardNumber")
	   @loyalty_card_id = @row.find_value_by_name("LoyaltyCardId") 
	   @promotion_code = @row.find_value_by_name("PromoCode")
	   @shipment_type =  @row.find_value_by_name("ShipmentType")
	   @qty_increase =  @row.find_value_by_name("QtyIncrease")
   end
   
end



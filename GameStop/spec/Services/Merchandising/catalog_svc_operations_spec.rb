#####################################################################
###USAGE NOTES
###Run this script using the following command
### Single execution in QA to get available product inventory
### d-Con .\dynamic_catalog_get_inventory_level.rb --csv catalog_dataset.csv --range "TestCase01" -e "should get product details" --sql .\get_products.sql --db .\databases.csv --db_env "QA_Catalog" --svc endpoints.csv --svc_env QA --or
###
### Additional sceanrios can be constructed by manipulating the data input.
### Facilitates authenticated and anonymous checkout.  To run as an authenticated session use the following parameters: --login user@test.com --password P@55w0rd!
### 
###Author: dturner

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

describe "GameStop Catalog Get Inventory Scenario Tests" do
csv = QACSV.new(csv_filename_parameter)
@row = csv.find_row_by_name(csv_range_parameter)
@testcasename = @row.find_value_by_name("TestCase")

    before(:all) do
#We will instantiate our connections for the test and take the option parameters passed by the command line 
        $tracer.mode = :on
        $tracer.echo = :on

#get the service endpoints from the --svc cmd parameter using --svc_env for the environment		
        @global_functions = GlobalServiceFunctions.new()
		@account_svc = @global_functions.account_svc
		@catalog_svc = @global_functions.catalog_svc
		
		puts "Catalog Service #{@catalog_svc}"
		
############################################################################
		
		
#get the --csv parameter and read the file, --range identifies the row of data to use per test case
		csv = QACSV.new(csv_filename_parameter)
		@row = csv.find_row_by_name(csv_range_parameter)
		
#get the --sql filename to use 
		@sql = "sql_queries/#{sql_parameter}"
		#@sql.should == "get_products.sql"
		
#get the server and database from the csv
		#db = QACSV.new("#{db_parameter}")
		#@db_name = db.find_row_by_name(db_env_parameter)
		
		#server = @db_name.find_value_by_name("Server")
		#database = @db_name.find_value_by_name("Database")	
		##create the new instance of dbmanager
		#@db = DbManager.new(server, database)		
    end

    before(:each) do
#user name and password are provided throught the command line parameter
#if no user name or password are provided the script will authorize the user as anonymous

		#generate a new session id guid.  the generate_guid function uses uuidtools to generate guids on the fly.
        @session_id = generate_guid
		
	end

#set instance variables for csv driven data elements

	#standard service data
	sku = @row.find_value_by_name("Sku")
	client_channel = @row.find_value_by_name("ClientChannel")
	locale = @row.find_value_by_name("Locale")
	currency = @row.find_value_by_name("Currency")
	client = @row.find_value_by_name("Client")

		###############
        ### CATALOG ###
        ###############

        ### GET_INVENTORY_LEVEL ###

	it "should get inventory level" do
		
        get_inventory_level_req = @catalog_svc.get_request_from_template_using_global_defaults(:get_inventory_level)
        get_inventory_level_request_data = get_inventory_level_req.find_tag("get_inventory_level_request").at(0)
        get_inventory_level_request_data.session_id.content = @session_id       
        get_inventory_level_request_data.skus.string.at(0).content = sku

        $tracer.trace(get_inventory_level_req.formatted_xml)

        get_inventory_level_rsp = @catalog_svc.get_inventory_level(get_inventory_level_req.xml)

        get_inventory_level_rsp.code.should == 200

        $tracer.trace(get_inventory_level_rsp.http_body.formatted_xml)

        catalog_product_inventory = get_inventory_level_rsp.http_body.find_tag("inventory_level").at(0).content
		
	end

		### GET_PRODUCTS ###
		
	it "should get product details" do
		
        get_products_req = @catalog_svc.get_request_from_template_using_global_defaults(:get_products)
        get_products_request_data = get_products_req.find_tag("get_products_request").at(0)
        get_products_request_data.session_id.content = @session_id       
        get_products_request_data.skus.string.at(0).content = sku

        $tracer.trace(get_products_req.formatted_xml)

        get_products_rsp = @catalog_svc.get_products(get_products_req.xml)

        get_products_rsp.code.should == 200

        $tracer.trace(get_products_rsp.http_body.formatted_xml)

        catalog_get_product_data = get_products_rsp.http_body.find_tag("product").at(0)
		additional_handling_fee_val = catalog_get_product_data.additional_handling_fee.content 
		availability = catalog_get_product_data.availability.content
		average_overall_rating = catalog_get_product_data.average_overall_rating.content
		cannot_cancel_order = catalog_get_product_data.cannot_cancel_order.content
		condition = catalog_get_product_data.condition.content
		definition_name = catalog_get_product_data.definition_name.content
		developer = catalog_get_product_data.developer.content
		display_name = catalog_get_product_data.display_name.content
		e_sr_brating = catalog_get_product_data.e_sr_brating.content
		e_sr_brating_text = catalog_get_product_data.e_sr_brating_text.content
		e_sr_bsmall_image_url = catalog_get_product_data.e_sr_bsmall_image_url.content
		has_downloadable_content = catalog_get_product_data.has_downloadable_content.content
		image_large_box = catalog_get_product_data.image_large_box.content
		image_small_box = catalog_get_product_data.image_small_box.content
		international_shipping_restrictions = catalog_get_product_data.international_shipping_restrictions.content
		inventory_warning_level = catalog_get_product_data.inventory_warning_level.content
		is_billing_and_shipping_match = catalog_get_product_data.is_billing_and_shipping_match.content
		is_drop_ship = catalog_get_product_data.is_drop_ship.content
		is_in_store_pickup_for_hops = catalog_get_product_data.is_in_store_pickup_for_ho_ps.content
		is_in_store_pickup_pre_order = catalog_get_product_data.is_in_store_pickup_pre_order.content
		is_online_only = catalog_get_product_data.is_online_only.content
		is_override_price = catalog_get_product_data.is_override_price.content
		is_pristine = catalog_get_product_data.is_pristine.content
		is_searchable = catalog_get_product_data.is_searchable.content
		last_price = catalog_get_product_data.last_price.content
		list_price = catalog_get_product_data.list_price.content
		product_limit = catalog_get_product_data.product_limit.content
		product_type = catalog_get_product_data.product_type.content
		publisher = catalog_get_product_data.publisher.content
		qty_available_to_sell = catalog_get_product_data.qty_available_to_sell.content
		recommendations_id = catalog_get_product_data.recommendations_id.content
		short_description = catalog_get_product_data.short_description.content
		units_sold = catalog_get_product_data.units_sold.content
	end
		##########################
		## Assertion Collection ##
		##########################
		
		#Need to put this function into a DSL
		#Assert for Sku
		#Inventory Level
	
		##########################
  

end



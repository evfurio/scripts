#####################################################################
###USAGE NOTES
###Run this script using the following command
### Single execution in QA to get available product inventory
### d-Con .\dynamic_catalog_get_inventory_level.rb --csv catalog_dataset.csv --range "TestCase01" -e "should get inventory level" --sql .\get_products.sql --db .\qa_databases.csv --db_range "catalog" --svc qa_endpoints.csv --svc_env QA --or
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
		@sku = @row.find_value_by_name("Sku")
		@client_channel = @row.find_value_by_name("ClientChannel")
		@locale = @row.find_value_by_name("Locale")
		@currency = @row.find_value_by_name("Currency")
		@client = @row.find_value_by_name("Client")
		@no_of_products = @row.find_value_by_name("NoOfProductsToBeDisplayed")
		@online_flag  = @row.find_value_by_name("onlineOnly")
		@terms = @row.find_value_by_name("terms")
		@no_of_recom = @row.find_value_by_name("NumberOfRecomendations")
		
	end

#set instance variables for csv driven data elements

	#standard service data


		###############
        ### CATALOG ###
        ###############

        ### GET_INVENTORY_LEVEL ###

	it "should get inventory level" do
		
        get_inventory_level_req = @catalog_svc.get_request_from_template_using_global_defaults(:get_inventory_level)
        get_inventory_level_request_data = get_inventory_level_req.find_tag("get_inventory_level_request").at(0)
        get_inventory_level_request_data.session_id.content = @session_id       
        get_inventory_level_request_data.skus.string.at(0).content = @sku

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
        get_products_request_data.skus.string.at(0).content = @sku

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
	
        ### GET PRODUCT LIST BY WILD CARD REQUEST ###

	it "should get wild card result" do
		
        get_wild_card_result_req = @catalog_svc.get_request_from_template_using_global_defaults(:get_product_list_by_wild_card)
        get_wild_card_result_request_data = get_wild_card_result_req.find_tag("get_wild_card_result_request").at(0)
        get_wild_card_result_request_data.no_of_products_to_be_displayed.content = @no_of_products       
        get_wild_card_result_request_data.online_only.content = @online_flag
		get_wild_card_result_request_data.terms.content = @terms

        $tracer.trace(get_wild_card_result_req.formatted_xml)

        get_wild_card_result_rsp = @catalog_svc.get_product_list_by_wild_card(get_wild_card_result_req.xml)

        get_wild_card_result_rsp.code.should == 200

        $tracer.trace(get_wild_card_result_rsp.http_body.formatted_xml)

      wild_card_result = get_wild_card_result_rsp.http_body.find_tag("get_wild_card_result_reply").at(0)
	  wild_card_result_data = wild_card_result.products.at(0)	
	  additional_handling_fee = wild_card_result_data.product.additional_handling_fee.content
	  additional_price_box_messages = wild_card_result_data.product.additional_price_box_messages.string.at(0).content
	  availability = wild_card_result_data.product.availability.content
	  #availability_message = wild_card_result_data.product.availability_message.content
	  average_overall_rating = wild_card_result_data.product.average_overall_rating.content
	  #buy_location_url = wild_card_result_data.product.buy_location_url.content
	  cannot_cancel_order = wild_card_result_data.product.cannot_cancel_order.content
	  condition = wild_card_result_data.product.condition.content
	  definition_name = wild_card_result_data.product.definition_name.content
	  developer = wild_card_result_data.product.developer.content
	  display_name = wild_card_result_data.product.display_name.content
	  #download_size = wild_card_result_data.product.download_size.content
	  e_sr_bdescriptors = wild_card_result_data.product.e_sr_bdescriptors.string.at(0).content
	  e_sr_brating = wild_card_result_data.product.e_sr_brating.content
	  e_sr_brating_text = wild_card_result_data.product.e_sr_brating_text.content
	  e_sr_bsmall_image_url = wild_card_result_data.product.e_sr_bsmall_image_url.content
	  #excluded_shipping_types = wild_card_result_data.product.excluded_shipping_types.string.at(0).content
	  #excluded_shipping_types_message = wild_card_result_data.product.excluded_shipping_types_message.content
	  #genres = wild_card_result_data.product.genres.string.at(0).content
	  has_downloadable_content = wild_card_result_data.product.has_downloadable_content.content
	  image_large_box = wild_card_result_data.product.image_large_box.content
	  image_small_box = wild_card_result_data.product.image_small_box.content
	  international_shipping_restrictions = wild_card_result_data.product.international_shipping_restrictions.content
	  #inventory_warning_level = wild_card_result_data.product.inventory_warning_level.content
	  is_billing_and_shipping_match = wild_card_result_data.product.is_billing_and_shipping_match.content
	  is_drop_ship = wild_card_result_data.product.is_drop_ship.content
	  #is_instore_pickup_for_h_op_s = wild_card_result_data.product.is_instore_pickup_for_h_op_s.content
	  #is_instore_pickup_pre_order = wild_card_result_data.product.is_instore_pickup_pre_order.content
	  is_online_only = wild_card_result_data.product.is_online_only.content
	  is_override_price = wild_card_result_data.product.is_override_price.content
	  is_pristine = wild_card_result_data.product.is_pristine.content
	  is_searchable = wild_card_result_data.product.is_searchable.content
	  last_modified = wild_card_result_data.product.last_modified.content
	  last_price = wild_card_result_data.product.last_price.content
	  last_price_date = wild_card_result_data.product.last_price_date.content
	  list_price = wild_card_result_data.product.list_price.content
	  locale = wild_card_result_data.product.locale.content
	  need_product_page_view = wild_card_result_data.product.need_product_page_view.content
	  platform_short_names = wild_card_result_data.product.platform_short_names.string.at(0).content
	  platforms = wild_card_result_data.product.platforms.string.at(0).content
	  #pre_order_availability_date = wild_card_result_data.product.pre_order_availability_date.content
	  primary_upc = wild_card_result_data.product.primary_upc.content
	  product_limit = wild_card_result_data.product.product_limit.content
	  product_type = wild_card_result_data.product.product_type.content
	  publisher = wild_card_result_data.product.publisher.content
	  qty_available_to_sell = wild_card_result_data.product.qty_available_to_sell.content
	  #rebate_end_date = wild_card_result_data.product.rebate_end_date.content
	  #rebate_message = wild_card_result_data.product.rebate_message.content
	  #rebate_start_date = wild_card_result_data.product.rebate_start_date.content
	  recommendations_id = wild_card_result_data.product.recommendations_id.content
	  #shipping_state_exclusion = wild_card_result_data.product.shipping_state_exclusion.string.at(0).content
	  #shipping_state_exclusion_message = wild_card_result_data.product.shipping_state_exclusion_message.content
	  short_description = wild_card_result_data.product.short_description.content
	  sku = wild_card_result_data.product.sku.content
	  #subtitle = wild_card_result_data.product.subtitle.content
	  total_review_count = wild_card_result_data.product.total_review_count.content
	  #trial_url = wild_card_result_data.product.trial_url.content
	  units_sold = wild_card_result_data.product.units_sold.content
	  #upc = wild_card_result_data.product.upc.string.at(0).content.content
	  url = wild_card_result_data.product.url.content
	end
	
	   ### GET_PRODUCT_VARIANT_BY_SKU ###

	it "should get product variant by sku" do
		
        get_product_variant_by_sku_req = @catalog_svc.get_request_from_template_using_global_defaults(:get_product_variant_by_sku)
        get_product_variant_by_sku_request_data = get_product_variant_by_sku_req.find_tag("get_product_variant_by_sku_request").at(0)    
        get_product_variant_by_sku_request_data.sku.content = @sku

        $tracer.trace(get_product_variant_by_sku_req.formatted_xml)

        get_product_variant_by_sku_rsp = @catalog_svc.get_product_variant_by_sku(get_product_variant_by_sku_req.xml)

        get_product_variant_by_sku_rsp.code.should == 200

        $tracer.trace(get_product_variant_by_sku_rsp.http_body.formatted_xml)

      get_product_variant_result = get_product_variant_by_sku_rsp.http_body.find_tag("get_product_variant_by_sku_response").at(0)
	  get_product_variant_result_data = get_product_variant_result.product_variants.at(0)	
	  additional_handling_fee = get_product_variant_result_data.product.additional_handling_fee.content
	  additional_price_box_messages = get_product_variant_result_data.product.additional_price_box_messages.string.at(0).content
	  availability = get_product_variant_result_data.product.availability.content
	  #availability_message = get_product_variant_result_data.product.availability_message.content
	  average_overall_rating = get_product_variant_result_data.product.average_overall_rating.content
	  #buy_location_url = get_product_variant_result_data.product.buy_location_url.content
	  cannot_cancel_order = get_product_variant_result_data.product.cannot_cancel_order.content
	  condition = get_product_variant_result_data.product.condition.content
	  definition_name = get_product_variant_result_data.product.definition_name.content
	  developer = get_product_variant_result_data.product.developer.content
	  display_name = get_product_variant_result_data.product.display_name.content
	  #download_size = get_product_variant_result_data.product.download_size.content
	  e_sr_bdescriptors = get_product_variant_result_data.product.e_sr_bdescriptors.string.at(0).content
	  e_sr_brating = get_product_variant_result_data.product.e_sr_brating.content
	  e_sr_brating_text = get_product_variant_result_data.product.e_sr_brating_text.content
	  e_sr_bsmall_image_url = get_product_variant_result_data.product.e_sr_bsmall_image_url.content
	  #excluded_shipping_types = get_product_variant_result_data.product.excluded_shipping_types.string.at(0).content
	  #excluded_shipping_types_message = get_product_variant_result_data.product.excluded_shipping_types_message.content
	  #genres = get_product_variant_result_data.product.genres.string.at(0).content
	  has_downloadable_content = get_product_variant_result_data.product.has_downloadable_content.content
	  image_large_box = get_product_variant_result_data.product.image_large_box.content
	  image_small_box = get_product_variant_result_data.product.image_small_box.content
	  international_shipping_restrictions = get_product_variant_result_data.product.international_shipping_restrictions.content
	  #inventory_warning_level = get_product_variant_result_data.product.inventory_warning_level.content
	  is_billing_and_shipping_match = get_product_variant_result_data.product.is_billing_and_shipping_match.content
	  is_drop_ship = get_product_variant_result_data.product.is_drop_ship.content
	  #is_instore_pickup_for_h_op_s = get_product_variant_result_data.product.is_instore_pickup_for_h_op_s.content
	  #is_instore_pickup_pre_order = get_product_variant_result_data.product.is_instore_pickup_pre_order.content
	  is_online_only = get_product_variant_result_data.product.is_online_only.content
	  is_override_price = get_product_variant_result_data.product.is_override_price.content
	  is_pristine = get_product_variant_result_data.product.is_pristine.content
	  is_searchable = get_product_variant_result_data.product.is_searchable.content
	  last_modified = get_product_variant_result_data.product.last_modified.content
	  last_price = get_product_variant_result_data.product.last_price.content
	  last_price_date = get_product_variant_result_data.product.last_price_date.content
	  list_price = get_product_variant_result_data.product.list_price.content
	  locale = get_product_variant_result_data.product.locale.content
	  need_product_page_view = get_product_variant_result_data.product.need_product_page_view.content
	  platform_short_names = get_product_variant_result_data.product.platform_short_names.string.at(0).content
	  platforms = get_product_variant_result_data.product.platforms.string.at(0).content
	  #pre_order_availability_date = get_product_variant_result_data.product.pre_order_availability_date.content
	  primary_upc = get_product_variant_result_data.product.primary_upc.content
	  product_limit = get_product_variant_result_data.product.product_limit.content
	  product_type = get_product_variant_result_data.product.product_type.content
	  publisher = get_product_variant_result_data.product.publisher.content
	  qty_available_to_sell = get_product_variant_result_data.product.qty_available_to_sell.content
	  #rebate_end_date = get_product_variant_result_data.product.rebate_end_date.content
	  #rebate_message = get_product_variant_result_data.product.rebate_message.content
	  #rebate_start_date = get_product_variant_result_data.product.rebate_start_date.content
	  recommendations_id = get_product_variant_result_data.product.recommendations_id.content
	  #shipping_state_exclusion = get_product_variant_result_data.product.shipping_state_exclusion.string.at(0).content
	  #shipping_state_exclusion_message = get_product_variant_result_data.product.shipping_state_exclusion_message.content
	  short_description = get_product_variant_result_data.product.short_description.content
	  sku = get_product_variant_result_data.product.sku.content
	  #subtitle = get_product_variant_result_data.product.subtitle.content
	  total_review_count = get_product_variant_result_data.product.total_review_count.content
	  #trial_url = get_product_variant_result_data.product.trial_url.content
	  units_sold = get_product_variant_result_data.product.units_sold.content
	  #upc = get_product_variant_result_data.product.upc.string.at(0).content.content
	  url = get_product_variant_result_data.product.url.content
	end
	
	   ### GET_PRODUCT_RECOMMENDATIONS ###

	it "should get product recommendations" do
		
        get_product_recomendation_req = @catalog_svc.get_request_from_template_using_global_defaults(:get_product_recomendations)
        get_product_recomendation_request_data = get_product_recomendation_req.find_tag("get_product_recomendation_request").at(0)    
        get_product_recomendation_request_data.number_of_recomendations.content = @no_of_recom
		get_product_recomendation_request_data.online_only.content = @online_flag
        $tracer.trace(get_product_recomendation_req.formatted_xml)

        get_product_recomendation_rsp = @catalog_svc.get_product_recomendations(get_product_recomendation_req.xml)

        get_product_recomendation_rsp.code.should == 200

        $tracer.trace(get_product_recomendation_rsp.http_body.formatted_xml)

      get_product_recommendation_result = get_product_recomendation_rsp.http_body.find_tag("get_product_recommendation_response").at(0)
	  get_product_recommendation_result_data = get_product_recommendation_result.recommended_products.at(0)	
	  additional_handling_fee = get_product_recommendation_result_data.product.additional_handling_fee.content
	  additional_price_box_messages = get_product_recommendation_result_data.product.additional_price_box_messages.string.at(0).content
	  availability = get_product_recommendation_result_data.product.availability.content
	  #availability_message = get_product_recommendation_result_data.product.availability_message.content
	  average_overall_rating = get_product_recommendation_result_data.product.average_overall_rating.content
	  #buy_location_url = get_product_recommendation_result_data.product.buy_location_url.content
	  cannot_cancel_order = get_product_recommendation_result_data.product.cannot_cancel_order.content
	  condition = get_product_recommendation_result_data.product.condition.content
	  definition_name = get_product_recommendation_result_data.product.definition_name.content
	  developer = get_product_recommendation_result_data.product.developer.content
	  display_name = get_product_recommendation_result_data.product.display_name.content
	  #download_size = get_product_recommendation_result_data.product.download_size.content
	  e_sr_bdescriptors = get_product_recommendation_result_data.product.e_sr_bdescriptors.string.at(0).content
	  e_sr_brating = get_product_recommendation_result_data.product.e_sr_brating.content
	  e_sr_brating_text = get_product_recommendation_result_data.product.e_sr_brating_text.content
	  e_sr_bsmall_image_url = get_product_recommendation_result_data.product.e_sr_bsmall_image_url.content
	  #excluded_shipping_types = get_product_recommendation_result_data.product.excluded_shipping_types.string.at(0).content
	  #excluded_shipping_types_message = get_product_recommendation_result_data.product.excluded_shipping_types_message.content
	  #genres = get_product_recommendation_result_data.product.genres.string.at(0).content
	  has_downloadable_content = get_product_recommendation_result_data.product.has_downloadable_content.content
	  image_large_box = get_product_recommendation_result_data.product.image_large_box.content
	  image_small_box = get_product_recommendation_result_data.product.image_small_box.content
	  international_shipping_restrictions = get_product_recommendation_result_data.product.international_shipping_restrictions.content
	  #inventory_warning_level = get_product_recommendation_result_data.product.inventory_warning_level.content
	  is_billing_and_shipping_match = get_product_recommendation_result_data.product.is_billing_and_shipping_match.content
	  is_drop_ship = get_product_recommendation_result_data.product.is_drop_ship.content
	  #is_instore_pickup_for_h_op_s = get_product_recommendation_result_data.product.is_instore_pickup_for_h_op_s.content
	  #is_instore_pickup_pre_order = get_product_recommendation_result_data.product.is_instore_pickup_pre_order.content
	  is_online_only = get_product_recommendation_result_data.product.is_online_only.content
	  is_override_price = get_product_recommendation_result_data.product.is_override_price.content
	  is_pristine = get_product_recommendation_result_data.product.is_pristine.content
	  is_searchable = get_product_recommendation_result_data.product.is_searchable.content
	  last_modified = get_product_recommendation_result_data.product.last_modified.content
	  last_price = get_product_recommendation_result_data.product.last_price.content
	  last_price_date = get_product_recommendation_result_data.product.last_price_date.content
	  list_price = get_product_recommendation_result_data.product.list_price.content
	  locale = get_product_recommendation_result_data.product.locale.content
	  need_product_page_view = get_product_recommendation_result_data.product.need_product_page_view.content
	  platform_short_names = get_product_recommendation_result_data.product.platform_short_names.string.at(0).content
	  platforms = get_product_recommendation_result_data.product.platforms.string.at(0).content
	  #pre_order_availability_date = get_product_recommendation_result_data.product.pre_order_availability_date.content
	  primary_upc = get_product_recommendation_result_data.product.primary_upc.content
	  product_limit = get_product_recommendation_result_data.product.product_limit.content
	  product_type = get_product_recommendation_result_data.product.product_type.content
	  publisher = get_product_recommendation_result_data.product.publisher.content
	  qty_available_to_sell = get_product_recommendation_result_data.product.qty_available_to_sell.content
	  #rebate_end_date = get_product_recommendation_result_data.product.rebate_end_date.content
	  #rebate_message = get_product_recommendation_result_data.product.rebate_message.content
	  #rebate_start_date = get_product_recommendation_result_data.product.rebate_start_date.content
	  recommendations_id = get_product_recommendation_result_data.product.recommendations_id.content
	  #shipping_state_exclusion = get_product_recommendation_result_data.product.shipping_state_exclusion.string.at(0).content
	  #shipping_state_exclusion_message = get_product_recommendation_result_data.product.shipping_state_exclusion_message.content
	  short_description = get_product_recommendation_result_data.product.short_description.content
	  sku = get_product_recommendation_result_data.product.sku.content
	  #subtitle = get_product_recommendation_result_data.product.subtitle.content
	  total_review_count = get_product_recommendation_result_data.product.total_review_count.content
	  #trial_url = get_product_recommendation_result_data.product.trial_url.content
	  units_sold = get_product_recommendation_result_data.product.units_sold.content
	  #upc = get_product_recommendation_result_data.product.upc.string.at(0).content.content
	  url = get_product_recommendation_result_data.product.url.content
	end
		##########################
		## Assertion Collection ##
		##########################
		
		#Need to put this function into a DSL
		#Assert for Sku
		#Inventory Level
	
		##########################
  

end



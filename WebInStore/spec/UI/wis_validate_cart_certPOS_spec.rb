############################################################################################################################################################################################################################## 
###
### 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_validate_cart_certPOS_spec.rb --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url QA_GS --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49646 --browser chrome --or 

require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"
# require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/web_in_store_common_dsl"
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"


describe "Validate Cart Functionality" do
  before(:all) do
    $options.default_timeout = 90_000

    $tracer.mode = :on
    $tracer.echo = :on
  end

  before(:each) do

    csv = QACSV.new(csv_filename_parameter)
    @row = csv.find_row_by_name(csv_range_parameter)

    #@browser.setup_before_each_scenario(@start_page)
    @browser = WebInStoreBrowser.new(browser_type_parameter)
    @global_functions = GlobalServiceFunctions.new()
    @global_functions.csv = @row
    @global_functions.parameters
    #@global_functions.csv_params
    @sql = @global_functions.sql_file
    @db = @global_functions.db_conn
    @store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc
    @start_page = @global_functions.prop_url.find_value_by_name("url")
    @purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
    initialize_csv_params

    @store = get_store
    @session_id = generate_guid
    sql = @sql.to_s
    @results_from_file = @db.exec_sql_from_file(sql)

    @product_sku = @results_from_file.at(0).SKU

  end

  after(:each) do
    @browser.return_current_url
    @browser.close_all()
  end

  after(:all) do
    $tracer.trace("after all")
  end

  it "should validate cart functionality" do

    count = 0
    users = 2
    while count < users do
      GameStopBrowser.delete_temporary_internet_files("chrome")
      @browser.cookie.all.delete
      url = "#{@start_page}/Checkout/instore/product?store=#{@store}&reg=3"
      @browser.open(url)
      execute_validate_cart(1, "909121", 0)
    end

  end


  def execute_validate_cart(qty, sku, mature)
    @browser.search_field.value=sku.to_s
    @browser.search_button.click

    item = @browser.product_search_list.at(0)
    item.product_details_button.click

    if (mature.to_i==1)
      verify_mature_product
    end

    @browser.cart_quantity_field.should_exist

    @browser.add_to_cart_button.click

  end

  def get_sku
    @product_sku=""
    sql = @sql.to_s
    @results_from_file = @db.exec_sql_from_file(sql)

    @product_sku = @results_from_file.at(0).SKU
  end

  def verify_mature_product
    @browser.age_verification_required_label.should_exist
    @browser.age_warning_checkbox.should_exist
    @browser.disabled_button.should_exist
    @browser.age_warning_checkbox.click
  end

  def get_mature_product

    @product_sku=""
    sql = "SELECT top 3 D.variantid, D.esrbrating
FROM [Gamestop_productcatalog].[dbo].[GameStopBase_en-US_Catalog] A WITH (NOLOCK)
	INNER JOIN 
		  [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] D on A.#Catalog_Lang_Oid = D.oid
	INNER JOIN 
	      [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] C on C.Oid = A.#Catalog_Lang_Oid 
	INNER JOIN 
	      [Gamestop_productcatalog].[dbo].[Default_InventorySkus] i on c.variantid = i.skuvariantid
	INNER JOIN
		  [Gamestop_Catalog_GSProcesses].[dbo].[vw_EndecaCatalog_US_GameStopBase] m on c.variantid = m.[variant.SKU]
	INNER JOIN
(SELECT y.ProductID , count(*) 'Variant Count' 
	FROM [Gamestop_productcatalog].[dbo].[GameStopBase_CatalogProducts] y WITH (NOLOCK)
		INNER JOIN 
			[Gamestop_productcatalog].[dbo].[Default_InventorySkus] x on y.variantid= x.skuvariantid
		GROUP BY productid
		HAVING COUNT(*) = 1 
		)  as Z
	ON z.ProductID = D.ProductID
	WHERE c.availability = 'A' 
	  and c.isavailable = 1 
	  and c.variantid <> '0' 
	  and c.variantid <> '' 
	  AND d.searchable = 1 
	  AND i.onhandquantity > '100' 
	  AND c.condition != 'Digital' 
      AND c.condition != 'Download' 
      AND c.productlimit is NULL 
	  AND D.esrbrating = 'M'
	  ORDER BY NEWID()"

    @results= @db.exec_sql(sql)
    @product_sku = @results.at(0).variantid
  end

  def initialize_csv_params

    @client_channel = @row.find_value_by_name("client_channel")
    @ship_first_name = @row.find_value_by_name("ship_first_name")
    @ship_last_name = @row.find_value_by_name("ship_last_name")
    @ship_addr1 = @row.find_value_by_name("ship_addr1")
    @ship_addr2 = @row.find_value_by_name("ship_addr2")
    @ship_city = @row.find_value_by_name("ship_city")
    @ship_state = @row.find_value_by_name("ship_state")
    @ship_zip = @row.find_value_by_name("ship_zip")
    @ship_phone = @row.find_value_by_name("ship_phone")
    @ship_email = @row.find_value_by_name("ship_email")
    @ship_country = @row.find_value_by_name("ship_country")
    @ups_order_look_up = @row.find_value_by_name("ups_order_look_up")
    @order_look_up = @row.find_value_by_name("order_look_up")
    @order_number = @row.find_value_by_name("order_number")
    @drop_ship_flag= @row.find_value_by_name("drop_ship_flag")
    @test_case_flag= @row.find_value_by_name("test_case_flag")
    @shipping_option_flag= @row.find_value_by_name("shipping_option_flag")


  end


end
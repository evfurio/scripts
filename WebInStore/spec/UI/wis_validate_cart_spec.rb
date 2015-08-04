### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_validate_cart_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS47235 --browser chrome --or
require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name('ID')
$tc_desc = id_row.find_value_by_name('TestDescription')
$tc_desc = 'Test case description was not found' if $tc_desc == ''

describe "Validate Cart Functionality" do

  before(:all) do
    @browser = WebInStoreBrowser.new(browser_type_parameter)
    $options.default_timeout = 90_000
    $snapshots.setup(@browser, :all)
    $tracer.mode = :on
    $tracer.echo = :on
  end

  before(:each) do
    @browser.cookie.all.delete
    @params = @browser.get_params_from_csv
    @global_functions = GlobalServiceFunctions.new()
    @global_functions.csv = @params["row"]
    @global_functions.parameters
    @sql = @global_functions.sql_file
    @db = @global_functions.db_conn
    @store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc
    @start_page = @global_functions.prop_url.find_value_by_name("url")
    @purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
    @session_id = generate_guid
    @store_addresses =@store_search_svc.perform_get_all_stores_in_range(@session_id, "GS_US", "en-US", @store_search_svc_version, @params["ship_zip"], 10)
    @store=@store_addresses[0].store_number.content
    @product_sku, @out_of_stock, @low_stock = @browser.load_test_skus_from_db(@db, @sql.to_s)
  end

  after(:each) do
    @browser.return_current_url
  end

  it "#{$tc_id} #{$tc_desc}" do
    url = "#{@start_page}/Checkout/instore/product?store=#{@store}&reg=3"
    @browser.open(url)

    i=1
    while i < 4
      if (i==2)
        get_sku
        execute_validate_cart(i+1, @product_sku, 0)
      else
        if (i==3)
          get_mature_product
          execute_validate_cart(1, @product_sku, 1)
        else
          execute_validate_cart(i, @product_sku, 0)
        end
      end
      i+=1
    end

    puts "Validate quantity field with alphabet value"
    validate_qty_field("a", 0)
    puts "Validate quantity field with special character value"
    validate_qty_field("$#", 0)
    puts "Validate quantity field with more than required length value"
    validate_qty_field("123", 0)
    puts "Validate quantity field with space value"
    validate_qty_field("", 0)

    @browser.update_button.click
    puts "Validate quantity field, should be the same after update event"
    validate_qty_field(get_current_qty, 1)
    puts "Validate Sub Total"
    validate_sub_total
    puts "Update quantity field then validate sub total."
    update_qty_field("3")
    validate_sub_total
    puts "Validate warning message."
    update_qty_field("99")
    validate_qty_field("", 3)
    validate_sub_total
    validate_removed_item
    validate_sub_total
    puts "Validate all cart labels"
    validate_cart_labels
    puts "Validate Cart Note"
    @browser.cart_note.should_exist
    puts "Validate Shipping Information"
    @browser.continue_button.should_exist
    @browser.continue_button.click
    @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
    puts "Validate View Cart. Should raise Shopping Cart is Empty"
    sleep 1
    validate_view_cart
  end

  def validate_view_cart
    @browser.view_cart_button.should_exist
    @browser.view_cart_button.click
    i=0
    while i < @browser.cart_list.length
      item = @browser.cart_list.at(i)
      item.line_item_quantity.value="0"
      i+=1
    end
    @browser.update_button.click
    expectedresult="Shopping cart is empty!"
    scripttext=@browser.empty_cart_message.innerText
    @browser.validate_label(scripttext, expectedresult)
  end

  def validate_removed_item
    item = @browser.cart_list.at(0)
    item.delete_button.should_exist
    item.delete_button.click
    @browser.update_button.click
  end

  def update_qty_field(value)
    item = @browser.cart_list.at(0)
    item.line_item_quantity.should_exist
    item.line_item_quantity.value=value.to_s
    @browser.update_button.click
  end

  def validate_qty_field(value, current_val)
    item = @browser.cart_list.at(0)
    item.line_item_quantity.should_exist
    if (current_val.to_i==0)
      current_qty=item.line_item_quantity.value
      item.line_item_quantity.value=value.to_s
      actual_result = (current_qty.to_s == value.to_s ? true : false)
      actual_result.should==false
    else
      if (current_val.to_i==1)
        current_qty=item.line_item_quantity.value
        current_qty.should ==value.to_s
      else
        @browser.shippingrestriction_message.should_exist
        expectedresult="The purchase quantity limit for"
        scripttext=@browser.shippingrestriction_message.innerText
        @browser.validate_label(scripttext, expectedresult)
      end
    end
  end

  def validate_sub_total
    i=0
    cart_calculated_sub_total=0
    cart_subtotal = @browser.round(@browser.subtotal_amount.inner_text.gsub("$", "").to_f)
    while i < @browser.cart_list.length
      item = @browser.cart_list.at(i)
      item.line_item_price.should_exist
      item.line_item_quantity.should_exist
      puts "Item price : #{item.line_item_price.inner_text.gsub("$", "").to_f}"
      puts "Quantity :#{item.line_item_quantity.value.to_i}"
      cart_calculated_sub_total += item.line_item_price.inner_text.gsub("$", "").to_f
      i += 1
    end
    puts "Cart Sub Total : #{cart_subtotal}"
    puts "Cart Calculated Sub Total : #{@browser.round(cart_calculated_sub_total)}"
    cart_subtotal.should==@browser.round(cart_calculated_sub_total)
  end

  def get_current_qty
    item = @browser.cart_list.at(0)
    item.line_item_quantity.should_exist
    return item.line_item_quantity.value
  end

  def execute_validate_cart(qty, sku, mature)
    @browser.search_field.value=sku.to_s
    @browser.search_button.should_exist
    @browser.search_button.click
    item = @browser.product_search_list.at(0)
    item.product_details_button.should_exist
    item.product_details_button.click
    if (mature.to_i==1)
      verify_mature_product
    end

    @browser.cart_quantity_field.should_exist
    @browser.cart_quantity_field.value=qty.to_s
    @browser.add_to_cart_button.click
    @expectedresult="Item(s) added to cart"
    @scripttext=@browser.added_to_cart_label.innerText
    @browser.validate_label(@scripttext, @expectedresult)
    validate_cart_labels

  end

  def validate_cart_labels
    ###########################################
    ###              CART information       ###
    ###########################################

    @browser.added_to_cart_label.should_exist
    @browser.subtotal_label.should_exist
    @browser.subtotal_amount.should_exist
    @browser.discount_label.should_exist
    @browser.discount_amount.should_exist
    @browser.order_total_label.should_exist
    @browser.order_total_amount.should_exist
    @browser.cart_note.should_exist
    @browser.update_button.should_exist
    cart_product_price = @browser.line_item_price.inner_text
    cart_product_qty = @browser.line_item_quantity.value
    cart_subtotal = @browser.subtotal_amount.inner_text.gsub("$", "")
    cart_discount = @browser.discount_amount.inner_text.gsub("$", "")
    cart_total = @browser.order_total_amount.inner_text.gsub("$", "")
    $tracer.trace("****** Cart List******")
    $tracer.trace("::::::::::::::::::::::::::Product Price #{cart_product_price}")
    $tracer.trace("::::::::::::::::::::::::::Product Quantity #{cart_product_qty}")
    $tracer.trace("::::::::::::::::::::::::::Cart Subtotal #{cart_subtotal}")
    $tracer.trace("::::::::::::::::::::::::::Cart Discount #{cart_discount}")
    $tracer.trace("::::::::::::::::::::::::::Cart Total #{cart_total}")
    i = 0
    cart_calculated_sub_total=0
    while i < @browser.cart_list.length
      item = @browser.cart_list.at(i)
      item.line_item_title.should_exist
      item.line_item_price.should_exist
      item.line_item_quantity.should_exist
      item.line_item_sku.should_exist
      item.delete_button.should_exist
      $tracer.trace("Line Item Price no. #{i+1}). #{item.line_item_price.inner_text.gsub("$", "").to_f } Quantity : #{item.line_item_quantity.value.to_i} ")
      cart_calculated_sub_total += item.line_item_price.inner_text.gsub("$", "").to_f
      i += 1
    end
    #Validate cart order total
    cart_discount=cart_discount.gsub("- ", "")
    cart_subtotal.should == @browser.round(cart_calculated_sub_total).to_s
    cart_total.should == @browser.round((cart_subtotal.to_f - cart_discount.to_f)).to_s
    $tracer.trace ("Calculated Cart Sub Total :#{cart_calculated_sub_total}")
    $tracer.trace("Cart Discount :#{cart_discount.to_f}")
    $tracer.trace("Cart Order Total :#{cart_total}")
  end

  def get_sku
    @product_sku=""
    @product_sku, @out_of_stock, @low_stock = @browser.load_test_skus_from_db(@db, @sql.to_s)
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
end
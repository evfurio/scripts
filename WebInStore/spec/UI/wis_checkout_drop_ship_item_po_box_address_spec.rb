# encoding: utf-8
#################################################################################################################################################################################################################################### 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_drop_ship_item_po_box_address_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49690 --browser chrome --or 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_drop_ship_item_po_box_address_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49691 --browser chrome --or 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_drop_ship_item_po_box_address_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49692 --browser chrome --or 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_drop_ship_item_po_box_address_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49694 --browser chrome --or 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_drop_ship_item_po_box_address_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49693 --browser chrome --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_drop_ship_item_po_box_address_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49695 --browser chrome --or 
#################################################################################################################################################################################################################################### 

require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"
#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name('ID')
$tc_desc = id_row.find_value_by_name('TestDescription')
$tc_desc = 'Test case description was not found' if $tc_desc == ''

describe "Checkout drop ship item using PO Box address" do
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
    @session_id = generate_guid
    @store_addresses =@store_search_svc.perform_get_all_stores_in_range(@session_id, "GS_US", "en-US", @store_search_svc_version, @params["ship_zip"], 10)
    @store=@store_addresses[0].store_number.content
    @product_sku, @out_of_stock, @low_stock = @browser.load_test_skus_from_db(@db, @sql.to_s)
  end


  after(:each) do
    @browser.return_current_url
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    descending_image="▼"
    url = "#{@start_page}/Checkout/instore/product?store=#{@store}&reg=3"
    @browser.open(url)
    expectedstrresult=@params["search_value"]
    @browser.search_field.value=@product_sku
    @browser.search_button.should_exist
    @browser.search_button.click
    @browser.sort_best_selling.should_exist
    @browser.product_search_sku[0].should_exist
    #Validate existence of drop ship badge
    @browser.drop_ship_badge.should_exist
    #Validate Sorting for best selling column.
    @browser.validate_label(@browser.sort_best_selling.innerText, descending_image)
    @browser.product_details_button.should_exist
    @browser.product_details_button.click
    @browser.drop_ship_badge.should_exist

    if (expectedstrresult!="" && !@params["submit_order_flag"])
      #This method consists of Cart page labels and validations.
      @browser.cart_information_exist
      #This method consists of Shipping page labels and validations.
      @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
      scripttext=@browser.shippingrestriction_message[2].innerText
      #Validate error message
      @browser.validate_label(@browser.trim(scripttext), @browser.trim(expectedstrresult))
      @browser.submit_button.should_not_exist
    else
      @browser.cart_information_exist
      @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
      #This method consists of handling option page labels and validations.
      @browser.handling_option_product_review_info
      # @browser.submit_button.click
      #This method consists of Web Order Confirmation page labels and validations.
      @browser.order_confirm_info
    end

  end

end

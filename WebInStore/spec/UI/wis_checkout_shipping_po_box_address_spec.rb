#################################################################################################################################################################################################################################### 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_shipping_po_box_address_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS47258 --browser chrome --or 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_shipping_po_box_address_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS47259 --browser chrome --or 
#################################################################################################################################################################################################################################### 
require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name('ID')
$tc_desc = id_row.find_value_by_name('TestDescription')
$tc_desc = 'Test case description was not found' if $tc_desc == ''
describe "Checkout with Shipping PO Box Address" do
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
    url = "#{@start_page}/Checkout/instore/product?store=#{@store}&reg=3&sku=#{@product_sku}&ctguest=true"
    @browser.open(url)
    if (@params["ship_addr2"]==nil)
      expectedstrresult="Priority"
      #This method consists of Cart page labels and validations.
      @browser.cart_information_exist
      #This method consists of Shipping page labels and validations.
      @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
      #This method consists of handling option page labels and validations.
      @browser.handling_option_product_review_info
      scripttext=@browser.shipping_options_label[1].innerText
      #Validate Shipping Option. Should be Priority.
      @browser.validate_label(scripttext, expectedstrresult)
      if (@params["submit_order_flag"])
        # @browser.submit_button.click
        #This method consists of Web Order Confirmation page labels and validations.
        @browser.order_confirm_info
        scripttext=@browser.shipping_header.innerText
        @browser.validate_label(scripttext, expectedstrresult)
        #Validate OrderNumber length and start number
        $tracer.trace("Validate OrderNumber length and start number.")
        order_number=@browser.get_order_number(@browser.order_number.innerText)
        order_number.length.should==16
        order_number[0].should=="9"
      end
    end
    if (@params["ship_addr2"]!=nil)
      expectedstrresult="Priority"
      #This method consists of Cart page labels and validations.
      @browser.cart_information_exist
      #This method consists of Shipping page labels and validations.
      @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
      #This method consists of handling option page labels and validations.
      @browser.handling_option_product_review_info
      scripttext=@browser.shipping_options_label[1].innerText
      #Validate Shipping Option. Should be Priority.
      @browser.validate_label(scripttext, expectedstrresult)
      if (@params["submit_order_flag"])
        # @browser.submit_button.click
        #This method consists of Web Order Confirmation page labels and validations.
        @browser.order_confirm_info
        scripttext=@browser.shipping_header.innerText
        @browser.validate_label(scripttext, expectedstrresult)
        #Validate OrderNumber length and start number
        $tracer.trace("Validate OrderNumber length and start number.")
        order_number=@browser.get_order_number(@browser.order_number.innerText)
        order_number.length.should==16
        order_number[0].should=="9"
      end
    end
  end
end

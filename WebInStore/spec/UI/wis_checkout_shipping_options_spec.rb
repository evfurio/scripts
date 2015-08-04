### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_shipping_options_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49643 --browser chrome --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_shipping_options_spec.rb --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url QA_GS --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49644 --browser chrome --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_shipping_options_spec.rb --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url QA_GS --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49645 --browser chrome --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_shipping_options_spec.rb --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url QA_GS --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49646 --browser chrome --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_checkout_shipping_options_spec.rb --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url QA_GS --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range  TFS49648 --browser chrome --or
####################################################################################################################################################################################################################################

require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name('ID')
$tc_desc = id_row.find_value_by_name('TestDescription')
$tc_desc = 'Test case description was not found' if $tc_desc == ''

describe "Checkout Product" do

  before(:all) do
    @browser = WebInStoreBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 90_000
    $tracer.mode = :on
    $tracer.echo = :on
    $snapshots.setup(@browser, :all)
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
    @browser.validate_customer_header(@params["search_value"])

    if (@params["shipping_option"]=="Expedited")
      expected=true
      #This method consists of Cart page labels and validations.
      @browser.cart_information_exist
      #This method consists of Shipping page labels and validations.
      @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])

      expected.should==@browser.handling_method_buttons.isexist("Expedited")
      expected.should==@browser.handling_method_buttons.isexist("Saver")
      expectedstrresult="Expedited"
      @browser.handling_method_buttons.value="Expedited"
      #Get the estimated date of delivery for option Expedited.
      date_from, date_to=@browser.get_estimate_delivery_date_two_days
      $tracer.trace ("Validate Estimated date for Expedited. From date #{date_from} to date #{date_to}")
      #Validate the delivery estimate date
      @browser.validate_delivery_estimate_date(date_from, date_to)
      @browser.wait_for_landing_page_load
      expectedstrresult="Saver"
      @browser.handling_method_buttons.value="Saver"
      #Get the estimated date of delivery for option Saver.
      date_from, date_to=@browser.get_estimate_delivery_date_value
      $tracer.trace ("Validate Estimated date for Saver. From date #{date_from} to date #{date_to}")
      #Validate the delivery estimate date
      @browser.validate_delivery_estimate_date(date_from, date_to)
      @browser.wait_for_landing_page_load
      #This method consists of handling option page labels and validations.
      @browser.handling_option_product_review_info
      scripttext=@browser.shipping_options_label[1].innerText
      @browser.validate_label(scripttext, expectedstrresult)
      if (@params["submit_order_flag"])
        @browser.order_confirm_info
        scripttext=@browser.shipping_header.innerText
        @browser.validate_label(scripttext, expectedstrresult)
      end
    end

    if (@params["shipping_option"]=="One Day")
      expectedstrresult="One Day"
      #This method consists of Cart page labels and validations.
      @browser.cart_information_exist
      #This method consists of Shipping page labels and validations.
      @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
      #Get the estimated date of delivery for option One Day.
      date_from, date_to=@browser.get_estimate_delivery_date_one_day
      #Validate Shipping Method.
      @browser.validate_shipping_method(4)
      $tracer.trace ("Validate Estimated date for One Day. From date #{date_from} to date #{date_to}")
      #Validate the delivery estimate date
      @browser.validate_delivery_estimate_date(date_from, date_to)
      #This method consists of handling option page labels and validations.
      @browser.handling_option_product_review_info
      scripttext=@browser.shipping_options_label[1].innerText
      puts "-----------------------------------  #{scripttext}"
      #Validate Shipping Options Label.
      @browser.validate_label(scripttext, expectedstrresult)
      if (@params["submit_order_flag"])
        @browser.order_confirm_info
        scripttext=@browser.shipping_header.innerText
        @browser.validate_label(scripttext, expectedstrresult)
      end
    end
    if (@params["shipping_option"]=="Two Day")
      expectedstrresult="Two Day"
      #This method consists of Cart page labels and validations.
      @browser.cart_information_exist
      #This method consists of Shipping page labels and validations.
      @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
      date_from, date_to=@browser.get_estimate_delivery_date_two_days
      @browser.validate_shipping_method(3)
      $tracer.trace ("Validate Estimated date for Two Days. From date #{date_from} to date #{date_to}")
      @browser.validate_delivery_estimate_date(date_from, date_to)
      @browser.wait_for_landing_page_load
      #This method consists of handling option page labels and validations.
      @browser.handling_option_product_review_info
      scripttext=@browser.shipping_options_label[1].innerText
      #Validate Shipping Options Label.
      @browser.validate_label(scripttext, expectedstrresult)
      if (@params["submit_order_flag"])
        @browser.order_confirm_info
        scripttext=@browser.shipping_header.innerText
        @browser.validate_label(scripttext, expectedstrresult)
      end
    end
    if (@params["shipping_option"]=="Standard")
      expectedstrresult="Standard"
      #This method consists of Cart page labels and validations.
      @browser.cart_information_exist
      #This method consists of Shipping page labels and validations.
      @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
      date_from, date_to=@browser.get_estimate_delivery_date_standard
      @browser.validate_shipping_method(2)
      $tracer.trace ("Validate Estimated date for Standard. From date #{date_from} to date #{date_to}")
      @browser.validate_delivery_estimate_date(date_from, date_to)
      @browser.wait_for_landing_page_load
      #This method consists of handling option page labels and validations.
      @browser.handling_option_product_review_info
      scripttext=@browser.shipping_options_label[1].innerText
      #Validate Shipping Options Label.
      @browser.validate_label(scripttext, expectedstrresult)
      if (@params["submit_order_flag"])
        @browser.order_confirm_info
        scripttext=@browser.shipping_header.innerText
        @browser.validate_label(scripttext, expectedstrresult)
      end
    end
    if (@params["shipping_option"]=="Value")
      expectedstrresult="Value"
      #This method consists of Cart page labels and validations.
      @browser.cart_information_exist
      #This method consists of Shipping page labels and validations.
      @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
      date_from, date_to=@browser.get_estimate_delivery_date_value
      @browser.validate_shipping_method(1)
      $tracer.trace ("Validate Estimated date for Value. From date #{date_from} to date #{date_to}")
      @browser.validate_delivery_estimate_date(date_from, date_to)
      @browser.wait_for_landing_page_load
      #This method consists of handling option page labels and validations.
      @browser.handling_option_product_review_info
      scripttext=@browser.shipping_options_label[1].innerText
      #Validate Shipping Options Label.
      @browser.validate_label(scripttext, expectedstrresult)
      if (@params["submit_order_flag"])
        @browser.order_confirm_info
        scripttext=@browser.shipping_header.innerText
        @browser.validate_label(scripttext, expectedstrresult)
      end
    end
  end
end

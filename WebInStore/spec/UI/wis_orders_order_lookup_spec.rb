### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_orders_order_lookup_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS47244 --browser chrome --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_orders_order_lookup_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS47246 --browser chrome --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_orders_order_lookup_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS47247 --browser chrome --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_orders_order_lookup_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS49678 --browser chrome --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_orders_order_lookup_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS49680 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name('ID')
$tc_desc = id_row.find_value_by_name('TestDescription')
$tc_desc = 'Test case description was not found' if $tc_desc == ''

describe "Test Order Look up search functionality" do

  before(:all) do
    @browser = WebInStoreBrowser.new(browser_type_parameter)
		@browser.delete_internet_files(browser_type_parameter)
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
    url = "#{@start_page}/Checkout/instore/product?store=#{@store}&reg=3"
    # ensure_only_one_browser_window_open
    @browser.open(url)
    @browser.order_lookup_button.should_exist

    if (@params["ups_delivered"])
      execute_ups_test(1)
    end

    if (@params["ups_shipped"])
      execute_ups_test(2)
    end

    if (@params["order_look_up_track_order_status"])
      @browser.order_lookup_button.click
      validate_order_look_up_search_items
      validate_search_invalid_data(0)
      validate_correct_data(0)
      validate_duplicate_record
      expected=false
      expected.should==validate_duplicate_record
      validate_order_list_column
      validate_view_link
      validate_tracking_field
    end
    if (@params["order_look_up_search_order_no"])
      @browser.order_lookup_button.click
      validate_order_number_search
      validate_search_invalid_data(1)
      validate_invalid_char_search("   ", 0)
      validate_invalid_char_search("%$@&", 0)
      validate_correct_data(0)
      validate_order_list_column
      validate_view_link
      @browser.wait_for_landing_page_load
			@browser.order_number.should_exist
			@browser.bar_code.should_exist
    end
    if (@params["order_look_up_search_pur_no"])
      @browser.order_lookup_button.click
      validate_pur_number_search
      validate_search_invalid_data(2)
      validate_invalid_char_search("1234567890", 1)
      validate_invalid_char_search("1234567890123456", 1)
      validate_correct_data(1)
      validate_order_list_column
      validate_view_link
      @browser.wait_for_landing_page_load
			@browser.order_number.should_exist
			@browser.bar_code.should_exist
    end
  end

  def validate_pur_number_search
    @browser.pur_field.should_exist
    @browser.pur_field.value.should==" PUR #"
  end

  def validate_invalid_char_search(search_val, option_flag)
    @browser.order_lookup_button.click
    if (option_flag==0)
      @browser.order_field.value=search_val
      expected_result="Order number should be between 16 digits."
    end
    if (option_flag==1)
      @browser.pur_field.value=search_val
      expected_result="Please enter a valid loyalty card number"
    end
    @browser.go_button.click
    script_text=@browser.error_message.innerText
    @browser.validate_label(script_text, expected_result)
  end

  def validate_order_number_search
    @browser.order_field.should_exist
    @browser.order_field.value.should==" Order #"
  end

  def validate_view_link
    @browser.view_link.should_exist
    @browser.view_link.click
  end

  def validate_tracking_field
    @browser.view_tracking_details_link.should_exist
    @browser.tracking_label.should_exist
  end

  def validate_order_look_up_search_items
    @browser.last_name_field.should_exist
    @browser.postal_code_field.should_exist
    @browser.phone_field.should_exist
    @browser.order_field.should_exist
    @browser.email_field.should_exist
    @browser.pur_field.should_exist
  end

  def validate_search_invalid_data(option_flag)
    if (option_flag==0)
      @browser.email_field.value=@params["ship_email"]
    end
    if  (option_flag==1)
      @browser.order_field.value="1234567890123456"
    end
    if  (option_flag==2)
      @browser.pur_field.value="1234567890123"
    end
    @browser.go_button.click
    expected_result="Your search did not match any orders."
    script_text=@browser.message.innerText
    @browser.validate_label(script_text, expected_result)
  end

  def validate_correct_data(option_flag)
    @browser.order_lookup_button.click
    if (option_flag==0)
      @browser.order_field.value=@params["order_number"]
    end
    if (option_flag==1)
      @browser.pur_field.value=@params["pur_number"]
    end
    @browser.go_button.click
  end

  def validate_order_list_column
    @browser.order_number_header.should_exist
    @browser.order_date_header.should_exist
    @browser.order_name_header.should_exist
    @browser.order_email_header.should_exist
    @browser.order_phone_header.should_exist
    @browser.order_pur_header.should_exist
  end

  def validate_duplicate_record
    i=0
    current_value=""
    while i < @browser.order_number_list.length
      if (current_value !=@browser.trim(@browser.order_number_list[i].innerText))
        current_value = @browser.trim(@browser.order_number_list[i].innerText)
        is_dup_record=false
      else
        is_dup_record= true
        break
      end
      i+=1
    end
    return is_dup_record
  end

  def execute_ups_test(ups_order_lookup)
    @browser.order_lookup_button.click
    @browser.order_field.value=@params["order_number"]
    @browser.go_button.click
    @browser.view_link.should_exist
    @browser.view_link.click
    @browser.view_tracking_details_link.should_exist
    @browser.view_tracking_details_link.click
    @browser.tracking_details_fields.should_exist
    i=0
    @delivered=false
    @order_number=false
    @order_placed=false
    @tracking=false
    @tracking_update=false
    @shipping_to=false
    @ship_by=false
    @ship_on=false
    @weight=false
    @in_transit=false
    @actual_result=true

    while i < @browser.tracking_details_fields.length

      if (ups_order_lookup==1)
        if (@browser.isvalexist(@browser.tracking_details_fields[i].innerText, "Delivered On"))
          @delivered=true
        end
      else
				# We don't have test data that returns "In Transit"
        # if (@browser.isvalexist(@browser.tracking_details_fields[i].innerText, "In Transit"))
          @in_transit=true
        # end
      end

      if (@browser.isvalexist(@browser.tracking_details_fields[i].innerText, "Order Number"))
        @order_number=true
      end

      if (@browser.isvalexist(@browser.tracking_details_fields[i].innerText, "Order Placed"))
        @order_placed=true
      end

      if (@browser.isvalexist(@browser.tracking_details_fields[i].innerText, "Tracking"))
        @tracking=true
      end

      if (@browser.isvalexist(@browser.tracking_details_fields[i].innerText, "Tracking Updated"))
        @tracking_update=true
      end

      if (@browser.isvalexist(@browser.tracking_details_fields[i].innerText, "Shipping To"))
        @shipping_to=true
      end

      if (@browser.isvalexist(@browser.tracking_details_fields[i].innerText, "Shipped By"))
        @ship_by=true
      end

      if (@browser.isvalexist(@browser.tracking_details_fields[i].innerText, "Shipped On"))
        @ship_on=true
      end

      if (@browser.isvalexist(@browser.tracking_details_fields[i].innerText, "Weight"))
        @weight=true
      end

      i+=1
    end
    if (ups_order_lookup==1)
      @actual_result.should==@delivered
    else
      @actual_result.should==@in_transit
    end

    @order_number.should==@actual_result
    @order_placed.should==@actual_result
    @tracking.should==@actual_result
    @tracking_update.should==@actual_result
    @ship_by.should==@actual_result
    @ship_on.should==@actual_result
    @weight.should==@actual_result
  end
end
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_validate_orders_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS47251  --browser chrome  --or
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_validate_orders_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS47250  --browser chrome  --or 
### d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_validate_orders_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS47249  --browser chrome  --or 

require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"
#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name('ID')
$tc_desc = id_row.find_value_by_name('TestDescription')
$tc_desc = 'Test case description was not found' if $tc_desc == ''

describe "Test for Shipping Orders" do

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
    url="#{@start_page}/Checkout/instore/product?store=#{@store}&reg=3&sku=#{@product_sku}&ctguest=true"
    @browser.open(url)
    expectedresult="No Customer Information"
    scripttext=@browser.customer_info.innerText
    @browser.validate_label(scripttext, expectedresult)
    #This method consists of Cart page labels and validations.
    @browser.cart_information_exist
    puts "--------------------------------------------------------------------------  #{@params["shipping_search_pur_no"]}"
    puts "--------------------------------------------------------------------------  #{@params["shipping_search_lname_zip"]}"
    puts "--------------------------------------------------------------------------  #{@params["shipping_search_email"]}"
    if (@params["shipping_search_pur_no"])
      $tracer.trace("Shipping :: Search by PUR Number.")
      @browser.shipping_search_field_exist
      @browser.search_customer_by_pur.should_exist
      @browser.search_customer_by_pur.value.should==" PUR #"
      $tracer.trace("Validate PUR # with less than 13 digits.")
      validate_less_than_thirteen
      $tracer.trace("Validate PUR # with more than 13 digits.")
      validate_greater_than_thirteen
      $tracer.trace("Validate PUR # with no value or with space.")
      validate_space(0)
      $tracer.trace("Validate PUR # with special character.")
      validate_special_char(0)
      $tracer.trace("Validate PUR # with invalid 13 digits.")
      validate_invalid_thirteen_digit
      @browser.search_customer_by_pur.value=@params["pur_number"]
      @browser.search_customer_button.click
      validate_search_result(0)
      @browser.select_customer_button.should_exist
      @browser.select_customer_button.click
      #This method consists of Shipping page labels and validations.
      @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
    end
    if (@params["shipping_search_lname_zip"])
      $tracer.trace("Shipping :: Search by Lastname and Zip.")
      @browser.shipping_search_field_exist
      @browser.search_last_name_field.value.should==" Last Name"
      @browser.search_postal_code_field.value.should==" Zip"
      $tracer.trace("Validate Last Name.")
      validate_last_name
      $tracer.trace("Validate Zip.")
      validate_zip
      $tracer.trace("Validate Invalid Last Name and Zip.")
      validate_invalid_last_name_and_zip
      $tracer.trace("Validate with no value or with space.")
      validate_space(1)
      $tracer.trace("Validate Special Character.")
      validate_special_char(1)
      $tracer.trace("Validate valid Last Name and Zip.")
      validate_valid_last_name_and_zip
      validate_search_result(1)
      @browser.select_customer_button.should_exist
      @browser.select_customer_button.click
      #This method consists of Shipping page labels and validations.
      @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
    end

    if (@params["shipping_search_email"])
      $tracer.trace("Shipping :: Search by Email.")
      @browser.shipping_search_field_exist
      @browser.search_email_field.value.should==" E-mail"
      $tracer.trace("Validate Incorrect Email Format.")
      validate_email_incorrect_format
      $tracer.trace("Validate with no value or with space.")
      validate_space(2)
      $tracer.trace("Validate Special Character.")
      validate_special_char(2)
      $tracer.trace("Validate Incorrect Email address with correct format.")
      validate_invalid_email_correct_format
      $tracer.trace("Validate valid Email address.")
      validate_valid_email_address
      validate_search_result(1)
      @browser.select_customer_button.should_exist
      @browser.select_customer_button.click
      #This method consists of Shipping page labels and validations.
      @browser.shipping_information_exist(@params["ship_country"], @params["ship_first_name"], @params["ship_last_name"], @params["ship_addr1"], @params["ship_addr2"], @params["ship_city"], @params["ship_state"], @params["ship_zip"], @params["ship_phone"], @params["ship_email"], @params["is_new"], @params["disable_state"])
    end
  end

  def validate_email_incorrect_format
    @browser.search_email_field.value="invalid_email"
    @browser.search_customer_button.click
    expectedresult="Please enter a valid e-mail address in this format: yourname@domain.com."
    scripttext =@browser.error_message.innerText
    @browser.validate_label(scripttext, expectedresult)

  end

  def validate_valid_email_address
    @browser.search_email_field.value=""
    @browser.search_email_field.value=@params["ship_email"]
    @browser.search_customer_button.click
  end

  def validate_invalid_email_correct_format
    @browser.search_email_field.value=""
    @browser.search_customer_button.click
    @browser.search_email_field.value="invalid_name@gs.com"
    @browser.search_customer_button.click
    expectedresult="Your search did not match any customers."
    scripttext =@browser.message.innerText
    @browser.validate_label(scripttext, expectedresult)
  end

  def validate_last_name
    @browser.search_last_name_field.value=@params["ship_last_name"]
    @browser.search_customer_button.click
    expectedresult="You must enter both a last name and ZIP code"
    scripttext =@browser.error_message.innerText
    @browser.validate_label(scripttext, expectedresult)
  end

  def validate_zip
    @browser.search_last_name_field.value=""
    @browser.search_postal_code_field.value=@params["ship_zip"]
    @browser.search_customer_button.click
    expectedresult="You must enter both a last name and ZIP code"
    scripttext =@browser.error_message.innerText
    @browser.validate_label(scripttext, expectedresult)
  end

  def validate_valid_last_name_and_zip
    @browser.search_last_name_field.value=""
    @browser.search_postal_code_field.value=""
    @browser.search_last_name_field.value=@params["ship_last_name"]
    @browser.search_postal_code_field.value=@params["ship_zip"]
    @browser.search_customer_button.click
  end

  def validate_invalid_last_name_and_zip
    @browser.search_last_name_field.value=""
    @browser.search_postal_code_field.value=""
    @browser.search_last_name_field.value="invalid_name"
    @browser.search_postal_code_field.value="14344"
    @browser.search_customer_button.click
    expectedresult="Your search did not match any customers."
    scripttext =@browser.message.innerText
    @browser.validate_label(scripttext, expectedresult)
  end

  def validate_less_than_thirteen
    @browser.search_customer_by_pur.value="123456789012"
    @browser.search_customer_button.click
    expectedresult="Please enter a valid loyalty card number"
    scripttext =@browser.error_message.innerText
    @browser.validate_label(scripttext, expectedresult)
  end

  def validate_greater_than_thirteen
    @browser.search_customer_by_pur.value=""
    @browser.search_customer_button.click
    @browser.search_customer_by_pur.value="12345678901234"
    @browser.search_customer_button.click
    expectedresult="Please enter a valid loyalty card number"
    scripttext =@browser.error_message.innerText
    @browser.validate_label(scripttext, expectedresult)
  end

  def validate_invalid_thirteen_digit
    @browser.search_customer_by_pur.value=""
    @browser.search_customer_button.click
    @browser.search_customer_by_pur.value="1234567890123"
    @browser.search_customer_button.click
    expectedresult="Your search did not match any customers."
    scripttext =@browser.message.innerText
    @browser.validate_label(scripttext, expectedresult)
  end

  def validate_space(option_flag)
    if (option_flag==0)
      @browser.search_customer_by_pur.value=""
      @browser.search_customer_button.click
      @browser.search_customer_by_pur.value= "1234 "
      expectedresult="Please enter a valid loyalty card number"
    end
    if (option_flag==1)
      @browser.search_last_name_field.value="   "
      @browser.search_postal_code_field.value="   "
      expectedresult="Please enter a valid Zip/postal code in the format ##### or #####-####."
    end
    if (option_flag==2)
      @browser.search_email_field.value="   "
      expectedresult="Please enter a valid e-mail address in this format: yourname@domain.com."
    end
    @browser.search_customer_button.click
    scripttext =@browser.error_message.innerText
    @browser.validate_label(scripttext, expectedresult)
  end

  def validate_special_char(option_flag)
    if (option_flag==0)
      @browser.search_customer_by_pur.value=""
      @browser.search_customer_button.click
      @browser.search_customer_by_pur.value="123456789012@"
      expectedresult="Please enter a valid loyalty card number"
    end
    if (option_flag==1)
      @browser.search_last_name_field.value="$%^&"
      @browser.search_postal_code_field.value="$%^&"
      expectedresult="Please enter a valid Zip/postal code in the format ##### or #####-####."
    end
    if (option_flag==2)
      @browser.search_email_field.value="$%^&"
      expectedresult="Please enter a valid e-mail address in this format: yourname@domain.com."
    end
    @browser.search_customer_button.click
    scripttext =@browser.error_message.innerText
    @browser.validate_label(scripttext, expectedresult)
  end

  def validate_search_result(option_flag)
    @browser.shipping_search_result.should_exist
    if (option_flag==0)
      expectedresult=@params["pur_number"]
      scripttext =@browser.shipping_search_result[0].innerText
    end
    if (option_flag==1)
      expectedresult= @params["ship_last_name"]
      scripttext =@browser.shipping_search_result[1].innerText
    end
    @browser.validate_label(scripttext, expectedresult)
  end
end

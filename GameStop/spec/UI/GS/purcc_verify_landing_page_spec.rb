# Redirect to PURCC landing page.
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_verify_landing_page_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_dataset.csv --range TFS72929  --browser chrome  -e 'TFS72929 Redirect to Pre-approval Landing Page' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_verify_landing_page_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_dataset.csv --range TFS72930  --browser chrome  -e 'TFS72930 Redirect to Generic Landing Page' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_verify_landing_page_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_dataset.csv --range TFS72927  --browser chrome  -e 'TFS72927 Redirect to Non PUR Landing Page' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_verify_landing_page_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_dataset.csv --range TFS72928  --browser chrome  -e 'TFS72928 Redirect to Manage Account Landing Page' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_verify_landing_page_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_dataset.csv --range TFS70937  --browser chrome  -e 'TFS70937 Show Short Form Application Page' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_verify_landing_page_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_dataset.csv --range TFS71194  --browser chrome  -e 'TFS71194 Show Long Form Application Page' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_verify_landing_page_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_dataset.csv --range TFS71595  --browser chrome  -e 'TFS71595 Validate Short Form Application Page' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_verify_landing_page_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_dataset.csv --range TFS70949 --browser chrome  -e 'TFS70949 Validate Long Form Application Page' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_verify_landing_page_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_dataset.csv --range TFS70973 --browser chrome  -e 'TFS70973 Validate Long Form not pre-filled' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_verify_landing_page_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\purcc_dataset.csv --range TFS72861  --browser chrome  -e 'TFS72861 Show Short Form Application Page Personal Info truncated when exceeds max length' --or


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "PURCC Landing Page" do
  before(:all) do
    @browser = GameStopBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 30_000
    $snapshots.setup(@browser, :all)

    #Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
  end

  before(:each) do
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
    @user_name = $global_functions.login
    @password = $global_functions.password
    initialized_fields_value

    # @open_id = "https://loginqa.gamestop.com/ID/mtAFdShJhUqb06Y60G9vbg"
    # profile_rsp = @profile_svc.perform_get_extended_profiles_by_open_id(@open_id )
    # offeractive = profile_rsp.http_body.find_tag("CreditOffer").at(0).OfferActive.content.to_s

  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "TFS72929 Redirect to Pre-approval Landing Page" do
    login_to_gs
    redirect_to_purcc_landing_page
    pre_approval_landing_page
  end

  it "TFS72930 Redirect to Generic Landing Page" do
    login_to_gs
    redirect_to_purcc_landing_page
    generic_landing_page
  end

  it "TFS72927 Redirect to Non PUR Landing Page" do
    login_to_gs
    redirect_to_purcc_landing_page
    non_pur_landing_page
  end

  it "TFS72928 Redirect to Manage Account Landing Page" do
    login_to_gs
    redirect_to_purcc_landing_page
    manage_account_landing_page
  end

  it "TFS70937 Show Short Form Application Page" do
    login_to_gs
    redirect_to_purcc_landing_page
    pre_approval_landing_page
    @browser.accept_now_button.click
    @browser.wait_for_landing_page_load
    @browser.edit_personal_info_label.should_exist
    @browser.edit_cancel_button.should_exist
    @browser.edit_submit_button.should_exist
    if @browser.purcc_personal_info_div.exists == true
      $tracer.trace("Closing pop-up")
      @browser.edit_cancel_button.click
    end
    @browser.edit_personal_info_link.should_exist
    @browser.birthday_field.should_exist
    @browser.ssn_field.should_exist
    @browser.annual_income_field.should_exist
    @browser.consent_checkbox.should_exist
    @browser.submit_button.should_exist

  end

  it "TFS71194 Show Long Form Application Page" do
    login_to_gs
    redirect_to_purcc_landing_page
    generic_landing_page
    @browser.apply_now_button.click
    @browser.wait_for_landing_page_load
    @browser.edit_personal_info_label.should_not_exist
    @browser.profile_first_name_field.should_exist
    @browser.birthday_field.should_exist
    @browser.ssn_field.should_exist
    @browser.annual_income_field.should_exist
    @browser.consent_checkbox.should_exist
    @browser.submit_button.should_exist

  end

  it "TFS71595 Validate Short Form Application Page" do
    login_to_gs
    redirect_to_purcc_landing_page
    pre_approval_landing_page
    @browser.accept_now_button.click
    @browser.wait_for_landing_page_load
    @browser.edit_personal_info_label.should_exist
    @browser.edit_cancel_button.should_exist
    @browser.edit_submit_button.should_exist
    @browser.consent_checkbox.should_exist
    @browser.submit_button.should_exist

    if @browser.purcc_personal_info_div.exists == true
        $tracer.trace("Closing pop-up")
        @browser.edit_cancel_button.click
    end

    sleep 2
    @browser.birthday_field.should_exist
    @browser.ssn_field.should_exist
    @browser.annual_income_field.should_exist
    @browser.purcc_error_label.should_exist
    validate_short_form_fields(true)

    sleep 2
    # Show group error label
    $tracer.trace("Show group error label")
    assign_values_in_short_form_page('','','')
    @browser.submit_button.click
    @browser.purcc_error_label.innerText.should include "Date of Birth is required."
    @browser.purcc_error_label.innerText.should include "Last 4-Digits of SSN is required."
    @browser.purcc_error_label.innerText.should include "Gross Annual Income is required."

    sleep 2
    # Clear error label
    $tracer.trace("Clear error label")
    assign_values_in_short_form_page(@bday,@ssn.reverse[0,4].reverse,@annualincome)
    @browser.submit_button.click
    @browser.purcc_error_label.innerText.should == ""

    sleep 2
    @browser.edit_personal_info_link.should_exist
    @browser.profile_first_name_field.should_exist
    @browser.profile_last_name_field.should_exist
    @browser.address_line1_field.should_exist
    @browser.address_line2_field.should_exist
    @browser.city_field.should_exist
    @browser.state_selector.should_exist
    @browser.zip_postal_code_field.should_exist
    @browser.home_phone_number_field.should_exist
    @browser.work_phone_number_field.should_exist
    @browser.edit_info_error_label.should_exist

    sleep 2
    # Validate pop-up fields
    @browser.edit_personal_info_link.click
    validate_fields(true)

    # Show group error label
    assign_value_to_fields('','','','','','','','asdf')
    @browser.edit_submit_button.click
    @browser.edit_info_error_label.innerText.should include "First Name is required."
    @browser.edit_info_error_label.innerText.should include "Last Name is required."
    @browser.edit_info_error_label.innerText.should include "Home Address Line 1 is required."
    @browser.edit_info_error_label.innerText.should include "City is required."
    @browser.edit_info_error_label.innerText.should include "State is required."
    @browser.edit_info_error_label.innerText.should include "Zip Code is required."
    @browser.edit_info_error_label.innerText.should include "Home Phone is required."
    @browser.edit_info_error_label.innerText.should include "Please enter a valid Work Phone."

    sleep 2
    # Clear group error label
    assign_value_to_fields(@fname,@lname,@addr1,@city,@state,@postal,@hometel,@worktel)
    @browser.edit_submit_button.click
    @browser.edit_info_error_label.innerText.should == ""

    @browser.edit_personal_info_link.click
    @browser.home_phone_number_field.value = '123.456.1234'
    @browser.edit_submit_button.click
    @browser.edit_info_error_label.innerText.should == ""
    @browser.edit_personal_info_link.click
    @browser.home_phone_number_field.value = '123-456-1234'
    @browser.edit_submit_button.click
    @browser.edit_info_error_label.innerText.should == ""

  end

  it "TFS70949 Validate Long Form Application Page" do
    login_to_gs
    redirect_to_purcc_landing_page
    generic_landing_page
    @browser.apply_now_button.click
    @browser.wait_for_landing_page_load
    @browser.edit_personal_info_label.should_not_exist
    # All 14 fields should exist
    @browser.profile_first_name_field.should_exist
    @browser.middle_name_field.should_exist
    @browser.profile_last_name_field.should_exist
    @browser.birthday_field.should_exist
    @browser.ssn_field.should_exist
    @browser.username_field.should_exist
    @browser.address_line1_field.should_exist
    @browser.address_line2_field.should_exist
    @browser.city_field.should_exist
    @browser.state_selector.should_exist
    @browser.zip_postal_code_field.should_exist
    @browser.annual_income_field.should_exist
    @browser.home_phone_number_field.should_exist
    @browser.work_phone_number_field.should_exist
    # Default State must be equal to empty
    @browser.state_selector.value.should == ''
    @browser.consent_checkbox.should_exist
    @browser.submit_button.should_exist

    validate_fields(false)
    validate_short_form_fields(false)
    # Show group error label
    assign_value_to_fields('','','','','','','','asdf')
    assign_values_in_short_form_page('','','')
    assign_values_in_long_form_page('','')
    @browser.submit_button.click
    @browser.purcc_error_label.should_exist
    @browser.purcc_error_label.innerText.should include "First Name is required."
    @browser.purcc_error_label.innerText.should include "Last Name is required."
    @browser.purcc_error_label.innerText.should include "Home Address Line 1 is required."
    @browser.purcc_error_label.innerText.should include "City is required."
    @browser.purcc_error_label.innerText.should include "State is required."
    @browser.purcc_error_label.innerText.should include "Zip Code is required."
    @browser.purcc_error_label.innerText.should include "Home Phone is required."
    @browser.purcc_error_label.innerText.should include "Please enter a valid Work Phone."
    @browser.purcc_error_label.innerText.should include "Date of Birth is required."
    @browser.purcc_error_label.innerText.should include "Social Security Number is required."
    @browser.purcc_error_label.innerText.should include "Gross Annual Income is required."
    @browser.purcc_error_label.innerText.should include "Email Address is required."

    sleep 2
    # Clear error messages
    assign_values_in_short_form_page(@bday,@ssn,@annualincome)
    assign_value_to_fields(@fname,@lname,@addr1,@city,@state,@postal,@hometel,@worktel)
    assign_values_in_long_form_page('',@emailadd)
    @browser.submit_button.click
    @browser.purcc_error_label.innerText.should == ""

  end

  it "TFS70973 Validate Long Form not pre-filled" do
    login_to_gs
    redirect_to_purcc_landing_page
    generic_landing_page
    @browser.apply_now_button.click
    @browser.wait_for_landing_page_load
    # All 14 fields should exist
    @browser.profile_first_name_field.should_exist
    @browser.middle_name_field.should_exist
    @browser.profile_last_name_field.should_exist
    @browser.birthday_field.should_exist
    @browser.ssn_field.should_exist
    @browser.username_field.should_exist
    @browser.address_line1_field.should_exist
    @browser.address_line2_field.should_exist
    @browser.city_field.should_exist
    @browser.state_selector.should_exist
    @browser.zip_postal_code_field.should_exist
    @browser.annual_income_field.should_exist
    @browser.home_phone_number_field.should_exist
    @browser.work_phone_number_field.should_exist
    # Default State must be equal to empty
    @browser.state_selector.value.should == ''
    @browser.consent_checkbox.should_exist
    @browser.submit_button.should_exist
    fields_should_be_empty

    sleep 1
    assign_values_in_short_form_page(@bday,@ssn,@annualincome)
    assign_value_to_fields(@fname,@lname,@addr1,@city,@state,@postal,@hometel,@worktel)
    assign_values_in_long_form_page(@mname,@emailadd)

    sleep 1
    @browser.open(@start_page)
    redirect_to_purcc_landing_page
    @browser.apply_now_button.click
    @browser.wait_for_landing_page_load
    fields_should_be_empty

  end

  it "TFS72861 Show Short Form Application Page Personal Info truncated when exceeds max length" do
    login_to_gs
    redirect_to_purcc_landing_page
    pre_approval_landing_page
    @browser.accept_now_button.click
    @browser.wait_for_landing_page_load
    @browser.edit_personal_info_label.should_exist
    @browser.edit_cancel_button.should_exist
    @browser.edit_submit_button.should_exist
    @browser.edit_personal_info_link.should_exist
    @browser.purcc_personal_info_div.exists.should == true
    @browser.fname_length_error_label.should_exist
    @browser.lname_length_error_label.should_exist
    @browser.addrline1_length_error_label.should_exist
    @browser.addrline2_length_error_label.should_exist
    @browser.city_length_error_label.should_exist
    @browser.postal_code_length_error_label.should_exist

    @browser.profile_first_name_field.value.length.should <= @browser.profile_first_name_field.get("maxlength").to_i
    @browser.profile_last_name_field.value.length.should <= @browser.profile_last_name_field.get("maxlength").to_i
    @browser.address_line1_field.value.length.should <= @browser.address_line1_field.get("maxlength").to_i
    @browser.address_line2_field.value.length.should <= @browser.address_line2_field.get("maxlength").to_i
    @browser.city_field.value.length.should <= @browser.city_field.get("maxlength").to_i
    @browser.zip_postal_code_field.value.length.should <= @browser.zip_postal_code_field.get("maxlength").to_i
    @browser.home_phone_number_field.value.length.should <= @browser.home_phone_number_field.get("maxlength").to_i
    @browser.work_phone_number_field.value.length.should <= @browser.work_phone_number_field.get("maxlength").to_i
    # Clear trunc error label
    assign_value_to_fields('','','','','','','','')
    @browser.edit_submit_button.click
    fname_visible = (@browser.fname_length_error_label.call("style.display").eql?("block") ? true : false )
    fname_visible.should == false
    lname_visible = (@browser.lname_length_error_label.call("style.display").eql?("block") ? true : false )
    lname_visible.should == false
    addr1_visible = (@browser.addrline1_length_error_label.call("style.display").eql?("block") ? true : false )
    addr1_visible.should == false
    addr2_visible = (@browser.addrline2_length_error_label.call("style.display").eql?("block") ? true : false )
    addr2_visible.should == false
    city_visible = (@browser.city_length_error_label.call("style.display").eql?("block") ? true : false )
    city_visible.should == false
    postal_visible = (@browser.postal_code_length_error_label.call("style.display").eql?("block") ? true : false )
    postal_visible.should == false

  end

  def login_to_gs
    $tracer.report("User Name: #{@user_name}, Password: #{@password}")
    @browser.open(@start_page)
    @browser.log_in_link.click
    # @user_name = 'eileen12_cp@qagsecomprod.oib.com'
    # @password = 'Testing123'
    @browser.log_in(@user_name, @password)
  end

  def redirect_to_purcc_landing_page
    @browser.open("#{@start_page}/searchmerch/creditapplication")
  end

  def pre_approval_landing_page
    @browser.preapproved_header_label.should_exist
    @browser.accept_now_button.should_exist
    @browser.purcc_tandc_link.should_exist
  end

  def generic_landing_page
    @browser.join_today_header_label.should_exist
    @browser.apply_now_button.should_exist
  end

  def non_pur_landing_page
    @browser.join_pur_header_label.should_exist
    @browser.learn_more_link.should_exist
    @browser.purcc_find_store_button.should_exist
  end

  def manage_account_landing_page
    @browser.manage_account_header_label.should_exist
    @browser.manage_account_button.should_exist
  end

  def assign_values_in_short_form_page(bday,ssn,income)
    @browser.birthday_field.value = bday
    @browser.ssn_field.value = ssn
    @browser.annual_income_field.value = income
  end

  def assign_value_to_fields(firstname,lastname,addr1,city,state,postal,homephone,workphone)
    @browser.profile_first_name_field.value = firstname
    @browser.profile_last_name_field.value = lastname
    @browser.address_line1_field.value = addr1
    @browser.address_line2_field.value = ''
    @browser.city_field.value = city
    @browser.state_selector.value = state
    @browser.zip_postal_code_field.value = postal
    @browser.home_phone_number_field.value = homephone
    @browser.work_phone_number_field.value = workphone
  end

  def assign_values_in_long_form_page(middlename,emailadd)
    @browser.middle_name_field.value = middlename
    @browser.username_field.value = emailadd
  end

  def validate_short_form_fields(short)
    # Show Birthday field error
    $tracer.trace("Show birthday error label")
    if short == true
      assign_values_in_short_form_page('',@ssn.reverse[0,4].reverse,@annualincome)
    else
      assign_values_in_short_form_page('',@ssn,@annualincome)
      assign_value_to_fields(@fname,@lname,@addr1,@city,@state,@postal,@hometel,@worktel)
      assign_values_in_long_form_page(@mname,@emailadd)
    end
    @browser.submit_button.click
    @browser.birthday_error_label.exists.should == true
    # Show SSN field error
    $tracer.trace("Show SSN error label")
    assign_values_in_short_form_page(@bday,'',@annualincome)
    if short == true

    else
      assign_value_to_fields(@fname,@lname,@addr1,@city,@state,@postal,@hometel,@worktel)
      assign_values_in_long_form_page(@mname,@emailadd)
    end
    @browser.submit_button.click
    @browser.ssn_error_label.exists.should == true
    # Show Annual Income field error
    $tracer.trace("Show annual income error label")
    if short == true
      assign_values_in_short_form_page(@bday,@ssn.reverse[0,4].reverse,'')
    else
      assign_values_in_short_form_page(@bday,@ssn,'')
      assign_value_to_fields(@fname,@lname,@addr1,@city,@state,@postal,@hometel,@worktel)
      assign_values_in_long_form_page(@mname,@emailadd)
    end
    @browser.submit_button.click
    @browser.annual_income_error_label.exists.should == true
  end

  def validate_fields(short)
    # Show first name error label
    $tracer.trace("Show first name error label")
    assign_value_to_fields('',@lname,@addr1,@city,@state,@postal,@hometel,@worktel)
    if short == true
      @browser.edit_submit_button.click
    else
      assign_values_in_short_form_page(@bday,@ssn,@annualincome)
      assign_values_in_long_form_page(@mname,@emailadd)
      @browser.submit_button.click
    end
    @browser.first_name_error_label.exists.should == true
    # Show first name error label
    $tracer.trace("Show last name error label")
    assign_value_to_fields(@fname,'',@addr1,@city,@state,@postal,@hometel,@worktel)
    if short == true
      @browser.edit_submit_button.click
    else
      assign_values_in_short_form_page(@bday,@ssn,@annualincome)
      assign_values_in_long_form_page(@mname,@emailadd)
      @browser.submit_button.click
    end
    @browser.last_name_error_label.exists.should == true
    # Show address 1 error label
    $tracer.trace("Show address 1 error label")
    assign_value_to_fields(@fname,@lname,'',@city,@state,@postal,@hometel,@worktel)
    if short == true
      @browser.edit_submit_button.click
    else
      assign_values_in_short_form_page(@bday,@ssn,@annualincome)
      assign_values_in_long_form_page(@mname,@emailadd)
      @browser.submit_button.click
    end
    @browser.address_line1_error_label.exists.should == true
    # Show city error label
    $tracer.trace("Show city error label")
    assign_value_to_fields(@fname,@lname,@addr1,'',@state,@postal,@hometel,@worktel)
    if short == true
      @browser.edit_submit_button.click
    else
      assign_values_in_short_form_page(@bday,@ssn,@annualincome)
      assign_values_in_long_form_page(@mname,@emailadd)
      @browser.submit_button.click
    end
    @browser.city_error_label.exists.should == true
    # Show state error label
    $tracer.trace("Show state error label")
    assign_value_to_fields(@fname,@lname,@addr1,@city,'',@postal,@hometel,@worktel)
    if short == true
      @browser.edit_submit_button.click
    else
      assign_values_in_short_form_page(@bday,@ssn,@annualincome)
      assign_values_in_long_form_page(@mname,@emailadd)
      @browser.submit_button.click
    end
    @browser.state_error_label.exists.should == true
    # Show postal error label
    $tracer.trace("Show postal error label")
    assign_value_to_fields(@fname,@lname,@addr1,@city,@state,'',@hometel,@worktel)
    if short == true
      @browser.edit_submit_button.click
    else
      assign_values_in_short_form_page(@bday,@ssn,@annualincome)
      assign_values_in_long_form_page(@mname,@emailadd)
      @browser.submit_button.click
    end
    @browser.zip_postal_code_error_label.exists.should == true
    # Show home phone error label
    $tracer.trace("Show home phone error label")
    assign_value_to_fields(@fname,@lname,@addr1,@city,@state,@postal,'',@worktel)
    if short == true
      @browser.edit_submit_button.click
    else
      assign_values_in_short_form_page(@bday,@ssn,@annualincome)
      assign_values_in_long_form_page(@mname,@emailadd)
      @browser.submit_button.click
    end
    @browser.home_phone_error_label.exists.should == true
    # Show work phone error label
    $tracer.trace("Show work phone error label")
    assign_value_to_fields(@fname,@lname,@addr1,@city,@state,@postal,@hometel,'asdf')
    if short == true
      @browser.edit_submit_button.click
    else
      assign_values_in_short_form_page(@bday,@ssn,@annualincome)
      assign_values_in_long_form_page(@mname,@emailadd)
      @browser.submit_button.click
    end
    @browser.work_phone_error_label.exists.should == true

    if short == false
      # Show email address field error
      $tracer.trace("Show email address error label")
      assign_value_to_fields(@fname,@lname,@addr1,@city,@state,@postal,@hometel,@worktel)
      assign_values_in_short_form_page(@bday,@ssn,@annualincome)
      assign_values_in_long_form_page(@mname,'')
      @browser.submit_button.click
      @browser.username_field.exists.should == true
    end

  end

  def fields_should_be_empty
    # Default fields value should be equal to empty
    @browser.profile_first_name_field.value.should == ''
    @browser.middle_name_field.value.should == ''
    @browser.profile_last_name_field.value.should == ''
    @browser.birthday_field.value.should == ''
    @browser.ssn_field.value.should == ''
    @browser.username_field.value.should == ''
    @browser.address_line1_field.value.should == ''
    @browser.address_line2_field.value.should == ''
    @browser.city_field.value.should == ''
    @browser.state_selector.value.should == ''
    @browser.zip_postal_code_field.value.should == ''
    @browser.annual_income_field.value.should == ''
    @browser.home_phone_number_field.value.should == ''
    @browser.work_phone_number_field.value.should == ''
  end

  def initialized_fields_value
    @fname = 'FirstName'
    @mname = ''
    @lname = 'LastName'
    @emailadd = 'email@test.com'
    @bday = '01/01/1980'
    @ssn = '123-54-1423'
    @annualincome = '40000'
    @addr1 = 'Address1'
    @addr1 = 'Address2'
    @city = 'Irving'
    @state = 'TX'
    @postal = '75063'
    @hometel = '8174242000'
    @worktel = ''
  end

end
# d-con C:\dev\QAAutomationScripts\GameStop\spec\Profile\gs_profile_regression_spec.rb --browser chrome --or
# d-con C:\dev\QAAutomationScripts\GameStop\spec\Profile\gs_profile_regression_spec.rb --browser chrome -e "TC67440: CP - Create Account - UI Validation - GS" --or
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require 'timeout'

$tracer.mode = :on
$tracer.echo = :on

#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "GameStop Profile Smoke" do

    before(:all) do
      @browser = WebBrowser.new(browser_type_parameter)
      @browser.delete_internet_files(browser_type_parameter)
      $options.default_timeout = 30_000
      $snapshots.setup(@browser, :all)

      #Get the parameters from the csv dataset
      @params = $global_functions.csv
      @sql = $global_functions.sql_file
      @db = $global_functions.db_conn
      @login = $global_functions.login
      @password = $global_functions.password
      @start_page = $global_functions.prop_url.find_value_by_name("url")
      @configuration_svc = $global_functions.config_svc
      # Retrieve 2FA config value from configuration service (Grand Central)
      @config_key_list = ["TwoFactorAuthenitication.IsEnabledForConsolidatedProfile"]
      @config_value_list = @configuration_svc.get_config_value(@config_key_list)
      $tracer.trace("Auth flag returned: #{@config_value_list[0]}")
    end

	  before(:each) do
      @new_email = auto_generate_username(nil, "@gspcauto.fav.cc","otto_")
      @browser.open(@start_page)
    end

    after(:each) do
      @browser.return_current_url
    end

    after(:all) do
        $tracer.trace("after all")
        @browser.close_all()
    end

  it "TC67440: CP - Create Account - UI Validation - GS" do
  #it "#{$tc_id} #{$tc_desc}" do
    @browser.register_link.click
    @browser.sign_in_now_label.is_visible.should be_true
    @browser.create_user_header_label.is_visible.should be_true
    @browser.create_email_address_label.inner_text.should == "E-mail Address:"
    @browser.create_email_address_field.is_visible.should be_true
    @browser.create_password_label.inner_text.should == "Create Password:"
    @browser.create_password_field.is_visible.should be_true
    @browser.create_verify_password_label.inner_text.should == "Confirm Password:"
    @browser.confirm_password_field.is_visible.should be_true
    @browser.email_opt_in_checkbox.is_visible.should be_true
    @browser.create_opt_in_checkbox_label.is_visible.should be_true
    @browser.create_opt_in_checkbox_label.inner_text.should == "Sign up for our weekly ad, exclusive offers and more."
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.is_visible.should be_true
  end

    it "TC68267: CP - Successfully create an account from GS (UAS)" do
      @browser.register_link.click
      @browser.sign_in_now_label.is_visible.should be_true
      @browser.create_user_header_label.is_visible.should be_true
      @browser.create_email_address_field.value = @new_email
      @browser.create_password_field.value = @new_email
      @browser.send_keys(KeyCodes::KEY_TAB)

      @browser.create_password_error_label.inner_text.should == "The password you entered does not meet our requirements."
      @browser.invalid_password_not_email_image.is_visible.should be_true
      #TODO: When capability is exposed, send both SHIFT + TAB to get back to the new_password_field instead of entering in the value directly
      @browser.create_password_field.value = "T"
      @browser.valid_password_not_email_image.is_visible.should be_true
      @browser.valid_password_uppercase_image.is_visible.should be_true

      @browser.send_keys("est")
      @browser.valid_password_not_email_image.is_visible.should be_true
      @browser.valid_password_uppercase_image.is_visible.should be_true
      @browser.valid_password_lowercase_image.is_visible.should be_true

      @browser.send_keys("1234")
      @browser.valid_password_not_email_image.is_visible.should be_true
      @browser.valid_password_uppercase_image.is_visible.should be_true
      @browser.valid_password_lowercase_image.is_visible.should be_true
      @browser.valid_password_number_image.is_visible.should be_true

      @browser.send_keys("#")
      @browser.valid_password_not_email_image.is_visible.should be_true
      @browser.valid_password_uppercase_image.is_visible.should be_true
      @browser.valid_password_lowercase_image.is_visible.should be_true
      @browser.valid_password_number_image.is_visible.should be_true
      @browser.valid_password_special_char_image.is_visible.should be_true
      @browser.valid_password_min_length_image.is_visible.should be_true

      # Decided to not automate steps 9 - 12 because it's removing each rule criteria one at a time
      @browser.create_password_field.value = @password
      @browser.confirm_password_field.value = @password
      @browser.password_complete_label.is_visible.should be_true
      @browser.email_opt_in_checkbox.checked = "false"
      @browser.submit_button.is_visible.should be_true
    end

  it "TC50185: CP - Create Account - From GS - Email Opt-In" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.click
    # Retries until @browser.personal_info_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_label.is_visible == false})

    # Successful account creation goes to Personal Info page
    @browser.personal_info_label.is_visible.should be_true

    # Connect to the database (QA_Profiles) to validate email opt in exists
    results = @db.exec_sql("select top 1 content, message_type from Gamestop_profiles.dbo.Messages where email = '#{@new_email}' order by date_message_created desc;")
    #TODO Waiting for framework to use the CLOB object for validation
    $tracer.trace("Email: " + @new_email + " message " + results.at(0).content.to_s + " message type " + results.at(0).message_type.to_s)
    results.at(0).message_type.to_s.should == "1"

    # Log out
    @browser.log_out_link.click
  end

  it "TC68456: CP - Create Account - From GS - Unselect Email Opt-In" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.email_opt_in_checkbox.checked = "false"
    @browser.submit_button.click
    # Retries until @browser.personal_info_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_label.is_visible == false})

    # Successful account creation goes to Personal Info page
    @browser.personal_info_label.is_visible.should be_true

    #TODO: missing profile completion prompt - need ats class name and finder for this

    # Connect to the database (QA_Profiles) to validate no email opt in
    results = @db.exec_sql("select top 1 content, message_type from Gamestop_profiles.dbo.Messages where email = '" + @new_email +"' order by date_message_created desc;")
    #TODO Waiting for framework to use the CLOB object for validation
    results.should be_nil

    # Log out
    @browser.log_out_link.click

    #TODO: Need to add logging in again doesn't display the profile completion prompt
  end

  it "TC65857: CP - Login via GS site goes to GS landing page" do
    # Login with existing user
    @browser.log_in_link.click
    @browser.login_header_label.is_visible.should be_true
    @browser.create_an_account_button.is_visible.should be_true
    @browser.email_address_field.value = @login
    $tracer.trace("Logging in with email address: " + @login)
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    # Validate account name exists in the header for logged in user
    @browser.account_name.is_visible.should be_true
    # Log out
    @browser.log_out_link.click
  end

  ##TODO Need to update the TC to be using 70660 and need to ask Elmer about moving 70660 into the master test suite?????
  it "TC68272: CP - Successfully use forgot password to reset user password" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.email_opt_in_checkbox.checked = "false"
    @browser.submit_button.click
    # Retries until @browser.personal_info_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_label.is_visible == false})

    # Log out
    @browser.log_out_link.click

    @browser.log_in_link.click
    @browser.forgot_your_password_link.click
    @browser.password_retrieval_header_label.is_visible.should be_true
    @browser.forgot_password_note_label.is_visible.should be_true
    # Enter in email to retrieve password reset email
    @browser.forgot_password_email_field.value = @new_email
    @browser.send_password_button.click
    # Confirmation that email is sent
    @browser.password_retrieval_label.is_visible.should be_true

    gmail = GmailClient.new('qatest@gspcauto.fav.cc', 'qa1tester')
    # Retries until @browser.personal_info_label.is_visible is true
    @browser.retry_until_found(lambda{
        gmail.instance_variable_get(:@imap).examine('INBOX') #Retrieves the lastest in inbox
        gmail.most_recent[0].receiver_email_address != "To: #{@new_email}\r\n\r\n"
      },
      90, 0.5
    )

    # Validate email values
    initial_list = gmail.most_recent
    initial_list[0].subject.should == "Forgot Your Password"
    initial_list[0].sender_email_address.should == "gsnews@gamestop-email.com"
    initial_list[0].receiver_email_address.should == "To: #{@new_email}\r\n\r\n"
    # Validate receiver email address is correct
    $tracer.trace("RECEIVER ADDR: " + initial_list[0].receiver_email_address.to_s)
    addr_list = initial_list.find_with_receiver_address("To: #{@new_email}\r\n\r\n")
    $tracer.trace("LIST LENGTH: " + addr_list.length.to_s)
    subj_list = addr_list.find_with_subject("Forgot Your Password")
    msg = subj_list.at(0)
    $tracer.trace("MSG: " + msg.body)
    msg.body.scan(/click here/).length.should == 1
    forgotten_password_reset_url_with_amp = URI.extract(msg.body, ['https'])[0]
    forgotten_password_reset_url = CGI.unescapeHTML(forgotten_password_reset_url_with_amp)
    # Go to the reset password URL from the email
    @browser.open(forgotten_password_reset_url)
    # Enter in new password values and submit
    @browser.new_password_field.value = @password
    @browser.confirm_new_password_field.value = @password
    @browser.password_complete_label.is_visible.should be_true
    @browser.reset_password_submit_button.click
    # Success message displays
    @browser.reset_password_success_label.is_visible.should be_true
    # Validate able to log in with reset password
    @browser.log_in_link.click
    @browser.email_address_field.value = @new_email
    $tracer.trace("Logging in with email address: " + @new_email)
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    # Validate account name exists in the header for logged in user
    @browser.account_name.is_visible.should be_true
    # Log out
    @browser.log_out_link.click
  end

  it "TC68475: CP - Personal Info - Insert Personal Info for New User" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.click
    # Retries until @browser.profile_account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.profile_account_name.is_visible == false})
    @browser.my_account_link.click

    # Verify Personal Info page
    @browser.username_label.is_visible.should be_true
    @browser.password_label.is_visible.should be_true

    # Verify PUR specific fields do not display
    @browser.security_question_label.is_visible.should be_false
    @browser.security_answer_label.is_visible.should be_false
    #@browser.contact_email_label.is_visible.should be_false #TODO as soon as ats class name is put in place
    @browser.contact_email_edit_link.is_visible.should be_false
    #TODO Add validation for blank labels existing on the Personal Details section

    # Verify ghost text for all Personal Details fields
    @browser.personal_details_edit_link.click
    @browser.profile_first_name_field.get("placeholder").should =="First name"
    @browser.middle_name_field.get("placeholder").should =="Middle name"
    @browser.profile_last_name_field.get("placeholder").should =="Last name"
    @browser.reviewer_field.get("placeholder").should =="Reviewer Screen Name"
    @browser.contact_primary_phone_field.get("placeholder").should =="(XXX) XXX-XXXX"
    @browser.birth_month_selector.get("data-bind").split(',')[5].split(":")[1].strip.should =="'Month'"
    @browser.birth_day_selector.get("data-bind").split(',')[3].split(":")[1].strip.should =="'Day'"
    # No gender is selected
    @browser.gender_buttons.at(0).checked.should == "false"
    @browser.gender_buttons.at(1).checked.should == "false"
    @browser.gender_buttons.at(2).checked.should == "false"

    # Click on the save button with blank values
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})

    # Verify save is successful as there are no required fields
    @browser.personal_info_success_label.is_visible.should be_true

    # Validating if first name can be saved
    @browser.personal_details_edit_link.click
    @browser.profile_first_name_field.value = "Accept"
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true

    # Validating if middle name can be saved
    @browser.personal_details_edit_link.click
    @browser.middle_name_field.value = "Middle"
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true

    # Validating if last name can be saved
    @browser.personal_details_edit_link.click
    @browser.profile_last_name_field.value = "Last"
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true

    # Validating if reviewer name can be saved
    @browser.personal_details_edit_link.click
    @browser.reviewer_field.value = "Ottomatin"
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true

    # Validating if phone number field can be saved
    @browser.personal_details_edit_link.click
    @browser.contact_primary_phone_field.value = "555-555-0000"
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true

    # Validating if birthday can be saved
    @browser.personal_details_edit_link.click
    @browser.birth_month_selector.value = "June"
    @browser.birth_day_selector.value = "30"
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true

    #Valdiating if gender can be saved
    @browser.personal_details_edit_link.click
    @browser.gender_buttons.value = "Unknown"
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true

    # Validating saved personal info values in the db (QA_ConsolidatedProfile)
    results = @db.exec_sql("SELECT p.FirstName, p.MiddleName, p.LastName, p.DisplayName, p.GenderID, p.BirthMonth, p.BirthDay, p.BirthYear, ph.PhoneNumber
    FROM Profile.dbo.Profile p
    JOIN Profile.dbo.Phone ph
      ON p.ProfileID = ph.ProfileID
    JOIN Profile.KeyMap.CustomerKey ck
      ON ph.ProfileID = ck.ProfileID
    JOIN Multipass.dbo.IssuedUser iu
      ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
    WHERE iu.EmailAddress = '#{@new_email}'")

    results.at(0).FirstName.should == "Accept"
    results.at(0).MiddleName.should == "Middle"
    results.at(0).LastName.should == "Last"
    results.at(0).DisplayName.should == "Ottomatin"
    results.at(0).GenderID.should == 0
    results.at(0).BirthMonth.should == 6
    results.at(0).BirthDay.should == 30
    results.at(0).BirthYear.should be_nil
    results.at(0).PhoneNumber.should == "5555550000"

    # Log out
    @browser.log_out_link.click
  end

  it "TC48927: CP - Personal Info - Username - Change Username functionality - GS User" do
    # Create an account
    @browser.register_link.click
    @browser.create_user_header_label.is_visible.should be_true
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.click
    @browser.submit_button.click
    # Retries until @browser.profile_account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.profile_account_name.is_visible == false})
    @browser.my_account_link.click

    # Personal Info page displays
    @browser.personal_info_label.is_visible.should be_true

    # Username section displays correctly
    @browser.username_label.inner_text.should == @new_email
    @browser.username_edit_button.click
    sleep 2

    if @config_value_list[0].should be_true
      $tracer.trace("2FA TURNED ON")
      @browser.popup_authentication_panel.is_visible.should be_true
      @browser.authentication_header_label.is_visible.should be_true
      @browser.authentication_close_button.is_visible.should be_true
      @browser.resend_code_link.is_visible.should be_true
      @browser.code_field.is_visible.should be_true
      @browser.device_name_field.is_visible.should be_true
      @browser.remember_device_checkbox.is_visible.should be_true
      @browser.remember_device_label.is_visible.should be_true
      @browser.authentication_save_button.is_visible.should be_true
      @browser.authentication_cancel_button.is_visible.should be_true

      # Log into email account
      gmail = GmailClient.new('qatest@gspcauto.fav.cc', 'qa1tester')

      @browser.retry_until_found(lambda{
        gmail.instance_variable_get(:@imap).examine('INBOX') #Retrieves the lastest in inbox
        gmail.most_recent[0].receiver_email_address != "To: #{@new_email}\r\n\r\n"
      },
      90, 0.5
      )

      # Validate email values
      initial_list = gmail.most_recent
      initial_list[0].subject.should == "GameStop Verification Code"
      initial_list[0].sender_email_address.should == "notifications@gamestop.com"
      initial_list[0].receiver_email_address.should == @new_email
      # Validate receiver email address is correct
      $tracer.trace("RECEIVER ADDR: " + initial_list[0].receiver_email_address.to_s)
      addr_list = initial_list.find_with_receiver_address(@new_email)
      $tracer.trace("LIST LENGTH: " + addr_list.length.to_s)
      subj_list = addr_list.find_with_subject("GameStop Verification Code")
      msg = subj_list.at(0)
      $tracer.trace("MSG: " + msg.body)
      index = msg.body.index('de:')
      auth_code = msg.body[index + 53, 6]
      $tracer.trace("AUTH_CODE: #{auth_code}")
      @browser.code_field.value = auth_code
      @browser.remember_device_checkbox.checked = "false"
      @browser.authentication_save_button.click
      sleep 3
    end

    @browser.username_field.is_visible.should be_true
    @browser.password_field.is_visible.should be_true
    @browser.username_save_button.is_visible.should be_true
    @browser.username_cancel_button.is_visible.should be_true

    # Validating password as a required field to change the username
    @browser.username_field.value = "abcd@abcd.com"
    @browser.username_save_button.click
    @browser.password_error_label.inner_text.should == "For security purposes, please enter your Current Password."
    @browser.password_error_close_button.click

    # Validating correct password is checked to change the username
    @browser.username_field.value = "test@test.com"
    @browser.password_field.value = "wrongpassword"
    @browser.username_save_button.click
    @browser.password_error_label.is_visible.should be_true
    @browser.password_error_close_button.click

    # Changing username
    @new_username = auto_generate_username(nil, "@gspcauto.fav.cc","otto_")
    @browser.username_field.value = @new_username
    $tracer.trace("Changed username: " + @new_username)
    @browser.password_field.value = @password
    @browser.username_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.inner_text.should == "Your Account E-mail Address has been saved."
    @browser.username_label.inner_text.should include "otto"

    # Log out
    @browser.profile_logout_link.click

    # Log in with original username and receive error messsage
    @browser.log_in_link.click
    @browser.login_header_label.is_visible.should be_true
    @browser.email_address_field.value = @new_email
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until @browser.log_in_error_panel.is_visible is true
    @browser.retry_until_found(lambda{@browser.log_in_error_panel.is_visible == false})
    @browser.log_in_error_panel.is_visible.should be_true

    # Log in with new username successfully
    @browser.email_address_field.value = @new_username
    @browser.password_field.value = @password
    @browser.log_in_button.click

    # Validate part of the new username (email address) displays in the header
    # Retries until @browser.profile_account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.log_out_link.click
  end

  it "TC68320: CP - Addresses - Add Domestic Address" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.click
    # Retries until @browser.profile_account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click

    # Go to the Addresses page
    @browser.addresses_link.click
    @browser.address_book_header_label.is_visible.should be_true

    #Creating an address type hash
    address_hash = {"0" => @browser.shipping_address_panel, "1" => @browser.billing_address_panel, "2" => @browser.mailing_address_panel}

    address_hash.each do |address_type_id, address_type|
      address_type.add_address_button.click
      # Validating existing saved values
      @browser.popup_address_panel.first_name_field.value == @new_email
      @browser.popup_address_panel.last_name_field.value == "Last"
      @browser.popup_address_panel.phone_number_field.value == "5555550000"
      @browser.popup_address_panel.country_selector.value == "United States"
      @browser.popup_address_panel.first_name_field.value = "123456789012345"
      @browser.popup_address_panel.last_name_field.value = "12345678901234567890"
      @browser.popup_address_panel.address_1_field.value = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ"
      @browser.popup_address_panel.address_2_field.value = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ"
      @browser.popup_address_panel.city_field.value = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      @browser.popup_address_panel.state_province_selector.value = "TX"
      @browser.popup_address_panel.zip_postal_code_field.value = "77777-77777"
      @browser.popup_address_panel.phone_number_field.value = "5555555555"

      @browser.popup_address_panel.default_address_checkbox.is_visible.should be_true
      @browser.popup_address_panel.default_address_label.is_visible.should be_true
      @browser.popup_address_panel.default_address_checkbox.checked.should == "true"
      @browser.popup_address_panel.default_address_checkbox.get("disabled")
      @browser.popup_address_panel.save_button.click
      # Retries until @browser.profile_account_name.is_visible is true
      @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})

      # Validating saved address values
      address_type.address_list.at(0).full_address_label.should_exist
      address_type.address_list.at(0).full_address_label.inner_text == "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWX ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXABCDEFGHIJKLMNOPQRSTUVWXY, TX 77777-7777(555) 555-5555"
      address_type.address_list.at(0).default_address_label.is_visible.should be_true
      address_type.address_list.at(0).default_address_label.inner_text == "PREFERRED"
      $tracer.trace(address_type.address_list.at(0).default_address_label.inner_text)

      # Retrieving first record in the db (QA_ConsolidatedProfile) to validate default address
      results = (@db.exec_sql("SELECT a.RecipientFirstName, a.RecipientLastName, a.Line1, a.Line2, a.City, a.State, a.PostalCode, a.Country, a.RecipientPhoneNumber, a.[Default]
                          FROM Profile.dbo.Address a
                          JOIN Profile.KeyMap.CustomerKey ck
                            ON a.ProfileID = ck.ProfileID
                          JOIN Multipass.dbo.IssuedUser iu
                            ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                          WHERE iu.EmailAddress = '#{@new_email}'
                            AND a.AddressTypeID = #{address_type_id}")).at(0)

      results.RecipientFirstName.should == "123456789012345"
      results.RecipientLastName.should == "12345678901234567890"
      results.Line1.should == "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWX"
      results.Line2.should == "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWX"
      results.City.should == "ABCDEFGHIJKLMNOPQRSTUVWXY"
      results.State.should == "TX"
      results.PostalCode.should == "77777-7777"
      results.Country.should == "US"
      results.RecipientPhoneNumber.should == "5555555555"
      results.Default.should == true
    end

    # Log out
    @browser.log_out_link.click
  end

  it "TC68321: CP - Addresses - Edit Domestic Address" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.click
    # Retries until @browser.profile_account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click

    # Go to the Addresses page
    @browser.addresses_link.click
    @browser.address_book_header_label.is_visible.should be_true

    #Creating an address type hash
    address_hash = {"0" => @browser.shipping_address_panel, "1" => @browser.billing_address_panel, "2" => @browser.mailing_address_panel}

    address_hash.each do |address_type_id, address_type|
      # Adding an address
      address_type.add_address_button.click
      # Validating existing saved values
      @browser.popup_address_panel.first_name_field.value = "Otto"
      @browser.popup_address_panel.last_name_field.value = "Matin"
      @browser.popup_address_panel.address_1_field.value = "1 Do Not Change Street"
      @browser.popup_address_panel.address_2_field.value = "I Mean It"
      @browser.popup_address_panel.city_field.value = "No Change"
      @browser.popup_address_panel.state_province_selector.value = "AL"
      @browser.popup_address_panel.zip_postal_code_field.value = "55555"
      @browser.popup_address_panel.phone_number_field.value = "5555555555"
      @browser.popup_address_panel.save_button.click
      # Retries until @browser.popup_address_panel.is_visible is false
      @browser.retry_until_found(lambda{@browser.popup_address_panel.is_visible == true})

      # Editing an address
      address_type.address_list.at(0).edit_address_button.click
      # Validating existing saved values
      @browser.popup_address_panel.first_name_field.value == "Otto"
      @browser.popup_address_panel.last_name_field.value == "Matin"
      @browser.popup_address_panel.address_1_field.value == "1 Do Not Change Street"
      @browser.popup_address_panel.address_2_field.value == "I Mean It"
      @browser.popup_address_panel.city_field.value == "No Change"
      @browser.popup_address_panel.state_province_selector.value == "AL"
      @browser.popup_address_panel.zip_postal_code_field.value == "55555"
      @browser.popup_address_panel.phone_number_field.value == "5555555555"
      @browser.popup_address_panel.country_selector.value == "United States"

      # Changing values
      @browser.popup_address_panel.first_name_field.value = "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCBA"
      @browser.popup_address_panel.last_name_field.value = "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCBA"
      @browser.popup_address_panel.address_1_field.value = "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCBA"
      @browser.popup_address_panel.address_2_field.value = "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCBA"
      @browser.popup_address_panel.city_field.value = "ZYXWVUTSRQPONMLKJIHGFEDCBA"
      @browser.popup_address_panel.state_province_selector.value = "FL"
      @browser.popup_address_panel.zip_postal_code_field.value = "55555-55555"
      @browser.popup_address_panel.phone_number_field.value = "5555550000"
      @browser.popup_address_panel.save_button.click
      # Retries until @browser.popup_address_panel.is_visible is false
      @browser.retry_until_found(lambda{@browser.popup_address_panel.is_visible == true})
      # Validating saved address values
      @browser.overlay_panel.should_not_exist
      address_type.address_list.at(0).full_address_label.should_exist
      address_type.address_list.at(0).full_address_label.innerText == "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDC ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCZYXWVUTSRQPONMLKJIHGFEDCB, FL 55555-55555(555) 555-0000"
      address_type.address_list.at(0).default_address_label.is_visible.should be_true
      address_type.address_list.at(0).default_address_label.innerText == "PREFERRED"
      $tracer.trace(address_type.address_list.at(0).default_address_label.innerText)

      # Validate in the db (QA_ConsolidatedProfile) for change in address
      results = @db.exec_sql("SELECT a.RecipientFirstName, a.RecipientLastName, a.Line1, a.Line2, a.City, a.State, a.PostalCode, a.Country, a.RecipientPhoneNumber, a.[Default]
                          FROM Profile.dbo.Address a
                          JOIN Profile.KeyMap.CustomerKey ck
                            ON a.ProfileID = ck.ProfileID
                          JOIN Multipass.dbo.IssuedUser iu
                            ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                          WHERE iu.EmailAddress = '#{@new_email}'
                            AND a.AddressTypeID = #{address_type_id}")
      #TODO DE3138
      #results.at(0).RecipientFirstName.should == "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDC"
      #results.at(0).RecipientLastName.should == "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDC"
      results.at(0).Line1.should == "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDC"
      results.at(0).Line2.should == "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDC"
      results.at(0).City.should == "ZYXWVUTSRQPONMLKJIHGFEDCB"
      results.at(0).State.should == "FL"
      results.at(0).PostalCode.should == "55555-5555"
      results.at(0).Country.should == "US"
      results.at(0).RecipientPhoneNumber.should == "5555550000"
      results.at(0).Default.should == true
    end

    # Log out
    @browser.log_out_link.click
  end

  it "TC68324: CP - Addresses - Add International Address" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.click
    # Retries until @browser.profile_account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click

    # Go to Addresses page
    @browser.addresses_link.click
    @browser.address_book_header_label.is_visible.should be_true

    #Creating an address type hash
    address_hash = {"0" => @browser.shipping_address_panel, "1" => @browser.billing_address_panel}

    address_hash.each do |address_type_id, address_type|
      # Adding an international shipping address
      address_type.add_address_button.click
      # Validating existing saved values
      @browser.popup_address_panel.first_name_field.value == @new_email
      @browser.popup_address_panel.last_name_field.value == "Last"
      @browser.popup_address_panel.phone_number_field.value == "5555550000"
      @browser.popup_address_panel.country_selector.value = "Canada"
      @browser.popup_address_panel.state_province_selector.is_visible.should be_false
      @browser.popup_address_panel.state_province_field.is_visible.should be_true
      @browser.popup_address_panel.first_name_field.value = "123456789012345"
      @browser.popup_address_panel.last_name_field.value = "12345678901234567890"
      @browser.popup_address_panel.address_1_field.value = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ"
      @browser.popup_address_panel.address_2_field.value = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ"
      @browser.popup_address_panel.city_field.value = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      @browser.popup_address_panel.state_province_field.value = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ"
      @browser.popup_address_panel.zip_postal_code_field.value = "ABCDE 12345"
      @browser.popup_address_panel.phone_number_field.value = "98765432109876543210"
      @browser.popup_address_panel.default_address_checkbox.is_visible.should be_true
      @browser.popup_address_panel.default_address_label.is_visible.should be_true
      @browser.popup_address_panel.default_address_checkbox.checked = true

      @browser.popup_address_panel.save_button.click
      @browser.popup_address_panel.popup_address_error_label.inner_text.should == "The phone number is invalid."
      @browser.popup_address_panel.phone_number_field.value = "98765432101234"
      @browser.popup_address_panel.save_button.click
      # Retries until @browser.popup_address_panel.is_visible is false
      @browser.retry_until_found(lambda{@browser.popup_address_panel.is_visible == true})

      # Validating saved address values
      @browser.overlay_panel.should_not_exist
      address_type.address_list.at(0).full_address_label.should_exist
      address_type.address_list.at(0).full_address_label.innerText == "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWX ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXABCDEFGHIJKLMNOPQRSTUVWXY, ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWX ABCDE 1234CA98765432101234"
      address_type.address_list.at(0).default_address_label.is_visible.should be_true
      address_type.address_list.at(0).default_address_label.innerText == "PREFERRED"
      $tracer.trace("ADDRESS LABEL: " + address_type.address_list.at(0).full_address_label.innerText)

      # Validate in the db (QA_ConsolidatedProfile) for new address
      results = @db.exec_sql("SELECT a.RecipientFirstName, a.RecipientLastName, a.Line1, a.Line2, a.City, a.State, a.PostalCode, a.Country, a.RecipientPhoneNumber, a.[Default]
                        FROM Profile.dbo.Address a
                        JOIN Profile.KeyMap.CustomerKey ck
                          ON a.ProfileID = ck.ProfileID
                        JOIN Multipass.dbo.IssuedUser iu
                          ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                        WHERE iu.EmailAddress = '#{@new_email}'
                          AND a.AddressTypeID = #{address_type_id}
                        ORDER BY DateCreated DESC")

      results.at(0).RecipientFirstName.should == "123456789012345"
      results.at(0).RecipientLastName.should == "12345678901234567890"
      results.at(0).Line1.should == "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWX"
      results.at(0).Line2.should == "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWX"
      results.at(0).City.should == "ABCDEFGHIJKLMNOPQRSTUVWXY"
      results.at(0).State.should == "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWX"
      results.at(0).PostalCode.should == "ABCDE 1234"
      results.at(0).Country.should == "CA"
      results.at(0).RecipientPhoneNumber.should == "98765432101234"
      results.at(0).Default.should == true
    end

    # Adding a Mailing address
    @browser.mailing_address_panel.add_address_button.click

    # Validating existing saved values
    @browser.popup_address_panel.first_name_field.value == @new_email
    @browser.popup_address_panel.last_name_field.value == "Last"
    @browser.popup_address_panel.phone_number_field.value == "5555550000"

    # Validating country drop down does not display for mailing addresses
    @browser.popup_address_panel.country_selector.is_visible.should be_false
    @browser.popup_address_panel.cancel_button.click

    # Log out
    @browser.log_out_link.click
  end


  it "TC68325: CP - Addresses - Edit International Address" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click

    # Go to Addresses page
    @browser.addresses_link.click
    @browser.address_book_header_label.is_visible.should be_true

    # Add international shipping address
    # Adding an international shipping address
    @browser.billing_address_panel.add_address_button.click
    # Validating existing saved values
    @browser.popup_address_panel.country_selector.value = "Canada"
    @browser.popup_address_panel.first_name_field.value = "Otto"
    @browser.popup_address_panel.last_name_field.value = "Matin"
    @browser.popup_address_panel.address_1_field.value = "1 First Street"
    @browser.popup_address_panel.city_field.value = "Far Away"
    @browser.popup_address_panel.state_province_field.value = "BC"
    @browser.popup_address_panel.zip_postal_code_field.value = "ABCDE 1234"
    @browser.popup_address_panel.phone_number_field.value = "98765432101234"
    @browser.popup_address_panel.save_button.click
    # Retries until @browser.popup_address_panel.is_visible is false
    @browser.retry_until_found(lambda{@browser.popup_address_panel.is_visible == true})
    @browser.billing_address_panel.address_list.length.should == 1

    # Editing a shipping address
    @browser.billing_address_panel.address_list.at(0).edit_address_button.click
    # Validating existing saved values
    @browser.popup_address_panel.first_name_field.value == "Otto"
    @browser.popup_address_panel.last_name_field.value == "Matin"
    @browser.popup_address_panel.address_1_field.value == "1 First Street"
    @browser.popup_address_panel.address_2_field.value == ""
    @browser.popup_address_panel.city_field.value == "Far Away"
    @browser.popup_address_panel.state_province_field.value == "BC"
    @browser.popup_address_panel.zip_postal_code_field.value == "ABCDE 1234"
    @browser.popup_address_panel.phone_number_field.value == "98765432101234"
    @browser.popup_address_panel.country_selector.value == "Canada"

    # Changing values
    @browser.popup_address_panel.country_selector.value = "United Kingdom"
    @browser.popup_address_panel.first_name_field.value = "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCBA"
    @browser.popup_address_panel.last_name_field.value = "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCBA"
    @browser.popup_address_panel.address_1_field.value = "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCBA"
    @browser.popup_address_panel.address_2_field.value = "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCBA"
    @browser.popup_address_panel.city_field.value = "ZYXWVUTSRQPONMLKJIHGFEDCBA"
    @browser.popup_address_panel.state_province_field.value = "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCBA"
    @browser.popup_address_panel.zip_postal_code_field.value = "ABCD 12345"
    @browser.popup_address_panel.phone_number_field.value = "12345678901234"
    @browser.popup_address_panel.default_address_checkbox.is_visible.should be_false
    @browser.popup_address_panel.save_button.click
    # Retries until @browser.popup_address_panel.is_visible is false
    @browser.retry_until_found(lambda{@browser.popup_address_panel.is_visible == true})
    # Validating saved address values
    @browser.overlay_panel.should_not_exist
    @browser.billing_address_panel.address_list.at(0).full_address_label.should_exist
    @browser.billing_address_panel.address_list.at(0).full_address_label.innerText == "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDC ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDCZYXWVUTSRQPONMLKJIHGFEDCB, ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDC ABCD 12345UK12345678901234"
    @browser.billing_address_panel.address_list.at(0).default_address_label.is_visible.should be_true
    @browser.billing_address_panel.address_list.at(0).default_address_label.innerText == "PREFERRED"
    $tracer.trace(@browser.billing_address_panel.address_list.at(0).full_address_label.innerText)

    # Validate in the db (QA_ConsolidatedProfile) for change in address
    results = @db.exec_sql("SELECT a.RecipientFirstName, a.RecipientLastName, a.Line1, a.Line2, a.City, a.State, a.PostalCode, a.Country, a.RecipientPhoneNumber, a.[Default]
                      FROM Profile.dbo.Address a
                      JOIN Profile.KeyMap.CustomerKey ck
                        ON a.ProfileID = ck.ProfileID
                      JOIN Multipass.dbo.IssuedUser iu
                        ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                      WHERE iu.EmailAddress = '#{@new_email}'
                        AND a.AddressTypeID = 1
                    ORDER BY a.DateCreated DESC")
    # DE3138
    #results.at(0).RecipientFirstName.should == "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDC"
    #results.at(0).RecipientLastName.should == "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDC"
    results.at(0).Line1.should == "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDC"
    results.at(0).Line2.should == "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDC"
    results.at(0).City.should == "ZYXWVUTSRQPONMLKJIHGFEDCB"
    results.at(0).State.should == "ZYXWVUTSRQPONMLKJIHGFEDCBAZYXWVUTSRQPONMLKJIHGFEDC"
    results.at(0).PostalCode.should == "ABCD 12345"
    results.at(0).Country.should == "GB"
    results.at(0).RecipientPhoneNumber.should == "12345678901234"
    results.at(0).Default.should == true

    # Log out
    @browser.log_out_link.click
  end

  it "TC68532: CP - Addresses - Max Addresses Allowed" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click

    # Go to Addresses page
    @browser.addresses_link.click

    # Add 20 addresses
    (1..20).each do |i|
      @browser.shipping_address_panel.add_address_button.click
      @browser.popup_address_panel.first_name_field.value = "TBD"
      @browser.popup_address_panel.last_name_field.value = "Matin"
      @browser.popup_address_panel.address_1_field.value = "S124 Main Street"
      @browser.popup_address_panel.city_field.value = "S124"
      @browser.popup_address_panel.state_province_selector.value = "TX"
      @browser.popup_address_panel.zip_postal_code_field.value = "77777"
      @browser.popup_address_panel.phone_number_field.value = "5555555555"
      @browser.popup_address_panel.save_button.click
      sleep 2 # Sleep was faster than using the retry_until_found
      $tracer.trace("Address #{i} added")
    end

    # Pop up for max number of addresses
    @browser.shipping_address_panel.add_address_button.className("/disabled/").should_exist #TODO
    @browser.shipping_address_panel.add_address_button.click
    @browser.popup_max_number_panel.is_visible.should be_true
    @browser.popup_max_number_panel.max_number_header_label.inner_text.should == "Maximum number of addresses"
    @browser.popup_max_number_panel.max_number_text_label.inner_text.should == "You have 20 addresses already, which is the most you can add to your account.To add another one, please delete one of your current addresses first."
    @browser.popup_max_number_panel.max_number_confirm_button.click

    # Log out
    @browser.log_out_link.click
  end

  it "TC68440: CP - Addresses - Add Store" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click

    # Go to Addresses page
    @browser.addresses_link.click
    @browser.address_book_header_label.is_visible.should be_true

    # Add a store
    @browser.stores_panel.add_store_button.click
    # Retries until @browser.store_finder_panel.is_visible is true
    @browser.retry_until_found(lambda{@browser.store_finder_panel.is_visible == false})
    @browser.store_finder_panel.store_finder_header_label.is_visible.should be_true
    @browser.store_finder_panel.store_results_list.length.should == 8
    @browser.store_finder_panel.store_results_list.at(0).store_number_label.is_visible.should be_true
    @browser.store_finder_panel.store_results_list.at(0).add_store_button.click
    # Retries until @browser.store_finder_panel.is_visible is false
    @browser.retry_until_found(lambda{@browser.store_finder_panel.is_visible == true})

    # Validate added store displays
    @browser.stores_panel.stores_list.length.should == 1
    @browser.stores_panel.stores_list.at(0).home_store_label.is_visible.should be_true
    $tracer.trace("Added store: " + @browser.stores_panel.stores_list.at(0).full_store_label.innerText)

    # Validate in the db (QA_ConsolidatedProfile) for new store
    results = @db.exec_sql("SELECT iu.EmailAddress, ps.StoreNumber, ps.IsHomeStore, ps.DateCreated, ps.DateModified
                          FROM Profile.dbo.PreferredStore ps
                        JOIN Profile.KeyMap.CustomerKey ck
                          ON ps.ProfileID = ck.ProfileID
                          JOIN Multipass.dbo.IssuedUser iu
                          on ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                          WHERE iu.EmailAddress = '#{@new_email}'")

    results.at(0).IsHomeStore.should == true
    # Log out
    @browser.log_out_link.click
  end

  it "TC57188: CP - Addresses - Change Preferred Address and Store" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click

    # Go to Addresses page
    @browser.addresses_link.click

    # Adding 2 billing addresses and 2 stores
    (0..1).each do |i|
      @browser.billing_address_panel.add_address_button.click
      @browser.popup_address_panel.first_name_field.value = "TBD"
      @browser.popup_address_panel.last_name_field.value = "Matin"
      @browser.popup_address_panel.address_1_field.value = "S124 Main Street"
      @browser.popup_address_panel.city_field.value = i.to_s
      @browser.popup_address_panel.state_province_selector.value = "TX"
      @browser.popup_address_panel.zip_postal_code_field.value = "77777"
      @browser.popup_address_panel.phone_number_field.value = "5555555555"
      @browser.popup_address_panel.save_button.click

      # Retries until @browser.popup_address_panel.is_visible is false
      @browser.retry_until_found(lambda{@browser.popup_address_panel.exists == true}, 30, 0.5, 5){
        @browser.popup_address_panel.exists.should be_false
      }
      @browser.stores_panel.add_store_button.click
      @browser.store_finder_panel.store_finder_header_label.is_visible.should be_true
      @browser.store_finder_panel.store_results_list.at(i).add_store_button.click
      # Retries until @browser.store_finder_panel.is_visible is false
      @browser.retry_until_found(lambda{@browser.store_finder_panel.exists == true}, 30, 0.5, 5){
        @browser.store_finder_panel.exists.should be_false
      }
      $tracer.trace("Address and Store Count #{i} added")
    end

    # Refreshing the page for stores
    @browser.refresh_page
    # Changing Preferred billing address
    @browser.billing_address_panel.address_list.at(1).make_default_button.is_visible.should be_true
    @address1 = @browser.billing_address_panel.address_list.at(1).full_address_label.inner_text
    @address2 = @browser.billing_address_panel.address_list.at(0).full_address_label.inner_text
    @browser.billing_address_panel.address_list.at(1).make_default_button.click
    # Retries until @browser.billing_address_panel.address_list.at(1).make_default_button.is_visible is false
    @browser.retry_until_found(lambda{@browser.billing_address_panel.address_list.at(1).make_default_button.is_visible == true})

    # Changing Preferred store
    @browser.stores_panel.stores_list.at(1).make_home_store_button.is_visible.should be_true
    @store1 = @browser.stores_panel.stores_list.at(1).full_store_label.inner_text
    @store2 = @browser.stores_panel.stores_list.at(0).full_store_label.inner_text
    @browser.stores_panel.stores_list.at(1).make_home_store_button.click
    # Retries until @browser.stores_panel.stores_list.at(1).make_home_store_button.is_visible is false
    @browser.retry_until_found(lambda{@browser.stores_panel.stores_list.at(1).make_home_store_button.is_visible == true})

    # Refreshing the page
    @browser.refresh_page
    # Retries until @browser.billing_address_panel.is_visible is false
    @browser.retry_until_found(lambda{@browser.billing_address_panel.is_visible == false})
    @browser.billing_address_panel.address_list.at(0).full_address_label.inner_text.should == @address1
    @browser.billing_address_panel.address_list.at(1).full_address_label.inner_text.should == @address2
    @browser.billing_address_panel.address_list.at(1).make_default_button.is_visible.should be_true

    # Validating in the db (QA_ConsolidatedProfile) for changed default address and store
    results = @db.exec_sql("SELECT a.City, a.[Default]
                            FROM Profile.dbo.Address a
                            JOIN Profile.KeyMap.CustomerKey ck
                            ON a.ProfileID = ck.ProfileID
                            JOIN Multipass.dbo.IssuedUser iu
                            ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                            WHERE iu.EmailAddress = '#{@new_email}'
                            and a.[Default] = 1
                            AND a.AddressTypeId = 1
                            ORDER BY a.DateCreated desc")

    results.at(0).City.should == "1"

    @browser.stores_panel.stores_list.at(0).full_store_label.inner_text.should == @store1
    @browser.stores_panel.stores_list.at(1).full_store_label.inner_text.should == @store2
    @browser.stores_panel.stores_list.at(1).make_home_store_button.is_visible.should be_true
    $tracer.trace("New Home Store: " + @browser.stores_panel.stores_list.at(0).full_store_label.inner_text)
    # Validating in the db (QA_ConsolidatedProfile) for changed home store
    results_store = @db.exec_sql("SELECT iu.EmailAddress, ps.StoreNumber, ps.IsHomeStore, ps.DateCreated, ps.DateModified
                                FROM Profile.dbo.PreferredStore ps
                                JOIN Profile.KeyMap.CustomerKey ck
                                ON ps.ProfileID = ck.ProfileID
                                JOIN Multipass.dbo.IssuedUser iu
                                on ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                                WHERE iu.EmailAddress = '#{@new_email}'
                                and ps.IsHomeStore = 1
                                ORDER BY ps.DateCreated desc")
    $tracer.trace("DB Home Store Value: " + results_store.at(0).StoreNumber.to_s)
    @browser.stores_panel.stores_list.at(0).full_store_label.inner_text.include? results_store.at(0).StoreNumber.to_s
    # Log out
    @browser.log_out_link.click
  end

  it "TC68323: CP - Addresses - Delete Non Preferred Address" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click

    # Go to Addresses page
    @browser.addresses_link.click
    # Create an hash for address types
    address_hash = {"0" => @browser.shipping_address_panel, "1" => @browser.billing_address_panel, "2" => @browser.mailing_address_panel}

    address_hash.each do |address_type_id, address_type|

      # Adding 2 addresses for each address type
      (0..1).each do |i|
        address_type.add_address_button.click
        @browser.popup_address_panel.first_name_field.value = "TBD - #{i}"
        @browser.popup_address_panel.last_name_field.value = "Matin"
        @browser.popup_address_panel.address_1_field.value = "S124 Main Street"
        @browser.popup_address_panel.city_field.value = i.to_s
        @browser.popup_address_panel.state_province_selector.value = "TX"
        @browser.popup_address_panel.zip_postal_code_field.value = "77777"
        @browser.popup_address_panel.phone_number_field.value = "5555555555"
        @browser.popup_address_panel.save_button.click
        $tracer.trace("Address #{i} added")
        # Retries until @browser.popup_address_panel.is_visible is false
        @browser.retry_until_found(lambda{@browser.popup_address_panel.is_visible == true})
      end

      list_len = address_type.address_list.length
      prefer_addr = address_type.address_list.at(0).full_address_label.inner_text

      # Retrieving count of addresses from the db (QA_ConsolidatedProfile)
      results = @db.exec_sql("SELECT COUNT(*) as Count
                          FROM Profile.dbo.Address a
                          JOIN Profile.KeyMap.CustomerKey ck
                          ON a.ProfileID = ck.ProfileID
                          JOIN Multipass.dbo.IssuedUser iu
                          ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                          WHERE iu.EmailAddress = '#{@new_email}'
                          and a.AddressTypeID = #{address_type_id}")

      addr_count = results.at(0).Count
      $tracer.trace("DB Addr count: " + addr_count.to_s)

      # Deleting address
      address_type.address_list.at(1).delete_address_button.click
      @browser.popup_remove_confirm_panel.is_visible.should be_true
      @browser.popup_remove_confirm_panel.remove_cancel_button.is_visible.should be_true
      @browser.popup_remove_confirm_panel.remove_submit_button.click
      # Retries until @browser.popup_remove_confirm_panel.is_visible is false
      @browser.retry_until_found(lambda{@browser.popup_remove_confirm_panel.is_visible == true})
      $tracer.trace("New List Length: " + address_type.address_list.length.to_s)
      address_type.address_list.length.should == list_len - 1
      # Validate no change in preferred address
      address_type.address_list.at(0).full_address_label.inner_text.should == prefer_addr
      # Validate in the db (QA_ConsolidatedProfile) that the address count is one less
      results = @db.exec_sql("SELECT COUNT(*) AS Count
                          FROM Profile.dbo.Address a
                          JOIN Profile.KeyMap.CustomerKey ck
                          ON a.ProfileID = ck.ProfileID
                          JOIN Multipass.dbo.IssuedUser iu
                          ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                          WHERE iu.EmailAddress = '" + @new_email + "'
                          and a.AddressTypeID = #{address_type_id}")

      results.at(0).Count.should == addr_count - 1
      $tracer.trace("DB Addr count after: " + results.at(0).Count.to_s)
    end
    # Log out
    @browser.profile_logout_link.click
  end

  it "TC68322: CP - Addresses - Delete Preferred Address" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click

    # Go to Addresses page
    @browser.addresses_link.click
    # Creating a hash of the different address types
    address_hash = {"0" => @browser.shipping_address_panel, "1" => @browser.billing_address_panel, "2" => @browser.mailing_address_panel}

    address_hash.each do |address_type_id, address_type|
      # Adding 2 addresses for each address type
      (0..1).each do |i|
        address_type.add_address_button.click
        @browser.popup_address_panel.first_name_field.value = "TBD - #{i}"
        @browser.popup_address_panel.last_name_field.value = "Matin"
        @browser.popup_address_panel.address_1_field.value = "S124 Main Street"
        @browser.popup_address_panel.city_field.value = i.to_s
        @browser.popup_address_panel.state_province_selector.value = "TX"
        @browser.popup_address_panel.zip_postal_code_field.value = "77777"
        @browser.popup_address_panel.phone_number_field.value = "5555555555"
        @browser.popup_address_panel.save_button.click
        $tracer.trace("Address #{i} added")
        # Retries until @browser.popup_address_panel.is_visible is false
        @browser.retry_until_found(lambda{@browser.popup_address_panel.is_visible == true})
      end

      new_preferred = address_type.address_list.at(1).full_address_label.inner_text
      list_len = address_type.address_list.length
      address_type.address_list.at(0).delete_address_button.click

      @browser.popup_remove_confirm_panel.is_visible.should be_true
      @browser.popup_remove_confirm_panel.remove_submit_button.click
      # Retries until @browser.popup_remove_confirm_panel.is_visible is false
      @browser.retry_until_found(lambda{@browser.popup_remove_confirm_panel.is_visible == true})
      address_type.address_list.length.should == list_len - 1
      address_type.address_list.at(0).full_address_label.inner_text.should == new_preferred
      # Validate in the db (QA_ConsolidatedProfile) preferred address is deleted
      results = @db.exec_sql("SELECT a.[Default]
                            FROM Profile.dbo.Address a
                            JOIN Profile.KeyMap.CustomerKey ck
                            ON a.ProfileID = ck.ProfileID
                            JOIN Multipass.dbo.IssuedUser iu
                            ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                            WHERE iu.EmailAddress = '#{@new_email}'
                            and a.AddressTypeID = #{address_type_id}
                            order by DateModified desc")

      results.at(0).Default.should == true
    end

    # Log out
    @browser.profile_logout_link.click
  end

  it "TC68439: CP - Addresses - Delete Store" do
    # Create an account
    @browser.register_link.click
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.submit_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click

    # Go to Addresses page
    @browser.addresses_link.click

    # Adding 3 stores
    (0..2).each do |i|
      @browser.stores_panel.add_store_button.click
      # Retries until @browser.store_finder_panel.is_visible is true
      @browser.retry_until_found(lambda{@browser.store_finder_panel.is_visible == false})
      @browser.store_finder_panel.store_finder_header_label.is_visible.should be_true
      @browser.store_finder_panel.store_results_list.at(i).add_store_button.click
      # Retries until @browser.store_finder_panel.is_visible is false
      @browser.retry_until_found(lambda{@browser.store_finder_panel.is_visible == true})
    end
    # Refresh the page
    @browser.refresh_page

    # Store list length should be at least 3
    @browser.stores_panel.stores_list.length.should >= 3
    length = @browser.stores_panel.stores_list.length
    new_home = @browser.stores_panel.stores_list.at(1).full_store_label.inner_text
    # Delete home store successfully
    @browser.stores_panel.stores_list.at(0).home_store_label.is_visible.should be_true
    @browser.stores_panel.stores_list.at(0).delete_store_button.click
    @browser.popup_remove_confirm_panel.is_visible.should be_true
    @browser.popup_remove_confirm_panel.remove_submit_button.click
    # Retries until @browser.popup_remove_confirm_panel.is_visible is false
    @browser.retry_until_found(lambda{@browser.store_finder_panel.is_visible == true})
    # Validate change in stores list
    new_length = @browser.stores_panel.stores_list.length
    new_length.should == length - 1
    $tracer.trace("New length: " + new_length.to_s)
    @browser.stores_panel.stores_list.at(0).full_store_label.inner_text.should == new_home

    # Validate in the database (QA_ConsolidatedProfile) home store successfully removed
    results = @db.exec_sql("SELECT iu.EmailAddress, ps.StoreNumber, ps.IsHomeStore, ps.DateCreated, ps.DateModified
                          FROM Profile.dbo.PreferredStore ps
                          JOIN Profile.KeyMap.CustomerKey ck
                          ON ps.ProfileID = ck.ProfileID
                          JOIN Multipass.dbo.IssuedUser iu
                          on ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                          WHERE iu.EmailAddress = '#{@new_email}'
                          order by ps.DateCreated desc")

    results.at(0).IsHomeStore.should == true
    # Delete a non home store successfully
    home_store = @browser.stores_panel.stores_list.at(0).full_store_label.inner_text
    @browser.stores_panel.stores_list.at(1).delete_store_button.click
    @browser.popup_remove_confirm_panel.remove_submit_button.click
    # Retries until @browser.popup_remove_confirm_panel.is_visible is false
    @browser.retry_until_found(lambda{@browser.popup_remove_confirm_panel.is_visible == true})
    @browser.stores_panel.stores_list.length.should == new_length - 1
    @browser.stores_panel.stores_list.at(0).full_store_label.inner_text.should == home_store
    # Delete all stores successfully
    @browser.stores_panel.stores_list.at(0).delete_store_button.click
    @browser.popup_remove_confirm_panel.remove_submit_button.click
    # Retries until @browser.popup_remove_confirm_panel.is_visible is false
    @browser.retry_until_found(lambda{@browser.popup_remove_confirm_panel.is_visible == true})
    # Validating no more stores exist in the database for the user
    results = @db.exec_sql("SELECT iu.EmailAddress, ps.StoreNumber, ps.IsHomeStore, ps.DateCreated, ps.DateModified
                          FROM Profile.dbo.PreferredStore ps
                          JOIN Profile.KeyMap.CustomerKey ck
                          ON ps.ProfileID = ck.ProfileID
                          JOIN Multipass.dbo.IssuedUser iu
                          on ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                          WHERE iu.EmailAddress = '#{@new_email}'")

    results.should be_nil
    #Log out
    @browser.profile_logout_link.click
  end

  it "TC68534: GameStop - Communication Prefs - Subscribe" do
    # Login with existing user
    @browser.log_in_link.click
    @browser.login_header_label.is_visible.should be_true
    @browser.create_an_account_button.is_visible.should be_true
    #@email_address = "ottomatin_donottouch@gspcauto.fav.cc"
    @browser.email_address_field.value = @login
    $tracer.trace("Logging in with email address: " + @login)
    #@browser.password_field.value = "Test12345"
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click

    # Go to Communications page
    @browser.communications_link.click
    @browser.communications_header_label.is_visible.should be_true
    @browser.pur_communications_label.is_visible.should be_false
    @browser.gs_communications_label.is_visible.should be_true
    @browser.gs_unsubscribe_button.is_visible.should be_true
    @browser.gs_subscribe_button.click
    # Retries until @browser.gs_communications_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.gs_communications_success_label.is_visible == false})

    @browser.gs_communications_success_label.is_visible.should be_true
    @browser.gs_communications_success_label.inner_text.should == "You have subscribed to GameStop newsletters and offers."
    # Validate in the db (QA_ConsolidatedProfile) that user is subscribed
    results = @db.exec_sql("SELECT message_type
                          FROM Gamestop_profiles.dbo.Messages
                          WHERE email = '#{@login}'
                          ORDER BY date_message_created DESC")

    results.at(0).message_type.should == 1
    # Log out
    @browser.profile_logout_link.click
  end

  it "TC68535: GameStop - Communication Prefs - Unsubscribe" do
    # Login with existing user
    @browser.log_in_link.click
    @browser.login_header_label.is_visible.should be_true
    @browser.create_an_account_button.is_visible.should be_true
    @browser.email_address_field.value = @login
    $tracer.trace("Logging in with email address: " + @login)
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    # Validate part of the email address displays in the header
    @browser.account_name.is_visible.should be_true
    @browser.my_account_link.click

    # Go to Communications page
    @browser.communications_link.click
    @browser.communications_header_label.is_visible.should be_true
    @browser.pur_communications_label.is_visible.should be_false
    @browser.gs_communications_label.is_visible.should be_true
    @browser.gs_subscribe_button.is_visible.should be_true
    @browser.gs_unsubscribe_button.click
    # Retries until @browser.gs_communications_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.gs_communications_success_label.is_visible == false})
    @browser.gs_communications_success_label.is_visible.should be_true
    @browser.gs_communications_success_label.inner_text.should == "You have unsubscribed from GameStop newsletters and offers."

    # Validate in the db (QA_ConsolidatedProfile) that user unsubscribed
    results = @db.exec_sql("SELECT message_type
                          FROM Gamestop_profiles.dbo.Messages
                          WHERE email = '#{@login}'
                          ORDER BY date_message_created DESC")

    results.at(0).message_type.should == 2
    # Log out
    @browser.profile_logout_link.click
  end

  it "TC66531: CP - Orders - Order lookup options for Non Activated User" do
    # Login ith existing user
    @browser.log_in_link.click
    @browser.login_header_label.is_visible.should be_true
    @browser.create_an_account_button.is_visible.should be_true
    @browser.email_address_field.value = @login
    $tracer.trace("Logging in with email address: " + @login)
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click
    # Go to Order History page
    @browser.orders_link.click
    # Retries until @browser.orders_header_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.orders_header_label.is_visible == false})
    @browser.orders_header_label.is_visible.should be_true

    # Validating PUR.com order history section does not exist
    @browser.pur_orders_image.is_visible.should be_false
    @browser.card_activity_link.is_visible.should be_false

    # Validate GS.com order history section exists
    @browser.gamestop_orders_image.is_visible.should be_true
    @browser.gamestop_orders_label.inner_text.should == "GameStop.com Order History"
    @browser.gamestop_orders_description_label.inner_text.should == "View past orders and make changes to existing ones"

    # Go to GS.com's order history page
    @browser.gamestop_order_history_link.click
    @browser.url.should == "https://qa.gamestop.com/Orders/OrderHistory.aspx"

    # Log out
    @browser.profile_logout_link.click
  end

  it "TC65961: CP - Payment Method" do
    # Log in with existing user
    @browser.log_in_link.click
    @browser.email_address_field.value = @login
    $tracer.trace("Logging in with email address: " + @login)
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until @browser.account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.account_name.is_visible == false})
    @browser.my_account_link.click

    # Go to Payments page
    @browser.payment_method_link.click
    # Retries until @browser.cancel_credit_card_button.is_visible is true
    @browser.retry_until_found(lambda{@browser.cancel_credit_card_button.is_visible == false})
    @browser.url.should == "https://loginqa.gamestop.com/Profile#payments"

    # Log out
    @browser.profile_logout_link.click
  end

end
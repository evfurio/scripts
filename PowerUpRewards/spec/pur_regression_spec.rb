#d-con %QAAUTOMATION_SCRIPTS%\PowerUpRewards\spec\pur_regression_spec.rb --csv %QAAUTOMATION_SCRIPTS%\PowerUpRewards\Spec\powerup_rewards_dataset.csv --range TFS65436 --browser chrome -e "TC 65436: CP - Login via PUR site goes to PUR landing page" --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/PowerUpRewards/dsl/src/dsl"
require 'timeout'

$tracer.mode = :on
$tracer.echo = :on

#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

#$tc_desc = $global_functions.desc
#$tc_id = $global_functions.id

describe "PUR Profile Regression" do

  before(:all) do
    @browser = WebBrowser.new(browser_type_parameter)
    #@browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 30_000
    $snapshots.setup(@browser, :all)

    #Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @loyaltymembership_svc = $global_functions.loyaltymembership_svc
    @configuration_svc = $global_functions.config_svc
    # Retrieve 2FA config value from configuration service (Grand Central)
    @config_key_list = ["TwoFactorAuthenitication.IsEnabledForConsolidatedProfile"]
    @config_value_list = @configuration_svc.get_config_value(@config_key_list)
    $tracer.trace("Auth flag returned: #{@config_value_list[0]}")
  end

  before(:each) do
    # Auto generates a new email address for creating an account
    @new_email = auto_generate_username(nil, "@gspcauto.fav.cc","PUR_")
    @browser.open(@start_page)
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    $tracer.trace("after all")
    @browser.close_all()
  end

  #it "#{$tc_id} #{$tc_desc}" do
  it "TC 68458: CP - Create Account - From Activate - PUR" do
      @browser.activate_link.click
      @browser.pur_activation_label.is_visible.should be_true
      @browser.requires_account_label.inner_text.should == "PowerUp Card Activation requires an account"
      @browser.sign_in_create_prompt_label.inner_text.should == "Please sign in below or create an account to get started."
      @browser.create_an_account_button.click
      @browser.create_opt_in_checkbox_label.is_visible.should be_false
      @browser.create_email_address_field.value = @new_email
      @browser.create_password_field.value = @password
      @browser.confirm_password_field.value = @password
      @browser.submit_button.click
      # Retries until activate_pur_header_label.is_visible is true
      @browser.retry_until_found(lambda{@browser.activate_pur_header_label.is_visible == false})
      @browser.activate_pur_header_label.is_visible.should be_true
      # TODO: Discuss name in GS.com's header
      # Validate username displays in the header - part of header not existing in common/profile
      #@browser.account_name.inner_text.should == @email[0..13]
      @browser.profile_logout_link.click
  end

  it "TC 68459: CP - Create Account - From Login - PUR" do
    # Click on PUR's log in link
    @browser.log_in_link.click
    # Go to create an account
    @browser.create_an_account_button.click
    @browser.create_user_header_label.is_visible.should be_true
    @browser.create_opt_in_checkbox_label.is_visible.should be_true
    @browser.create_opt_in_checkbox_label.inner_text.should == "Sign up for our weekly ad, exclusive offers and more."
    @browser.email_opt_in_checkbox.checked.should == "true"
    @browser.create_email_address_field.value = @new_email
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked = "false"
    @browser.submit_button.click
    # Retries until hi_name_label.exists is true
    @browser.retry_until_found(lambda{@browser.hi_name_label.exists == false})
    @browser.hi_name_label.should_exist
    @browser.sign_out_link.click
  end

  it "TC 65436: CP - Login via PUR site goes to PUR landing page" do
    # Click on the login link from the PUR site
    @browser.log_in_link.click
    @browser.login_header_label.is_visible.should be_true
    @browser.create_an_account_button.is_visible.should be_true
    # Log in with existing account found in dataset
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until hi name label is true
    @browser.retry_until_found(lambda{@browser.hi_name_label.exists == false})
    @browser.hi_name_label.inner_text.should include "Ottomatin"
    # Validates PUR menu
    @browser.dashboard_menu_link.is_visible.should be_true
    @browser.rewards_catalog_menu_link.is_visible.should be_true
    @browser.game_library_menu_link.is_visible.should be_true
    @browser.my_account_menu_link.is_visible.should be_true
    @browser.xtra_points_menu_link.is_visible.should be_true
    # Log out
    @browser.sign_out_link.click
  end

  ##TODO Need to update the TC
  it "TC 48937: CP - Personal Info - Password - Change Password functionality - PUR user" do
    # Enroll user with created email address via the loyalty membership service
    # Create an account
    @browser.activate_link.click
    @browser.create_an_account_button.click
    @browser.create_user_header_label.is_visible.should be_true
    @browser.create_email_address_field.value = @new_email
    $tracer.trace("Created Email Address: " + @new_email)
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    #@browser.email_opt_in_checkbox.click
    @browser.submit_button.click

    # Redirects to Personal Info after account creation
    @browser.personal_info_link.click
    @browser.personal_info_label.is_visible.should be_true
    @browser.password_prompt_label.is_visible.should be_true
    @browser.password_label.is_visible.should be_true
    @browser.password_edit_button.is_visible.should be_true
    @browser.password_edit_button.click

    # Checking if 2FA is turned on
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
      initial_list = gmail.most_recent
      # Validate email values
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

    # Retries until password requirements header is true
    @browser.retry_until_found(lambda{@browser.password_rules_section_label.is_visible == false})
    # Validates elements in the password section are visible
    @browser.current_password_field.is_visible.should be_true
    @browser.new_password_field.is_visible.should be_true
    @browser.verify_new_password_field.is_visible.should be_true
    @browser.password_save_button.is_visible.should be_true
    @browser.password_cancel_button.is_visible.should be_true
    # Validate entering in incorrect current password value
    @browser.current_password_field.value = "incorrect"
    @browser.new_password_field.value = "Password1"
    @browser.verify_new_password_field.value = "Password1"
    @browser.password_save_button.click
    @browser.current_password_error_label.inner_text.should == "This password is incorrect. Please enter your Current Account Password."
    @browser.current_password_error_close_button.click

    # NEW UAS checks
    @browser.current_password_field.value = @password
    @browser.new_password_field.value = ""
    @browser.password_save_button.click
    @browser.new_password_error_label.is_visible.should be_true

    @browser.new_password_field.value = @new_email
    #@browser.popup_password_panel.new_password_error_label.is_visible.should be_false
    @browser.verify_new_password_field.value = " "
    @browser.new_password_error_label.inner_text.should == "The Password you entered does not meet our requirements."
    @browser.invalid_password_not_email_image.is_visible.should be_true

    @browser.new_password_field.value = "T"
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

    # Decided to not automate steps 11 - 14 because it's removing each rule criteria one at a time

    @browser.current_password_field.value = @password
    @browser.new_password_field.value = "Test1234"
    @browser.verify_new_password_field.value = "Test1234"
    #@browser.password_complete_label.is_visible.should be_true
    @browser.password_save_button.click
    # Retries until password requirements header is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.inner_text.should == "Your Password has been changed successfully."
    @browser.password_label.is_visible.should be_true
    # Log out
    @browser.profile_logout_link.click

    # Returns to GameStop's main page - need to login again to validate old password doesn't work
    @browser.profile_log_in_link.click #TODO go back to log_in_link
    @browser.login_header_label.is_visible.should be_true
    @browser.email_address_field.value = @new_email
    @browser.password_field.value = @password
    @browser.log_in_button.click
    @browser.retry_until_found(lambda{@browser.log_in_error_panel.is_visible == false})
    @browser.log_in_error_panel.is_visible.should be_true
    # Validate user able to login with new password
    @browser.email_address_field.value = @new_email
    @browser.password_field.value = "Test1234"
    @browser.log_in_button.click
    # Retries until the profile account name is true
    @browser.retry_until_found(lambda{@browser.profile_account_name.is_visible == false}) #TODO go back to account_name
    @browser.profile_account_name.inner_text.should include "PUR" #TODO go back to account_name
    # Log out
    @browser.profile_logout_link.click
  end

  it "TC69362: CP - PUR Activation - Existing Profile - Optional Fields - Over 13 Yrs Old" do
    # Create a new account via the activate link
    @browser.activate_link.click
    @browser.create_an_account_button.click
    @browser.create_email_address_field.value = @new_email
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.submit_button.click
    # Retries until activate_pur_header_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.activate_pur_header_label.is_visible == false})
    @browser.activate_pur_header_label.is_visible.should be_true
    # Enroll user with created email address via the loyalty membership service
    @enrolled_email, @card_number = @loyaltymembership_svc.enroll_existing_user(@params, @new_email)
    #$tracer.trace(enrolled_user.inspect)
    $tracer.trace("EMAIL: " + @enrolled_email)
    $tracer.trace("CARD NUMBER: " + @card_number)

    # Go to Personal Info page
    @browser.personal_info_link.click
    # Retries until @browser.personal_info_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_label.is_visible == false})
    @browser.personal_info_label.is_visible.should be_true
    # Set value for gender
    @browser.personal_details_edit_link.click
    @browser.gender_buttons.value = "Male"
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true
    # Adding a Preferred mailing address
    @browser.addresses_link.click
    # Retries until @browser.address_book_header_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.address_book_header_label.is_visible == false})
    @browser.address_book_header_label.is_visible.should be_true
    @browser.mailing_address_panel.add_address_button.click
    @browser.popup_address_panel.first_name_field.value = "Otto"
    @browser.popup_address_panel.last_name_field.value = "Matin"
    @browser.popup_address_panel.address_1_field.value = "123 High Point Dr"
    @browser.popup_address_panel.city_field.value = "Irving"
    @browser.popup_address_panel.state_province_selector.value = "TX"
    @browser.popup_address_panel.zip_postal_code_field.value = "75038"
    @browser.popup_address_panel.phone_number_field.value = "5555550000"
    @browser.popup_address_panel.save_button.click
    # Retries until @browser.mailing_address_panel.add_address_button.exists is true
    @browser.retry_until_found(lambda{@browser.mailing_address_panel.add_address_button.exists == false})
    @browser.mailing_address_panel.address_list.length.should == 1
    @browser.mailing_address_panel.address_list.at(0).default_address_label.is_visible.should be_true
    # Adding a Preferred shipping
    @browser.shipping_address_panel.add_address_button.click
    @browser.popup_address_panel.country_selector.value = "American Samoa"
    @browser.popup_address_panel.first_name_field.value = "Otto"
    @browser.popup_address_panel.last_name_field.value = "Matin"
    @browser.popup_address_panel.address_1_field.value = "123 High Point Dr"
    @browser.popup_address_panel.city_field.value = "Irving"
    @browser.popup_address_panel.state_province_field.value = "Somewhere"
    @browser.popup_address_panel.zip_postal_code_field.value = "75038"
    @browser.popup_address_panel.phone_number_field.value = "5555550000"
    @browser.popup_address_panel.save_button.click
    # Retries until @browser.shipping_address_panel.add_address_button.exists is true
    @browser.retry_until_found(lambda{@browser.shipping_address_panel.add_address_button.exists == false})
    @browser.shipping_address_panel.address_list.length.should == 1
    @browser.shipping_address_panel.address_list.at(0).default_address_label.is_visible.should be_true
    # Adding a Home Store
    @browser.stores_panel.add_store_button.click
    # Retries until @browser.store_finder_panel.is_visible is true
    @browser.retry_until_found(lambda{@browser.store_finder_panel.is_visible == false})
    @browser.store_finder_panel.store_finder_header_label.is_visible.should be_true
    @browser.store_finder_panel.store_results_list.length.should == 8
    @browser.store_finder_panel.store_results_list.at(0).store_number_label.is_visible.should be_true
    @browser.store_finder_panel.store_results_list.at(0).add_store_button.click
    # Retries until @browser.stores_panel.add_store_button.is_visible is true
    @browser.retry_until_found(lambda{@browser.stores_panel.add_store_button.is_visible == false})
    # Validate added store displays
    @browser.stores_panel.stores_list.length.should == 1
    @browser.stores_panel.stores_list.at(0).home_store_label.is_visible.should be_true
    @browser.refresh_page
    home_store = @browser.stores_panel.stores_list.at(0).full_store_label.inner_text
    $tracer.trace("Added store: " + home_store)
    # Authenticate the user
    @browser.activate_pur_link.click
    @browser.profile_powerup_rewards_number_field.value = @card_number
    @browser.pur_phone_field.value = "5555550000"
    @browser.activate_pur_continue_button.click
    # Retries until @browser.pur_authentication_error_label.exists is true
    @browser.retry_until_found(lambda{@browser.pur_authentication_error_label.is_visible == false})
    @browser.pur_authentication_error_label.is_visible.should be_true
    @browser.pur_authentication_error_label.inner_text.should == "Sorry, we couldn't validate your information. Please try again."
    @browser.profile_powerup_rewards_number_field.value = @card_number
    @browser.pur_phone_field.value = "1112223333"
    @browser.activate_pur_continue_button.click
    # Retries until @browser.pur_step1_prompt_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_step1_prompt_label.is_visible == false})
    # Activate the user
    @browser.pur_step1_prompt_label.is_visible.should be_true
    @browser.pur_opt_in_text_messages_checkbox.checked.should == "false"
    @browser.pur_opt_in_phone_checkbox.checked.should == "false"
    @browser.pur_opt_in_mail_checkbox.checked.should == "false"
    @browser.pur_primary_phone_field.get("disabled")
    @browser.pur_address_book_button.get("disabled")
    # Opt in for phone calls
    @browser.pur_opt_in_phone_checkbox.checked = true
    @browser.pur_primary_phone_field.value = "5555551111"
    # Opt in for mail
    @browser.pur_opt_in_mail_checkbox.checked = true
    @browser.pur_address_book_button.click
    # Retries until @browser.pur_address_list.exists is true
    @browser.retry_until_found(lambda{@browser.pur_address_list.exists == false})
    @browser.pur_address_list.is_visible.should be_true
    @browser.pur_address_book_header_label.is_visible.should be_true
    @browser.pur_address_book_close_button.is_visible.should be_true
    @browser.pur_address_list.length.should == 2
    selected_address = @browser.pur_address_list.at(0).pur_saved_address_label.inner_text
    @browser.pur_address_list.at(0).pur_select_address_button.click
    # Retries until @browser.pur_address_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_address_label.is_visible == false})
    @browser.pur_address_label.inner_text.should == selected_address
    # Adding a new address
    @browser.pur_add_address_button.click
    @browser.popup_address_panel.is_visible.should be_true
    @browser.popup_address_panel.first_name_field.value = "Otto2"
    @browser.popup_address_panel.last_name_field.value = "Matin2"
    @browser.popup_address_panel.address_1_field.value = "456 High Point Dr"
    @browser.popup_address_panel.city_field.value = "Irving"
    @browser.popup_address_panel.state_province_selector.value = "TX"
    @browser.popup_address_panel.zip_postal_code_field.value = "75038"
    @browser.popup_address_panel.phone_number_field.value = "5555552222"
    @browser.popup_address_panel.save_button.click
    # Retries until @browser.pur_add_address_button.is_visible is true
    #@browser.retry_until_found(lambda{@browser.pur_add_address_button.is_visible == false})
    sleep 2
    @browser.pur_address_label.inner_text.should == "Otto2 Matin2456 High Point DrIrving, TX 75038(555) 555-2222"
    # TODO Did not validate text - should the TC be changed to just check for it existing?
    @browser.pur_disclaimer_label.is_visible.should be_true
    @browser.pur_security_question_selector.value = "What's your favorite video game of all time?"
    @browser.pur_security_answer_field.value = "Katamari"
    @browser.pur_birth_month_selector.value = "December"
    @browser.pur_birth_day_selector.value = "31"
    @browser.pur_birth_year_selector.value = "1947"
    @browser.pur_gender_buttons.value.should == "Male"
    @browser.pur_gender_buttons.value = "Female"
    @browser.pur_activate_button.click
    # Successfully activated
    # Retries until @browser.pur_congrats_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_congrats_label.is_visible == false})
    @browser.personal_info_label.is_visible.should be_true
    @browser.pur_congrats_label.is_visible.should be_true
    @browser.pur_success_text_label.is_visible.should be_true
    @browser.pur_continue_button.is_visible.should be_true
    # Validating Personal Info values
    @browser.phone_label.inner_text.should == "(555) 555-1111"
    @browser.security_question_label.inner_text.should == "What's your favorite video game of all time?"
    @browser.security_answer_label.is_visible.should be_true
    @browser.birth_month_label.inner_text.should == "December"
    @browser.birthday_label.inner_text.should == "31"
    @browser.gender_label.inner_text.should == "Female"
    # Validating Addresses values
    @browser.addresses_link.click
    $tracer.trace("Mailing address : " + @browser.mailing_address_panel.address_list.at(0).full_address_label.inner_text)
    @browser.mailing_address_panel.address_list.at(0).full_address_label.inner_text.should == "Otto2 Matin2456 High Point DrIrving, TX 75038(555) 555-2222"
    @browser.mailing_address_panel.address_list.at(0).default_address_label.is_visible.should be_true
    # Validating Store values
    @browser.stores_panel.stores_list.length.should == 2
    @browser.stores_panel.stores_list.at(0).full_store_label.inner_text.should == home_store
    @browser.stores_panel.stores_list.at(1).full_store_label.inner_text.include? "2356"
    # Validating Communications values
    @browser.communications_link.click
    @browser.communications_header_label.is_visible.should be_true
    @browser.pur_opt_in_text_messages_checkbox.checked.should == "false"
    @browser.pur_opt_in_phone_checkbox.checked.should == "true"
    @browser.pur_opt_in_mail_checkbox.checked.should == "true"
    @browser.pur_address_label.inner_text.should == "Otto2 Matin2456 High Point DrIrving, TX 75038(555) 555-2222"
    # Log out
    @browser.profile_logout_link.click

    # Validating in the database profile, address and membership values - QA_ConsolidatedProfile
    profile_results = @db.exec_sql("	SELECT p.ProfileID, p.GenderID, p.BirthMonth, p.BirthDay, p.BirthYear, ph.PhoneNumber, a.Line1, a.Line2, a.City, a.State, a.PostalCode, a.Country, a.RecipientFirstName,
                              a.RecipientLastName, a.RecipientPhoneNumber, a.[Default], m.MembershipStatusID
                            FROM Profile.dbo.Profile p WITH(NOLOCK)
                            JOIN Profile.dbo.Address a WITH(NOLOCK)
                            ON p.ProfileID = a.ProfileID
                            JOIN Profile.dbo.Phone ph WITH(NOLOCK)
                            ON p.ProfileID = ph.ProfileID
                            JOIN Profile.KeyMap.CustomerKey ck WITH(NOLOCK)
                            ON p.ProfileID = ck.ProfileID
                            JOIN Membership.dbo.Membership m WITH(NOLOCK)
                            ON m.MembershipID = ck.MembershipID
                            JOIN Multipass.dbo.IssuedUser iu WITH(NOLOCK)
                            ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                            WHERE iu.EmailAddress = '#{@new_email}'
                            and a.AddressTypeID = 2 and a.[Default] = 1")

    profile_results.at(0).GenderID.should == 2
    profile_results.at(0).BirthMonth.should == 12
    profile_results.at(0).BirthDay.should == 31
    profile_results.at(0).BirthYear.should == 1947
    profile_results.at(0).PhoneNumber.should == "5555551111"
    profile_results.at(0).Line1.should == "456 High Point Dr"
    profile_results.at(0).Line2.should be_nil
    profile_results.at(0).City.should == "Irving"
    profile_results.at(0).State.should == "TX"
    profile_results.at(0).PostalCode.should == "75038"
    profile_results.at(0).Country.should == "US"
    profile_results.at(0).RecipientFirstName.should == "Otto2"
    profile_results.at(0).RecipientLastName.should == "Matin2"
    profile_results.at(0).RecipientPhoneNumber.should == "5555552222"
    profile_results.at(0).Default.should == true
    profile_results.at(0).MembershipStatusID.should == 1

    comm_results = @db.exec_sql("SELECT r.*, pa.*
                                FROM GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
                                      JOIN GenesisCorp.dbo.refResource r WITH(NOLOCK)
                                            ON pq.ResourceID = r.ResourceID
                                      JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
                                            ON pq.PreferenceQuestionID = pa.PreferenceQuestionID
                                WHERE pa.CustomerID in (SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = '#{@new_email}')
                                and r.ResouceText like 'PreferencesQandA.Q.PreferredContactMethod%'
                                and pa.PreferencePossibleAnswerID in (358, 2)")
    comm_results.length.should == 2

    # Validates security question answer is saved in the db - QA_ConsolidatedProfile
    security_results  = @db.exec_sql("SELECT pa.AnswerText
                                    FROM GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
                                          JOIN GenesisCorp.dbo.refResource r WITH(NOLOCK)
                                                ON pq.ResourceID = r.ResourceID
                                          JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
                                                ON pq.PreferenceQuestionID = pa.PreferenceQuestionID
                                    WHERE pa.CustomerID in (SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = '#{@new_email}')
                                    and r.ResouceText = 'PreferencesQandA.SecurityQ.AnswerSelected'")

    security_results.at(0).AnswerText.should == "Katamari"
  end

  #TODO Activation banner
  it "TC69360: CP - PUR Activation - New Profile - Required Fields - Over 13 Yrs Old" do
    # Enroll user via the loyalty membership service - no existing email address
    @enrolled_email, @card_number = @loyaltymembership_svc.enroll_pur_user(@params)
    #$tracer.trace(enrolled_user.inspect)
    $tracer.trace("EMAIL: " + @enrolled_email)
    $tracer.trace("CARD NUMBER: " + @card_number)

    # Create a new account via the activate link
    @browser.activate_link.click
    @browser.create_an_account_button.click
    @browser.create_email_address_field.value = @enrolled_email
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.submit_button.click
    # Retries until activate_pur_header_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.activate_pur_header_label.is_visible == false})
    @browser.activate_pur_header_label.is_visible.should be_true

    # Authenticate the user
    @browser.profile_powerup_rewards_number_field.value = @card_number
    @browser.pur_email_field.value = "anything@whatever.com"
    @browser.activate_pur_continue_button.click
    # Retries until @browser.pur_authentication_error_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_authentication_error_label.is_visible == false})
    @browser.pur_authentication_error_label.inner_text.should == "Sorry, we couldn't validate your information. Please try again."
    @browser.profile_powerup_rewards_number_field.value = @card_number
    @browser.pur_email_field.value = @enrolled_email
    @browser.activate_pur_continue_button.click
    # Retries until @browser.pur_step1_prompt_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_step1_prompt_label.is_visible == false})
    @browser.pur_step1_prompt_label.is_visible.should be_true
    # Activate with none of the required fields populated
    @browser.pur_activate_button.click
    # Validate error messages display
    @browser.pur_security_question_error_label.is_visible.should be_true
    @browser.pur_security_answer_error_label.is_visible.should be_true
    @browser.pur_birthday_error_label.is_visible.should be_true
    # Activate the user
    @browser.pur_security_question_selector.value = "What's your favorite video game of all time?"
    @browser.pur_security_answer_field.value = "Katamari"
    @browser.pur_birth_month_selector.value = "December"
    @browser.pur_birth_day_selector.value = "31"
    @browser.pur_birth_year_selector.value = "1947"
    @browser.pur_activate_button.click
    # Successfully activated
    # Retries until @browser.pur_congrats_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_congrats_label.is_visible == false})
    @browser.personal_info_label.is_visible.should be_true
    @browser.pur_congrats_label.is_visible.should be_true
    # Validating Personal Info values
    @browser.security_question_label.inner_text.should == "What's your favorite video game of all time?"
    @browser.security_answer_label.is_visible.should be_true
    @browser.birth_month_label.inner_text.should == "December"
    @browser.birthday_label.inner_text.should == "31"
    @browser.gender_label.inner_text.empty?
    # Validating Addresses values
    @browser.addresses_link.click
    $tracer.trace("Mailing address : " + @browser.mailing_address_panel.address_list.at(0).full_address_label.inner_text)
    @browser.mailing_address_panel.address_list.at(0).full_address_label.inner_text.should == "Otto Matin625 Westport PkwyGrapevine, TX 76051"
    @browser.mailing_address_panel.address_list.at(0).default_address_label.is_visible.should be_true
    # Validating Store values
    @browser.stores_panel.stores_list.length.should == 1
    @browser.stores_panel.stores_list.at(0).full_store_label.inner_text.include? "2356"
    # Validate PUR Dashboard info for activated user
    @browser.pur_dashboard_link.click
    @browser.activate_pur_link.is_visible.should be_false
    #TODO Add PUR dashboard validation
    # Log out
    @browser.profile_logout_link.click

    # Validating membership is activated in the database - QA_ConsolidatedProfile
    membership_results = @db.exec_sql("SELECT m.MembershipStatusID
                                    FROM Membership.dbo.Membership m
                                    JOIN Profile.KeyMap.CustomerKey ck
                                    ON m.MembershipID = ck.MembershipID
                                    JOIN Multipass.dbo.IssuedUser iu
                                    ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                                    WHERE iu.EmailAddress = '#{@enrolled_email}'")

    membership_results.at(0).MembershipStatusID.should == 1
  end

  #TODO ASK HANIF ABOUT STEP 3 because there is no banner when it's on the activation page
  it "TC68481: CP - PUR Activation - Birthday - Under 13yrs old user" do
    # Enroll user via the loyalty membership service - no existing email address
    @enrolled_email, @card_number = @loyaltymembership_svc.enroll_pur_user(@params)
    #$tracer.trace(enrolled_user.inspect)
    $tracer.trace("EMAIL: " + @enrolled_email)
    $tracer.trace("CARD NUMBER: " + @card_number)

    # Create a new account via the activate link
    @browser.activate_link.click
    @browser.create_an_account_button.click
    @browser.create_email_address_field.value = @enrolled_email
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.submit_button.click
    # Retries until activate_pur_header_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.activate_pur_header_label.is_visible == false})
    @browser.activate_pur_header_label.is_visible.should be_true
    # Authenticate the user
    @browser.profile_powerup_rewards_number_field.value = @card_number
    @browser.pur_email_field.value = @enrolled_email
    @browser.activate_pur_continue_button.click
    # Retries until @browser.pur_step1_prompt_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_step1_prompt_label.is_visible == false})
    @browser.pur_step1_prompt_label.is_visible.should be_true
    # Activate the user
    @browser.pur_security_question_selector.value = "What's your favorite video game of all time?"
    @browser.pur_security_answer_field.value = "Katamari"
    @browser.pur_birth_month_selector.value = "December"
    @browser.pur_birth_day_selector.value = "31"
    @browser.pur_birth_year_selector.value = "2014"
    @browser.pur_activate_button.click
    # Successfully activated
    # Retries until @browser.pur_invalid_age_error_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_invalid_age_error_label.is_visible == false})
    @browser.pur_invalid_age_error_label.inner_text.should == "You must be at least 13 years oldto enroll in PowerUp Rewards."
    @browser.privacy_policy_link.is_visible.should be_true
    @browser.terms_and_conditions_link.should be_true

    # Log out
    @browser.profile_logout_link.click

    # Re-log in #TODO go back to log_in_link
    @browser.profile_log_in_link.click
    @browser.login_header_label.is_visible.should be_true
    # Log in with an existing account
    @browser.email_address_field.value = @enrolled_email
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until @browser.profile_account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.profile_account_name.is_visible == false})
    @browser.profile_my_account_link.click
    # Go to the Personal Info page
    @browser.retry_until_found(lambda{@browser.personal_info_label.is_visible == false})
    @browser.personal_info_label.is_visible.should be_true
    @browser.security_question_label.is_visible.should be_false
    @browser.security_answer_label.is_visible.should be_false
    # Go to Activate
    @browser.activate_pur_link.click
    # Validate age gate message displays
    @browser.pur_invalid_age_error_label.inner_text.should == "You must be at least 13 years oldto enroll in PowerUp Rewards."
    @browser.privacy_policy_link.is_visible.should be_true
    @browser.terms_and_conditions_link.should be_true

    # Log out
    @browser.profile_logout_link.click

    # Validating membership is not activated in the database - QA_ConsolidatedProfile
    membership_results = @db.exec_sql("SELECT m.MembershipStatusID
                                    FROM Membership.dbo.Membership m
                                    JOIN Profile.KeyMap.CustomerKey ck
                                    ON m.MembershipID = ck.MembershipID
                                    JOIN Multipass.dbo.IssuedUser iu
                                    ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                                    WHERE iu.EmailAddress = '#{@enrolled_email}'")

    membership_results.at(0).MembershipStatusID.should == 2
  end

  it "TC 68474: CP - Personal Info - Update Personal Info for Existing User" do
    # Click on the login link from the PUR site
    @browser.log_in_link.click
    @browser.login_header_label.is_visible.should be_true
    # Log in with an existing account
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until @browser.my_account_menu_link.is_visible is true
    @browser.retry_until_found(lambda{@browser.my_account_menu_link.is_visible == false})
    @browser.my_account_menu_link.click
    # Go to the Personal Info page
    @browser.personal_info_label.is_visible.should be_true
    # Fields pertaining to PUR should display if activated
    @browser.contact_email_prompt_label.is_visible.should be_true
    @browser.contact_email_label.is_visible.should be_true
    @browser.contact_email_edit_link.is_visible.should be_true
    @browser.security_question_prompt_label.is_visible.should be_true
    @browser.security_question_label.is_visible.should be_true
    @browser.security_answer_label.is_visible.should be_true

    # Updating security question/answer
    @browser.security_edit_link.click

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
        gmail.most_recent[0].receiver_email_address != "To: #{@login}\r\n\r\n"
      },
                                 90, 0.5
      )
      initial_list = gmail.most_recent
      # Validate email values
      initial_list[0].subject.should == "GameStop Verification Code"
      initial_list[0].sender_email_address.should == "notifications@gamestop.com"
      initial_list[0].receiver_email_address.should == @login
      # Validate receiver email address is correct
      $tracer.trace("RECEIVER ADDR: " + initial_list[0].receiver_email_address.to_s)
      addr_list = initial_list.find_with_receiver_address(@login)
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

    @browser.pur_security_question_selector.value = "Choose a Security Question..."
    @browser.pur_security_answer_field.value = ""
    @browser.security_save_button.click
    @browser.pur_security_question_error_label.is_visible.should be_true
    @browser.pur_security_question_selector.value = "What's your favorite video game character of all time?"
    @browser.security_save_button.click
    @browser.pur_security_answer_error_label.is_visible.should be_true
    @browser.pur_security_question_selector.value = "What's your favorite video game character of all time?"
    @browser.pur_security_answer_field.value = "Zelda"
    @browser.security_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true

    # Updating contact email address
    @browser.contact_email_edit_link.click
    # Retries until @browser.contact_email_field.is_visible is true
    @browser.retry_until_found(lambda{@browser.contact_email_field.is_visible == false})
    @browser.contact_email_field.value = ""
    @browser.contact_email_save_button.click
    @browser.contact_email_error_label.is_visible.should be_true
    @browser.contact_email_field.value = @login
    @browser.contact_email_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true

    # Clearing out existing values and attempting to save
    @browser.personal_details_edit_link.click
    @browser.profile_first_name_field.value = ""
    @browser.middle_name_field.value = ""
    @browser.profile_last_name_field.value = ""
    @browser.reviewer_field.value = ""
    @browser.contact_primary_phone_field.value = ""
    @browser.birth_month_selector.value = "Month"
    @browser.birth_day_selector.value = "Day"
    @browser.personal_info_save_button.click
    #Retries until @browser.first_name_error_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.first_name_error_label.is_visible == false})
    # Error message displays for required fields
    @browser.first_name_error_label.is_visible.should be_true
    @browser.last_name_error_label.is_visible.should be_true
    @browser.phone_error_label.is_visible.should be_true
    @browser.birthday_error_label.is_visible.should be_true
    @browser.personal_info_error_label.is_visible.should be_true
    # Populating and saving required fields
    @browser.profile_first_name_field.value = "Ottomatin"
    @browser.profile_last_name_field.value = "Activated"
    @browser.contact_primary_phone_field.value = "555-555-0000"
    @browser.birth_month_selector.value = "July"
    @browser.birth_day_selector.value = "31"
    # Validating if middle name can be saved
    @browser.middle_name_field.value = "Middle-changed"
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true
    # Validating if reviewer name can be saved
    @browser.personal_details_edit_link.click
    @browser.reviewer_field.value = "OttoActive"
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true
    # Validating if gender can be saved
    @browser.personal_details_edit_link.click
    @browser.gender_buttons.value = "Unknown"
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true
    # Validating values are saved in the db - QA_ConsolidatedProfile
    results = @db.exec_sql("SELECT p.FirstName, p.MiddleName, p.LastName, p.DisplayName, p.EmailAddress, p.GenderID, p.BirthMonth, p.BirthDay, p.BirthYear, ph.PhoneNumber
                          FROM Profile.dbo.Profile p
                          JOIN Profile.dbo.Phone ph
                            ON p.ProfileID = ph.ProfileID
                          JOIN Profile.KeyMap.CustomerKey ck
                            ON ph.ProfileID = ck.ProfileID
                          JOIN Multipass.dbo.IssuedUser iu
                            ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                          WHERE iu.EmailAddress = '#{@login}'")

    results.at(0).FirstName.should == "Ottomatin"
    results.at(0).MiddleName.should == "Middle-changed"
    results.at(0).LastName.should == "Activated"
    results.at(0).DisplayName.should == "OttoActive"
    results.at(0).GenderID.should == 0
    results.at(0).BirthMonth.should == 7
    results.at(0).BirthDay.should == 31
    results.at(0).BirthYear.should == 1996 #gspcauto.fav.cc user had 1996
    results.at(0).PhoneNumber.should == "5555550000"
    results.at(0).EmailAddress.should == @login
    # Validates security question answer is saved in the db - QA_ConsolidatedProfile
    security_results  = @db.exec_sql("SELECT pa.AnswerText
                                    FROM GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
                                          JOIN GenesisCorp.dbo.refResource r WITH(NOLOCK)
                                                ON pq.ResourceID = r.ResourceID
                                          JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
                                                ON pq.PreferenceQuestionID = pa.PreferenceQuestionID
                                    WHERE pa.CustomerID in (SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = '#{@login}')
                                    and r.ResouceText = 'PreferencesQandA.SecurityQ.AnswerSelected'")

    security_results.at(0).AnswerText.should == "Zelda"
    # Log out
    @browser.profile_logout_link.click
  end

  it "TC70095: CP - Contact Email Address Validation - Existing PUR User - Valid Email address" do
    # Click on the login link from the PUR site
    @browser.log_in_link.click
    @browser.login_header_label.is_visible.should be_true
    @browser.create_an_account_button.is_visible.should be_true
    # Log in with existing account found in dataset
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until hi name label is true
    @browser.retry_until_found(lambda{@browser.hi_name_label.exists == false})
    @browser.hi_name_label.inner_text.should include "Ottomatin"

    @browser.my_account_menu_link.click
    # Successful account creation goes to Personal Info page
    @browser.personal_info_label.is_visible.should be_true

    # Update contact email address to valid email address
    @browser.contact_email_edit_link.click

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
        gmail.instance_variable_get(:@imap).examine('INBOX') #Retrieves the latest in inbox
        gmail.most_recent[0].receiver_email_address != "To: #{@login}\r\n\r\n"
      },
                                 90, 0.5
      )
      initial_list = gmail.most_recent
      # Validate email values
      initial_list[0].subject.should == "GameStop Verification Code"
      initial_list[0].sender_email_address.should == "notifications@gamestop.com"
      initial_list[0].receiver_email_address.should == @login
      # Validate receiver email address is correct
      $tracer.trace("RECEIVER ADDR: " + initial_list[0].receiver_email_address.to_s)
      addr_list = initial_list.find_with_receiver_address(@login)
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
    end
    # Retries until @browser.contact_email_field.is_visible is true
    @browser.retry_until_found(lambda{@browser.contact_email_field.is_visible == false})
    @browser.contact_email_field.value = @login
    @browser.contact_email_save_button.click

    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    #TODO add validation for 200 response code

    # Log out
    @browser.profile_logout_link.click

    # Validating values are saved in the db - QA_ConsolidatedProfile
    results = @db.exec_sql("SELECT p.EmailAddress
                          FROM Profile.dbo.Profile p
                          JOIN Profile.dbo.Phone ph
                            ON p.ProfileID = ph.ProfileID
                          JOIN Profile.KeyMap.CustomerKey ck
                            ON ph.ProfileID = ck.ProfileID
                          JOIN Multipass.dbo.IssuedUser iu
                            ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                          WHERE iu.EmailAddress = '#{@login}'")

    results.at(0).EmailAddress.should == @login
  end

  it "TC70100: CP - Contact Email Address Validation - Existing PUR User - Non Deliverable Email address" do
    # Click on the login link from the PUR site
    @browser.log_in_link.click
    @browser.login_header_label.is_visible.should be_true
    @browser.create_an_account_button.is_visible.should be_true
    # Log in with existing account found in dataset
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until hi name label is true
    @browser.retry_until_found(lambda{@browser.hi_name_label.exists == false})
    @browser.hi_name_label.inner_text.should include "Ottomatin"

    @browser.my_account_menu_link.click
    # Successful account creation goes to Personal Info page
    @browser.personal_info_label.is_visible.should be_true

    # Update contact email address
    @browser.contact_email_edit_link.click
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
        gmail.most_recent[0].receiver_email_address != "To: #{@login}\r\n\r\n"
      },
                                 90, 0.5
      )
      initial_list = gmail.most_recent
      # Validate email values
      initial_list[0].subject.should == "GameStop Verification Code"
      initial_list[0].sender_email_address.should == "notifications@gamestop.com"
      initial_list[0].receiver_email_address.should == @login
      # Validate receiver email address is correct
      $tracer.trace("RECEIVER ADDR: " + initial_list[0].receiver_email_address.to_s)
      addr_list = initial_list.find_with_receiver_address(@login)
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
    end
    # Retries until @browser.contact_email_field.is_visible is true
    @browser.retry_until_found(lambda{@browser.contact_email_field.is_visible == false})
    @browser.contact_email_field.value = "bademail@asdf.fav.cc"
    @browser.contact_email_save_button.click

    ## Retries until @browser.personal_info_error_label.is_visible is true
    #@browser.retry_until_found(lambda{@browser.personal_info_error_label.is_visible == false})

    # Validate error message
    @browser.contact_email_error_label.is_visible.should be_true
    @browser.contact_email_error_label.inner_text.should == "The information you entered is not a valid E-mail address. Please enter another E-mail address."

    # Log out
    @browser.profile_logout_link.click

    # Validating values are saved in the db - QA_ConsolidatedProfile
    results = @db.exec_sql("SELECT p.EmailAddress
                          FROM Profile.dbo.Profile p
                          JOIN Profile.dbo.Phone ph
                            ON p.ProfileID = ph.ProfileID
                          JOIN Profile.KeyMap.CustomerKey ck
                            ON ph.ProfileID = ck.ProfileID
                          JOIN Multipass.dbo.IssuedUser iu
                            ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                          WHERE iu.EmailAddress = '#{@login}'")

    results.at(0).EmailAddress.should == @login
  end

  it "TC64716: CP - Communication Pref - Preferences from Activation Persists" do
    # Create a new account via the activate link
    @browser.activate_link.click
    @browser.create_an_account_button.click
    @browser.create_email_address_field.value = @new_email
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.submit_button.click
    # Retries until activate_pur_header_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.activate_pur_header_label.is_visible == false})
    @browser.activate_pur_header_label.is_visible.should be_true
    # Enroll user with created email address via the loyalty membership service
    @enrolled_email, @card_number = @loyaltymembership_svc.enroll_existing_user(@params, @new_email)
    #$tracer.trace(enrolled_user.inspect)
    $tracer.trace("EMAIL: " + @enrolled_email)
    $tracer.trace("CARD NUMBER: " + @card_number)

    # Authenticate the user
    @browser.profile_powerup_rewards_number_field.value = @card_number
    @browser.pur_phone_field.value = "1112223333"
    @browser.activate_pur_continue_button.click
    # Retries until @browser.pur_step1_prompt_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_step1_prompt_label.is_visible == false})
    # Activate the user
    @browser.pur_step1_prompt_label.is_visible.should be_true
    @browser.pur_opt_in_text_messages_checkbox.checked.should == "false"
    @browser.pur_opt_in_phone_checkbox.checked.should == "false"
    @browser.pur_opt_in_mail_checkbox.checked.should == "false"
    @browser.pur_primary_phone_field.get("disabled")
    @browser.pur_address_book_button.get("disabled")
    # Opt in for text messages
    @browser.pur_opt_in_text_messages_checkbox.checked = true
    # Opt in for phone calls
    @browser.pur_opt_in_phone_checkbox.checked = true
    @browser.pur_primary_phone_field.value = "5555551111"
    # Opt in for mail
    @browser.pur_opt_in_mail_checkbox.checked = true
    @browser.pur_address_label.inner_text.should == "Otto Matin625 Westport PkwyGrapevine, TX 76051"
    # Entering in required fields for activation
    @browser.pur_security_question_selector.value = "What's your favorite video game of all time?"
    @browser.pur_security_answer_field.value = "Katamari"
    @browser.pur_birth_month_selector.value = "December"
    @browser.pur_birth_day_selector.value = "31"
    @browser.pur_birth_year_selector.value = "1947"
    @browser.pur_activate_button.click
    # Successfully activated
    # Retries until @browser.pur_congrats_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_congrats_label.is_visible == false})
    @browser.pur_congrats_label.is_visible.should be_true
    # Log out
    @browser.profile_logout_link.click
    # Returns to GameStop's main page - Log back in with the created account
    @browser.profile_log_in_link.click #TODO go back to log_in_link
    @browser.login_header_label.is_visible.should be_true
    @browser.email_address_field.value = @new_email
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until @browser.profile_account_name.is_visible is true
    @browser.retry_until_found(lambda{@browser.profile_account_name.is_visible == false})
    @browser.profile_account_name.click
    # Validating Communications values
    @browser.communications_link.click
    @browser.communications_header_label.is_visible.should be_true
    @browser.pur_opt_in_text_messages_checkbox.checked.should == "true"
    @browser.pur_opt_in_phone_checkbox.checked.should == "true"
    @browser.pur_opt_in_mail_checkbox.checked.should == "true"
    @browser.pur_address_label.inner_text.should == "Otto Matin625 Westport PkwyGrapevine, TX 76051"
    # Log out
    @browser.profile_logout_link.click

    # Validating the selected comm prefs saved in the db
    comm_results = @db.exec_sql("SELECT r.*, pa.*
                                FROM GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
                                      JOIN GenesisCorp.dbo.refResource r WITH(NOLOCK)
                                            ON pq.ResourceID = r.ResourceID
                                      JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
                                            ON pq.PreferenceQuestionID = pa.PreferenceQuestionID
                                WHERE pa.CustomerID in (SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = '#{@new_email}')
                                and r.ResouceText like 'PreferencesQandA.Q.PreferredContactMethod%'
                                and pa.PreferencePossibleAnswerID in (358, 2, 3)")
    comm_results.length.should == 3
  end

  it "TC68444: CP - Communication Pref - Mail Pref - Add a New Address" do
    # TODO: Consider going back to using existing account ottomatinactivated@gspcauto.fav.cc when profile dsl is ready for the cleanup
    # Enroll user via the loyalty membership service - no existing email address
    @enrolled_email, @card_number = @loyaltymembership_svc.enroll_pur_user(@params)
    #$tracer.trace(enrolled_user.inspect)
    $tracer.trace("EMAIL: " + @enrolled_email)
    $tracer.trace("CARD NUMBER: " + @card_number)

    # Create a new account via the activate link
    @browser.activate_link.click
    @browser.create_an_account_button.click
    @browser.create_email_address_field.value = @enrolled_email
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.submit_button.click
    # Retries until activate_pur_header_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.activate_pur_header_label.is_visible == false})
    @browser.activate_pur_header_label.is_visible.should be_true

    # Authenticate the user
    @browser.profile_powerup_rewards_number_field.value = @card_number
    @browser.pur_email_field.value = @enrolled_email
    @browser.activate_pur_continue_button.click
    # Retries until @browser.pur_step1_prompt_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_step1_prompt_label.is_visible == false})
    @browser.pur_step1_prompt_label.is_visible.should be_true
    # Activate the user
    @browser.pur_security_question_selector.value = "What's your favorite video game of all time?"
    @browser.pur_security_answer_field.value = "Katamari"
    @browser.pur_birth_month_selector.value = "December"
    @browser.pur_birth_day_selector.value = "31"
    @browser.pur_birth_year_selector.value = "1947"
    @browser.pur_activate_button.click
    # Successfully activated
    # Retries until @browser.pur_congrats_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_congrats_label.is_visible == false})
    @browser.pur_congrats_label.is_visible.should be_true

    # Go Communications page
    @browser.communications_link.click
    # Opt in for mail for PUR
    @browser.pur_communications_label.is_visible.should be_true
    @browser.pur_opt_in_mail_checkbox.checked.should == "false"
    @browser.pur_address_book_button.get("disabled")
    @browser.pur_opt_in_mail_checkbox.checked = "true"
    @browser.pur_add_address_button.click
    # Validate no country drop down or default checkbox
    @browser.popup_address_panel.is_visible.should be_true
    @browser.popup_address_panel.country_selector.is_visible.should be_false
    @browser.popup_address_panel.default_address_checkbox.is_visible.should be_false
    # Adding a new mailing address for communication preferences
    @browser.popup_address_panel.first_name_field.value = "Ottomatin"
    @browser.popup_address_panel.last_name_field.value = "Activated"
    @browser.popup_address_panel.address_1_field.value = "456 High Point Dr"
    @browser.popup_address_panel.city_field.value = "Irving"
    @browser.popup_address_panel.state_province_selector.value = "TX"
    @browser.popup_address_panel.zip_postal_code_field.value = "75038"
    @browser.popup_address_panel.phone_number_field.value = "5555551111"
    @browser.popup_address_panel.save_button.click
    # Retries until @browser.popup_address_panel.is_visible is false
    @browser.retry_until_found(lambda{@browser.popup_address_panel.exists == true}, 30, 0.5, 5){
      @browser.popup_address_panel.exists.should be_false
    }
    @browser.communications_update_button.click
    # Retries until {@browser.pur_communications_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_communications_success_label.is_visible == false})
    @browser.pur_communications_success_label.is_visible.should be_true
    @browser.pur_communications_success_label.inner_text.should == "Your information has been saved."
    @browser.pur_address_label.inner_text.should == "Ottomatin Activated456 High Point DrIrving, TX 75038(555) 555-1111"

    # Validating selection for communications is saved in the db - QA_ConsolidatedProfile
    results = @db.exec_sql("SELECT pa.PreferencePossibleAnswerID
                          FROM GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
                                JOIN GenesisCorp.dbo.refResource r WITH(NOLOCK)
                                      ON pq.ResourceID = r.ResourceID
                                JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
                                      ON pq.PreferenceQuestionID = pa.PreferenceQuestionID
                          WHERE pa.CustomerID in (SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = '#{@enrolled_email}')
                          and r.ResouceText like 'PreferencesQandA.Q.PreferredContactMethod%'
                          and pa.PreferencePossibleAnswerID = 358")
    results.at(0).PreferencePossibleAnswerID.should == 358
    # Validating new mailing address is saved in the DB - QA_ConsolidatedProfile
    address_results = @db.exec_sql("SELECT a.Line1, a.Line2, a.City, a.State, a.PostalCode, a.Country, a.RecipientFirstName,
                              a.RecipientLastName, a.RecipientPhoneNumber, a.[Default]
                                  FROM Profile.dbo.Address a
                                  JOIN Profile.KeyMap.CustomerKey ck
                                  ON a.ProfileID = ck.ProfileID
                                  JOIN Multipass.dbo.IssuedUser iu
                                  ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                                  WHERE iu.EmailAddress = '#{@enrolled_email}'
                                  and a.AddressTypeID = 2 and a.[Default] = 1
                                  ORDER BY DateCreated desc")
    address_results.at(0).Line1.should == "456 High Point Dr"
    address_results.at(0).Line2.should be_nil
    address_results.at(0).City.should == "Irving"
    address_results.at(0).State.should == "TX"
    address_results.at(0).PostalCode.should == "75038"
    address_results.at(0).Country.should == "US"
    address_results.at(0).RecipientFirstName.should == "Ottomatin"
    address_results.at(0).RecipientLastName.should == "Activated"
    address_results.at(0).RecipientPhoneNumber.should == "5555551111"
    address_results.at(0).Default.should == true

    # Log out
    @browser.profile_logout_link.click
  end

  it "TC64738: CP - Communication Pref - Mail Pref - Choose New Address" do
    # TODO: Consider going back to using existing account ottomatinactivated@gspcauto.fav.cc when profile dsl is ready for the cleanup
    # Enroll user via the loyalty membership service - no existing email address
    @enrolled_email, @card_number = @loyaltymembership_svc.enroll_pur_user(@params)
    #$tracer.trace(enrolled_user.inspect)
    $tracer.trace("EMAIL: " + @enrolled_email)
    $tracer.trace("CARD NUMBER: " + @card_number)

    # Create a new account via the activate link
    @browser.activate_link.click
    @browser.create_an_account_button.click
    @browser.create_email_address_field.value = @enrolled_email
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.submit_button.click
    # Retries until activate_pur_header_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.activate_pur_header_label.is_visible == false})
    @browser.activate_pur_header_label.is_visible.should be_true

    # Authenticate the user
    @browser.profile_powerup_rewards_number_field.value = @card_number
    @browser.pur_email_field.value = @enrolled_email
    @browser.activate_pur_continue_button.click
    # Retries until @browser.pur_step1_prompt_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_step1_prompt_label.is_visible == false})
    @browser.pur_step1_prompt_label.is_visible.should be_true
    # Activate the user
    @browser.pur_security_question_selector.value = "What's your favorite video game of all time?"
    @browser.pur_security_answer_field.value = "Katamari"
    @browser.pur_birth_month_selector.value = "December"
    @browser.pur_birth_day_selector.value = "31"
    @browser.pur_birth_year_selector.value = "1947"
    @browser.pur_activate_button.click
    # Successfully activated
    # Retries until @browser.pur_congrats_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_congrats_label.is_visible == false})
    @browser.pur_congrats_label.is_visible.should be_true

    # Adding a Preferred mailing address
    @browser.addresses_link.click
    # Retries until @browser.address_book_header_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.address_book_header_label.is_visible == false})
    @browser.address_book_header_label.is_visible.should be_true
    @browser.mailing_address_panel.add_address_button.click
    @browser.popup_address_panel.first_name_field.value = "Otto"
    @browser.popup_address_panel.last_name_field.value = "Matin"
    @browser.popup_address_panel.address_1_field.value = "123 High Point Dr"
    @browser.popup_address_panel.city_field.value = "Irving"
    @browser.popup_address_panel.state_province_selector.value = "TX"
    @browser.popup_address_panel.zip_postal_code_field.value = "75038"
    @browser.popup_address_panel.phone_number_field.value = "5555550000"
    @browser.popup_address_panel.save_button.click
    # Retries until @browser.popup_address_panel.is_visible is false
    @browser.retry_until_found(lambda{@browser.popup_address_panel.exists == true}, 30, 0.5, 5){
      @browser.popup_address_panel.exists.should be_false
    }
    @browser.mailing_address_panel.address_list.length.should == 2
    @browser.mailing_address_panel.address_list.at(0).default_address_label.is_visible.should be_true

    # Adding a Preferred international shipping address
    @browser.shipping_address_panel.add_address_button.click
    @browser.popup_address_panel.country_selector.value = "American Samoa"
    @browser.popup_address_panel.first_name_field.value = "Otto"
    @browser.popup_address_panel.last_name_field.value = "Matin"
    @browser.popup_address_panel.address_1_field.value = "123 High Point Dr"
    @browser.popup_address_panel.city_field.value = "Irving"
    @browser.popup_address_panel.state_province_field.value = "Somewhere"
    @browser.popup_address_panel.zip_postal_code_field.value = "75038"
    @browser.popup_address_panel.phone_number_field.value = "5555550000"
    @browser.popup_address_panel.save_button.click
    # Retries until @browser.popup_address_panel.is_visible is false
    @browser.retry_until_found(lambda{@browser.popup_address_panel.exists == true}, 30, 0.5, 5){
      @browser.popup_address_panel.exists.should be_false
    }
    @browser.shipping_address_panel.address_list.length.should == 1
    @browser.shipping_address_panel.address_list.at(0).default_address_label.is_visible.should be_true

    # Opting in for mail communications
    @browser.communications_link.click
    @browser.pur_communications_label.is_visible.should be_true
    @browser.pur_opt_in_mail_checkbox.checked.should == "false"
    @browser.pur_address_book_button.get("disabled")
    @browser.pur_add_address_button.get("disabled")
    @browser.pur_opt_in_mail_checkbox.checked = "true"
    @browser.pur_address_book_button.click
    # Retries until @browser.pur_address_list.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_address_list.is_visible == false})
    @browser.pur_address_list.is_visible.should be_true
    sleep 3
    @browser.pur_address_list.length.should == 2
    selected_address = @browser.pur_address_list.at(1).pur_saved_address_label.inner_text
    @browser.pur_address_list.at(1).pur_select_address_button.click
    # Retries until @browser.popup_address_panel.is_visible is false
    @browser.retry_until_found(lambda{@browser.popup_address_panel.exists == true}, 30, 0.5, 5){
      @browser.popup_address_panel.exists.should be_false
    }
    @browser.pur_address_label.inner_text.should == selected_address
    @browser.communications_update_button.click
    # Retries until @browser.pur_communications_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_communications_success_label.is_visible == false})
    @browser.pur_communications_success_label.is_visible.should be_true
    @browser.pur_communications_success_label.inner_text.should == "Your information has been saved."

    # Validating selection for communications is saved in the db - QA_ConsolidatedProfile
    results = @db.exec_sql("SELECT pa.PreferencePossibleAnswerID
                          FROM GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
                                JOIN GenesisCorp.dbo.refResource r WITH(NOLOCK)
                                      ON pq.ResourceID = r.ResourceID
                                JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
                                      ON pq.PreferenceQuestionID = pa.PreferenceQuestionID
                          WHERE pa.CustomerID in (SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = '#{@enrolled_email}')
                          and r.ResouceText like 'PreferencesQandA.Q.PreferredContactMethod%'
                          and pa.PreferencePossibleAnswerID = 358")
    results.at(0).PreferencePossibleAnswerID.should == 358

    # Log out
    @browser.profile_logout_link.click
  end

  it "TC68453: CP - Communication Pref - Phone Calls - Saving with Valid phone number" do
    # Login with existing user
    @browser.log_in_link.click
    @browser.login_header_label.is_visible.should be_true
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until @browser.my_account_menu_link.is_visible is true
    @browser.retry_until_found(lambda{@browser.my_account_menu_link.is_visible == false})
    @browser.my_account_menu_link.click
    @browser.personal_info_label.is_visible.should be_true

    # Opting in for Phone communications
    @browser.communications_link.click
    @browser.pur_communications_label.is_visible.should be_true
    @browser.pur_primary_phone_field.get("disabled")
    @browser.pur_opt_in_phone_checkbox.checked = "true"
    @browser.pur_primary_phone_field.value.should == ""
    @browser.pur_primary_phone_field.value = "5555555555"
    @browser.communications_update_button.click
    # Retries until @browser.pur_communications_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_communications_success_label.is_visible == false})
    @browser.pur_communications_success_label.is_visible.should be_true
    @browser.pur_communications_success_label.inner_text.should == "Your information has been saved."
    @browser.pur_primary_phone_field.value.should == ""

    # Validating the contact phone value is updated
    @browser.personal_info_link.click
    @browser.phone_label.inner_text.should == "(555) 555-5555"

    # Validating selection for communications is saved in the db - QA_ConsolidatedProfile
    results = @db.exec_sql("SELECT pa.PreferencePossibleAnswerID
                          FROM GenesisCorp.dbo.PreferenceQuestion pq WITH(NOLOCK)
                                JOIN GenesisCorp.dbo.refResource r WITH(NOLOCK)
                                      ON pq.ResourceID = r.ResourceID
                                JOIN GenesisCorp.dbo.PreferenceAnswer pa WITH(NOLOCK)
                                      ON pq.PreferenceQuestionID = pa.PreferenceQuestionID
                          WHERE pa.CustomerID in (SELECT p.ProfileID FROM Profile.dbo.Profile p WHERE p.EmailAddress = '#{@login}')
                          and r.ResouceText like 'PreferencesQandA.Q.PreferredContactMethod%'
                          and pa.PreferencePossibleAnswerID = 2")
    results.at(0).PreferencePossibleAnswerID.should == 2
    # Validating phone number is saved in the DB - QA_ConsolidatedProfile
    phone_results = @db.exec_sql("SELECT p.PhoneNumber, p.DateModified
                                FROM Profile.dbo.Phone p
                                JOIN Profile.KeyMap.CustomerKey ck
                                ON p.ProfileID = ck.ProfileID
                                JOIN Multipass.dbo.IssuedUser iu
                                ON ck.OpenIDClaimedIdentifier = iu.OpenIDClaimedIdentifier
                                WHERE iu.EmailAddress = '#{@login}'")
    phone_results.at(0).PhoneNumber.should == "5555555555"
    # TODO date timestamp validation for day
    #phone_results.at(0).DateModified.include ==

    # Cleanup for user
    @browser.communications_link.click
    @browser.pur_opt_in_phone_checkbox.checked = "false"
    @browser.communications_update_button.click
    # Retries until @browser.pur_communications_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.pur_communications_success_label.is_visible == false})
    @browser.pur_communications_success_label.is_visible.should be_true

    @browser.personal_info_link.click
    @browser.personal_details_edit_link.click
    @browser.contact_primary_phone_field.value = "5555550000"
    @browser.personal_info_save_button.click
    # Retries until @browser.personal_info_success_label.is_visible is true
    @browser.retry_until_found(lambda{@browser.personal_info_success_label.is_visible == false})
    @browser.personal_info_success_label.is_visible.should be_true
    @browser.profile_logout_link.click
  end

  it "TC66530: CP - Orders - Order lookup options for Activated User" do
    # Login with existing user
    @browser.log_in_link.click
    @browser.login_header_label.is_visible.should be_true
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
    @browser.log_in_button.click
    # Retries until @browser.my_account_menu_link.is_visible is true
    @browser.retry_until_found(lambda{@browser.my_account_menu_link.is_visible == false})
    @browser.my_account_menu_link.click
    @browser.personal_info_label.is_visible.should be_true

    # Go to Orders page
    @browser.orders_link.click
    @browser.orders_header_label.is_visible.should be_true

    # Validate GS.com order history option exists
    @browser.gamestop_orders_image.is_visible.should be_true
    @browser.gamestop_order_history_link.is_visible.should be_true

    # Validate PUR order history
    @browser.pur_orders_image.is_visible.should be_true
    @browser.pur_orders_label.is_visible.should be_true
    @browser.pur_orders_label.inner_text.should == "PowerUpRewards Order History"
    @browser.pur_orders_description_label.inner_text.should == "View recent rewards purchases"
    @browser.card_activity_link.click
    @browser.url.should == "https://qa.gamestop.com/PowerUpRewards/Account/OrderHistory"
    # Log out
    @browser.sign_out_link.click
  end
end

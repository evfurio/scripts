# d-con %QAAUTOMATION_SCRIPTS%\PowerUpRewards\spec\pur_activation_spec.rb --csv %QAAUTOMATION_SCRIPTS%\PowerUpRewards\spec\powerup_rewards_dataset.csv --range TFS68458 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/PowerUpRewards/dsl/src/dsl"
require 'timeout'

$tracer.mode = :on
$tracer.echo = :on

#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

#$tc_desc = $global_functions.desc
#$tc_id = $global_functions.id


describe "Enroll and Activate PUR" do

  before(:all) do
    @browser = WebBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 30_000
    $snapshots.setup(@browser, :all)

    @params = $global_functions.csv
    @loyaltymembership_svc = $global_functions.loyaltymembership_svc

  end

  before(:each) do
    @start_page = "https://qa.gamestop.com/poweruprewards"
    @browser.open(@start_page)

    @browser.activate_link.click
    @browser.pur_activation_label.is_visible.should be_true
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    $tracer.trace("after all")
    @browser.close_all()
  end

  it "should enroll and activate a PUR user" do
    # enrolls user with parameters passed in
    @email, @card_number = @loyaltymembership_svc.enroll_pur_user(@params)

    # Setting variables based on enrolled user
    $tracer.trace("EMAIL: #{@email}")
    $tracer.trace("CARD NUMBER: #{@card_number}")
    sleep 5
    # On the PUR home page, click on the activate link and create an account
    @browser.login_header_label.should_exist
    @browser.create_an_account_button.click
    @browser.create_user_header_label.should_exist
    @browser.create_opt_in_checkbox_label.is_visible.should be_false
    $tracer.trace("Created Email Address: " + @email)
    @browser.create_email_address_field.value = @email
    @browser.create_password_field.value = "T3sting1"
    @browser.confirm_password_field.value = "T3sting1"
    #@browser.email_opt_in_checkbox.click
    @browser.submit_button.click
    sleep 5
    # After account creation the activate page displays
    @browser.activate_pur_header_label.should_exist
    sleep 5
    # Confirm fields only for PUR activated users don't display on Personal Info
    @browser.personal_info_link.click
    @browser.contact_email_field.is_visible.should be_false
    @browser.pur_security_question_selector.is_visible.should be_false
    @browser.pur_security_answer_field.is_visible.should be_false

    # Begin activation process
    @browser.activate_pur_link.click

    # Authenticate the user
    @browser.profile_powerup_rewards_number_field.value = @card_number
    @browser.pur_email_field.value = @email
    @browser.activate_pur_continue_button.click
    sleep 10
    # Activate the user
    @browser.pur_step1_prompt_label.should_exist
    sleep 5
    @browser.pur_security_question_selector.value = "What's your favorite video game of all time?"
    @browser.pur_security_answer_field.value = "Automation"
    @browser.pur_birth_month_selector.value = "April"
    @browser.pur_birth_day_selector.value = "15"
    @browser.pur_birth_year_selector.value = "1980"
    @browser.pur_activate_button.click
    sleep 10
    # User is now activated
    @browser.pur_congrats_label.is_visible.should be_true
    sleep 5

    # Validate PUR fields display on Personal Info now that the user is activated
    @browser.contact_email_field.value.should == @email
    @browser.pur_security_question_selector.value.should == "What's your favorite video game of all time?"
    sleep 10
    # TODO : Research to see if we can validate masked fields for values.  Not the actual value, just that something is there.
    @browser.pur_security_answer_field.should exist
    @browser.birth_month_selector.value.should == "April"
    @browser.birth_day_selector.value.should == "15"

    # Logout
    @browser.profile_logout_link.click
  end

end

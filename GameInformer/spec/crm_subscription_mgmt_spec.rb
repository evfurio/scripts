#USAGE NOTES#
# this script is for the Subscription Management page
# all methods are associated with a manual test case in MTM
# GameInformer project/Regression Tests plan

#d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\crm_subscription_mgmt_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_crm_dataset.csv --range TFS# --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_CRM --browser chrome --or -e "method name"
#Current TFS Numbers:  TFS42171QA, TFS58913QA, TFS61595QA

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameInformer/dsl/src/dsl"

#New global functions for datasets
$tracer.mode = :on
$tracer.echo = :on
$global_functions = GlobalFunctions.new()

# NOTE
# If you are using test id and test description to run specific tests, you can use the below to load.
# If you have several test methods this is not ideal.
$tc_desc = $global_functions.desc
$tc_id = $global_functions.id



describe "CRM Subscription Management" do

  before(:all) do
    $options.default_timeout = 30_000

    $browser = WebBrowser.new(browser_type_parameter)
    $snapshots.setup($browser, :all)
	  WebBrowser.delete_temporary_internet_files(browser_type_parameter)

    #@start_page = "http://qa.crm.gameinformer.com/"
    #Get the parameters from the csv dataset
    @params = $global_functions.csv
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")

    $SubSearchSubNum = @params['SubSearchSubNum']
    $SubSearchLastName = @params['SubSearchLastName']
  end
	
  before(:each) do
    $browser.open(@start_page)
    $browser.cookie.all.delete

    $username = @params['login']
    $password = @params['password']
    $browser.login_user_crm($username, $password)

  end

  after(:each) do
    $browser.log_off_link.click
  end

  after(:all) do
    $browser.close_all()
  end

   it "should validate Subscriber Search page" do

	  # Check for the Log off link
	  $browser.log_off_link.should_exist
	
	  # Check the fields.
	  $browser.card_num_field.should_exist
	  $browser.subscriber_num_field.should_exist
	  $browser.email_field.should_exist
	  $browser.last_name_field.should_exist
	  $browser.first_name_field.should_exist
	  $browser.address_one_field.should_exist
	  $browser.city_field.should_exist
	  $browser.zip_field.should_exist
	  $browser.phone_field.should_exist

	  # Check the buttons
	  $browser.subscriber_clear_button.should_exist
	  $browser.subscriber_search_button.should_exist
	  $browser.create_subscriber_button.should_exist
	
	  # Check the column headers
    $browser.name_column.should_exist
    $browser.email_column.should_exist
    $browser.phone_column.should_exist
    $browser.address_column.should_exist
    $browser.zip_code_column.should_exist
    $browser.subscriber_num_column.should_exist


    # Check the  menu options.
    # Check for Subscribers Droplist items.
    $browser.create_subscriber_menu_list.at(1).innerText.strip.should == "Subscriber Search"
    $browser.create_subscriber_menu_list.at(2).innerText.strip.should == "Create Subscriber"

    # Check for Maintenance Droplist items.
    $browser.create_maintenance_menu_list.at(1).innerText.strip.should == "Maintain Code Tables"
    $browser.create_maintenance_menu_list.at(2).innerText.strip.should == "Matching Groups Maintenance"
    $browser.create_maintenance_menu_list.at(3).innerText.strip.should == "Validation Rule Maintenance"
    $browser.create_maintenance_menu_list.at(4).innerText.strip.should == "NCOA Update"
    $browser.create_maintenance_menu_list.at(5).innerText.strip.should == "Create Subscription Extract"
    $browser.create_maintenance_menu_list.at(6).innerText.strip.should == "First Issue Reassignment"
    $browser.create_maintenance_menu_list.at(7).innerText.strip.should == "Reports"
    $browser.create_maintenance_menu_list.at(8).innerText.strip.should == "Queue"

   end

  it "should validate Subscriber id set as focus" do
    $browser.send_keys($SubSearchSubNum)
    $browser.subscriber_num_field.value.strip.should == $SubSearchSubNum

  end

  it "should validate Subscriber is returned" do
    $browser.last_name_field.value = $SubSearchLastName
    $browser.subscriber_search_button.click
    $browser.subscriber_first_page_retrieved.should_exist
    $browser.subscriber_first_page_retrieved.value.strip.should == "1"
    $browser.subscriber_total_num_pages_retrieved.should_exist
    $browser.subscriber_go_button.should_exist
    $browser.subscriber_next_button.should_exist
    $browser.subscriber_last_button.should_exist


  end


end
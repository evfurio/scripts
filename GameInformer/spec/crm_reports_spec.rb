#USAGE NOTES#
# this script is for the CRM Reports
# all methods are associated with a manual test case in MTM
# GameInformer project/Regression Tests plan

#d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\crm_reports_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_crm_dataset.csv --range TFS# --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_CRM --browser chrome --or -e "method name"
#Current TFS Numbers:  TFS65237QA, TFS65237QA, TFS65248QA, TFS65246QA, TFS65247QA, TFS63501QA, TFS63502QA, TFS63503QA


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameInformer/dsl/src/dsl"


#New global functions for datasets
$tracer.mode = :on
$tracer.echo = :on
$global_functions = GlobalFunctions.new()

# NOTE
# If you are using test id and test description to run specific tests, you can use the below to load.
# If you have several test methods this is not ideal.
#$tc_desc = $global_functions.desc
#$tc_id = $global_functions.id



describe "CRM Reports" do

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


    $scorecardReport = @params['ScoreCardTitle']
    $subscriptionTitleId = @params['SalesbyStateSubTitleId']
    $startIssue = @params['ScoreCardStartIssue']
    $startdate = @params['ReportDateStartRange']
    $enddate = @params['ReportDateEndRange']
    $subMonth = @params['SalesbyZipMonth']
    $subYear = @params['SalesbyZipYear']
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

  # Declare variables for this test:
  #$scorecardReport = "Game Informer [Digital]"
  #$subscriptionTitleId = "Game Informer [Print]"
  #$startIssue = "2011 Aug [8]"
  #$startdate = "12/10/2010"
  #$enddate = "12/10/2013"
  #$subMonth = "June"
  #$subYear = "2012"




  it "should select Reports from dropdown" do
    $browser.create_maintenance_menu_list.at(7).innerText.strip.should == "Reports"
    $browser.create_maintenance_menu_list.at(7).click
  end

  it "should verify Reports page" do
    $browser.create_maintenance_menu_list.at(7).click
    $browser.report_label.should_exist
    $browser.report_label.innerText.strip.should == "Reports"

    $browser.score_card_report_link.should_exist
    $browser.sales_by_state_report_link.should_exist
    $browser.sales_by_zip_report_link.should_exist
    $browser.ten_day_paid_sales_report_link.should_exist
    $browser.store9850_sales_by_state_report_link.should_exist
    $browser.store9850_sales_by_city_report_link.should_exist
  end
  
  it "should verify the Score Card Report" do
    $browser.create_maintenance_menu_list.at(7).click
    $browser.score_card_report_link.click
    $browser.score_card_report_label.should_exist
    #A messagebox sometimes appears here.
    $browser.title_id_selector.value = $scorecardReport
    $browser.start_issue_selector.value = $startIssue
    $browser.execute_report_button.click
    $browser.report_column_details.should_exist
    $browser.download_report_link.should_exist
    $browser.download_report_link.click
  end

  it "should verify Sales by State Report" do
    $browser.create_maintenance_menu_list.at(7).click
    $browser.sales_by_state_report_link.click
    $browser.sales_by_state_report_label.should_exist
    $browser.title_id_selector.value = $subscriptionTitleId
    $browser.execute_report_button.click
    $browser.report_column_details.should_exist
    $browser.download_report_link.should_exist
    $browser.download_report_link.click
  end

  it "should verify Sales by Zip Report" do
    $browser.create_maintenance_menu_list.at(7).click
    $browser.sales_by_zip_report_link.click
    $browser.sales_by_zip_report_label.should_exist
    $browser.execute_report_button.click
    $browser.report_column_details.should_exist
    $browser.download_report_link.should_exist
    $browser.download_report_link.click
  end

  it "should verify Ten Day Paid Sales Report" do
    $browser.create_maintenance_menu_list.at(7).click
    $browser.ten_day_paid_sales_report_link.click
    $browser.ten_day_paid_sales_report_label.should_exist
    $browser.execute_report_button.click
    $browser.report_column_details.should_exist
    $browser.download_report_link.should_exist
    $browser.download_report_link.click
  end


   it "should verify 9850 Sales by State Report" do
    $browser.create_maintenance_menu_list.at(7).click
    $browser.store9850_sales_by_state_report_link.click
    $browser.store9850_sales_by_state_report_label.should_exist
    $browser.start_date_picker_field.value = $startdate
    $browser.end_date_picker_field.value = $enddate
    $browser.execute_report_button.click
    $browser.report_column_details.should_exist
    $browser.report_column_details.should_exist
    $browser.download_report_link.should_exist
    $browser.download_report_link.click
   end

  it "should verify 9850 Sales by City Report" do
   $browser.create_maintenance_menu_list.at(7).click
   $browser.store9850_sales_by_city_report_link.click
   $browser.store9850_sales_by_city_report_label.should_exist
   $browser.start_date_picker_field.value = $startdate
   $browser.end_date_picker_field.value = $enddate
   $browser.execute_report_button.click
   $browser.report_column_details.should_exist
   $browser.report_column_details.should_exist
   $browser.download_report_link.should_exist
   $browser.download_report_link.click
  end

end
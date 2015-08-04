## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\mgs_qualtrics_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\mobile_dataset.csv  --range TFS74661  --browser chrome -e 'mgs qualtrics in weekly ad' --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "GS Mobile Qualtrics" do

  before(:all) do
    if browser_type_parameter == "chrome"
      @browser = WebBrowser.new(browser_type_parameter, true)
    else
      @browser = WebBrowser.new(browser_type_parameter)
    end
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 10_000
    $snapshots.setup(@browser, :all)

    #Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
  end

  before(:each) do
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "mgs qualtrics in weekly ad" do
    @browser.open(@start_page)
    @browser.mgs_weekly_ad_link.click
		@browser.wait_for_landing_page_load
    @browser.mgs_feedback_link.click
    @browser.wait_for_landing_page_load
		
		@browser.mgs_feedback_modal.should_exist
		qualtrics_script = @browser.mgs_qualtrics_script
		qualtrics_script.innerText.should include "gamestop.siteintercept.qualtrics.com"
    $tracer.report("Qualtrics Script  :: #{qualtrics_script.innerText}")
		

  end

end
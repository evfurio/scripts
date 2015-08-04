# NOTE: This script is not ready for testing.  Please do not use. #dturner

# d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\GSmobile_sign_on_cookie_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\SSO\single_sign_on_dataset.csv  --range TFS60291  -e 'TFS60291'  --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()
USER_AGENT_STR = "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"

describe "MGS Single Sign-On" do

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

    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
		
    $options.http_proxy = "localhost"
    $options.http_proxy_port = "18252"
    @proxy = ProxyServerManager.new(18252)
    @proxy.start
    @proxy.set_request_header("User-Agent", USER_AGENT_STR)
  end

  before(:each) do
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
    $tc_desc = $global_functions.desc
    $tc_id = $global_functions.id
    $tc_desc = "Test case description was not found" if $tc_desc == "" || $tc_desc == nil
    $tracer.report("Executed Test :#{$tc_id} #{$tc_desc}")
  end

  after(:each) do
    @browser.return_current_url
    @browser.close_all()
  end

  it "TFS60291" do
    @browser.open("#{@start_page}")
    @browser.log_in_link.click
    @browser.wait_for_landing_page_load
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
    @browser.log_in_button.click
    sleep 5
    #check correct cookies at unsecure page
    @browser.validate_cookies(:unsecure_auth_user)
    #go to secure page
    @browser.order_lookup_link.click
    #check correct cookies at secure page
    @browser.validate_cookies(:authenticated_cart)
    @browser.log_out_link.click
    @browser.validate_cookies(:au_cart_no_tickets)
  end

  it "TFS60299" do
    # Go to site and checkout page
    @browser.open("#{@start_page}")
    @browser.view_cart_button.click
    sleep 5
    # Check cookies are correct
    @browser.validate_cookies(:au_cart_no_tickets)
    # Login (authenticated) and go to checkout page
    @browser.log_in_link.click
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
    @browser.log_in_button.click
    @browser.view_cart_button.click
    sleep 5
    # Log out
    @browser.log_out_link.click
    # Check cookies are correct
    @browser.validate_cookies(:au_cart_no_tickets)
  end

end
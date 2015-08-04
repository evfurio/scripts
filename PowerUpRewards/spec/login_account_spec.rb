# d-Con %QAAUTOMATION_SCRIPTS%\PowerUpRewards\spec\login_account_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\SSO\single_sign_on_dataset.csv --range TFS60286 -e 'TFS60286' --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/PowerUpRewards/dsl/src/dsl"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

USER_AGENT_STR = "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"

describe "PowerUpRewards" do

  before(:all) do
	  @browser = WebBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 30_000
    $snapshots.setup(@browser, :all)
		
    #Get the parameters from the csv dataset
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
		
    $options.http_proxy = "localhost"
    $options.http_proxy_port = "14906"
    @proxy = ProxyServerManager.new(14906)
    @proxy.start
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

	# Cookie verification on gamestop.com poweruprewards after Log In
  it "TFS60284" do
    @browser.open("#{@start_page}/PowerUpRewards/home")
    @browser.log_in_link.click
    sleep 5
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
    @browser.log_in_button.click
    sleep 10
    @browser.validate_cookies(:after_login_from_pur)
  end

	# Cookie verification on gamestop.com poweruprewards after Log Out
	it "TFS60285" do
    @browser.open("#{@start_page}/PowerUpRewards/home")
    @browser.log_in_link.click
    sleep 5
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
    @browser.log_in_button.click
    sleep 10
    @browser.validate_cookies(:after_login_from_pur)
    @browser.sign_out_link.click
    @browser.log_in_link.should_exist
    @browser.validate_cookies(:after_logout_from_pur)
  end
	
	# Cookie verification on m.gamestop.com poweruprewards after Log In
  it "TFS60286" do
    $tracer.report("User agent used : #{USER_AGENT_STR}")
    @proxy.set_request_header("User-Agent", USER_AGENT_STR)
    @browser.open("#{@start_page}/PowerUpRewards/home")

    # This is temporary. Need to know where the new finders for Mobile PUR should be placed.
		@browser.a.className("/login/").click

    sleep 5
    @browser.email_address_field.value = @login
    @browser.password_field.value = @password
    @browser.log_in_button.click
    sleep 10
    @browser.validate_cookies(:after_login_from_pur)

  end

end



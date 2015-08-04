# This is a base template to construct new UI based scripts from.
# USAGE NOTES
### d-Con %QAAUTOMATION_SCRIPTS%\Monitoring\spec\proxy_user_agent_spec.rb --csv %QAAUTOMATION_SCRIPTS%\Monitoring\spec\monitor_dataset.csv --range WatchDogGSUI --env QA --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$options.http_proxy = "localhost"
$options.http_proxy_port = "9091"
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
USER_AGENT_STR = "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25"

describe "GameStop QA Monitoring Solution" do

  before(:all) do
    @browser_type = $global_functions.get_browser_type
    @browser = WebBrowser.new(@browser_type)
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @env = $global_functions.get_env
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
    $proxy = @browser.start_proxy_server(9091)
  end

  before(:each) do
    $proxy.started? == true
  end

  after(:each) do
    @browser.stop_proxy_server($proxy) if $proxy.started? == true
  end

  it "#{$tc_id} : #{$tc_desc}" do
    # TODO : Profile, Checkout and PowerUp Rewards are their own applications.
    $tracer.trace("Environment to be used #{@env}")
    dir = ["/", "/browse", "/browse/storesearch.aspx", "/gift-cards", "/browse?nav=28-xu0", "/weeklyad", "/poweruprewards"]
    port = "9091"

    @browser.set_capture_content($proxy, false)
    @browser.set_capture_headers($proxy, true)
    @browser.set_user_agent_header($proxy, USER_AGENT_STR)
    @browser.start_capture($proxy)
    @browser.open("http://qa.gamestop.com")
    @browser.refresh_page
    @browser.stop_capture($proxy)

    #sleep(1) until $proxy.started? == false

    recording = @browser.get_capture($proxy)
    #@browser.verify_game_stop_dot_com_is_alive(@params, dir, @env)

    # locate 'User-Agent' header
    header_found = false
    recording.log.entries.each do |e|
      # NOTE: ie for some reason differs.. it uses referer as url instead of url, therefore we look for ajax
      if e.request.exists && (e.request.url.content.include?("qa.gamestop.com"))
        e.request.headers.each do |h|
          if h.name.content.eql?("User-Agent")
            header_found = true
            h.value.content.should == USER_AGENT_STR
          end
        end
      end
    end

    unless header_found
      raise Exception, "'User-Agent' header not found"
    end

    @browser.stop_proxy_server($proxy)

  end

end
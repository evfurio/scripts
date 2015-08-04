# This is a base template to construct new UI based scripts from.
# USAGE NOTES
### d-Con %QAAUTOMATION_SCRIPTS%\Monitoring\spec\monitor_gamestop_spec.rb --csv %QAAUTOMATION_SCRIPTS%\Monitoring\spec\monitor_dataset.csv --range WatchDogGSUI --env QA --browser phantomjs --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"
#HTTPI.log_level = :info
#HTTPI.log = false

$tracer.mode=:on
$tracer.echo=:on
$options.http_proxy = "localhost"
$options.http_proxy_port = "9091"
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "GameStop QA Monitoring Solution" do

  before(:all) do
    @browser_type = $global_functions.get_browser_type
    @browser = WebBrowser.new(@browser_type)
    @params = $global_functions.csv
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @env = $global_functions.get_env
  end

  it "#{$tc_id} : #{$tc_desc}" do
    # TODO : Profile, Checkout and PowerUp Rewards are their own applications.
    $tracer.trace("Environment to be used #{@env}")
    dir = ["/", "/browse", "/browse/storesearch.aspx", "/gift-cards", "/browse?nav=28-xu0", "/weeklyad", "/poweruprewards"]
    @browser.verify_game_stop_dot_com_is_alive(@params, dir, @env)
  end

end
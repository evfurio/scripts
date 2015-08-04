#USAGE NOTES#
#proxy spec tutorial
#d-Con %QAAUTOMATION_SCRIPTS%\tutorials\advanced\useragent_mapping_spec.rb --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "proxy basic" do

  before(:all) do
    $tracer.mode=:on
		$tracer.echo=:on

    #Set proxy for the web driver
    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9091"

    $tracer.trace("STEP 1: This is before all")
    $proxy = ProxyServerManager.new(9091)
    $browser = WebBrowser.new("chrome")
  end

  before(:each) do
    $tracer.trace("STEP 2: This is before each")
    $proxy.inspect
    $proxy.start
    $proxy.set_request_header("User-Agent", "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25")
    sleep 5
  end

  after(:each) do
    $proxy.stop
    $tracer.trace("STEP 4: This is after each")
  end

  after(:all) do
    $tracer.trace("STEP 5: This is after all")
    $browser.close
  end

	it "proxy test function" do
    $browser.open("http://qa.gamestop.com")
    $tracer.trace("STEP 3: You made it to the test function")
    $proxy.start_capture
    $browser.open("https://qa.gamestop.com/checkout")
  # $proxy.set_dns_remap("localhost", "127.0.0.1") # NOTE: when using localhost, you must remap to 127.0.0.1 (why??)

  # this open will not show up in our captures, since stop_capture was called, and never re-started


    json_dot_object = $proxy.get_capture
    $tracer.trace(json_dot_object.formatted_json)

  # should contain two pages
    json_dot_object.log.pages.length.should == 1

  # should be two requests and two responses per page
    entries_list = json_dot_object.log.entries
	end

end
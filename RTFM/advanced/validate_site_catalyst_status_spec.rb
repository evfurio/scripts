#USAGE NOTES#
#proxy spec tutorial
#d-Con %QAAUTOMATION_SCRIPTS%\RTFM\advanced\validate_site_catalyst_status_spec.rb --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "proxy basic" do

  before(:all) do
    $tracer.mode=:on
		$tracer.echo=:on

    #Set proxy for the web driver
    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9091"

    $proxy = ProxyServerManager.new(9091)
    $browser = GameStopBrowser.new("chrome")
		@start_page = "http://qa.gamestop.com"
  end

  before(:each) do
    $proxy.inspect
    $proxy.start
    sleep 5
  end

  after(:each) do
    $proxy.stop
  end

  after(:all) do
    $browser.close
  end

	it "validate SiteCatalyst Response Status" do
    $proxy.start_capture(true)
		$browser.open(@start_page)
		capture_data = $proxy.get_capture

    #replace @start_page with current_url
    url = $browser.return_current_url
    get_request_from_url((capture_data), url)
	end

  def get_request_from_url(capture_data, url, page = nil, requested_query_string_array = nil)
    entries_list = capture_data.log.entries
    $tracer.trace(entries_list)
    unless entries_list.length > 0
      raise Exception, "no 'entries' found to test"
    end

    entries_list.each do |e|
			if e.request.exists && e.request.url.content.include?("sitecatalyst") && (page.nil? || e.pageref.content.downcase == page.downcase)
        Struct.new("QueryStringData", :page, :url, :query_string_hash)
        record = Struct::QueryStringData.new(nil, nil, {})
				$tracer.report("PageRef :: #{e.pageref.content}")
				$tracer.report("URL :: #{e.request.url.content}")
				$tracer.report("Status :: #{e.response.status.content}")
				$tracer.report("Status Text :: #{e.response.status_text.content}")
				
				#Assert STATUS and Status Test
				e.response.status.content.should == 200
				e.response.status_text.content.should == "OK"
      end
    end
  end


end
#USAGE NOTES#
#proxy spec tutorial
#d-Con %QAAUTOMATION_SCRIPTS%\tutorials\advanced\enable_http_capture_spec.rb --or

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
    $browser = GameStopBrowser.new("chrome")
  end

  before(:each) do
    $tracer.trace("STEP 2: This is before each")
    $proxy.inspect
    $proxy.start
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
    $tracer.trace("STEP 3: You made it to the test function")
    $proxy.start_capture
	 
    $proxy.start_capture(true)
  # $proxy.set_dns_remap("localhost", "127.0.0.1") # NOTE: when using localhost, you must remap to 127.0.0.1 (why??)
  # $proxy.set_request_header("User-Agent", "Mozilla/5.0 (iPad; CPU OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5355d Safari/8536.25")

  # this open will not show up in our captures, since stop_capture was called, and never re-started
    $browser.open("http://qa.gamestop.com")

    capture_data = $proxy.get_capture
    #$tracer.trace(capture_data.formatted_json)
    omniture_list = @browser.get_request_from_url((capture_data), "SiteCatalystMainSiteEvents.js")
    @browser.trace_request_query_strings(omniture_list)

  # should contain two pages
    capture_data.log.pages.length.should == 1

  # should be two requests and two responses per page
    entries_list = capture_data.log.entries
	end

  # Given a capture data dot object (returned from a proxy) and a URL, an array is returned containing a list of omniture
  # request query strings for each page found for this specified URL.  The return type is a Ruby array containing a Ruby
  # Struct of "page", "url" and "query_string_hash".
  # === Paramaters:
  # _capture_data_:: capture data from a ProxyServerManager get_capture call.  (dot object)
  # _url_:: URL string in which to return request query strings for.
  #         NOTE: the match uses include? so the string may be a partial URL.
  # _page_:: the capture data page to be returned, in the form of "Page #".  NOTE: The capture data returned from the
  #          get_capture call may have multiple pages.  Default: all pages returned if page is not specified.
  # _requested_query_sring_array_:: an array of query string names in which to be returned:  Default: all query strings returned.
  def get_request_from_url(capture_data, url, page = nil, requested_query_string_array = nil)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    list = []

    entries_list = capture_data.log.entries

    unless entries_list.length > 0
      raise Exception, "no 'entries' found to test"
    end

    entries_list.each do |e|
      if e.request.exists && e.request.url.content.include?("SiteCatalystMainSiteEvents") && (page.nil? || e.pageref.content.downcase == page.downcase)
        Struct.new("QueryStringData", :page, :url, :query_string_hash)
        record = Struct::OmnitureQueryStringData.new(nil, nil, {})

        record.page = e.pageref.content
        record.url = e.request.url.content

        query_string_list = e.request.query_string
        query_string_list.each do |item|
          if requested_query_string_array.nil? || requested_query_string_array.include?(item.name.content)
            record.query_string_hash[item.name.content] = item.value.content
          end
        end

        list << record
      end
    end

    return list
  end

  # Given a omniture query string array from a call to get_omniture_request_query_strings_for_url(), trace statementes will be output
  # to the trace file in a standarized way, displaying each of the query strings as well as the page number from the capture, plus the
  # full url.
  # === Parameters:
  # _query_string_array_:: Ruby Array of Struct::QueryStringData, generated from the call to get_omniture_request_query_strings_for_url
  def trace_request_query_strings(query_string_array)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    query_string_array.each do |rec|
      if rec.class.eql?(Struct::QueryStringData)
        $tracer.trace("#{rec.page} => url: #{rec.url}")
        $tracer.trace("#{rec.page} => status: #{rec.status}")
        rec.query_string_hash.each do |k, v|
          $tracer.trace("\t#{k}: #{v}")
        end
      else
        raise Exception, "omniture query string array data must be from get_omniture_request_query_strings_for_url() call"
      end
    end
    return http_status
  end

  def validate_http_response_code(http_status, http_status_validations)
    #iterate through an array of http status codes to ensure they're all 200

  end


end
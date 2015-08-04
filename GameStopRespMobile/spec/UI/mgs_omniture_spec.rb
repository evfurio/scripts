# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_omniture_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range TFS96873 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopRespMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
$tracer.trace("THIS IS TEST DESC #{$tc_desc} \nTHIS IS TEST ID #{$tc_id}")

describe "omniture" do

  before(:all) do
		#Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
    @shipping_svc, @shipping_svc_version = $global_functions.shipping_svc
		
		$options.http_proxy = "localhost"
    $options.http_proxy_port = "9091"

    $proxy = ProxyServerManager.new(9091)
		
		@browser = WebBrowser.new(browser_type_parameter, true)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 10_000
    $snapshots.setup(@browser, :all)

    # Get the size, view and user agent of the device
    @device, device_width, device_heigth, @device_user_agent = @browser.get_user_agent_and_device_size(@params)
    $tracer.trace("DEVICE SIZE - W: #{device_width}, H: #{device_heigth}")
    @browser.set_size(device_width, device_heigth)
  end

  before(:each) do
		$proxy.inspect
    $proxy.start
    sleep 5
		
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
  end

  after(:each) do
		$proxy.stop
    @browser.return_current_url
  end

  after(:all) do
		@browser.close_all()
  end

  it "Homepage: Get omniture value for Channel" do
		$proxy.start_capture
		@browser.open("#{@start_page}")
		capture_data = $proxy.get_capture
		# $tracer.trace(capture_data.formatted_json)
    home_page = @browser.url_data.full_url
		# ch is channel in json response
    query_string_name = "ch"
		omniture_list = get_omniture_request_query_strings_for_url(capture_data)
		query_string_value  = get_value_from_query_strings(omniture_list, home_page, query_string_name)
		# Validate if the channel value is homepage
		query_string_value.should == "homepage"
		$tracer.report("Query String Value = #{query_string_value}")
	end

	# This is already in analytics dsl. You may use this instead of adding the dsl in mgs requires. I also removed the url in the param.
	def get_omniture_request_query_strings_for_url(capture_data, page = nil, requested_query_string_array = nil)
		list = []
		entries_list = capture_data.log.entries
		unless entries_list.length > 0
			raise Exception, "no 'entries' found to test"
		end
		entries_list.each do |e|
			if e.request.exists && e.request.url.content.include?("metrics.gamestop.com") && (page.nil? || e.pageref.content.downcase == page.downcase)
				Struct.new("OmnitureQueryStringData", :page, :url, :query_string_hash)
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

	# This is for getting the omniture value.
	def get_value_from_query_strings(omniture_query_string_array, url, query_name)
		omniture_query_string_array.each do |rec|
			if rec.query_string_hash["g"].include?(url)
				$tracer.trace("#{rec.page} => url: #{rec.url}")
				rec.query_string_hash.each do |k, v|
					$tracer.trace("\t#{k}: #{v}")
					@query_value = rec.query_string_hash[query_name]
				end
			end
		end
		return @query_value
	end

end
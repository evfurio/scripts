# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_omniture_footers_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range header001 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopRespMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
$tracer.trace("THIS IS TEST DESC #{$tc_desc} \nTHIS IS TEST ID #{$tc_id}")

describe "MGS NextGen Omniture Footer Links Behavior" do

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

		@browser.delete_all_cookies_and_verify
		$proxy.inspect
		$proxy.start
		sleep 5
    $has_run = false
  end

  before(:each) do
    @session_id = generate_guid
  end

  after(:each) do
    @browser.return_current_url
  end

	after(:all) do
		$proxy.stop
		@browser.close_all()

		if $has_run == false
			warn("
			\r\n**********************************************************************
      \r\n  VALIDATING OMNITURE VALUES FOR PHONES AND TABLETS HAVE BEEN SKIPPED.
      \r\n  Kindly check run configurations.
      \r\n  Device = #{@device}
			\r\n**********************************************************************
      ")

			raise SystemExit
		end
  end

	it "#{$tc_id} #{$tc_desc}" do
		$proxy.set_request_header("User-Agent", @device_user_agent)

		# Check if user is Authenticated or Guest
		is_guest_user = false
		unless @params['login'] == ""
			@open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
			@cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
			@cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)

			@browser.open("#{@start_page}")
			sleep 2

			### TODO: Validation for Tablet and Phone for Login
			if @device.upcase.strip == "PHONE"
				@browser.mgs_hdr_mobile_hamburger.click
				@browser.mgs_hdr_mobmnu_signin_lnk.click
			else
				@browser.mgs_hdr_tabmnu_signin_section.click
				@browser.mgs_hdr_tabmnu_signin_btn.click
			end
			### TODO: Move this to dsl
			@browser.wait_for_landing_page_load
			@browser.email_address_field.value = @login
			@browser.password_field.value = @password
			@browser.log_in_button.click
			sleep 5
		else
			@browser.open("#{@start_page}")
			is_guest_user = true
		end
	end


	it "Mobile Omniture footers link validation for tablets" do
		if @device.upcase.strip == "TABLET"
			$has_run = true
			$proxy.start_capture
			@browser.open("#{@start_page}")

			$tracer.report("===== >>>>> Navigate footer links.")
			@browser.mgs_ftr_about_lnk.click if @browser.mgs_ftr_about_lnk.exists == true
			sleep 2
			@browser.mgs_browser_title == "About | GameStop"
			@browser.url_data.full_url.should == "#{@start_page}/pages/about"
			about_page = @browser.url_data.full_url

			@browser.mgs_ftr_privpolicy_lnk.click if @browser.mgs_ftr_privpolicy_lnk.exists == true
			sleep 2
			@browser.mgs_browser_title == "Privacy Policy | GameStop"
			@browser.url_data.full_url.should == "#{@start_page}/pages/privacypolicy"
			sleep 2
			privpol_page = @browser.url_data.full_url

			@browser.mgs_ftr_condition_lnk.click if @browser.mgs_ftr_condition_lnk.exists == true
			@browser.mgs_browser_title == "Condition Of Use | GameStop"
			@browser.url_data.full_url.should == "#{@start_page}/pages/conditionsofuse"
			sleep 2
			cou_page = @browser.url_data.full_url

			@browser.mgs_ftr_feedback_lnk.click if @browser.mgs_ftr_feedback_lnk.exists == true
			@browser.mgs_browser_title == "Feedback | GameStop"
			@browser.url_data.full_url.should == "#{@start_page}/Pages/Feedback"
			sleep 2
			feedback_page = @browser.url_data.full_url

			@browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
			@browser.mgs_browser_title.to_s.include?("Video Games for Xbox One, PS4, Wii U, PC, Xbox 360, PS3 & 3DS | GameStop")
			@browser.url_data.full_url.to_s.include?(".gamestop.com/")
			sleep 2
			fullsite_page = @browser.url_data.full_url

			$tracer.report("===== >>>>> Validate contact footer link has been removed.")
			@browser.mgs_ftr_contact_lnk.exists == false


			$tracer.report("===== >>>>> Validate of json conversion variables.")
			capture_data = $proxy.get_capture
			query_string_name = "v8"
			omniture_list = get_omniture_request_query_strings_for_url(capture_data)
			query_string_value  = get_value_from_query_strings(omniture_list, about_page, query_string_name)
			query_string_value.should == "tabletfooter|about"
			$tracer.report("Query String Value = #{query_string_value}")

			omniture_list = get_omniture_request_query_strings_for_url(capture_data)
			query_string_value  = get_value_from_query_strings(omniture_list, privpol_page, query_string_name)
			query_string_value.should == "tabletfooter|privacy policy"
			$tracer.report("Query String Value = #{query_string_value}")

			omniture_list = get_omniture_request_query_strings_for_url(capture_data)
			query_string_value  = get_value_from_query_strings(omniture_list, cou_page, query_string_name)
			query_string_value.should == "tabletfooter|conditions of use"
			$tracer.report("Query String Value = #{query_string_value}")

			omniture_list = get_omniture_request_query_strings_for_url(capture_data)
			query_string_value  = get_value_from_query_strings(omniture_list, feedback_page, query_string_name)
			query_string_value.should == "tabletfooter|feedback"
			$tracer.report("Query String Value = #{query_string_value}")

			omniture_list = get_omniture_request_query_strings_for_url(capture_data)
			query_string_value  = get_value_from_query_strings(omniture_list, fullsite_page, query_string_name)
			query_string_value.should == "tabletfooter|full site"
			$tracer.report("Query String Value = #{query_string_value}")
		else
			$tracer.trace("
			\r\n===============================================================
      \r\nValidating json conversion values for tablets has been skipped.
      \r\nDevice = #{@device}
			\r\n===============================================================
      ")
    end
  end

	it "Mobile Omniture footers link validation for phones" do
		if @device.upcase.strip == "PHONE"
			$has_run = true
			$proxy.start_capture
			@browser.open("#{@start_page}/browse")

			$tracer.report("===== >>>>> Navigate footer links.")
			@browser.mgs_ftr_about_lnk.click if @browser.mgs_ftr_about_lnk.exists == true
			sleep 2
			@browser.mgs_browser_title == "About | GameStop"
			@browser.url_data.full_url.should == "#{@start_page}/pages/about"
			about_page = @browser.url_data.full_url

			@browser.mgs_ftr_privpolicy_lnk.click if @browser.mgs_ftr_privpolicy_lnk.exists == true
			sleep 2
			@browser.mgs_browser_title == "Privacy Policy | GameStop"
			@browser.url_data.full_url.should == "#{@start_page}/pages/privacypolicy"
			sleep 2
			privpol_page = @browser.url_data.full_url

			@browser.mgs_ftr_condition_lnk.click if @browser.mgs_ftr_condition_lnk.exists == true
			@browser.mgs_browser_title == "Condition Of Use | GameStop"
			@browser.url_data.full_url.should == "#{@start_page}/pages/conditionsofuse"
			sleep 2
			cou_page = @browser.url_data.full_url

			@browser.mgs_ftr_feedback_lnk.click if @browser.mgs_ftr_feedback_lnk.exists == true
			@browser.mgs_browser_title == "Feedback | GameStop"
			@browser.url_data.full_url.should == "#{@start_page}/Pages/Feedback"
			sleep 2
			feedback_page = @browser.url_data.full_url

			@browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
			@browser.mgs_browser_title.to_s.include?("Video Games for Xbox One, PS4, Wii U, PC, Xbox 360, PS3 & 3DS | GameStop")
			@browser.url_data.full_url.to_s.include?(".gamestop.com/")
			sleep 2
			fullsite_page = @browser.url_data.full_url

			$tracer.report("===== >>>>> Validate contact footer link has been removed.")
			@browser.mgs_ftr_contact_lnk.exists == false


			$tracer.report("===== >>>>> Validation of json conversion variables.")
			capture_data = $proxy.get_capture
			query_string_name = "v8"
			omniture_list = get_omniture_request_query_strings_for_url(capture_data)
			query_string_value  = get_value_from_query_strings(omniture_list, about_page, query_string_name)
			query_string_value.should == "mobilefooter|about"
			$tracer.report("Query String Value = #{query_string_value}")

			omniture_list = get_omniture_request_query_strings_for_url(capture_data)
			query_string_value  = get_value_from_query_strings(omniture_list, privpol_page, query_string_name)
			query_string_value.should == "mobilefooter|privacy policy"
			$tracer.report("Query String Value = #{query_string_value}")

			omniture_list = get_omniture_request_query_strings_for_url(capture_data)
			query_string_value  = get_value_from_query_strings(omniture_list, cou_page, query_string_name)
			query_string_value.should == "mobilefooter|conditions of use"
			$tracer.report("Query String Value = #{query_string_value}")

			omniture_list = get_omniture_request_query_strings_for_url(capture_data)
			query_string_value  = get_value_from_query_strings(omniture_list, feedback_page, query_string_name)
			query_string_value.should == "mobilefooter|feedback"
			$tracer.report("Query String Value = #{query_string_value}")

			omniture_list = get_omniture_request_query_strings_for_url(capture_data)
			query_string_value  = get_value_from_query_strings(omniture_list, fullsite_page, query_string_name)
			query_string_value.should == "mobilefooter|full site"
			$tracer.report("Query String Value = #{query_string_value}")
		else
			$tracer.trace("
			\r\n===============================================================
      \r\nValidating json conversion values for phones has been skipped.
      \r\nDevice = #{@device}
			\r\n===============================================================
      ")
		end
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
### TODO: Template Description of this script
# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_age_gate_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range Age003 --browser chrome --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_age_gate_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range Age004 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopRespMobile/dsl/src/dsl"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
$tracer.trace("THIS IS TEST DESC #{$tc_desc} \nTHIS IS TEST ID #{$tc_id}")

describe "MGS NextGen Age Gate Behavior" do

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

	@first_name = @params['first_name']
	@last_name = @params['last_name']
	@shipping_line1 = @params['shipping_line1']
	@shipping_line2 = @params['shipping_line2']
	@shipping_city = @params['shipping_city']
	@shipping_county = @params['shipping_county']
	@shipping_state = @params['shipping_state']
	@shipping_zip = @params['shipping_zip']
	@shipping_country = @params['shipping_country']
	@shipping_phone = @params['shipping_phone']
	@shipping_email = @params['shipping_email']
	@billing_line1 = @params['billing_line1']
	@billing_line2 = @params['billing_line2']
	@billing_city = @params['billing_city']
	@billing_county = @params['billing_county']
	@billing_state = @params['billing_state']
	@billing_zip = @params['billing_zip']
	@billing_country = @params['billing_country']
	@billing_phone = @params['billing_phone']
	@billing_email = @params['billing_email']
    @product_search_key = @params['search_text']

    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9091"

    $proxy = ProxyServerManager.new(9091)

    @browser = WebBrowser.new(browser_type_parameter, true)
    @browser.delete_internet_files(browser_type_parameter)

    ### TODO: change to 20 and remove wait
    $options.default_timeout = 10_000
    $snapshots.setup(@browser, :all)

    # Get the size, view and user agent of the device
    @device, device_width, device_heigth, @device_user_agent = @browser.get_user_agent_and_device_size(@params)
    $tracer.trace("DEVICE SIZE - W: #{device_width}, H: #{device_heigth}")
    @browser.set_size(device_width, device_heigth)

    @browser.delete_all_cookies_and_verify
    $has_run = false
  end

  before(:each) do
    ### TODO: Move to before all
    $proxy.inspect
    $proxy.start
    sleep 5
    @session_id = generate_guid
  end

  after(:each) do
    ### TODO: move to after all
    $proxy.stop


    @browser.return_current_url
  end

  after(:all) do
    if $has_run == false
      warn("
      \r\n\r\n**********************************************************************
      \r\n\r\n  VALIDATING FULLSITE LINK FOR PHONES AND TABLETS HAVE BEEN SKIPPED.
      \r\n\r\n  Kindly check run configurations.
      \r\n\r\n  Device = #{@device}
      \r\n\r\n**********************************************************************
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
      @browser.wait_for_landing_page_load 

      ### TODO: Validation for Tablet and Phone for Login

      if @device.upcase.strip == "PHONE"
        @browser.mgs_hdr_mobile_hamburger.click
        @browser.mgs_hdr_mobmnu_signin_lnk.click
      else
        @browser.mgs_hdr_tabmnu_signin_menu.click
        @browser.mgs_hdr_tabmnu_signin_btn.click
      end
        ### TODO: Move this to dsl
        @browser.wait_for_landing_page_load
        @browser.email_address_field.value = @login
        @browser.password_field.value = @password
        @browser.user_login_button.click
        sleep 5
    else
      @browser.open("#{@start_page}")
      is_guest_user = true
    end
  end

  it "Mobile age gate validation for mobile" do
    if @device.upcase.strip == "TABLET" || @device.upcase.strip == "PHONE"
      $has_run = true

			$tracer.trace("\r\n\r\n===== >>>>> Add mature item then select under 17.")
			msg_add_mature_content
			if @params['login'] == ""
				@browser.url_data.full_url.to_s.include?("gamestop.com/Checkout/en/Login?continue=True")
				@browser.mgs_buy_as_guest_btn.click
			end
			@browser.url_data.full_url.to_s.include?(".gamestop.com/Checkout/en/AgeGate")
			@browser.div.className("empty_cart").h4.should_not_exist == true
			@browser.wait_for_landing_page_load 

			$tracer.trace("\r\n\r\n===== >>>>> Validate that the Age Gate has been triggered.")
			@browser.mgs_chkout_over_seventeen_btn.innerText.to_s.include?("I Am 17 Years Old")

			$tracer.trace("\r\n\r\n===== >>>>> Select under 17.")
			@browser.mgs_chkout_under_seventeen_btn.click
			@browser.mgs_chkout_cart_info_message.innerText.to_s.include?("The mature-rated items in your cart have been removed.")

			$tracer.trace("\r\n\r\n===== >>>>> Add mature item again then select over 17.")
			msg_add_mature_content
			if @params['login'] == ""
				@browser.url_data.full_url.to_s.include?("gamestop.com/Checkout/en/Login?continue=True")
				@browser.mgs_buy_as_guest_btn.click
			end
			@browser.url_data.full_url.to_s.include?(".gamestop.com/Checkout/en/AgeGate")
			@browser.div.className("empty_cart").h4.should_not_exist == true
			@browser.wait_for_landing_page_load 

			@browser.mgs_chkout_over_seventeen_btn.click
			@browser.url_data.full_url.to_s.include?("gamestop.com/Checkout/en/NextGenShipping")
			@browser.mgs_ship_handling_btn.exists == true

			$tracer.trace("\r\n\r\n===== >>>>> Navigated to NextGenShipping.")
			if @params['login'] == ""
				@browser.mgs_chkout_email_address_field.value = " "
				@browser.mgs_chkout_first_name_field.value = @first_name
				@browser.mgs_chkout_last_name_field.value = @last_name
				@browser.mgs_chkout_email_address_field.value = @shipping_email
				@browser.mgs_chkout_phone_number_field.value = @shipping_phone
				@browser.mgs_chkout_address_1_field.value = @shipping_line1
				@browser.mgs_chkout_address_2_field.value = @shipping_line2
				@browser.mgs_chkout_zip_code_field.value = @shipping_zip
				@browser.mgs_chkout_city_field.value = @shipping_city
				@browser.mgs_chkout_state_select.value = @shipping_state
				@browser.mgs_chkout_same_address_chkbox.checked.eql?(true)
      else
				@browser.mgs_chkout_email_address_field.value != ""
      end

			$tracer.trace("\r\n\r\n===== >>>>> Cycle through the shipping options.")
			@browser.mgs_ship_handling_btn.click
			@browser.mgs_chkout_ship_standard.click
			@browser.mgs_chkout_ship_value.click
			@browser.mgs_chkout_ship_1day.click
			@browser.mgs_chkout_ship_saver.click
			@browser.mgs_chkout_ship_2day.click

		sleep 5
      
		else
			$tracer.trace("
			\r\n\r\n=====================================================
			\r\n\r\nValidating age gate for mobiles has been skipped.
			\r\n\r\nDevice = #{@device}
			\r\n\r\n=====================================================
			")
    end
  end


	def msg_add_mature_content()
		$tracer.trace("\r\n\r\n===== >>>>> Start search.")
		@browser.open("#{@start_page}/browse")
		if @device.upcase.strip == "PHONE"
			@browser.mgs_hdr_mobnav_search_lnk.click
			@browser.mgs_hdr_mobnav_search_input.value = (@product_search_key)
		else
			@browser.mgs_hdr_tabnav_search_input.click
			@browser.mgs_hdr_tabnav_search_input.value = (@product_search_key)
		end	
		@browser.send_keys(KeyCodes::KEY_RETURN)
		@browser.wait_for_landing_page_load 
		
		$tracer.trace("\r\n\r\n===== >>>>> Select a Mature content item")
		@browser.mgs_search_filter_list[0].click
		@browser.wait_for_landing_page_load 

		mgs_search_select_filter_item("Mature")
		mgs_search_select_filter_item("Fighting")

=begin
		@filterItem = ""
		@filterItem = @browser.mgs_search_filter_section.innerHTML.split("</li>").to_a
		@filterItem.each_index do |filter|
			if @filterItem[filter].to_s.include?("Mature")
				@browser.mgs_search_filter_section.a[filter].click
				break
			end
		end
		@browser.wait_for_landing_page_load 

		@filterItem = ""
		@filterItem = @browser.mgs_search_filter_section.innerHTML.split("</li>").to_a
		@filterItem.each_index do |filter|
			if @filterItem[filter].to_s.include?("Fighting")
				@browser.mgs_search_filter_section.a[filter].click
				break
			end
		end
		@browser.wait_for_landing_page_load 
=end


		@browser.mgs_search_filter_btn.click if @device.upcase.strip == "PHONE"
		@browser.wait_for_landing_page_load 
		@browser.mgs_search_product_list[0].a.click
		@browser.wait_for_landing_page_load 

		$tracer.trace("\r\n\r\n===== >>>>> Buy the item.")
		mark = 0
		(0..@browser.mgs_purchaseopt_list.length-1).each do |filter|
			puts "#{@browser.mgs_purchaseopt_list[filter].to_s}"
			if @browser.mgs_purchaseopt_list[filter].innerHTML.to_s.include?("Buy")
				mark = filter
			end
		end
      
		$tracer.trace("\r\n\r\n===== >>>>> Checkout the item")
		@browser.mgs_purchaseopt_list[mark].click
		@browser.wait_for_landing_page_load 
		@browser.mgs_chkout_cart_modal_btn.click
		@browser.wait_for_landing_page_load 
		@browser.url_data.full_url.to_s.include?(".gamestop.com/checkout")
		@browser.mgs_chkout_cart_page_btn.click	

	end

  def mgs_search_select_filter_item(filterPick)
		@filterList = ""
		found = false
		@filterItems = Array.new
		@filterItems = @browser.mgs_search_filter_section.innerHTML.split("</li>").to_a

		@filterItems.each_index do |filter|
			@filterList += "\r\n\r\n " + @filterItems[filter].to_s

			if @filterItems[filter].to_s.include?(filterPick)
				@browser.mgs_search_filter_section.a[filter].click
				@browser.wait_for_landing_page_load
				found = true
				puts ("\r\n\r\n===== >>>>> The desired filter item was selected = #{filterPick}")
				break
			end
		end

		if found == false
			puts ("\r\n\r\n===== >>>>> The desired filter item was NOT selected = #{filterPick}")
		end
		puts ("\r\n\r\n===== >>>>> Filter items = #{@filterList}")
		@filterItems.clear
	end
end


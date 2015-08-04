### TODO: Template Description of this script
# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_footers_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range TFS96873 --browser chrome --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_footers_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range TFS99023 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopRespMobile/dsl/src/dsl"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
$tracer.trace("THIS IS TEST DESC #{$tc_desc} \nTHIS IS TEST ID #{$tc_id}")

describe "MGS NextGen Footer Links" do

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

    ### TODO: change to 20 and remove wait
    $options.default_timeout = 10_000
    $snapshots.setup(@browser, :all)

    # Get the size, view and user agent of the device
    @device, device_width, device_heigth, @device_user_agent = @browser.get_user_agent_and_device_size(@params)
    $tracer.trace("DEVICE SIZE - W: #{device_width}, H: #{device_heigth}")
    @browser.set_size(device_width, device_heigth)

  end

  before(:each) do
    ### TODO: Move to before all
    $proxy.inspect
    $proxy.start
    sleep 5

    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
  end

  after(:each) do
    ### TODO: move to after all
    $proxy.stop


    @browser.return_current_url
  end

  after(:all) do
    #@browser.close_all()
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

      ### TODO: Validation for Tablet and Phone for Login
      if @device.upcase.strip == "PHONE"
        @browser.mgs_hdr_mobile_hamburger.click
        @browser.mgs_hdr_mobmnu_signin_lnk.click
      else
        @browser.mgs_hdr_tab_signin_menu.click
        @browser.mgs_hdr_tab_signin_btn.click
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

    @browser.open("#{@start_page}/browse")

    @browser.mgs_ftr_about_lnk.exists == true
    @browser.mgs_ftr_about_lnk.click
    #@browser.mgs_browser_title == "About | GameStop"
    @browser.mgs_browser_title == "DEAD LINK"
    # @browser.url_data.full_url.should == "#{@start_page}/Pages/About"
    # $tracer.trace("#{@start_page}/Pages/About")
    @browser.browser_back
    @browser.mgs_ftr_about_lnk.exists == true

    @browser.mgs_ftr_privpolicy_lnk.exists == true
    @browser.mgs_ftr_privpolicy_lnk.click
    #@browser.mgs_browser_title == "Privacy Policy | GameStop"
    @browser.mgs_browser_title == "DEAD LINK"
    # @browser.url_data.full_url.should == "#{@start_page}/Pages/PrivacyPolicy"
    # $tracer.trace("#{@start_page}/Pages/PrivacyPolicy")
    @browser.browser_back
    @browser.mgs_ftr_privpolicy_lnk.exists == true


    @browser.mgs_ftr_feedback_lnk.exists == true
    @browser.mgs_ftr_feedback_lnk.click
    #@browser.mgs_browser_title == "Condition Of Use | GameStop"
    @browser.mgs_browser_title == "DEAD LINK"
    # @browser.url_data.full_url.should == "#{@start_page}/Pages/ConditionsofUse"
    # $tracer.trace("#{@start_page}/Pages/ConditionsofUse")
    @browser.browser_back
    @browser.mgs_ftr_feedback_lnk.exists == true


    @browser.mgs_ftr_condition_lnk.exists == true
    @browser.mgs_ftr_condition_lnk.click
    #@browser.mgs_browser_title == "Condition Of Use | GameStop"
    @browser.mgs_browser_title == "DEAD LINK"
    # @browser.url_data.full_url.should == "#{@start_page}/Pages/ConditionsofUse"
    # $tracer.trace("#{@start_page}/Pages/ConditionsofUse")
    @browser.browser_back
    @browser.mgs_ftr_condition_lnk.exists == true


    @browser.mgs_ftr_contact_lnk.exists == true
    @browser.mgs_ftr_contact_lnk.click
    #@browser.mgs_browser_title == "Contact | GameStop"
    @browser.mgs_browser_title == "DEAD LINK"
    # @browser.url_data.full_url.should == "#{@start_page}/Pages/Contact"
    # $tracer.trace("#{@start_page}/Pages/Contact")
    @browser.browser_back
    @browser.mgs_ftr_contact_lnk.exists == true


    @browser.mgs_ftr_fullsite_lnk.exists == true
    @browser.mgs_ftr_fullsite_lnk.click
    @browser.mgs_browser_title.to_s.include? "Video Games for Xbox One, PS4, Wii U, PC, Xbox 360, PS3 & 3DS | GameStop"
    @browser.url_data.full_url.to_s.include? ".gamestop.com/"
    @browser.browser_back
    @browser.mgs_ftr_fullsite_lnk.exists == true

  end

end


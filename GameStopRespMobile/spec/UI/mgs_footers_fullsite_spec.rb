### TODO: Template Description of this script
# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_footers_fullsite_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range header001 --browser chrome --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_footers_fullsite_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range header002 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopRespMobile/dsl/src/dsl"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
$tracer.trace("THIS IS TEST DESC #{$tc_desc} \nTHIS IS TEST ID #{$tc_id}")

describe "MGS NextGen Footer Fullsite Links Behavior" do

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
      \r\n**********************************************************************
      \r\n  VALIDATING FULLSITE LINK FOR PHONES AND TABLETS HAVE BEEN SKIPPED.
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

  it "Mobile fullsite link validation for tablet" do
    if @device.upcase.strip == "TABLET"
      $has_run = true
      $tracer.trace("\r\n===== >>>>> Validating fullsite link from home page.")
      @browser.open("#{@start_page}")
      @mobile_url = @browser.url_data.full_url.to_s
      @browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
      sleep 2
      @browser.url_data.full_url.to_s.eql?("qa.gamestop.com")
      @browser.browser_back
      sleep 2
      @browser.url_data.full_url.to_s.eql?(@mobile_url)
      @browser.mgs_ftr_fullsite_lnk.exists == true

      $tracer.trace("\r\n===== >>>>> Validating fullsite link from search page.")
      @browser.open("#{@start_page}/browse")
      @browser.mgs_hdr_tabnav_search_input.click
      @browser.mgs_hdr_tabnav_search_input.value = (@product_search_key)
      @browser.send_keys(KeyCodes::KEY_RETURN)
      @browser.mgs_search_product_list.at(0).prod_title.to_s.include?(@product_search_key)
      @mobile_url = @browser.url_data.full_url.to_s
      @browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
      sleep 2

      #current desktop finder has className("/^product$/")
      @browser.url_data.full_url.to_s.include? ("qa.gamestop.com/browse?") and (@product_search_key)
      @browser.div.className("products").div.className("/^product/").at(0).to_s.include?(@product_search_key)
      @browser.browser_back
      sleep 2
      @browser.url_data.full_url.to_s.include?(@mobile_url)
      @browser.mgs_ftr_fullsite_lnk.exists == true


      $tracer.trace("\r\n===== >>>>> Validating fullsite link from product page.")
      @browser.mgs_search_product_list.at(0).prod_title.to_s.include?(@product_search_key)
      @browser.mgs_search_product_list.at(0).click
      sleep 2
      @mobile_url = @browser.url_data.full_url.to_s
      @browser.url_data.full_url.to_s.include?("qa.gamestop.com/") and (@product_search_key)
      @browser.mgs_prodzen_label.h1.innerText.to_s.include?(@product_search_key)
      @browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
      sleep 2

      @browser.url_data.full_url.to_s.include? ("qa.gamestop.com/") and (@product_search_key)
      @browser.h1.className("grid_17").innerText.to_s.include?(@product_search_key)
      @browser.browser_back
      sleep 2
      @browser.url_data.full_url.to_s.include?(@mobile_url)
      @browser.mgs_ftr_fullsite_lnk.exists == true

      $tracer.trace("\r\n===== >>>>> Validating fullsite link from pick up at store page.")
      @browser.open("#{@start_page}/browse")
      @browser.mgs_hdr_tabnav_search_input.click
      @browser.mgs_hdr_tabnav_search_input.value = (@product_search_key)
      @browser.send_keys(KeyCodes::KEY_RETURN)
      @browser.mgs_search_product_list.at(0).prod_title.to_s.include?(@product_search_key)
      @mobile_url = @browser.url_data.full_url.to_s
      @browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
      @browser.browser_back
      sleep 2

      @browser.mgs_search_filter_list[0].click
      @myText = @browser.mgs_search_filter_list[0].ul[0].innerHTML.split("<a").to_a
      @myText.delete_at(0)
      @myText.each_index do |filter|
        @browser.mgs_search_filter_list[0].ul[0].li[filter].a.click if @myText[filter].to_s.include?("PickUp@Store")
      end
      sleep 2
      @browser.mgs_search_filter_btn.click
      sleep 2
      @browser.mgs_search_product_list[0].a.click
      sleep 2
      @browser.mgs_shipopt_puas.click
      @browser.url_data.full_url.to_s.include?("http://qa.m2.gamestop.com/PickUpAtStore/")
      @browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
      sleep 2
      @browser.url_data.full_url.to_s.include?("qa.gamestop.com")


      $tracer.trace("\r\n===== >>>>> Validating fullsite link from checkout page.")
      @browser.open("#{@start_page}/browse")
      @browser.mgs_hdr_tabnav_search_input.click
      @browser.mgs_hdr_tabnav_search_input.value = (@product_search_key)
      @browser.send_keys(KeyCodes::KEY_RETURN)
      @browser.mgs_search_product_list[0].a.click
      sleep 2
      mark = 0
      (0..@browser.mgs_purchaseopt_list.length-1).each do |filter|
        puts "#{@browser.mgs_purchaseopt_list[filter].to_s}"
        if @browser.mgs_purchaseopt_list[filter].innerHTML.to_s.include?("Buy")
          mark = filter
        end
      end
      @browser.mgs_purchaseopt_list[mark].click
      sleep 2
      @browser.mgs_cart_modal_chkout_btn.click
      sleep 2
      @browser.url_data.full_url.to_s.include?("qa.m2.gamestop.com/checkout")
      @browser.div.className("empty_cart").h4.should_not_exist == true
      @browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
      @browser.url_data.full_url.to_s.include?("qa.gamestop.com/Checkout")
      @browser.div.className("cartempty").h2.should_not_exist == true
      @browser.mgs_ftr_fullsite_lnk.exists == true
    else
      $tracer.trace("
      \r\n=====================================================
      \r\nValidating fullsite link for tablets has been skipped.
      \r\nDevice = #{@device}
      \r\n=====================================================
      ")
    end
  end


  it "Mobile fullsite link validation for phones" do
    if @device.upcase.strip == "PHONE"
      $has_run = true

      $tracer.trace("\r\n===== >>>>> Validating fullsite link from home page.")
      @browser.open("#{@start_page}")
      @mobile_url = @browser.url_data.full_url.to_s
      @browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
      sleep 2
      @browser.url_data.full_url.to_s.eql?("qa.gamestop.com")
      @browser.browser_back
      sleep 2
      @browser.url_data.full_url.to_s.eql?(@mobile_url)
      @browser.mgs_ftr_fullsite_lnk.exists == true


      $tracer.trace("\r\n===== >>>>> Validating fullsite link from search page.")
      @browser.open("#{@start_page}/browse")
      @browser.mgs_hdr_mobnav_search_lnk.click
      @browser.mgs_hdr_mobnav_search_input.value = (@product_search_key)
      @browser.send_keys(KeyCodes::KEY_RETURN)
      @browser.mgs_search_product_list.at(0).prod_title.to_s.include?(@product_search_key)
      @mobile_url = @browser.url_data.full_url.to_s
      @browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
      sleep 2

      #current desktop finder has className("/^product$/")
      @browser.url_data.full_url.to_s.include? ("qa.gamestop.com/browse?") and (@product_search_key)
      @browser.div.className("products").div.className("/^product/").at(0).to_s.include?(@product_search_key)
      @browser.browser_back
      sleep 2
      @browser.url_data.full_url.to_s.eql?(@mobile_url)
      @browser.mgs_ftr_fullsite_lnk.exists == true


      $tracer.trace("\r\n===== >>>>> Validating fullsite link from product page.")
      @browser.mgs_search_product_list.at(0).prod_title.to_s.include?(@product_search_key)
      @browser.mgs_search_product_list.at(0).click
      sleep 2
      @mobile_url = @browser.url_data.full_url.to_s
      @browser.url_data.full_url.to_s.include?("qa.gamestop.com/") and (@product_search_key)
      @browser.mgs_prodzen_label.h1.innerText.to_s.include?(@product_search_key)
      @browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
      sleep 2

      @browser.url_data.full_url.to_s.include? ("qa.gamestop.com/") and (@product_search_key)
      @browser.h1.className("grid_17").innerText.to_s.include?(@product_search_key)
      @browser.browser_back
      sleep 2
      @browser.url_data.full_url.to_s.eql?(@mobile_url)
      @browser.mgs_ftr_fullsite_lnk.exists == true

      $tracer.trace("\r\n===== >>>>> Validating fullsite link from pick up at store page.")
      @browser.open("#{@start_page}/browse")
      @browser.mgs_hdr_mobnav_search_lnk.click
      @browser.mgs_hdr_mobnav_search_input.value = (@product_search_key)
      @browser.send_keys(KeyCodes::KEY_RETURN)
      @browser.mgs_search_product_list.at(0).prod_title.to_s.include?(@product_search_key)
      @mobile_url = @browser.url_data.full_url.to_s

      @browser.mgs_search_filter_btn.click
      sleep 2
      @browser.mgs_search_filter_list[0].click
      @myText = @browser.mgs_search_filter_list[0].ul[0].innerHTML.split("<a").to_a
      @myText.delete_at(0)
      @myText.each_index do |filter|
        @browser.mgs_search_filter_list[0].ul[0].li[filter].a.click if @myText[filter].to_s.include?("PickUp@Store")
      end
      sleep 2
      @browser.mgs_search_filter_btn.click
      sleep 2
      @browser.mgs_search_product_list[0].a.click
      sleep 2
      @browser.mgs_shipopt_puas.click
      @browser.url_data.full_url.to_s.include?("http://qa.m2.gamestop.com/PickUpAtStore/")
      @browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
      sleep 2
      @browser.url_data.full_url.to_s.include?("qa.gamestop.com")


      $tracer.trace("\r\n===== >>>>> Validating fullsite link from checkout page.")
      @browser.open("#{@start_page}/browse")
      @browser.mgs_hdr_mobnav_search_lnk.click
      @browser.mgs_hdr_mobnav_search_input.value = (@product_search_key)
      @browser.send_keys(KeyCodes::KEY_RETURN)
      @browser.mgs_search_product_list[0].a.click
      sleep 2
      mark = 0
      (0..@browser.mgs_purchaseopt_list.length-1).each do |filter|
        puts "#{@browser.mgs_purchaseopt_list[filter].to_s}"
        if @browser.mgs_purchaseopt_list[filter].innerHTML.to_s.include?("Buy")
          mark = filter
        end
      end
      @browser.mgs_purchaseopt_list[mark].click
      sleep 2
      @browser.mgs_cart_modal_chkout_btn.click
      sleep 2
      @browser.url_data.full_url.to_s.include?("qa.m2.gamestop.com/checkout")
      @browser.div.className("empty_cart").h4.should_not_exist == true
      @browser.mgs_ftr_fullsite_lnk.click if @browser.mgs_ftr_fullsite_lnk.exists == true
      @browser.url_data.full_url.to_s.include?("qa.gamestop.com/Checkout")
      @browser.div.className("cartempty").h2.should_not_exist == true
      @browser.mgs_ftr_fullsite_lnk.exists == true
    else
      $tracer.trace("
      \r\n=====================================================
      \r\nValidating fullsite link for phones has been skipped.
      \r\nDevice = #{@device}
      \r\n=====================================================
      ")
    end
  end
end

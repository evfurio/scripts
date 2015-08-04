### TODO: Template Description of this script
# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_headers_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range header002 --browser chrome --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_headers_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range header004 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopRespMobile/dsl/src/dsl"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
$tracer.trace("THIS IS TEST DESC #{$tc_desc} \nTHIS IS TEST ID #{$tc_id}")

describe "MGS NextGen Header Links" do

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
      \r\n***********************************************************************
      \r\n  VALIDATING HEADERS VALUES FOR PHONES AND TABLETS HAVE BEEN SKIPPED.
      \r\n  Kindly check run configurations.
      \r\n  Device = #{@device}
      \r\n***********************************************************************
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
      @browser.log_in_button.click
      sleep 5
    else
      @browser.open("#{@start_page}")
      is_guest_user = true
    end

  end

  it "Mobile Header validation for Tablets" do
    arrTabHeader = ["Shop", "Deals", "Trade", "Sign In"]

    if @device.upcase.strip == "TABLET"
      $has_run = true

      $tracer.trace("\r\n===== >>>>> Validating PUR link.")
      @browser.mgs_hdr_tabnav_guest_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_tabnav_guest_lnk.click
      if @params['login'] == ""
         @browser.url_data.full_url.to_s.include?("gamestop.com/poweruprewards")
      else
         @browser.url_data.full_url.to_s.include?("gamestop.com/PowerUpRewards/Dashboard")
      end
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating gift cards link.")
      @browser.mgs_hdr_tabnav_giftcards_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_tabnav_giftcards_lnk.click
      @browser.url_data.full_url.to_s.include?("#{@start_page}/gift-cards")
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating cart link.")
      @browser.mgs_hdr_tabnav_cart_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_tabnav_cart_lnk.click
      @browser.url_data.full_url.to_s.include?("#{@start_page}/Checkout")
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating stores link.")
      @browser.mgs_hdr_tabnav_stores_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_tabnav_stores_lnk.click
      @browser.url_data.full_url.to_s.include?("#{@start_page}/Stores")
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating shop link.")
      @browser.mgs_hdr_tabnav_search_section.is_visible.should.eql?(true)
      @browser.mgs_hdr_tabmnu_list.is_visible.should.eql?(true)
      @browser.mgs_hdr_tabmnu_list[0].innerText.eql?(arrTabHeader[0])
      @browser.mgs_hdr_tabmnu_list[0].click

      $tracer.trace("\r\n===== >>>>> Validating shop > xboxone link.")
      @browser.mgs_shop_xboxone_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_xboxone_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z141ub"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating shop > ps4 link.")
      @browser.mgs_shop_ps4_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_ps4_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z141uc"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating shop > xbox360 link.")
      @browser.mgs_shop_xbox360_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_xbox360_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z141uo"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating shop > ps3 link.")
      @browser.mgs_shop_ps3_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_ps3_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z141uu"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating shop > wii link.")
      @browser.mgs_shop_wii_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_wii_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z141ul"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating shop > 3ds link.")
      @browser.mgs_shop_3ds_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_3ds_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z141un"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating shop > psvita link.")
      @browser.mgs_shop_psvita_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_psvita_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-0Z1z141um"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating more link.")
      @browser.mgs_hdr_tabmnu_list[0].li.innerText.eql?("More")
      @browser.mgs_hdr_tabmnu_list[0].ul.li[7].a.innerText("More").click

      $tracer.trace("\r\n===== >>>>> Validating more > collectibles link.")
      @browser.mgs_shop_more_collectibles_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_more_collectibles_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z141wd"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating more > accessories link.")
      @browser.mgs_shop_more_accessories_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_more_accessories_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z141z1"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating more > headsets link.")
      @browser.mgs_shop_more_headsets_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_more_headsets_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-0Z1z141yu"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating more > phone link.")
      @browser.mgs_shop_more_phones_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_more_phones_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z13lbh"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating more > tablets link.")
      @browser.mgs_shop_more_tablets_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_more_tablets_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-0Z1z13l9m"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating more > media players link.")
      @browser.mgs_shop_more_mediaplayers_lnk.is_visible.should.eql?(true)
      @browser.mgs_shop_more_mediaplayers_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-0Z1z13lap"
      @browser.browser_back


      $tracer.trace("\r\n===== >>>>> Validating deals link.")
      @browser.mgs_hdr_tabmnu_list[1].innerText.eql?(arrTabHeader[1])
      @browser.mgs_hdr_tabmnu_list[1].click

      $tracer.trace("\r\n===== >>>>> Validating deals > hotdeals link.")
      @browser.mgs_deals_hotdeals_lnk.is_visible.should.eql?(true)
      @browser.mgs_deals_hotdeals_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-9u"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating deals > preowned link.")
      @browser.mgs_deals_preowned_lnk.is_visible.should.eql?(true)
      @browser.mgs_deals_preowned_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-am"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating deals > best sellers link.")
      @browser.mgs_deals_bestsellers_lnk.is_visible.should.eql?(true)
      @browser.mgs_deals_bestsellers_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?Ns=variant.UnitsSold%7c1&Ntk=WildcardTitleKeyword"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating deals > weely ad link.")
      @browser.mgs_deals_weeklyad_lnk.is_visible.should.eql?(true)
      @browser.mgs_deals_weeklyad_lnk.click
      @browser.url_data.full_url.to_s.include?("qa.gamestop.com/weeklyad")
      @browser.open("#{@start_page}")
      # issue = needs two back events
      # @browser.browser_back


      $tracer.trace("\r\n===== >>>>> Validating deals > top categories link.")
      @browser.mgs_hdr_tabmnu_list[1].ul.li[4].innerText.eql?("Top Categories")
      @browser.mgs_hdr_tabmnu_list[1].ul.li[4].a.innerText("Top Categories").click

      $tracer.trace("\r\n===== >>>>> Validating deals > top categories > games link.")
      @browser.mgs_deals_topcategories_games_lnk.is_visible.should.eql?(true)
      @browser.mgs_deals_topcategories_games_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z13m1s"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating deals > top categories > electronics link.")
      @browser.mgs_deals_topcategories_electronics_lnk.is_visible.should.eql?(true)
      @browser.mgs_deals_topcategories_electronics_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z13mc5"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating deals > top categories > consoles link.")
      @browser.mgs_deals_topcategories_consoles_lnk.is_visible.should.eql?(true)
      @browser.mgs_deals_topcategories_consoles_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z13m8v"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating deals > top categories > accessories link.")
      # to do = ats tag must be unique for the two accessories submenus
      @browser.mgs_hdr_tabmnu_list[1].ul.li[4].ul.li[3].a.is_visible.should.eql?(true)
      @browser.mgs_hdr_tabmnu_list[1].ul.li[4].ul.li[3].a.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z13m8h"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating deals > top categories > collectibles link.")
      @browser.mgs_deals_topcategories_collectibles_lnk.is_visible.should.eql?(true)
      @browser.mgs_deals_topcategories_collectibles_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-1z141wd"
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating Sign In / My Account link.")
      @browser.mgs_hdr_tabmnu_list[2].innerText.eql?(arrTabHeader[2])
      @browser.mgs_hdr_tabmnu_list[2].click
      @browser.url_data.full_url.to_s.include?("qa.gamestop.com/trade")
      @browser.browser_back
      sleep 2

      if @params['login'] == ""
        $tracer.trace("\r\n===== >>>>> User is NOT logged in.")
        @browser.mgs_hdr_tabmnu_list[3].innerText.eql?(arrTabHeader[3])
        @browser.mgs_hdr_tabmnu_list[3].click

        $tracer.trace("\r\n===== >>>>> Validating sign in link.")
        @browser.mgs_hdr_tabmnu_signin_btn.is_visible.should.eql?(true)
        @browser.mgs_hdr_tabmnu_signin_btn.click
        @browser.url_data.full_url.to_s.include?("loginqa.gamestop.com/Account/Login?ReturnUrl=http%3A%2F%2Fqa.m2.gamestop.com%2F")
        @browser.browser_back

        $tracer.trace("\r\n===== >>>>> Validating create account link.")
        @browser.mgs_hdr_tabmnu_createacct_btn.is_visible.should.eql?(true)
        @browser.mgs_hdr_tabmnu_createacct_btn.click
        @browser.url_data.full_url.to_s.include?("loginqa.gamestop.com/Account/Login?ReturnUrl=http%3A%2F%2Fqa.m2.gamestop.com%2F#create")
        @browser.browser_back

        $tracer.trace("\r\n===== >>>>> Validating orders link.")
        @browser.mgs_hdr_tabmnu_signin_menu.is_visible.should.eql?(true)
        @browser.mgs_hdr_tabmnu_signin_menu.click
        @browser.url_data.full_url.to_s.include?("#{@start_page}/Orders/OrderHistoryLogin")
        @browser.browser_back
      else
        $tracer.trace("\r\n===== >>>>> User was logged in successfully.")
        @browser.mgs_hdr_tabmnu_list[3].innerText.include?("Welcome back")
        @browser.mgs_hdr_tabmnu_list[3].click

        $tracer.trace("\r\n===== >>>>> Validating profile link.")
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[0].is_visible.should.eql?(true)
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[0].innerText.eql?("Account Details")
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[0].click
        @browser.url_data.full_url.to_s.include?("loginqa.gamestop.com/Profile")
        @browser.browser_back

        $tracer.trace("\r\n===== >>>>> Validating order history link.")
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[1].is_visible.should.eql?(true)
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[1].innerText.eql?("Order History")
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[1].click
        @browser.url_data.full_url.to_s.include?("#{@start_page}/Orders/OrderHistory")
        @browser.browser_back

        $tracer.trace("\r\n===== >>>>> Validating orders link.")
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[2].is_visible.should.eql?(true)
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[2].innerText.eql?("Guest / In Store Orders")
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[2].click
        @browser.url_data.full_url.to_s.include?("#{@start_page}/Orders/OrderHistoryLogin")
        @browser.browser_back

        $tracer.trace("\r\n===== >>>>> Validating pur link.")
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[3].is_visible.should.eql?(true)
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[3].innerText.eql?("PowerUp Rewards")
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[3].click
        @browser.url_data.full_url.to_s.include?("m.qa4.gamestop.com/poweruprewards")
        @browser.browser_back

        $tracer.trace("\r\n===== >>>>> Validating sign out link.")
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[4].is_visible.should.eql?(true)
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[4].innerText.eql?("Sign Out")
        @browser.mgs_hdr_tabmnu_list[3].ul.li.a[4].click
        @browser.url_data.full_url.to_s.include?("#{@start_page}/Frame/Header/MobileSignOut")
        @browser.browser_back
      end

      $tracer.trace("\r\n===== >>>>> Validating PURCC removed")
      @browser.mgs_hdr_mobmnu_purcc_lnk.eql?(false)
    else
      $tracer.trace("
      \r\n=====================================================
      \r\nValidating fullsite link for tablets has been skipped.
      \r\nDevice = #{@device}
      \r\n=====================================================
      ")
    end
  end

  it "Mobile Header validation for Phones" do
    arrPhoneHeader = ["Trade", "Cart", "Stores", "Search"]

    if @device.upcase.strip == "PHONE"
      $has_run = true

      $tracer.trace("\r\n===== >>>>> Validating hamburger menu.")
      @browser.mgs_hdr_mobile_hamburger.is_visible.should.eql?(true)
      @browser.mgs_hdr_mobile_hamburger.click

      $tracer.trace("\r\n===== >>>>> Validating trade link.")
      @browser.mgs_hdr_mobnav_trade_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_mobnav_trade_lnk.innerText.eql?(arrPhoneHeader[0])
      @browser.mgs_hdr_mobnav_trade_lnk.click
      @browser.url_data.full_url.to_s.include?("#{@start_page}/trade")
      @browser.th.className("tradeValue").innerText.eql?("Trade Value")
	  @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating cart link.")
      @browser.mgs_hdr_mobnav_cart_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_mobnav_cart_lnk.innerText.eql?(arrPhoneHeader[1])
      @browser.mgs_hdr_mobnav_cart_lnk.click
      @browser.url_data.full_url.to_s.include?("#{@start_page}/Checkout")
	  @browser.section.className("content_group").h3.innerText.eql?("Shopping Cart")
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating store link.")
      @browser.mgs_hdr_mobnav_stores_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_mobnav_stores_lnk.innerText.eql?(arrPhoneHeader[2])
      @browser.mgs_hdr_mobnav_stores_lnk.click
      @browser.url_data.full_url.to_s.include?("#{@start_page}/stores")
	  @browser.span.className("toggleStyle").innerText.to_s.include?("LIST")
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating search link.")
      @browser.mgs_hdr_mobnav_search_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_mobnav_search_lnk.innerText.eql?(arrPhoneHeader[3])
      @browser.mgs_hdr_mobnav_search_lnk.click
      @browser.span.className("twitter-typeahead").innerText.eql?("Search GameStop")

      $tracer.trace("\r\n===== >>>>> Validating sign in / my account link.")
      @browser.mgs_hdr_mobile_hamburger.click
      if @params['login'] == ""
        @browser.mgs_hdr_mobmnu_signin_lnk.is_visible.should.eql?(true)
        @browser.mgs_hdr_mobmnu_signin_lnk.innerText.eql?("Sign In")
        @browser.mgs_hdr_mobmnu_signin_lnk.click
        @browser.url_data.full_url.to_s.include?("gamestop.com/Account/Login?ReturnUrl=http%3A%2F%2F#{@start_page}%2F")
		@browser.login_email_address_label.is_visible.should.eql?(true)
		$tracer.trace("\r\n===== >>>>> #{@browser.url_data.full_url.to_s}")
      else
        @browser.mgs_hdr_mob_myaccount_lnk.is_visible.should.eql?(true)
        @browser.mgs_hdr_mob_myaccount_lnk.innerText.eql?("My Account")
        @browser.mgs_hdr_mob_myaccount_lnk.click
        @browser.url_data.full_url.to_s.include?(".gamestop.com/Profile")
		$tracer.trace("\r\n===== >>>>> #{@browser.url_data.full_url.to_s}")
      end
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating shop link.")
      @browser.mgs_hdr_mobmnu_shop_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_mobmnu_shop_lnk.innerText.eql?("Shop")
      @browser.mgs_hdr_mobmnu_shop_lnk.click
      @browser.url_data.full_url.to_s.include?("#{@start_page}/browse")
      @browser.browser_back

		  $tracer.trace("\r\n===== >>>>> Validating shop > toggle link.")
		  @browser.mgs_hdr_mobmnu_shop_toggle_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_shop_toggle_lnk.innerText.eql?("Shop")
		  @browser.mgs_hdr_mobmnu_shop_toggle_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/#")
		  @browser.browser_back

		  $tracer.trace("\r\n===== >>>>> Validating shop > xboxone link.")
		  @browser.mgs_hdr_mobmnu_shop_xboxone_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_shop_xboxone_lnk.innerText.eql?("Xbox One")
		  @browser.mgs_hdr_mobmnu_shop_xboxone_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/browse?navState=/_/N-1z141ub")
		  @browser.mgs_search_sort_section.is_visible.should.eql?(true)
		  @browser.mgs_search_product_list.innerHTML.to_s.include?("Xbox One")
		  @browser.browser_back

		  $tracer.trace("\r\n===== >>>>> Validating shop > ps4 link.")
		  @browser.mgs_hdr_mobmnu_shop_ps4_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_shop_ps4_lnk.innerText.eql?("PS4")
		  @browser.mgs_hdr_mobmnu_shop_ps4_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/browse?navState=/_/N-1z141uc")
		  @browser.mgs_search_sort_section.is_visible.should.eql?(true)
		  @browser.mgs_search_product_list.innerHTML.to_s.include?("PlayStation 4")
		  @browser.browser_back

		  $tracer.trace("\r\n===== >>>>> Validating shop > xbox360 link.")
		  @browser.mgs_hdr_mobmnu_shop_xbox360_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_shop_xbox360_lnk.innerText.eql?("Xbox 360")
		  @browser.mgs_hdr_mobmnu_shop_xbox360_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/browse?navState=/_/N-1z141uo")
		  @browser.browser_back

		  $tracer.trace("\r\n===== >>>>> Validating shop > ps3 link.")
		  @browser.mgs_hdr_mobmnu_shop_ps3_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_shop_ps3_lnk.innerText.eql?("PS3")
		  @browser.mgs_hdr_mobmnu_shop_ps3_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/browse?navState=/_/N-1z141uu")
		  @browser.browser_back

		  $tracer.trace("\r\n===== >>>>> Validating shop > wii u link.")
		  @browser.mgs_hdr_mobmnu_shop_wii_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_shop_wii_lnk.innerText.eql?("Wii U")
		  @browser.mgs_hdr_mobmnu_shop_wii_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/browse?navState=/_/N-1z141ul")
		  @browser.browser_back

		  $tracer.trace("\r\n===== >>>>> Validating shop > 3ds link.")
		  @browser.mgs_hdr_mobmnu_shop_3ds_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_shop_3ds_lnk.innerText.eql?("3DS")
		  @browser.mgs_hdr_mobmnu_shop_3ds_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/browse?navState=/_/N-1z141un")
		  @browser.browser_back

		  $tracer.trace("\r\n===== >>>>> Validating shop > ps vita link.")
		  @browser.mgs_hdr_mobmnu_shop_psvita_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_shop_psvita_lnk.innerText.eql?("PS Vita")
		  @browser.mgs_hdr_mobmnu_shop_psvita_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/browse?navState=/_/N-0Z1z141um")
		  @browser.browser_back

		  $tracer.trace("\r\n===== >>>>> Validating shop > more link.")
		  @browser.mgs_hdr_mobmnu_shop_more_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_shop_more_lnk.innerText.eql?("More")
		  @browser.mgs_hdr_mobmnu_shop_more_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/#")
		  @browser.browser_back

	  
      $tracer.trace("\r\n===== >>>>> Validating deals link.")
      @browser.mgs_hdr_mobmnu_deals_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_mobmnu_deals_lnk.innerText.eql?("Deals")
      @browser.mgs_hdr_mobmnu_deals_lnk.click
      @browser.url_data.full_url.to_s.include?("#{@start_page}/browse?navState=/_/N-9u")
      @browser.browser_back
	  
		  $tracer.trace("\r\n===== >>>>> Validating deals > toggle link.")
		  @browser.mgs_hdr_mobmnu_deals_toggle_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_deals_toggle_lnk.innerText.eql?("Deals")
		  @browser.mgs_hdr_mobmnu_deals_toggle_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/#")
		  @browser.browser_back

		  $tracer.trace("\r\n===== >>>>> Validating deals > hot deals link.")
		  @browser.mgs_hdr_mobmnu_deals_hotdeals_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_deals_hotdeals_lnk.innerText.eql?("Hot Deals")
		  @browser.mgs_hdr_mobmnu_deals_hotdeals_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/browse?navState=/_/N-9u")
		  @browser.browser_back
	  
		  $tracer.trace("\r\n===== >>>>> Validating deals > preowned link.")
		  @browser.mgs_hdr_mobmnu_deals_preowned_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_deals_preowned_lnk.innerText.eql?("Pre-Owned")
		  @browser.mgs_hdr_mobmnu_deals_preowned_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/browse?navState=/_/N-am")
		  @browser.browser_back
	  
		  $tracer.trace("\r\n===== >>>>> Validating deals > best sellers link.")
		  @browser.mgs_hdr_mobmnu_deals_bestsellers_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_deals_bestsellers_lnk.innerText.eql?("Best Sellers")
		  @browser.mgs_hdr_mobmnu_deals_bestsellers_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/browse?Ns=variant.UnitsSold%7c1&Ntk=WildcardTitleKeyword")
		  @browser.browser_back
	  
		  $tracer.trace("\r\n===== >>>>> Validating deals > weekly ad link.")
		  @browser.mgs_hdr_mobmnu_deals_weeklyad_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_deals_weeklyad_lnk.innerText.eql?("Weekly Ad")
		  @browser.mgs_hdr_mobmnu_deals_weeklyad_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/weeklyad")
		  @browser.browser_back
	  
		  $tracer.trace("\r\n===== >>>>> Validating deals > top categories link.")
		  @browser.mgs_hdr_mobmnu_deals_topcategories_lnk.is_visible.should.eql?(true)
		  @browser.mgs_hdr_mobmnu_deals_topcategories_lnk.innerText.eql?("Top Categories")
		  @browser.mgs_hdr_mobmnu_deals_topcategories_lnk.click
		  @browser.url_data.full_url.to_s.include?("#{@start_page}/#")
		  @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating trade link.")
      @browser.mgs_hdr_mobmnu_trade_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_mobmnu_trade_lnk.innerText.eql?("Trade")
      @browser.mgs_hdr_mobmnu_trade_lnk.click
      @browser.url_data.full_url.to_s.include?("#{@start_page}/trade")
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating pur link.")
      @browser.mgs_hdr_mobmnu_pur_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_mobmnu_pur_lnk.innerText.eql?("PowerUp Rewards")
      @browser.mgs_hdr_mobmnu_pur_lnk.click
      @browser.url_data.full_url.to_s.include?("/poweruprewards")
      $tracer.trace("\r\n===== >>>>> #{@browser.url_data.full_url.to_s}")
      @browser.browser_back

      # need to add ats tag for this
      $tracer.trace("\r\n===== >>>>> Validating create an account link.")
      @browser.mgs_hdr_mobmnu_list[8].a.is_visible.should.eql?(true)
      @browser.mgs_hdr_mobmnu_list[8].a.innerText.eql?("Create an Account")
      @browser.mgs_hdr_mobmnu_list[8].a.click
      @browser.url_data.full_url.to_s.include?("gamestop.com/Account/Login?ReturnUrl=http%3A%2F%2F#{@start_page}%2F#create")
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating orders link.")
      @browser.mgs_hdr_mobmnu_orders_lnk.is_visible.should.eql?(true)
      @browser.mgs_hdr_mobmnu_orders_lnk.innerText.eql?("Guest / In Store Orders")
      @browser.mgs_hdr_mobmnu_orders_lnk.click
      @browser.url_data.full_url.to_s.include?("#{@start_page}/Orders/OrderHistoryLogin")
      @browser.browser_back

      $tracer.trace("\r\n===== >>>>> Validating sign out / gc link.")
      if @params['login'] == ""
        @browser.mgs_hdr_mob_signout_lnk.is_visible.should.eql?(true)
        @browser.mgs_hdr_mob_signout_lnk.innerText.eql?("Sign Out")
        @browser.mgs_hdr_mob_signout_lnk.click
        @browser.url_data.full_url.to_s.include?("#{@start_page}//Frame/Header/MobileSignOut")
      else
        @browser.mgs_hdr_mobmnu_gc_lnk.is_visible.should.eql?(true)
        @browser.mgs_hdr_mobmnu_gc_lnk.innerText.eql?("Gift Cards")
        @browser.mgs_hdr_mobmnu_gc_lnk.click
        @browser.url_data.full_url.to_s.include?("#{@start_page}/gift-cards")
      end
      @browser.browser_back
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


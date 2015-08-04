# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_frame_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range TFS99023 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopRespMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "MGS NextGen Sanity Tests" do

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
    $options.default_timeout = 20_000
    $snapshots.setup(@browser, :all)
		
		### Gets the size, view and user agent of the device
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
		@browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    $proxy.set_request_header("User-Agent", @device_user_agent)



    # Validation: Navigation - Tablet vs Phone
=begin
    if @device == "TABLET"
      @browser.mgs_hdr_mobile_hamburger.is_visible.should == false

      @browser.mgs_hdr_mobnav_list.is_visible.should == false
      @browser.mgs_hdr_mobnav_trade_lnk.is_visible.should == false
      @browser.mgs_hdr_mobnav_cart_lnk.is_visible.should == false
      @browser.mgs_hdr_mobnav_stores_lnk.is_visible.should == false
      @browser.mgs_hdr_mobnav_search_lnk.is_visible.should == false

      @browser.mgs_hdr_tabnav_list.is_visible.should == true
      @browser.mgs_hdr_tabnav_guest_lnk.is_visible.should == true
      @browser.mgs_hdr_tabnav_giftcards_lnk.is_visible.should == true
      @browser.mgs_hdr_tabnav_cart_lnk.is_visible.should == true
      @browser.mgs_hdr_tabnav_cart_img.is_visible.should == true
      @browser.mgs_hdr_tabnav_stores_lnk.is_visible.should == true
      @browser.mgs_hdr_tabnav_stores_img.is_visible.should == true
      @browser.mgs_hdr_tabnav_search_section.is_visible.should == true
      @browser.mgs_hdr_tabnav_search_input.is_visible.should == true

      @browser.mgs_hdr_tabnav_guest_lnk.click
      @browser.wait_for_landing_page_load
      @browser.back
      @browser.wait_for_landing_page_load

      @browser.mgs_hdr_tabnav_giftcards_lnk.click
      @browser.wait_for_landing_page_load
      @browser.back
      @browser.wait_for_landing_page_load

      @browser.mgs_hdr_tabnav_cart_lnk.click
      @browser.wait_for_landing_page_load
      @browser.back
      @browser.wait_for_landing_page_load

      @browser.mgs_hdr_tabnav_stores_lnk.click
      @browser.wait_for_landing_page_load
      @browser.back
      @browser.wait_for_landing_page_load

      @browser.mgs_hdr_tabnav_search_input.value = "robert"
      @browser.send_keys(KeyCodes::KEY_ENTER)
      sleep 5

    end

    if @device == "PHONE"
      @browser.mgs_hdr_mobile_hamburger.is_visible.should == true

      @browser.mgs_hdr_mobnav_list.is_visible.should == true
      @browser.mgs_hdr_mobnav_trade_lnk.is_visible.should == true
      @browser.mgs_hdr_mobnav_trade_img.is_visible.should == true
      @browser.mgs_hdr_mobnav_cart_lnk.is_visible.should == true
      @browser.mgs_hdr_mobnav_cart_img.is_visible.should == true
      @browser.mgs_hdr_mobnav_stores_lnk.is_visible.should == true
      @browser.mgs_hdr_mobnav_stores_img.is_visible.should == true
      @browser.mgs_hdr_mobnav_search_lnk.is_visible.should == true
      @browser.mgs_hdr_mobnav_search_img.is_visible.should == true

      @browser.mgs_hdr_tabnav_list.is_visible.should == false
      @browser.mgs_hdr_tabnav_guest_lnk.is_visible.should == false
      @browser.mgs_hdr_tabnav_giftcards_lnk.is_visible.should == false
      @browser.mgs_hdr_tabnav_cart_lnk.is_visible.should == false
      @browser.mgs_hdr_tabnav_stores_lnk.is_visible.should == false
      @browser.mgs_hdr_tabnav_search_section.is_visible.should == false
      @browser.mgs_hdr_tabnav_search_input.is_visible.should == false

      @browser.mgs_hdr_mobnav_trade_lnk.click
      @browser.wait_for_landing_page_load
      @browser.back
      @browser.wait_for_landing_page_load

      @browser.mgs_hdr_mobnav_cart_lnk.click
      @browser.wait_for_landing_page_load
      @browser.back
      @browser.wait_for_landing_page_load

      @browser.mgs_hdr_mobnav_stores_lnk.click
      @browser.wait_for_landing_page_load
      @browser.back
      @browser.wait_for_landing_page_load

      @browser.mgs_hdr_mobnav_search_lnk.click
      @browser.mgs_hdr_mobnav_search_section.is_visible.should == true
      @browser.mgs_hdr_mobnav_search_input.is_visible.should == true
      @browser.mgs_hdr_mobnav_search_input.value = "robert"
      @browser.send_keys(KeyCodes::KEY_ENTER)
      sleep 5

    end
=end

# Validation: Menu - Tablet vs Phone
    if @device.upcase.strip == "PHONE"


      unless @params['login'] == ""
        @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
        @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
        @cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)

        @browser.open("#{@start_page}")
        @browser.mgs_header_logo.should_exist

        ### TODO: Validation for Tablet and Phone for Login
        @browser.mgs_hdr_mobile_hamburger.click
        @browser.mgs_hdr_mobmnu_signin_lnk.innerText.should == "Sign In"
        @browser.mgs_hdr_mobmnu_signin_lnk.click
        @browser.wait_for_landing_page_load

        ### TODO: Move this to dsl
        @browser.email_address_field.value = @login
        @browser.password_field.value = @password
        @browser.log_in_button.click
        sleep 5

        @browser.mgs_hdr_mobile_hamburger.click
        @browser.mgs_hdr_mob_myaccount_lnk.innerText.should == "My Account"
      else
        @browser.open("#{@start_page}")
      end

      # validate_header_menus_by_device(@device)

      @browser.mgs_hdr_mobmnu_shop_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse"
      go_back_and_expand_hamburger

      @browser.mgs_hdr_mobmnu_deals_lnk.click
      @browser.url_data.full_url.should == "#{@start_page}/browse?navState=/_/N-9u"
      go_back_and_expand_hamburger

      @browser.mgs_hdr_mobmnu_trade_lnk.click
      go_back_and_expand_hamburger

      @browser.mgs_hdr_mobmnu_pur_lnk.click
      go_back_and_expand_hamburger

      @browser.mgs_hdr_mobmnu_orders_lnk.click
      go_back_and_expand_hamburger

      @browser.mgs_hdr_mobmnu_gc_lnk.click
      go_back_and_expand_hamburger

      @browser.mgs_hdr_mobmnu_purcc_lnk.click
      go_back_and_expand_hamburger


      ### Signout
      @browser.mgs_hdr_mobile_hamburger.click
      @browser.mgs_hdr_mob_signout_lnk.click
      sleep 10

    end


    if @device == "TABLET"
      @browser.mgs_hdr_mobile_hamburger.is_visible.should == false
      validate_header_menus_by_device(@device)

      @browser.mgs_hdr_tabmnu_list.length.should > 0
      puts "-------------------------MAIN MENU---------- #{@browser.mgs_hdr_tabmnu_list.length}"
      i=0
      while i < @browser.mgs_hdr_tabmnu_list.length
        puts "++++++++++++ MENU: #{@browser.mgs_hdr_tabmnu_list.at(i).menu.innerText.upcase.strip}"
        @browser.mgs_hdr_tabmnu_list.at(i).menu.click
        @browser.wait_for_landing_page_load

        puts "-----------------------SUB MENU------------ #{@browser.mgs_hdr_tabmnu_list.at(i).sub_menu_list.length}"
        a=0
        sub_menus=[]
        while a < @browser.mgs_hdr_tabmnu_list.at(i).sub_menu_list.length
          sub_menus << @browser.mgs_hdr_tabmnu_list.at(i).sub_menu_list.at(a).sub_menu.innerText.upcase.strip

            if @browser.mgs_hdr_tabmnu_list.at(i).sub_menu_list.at(a).sub_menu_item_list.exists == true
              puts "-----------------------SUB ITEMS------------ #{@browser.mgs_hdr_tabmnu_list.at(i).sub_menu_list.at(a).sub_menu_item_list.length}"
              b=0
              sub_menu_items=[]
              while b < @browser.mgs_hdr_tabmnu_list.at(i).sub_menu_list.at(a).sub_menu_item_list.length
                sub_menu_items << @browser.mgs_hdr_tabmnu_list.at(i).sub_menu_list.at(a).sub_menu_item_list.at(b).sub_menu_item.innerText.upcase.strip
                b+=1
              end
            end
          puts "++++++++++++ SUB MENU: #{@browser.mgs_hdr_tabmnu_list.at(i).sub_menu_list.at(a).sub_menu.innerText.upcase.strip}"
          puts "++++++++++++ SUB ITEMS: #{sub_menu_items}"

          a+=1
        end
        puts "++++++++++++ SUB MENU: #{sub_menus}"


        i+=1
      end
      













    end

	end	


  def validate_header_menus_by_device(device)
    if device.upcase.strip == "TABLET"
      @browser.mgs_hdr_mobmnu_section.is_visible.should == false
      @browser.mgs_hdr_mobmnu_list.is_visible.should == false
      @browser.mgs_hdr_mobmnu_signin_lnk.is_visible.should == false
      @browser.mgs_hdr_mobmnu_shop_lnk.is_visible.should == false
      @browser.mgs_hdr_mobmnu_deals_lnk.is_visible.should == false
      @browser.mgs_hdr_mobmnu_trade_lnk.is_visible.should == false
      @browser.mgs_hdr_mobmnu_pur_lnk.is_visible.should == false
      @browser.mgs_hdr_mobmnu_orders_lnk.is_visible.should == false
      @browser.mgs_hdr_mobmnu_gc_lnk.is_visible.should == false
      @browser.mgs_hdr_mobmnu_purcc_lnk.is_visible.should == false

      @browser.mgs_hdr_tabmnu_section.is_visible.should == true
      @browser.mgs_hdr_tabmnu_list.is_visible.should == true

    else
      @browser.mgs_hdr_mobmnu_section.is_visible.should == true
      @browser.mgs_hdr_mobmnu_list.is_visible.should == true
      @browser.mgs_hdr_mobmnu_signin_lnk.is_visible.should == true
      @browser.mgs_hdr_mobmnu_shop_lnk.is_visible.should == true
      @browser.mgs_hdr_mobmnu_deals_lnk.is_visible.should == true
      @browser.mgs_hdr_mobmnu_trade_lnk.is_visible.should == true
      @browser.mgs_hdr_mobmnu_pur_lnk.is_visible.should == true
      @browser.mgs_hdr_mobmnu_orders_lnk.is_visible.should == true
      @browser.mgs_hdr_mobmnu_gc_lnk.is_visible.should == true
      @browser.mgs_hdr_mobmnu_purcc_lnk.is_visible.should == true

      @browser.mgs_hdr_tabmnu_section.is_visible.should == false
      @browser.mgs_hdr_tabmnu_list.is_visible.should == false

    end
  end


  def go_back_and_expand_hamburger
    @browser.wait_for_landing_page_load
    @browser.back
    @browser.mgs_hdr_mobile_hamburger.click
    @browser.wait_for_landing_page_load
  end


end
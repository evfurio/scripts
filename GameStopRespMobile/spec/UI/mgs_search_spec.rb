# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_search_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range TFS98971 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopRespMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "MGS NextGen Search Tests" do

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

  it "#{$tc_id} #{$tc_desc}" do

    @browser.open("#{@start_page}/browse")
    @browser.wait_for_landing_page_load
    @browser.mgs_header_logo.should_exist


    if @device.upcase.strip == "PHONE"
      @browser.mgs_search_filter_btn.is_visible.should == true
      @browser.mgs_search_filter_btn.innerText.strip.should == "FILTER"
      @browser.mgs_search_filter_btn.click
      @browser.wait_for_landing_page_load
    else
      @browser.mgs_search_filter_btn.is_visible.should == false
    end

    # Select Filters
    defined_filter = @params['filter'].upcase.strip
    puts "----------------------------------------------------------------- #{defined_filter}"
    i = 0
    filters = []
    has_selected_filter = false
    while i < @browser.mgs_search_filter_list.length
      filter_name = @browser.mgs_search_filter_list.at(i).filter_header.innerText.strip
      filters << filter_name
      @browser.mgs_search_filter_list.at(i).expand_collapse.click
      @browser.wait_for_landing_page_load
      @browser.mgs_search_filter_list.at(i).filter_items.length.should > 0

      a = 0
      while a < @browser.mgs_search_filter_list.at(i).filter_items.length
        sub_filter_name = @browser.mgs_search_filter_list.at(i).filter_items.at(a).item_link.innerText.split("(")
        selected_filter_name = sub_filter_name[0].upcase.strip
        selected_filter_count = @browser.mgs_search_filter_list.at(i).filter_items.at(a).record_count.innerText.strip

        if selected_filter_name == defined_filter
          @browser.mgs_search_filter_list.at(i).filter_items.at(a).item_link.click
          @browser.wait_for_landing_page_load
          @browser.mgs_search_breadcrumb_header.should_exist
          # Validation: Defined filter should match what's in the Breadcrumb
          breadcrumb = @browser.mgs_search_breadcrumb_list.at(0).selected_filter.innerText.upcase.strip
          $tracer.trace("Selected Filter: #{selected_filter_name} = Breadcrumb: #{breadcrumb}")
          breadcrumb.should == "#{selected_filter_name}"
          has_selected_filter = true
        end
        break if i == @browser.mgs_search_filter_list.length
        a = has_selected_filter == true ? @browser.mgs_search_filter_list.at(i).filter_items.length : a+=1
      end

      i = has_selected_filter == true ? @browser.mgs_search_filter_list.length  : i+=1
    end
    $tracer.trace("FILTERS :::::  #{filters}")

    sleep 5
    @browser.mgs_search_filter_btn.click if @device == "PHONE"

    result_hdr = @browser.mgs_search_result_hdr.innerText.strip.split(" ")
    $tracer.trace("Results from Header :::::  #{@browser.mgs_search_result_hdr.innerText.strip}")
    selected_filter_count.should include "#{result_hdr[0].strip}"
    selected_filter_count.should include "#{@browser.mgs_search_record_lbl[1].innerText.strip}"

    # Validation: Filter results
    i = 0
    while i < @browser.mgs_search_product_list.length
      @browser.mgs_search_product_list.at(i).prod_img.should_exist
      @browser.mgs_search_product_list.at(i).prod_lnk.should_exist
      @browser.mgs_search_product_list.at(i).prod_info.should_exist
      @browser.mgs_search_product_list.at(i).prod_title.should_exist
      @browser.mgs_search_product_list.at(i).prod_platform.should_exist

      if defined_filter == "MONTH AFTER NEXT"
        @browser.mgs_search_product_list.at(i).prod_preorder.should_exist
        @browser.mgs_search_product_list.at(i).prod_release.should_exist

        release_date = @browser.mgs_search_product_list.at(i).prod_release.innerText.split(":")
        $tracer.trace(" Date Today :::::  #{Time.now.strftime('%m/%d/%Y').to_s}")
        $tracer.trace(" Release Date ::::::  #{release_date[1].strip}")
        release_date[1].strip.should > Time.now.strftime('%m/%d/%Y').to_s
      end
      @browser.mgs_search_product_list.at(i).prod_preorder.should_exist if defined_filter == "PRE-RELEASE"
      @browser.mgs_search_product_list.at(i).prod_rating.should_exist if defined_filter == "9+"
      @browser.mgs_search_product_list.at(i).prod_puas.should_exist if defined_filter == "PICKUP@STORE"
      @browser.mgs_search_product_list.at(i).prod_price.should_exist
      i+=1
    end
    product_list_count = @browser.mgs_search_product_list.length



    # Validation: Sorting
    @browser.mgs_search_sort_section.should_exist
    @browser.mgs_search_sort_list.should_exist
    @browser.mgs_search_sort_list.length.should > 0
    i = 0
    sort_names = []
    while i < @browser.mgs_search_sort_list.length
      sort_names << @browser.mgs_search_sort_list.at(i).innerText.strip
      sort_names.at(0).should == "Sort By:"
      @browser.mgs_search_sort_list.at(0).is_visible.should == false if @device == "PHONE"

          unless i == 0
            if i == @browser.mgs_search_sort_list.length-1 and @device == "PHONE"
              @browser.mgs_search_sort_list.at(i).is_visible.should == false
              puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            else
              @browser.mgs_search_sort_list.at(i).sort_name.click
              @browser.mgs_search_sort_list.at(i).sort_name.get("class").split(" ").include?("sort-desc").should == true
              @browser.wait_for_landing_page_load
              @browser.mgs_search_sort_list.at(i).sort_name.click
              unless @browser.mgs_search_sort_list.at(i).innerText.upcase.strip == "POPULARITY" or @browser.mgs_search_sort_list.at(i).innerText.upcase.strip == "BEST SELLING"
                @browser.mgs_search_sort_list.at(i).sort_name.get("class").split(" ").include?("sort-asc").should == true
                puts "****************************************************************************************************"
              else
                @browser.mgs_search_sort_list.at(i).sort_name.get("class").split(" ").include?("sort-asc").should == false
                puts "/////////////////////////////////////////////////////////////////////////////////////////////////////"
              end
            end
            @browser.wait_for_landing_page_load
          end





      i+=1
    end



    # Validation: Previous filters should be available in the Breadcrumb section
    @browser.mgs_search_product_list.at(product_list_count-1).prod_lnk.click
    @browser.wait_for_landing_page_load
    @browser.back

    @browser.mgs_search_filter_btn.click if @device == "PHONE"
    defined_filter.should == @browser.mgs_search_breadcrumb_list.at(0).selected_filter.innerText.upcase.strip

    @browser.take_snapshot("GUNSMOKE")

  end

  it "Homepage-Hero Cartridge" do
     @browser.open("#{@start_page}")
     @browser.mgs_swiper_wrapper.should_exist

     @browser.mgs_cartridge_ads.should_exist

     $tracer.trace("Total Cartridges: #{@browser.mgs_cartridge_ads.length}")

     total_iteration=0
     dynamic_image_flg=false
     while dynamic_image_flg==false
       cartridge_class=@browser.mgs_cartridge_ads.get("class")
       $tracer.trace("Present Ads class: #{cartridge_class}")
       sleep 2
       next_cartridge_class=@browser.mgs_cartridge_ads.get("class")
       $tracer.trace("Next Ads class: #{next_cartridge_class}")

       $tracer.trace("Checking if cartridge is dynamically changing")
       #This will determine if cartridge images are dynamically displayed
       if cartridge_class!=next_cartridge_class
          dynamic_image_flg=true
          break
       end

       total_iteration+=1

       if total_iteration==20
         break
       end

     end

     dynamic_image_flg.should==true

     count_flg=true
     if @browser.mgs_cartridge_ads.length<4
       count_flg=false
       $tracer.trace("Total Cartridges: #{@browser.mgs_cartridge_ads.length} not within expected.")
     end

     count_flg.should==true

  end

  it "Homepage-Horizontal Ads and Record List" do
    @browser.open("#{@start_page}")

    defined_filter = @params['filter'].upcase.strip

    #Replacing:
    #   box_art=MGSRecommendationsList.new(@browser)
    #with:
    box_art=@browser.mgs_prodrecommendations_section

    if defined_filter.include?";RECORD-LIST;"
        if box_art.product_list!=nil
          $tracer.trace("BOX ART is turned on.")
          $tracer.trace("Total boxes: #{box_art.product_list.length}")
          @browser.mgs_product_recommendations.should_exist
        else
          $tracer.trace("BOX ART is turned off.")
        end
    end

    if defined_filter.include?";AD-SLOT;"
      box_art.product_list.should_exist
      box_art.product_list.at(0).product_link.should_exist
      box_art.product_list.at(0).product_image.should_exist
    end

    #Record rating existence verification
    @browser.mgs_product_record_rating.should_exist

  end

 #HOPS Main Automation Single and Multiple variants
 #Serves the following TCs:
 #"101076 Authenticated User-Without Home Store Single and Multiple variants"
 #"101087 Authenticated User-With Home Store-With Personal Information-Single and Multiple variants"
 #"101287 Check Store Availability - Guest User - Single and Multiple variants"
 #"101280 Authenticated User-With Home Store-Without Personal Info-Single and Multiple variants"
  it "HOPS Main Automation Single and Multiple variants" do
    @browser.open("#{@start_page}/browse")
    @browser.mgs_ats_tab_sign_in.should_exist

    defined_focus = @params['Focus'].upcase.strip
    defined_filter = @params['filter'].upcase.strip

    search_text = @params['search_text']

    #Authentication

    if defined_focus=="HOPS-AUTH"
      @browser.mgs_hdr_mobile_hamburger.should_exist
      @browser.mgs_hdr_mobile_hamburger.click
      @browser.mgs_hdr_mobmnu_signin_lnk.should_exist
      @browser.mgs_hdr_mobmnu_signin_lnk.click
      @browser.mgs_log_in(@login,@password)
    end

    @browser.mgs_search_product(search_text)
    @browser.wait_for_landing_page_load

    @browser.mgs_prod_puas.should_exist
    @browser.select_and_click(@browser.mgs_prod_puas,0)

    @browser.wait_for_landing_page_load

    @browser.mgs_shipopt_puas.should_exist
    @browser.mgs_shipopt_puas.click

    if @browser.mgs_pick_up_store_info.exists
       @browser.mgs_pick_up_store_info.click
    else
       $tracer.trace("Pickup at store info does not exists.")
    end


    if defined_filter.include?";USE-LEGACY;"
      $tracer.trace("Using legacy pages for HOPS.")
      @browser.wait_for_landing_page_load

      input_element=@browser.get_element_from_attrib_value(@browser.mgs_location_city_state,"type","search")
      if input_element!=nil

        @browser.set_value_and_enter(input_element,@params['shipping_zip'])

        @browser.select_and_click(@browser.mgs_store_actions,0)
        @browser.select_and_click(@browser.mgs_pick_up_new,0)

        @browser.wait_for_landing_page_load

        #This will only appear if previous details were not inputted
        #If authenticated, the app will save the previous data
        @browser.mgs_puas_firstname.should_exist
        @browser.mgs_puas_firstname.value=@params['first_name'] #"Accept"

        @browser.mgs_puas_lastname.should_exist
        @browser.mgs_puas_lastname.value=@params['last_name'] #"Test"

        @browser.mgs_puas_email.should_exist

        #Using shipping_email as a container field of PUAS email
        @browser.mgs_puas_email.value=@params['shipping_email'] #"AllenValencia@gamesstop.com"

        @browser.mgs_puas_phone.should_exist

        #Using shipping_phone as a container field of PUAS phone
        @browser.mgs_puas_phone.value=@params['shipping_phone']

        @browser.mgs_puas_continue_button.should_exist
        @browser.mgs_puas_continue_button.click

        @browser.mgs_finish_button.should_exist
        @browser.mgs_finish_button.click

        continue_shopping=@browser.get_element_from_inner_text_match(@browser.mgs_red_button,"continue shopping")
        continue_shopping.click
      else
           #This portion is for non-legacy pages
           #Future scripts will be written here upon availability of non-legacy PUAS
           $tracer.trace("Arrived to a point where non-legacy pages should be used.")
      end

    else
      $tracer.trace("Configured as not using legacy pages.")
    end

    #Waiting for dev to finish
    #suppose to be redirected to an entry page under HOPS
  end


  it "Navigate order history" do

    defined_filter = @params['filter'].upcase.strip
    user_login = @params['login'].strip
    user_pass = @params['password'].strip


    @browser.open("#{@start_page}")
    @browser.wait_for_landing_page_load

    if defined_filter.include?";WITH-FLYOUT-MENU;"
      @browser.mgs_tab_sign_in_lbl.should_exist
      @browser.mgs_tab_sign_in_lbl.click
      #Will solve timing problem with JQuery
      sleep 2
      @browser.mgs_ats_tab_sign_in.should_exist
      @browser.mgs_tab_create_acct_btn.should_exist
      @browser.mgs_tab_guest_order_history.should_exist
    end

    #Guest Order History
    #
    if defined_filter.include?";ORDER-HISTORY;"

      current_url=@browser.url_data.full_url
      click_result=@browser.click_and_validate_redirect(@browser.mgs_tab_guest_order_history,current_url,@browser)
      click_result.should==true

      @browser.wait_for_landing_page_load

      @browser.mgs_lookup_by_login.should_exist
      @browser.mgs_lookup_by_confirmation.should_exist
      @browser.mgs_lookup_by_cc.should_exist

    end

    if defined_filter.include?";ORDER-HISTORY-LOGIN;"
       if defined_filter.include?";LOOKUP-LOGIN;"
          @browser.mgs_lookup_by_login.should_exist
          @browser.mgs_lookup_by_login.click
       elsif defined_filter.include?";LOOKUP-CONFIRM-NUM;"
          @browser.mgs_lookup_by_confirmation.click
          #Delay for any JQuery processing
          sleep 1
       end
    end

    if defined_filter.include?";LOGIN-PAGE;"
       @browser.mgs_email_addr_field.should_exist
       @browser.mgs_password_field.should_exist

       if user_login.length>0
           @browser.mgs_email_addr_field.value=user_login
           @browser.mgs_password_field.value=user_pass
           @browser.user_login_button.should_exist
           @browser.user_login_button.click
           @browser.wait_for_landing_page_load
       end
    end

    if defined_filter.include?";USE-CONFIRM-NUMBER;"
       @browser.mgs_email_in_lookup_confirm.should_exist
       @browser.mgs_lookup_confirm_number.should_exist
    end

    if defined_filter.include?";USE-CC;"
       @browser.mgs_lookup_by_cc.click
       @browser.mgs_lookup_by_cc_email.should_exist
       @browser.mgs_lookup_by_cc_number.should_exist
    end

  end

  it "Default sort order" do
    @browser.open("#{@start_page}/browse")   
    sort_option = @browser.get_element_arr_from_attrib_value(@browser.mgs_search_sort_list_a,"class","active sort-desc")
    result = true
          
    if sort_option.length>1
      $tracer.trace("ERROR: MORE THAN ONE ACTIVE SORT OPTION")
      result = false
    end
    
    if !sort_option[0].innerText.include?("Best Selling")
      $tracer.trace("ERROR: Default sort option is not 'Best Selling'")
      result = false
    end
    
    result.should == true
  end
end
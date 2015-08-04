# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_browse_main_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range TFS97352 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopRespMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()
USER_AGENT_STR = "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
$tracer.trace("THIS IS TEST DESC #{$tc_desc} \nTHIS IS TEST ID #{$tc_id}")

describe "GS Responsive Mobile" do

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
		
		# Load the size of device
		$tracer.trace("DEVICE SIZE - W: #{@params['device_width']}, H: #{@params['device_height']}")
    @browser.set_size(@params['device_width'].to_i, @params['device_height'].to_i)
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
		
		# Check if user is Authenticated or Guest
		unless @params["login"] == ""
			$tracer.trace("Goto Login page if Authenticated User")
			@open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
			@cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
			
			# Temporary approach while waiting for the mGS Header Cartridge
			login_url = "https://loginqa.gamestop.com/account/login?ReturnUrl="
			@browser.open("#{login_url}#{@start_page}/browse")
			
			@browser.username_field.value = @login
			@browser.password_field.value = @password
			@browser.log_in_button.click
		else
			@browser.open("#{@start_page}/browse")
		end
	
		#---------------------------------------------
		if @params['device'].upcase == "PHONE"
			@browser.mgs_search_filter_btn.is_visible.should == true
			@browser.mgs_search_left_section.is_visible.should == false
			@browser.mgs_search_record_section.is_visible.should == false
		else
			@browser.mgs_search_filter_btn.is_visible.should == false
			@browser.mgs_search_left_section.is_visible.should == true
			@browser.mgs_search_record_section.is_visible.should == true
		end
		
		@browser.mgs_search_main_section.should_exist
		@browser.mgs_search_filter_btn.should_exist
		@browser.mgs_search_result_hdr.should_exist
		
		@browser.mgs_search_record_section.should_exist
		@browser.mgs_search_record_lbl.should_exist
		@browser.mgs_search_prodlist_section.should_exist
		@browser.mgs_search_product_list.should_exist
		@browser.mgs_search_product_list.length.should > 0
		i = 0
		while i < @browser.mgs_search_product_list.length
			@browser.mgs_search_product_list.at(i).prod_img.should_exist
			@browser.mgs_search_product_list.at(i).prod_lnk.should_exist
			@browser.mgs_search_product_list.at(i).prod_info.should_exist
			@browser.mgs_search_product_list.at(i).prod_title.should_exist
			@browser.mgs_search_product_list.at(i).prod_platform.should_exist
			# @browser.mgs_search_product_list.at(i).prod_release.should_exist
			# @browser.mgs_search_product_list.at(i).prod_puas.should_exist
			@browser.mgs_search_product_list.at(i).prod_price.should_exist
			i+=1
		end
		product_list_count = @browser.mgs_search_product_list.length
		
		#Sorting functionality still in DEV
		@browser.mgs_search_sort_section.should_exist
		@browser.mgs_search_sort_list.should_exist
		@browser.mgs_search_sort_list.length.should > 0
		i = 0
		sort_names = []
		while i < @browser.mgs_search_sort_list.length
			sort_names << @browser.mgs_search_sort_list.at(i).innerText.strip
			@browser.mgs_search_sort_list.at(i).sort_name.click unless i == 0 
			@browser.wait_for_landing_page_load
			i+=1
		end
		#TODO: Hardcoded for the meantime
		$tracer.trace("SORT LIST :::::  #{sort_names}")
		sort_names.should include "Sort By:", "Relevance", "Release Date", "Price"
		@browser.refresh_page
		
		@browser.mgs_search_load_more.should_exist
		@browser.mgs_search_load_more.click
		@browser.wait_for_landing_page_load
		
		# Validation for LoadMore: ProductList count PHONE / TABLET
		@browser.mgs_search_product_list.length.should == product_list_count * 2
		$tracer.trace("PRODUCT_LIST LENGTH :::::  #{@browser.mgs_search_product_list.length}")
		if @params["device"].upcase == "TABLET"
			record_count = @browser.mgs_search_record_lbl[0].innerText.strip.split("-")
			$tracer.trace("RECORD COUNT :::::  #{record_count[1].strip}   -----   PRODUCT LENGTH :::::  #{@browser.mgs_search_product_list.length.to_s}")
			record_count[1].strip.should == @browser.mgs_search_product_list.length.to_s	
			@browser.take_snapshot("BERT")
		end
	end	
	
end
# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_browse_left_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range TFS97350 --browser chrome --or

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
			@browser.mgs_search_filter_btn.innerText.strip.should == "FILTER"
			@browser.mgs_search_filter_btn.click
			@browser.wait_for_landing_page_load
		else
			@browser.mgs_search_filter_btn.is_visible.should == false
		end
		
		@browser.mgs_search_left_section.should_exist
		@browser.mgs_search_breadcrumb_section.should_exist
		@browser.mgs_search_filter_section.should_exist
		@browser.mgs_search_filter_list.length.should > 0
		
		# Validations - Expand Collapse functionality
		i = 0
		filters = []
		while i < @browser.mgs_search_filter_list.length
			filter_name = @browser.mgs_search_filter_list.at(i).filter_header.innerText.strip
			filters << filter_name
			@browser.mgs_search_filter_list.at(i).expand_collapse.click
			@browser.wait_for_landing_page_load
			
			@browser.mgs_search_filter_list.at(i).filter_items.length.should > 0
			a = 0
			sub_filters = []
			while a < @browser.mgs_search_filter_list.at(i).filter_items.length		
				sub_filter_name = @browser.mgs_search_filter_list.at(i).filter_items.at(a).item_link.innerText.split("(")
				sub_filters << "#{sub_filter_name[0].strip} #{@browser.mgs_search_filter_list.at(i).filter_items.at(a).record_count.innerText.strip}"
				# Validations - Adding and Removing a filter
				if i == 0
					@browser.mgs_search_filter_list.at(i).filter_items.at(a).item_link.click	
					@browser.wait_for_landing_page_load				
					@browser.mgs_search_breadcrumb_header.should_exist	
					$tracer.trace("Selected Filter: #{sub_filter_name[0].strip} = Breadcrumb: #{@browser.mgs_search_breadcrumb_list.at(0).selected_filter.innerText.strip}")
					@browser.mgs_search_breadcrumb_list.at(0).selected_filter.innerText.strip.should == "#{sub_filter_name[0].strip}"
					
					@browser.mgs_search_breadcrumb_list.at(0).remove_filter.click
					@browser.wait_for_landing_page_load
					@browser.mgs_search_breadcrumb_header.should_not_exist	
					@browser.mgs_search_breadcrumb_list.length.should == 0
				end
				a+=1
			end
			$tracer.trace("SUB FILTERS for #{filter_name} :::::  #{sub_filters}")
			
			#sub_filter_content(@catalog_svc, @catalog_svc_version, filter_name, sub_filters)
			@browser.mgs_search_filter_list.at(i).expand_collapse.click
			@browser.wait_for_landing_page_load
			i+=1
		end
		$tracer.trace("FILTERS :::::  #{filters}")

		i = 0
		ctr = 0
		previous_filter = ""
		while ctr < @browser.mgs_search_filter_list.length
			main_filter_name = @browser.mgs_search_filter_list.at(i).filter_header.innerText.strip
			@browser.mgs_search_filter_list.at(i).expand_collapse.click
			@browser.wait_for_landing_page_load
			sub_filter_name = @browser.mgs_search_filter_list.at(i).filter_items.at(i).item_link.innerText.split("(")
			selected_filter_name = sub_filter_name[0].strip
			selected_filter_count = @browser.mgs_search_filter_list.at(i).filter_items.at(i).record_count.innerText.strip
			@browser.mgs_search_filter_list.at(i).filter_items.at(i).item_link.click
			@browser.wait_for_landing_page_load
			
			# Validations - RecordCount against Results
			unless previous_filter == main_filter_name
				result_hdr = @browser.mgs_search_result_hdr.innerText.strip.split(" ")
				selected_filter_count.should include "#{result_hdr[1]}"
				selected_filter_count.should include "#{@browser.mgs_search_record_lbl[1].innerText.strip}"
				$tracer.trace("RECORD COUNT :::::  #{result_hdr[1]} results")
			end
			
			# Validations - New Breadcrumbs
			$tracer.trace("BREADCRUMB :::::  #{breadcrumb}")
			breadcrumb.should include "#{selected_filter_name}"
			
			previous_filter = main_filter_name
			ctr = @browser.mgs_search_filter_list.exists == true ? 0 : @browser.mgs_search_filter_list.length
		end
		
		# Validations - Remove Breadcrumb
		i = 0
		while i < @browser.mgs_search_breadcrumb_list.length
			@browser.mgs_search_breadcrumb_list.at(i).remove_filter.click
			@browser.wait_for_landing_page_load
			i = @browser.mgs_search_breadcrumb_list.exists == true ? 0 : @browser.mgs_search_filter_list.length
		end
		@browser.mgs_search_breadcrumb_header.should_not_exist		
		
		if @params['device'].upcase == "PHONE"
			@browser.mgs_search_filter_btn.is_visible.should == true
			@browser.mgs_search_filter_btn.innerText.strip.should == "DONE"
			@browser.mgs_search_filter_btn.click
			@browser.wait_for_landing_page_load
			@browser.mgs_search_filter_btn.innerText.strip.should == "FILTER"
		else
			@browser.mgs_search_filter_btn.is_visible.should == false
		end
		
		@browser.take_snapshot("BERT")
		
		#---------------------------------------------
		# #Validations - Breadcrumb should not be removed if Sorting is selected		
		# @browser.mgs_search_filter_list.at(0).expand_collapse.click
		# sleep 2
		# @browser.mgs_search_filter_list.at(0).filter_items.at(2).item_link.click
		# sleep 2
		# @browser.mgs_search_sort_list.at(2).sort_name.click
		# sleep 2
		# @browser.mgs_search_breadcrumb_header.should_exist
		# @browser.mgs_search_breadcrumb_list.length.should > 0
	
	end
	
	# NOTE: This is nothing being used yet
	def sub_filter_content(catalog_svc, catalog_svc_version, filter_name, sub_filters)	
		sub_filter_rsp = catalog_svc.perform_get_navigation_filter_by_type(catalog_svc_version, filter_name)		
		case filter_name.upcase
			when "AVAILABILITY", "CATEGORY", "CONDITION", "DEALS", "ESRB", "PLATFORM", "PRICE", "PRODUCTS", "PUBLISHER", "RATING"
				sub_filter_rsp.should include sub_filters
			else
				# DO NOTHING
		end
	end
	
	def breadcrumb
		@browser.wait_for_landing_page_load
		@browser.mgs_search_breadcrumb_header.should_exist
		@browser.mgs_search_breadcrumb_list.length.should > 0
		i = 0
		selected_filters = []
		while i < @browser.mgs_search_breadcrumb_list.length
			selected_filters << @browser.mgs_search_breadcrumb_list.at(i).selected_filter.innerText.strip
			@browser.mgs_search_breadcrumb_list.at(i).remove_filter.should_exist
			i+=1
		end
		return selected_filters
	end

end
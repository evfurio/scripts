#USAGE NOTES#
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_nfs_puas_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS74568 --browser chrome --or 

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Authenticated User NFS PUAS Button" do

  before(:all) do
    #Set proxy for the web driver
    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9091"

    $proxy = ProxyServerManager.new(9091)
    @browser = WebBrowser.new(browser_type_parameter)

		@browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 10_000
    $snapshots.setup(@browser, :all)
		
		#Get the parameters from the csv dataset
    @params = $global_functions.csv
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")		
  end

  before(:each) do
    $proxy.inspect
    $proxy.start
    sleep 5
		
		@browser.delete_all_cookies_and_verify
    @browser.open(@start_page)
		@browser.log_in_link.click
    @browser.log_in(@login, @password)
  end

  after(:each) do
    $proxy.stop
		@browser.return_current_url
  end

  after(:all) do
    @browser.close
  end

		it "#{$tc_id} #{$tc_desc}" do
    $proxy.start_capture(true)
		@browser.open(@start_page)
		empty = ""
    @browser.search_for_product(empty)
    @browser.open("#{@start_page}/browse?nav=28-xu0,1317f")
    @browser.retry_until_found(lambda{@browser.nfs_pickup_at_store_button[0].exists != false}, 10)
    @browser.nfs_pickup_at_store_button[0].click
		@browser.wait_for_landing_page_load
		
		popup_visible = (@browser.hops_no_stores_popup.call("style.display").eql?("none") ? true : false )
		unless popup_visible == true
			@browser.hops_no_stores_button.click
      @browser.wait_for_landing_page_load
    end
		@browser.hops_zip_code_search_field.value = ''
		@browser.hops_zip_code_search_field.value = @params['ship_zip']
		@browser.wait_for_landing_page_load
    @browser.hops_zip_code_search_button.click
		sleep 5
		
		if @browser.hops_zip_code_search_field.exists == true
			@browser.hops_store_list.at(0).pickup_at_store_button.click 
			@browser.wait_for_landing_page_load
			is_store_search_visible = true
		end
		
		capture_data = $proxy.get_capture
		# $tracer.trace(capture_data.formatted_json)
		
		url = @browser.return_current_url
		store_number = @browser.get_store_number_from_url(@browser.url_data.full_url)
		omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), @browser.url_data.full_url)
		store_search_event, hold_request_event, c15_value = @browser.get_store_and_event_from_query_strings(omniture_list)
		
		# Assert: event33, event 34, prop15
		store_search_event.should == 'event33' if is_store_search_visible == true
		hold_request_event.should == 'event34'
		c15_value.should == store_number
		$tracer.report("Actual Event :: #{store_search_event}        Expected Event :: event33") if is_store_search_visible == true
		$tracer.report("Actual Event :: #{hold_request_event}        Expected Event :: event34")
    $tracer.report("Actual c15 :: #{c15_value}        Expected c15 :: #{store_number}")

		# Populate the Hold Request form
		@browser.first_name_field.value = @params['bill_first_name']
    @browser.last_name_field.value = @params['bill_last_name']
    @browser.email_address_field.value = @params['bill_email']
    @browser.confirm_email_address_field.value = @params['bill_email']
    @browser.phone_number_field.value = @params['bill_phone']
    
		@browser.hops_finish_button.click
    @browser.wait_for_landing_page_load

		if @browser.hops_alternate_store_popup_panel.exists
			@browser.hops_alternate_store_popup_panel.set_alternate_store_button.click
			@browser.wait_for_landing_page_load
		end
    @browser.retry_until_found(lambda{@browser.hops_accepted_page_title.exists != false}, 10)
    @browser.hops_accepted_page_title.should_exist
    @browser.hops_accepted_page_message.inner_text.should start_with "Sweet! We've sent an email to"
		sleep 5
	end


end
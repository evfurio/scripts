### *** Recommerce *** 
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\RCM\recommerce_web_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\RCM\tradevalue_dataset.csv --range TFS40155 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Trade Value - Search for device" do
	before(:all) do
		@browser = WebBrowser.new(browser_type_parameter)
		@browser.delete_internet_files(browser_type_parameter)
		$options.default_timeout = 10_000
		$snapshots.setup(@browser, :all)

		@params = $global_functions.csv
		@start_page = $global_functions.prop_url.find_value_by_name("url")
	end

	before(:each) do
		@browser.delete_all_cookies_and_verify
	end

	after(:each) do
		@browser.return_current_url
	end

	after(:all) do
			$tracer.trace("after all")
	end
	
	it "#{$tc_id} #{$tc_desc}" do
		url = "#{@start_page}/Recommerce/web"
		$tracer.trace("URL ::::::::::::::::::::: #{url}")
		@browser.open(url)
		
		@browser.validate_rcm_home_page_controls
		@browser.product_list_dropdown.value = @params["ProductDropdown"]
		@browser.product_list_button.click
		@browser.wait_for_landing_page_load
			
		### The "Choose Device" page should successfully load at this point. ###	
		@browser.validate_rcm_choose_device_page_controls
		@browser.get_offer_button.click
		@browser.wait_for_landing_page_load
				
		### The "Product Condition" page should successfully load at this point. ###
		@browser.validate_rcm_product_condition_page_controls
		
		#ASSERT: By default Working tab should be selected
		actual_result = (@browser.rcm_tab2_section.call("style.display").eql?("block") ? true : false )
		actual_result.should == true

		@browser.good_tab.click
		@browser.wait_for_landing_page_load
		@credit_price, @cash_price = @browser.get_credit_cash_price
		sleep 3
		@browser.items_included_checkbox[3].click 
		@credit_price_after, @cash_price_after = @browser.get_credit_cash_price
		@browser.validate_before_after_price(@credit_price, @cash_price, @credit_price_after, @cash_price_after)

		@browser.poor_tab.click
		@browser.wait_for_landing_page_load
		@credit_price, @cash_price = @browser.get_credit_cash_price
		sleep 3
		@browser.items_included_checkbox[9].click 
		@credit_price_after, @cash_price_after = @browser.get_credit_cash_price
		@browser.validate_before_after_price(@credit_price, @cash_price, @credit_price_after, @cash_price_after)
		
		
		@browser.like_new_tab.click
		@browser.wait_for_landing_page_load
		@credit_price, @cash_price = @browser.get_credit_cash_price	
		sleep 3
		@browser.items_included_checkbox[0].click 
		@credit_price_after, @cash_price_after = @browser.get_credit_cash_price
		@browser.validate_before_after_price(@credit_price, @cash_price, @credit_price_after, @cash_price_after)
		
	end
		
end

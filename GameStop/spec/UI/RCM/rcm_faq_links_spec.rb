### *** Recommerce *** 
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\RCM\rcm_faq_links_spec.rb --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv  --url QA_GS --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\RCM\tradevalue_dataset.csv --range TFS40151 --browser chrome --or 

#require "#{ENV['QAAUTOMATION_SCRIPTS']}/Recommerce/dsl/src/dsl"
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"


describe "Trade Value - Search for device" do
    before(:all) do
        $options.default_timeout = 90_000
		$tracer.mode = :on
        $tracer.echo = :on
    end

    before(:each) do
		csv = QACSV.new(csv_filename_parameter)
		@row = csv.find_row_by_name(csv_range_parameter)
        @browser = GameStopBrowser.new(browser_type_parameter)
		@global_functions = GlobalServiceFunctions.new()
		@global_functions.csv = @row
		@global_functions.parameters
		@sql = @global_functions.sql_file
		@db = @global_functions.db_conn
		@store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc
		@start_page = @global_functions.prop_url.find_value_by_name("url")
		initialize_csv_params
		
		#Get necessary GUID's per test method execution
		@session_id = generate_guid
		
		@tradevalue_svc, @tradevalue_svc_version = @global_functions.tradevalue_svc
    end

    after(:each) do
      @browser.return_current_url
    end

    after(:all) do
        $tracer.trace("after all")
    end
	
	it "should be able to search for device" do
		url = "#{@start_page}/Recommerce/web"
		$tracer.trace("URL ::::::::::::::::::::: #{url}")
		@browser.open(url)
		
		@browser.trade_in_your_stuff_title.should_exist
		
		@browser.product_list_dropdown.should_exist
		@browser.product_list_button.should_exist
		
		@browser.how_works_link.should_exist
		@browser.what_trade_link.should_exist
		@browser.where_take_link.should_exist
		@browser.faqs_link.should_exist
		@browser.disclaimer_label.should_exist
		
		#It should go to "How does it work?" page
		@browser.how_works_link.click
		@browser.wait_for_landing_page_load
		$tracer.trace("URL ::::::::::::::::::::: #{url}")
		#validate other controls in here
		@browser.trade_in_your_stuff_title.should_exist
		@browser.rcm_faqs_title.should_exist
		#It should go back to "Default" page
		@browser.how_works_link.click
		@browser.wait_for_landing_page_load
				
		#It should go to "What can I trade?" page
		@browser.what_trade_link.click
		@browser.wait_for_landing_page_load
		#validate other controls in here
		@browser.trade_in_your_stuff_title.should_exist
		#It should go back to "Default" page
		@browser.how_works_link.click
		@browser.wait_for_landing_page_load
		
		#It should go to "Where do I take it?" page
		@browser.where_take_link.click
		@browser.wait_for_landing_page_load
		#validate other controls in here
		@browser.trade_in_your_stuff_title.should_exist
		@browser.rcm_faqs_title.should_exist
		#It should go back to "Default" page
		@browser.how_works_link.click
		@browser.wait_for_landing_page_load
		
		#It should go to "Frequently Asked Questions" page
		@browser.faqs_link.click
		@browser.wait_for_landing_page_load
		#validate other controls in here
		@browser.trade_in_your_stuff_title.should_exist
		@browser.rcm_faqs_title.should_exist
		#It should go back to "Default" page
		@browser.how_works_link.click
		@browser.wait_for_landing_page_load
	
	end	
		
	def initialize_csv_params
		 @client_channel = @row.find_value_by_name("ClientChannel")
		 @locale = @row.find_value_by_name("Locale")
		 @concept = @row.find_value_by_name("Concept")
		 @product = @row.find_value_by_name("ProductDropdown")
		 @keyword = @row.find_value_by_name("KeyWord")
	end
	
end

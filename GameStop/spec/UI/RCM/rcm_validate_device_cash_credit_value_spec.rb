### *** Recommerce *** 
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\RCM\rcm_validate_device_cash_credit_value_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\RCM\tradevalue_dataset.csv --range TFS40155 --browser chrome --or

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
		@browser.how_works_link.should_exist
		@browser.what_trade_link.should_exist
		@browser.where_take_link.should_exist
		@browser.faqs_link.should_exist
		@browser.disclaimer_label.should_exist
		
		@browser.product_list_dropdown.should_exist
		@browser.product_list_dropdown.value = @product
		@browser.product_list_button.should_exist
		@browser.product_list_button.click
		@browser.wait_for_landing_page_load
		
		
		### The "Choose Device" page should successfully load at this point. ###	
		@browser.trade_in_your_stuff_title.should_exist
		@browser.device_name_label.should_exist
		@browser.device_image.should_exist
		@browser.product_storage_label.should_exist
		@browser.product_connectivity_label.should_exist
		
		@browser.get_offer_button.should_exist
		@browser.get_offer_button.click
		@browser.wait_for_landing_page_load
		
		
		### The "Product Condition" page should successfully load at this point. ###
		@browser.trade_in_your_stuff_title.should_exist
		@browser.product_family_label.should_exist
		@browser.rcm_product_title_label.should_exist
		@browser.model_holder_label.should_exist
		@browser.model_number_label.should_exist
		
		@browser.product_condition_image.should_exist
		@browser.choose_another_device_link.should_exist
		@browser.like_new_tab.should_exist
		@browser.good_tab.should_exist
		@browser.poor_tab.should_exist
		# @browser.broken_tab.should_exist
		@browser.items_included_checkbox.should_exist
		
		@browser.credit_price_label.should_exist
		@browser.cash_price_label.should_exist
		@browser.print_quote_button.should_exist
		
		@browser.store_locator_textbox.should_exist
		@browser.store_locator_button.should_exist

		
		#By default Like New tab should be selected
		#Check and Uncheck the checkboxes
		@browser.items_included_checkbox[0].click 
		sleep 3
		@browser.items_included_checkbox[0].click
		
		sleep 5
		@browser.good_tab.click
		@browser.wait_for_landing_page_load
		@browser.items_included_checkbox[1].click 
		sleep 3
		@browser.items_included_checkbox[1].click
		
		sleep 5
		@browser.poor_tab.click
		@browser.wait_for_landing_page_load
		@browser.items_included_checkbox[2].click
		sleep 3
		@browser.items_included_checkbox[3].click
		sleep 3
		@browser.items_included_checkbox[4].click 
		sleep 3
		@browser.items_included_checkbox[2].click
		sleep 3
		@browser.items_included_checkbox[3].click
		sleep 3
		@browser.items_included_checkbox[4].click
		
		sleep 5
		# @browser.broken_tab.click
		# @browser.wait_for_landing_page_load
		# @browser.items_included_checkbox[5].click
		# sleep 3
		# @browser.items_included_checkbox[6].click
		# sleep 3
		# @browser.items_included_checkbox[7].click
		# sleep 3
		# @browser.items_included_checkbox[8].click
		# sleep 3
		# @browser.items_included_checkbox[9].click
		# sleep 3
		# @browser.items_included_checkbox[10].click 
		# sleep 3
		# @browser.items_included_checkbox[5].click
		# sleep 3
		# @browser.items_included_checkbox[6].click
		# sleep 3
		# @browser.items_included_checkbox[7].click
		# sleep 3
		# @browser.items_included_checkbox[8].click
		# sleep 3
		# @browser.items_included_checkbox[9].click
		# sleep 3
		# @browser.items_included_checkbox[10].click
		
		sleep 5
		@browser.like_new_tab.click
		@browser.wait_for_landing_page_load
		
		puts "============================ credit_price :::::    #{@browser.credit_price_label.inner_text}"
		puts "============================ cash_price :::::    #{@browser.cash_price_label.innerText}"	
		unless @browser.credit_price_label.innerText == "Recycle"
			credit_price = money_string_to_decimal(@browser.credit_price_label.inner_text)
		end
		unless @browser.cash_price_label.innerText == "Recycle"
			cash_price = money_string_to_decimal(@browser.cash_price_label.innerText)
		end
		puts "============================ credit_price :::::    #{credit_price}"
		puts "============================ cash_price :::::    #{cash_price}"
		
		@browser.items_included_checkbox[0].click
		sleep 5
		
		puts "============================ credit_price_after :::::    #{@browser.credit_price_label.inner_text}"
		puts "============================ cash_price_after :::::    #{@browser.cash_price_label.innerText}"
		@recycle_credit = (@browser.credit_price_label.inner_text.eql?("Recycle") ? true : false )
		credit_price_after = (@recycle_credit ? 0 : money_string_to_decimal(@browser.credit_price_label.inner_text))
		@recycle_cash = (@browser.cash_price_label.inner_text.eql?("Recycle") ? true : false )
		cash_price_after = (@recycle_cash ? 0 : money_string_to_decimal(@browser.cash_price_label.inner_text))
		puts "============================ credit_price_after :::::    #{credit_price_after}"
		puts "============================ cash_price_after :::::    #{cash_price_after}"
				
		#ASSERT: Cash Price / Credit Price should not be equal after clicking the checkbox.
		@expected_result = true
		actual_credit = (credit_price != credit_price_after ? true : false)
		actual_cash = (cash_price != cash_price_after	? true : false)
		actual_credit.should == @expected_result
		actual_cash.should == @expected_result
	
	
	end	
		
	def initialize_csv_params
		 @client_channel = @row.find_value_by_name("ClientChannel")
		 @locale = @row.find_value_by_name("Locale")
		 @concept = @row.find_value_by_name("Concept")
		 @product = @row.find_value_by_name("ProductDropdown")
		 @keyword = @row.find_value_by_name("KeyWord")
	end
	
end

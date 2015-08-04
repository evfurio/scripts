## Calling all test data from csv
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\GSmobile_guest_checkout_ISPU_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\mobile_dataset.csv  --range TFS47276  --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "GS Mobile Guest Checkout ISPU" do

  before(:all) do
    if browser_type_parameter == "chrome"
      @browser = WebBrowser.new(browser_type_parameter, true)
    else
      @browser = WebBrowser.new(browser_type_parameter)
    end
		@browser.delete_internet_files(browser_type_parameter)
		$options.default_timeout = 10_000
		$snapshots.setup(@browser, :all)
		
		#Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
		@purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
  end

  before(:each) do
		@browser.cookie.all.delete
		@session_id = generate_guid
		sql = @sql.to_s
		@results_from_file = @db.exec_sql_from_file("#{sql}")  
		@browser.open(@start_page)
		@browser.validate_analytics(@params)
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end
    
   it "#{$tc_id} #{$tc_desc}" do
		@browser.view_cart_button.click
		@browser.empty_new_cart   
		@browser.continue_shopping_button.click
		@browser.store_pickup_search_button.click	
		@browser.availability_slide.click
		@browser.gsm_filter_submit_button.click	
		@browser.wait_for_landing_page_load

		$tracer.trace("Get Products")
		@matured_product, @physical_product = @browser.add_products_to_cart(@results_from_file, @start_page, @params)
		
		if @params["continue_checkout"]
			#Click the InStorePickUp link
			@browser.store_pickup_link.at(1).click
			@browser.wait_for_landing_page_load
			@browser.paypal_chkout_button.should_not_exist   # This Paypal button should disappear if PickUpAtStore is selected
			
			$tracer.trace("Continue Secure Checkout")
			@browser.continue_checkout_button_handling.click
			@browser.wait_for_landing_page_load
			
			$tracer.trace("How Do You Want To Checkout? screen")
			@browser.buy_as_guest_button.click
			@browser.wait_for_landing_page_load
			
			$tracer.trace("Age Check screen")
			if @matured_product
				@browser.seventeen_or_older_button.click
				@browser.wait_for_landing_page_load
			end
						
			$tracer.trace("Billing Address screen")
			@browser.continue_checkout_button_handling.click
			@browser.wait_for_landing_page_load
			@browser.show_order_summary_link.click
			@browser.enter_billing_address_plus_email(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"], @params["billing_email"])           
			@browser.continue_checkout_button_handling.click
			@browser.wait_for_landing_page_load
			
			$tracer.trace("Handling Options screen")
			@browser.show_order_summary_link.click
			@browser.store_pickup_zipcode(@params["billing_zip"])
			@browser.store_pickup_search_button.click
			@browser.chkout_handling_options_label.should_exist
			@browser.chkout_store_pickup_radio.click
			@browser.wait_for_landing_page_load
			@browser.select_store_button.click
			@browser.wait_for_landing_page_load
			sleep 3
			@browser.chkout_store_pickup_number.value = @params["billing_phone"]
	
			@browser.continue_checkout_button_handling.click
			@browser.wait_for_landing_page_load

			$tracer.trace("Payment Options screen") 
			@browser.show_order_summary_link.click
			@browser.unused_promocode_message.should_not_exist
			
			$tracer.trace("Pay With A Credit Card") 
			@browser.cc_payment_option.click
			@browser.wait_for_landing_page_load
			
			if @params["change_existing_address"]
				$tracer.trace("Change address Link on Payment Page")
				@browser.change_address_payment_page_link.click
				@browser.enter_billship_address(@params["first_name"], @params["last_name"], @params["billing_line1"], @params["billing_city"], @params["billing_state"], @params["billing_zip"], @params["billing_phone"])              
				@browser.continue_checkout_button_handling.click
				@browser.wait_for_landing_page_load
				@browser.retry_until_found(lambda{@browser.cc_payment_option.exists != false})
				@browser.cc_payment_option.click
				@browser.wait_for_landing_page_load
			end
			$tracer.trace("Enter Credit Card Info") 
			@browser.enter_credit_card_info(@params["cc_type"], @params["cc_number"], @params["exp_month"], @params["exp_year"], @params["cvv"])
							
			if @params["submit_order"]
				@browser.submit_order
				unless @params["valid_pur_svs_cc"]
					$tracer.trace("Please enter a valid credit card number.") 
					@browser.confirm_invalid_cc_warning
				else
					$tracer.trace("Order Confirmation screen") 
					@browser.validate_order_prefix("(5|8)1")
					# @browser.take_snapshot
				end
			end
		end		
	end
end
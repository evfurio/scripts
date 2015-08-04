# USAGE NOTES
# Sanity test for all browsers
##################################
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\multiple_browser_sanity.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv --url QA_GS --browser chrome --or
#If using Paypal in QA3 to test: Add: --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA3_Paypal1
# and set @start_page = "http://qa3.gamestop.com" if (@params["use_paypal_at_cart"] || @params["use_paypal_at_payment"])

qaautomation_dir = ENV['QAAUTOMATION_FILES']
require "#{qaautomation_dir}/common/src/base_requires"
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

# This must be global, you would have to read from CSV here
$arr = ["firefox", "chrome", "webspec-ie", "safari"]

$arr.each { |b|
  describe "Sanity for All Browsers" do
    before(:all) do
		$browser = GameStopBrowser.new(b)
		GameStopBrowser.delete_temporary_internet_files(b)
		$options.default_timeout = 10_000
		$snapshots.setup($browser, :all)
		$tracer.mode=:on
		$tracer.echo=:on
    end
    
    before(:each) do
	    @session_id = generate_guid
		
		@params = $browser.initialize_params_from_csv(QACSV.new(csv_filename_parameter), csv_range_parameter)
		$tc_desc = @params["testdescription"]
		$tc_id = @params["id"]
		#global_functions passes the csv row object and return the parameters.
	    @global_functions = GlobalServiceFunctions.new()
		@global_functions.csv = @params["row"]
		@global_functions.parameters
		@sql = @global_functions.sql_file
		@db = @global_functions.db_conn
	
		@catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
		@start_page = @global_functions.prop_url.find_value_by_name("url")
		
		@cart_svc, @cart_svc_version = @global_functions.cart_svc
		@account_svc, @account_svc_version = @global_functions.account_svc
		@profile_svc, @profile_svc_version = @global_functions.profile_svc
		@digital_wallet_svc, @digital_wallet_version = @global_functions.digitalwallet_svc
		@purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
		@velocity_svc, @velocity_svc_version = @global_functions.velocity_svc
	
		$tracer.trace(" *** Clear Cart *** ")
		@open_id, @user_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, account_login_parameter, account_password_parameter , @account_svc_version)
		
		@cart_svc.perform_empty_cart(@session_id, @user_id, 'GS_US', 'en-US', @cart_svc_version)
				
		if @params["load_ship_addr_from_profile"] || @params["load_bill_addr_from_profile"]
		   @shipping_addresses, @billing_address = @profile_svc.get_address_by_user_id(@user_id, @session_id, "GS_US", @profile_svc_version)
		end
		
    end

    after(:all) do
      $browser.close_all()
    end
	
	it "#{$tc_id} should populate cart and login with #{b}" do
		$tracer.trace("Add to cart by service invocation")
		$browser.add_products_to_cart_by_service(@db, @sql)
		
		$browser.open("#{@start_page}/checkout")
		$browser.log_in_link.click
		$browser.log_in(account_login_parameter, account_password_parameter)
	end
    
    it "#{$tc_id} should login and refresh page with #{b}" do

	  $browser.instance_variable_get(:@driver).navigate.refresh
	  $browser.open("http://www.gamestop.com/")
	  $browser.log_in_link.click
	  $browser.log_in(account_login_parameter, account_password_parameter)
	  $browser.instance_variable_get(:@driver).navigate.refresh
      
    end
    
    it "#{$tc_id} should do a search for a keyword with #{b}" do
      $browser.search_field.value = "legos"
      $browser.search_button.click
    end
	
	
  end
}


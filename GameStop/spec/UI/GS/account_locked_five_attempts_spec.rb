# http://qa.gamestop.com
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS68121  --browser chrome  -e 'Locked Account after five attempts' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS68133  --browser chrome  -e 'Attempt to login less than 30 minutes' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS68136  --browser chrome  -e 'Attempt to login after 30 minutes' --or

# http://qa.ebgames.com
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS68141  --browser chrome  -e 'Locked Account after five attempts' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS68142  --browser chrome  -e 'Attempt to login less than 30 minutes' --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS68144  --browser chrome  -e 'Attempt to login after 30 minutes' --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "GS Account Locked Tests" do
  before(:all) do	
		@browser = WebBrowser.new(browser_type_parameter)
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
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
  end

  before(:each) do
    @browser.cookie.all.delete
    @session_id = generate_guid
  end

  after(:each) do
    @browser.return_current_url
  end
  
  after(:all) do
		@browser.close_all()
  end
  
  it "Locked Account after five attempts" do
		lock_account_after_five_attempts
	end	
		
	it "Attempt to login less than 30 minutes" do
		lock_account_after_five_attempts
		#Close browser then open new browser before 30 minutes
		@browser.close_all()
		sleep 50
		@browser = WebBrowser.new(browser_type_parameter)
		@browser.refresh_page
		@product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id) 
		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, @cart_id = '', @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		@browser.checkout_log_in(@user_name, @password)
		validate_login_max_attempt_error	
	end
	
	it "Attempt to login after 30 minutes"  do
		lock_account_after_five_attempts
		#Close browser then open a new one after 30+ minutes
		@browser.close_all()
		sleep 1801
		@browser = WebBrowser.new(browser_type_parameter)
		@browser.refresh_page
		@product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id) 
		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, @cart_id, @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		@browser.checkout_log_in(@user_name, @password)
		@browser.error_message_label.innerText.should == ""
	end
	
	def generate_new_user_credentials
		this =  [('a'..'z'),('A'..'Z'),(1..10)].map{|i| i.to_a}.flatten
		idnew  =  (0...10).map{ this[rand(this.length)] }.join
		return "svc_autogen#{idnew}@qagsecomprod.oib.com", "Test1234!"
	end
		
	def validate_login_error
		@browser.error_message_label.innerText.should == "The information you supplied appears to be incorrect. Please carefully re-type your email address and password."
		sleep 5
	end
	
	def validate_login_max_attempt_error
		@browser.error_message_label.innerText.should == "The information you supplied appears to be incorrect and you have exceeded the maximum number of attempts. Please try signing in later or reset your password."
		sleep 5
	end
	
	def lock_account_after_five_attempts
		$tracer.trace("Register user then Logout")
    @user_name, @password = generate_new_user_credentials		
    @browser.open(@start_page)
		@browser.register_link.click		
		@browser.create_email_address_field.should_exist
    @browser.create_email_address_field.value = @user_name
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked = false
    @browser.submit_button.click
		sleep 5
		@browser.profile_logout_link.should_exist
		@browser.profile_logout_link.click
		
		$tracer.trace("Goto Homepage then Add a product to Cart")		
		@browser.open(@start_page)
		@product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id) 
		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, '', @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
    @browser.add_powerup_rewards_number(@params)
		subtotal = @browser.check_cart_subtotal_and_discount(@params)
		@browser.wait_for_landing_page_load
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		# Login with invalid password
		@wrong_password = 'Test1234'
		i = 1
		attempts = 5
		while i < attempts do
			@browser.checkout_log_in(@user_name, @wrong_password)
			validate_login_error
			i += 1
		end
		@browser.checkout_log_in(@user_name, @wrong_password)
		validate_login_max_attempt_error
	end
  
end
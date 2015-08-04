## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\GSmobile_account_locked_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\mobile_dataset.csv  --range TFS68137  --browser chrome -e 'GSM Locked Account after five attempts' --or
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\GSmobile_account_locked_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\mobile_dataset.csv  --range TFS68138  --browser chrome -e 'GSM Attempt to login less than 30 minutes' --or
## d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\GSmobile_account_locked_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\UI\mobile_dataset.csv  --range TFS68140  --browser chrome -e 'GSM Attempt to login after 30 minutes' --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "GS Mobile Account Locked Tests" do

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
		@browser.delete_all_cookies_and_verify
		@session_id = generate_guid
		sql = @sql.to_s
		@results_from_file = @db.exec_sql_from_file("#{sql}")  
		@browser.open(@start_page)
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end
    
  it "GSM Locked Account after five attempts" do
		lock_account_after_five_attempts
	end
		
	it "GSM Attempt to login less than 30 minutes" do
		lock_account_after_five_attempts
		#Close browser then open new browser before 30 minutes
		@browser.close_all()
		@browser = WebBrowser.new(browser_type_parameter)
		sleep 50
		@browser.refresh_page
		@matured_product, @physical_product = @browser.add_products_to_cart(@results_from_file, @start_page, @params)
		@browser.continue_checkout_button_handling.click
		@browser.wait_for_landing_page_load
		@browser.buy_as_login_button.click
		@browser.wait_for_landing_page_load
		@browser.enter_login_credentials(@user_name, @wrong_password)
		@browser.user_login_button.click
		@browser.wait_for_landing_page_load
		validate_login_max_attempt_error
	end
	
	it "GSM Attempt to login after 30 minutes" do
		lock_account_after_five_attempts
		#Close browser then open a new one after 30+ minutes
		@browser.close_all()
		sleep 1801
		@browser = WebBrowser.new(browser_type_parameter)
		@browser.refresh_page
		@matured_product, @physical_product = @browser.add_products_to_cart(@results_from_file, @start_page, @params)
		@browser.continue_checkout_button_handling.click
		@browser.wait_for_landing_page_load
		@browser.buy_as_login_button.click
		@browser.wait_for_landing_page_load
		@browser.enter_login_credentials(@user_name, @wrong_password)
		@browser.user_login_button.click
		@browser.wait_for_landing_page_load
		@browser.gsm_error_message.innerText.should == ""
	end		
	
	def generate_new_user_credentials
		this =  [('a'..'z'),('A'..'Z'),(1..10)].map{|i| i.to_a}.flatten
		idnew  =  (0...10).map{ this[rand(this.length)] }.join
		return "svc_autogen#{idnew}@qagsecomprod.oib.com", "Test1234!"
	end
	
	def validate_login_error
		@browser.gsm_error_message.should_exist
		@browser.gsm_error_message.innerText.should == 'The information you supplied appears to be incorrect. Please carefully re-type your email address and password.'
		sleep 5
	end
	
	def validate_login_max_attempt_error
		@browser.gsm_error_message.should_exist
		@browser.gsm_error_message.innerText.should == 'The information you supplied appears to be incorrect and you have exceeded the maximum number of attempts. Please try signing in later or reset your password.'
		sleep 5
	end
	
	def lock_account_after_five_attempts
		@browser.log_out_link.click if @browser.log_out_link.exists
		@browser.log_in_link.click
		@browser.wait_for_landing_page_load

		@browser.user_signup_button.click
		@browser.wait_for_landing_page_load

		$tracer.trace("Register user then Logout")
		@user_name = @browser.generate_new_user_credentials(prefix = "svc_autogen", domain = "qagsecomprod.oib.com")
    @password = "T3sting1!"

    @browser.create_email_address_field.should_exist
    @browser.create_email_address_field.value = @user_name
    @browser.create_password_field.value = @password
    @browser.confirm_password_field.value = @password
    @browser.email_opt_in_checkbox.checked = false
    @browser.submit_button.click
		sleep 2
		@browser.log_out_link.click 
		
		$tracer.trace("Get Products")
		@browser.view_cart_button.click
		@browser.wait_for_landing_page_load
		@browser.empty_new_cart  	
		@browser.continue_shopping_button.click
		@browser.store_pickup_search_button.click	
		@browser.availability_slide.click
		@browser.gsm_filter_submit_button.click	
		@browser.wait_for_landing_page_load
		
		@matured_product, @physical_product = @browser.add_products_to_cart(@results_from_file, @start_page, @params)
		@browser.validate_pur(@params)
		
		#Proceed with checkout if True
		unless @params["continue_checkout"]
			$tracer.trace("This will not proceed with Checkout")
		else
			$tracer.trace("Continue Secure Checkout")
			@browser.continue_checkout_button_handling.click
			@browser.wait_for_landing_page_load
			@browser.buy_as_login_button.click
			@browser.wait_for_landing_page_load
			
			# Login with invalid password
			@wrong_password = 'fjdklajk32322'
			i = 1
			attempts = 5
			while i < attempts do
				@browser.enter_login_credentials(@user_name, @wrong_password)
				@browser.user_login_button.click
				@browser.wait_for_landing_page_load
				validate_login_error
				i += 1
			end
			@browser.enter_login_credentials(@user_name, @wrong_password)
			@browser.user_login_button.click
			@browser.wait_for_landing_page_load
			validate_login_max_attempt_error
		end
	end
	
end
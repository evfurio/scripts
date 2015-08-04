# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\validate_adroll_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --browser chrome --range TFS57942 -e 'TFS57942'  --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "#{ENV['QAAUTOMATION_TOOLS']}/QAAutomation/common/src/qaautomation_formatter.rb"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

describe "Check for ADROLL script" do

  before(:all) do
    $options.default_timeout = 30_000
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    # @browser_type = $global_functions.browser

    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
  end

  before(:each) do
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @browser = WebBrowser.new(browser_type_parameter)
    $snapshots.setup(@browser, :all)
    @browser.delete_internet_files(browser_type_parameter)
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
    $tc_desc = $global_functions.desc
    $tc_id = $global_functions.id
    $tc_desc = "Test case description was not found" if $tc_desc == "" || $tc_desc == nil
    $tracer.report("Executed Test :#{$tc_id} #{$tc_desc}")
		
		@browser.open(@start_page)
		@browser.wait_for_landing_page_load
  end

  after(:each) do
    @browser.return_current_url
    @browser.close_all()
  end

	it "TFS57939" do
		$tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, '', @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
  end
	
	it "TFS57941" do
    @browser.validate_cookies_and_tags(@params)
  end
	
  it "TFS57942" do
    @browser.open("#{@start_page}/Profiles/OrderTrackingLogin.aspx")
		@browser.order_lookup_email.value = "robertsantos@gamestop.com"
		@browser.order_lookup_confirmation_number.value = "4131015095782760"
		@browser.order_lookup_button.click
		@browser.wait_for_landing_page_load
		@browser.validate_cookies_and_tags(@params)
  end
	
	it "TFS57944" do
		$tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, '', @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
  
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Click Checkout As Guest")
		@browser.chkoutbuy_as_guest_button.click

		$tracer.trace("Fill Out Shipping Address Form")
		@browser.fill_out_shipping_form(@params)
		@browser.validate_cookies_and_tags(@params)
		
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Billing Address Info (Physical).")
		@browser.fill_out_billing_form(@params)
		@browser.validate_cookies_and_tags(@params)
	end

	
	it "TFS58266" do
    @browser.log_in_link.click
    @browser.log_in(@login, @password)
		@browser.open("#{@start_page}/Profiles/MyAccount.aspx")
		@browser.wait_for_landing_page_load
		@browser.validate_cookies_and_tags(@params)
	end

	it "TFS58267" do
    @browser.log_in_link.click
    @browser.log_in(@login, @password)
		@browser.search_button.click
		@browser.wait_for_landing_page_load
		@browser.validate_cookies_and_tags(@params)
	end
	
	it "TFS58289" do
		add_product_to_cart_as_authenticated_user
	end

	it "TFS58290" do
		@browser.log_in_link.click
    @browser.log_in(@login, @password)
		@browser.wait_for_landing_page_load
		@browser.validate_cookies_and_tags(@params)
	end
		
	it "TFS58292" do
    @browser.order_history_link.click
		@browser.wait_for_landing_page_load	
    @browser.log_in(@login, @password)
		# @browser.open("#{@start_page}/Orders/OrderHistory.aspx")
		@browser.wait_for_landing_page_load
		@browser.validate_cookies_and_tags(@params)
	end

  it "TFS58300" do
    @browser.log_in_link.click
    @browser.log_in(@login, @password)
    @browser.open("#{@start_page}/ps3")
		@browser.wait_for_landing_page_load	
		@browser.validate_cookies_and_tags(@params) 
  end
	
	it "TFS58265" do
		add_product_to_cart_as_authenticated_user
		
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		@browser.validate_cookies_and_tags(@params)
	end

	it "TFS58293" do
		add_product_to_cart_as_authenticated_user
	
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		@browser.validate_cookies_and_tags(@params)
		
		if @matured_product
      @browser.handle_mature_product_screen(@params) unless @params["use_paypal_at_cart"]			
    end
		
		$tracer.trace("Enter Shipping Address Info.")
		@browser.fill_out_shipping_form(@params)
		@browser.validate_cookies_and_tags(@params)
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Billing Address Info (Physical).")
		@browser.fill_out_billing_form(@params)
		@browser.validate_cookies_and_tags(@params)
	end
	
	it "TFS58294" do
		add_product_to_cart_as_authenticated_user
	
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		@browser.validate_cookies_and_tags(@params)
		
		if @matured_product
      @browser.handle_mature_product_screen(@params) unless @params["use_paypal_at_cart"]			
    end
		
		$tracer.trace("Enter Shipping Address Info.")
		@browser.fill_out_shipping_form(@params)
		@browser.validate_cookies_and_tags(@params)
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Billing Address Info (Physical).")
		@browser.fill_out_billing_form(@params)
		@browser.validate_cookies_and_tags(@params)
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Handling Options")
		@browser.enter_handling_options(@params)
	end
 
	it "TFS58295" do
		add_product_to_cart_as_authenticated_user
	
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		@browser.validate_cookies_and_tags(@params)
		
		if @matured_product
      @browser.handle_mature_product_screen(@params) unless @params["use_paypal_at_cart"]			
    end
		
		$tracer.trace("Enter Shipping Address Info.")
		@browser.fill_out_shipping_form(@params)
		@browser.validate_cookies_and_tags(@params)
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Billing Address Info (Physical).")
		@browser.fill_out_billing_form(@params)
		@browser.validate_cookies_and_tags(@params)
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Handling Options")
		@browser.enter_handling_options(@params)
		
		$tracer.trace("Payment Info")
		@browser.validate_cookies_and_tags(@params)
	end
 
 	it "TFS58296" do
		add_product_to_cart_as_authenticated_user
	
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		@browser.validate_cookies_and_tags(@params)
		
		if @matured_product
      @browser.handle_mature_product_screen(@params) unless @params["use_paypal_at_cart"]			
    end
		
		$tracer.trace("Enter Shipping Address Info.")
		@browser.fill_out_shipping_form(@params)
		@browser.validate_cookies_and_tags(@params)
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Billing Address Info (Physical).")
		@browser.fill_out_billing_form(@params)
		@browser.validate_cookies_and_tags(@params)
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Handling Options")
		@browser.enter_handling_options(@params)
		
		$tracer.trace("Enter Credit Card Info")
		@browser.wallet_label.value = "-- Select a Card--" if @browser.wallet_label.exists
		@browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])
		@browser.validate_cookies_and_tags(@params)
		
		$tracer.trace("Submitted Order")
		order_num = @browser.submit_and_confirm_order(@params, @condition)
	end

	it "TFS58297" do
		@product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
		@product_urls.each_with_index do |url|
			$tracer.trace("Product Url: #{url}")
			@browser.open("#{@start_page}#{url}")
			@browser.validate_cookies_and_tags(@params)
		end
	end
	
	
  def add_product_to_cart_as_authenticated_user
		@open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
		@cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
    @cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)
	
		$tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
		
		@browser.log_in_link.click
    @browser.log_in(@login, @password)
		@browser.wait_for_landing_page_load
		
		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, '', @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
	end

end

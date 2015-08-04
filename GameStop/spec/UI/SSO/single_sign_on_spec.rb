# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\SSO\single_sign_on_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\SSO\single_sign_on_dataset.csv --range TFS59609 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "#{ENV['QAAUTOMATION_TOOLS']}/QAAutomation/common/src/qaautomation_formatter.rb"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()
$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
$tc_desc = "Test case description was not found" if $tc_desc == "" || $tc_desc == nil

describe "Single Sign-On" do

  before(:all) do
    $options.default_timeout = 30_000
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @browser_type = $global_functions.browser

    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    $tracer.trace("THIS IS THE BROWSER TYPE #{@browser_type}")
    @browser = WebBrowser.new(@browser_type)
    @browser.delete_internet_files(@browser_type)
    $snapshots.setup(@browser, :all)
    @browser.delete_all_cookies_and_verify
  end

  before(:each) do
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @session_id = generate_guid
    $tracer.report("Executed Test :#{$tc_id} #{$tc_desc}")
  end

  after(:each) do
    @browser.return_current_url
    @browser.close_all()
  end

  it "TFS60273 SSO Cookie verification on gamestop.com" do
    #Cookie verification on gamestop.com
    @browser.open(@start_page)
    @browser.my_cart_button.click
    @browser.log_in_link.click
    @browser.url.should include ('https://')
    @browser.log_in(@login, @password)
		sleep 3
    @browser.validate_cookies(:authenticated_cart)
    @browser.log_out_link.should_exist
    @browser.log_out
		sleep 3
    @browser.validate_cookies(:au_cart_no_tickets)
  end

  # it "Weekly Ad Login" do
    # @browser.open(@start_page)
    # @browser.weekly_ad_link.click
    # @browser.log_in_link.click
    # @browser.url.should include ('https://')
    # @browser.log_in(@login, @password)
    # @browser.log_out_link.should_exist
    # @browser.log_out
    # @browser.validate_cookies(:au_cart_no_tickets)
  # end

  it "TFS60275" do
    @browser.open("#{@start_page}")
    @browser.log_in_link.click
    @browser.url.should include ('https://')
    @browser.log_in(@login, @password)
    @browser.my_account_link.click
		sleep 3
    @browser.validate_cookies(:secure_auth_user)
    @browser.url.should include ('https://')
    @browser.wish_list_link.click
		sleep 3
    @browser.validate_cookies(:secure_auth_user)
    @browser.url.should include ('https://')
    @browser.log_out
		sleep 3
    @browser.validate_cookies(:au_cart_no_tickets)
  end

  it "TFS60276" do
    #Authenticated user on an unsecure page
    @browser.open("#{@start_page}")
    @browser.log_in_link.click
    @browser.log_in(@login, @password)
    @browser.url.should == ("#{@start_page}/")
    @browser.my_account_link.click
		sleep 3
    @browser.validate_cookies(:au_cart_no_tickets)
    @browser.url.should include ('https://')
    @browser.wish_list_link.click
		sleep 3
    @browser.validate_cookies(:au_cart_no_tickets)
    @browser.url.should include ('https://')
    @browser.gamestop_logo_link.click
		sleep 3
    @browser.validate_cookies(:unsecure_auth_user)
    @browser.url.should == ("#{@start_page}/")
    @browser.log_out
    @browser.url.should == ("#{@start_page}/")
  end

  it "TFS60309" do
    @browser.open(@start_page)
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
    url = @product_urls[0]
    @browser.open("#{@start_page}#{url}")
    product_name_start = @browser.product_title_label.innerText
    @browser.log_in_link.click
    @browser.url.should include ('https://')
    $tracer.trace(@browser.url)
    @browser.log_in(@login, @password)
    product_name_return = @browser.product_title_label.innerText
    product_name_start.should == product_name_return
    $tracer.trace("should redirect to product details page after login")
    @browser.url.should == "#{@start_page}#{url}"
  end

  it "TFS60310" do
    #Test: Verify referring URL after logging in on GS checkout
    @browser.open(@start_page)
    @browser.url.should include ('http://')
		@open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
		@cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
		@cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)

    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
    @browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, "", @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
    # #Verify cart occurs in the add_products_to_cart_by_url functional steps.  Each product added is validated as it is added.
    @browser.log_in_link.click
    @browser.url.should include ('https://')
    @browser.log_in(@login, @password)
		sleep 5
    @browser.url.should include ('https://')
    @browser.url_data.full_url.split('/').last.should == "Checkout"
    $tracer.trace("should redirect to Cart page after login")
    @browser.check_cart_subtotal_and_discount(@params)
  end

	it "TFS59613" do
    #Cookie verification on gamestop.com
    @browser.open(@start_page)
    @browser.my_cart_button.click
    @browser.log_in_link.click
    @browser.url.should include ('https://')
    @browser.log_in(@login, @password)
		sleep 3
		@browser.profile_account_name.innerText.should == @params["ship_first_name"]
		$tracer.trace("Account Name in Header   ::::  #{@browser.profile_account_name.innerText}")
    @browser.validate_cookies(:authenticated_cart)
  end
	
  it "TFS59609" do
    @browser.open(@start_page)
    @browser.url.should include ('http://')
		@browser.open("#{@start_page}/ps3")
		sleep 3
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
    @browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, "", @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
    @browser.continue_checkout_button.click
    @browser.wait_for_landing_page_load
		@browser.username_field.value = @login
		@browser.password_field.value = @password
		@browser.log_in_button.click
		@browser.wait_for_landing_page_load
    @browser.log_out_link.click
		@browser.wait_for_landing_page_load
		$tracer.trace("URL: " + @browser.url)
    @browser.url.should == @start_page+'/'
  end

  # it "TFS60292" do
    # pending("Not implemented yet")
  # end

  # it "TFS60299" do
    # pending("Not implemented yet")
  # end

  # it "TFS60300" do
    # pending("Not implemented yet")
  # end

  # it "TFS60302" do
    # pending("Not implemented yet")
    # # check cookies for hard login, then set GS.Ticket to short expiry period (becomes soft login) and check cookies again
  # end

end

# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\SSO\single_sign_on_web_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\SSO\single_sign_on_dataset.csv --range TFS60276 --login bf_gsdc85@qagsecomprod.oib.com --password T3sting --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "#{ENV['QAAUTOMATION_TOOLS']}/QAAutomation/common/src/qaautomation_formatter.rb"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()
$tc_desc = $global_functions.desc
$tc_ID = $global_functions.ID

	if $tc_desc == "" || $tc_desc == nil
		$tc_desc = "Test case description was not found"
	end

describe "Single Sign-On" do

	before(:all) do
    @browser = WebBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 30_000
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
	end

	before(:each) do
    @browser.delete_all_cookies_and_verify

		@session_ID = generate_guID
    @open_ID = @account_svc.perform_authorization_and_return_user_and_open_ID(@session_ID, @login, @password, @account_svc_version)
    @cart_ID = @profile_svc.perform_get_cart_ID(@open_ID, @session_ID, 'GS_US', @profile_svc_version)
    @cart_svc.perform_empty_cart(@session_ID, @cart_ID, 'GS_US', 'en-US', @cart_svc_version)
	end

  after(:each) do
    @browser.return_current_url
  end

	after(:all) do
		@browser.close_all()
	end
  
	it "#{$tc_ID} #{$tc_desc}" do
	
		if @params["ID"] == "TFS60273" or @params["ID"] == "TFS60275" or @params["ID"] == "TFS60276"
			#Perform TFS60273 
			@browser.open(@start_page)
			@browser.verify_cookies_before_login_from_gs  
			@browser.log_in_link.click
			@browser.wait_for_landing_page_load
			@browser.log_in(account_login_parameter, account_password_parameter)
			$tracer.trace("Verify the authenticated user cookies on GS.com")
			@browser.verify_cookies_after_login_from_gs
			
			#Perform TFS60275
			@browser.open("#{@start_page}/Profiles/MyAccount.aspx")
			$tracer.trace("Verify cookies from Account Details page")
			@browser.verify_cookies_after_login_from_gs
			
			@browser.open("#{@start_page}/Profiles/WishList.aspx")
			$tracer.trace("Verify cookies from Wish List page")
			@browser.verify_cookies_after_login_from_gs
			
			@browser.open("#{@start_page}/Orders/OrderHistory.aspx")
			$tracer.trace("Verify cookies from Order History page")
			@browser.verify_cookies_after_login_from_gs
			
			#Perform TFS60276
			#Go back to GS.com - authenticated user on an unsecure page
			@browser.open(@start_page)
			$tracer.trace("Verify cookies for an authenticated user on an unsecure page")
			@browser.verify_unsecure_auth_user_cookies
		end
		
		if @params["ID"] == "TFS60284" or @params["ID"] == "TFS60285"
			@browser.open("#{@start_page}/PowerUpRewards")
			@browser.wait_for_landing_page_load
			@browser.div.ID("login").find.a.href("/LogOn/").click
			@browser.input.ID("UserName").value = account_login_parameter
			@browser.input.ID("Password").value = account_password_parameter
			@browser.input.ID("KeepMeSignedIn").click
			@browser.input.className("/hIDeOnClick/").click
			@browser.wait_for_landing_page_load
			$tracer.trace("Verify cookies after login from PUR")
			@browser.verify_cookies_after_login_from_pur
			
			#SignOut from PUR
			@browser.div.className("manage-account").find.a.href("/LogOff/").click
			@browser.wait_for_landing_page_load
			$tracer.trace("Verify cookies after logout from PUR")
			@browser.verify_cookies_after_logout_from_pur
			sleep 30
		end
		
		if @params["ID"] == "TFS60288" or @params["ID"] == "TFS60289"
			@browser.open("#{@start_page}/Checkout")
			@browser.log_in_link.click
			@browser.wait_for_landing_page_load
			@browser.log_in(account_login_parameter, account_password_parameter)
			$tracer.trace("Verify the authenticated user cookies on GS Checkout")
			@browser.verify_cookies_after_login_from_gs
			
			#SignOut from GS Checkout
			@browser.log_out_link.click
			$tracer.trace("Verify cookies after logout from GS Checkout")
			@browser.verify_cookies_after_logout_from_gs
		end
		
		if @params["ID"] == "TFS60309"
			@browser.open(@start_page)
			$tracer.trace("Get products")
			@product_urls, @matured_product, @physical_product, @condition = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_ID)
			@product_urls.each do |url|
				@browser.open("#{@start_page}#{url}")
				@browser.wait_for_landing_page_load
			end
			@browser.log_in_link.click
			@browser.log_in(account_login_parameter, account_password_parameter)		

			puts "should redirect to product details page after login"
			
		end
				
		if @params["ID"] == "TFS60310"
			@browser.open(@start_page)
			$tracer.trace("Get products")
			@product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_ID)
			@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_ID, @cart_ID, @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
			@browser.log_in_link.click
			@browser.log_in(account_login_parameter, account_password_parameter)
			
			puts "should redirect to My Cart page after login"
		end		
		
		
		####################################################################
		###   The items below are GAMESTOP MOBILE specific scenarios.    ###  
		####################################################################
		
		if @params["ID"] == "TFS60286" or @params["ID"] == "TFS60287"  or @params["ID"] == "TFS60304"
			@browser.open("#{@start_page}/poweruprewards/account/logon")
			@browser.input.ID("UserName").value = account_login_parameter
			@browser.input.ID("Password").value = account_password_parameter
			@browser.input.ID("KeepMeSignedIn").click
			@browser.a.className("/login-button/").click
			@browser.wait_for_landing_page_load
			$tracer.trace("Verify cookies after login from Mobile PUR")
			@browser.verify_cookies_after_login_from_pur
			
			#SignOut from GS Mobile PUR
			@browser.a.className("/ui-btn-up-a/").click
			@browser.wait_for_landing_page_load
			$tracer.trace("Verify cookies after logout from Mobile PUR")
			@browser.verify_cookies_after_logout_from_pur
			#GS.Ticket and GS.TicketLong should not be visible
		end
		
		
		if @params["ID"] == "TFS60291" or @params["ID"] == "TFS60292" or @params["ID"] == "TFS60294" or @params["ID"] == "TFS60295"
			@browser.open("#{@start_page}/Account/Login")
			$tracer.trace("Verify cookies before login from Mobile")
			@browser.verify_cookies_before_login_from_mobile
			
			#@browser.log_in_link.click
			#@browser.log_into_my_account_button.click
			#@browser.email_address_field.value = account_login_parameter
			#@browser.password_field.value = account_password_parameter
			#@browser.log_in_button.click
			
			#@browser.li.ID("login_link").find.a.href("/Login/").click
			@browser.li.ID("log_in_link").find.button.click
			@browser.wait_for_landing_page_load
			
			@browser.input.ID("UserName").value = account_login_parameter
			@browser.input.ID("Password").value = account_password_parameter
			@browser.section.ID("log_in_form").find.button.click
			@browser.wait_for_landing_page_load
			sleep 5
			$tracer.trace("Verify cookies after login from Mobile Non Secure")
			@browser.verify_cookies_after_login_from_mobile_non_secure
			
			@browser.open("https://m.qa.gamestop.com/Orders/OrderHistoryLogin")
			@browser.wait_for_landing_page_load
			sleep 5
			$tracer.trace("Verify cookies after login from Mobile Secure")
			@browser.verify_cookies_after_login_from_mobile_secure
			
			@browser.li.ID("login_link").find.a.href("/Logout/").click
			@browser.wait_for_landing_page_load
			$tracer.trace("Verify cookies after logout from Mobile")
			@browser.verify_cookies_after_logout_from_mobile
		end
	
		if @params["ID"] == "TFS60296" or @params["ID"] == "TFS60297" or @params["ID"] == "TFS60299" or @params["ID"] == "TFS60300" or @params["ID"] == "TFS60302"
			#@browser.open("https://m.qa.gamestop.com/checkout")
			@browser.open(@start_page)
			@browser.li.ID("nav_cart").find.a.click
			@browser.li.ID("login_link").find.a.href("/Login/").click
			@browser.li.ID("log_in_link").find.button.click
			@browser.wait_for_landing_page_load
			sleep 5
			$tracer.trace("Verify cookies before login from Mobile")
			@browser.verify_cookies_before_login_from_mobile
			
			@browser.input.ID("EmailAddress").value = account_login_parameter
			@browser.input.ID("Password").value = account_password_parameter
			@browser.button.className("ats-loginbtn").click
			@browser.wait_for_landing_page_load
			sleep 5
			$tracer.trace("There are a total of #{@browser.get_all_cookies.length} cookies.")
			$tracer.trace("Verify cookies after login from Mobile Checkout Secure")
			@browser.verify_cookies_after_login_from_mobile_secure
			
			@browser.h1.find.a.click
			@browser.wait_for_landing_page_load
			sleep 5
			
			$tracer.trace("There are a total of #{@browser.get_all_cookies.length} cookies.")
			@browser.get_all_cookies.each { |c|
				retrieved_cookie = @browser.cookies.get(c.name)[0]
				puts "#{c.name}"
			}
			
			$tracer.trace("Verify cookies after login from Mobile Checkout Non Secure")
			@browser.verify_cookies_after_login_from_mobile_non_secure
			
			@browser.li.ID("login_link").find.a.href("/Logout/").click
			@browser.wait_for_landing_page_load
			$tracer.trace("Verify cookies after logout from Mobile")
			@browser.verify_cookies_after_logout_from_mobile
		end
	
		if @params["ID"] == "TFS60301"
			@browser.open("#{@start_page}/poweruprewards/account/logon")
			@browser.input.ID("UserName").value = account_login_parameter
			@browser.input.ID("Password").value = account_password_parameter
			@browser.input.ID("KeepMeSignedIn").click
			@browser.a.className("/login-button/").click
			@browser.wait_for_landing_page_load

			@browser.open(@start_page)
			@browser.wait_for_landing_page_load
			sleep 5
			$tracer.trace("Verify cookies after login from Mobile PUR Non Secure")
			@browser.verify_cookies_after_login_from_pur_non_secure
		end

		if @params["ID"] == "TFS60298"
			@browser.open(@start_page)
			@browser.li.ID("nav_cart").find.a.click
			@browser.li.ID("login_link").find.a.href("/Login/").click
			@browser.li.ID("log_in_link").find.button.click
			@browser.wait_for_landing_page_load
			
			@browser.input.ID("EmailAddress").value = account_login_parameter
			@browser.input.ID("Password").value = account_password_parameter
			@browser.button.className("ats-loginbtn").click
			@browser.wait_for_landing_page_load
			sleep 5
			
			@browser.get_specific_cookie("GS.Ticket")

			$tracer.trace("Verify cookies after login from Mobile Checkout Secure")
			@browser.verify_cookies_after_login_from_mobile_secure
		end

	end
	
end
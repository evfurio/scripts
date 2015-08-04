require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

######## Powershell Command ################
# d-Con.bat --range QA1 --csv %QAAUTOMATION_SCRIPTS%\Impulse\spec\impulse_sanity_variables.csv %QAAUTOMATION_SCRIPTS%\Impulse\spec\impulse_sanity.rb --browser chrome --or


describe "Impulse Sanity Suite" do

    before(:all) do
		########## This script is run using impulse_sanity_variables.csv ###########
        csv = QACSV.new(csv_filename_parameter)
        @row = csv.find_row_by_name(csv_range_parameter)

        # Environment Prefix to use in URLs
        @web_env_prefix = ("http://" + @row.find_value_by_name("Env_Prefix"))
        @secure_env_prefix = ("https://" + @row.find_value_by_name("Env_Prefix"))

        # URL domains to use and validate against
        @web_domain = "www.impulsedriven.com/"
        @store_domain = "impulsestore.gamestop.com/"
        @developer_domain = "developer.impulsedriven.com/"
		# @forums_domain = "forums.impulsedriven.com/"

        @web_start_page = (@web_env_prefix + @web_domain)
		@store_start_page = (@web_env_prefix + @store_domain + "cart.aspx")
        @cart_logout =  "#{@secure_env_prefix}#{@store_domain}logout"
		@redemption_start_page = (@web_env_prefix + @store_domain + "redeempos")
		@developer_start_page = (@secure_env_prefix + @developer_domain)
		# @forums_start_page = (@secure_env_prefix + @forums_domain)
		       
        @browser = ImpulseBrowser.new(browser_type_parameter)
        
        $snapshots.setup(@browser, :all)
        $tracer.mode = :on
        $tracer.echo = :on
    end
	
    after(:all) do
        $tracer.trace("after :all")
        @browser.close_all
    end
	
	# Validating Home page displays - main header items
	it "WEB - should have a proper header and footer" do
		@browser.open(@web_start_page)
		
		# Verify header links
        @browser.gamestop_logo_pc_downloads_link.should_exist
        @browser.view_cart_link.should_exist
        @browser.checkout_link.should_exist
        @browser.genres_menu_list.should_exist
        @browser.publishers_menu_list.should_exist
        @browser.browse_by_menu_list.should_exist

        # @browser.forums_button.should_exist
        @browser.support_button.should_exist

        @browser.search_field.should_exist
        @browser.search_button.should_exist

		list = @browser.featured_games_list
        list.should_exist
		
		# Verify footer links
		@browser.part_of_the_gamestop_network_logo_link.should_exist
		@browser.gamestop_logo_link.should_exist
		@browser.gameinformer_logo_link.should_exist
		@browser.kongregate_logo_link.should_exist
		@browser.buymytronics_logo_link.should_exist
		@browser.about_label.should_exist
		@browser.genres_label.should_exist
		@browser.categories_label.should_exist
		@browser.keep_in_touch_label.should_exist
		@browser.corporate_link.should_exist
		@browser.about_impulse_link.should_exist
		@browser.developers_link.should_exist
		@browser.developers_tools_link.should_exist
		@browser.action_link.should_exist
		@browser.adventure_link.should_exist
		@browser.casual_link.should_exist
		@browser.indie_publishers_link.should_exist
		@browser.mmo_link.should_exist
		@browser.puzzle_link.should_exist
		@browser.rpgs_link.should_exist
		@browser.shooters_link.should_exist
		@browser.simulation_link.should_exist
		@browser.sports_link.should_exist
		@browser.staff_picks_link.should_exist
		@browser.strategy_link.should_exist
		@browser.top_sellers_link.should_exist
		@browser.new_releases_link.should_exist
		@browser.on_sale_link.should_exist
		@browser.coming_soon_link.should_exist
		@browser.support_link.should_exist
		@browser.gamestop_events_link.should_exist
		# @browser.forums_link.should_exist
		@browser.impulse_copyright_link.should_exist
		@browser.license_link.should_exist
		@browser.sales_faq_link.should_exist
		@browser.privacy_policy_link.should_exist
		@browser.return_policy_link.should_exist
		@browser.terms_of_service_link.should_exist
		@browser.connect_label.should_exist
		@browser.twitter_link.should_exist
		@browser.facebook_link.should_exist
		@browser.announcements_rss_link.should_exist
    end
	
	# Validating Support page displays
	it "WEB - should verify the Support header link is correct" do	
		#Goes to the Home Page
		@browser.open(@web_start_page)

		@browser.support_button.click
		
		# Verify support page is displayed by looking for Support label
		@browser.support_label.should_exist
		
		# Checking support page URL
		@browser.url.should == @web_env_prefix + @web_domain + 'support'
		
	end
	
	# Validating About page
	it "WEB - should verify About page is correct" do
		#Goes to the Home Page
		# Workaround for IE Selenium
		# @browser.open(@web_start_page)
		@browser.open(@web_start_page + 'about')
		
		# Validates Download Now area link
		# Issue with IE Selenium - doesn't actually click on the area link
		# @browser.download_now_link.click
		
		@browser.pc_downloads_app_label.exists
		@browser.download_now_button.exists
		
		# Checking about page URL
		@browser.url.should == @web_env_prefix + @web_domain + 'about'
     	
	end
	
	 # Validating Publisher page
	 it "WEB - should have a publishers header menu that links to correct page" do
        @browser.open(@web_start_page)
		
		publishers_string = "Electronic Arts"

		menu = @browser.publishers_menu_list
		menu.should_exist
	
		item = menu.find(publishers_string)
		$tracer.trace("Publisher : " + publishers_string)
		item.inner_text.should == publishers_string
		
		item.click
		
		#Verify first result in page has correct publisher
		@browser.product_list.at(0).product_publisher_label.inner_text.should == publishers_string
		
		#Code added to convert uppercase to lowercase and convert spaces into _
		@browser.url.should == @web_env_prefix + @web_domain + 'publisher/' + (publishers_string.downcase).tr(' ','_')
			
    end
	
	# Validating Catalog page
	it "WEB - should have a genres header menu that links to a catalog page" do
		@browser.open(@web_start_page)
		
        genre_string = "Shooters" 

		menu = @browser.genres_menu_list
		menu.should_exist
		
		item = menu.find(genre_string)
		$tracer.trace("Genre : " + genre_string)
		item.inner_text.should == genre_string
		
		item.click
		
		# Verify first result in page contains correct genre
		@browser.product_list.at(0).product_genre_label.inner_text.should include genre_string
		
		@browser.url.should == @web_env_prefix + @web_domain + 'explore/games/first-person_shooters'

    end
	
	it "WEB - should validate age gate functions correctly" do
		@browser.open(@web_start_page)

		# Search for product with age gate and EULA
		@browser.search_field.value = "Dragon Age 2"
		@browser.search_button.click
		
		#Verify you are on the Search Results page for searched product
		list = @browser.product_list
		list.should_exist
		item = list.at(0)

		item.product_title_link.inner_text.should == "Dragon Age 2"
		
		@browser.url.should == @web_env_prefix + @web_domain + 'explore'
		
		item.product_title_link.click
		
		# Verify age gate page displays
		@browser.age_verification_label.should_exist
		@browser.year_selector.value = "1948"
		@browser.month_selector.value = "February"
		@browser.day_selector.value = "29"
		@browser.submit_button.click
		
		#Verify the Product Detail page is displayed
		@browser.product_header_label.should_exist
		
	end
	
	# Validating product detail page
	it "WEB/STORE - should search product and validate product detail page" do
		@browser.open(@web_start_page)
		@browser.search_field.value = "gShift"
		@browser.search_button.click
		
		#Verify you are on the Search Results page for gShift
		list = @browser.product_list
		list.should_exist
		item = list.at(0)

		item.product_title_link.inner_text.should == "gShift"
		
		@browser.url.should == @web_env_prefix + @web_domain + 'explore'
		
		item.product_title_link.click
		
		#Verify the Product Detail page is displayed
		@browser.product_header_label.should_exist
		
		@browser.add_to_cart_button.click
		
		#Verify item added to cart
		@browser.cart_list.at(0).product_name_link.should_exist

	end
	
	# Validating making a purchase with a new account and CC
    it "STORE - should create a new account and buy a product using CC during checkout process" do
		
		# empty cart on guest (note: could have been already emptied)
		@browser.open(@cart_logout)
		@browser.log_out_cart
		@browser.empty_cart
		
        user_name = auto_generate_username(nil, @row.find_value_by_name("Server") + "@gspcauto.fav.cc","ottomatin_")
        password = @row.find_value_by_name("Password")
        first_name = @row.find_value_by_name("First_Name")
        last_name = @row.find_value_by_name("Last_Name")

        # Verify cart is empty
        @browser.empty_cart_label.should_exist #TODO Add to empty_cart dsl

        # Add Really Big Sky to cart
        @browser.open(@secure_env_prefix + @store_domain +"cart.aspx?add&productID=" +  @row.find_value_by_name("ProductID") + "&theme=impulse")

        # Verify the product is in the cart
		@browser.cart_list.at(0).product_name_link.should_exist

        # Click Checkout
        @browser.checkout_button.click

        #Create New User
        @browser.create_account(user_name, password)

        @browser.success_page_label.should_exist
        @browser.come_on_in_button.click 

        # Kept for use with new user setup
		@browser.enter_address(first_name, last_name, "123 High Point Dr", "Irving", "Texas", "75038", "999-999-9999")

        @browser.continue_button.click
		
        # Enter CC Info
		@browser.enter_credit_card_info("Visa", "4222222222222", "#{first_name} #{last_name}", "03", "2014", "gs01")

        @browser.continue_button.click

        # Submit the Order
        @browser.submit_order_button.click

        link = @browser.order_number_link
        link.should_exist
        $tracer.trace("Order Number: " + link.innerText)

        # Empty cart in preparation for next test
        @browser.impulse_logo_link.click	
		@browser.view_cart_link.click
		@browser.cart_logout_link.click
		@browser.empty_cart
		

    end
	
	# Commenting out scenario due to PayPal changes
	# # Validating making a gift purchase with an existing account and Paypal
	it "STORE - should make a gift purchase with an existing account using PayPal" do

		@browser.open(@cart_logout)
		@browser.log_out_cart
		@browser.empty_cart
	
		# set some variables, use defined functions above
		user_name = @row.find_value_by_name("No_Fraud_Account_Email")
		giftee_user_name = auto_generate_username(nil, @row.find_value_by_name("Server") + "@gspcauto.fav.cc","ottomatin_")
		password = @row.find_value_by_name("Password")


		# # Make sure user is logged out of PayPal test store
		# @browser.open("https://www.sandbox.paypal.com/us/cgi-bin/webscr?cmd=_login-submit")
		# if @browser.paypal_personal_tab.exists
		   # then  @browser.paypal_logout_link.click
		# else 
			# @browser.paypal_master_login_link.click
		# end
		
		# # Log into PayPal sandbox - login is now a popup
		# @browser.paypal_master_start_login_button.click
		# $tracer.trace("BROWSER: " + browser_type_parameter)
		
		# if browser_type_parameter == "ie-webspec" then
			# @browser.paypal_master_email_field.value = @row.find_value_by_name("Paypal_Primary_Email")
			# @browser.paypal_master_password_field.value = password
			# @browser.paypal_master_login_button.click
			# @browser.open(@web_start_page)
		# else
			# @browser.browser(1).paypal_master_email_field.value = @row.find_value_by_name("Paypal_Primary_Email")
			# @browser.browser(1).paypal_master_password_field.value = password
			# @browser.browser(1).paypal_master_login_button.click
			# # Verify cart is empty - goes from web home page to cart to confirm no certificate issue
			# @browser.browser(0).open(@web_start_page)
		# end
		
		@browser.view_cart_link.click
		@browser.empty_cart_label.should_exist	
		
		# Add Really Big Sky to cart
		@browser.open(@secure_env_prefix + @store_domain +"cart.aspx?add&productID=" +  @row.find_value_by_name("ProductID") + "&theme=impulse")
		
		# Verify a product is in the cart
		@browser.cart_list.at(0).remove_link.should_exist
		
		# Apply coupon code to lower the cost charged to paypal
		@browser.coupon_field.value = @row.find_value_by_name("Order_Wide_Coupon")
		@browser.apply_coupon_button.click
		@browser.cart_remove_coupon_link.should_exist
		
		# Login with existing user
		@browser.login_link.click
		@browser.log_in(user_name, password)
		
		# Click Purchase as a Gift
		@browser.purchase_as_gift_button.click
		
		# Enter gift information
		@browser.email_or_nickname_field.value = giftee_user_name
		@browser.confirm_email_or_nickname_field.value = giftee_user_name
		@browser.message_field.value = "test gift order message"
		@browser.continue_button.click
		
		# Select PayPal button and continue
		@browser.payment_method_buttons.value = "Pay using PayPal"
		@browser.continue_button.click
		
		# User is taken to sandbox test store b/c they're already logged into the main test area
		@browser.paypal_test_acct_login_field.value = @row.find_value_by_name("Paypal_Secondary_Email")
		@browser.paypal_test_acct_password_field.value = password
		@browser.paypal_test_acct_login_button.click
		
		# # Policy acceptance page - No longer needed 
		# @browser.paypal_policy_consent_checkbox.click
		# @browser.paypal_agree_button.click
		
		# verify user is logged in and on the specify payment/shipping/billing info page
		@browser.paypal_shipping_address_panel.exists
	
		# select a payment shipping address (a test account can have multiple shipping addresses...)
		@browser.paypal_test_acct_continue_button.click
		
		# Submit the order
		@browser.submit_order_button.click
		link = @browser.order_number_link
		link.should_exist
		$tracer.trace("Order Number: " + link.inner_text)
		
		# Empty cart in preparation for next test	
		@browser.impulse_logo_link.click	
		@browser.view_cart_link.click
		@browser.cart_logout_link.click
		@browser.empty_cart
	
	end
	
	it "STORE - should create an account and redeem a product" do
	
		@browser.open(@redemption_start_page)
		
		user_name = auto_generate_username(nil, @row.find_value_by_name("Server") + "@gspcauto.fav.cc","ottomatin_")
        password = @row.find_value_by_name("Password")
		
		 #Create New User
        @browser.create_account(user_name, password)
		
        @browser.success_page_label.should_exist
        @browser.come_on_in_button.click 
		
		# Validate 'Redeem Code' page
		@browser.redemption_welcome_user_label.should_exist
		@browser.redemption_receipt_image.should_exist
		
		# Connect to the database to retrieve a valid redemption code
		db = DbManager.new("DL1SCQDB04SQL17.TESTECOM.PVT\\INST17","Store")
		$tracer.trace("#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/spec/getredemptioncode.sql")
		results = db.exec_sql_from_file("#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/spec/getredemptioncode.sql")
		# results = db.exec_sql("select top 1 Code from store.dbo.store_RedemptionCodes where OrderDetailID is null and ProdID = 'ESD-QA1-AUTO1';")
		
		# Use returned redemption code to redeem
		@browser.redemption_code_field.value = results.at(0).Code
		@browser.redemption_captcha_text_field.should_exist
		@browser.redemption_captcha_image.should_exist
		@browser.redemption_redeem_button.click
		
		# Validate the 'Get the GameStop App' page
		@browser.redemption_download_now_button.should_exist
		@browser.redemption_continue_button.click
		
		# Validate the 'Download Your Game!' page
		@browser.redemption_download_your_game_label.should_exist
		@browser.redemption_all_set_label.should_exist
		
		@browser.open(@redemption_start_page)
		@browser.redemption_continue_button.exists
		@browser.redemption_logout_link.click
		
		db14 = DbManager.new("DL1SCQDB04SQL14.TESTECOM.PVT\\INST14","Stardock")
		sleep 10
		results = db14.exec_sql("SELECT p.prodID FROM stardock.dbo.tb_Product p JOIN stardock.dbo.tb_Registration r ON p.productID = r.productID WHERE p.prodID = 'ESD-QA1-AUTO1' AND r.customerid = (SELECT customerID FROM stardock.dbo.tb_Accounts WHERE AccountEmail = '" + user_name + "');")
		
		$tracer.trace("User: " + user_name + " redeemed product ID " + results.at(0).prodID)
		results.at(0).prodID.should == "ESD-QA1-AUTO1"
		
	end
	
	# Removing forums since it's going away in Release 19
	# it "FORUMS - should login and logout successfully" do
	
		# user_name = @row.find_value_by_name("Account_Email")
		# password = @row.find_value_by_name("Password")
		
		# # Go to forums home page
		# @browser.open(@forums_start_page)
		# @browser.forums_recent_posts_link.should_exist
		
		# # Log into forums
		# @browser.forums_email_address_field.value = user_name
		# @browser.forums_password_field.value = password
		# @browser.forums_login_button.click	
		# @browser.forums_my_account_link.should_exist
		
		# # Log out of forums
		# @browser.forums_sign_out_link.click
		# @browser.forums_email_address_field.should_exist
		
	# end
	
	# Validating able to log in and out of dev portal and reports page displays
	it "DEVELOPER - should log in, validate reports page, and logout" do
	
		user_name = @row.find_value_by_name("Account_Email")
		password = @row.find_value_by_name("Password")
		
		# Go to developer portal home page
		@browser.open(@developer_start_page)
		
		# Log into developer portal
		@browser.developer_login_link.click
		@browser.developer_header_label.innerText.should == "Impulse Developers : Login"
		@browser.developer_email_address_field.value = user_name
		@browser.developer_password_field.value = password
		@browser.developer_login_button.click	
		@browser.developer_welcome_label.should_exist
		
		# Validate reports page 
		@browser.developer_reports_link.click
		@browser.developer_header_label.innerText.should == "Impulse Developers : Reports"
		@browser.developer_sales_chart_label.should_exist
		@browser.developer_product_data_label.should_exist
		@browser.developer_product_comparison_chart_label.should_exist
		
		# Log out
		@browser.developer_logout_link.click
		@browser.developer_login_link.should_exist

	end
end

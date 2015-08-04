
#Author### - dturner
#Modified  - Robert Ramirez
# 1/7/2012, New checkout script utilizting ATS tags and logic
# 1/8/2012, Assumptions:  Pre-existing user/login with biling and shipping addresses
# 1/29/2012, DT - Broke Authenicated and Guest user paths into their own test methods to reduce conditional logic complexities
# 3/01/2013, MK - moved authenticated user test into a separate file. Added assertions to check cart items, amounts and totals.
# 
################################################################################################################################################################################################
#                                                                                                                                                                                              # 
# d-Con  %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_ISPU_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48610  --browser chrome  --or #
#                                                                                                                                                                                              # 
################################################################################################################################################################################################
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Guest Checkout ISPU" do
	before(:all) do
		@browser = GameStopBrowser.new(browser_type_parameter)
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
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
	end

	before(:each) do
    @browser.delete_all_cookies_and_verify
		@session_id = generate_guid
	
		#uses the sku(s) returned from the SQL query to get product details information from the catalog service
		$tracer.trace("Get products")
	  @product_urls, @matured_product, @physical_product, @condition = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)
		@browser.open(@start_page)
  end

  after(:each) do
    @browser.return_current_url
  end

	after(:all) do
		@browser.close_all()
	end
  
	it "#{$tc_id} #{$tc_desc}" do
	
		item_num = 0 
		@product_urls.each do |url|
			$tracer.trace("Product Url: #{url}")
			@browser.open("#{@start_page}#{url}")
			@browser.buy_first_panel.add_to_cart_button.click
			@browser.wait_for_landing_page_load
			cart_item = @browser.cart_list.at(item_num)
			
			cart_item.remove_button.should_exist 
			cart_item.shipping_option_buttons.should_exist
			cart_item.shipping_option_buttons.value = "PickUpAtStore"
			item_num = item_num + 1
		end

    @browser.add_powerup_rewards_number(@params)
		$tracer.trace("Check subtotal and total")
		subtotal = @browser.check_cart_subtotal_and_discount(@params)
	  
		@browser.paypal_chkout_button.should_not_exist
		
		# Validate Certona recommendation cartridge on the cart
    @browser.validate_certona_recommendation if @params['validate_certona_cart'] == true
		@browser.wait_for_landing_page_load
		
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		@browser.chkoutbuy_as_guest_button.click
		
		# Mature or Adult Audience confirmation page
		if @matured_product 
			@browser.handle_mature_product_screen(@params)
		end		
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Enter Billing Address Info.")
		@browser.fill_out_billing_form(@params)
		@browser.chkoutpurchaseemail_label.value = @params["bill_email"]
		@browser.chkoutconfirmemail_bill_to_label.value = @params["bill_email"]
	  @browser.continue_checkout_button.click
				
		$tracer.trace("Handling Options/Select Store")
		@browser.wait_for_landing_page_load
		i = 0
		while i <  @browser.handling_options_page_panel.length
		  $tracer.trace("Choose Store For ISPU product")
			panel = @browser.handling_options_page_panel.at(i)
			panel.choose_store_link.click
			@browser.search_store_adress.should_exist
			@browser.search_store_adress.value = @params["ship_zip"]
			@browser.search_store_adress_button.should_exist
			@browser.search_store_adress_button.click
			# IMPORTANT: sleep is needed here to allow store search result to load before clicking on "choose store" link 
			sleep 5
			@browser.choose_store_button.should_exist
			@browser.choose_store_button.click
			
			i = i +1
		end
			
		@browser.continue_checkout_button.click
	  
		#Checkout - Payment Options
		$tracer.trace("Payment Options")
		@browser.wait_for_landing_page_load
		@browser.preview_order_button.should_exist
	  
		@browser.order_summary_subtotal.should_exist
		@browser.order_summary_tax.should_exist
		@browser.handling_with_discount_amount.should_exist
		@browser.order_summary_total.should_exist
	  
		order_summary_subtotal = money_string_to_decimal(@browser.order_summary_subtotal.innerText) 
		order_summary_tax = money_string_to_decimal(@browser.order_summary_tax.innerText) 
		order_summary_total = money_string_to_decimal(@browser.order_summary_total.innerText)
	  
		total = order_summary_subtotal + order_summary_tax 
		order_summary_total.should == total
		
		# Assert: Paypal radio button should not be visible for ISPU
		$tracer.trace("Paypal Payment should NOT be available for ISPU.")
		@browser.payment_options_radio_button.length.should == 1

		$tracer.trace("Enter Credit Card Info")
		@browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])
		
		
		#Submit the order only if the value of submit_order_flag from csv file is 'true'
		if @params["submit_order_flag"]
			order_num = @browser.submit_and_confirm_order(@params, @condition)
			@browser.confirm_order_details_panel.ordered_product_label.should_exist
		  @browser.confirm_order_details_panel.ordered_availability_label.should_exist
			@browser.check_confirmation_page_subtotal(subtotal)
			@browser.confirm_order_note.should_exist
		  
			@browser.confirm_billing_address_panel.confirm_billing_first_name_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_last_name_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_addr1_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_city_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_state_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_zip_label.should_exist
			@browser.confirm_billing_address_panel.confirm_billing_country_label.should_exist
	    @browser.confirm_handling_method_panel.should_exist
			@browser.confirm_handling_method_panel.innerText.include?("Pick Up At Store").should == true
			@browser.confirm_payment_panel.confirm_payment_type_label.should_exist
			@browser.confirm_payment_panel.confirm_payment_number_label.should_exist 
		end
	end
	
	
end





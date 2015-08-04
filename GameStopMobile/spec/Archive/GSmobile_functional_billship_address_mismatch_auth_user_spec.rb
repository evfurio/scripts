#d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\GSmobile_functional_billship_address_mismatch_auth_user_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\Spec\MobileUI.csv --range "TFS47423" --browser chrome --or 
#
#
######################################################################################################################################################################
###                             Physical Product Purchase for BillShip Mismatch review Using Valid CC - Authenticated User                                         ###          
######################################################################################################################################################################



require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"

describe "GSMobile Functional Tests" do
  before(:all) do
    $tracer.echo = :on

    # get the --csv parameter and read the file, --range identifies the row of data to use per test case
	# range will now define the TFS ID to use in relation to the MTM test case created.
	csv = QACSV.new(csv_filename_parameter)
	@row = csv.find_row_by_name(csv_range_parameter)
	
	# set instance variables for csv driven data elements
	initialize_csv_params

    @start_page = @main_url
	@product_page = @product_url
	
    # TODO: MOBILE WEB: Kludge - need to remove the if condition.
    if browser_type_parameter == "chrome"
      @browser = GameStopMobileBrowser.new(browser_type_parameter, true)
    else
      @browser = GameStopMobileBrowser.new(browser_type_parameter)
    end

    $snapshots.setup_browser(@browser, :all)

    @browser.open(@start_page)
	@browser.cookie.all.delete
  end

  before(:each) do
    	   
  end

  after(:all) do
    $tracer.trace("after all")
    @browser.close_all()
  end
  
  it "Physical Product Purchase for BillShip Mismatch review Using Valid CC - Authenticated User" do
    @browser.open(@start_page)
	
	#Empty Shopping Cart Workaround until defect is fixed.
	@browser.view_cart_button.click
	
    if (@browser.timeout(5000).log_out_link.exists)
      @browser.log_out_link.click
    end
	
	@browser.log_in_link.click
	@browser.log_into_my_account_button.click
	
    # Login Credentials.
    @browser.enter_login_credentials(
      @Username,
      @Password
	)
	
	@browser.user_login_button.click
	@browser.empty_new_cart
    
	@products.each_with_index do |product, i|
		#@browser.search_field.value = "\\" + product
		#@browser.search_field.click
		@browser.open(@product_page + product)		
		@browser.product_price_list.at(0).add_to_cart_button.click
		
		if i < (@products.count - 1)
			@browser.open(@start_page)
		end
    end    
	
    @browser.continue_checkout_button_handling.click

    if @browser.timeout(5000).seventeen_or_older_button.exists
      @browser.seventeen_or_older_button.click
    end
	
	@browser.chkout_modify_existing_address.click
	@browser.chkout_enter_billing_address.click

    #Shipping Address Info.
    @browser.enter_billship_address_plus_country(
	  @shipping_country,
      @first_name,
      @last_name,
      @ShippingLine1,
      @ShippingCity,
      @ShippingState,
      @ShippingZip,
      @ShippingPhone
    )
      @browser.chkout_email_address_field.value = @ShippingEmail
	
    @browser.continue_checkout_button_handling.click
	@browser.wait_for_landing_page_load
	
	@browser.chkout_modify_existing_address.click
	@browser.chkout_enter_billing_address.click
	
	#Billing Address info.
    @browser.enter_billship_address_plus_country(
	  @billing_country,
      @first_name,
      @last_name,
      @billing_line1,
      @billing_city,
      @billing_state,
      @billing_zip,
      @billing_phone,
    )
	

   
    @browser.continue_checkout_button_handling.click

    @browser.chkout_handling_options_label.should_exist
   

    # TODO: MOBILE WEB: Kludge - need to rework once new web pages are available.
    if @browser.is_a? SeleniumBrowser
      @browser.table.id("standard_handling_method_select").find.input.click
    else
      @browser.chkout_handling_method_buttons.value = "Value"
    end

    @browser.continue_checkout_button_handling.click
	
	@browser.chkout_digital_wallet_selector.value = "-- Select a Card--"

	#Payment Info.
    @browser.enter_credit_card_info(
      @cc_type,
      @cc_number,
      @exp_month,
      @exp_year,
	  @cvv_number
    )
    @browser.chkout_complete_checkout_button.click
	

    # TODO: MOBILE WEB: rework this when new HTML is available in QA.
    @browser.validate_order_prefix("41")
	@browser.take_snapshot

  end

	def initialize_csv_params
	   #Shipping address.
	    @shipping_country = @row.find_value_by_name("ShippingCountry")
		@first_name = @row.find_value_by_name("FirstName")
		@last_name = @row.find_value_by_name("LastName")
		@ShippingLine1 = @row.find_value_by_name("ShippingLine1")
		@ShippingCity = @row.find_value_by_name("ShippingCity")
		@ShippingState = @row.find_value_by_name("ShippingState")
		@ShippingZip = @row.find_value_by_name("ShippingZip")
		@ShippingPhone = @row.find_value_by_name("ShippingPhone")
		@ShippingEmail = @row.find_value_by_name("ShippingEmail")
		#$tracer.trace(@first_name.to_s)
		
		#Billing address.
		@billing_country = @row.find_value_by_name("BillingCountry")
		@first_name = @row.find_value_by_name("FirstName")
		@last_name = @row.find_value_by_name("LastName")
		@billing_line1 = @row.find_value_by_name("BillingLine1")
		@billing_city = @row.find_value_by_name("BillingCity")
		@billing_state = @row.find_value_by_name("BillingState")
		@billing_zip = @row.find_value_by_name("BillingZip")
		@billing_phone = @row.find_value_by_name("BillingPhone")
		
		#Payment info.
		@cc_type = @row.find_value_by_name("CCType")
		@cc_number = @row.find_value_by_name("CCNumber")
		@exp_month = @row.find_value_by_name("ExpMonth")
		@exp_year = @row.find_value_by_name("ExpYear")
		@cvv_number = @row.find_value_by_name("CVV")
		
		#get product using sku.
		@products = @row.find_value_by_name("SKUS").split(",")
		@get_single_product = @products.first
		
		#login Credentials.
	    @Username = @row.find_value_by_name("Username")
	    @Password = @row.find_value_by_name("Password")
		
		#Enviroment
	    @main_url = @row.find_value_by_name("MainURL")
	    @product_url = @row.find_value_by_name("ProductURL")
	end
end

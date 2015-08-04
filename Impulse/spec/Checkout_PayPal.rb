# requiring dsl.rb file found at specified location 
require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

describe "Checkout_PayPal" do

  before(:all) do
    
	@start_page = "http://www.impulsedriven.com"
		if os_name == "darwin"
			@browser = ImpulseBrowser.new.safari
		else
			@browser = ImpulseBrowser.new.ie
		end
	$snapshots.setup(@browser, :all)
    $tracer.mode = :on
    $tracer.echo = :on
	WebSpec.default_timeout 30000
  end
  
  before(:each) do
    @browser.browser(0).open(@start_page)
	@browser.open("https://impulsestore.gamestop.com/logout/")
	@browser.empty_cart
	
    def auto_generate_impulse_username(t = nil)
      t ||= Time.now
      return "jontestqa+" + t.strftime("%Y%m%d_%H%M%S") + "@gmail.com"
    end

  end
  
  after(:each) do
	
  end
  
  after(:all) do
    $tracer.trace("after :all")
    @browser.close_all
  end
  
  # a specific test scenario
  it "should create an account then purchase an order using PayPal" do

	# set some variables, use defined functions above
	user_name = auto_generate_impulse_username
    password = 'test1234'
    first_name = 'Jon'
    last_name = 'TestQA'

    # Make sure user is logged out of PayPal test store
	@browser.open("https://sandbox.paypal.com")
	if @browser.paypal_personal_tab.exists
	   then  @browser.paypal_logout_link.click
	end
	
	@browser.open("https://impulsestore.gamestop.com/logout/")
	@browser.view_cart_link.click
    @browser.create_account_link.click
	@browser.email_address_field.value = user_name
    @browser.confirm_email_address_field.value = user_name
    @browser.password_field.value = password
    @browser.confirm_password_field.value = password
	@browser.promotions_and_special_offers_opt_in_checkbox.checked = false
    @browser.continue_button.click	
	@browser.view_cart_link.click
	
	# IP Spoofing - QA Only
    @browser.ip_address_field.value = "166.128.1.150"
    @browser.submit_button.click
	
 	# Verify cart is empty
	@browser.my_cart_label.should_exist
	@browser.empty_cart_label.should_exist	
	
	# Go to and Verify you are on the Impulse hompage
	@browser.impulse_logo_link.click
    @browser.best_sellers_tab.should_exist	
	
	# Search for a Product
	@browser.search_field.value = "Avadon - The Black Fortress"
	@browser.search_button.click
	
	# Verify you are on the Search Results page
	list = @browser.product_list
	list.should_exist
	item = list.at(0)
	item.should_exist
	item.product_title_link.innerText.should == "Avadon - The Black Fortress"

	# Click on Product link
	item.product_image_link.click
	
	# Verify you are on the Product Detail page
	@browser.product_header_label.should_exist
	
	# add game to cart
	@browser.add_to_cart_button.click
	
	# Verify a product is in the cart
	@browser.cart_list.at(0).remove_link.should_exist
	
	#Click Checkout
    @browser.checkout_button.click
	
	# Kept for use with new user setup
    @browser.first_name_field.value = first_name
    @browser.last_name_field.value = last_name
    @browser.street_address_field.value = "1 Denton Dr."
    @browser.city_field.value = "Denton"
    @browser.state_selector.value = "Texas"
    @browser.zip_code_field.value = "76210"
	@browser.phone_number_field.value = "5084147901"
    @browser.continue_button.click
	
	# Select PayPal button and continue
	@browser.input.id("_Content__RadioPaymentMethodPaypal").click # needs finder/ATS class tag for PayPal radio button
	@browser.continue_button.click
	
	# Log into PayPal sandbox
	@browser.paypal_master_login_link.click
	@browser.paypal_master_email_field.value = ""
	@browser.paypal_master_email_field.value = "jonathanlafortune@gamestop.com"
	@browser.paypal_master_password_field.value = "Tennis33"
	@browser.paypal_master_login_button.click
		
	# Go back to Cart page now that user is logged in with master acct
	@browser.open("https://impulsestore.gamestop.com/cart")
	
	# Now that user is logged into main PayPal sandbox, repeat process in cart
	@browser.checkout_button.click
	@browser.input.id("_Content__RadioPaymentMethodPaypal").click # noted above, this needs finder/ATS class tag
	@browser.continue_button.click
	
	# User is taken to sandbox test store b/c they're already logged into the main test area
	@browser.paypal_test_acct_login_field.value = ""
	@browser.paypal_test_acct_login_field.value = "jonath_1319546914_per@gamestop.com"
	@browser.paypal_test_acct_password_field.value = "test1234"
	@browser.paypal_test_acct_login_button.click
	
	# verify user is logged in and on the specify payment/shipping/billing info page
	@browser.paypal_shipping_address_panel.exists
	
	# select a payment shipping address (a test account can have multiple shipping addresses...)
	@browser.paypal_test_acct_continue_button.click
	
	# user should be taken back to store on the review/submit page
	@browser.img.className("/image_paypal/").exists #needs impulse store finder / ATS class tag
	
	# Submit the order
    @browser.submit_order_button.click
    link = @browser.order_number_link
    link.should_exist
    $tracer.trace("Order Number: " + link.innerText)
    sleep 5
 	
	# Empty cart in preparation for next test
	@browser.impulse_logo_link.click	
    @browser.view_cart_link.click
	@browser.cart_logout_link.click
	@browser.empty_cart		
	
  end
    
end	
	
	
	
	


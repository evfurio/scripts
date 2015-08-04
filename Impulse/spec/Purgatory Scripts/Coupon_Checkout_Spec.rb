require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

describe "Coupon Checkout Suite" do

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
  end

  before(:each) do
    @browser.browser(0).open(@start_page)
	@browser.open("https://impulsestore.gamestop.com/logout/")
	@browser.open("https://impulsestore.gamestop.com/cart.aspx")
	@browser.empty_cart		
	
	def auto_generate_impulse_username(t = nil)
    t ||= Time.now
    # return "ottomatin+" + t.strftime("%H%M%S") + "@gmail.com"
	    return "ottomatin+" + t.strftime("%Y%m%d_%H%M%S_%3N") + "@gmail.com"
   end
   
  end
	
	after(:each) do
	
    end

  after(:all) do
    $tracer.trace("after :all")
    @browser.close_all
  end
  
    
	it "should create an account, add to cart a product below minimum coupon value and attempt to use an Order Wide Coupon" do
    WebSpec.default_timeout 10000
	
    user_name = auto_generate_impulse_username
    password = 'Manh0le1'
    first_name = 'Otto'
    last_name = 'Matin'

    @browser.view_cart_link.click
    @browser.create_account_link.click
    @browser.email_address_field.value = user_name
    @browser.confirm_email_address_field.value = user_name
    @browser.password_field.value = password
    @browser.confirm_password_field.value = password
	@browser.promotions_and_special_offers_opt_in_checkbox.checked = false
    @browser.continue_button.click	
	# sleep 100
	
    @browser.view_cart_link.click

	
	# IP Spoofing - QA Only
    @browser.ip_address_field.value = "216.39.86.61"
    @browser.submit_button.click
	
 	# Verify cart is empty
	@browser.my_cart_label.should_exist
	@browser.empty_cart_label.should_exist	
	
	# Go to the Homepage
	@browser.impulse_logo_link.click	
	
	# Verify you are on the Impulse hompage
    @browser.best_sellers_tab.should_exist
	
	# Search for a Product
	@browser.search_field.value = "Really Big Sky"
	@browser.search_button.click
	
	#Verify you are on the Search Results page
	list = @browser.product_list
	list.should_exist
	item = list.at(0)
	item.should_exist
	item.product_title_link.innerText.should == "Really Big Sky"

	# Click on Product link
	item.product_image_link.click
	
	#Verify you are on the Product Detail page
	@browser.product_header_label.should_exist
	
	# Add Product to Cart
    @browser.add_to_cart_button.click
	
	# Verify the product is in the cart
	# @browser.product_in_cart_label.should_exist
	
	#Add a coupon
	@browser.coupon_field.value = "VDBK-TLJY-HNOS"
	@browser.apply_coupon_button.click
	
	#Verify Coupon Error Notice
	@browser.coupon_error_notice.should_exist
	@browser.coupon_error_notice.innerText.should == "* The coupon code you entered VDBK-TLJY-HNOS requires a minimum order of 9. "
	@browser.discounts_label.should_not_exist
	@browser.subtotal_amount_panel.innerText.should  == "$7.99"
	
	#Click Checkout
    @browser.checkout_button.click
	
	# Kept for use with new user setup
	#@browser.billing_information_label.should_exist
	@browser.enter_address(
		first_name,
		last_name,
		"111 High Point Dr",
		"Irving",
		"Texas",
		"75038",
		"214-555-1212")	
    @browser.continue_button.click
    
	# Enter CC Info
    @browser.checkout_payment_information_label.should_exist
    @browser.enter_credit_card_info(
        "Visa",
        "4222222222222",
        "#{first_name} #{last_name}",
        "12",
        "2015",
        "gs01")	
	
    @browser.continue_button.click

	#Verify no discount on Payment Info page
	
    @browser.submit_order_button.click

    link = @browser.order_number_link
    link.should_exist
    $tracer.trace("Order Number: " + link.innerText)
    sleep 5
    # @browser.source().include?("Order Status").should == false
	
	# Empty cart in preparation for next test
	@browser.impulse_logo_link.click	
    @browser.view_cart_link.click
	@browser.cart_logout_link.click
	@browser.empty_cart		
		
  end
  
   
end	
	
	
	
	


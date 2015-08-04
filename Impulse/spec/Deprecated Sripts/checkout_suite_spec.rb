require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

# The purpose of this script is to create an account, add an item to the cart and complete the checkout process.

describe "Checkout Suite" do

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
  end

  after(:all) do
    $tracer.trace("after :all")
    @browser.close_all
  end

  it "should create a new account then buy a product" do
  
	# Generate Username, first name and last name
    WebSpec.default_timeout 10000
    user_name = auto_generate_username
    password = 'impulse#2011'
    first_name = name_generator("cvvc")
    last_name = name_generator("cvcvvc")

	# go to cart page
    @browser.view_cart_link.click
	
	# create a new account
    @browser.create_account_link.click
    @browser.email_address_field.value = user_name
    @browser.confirm_email_address_field.value = user_name
    @browser.password_field.value = password
    @browser.confirm_password_field.value = password
    @browser.continue_button.click

	# Add an item to the cart
	# Below are 2 methods for adding item to cart - use the URL to directly add an item to the cart
	# OR
	# Use the URL to go to the Product Detail page and use Add to Cart button to add an item to the cart	
	
    #@browser.open("https://impulsestore.gamestop.com/cart.aspx?add&productID=ESD-IMP-W092&theme=impulse")
    @browser.open("http://www.impulsedriven.com/sinstrinity")
    @browser.add_to_cart_button.click
    
	# Update the IP address (QA & DEV Environtments ONLY)
    @browser.ip_address_field.value = "216.39.86.61"
    @browser.submit_button.click
    @browser.checkout_button.click

	# Enter BIlling Address Information
    @browser.first_name_field.value = first_name
    @browser.last_name_field.value = last_name
    @browser.street_address_field.value = "123 High Point Dr"
    @browser.city_field.value = "Irving"
    @browser.state_selector.value = "Texas"
    @browser.zip_code_field.value = "75038"
	@browser.phone_number_field.value = "999-999-9999"
    @browser.continue_button.click
    
	# Enter Payment Method Information
    @browser.credit_card_selector.value = "Visa"
    @browser.credit_card_number_field.value = "4222222222222"
    @browser.credit_card_holder_name_field.value = "#{first_name} #{last_name}"
    @browser.credit_card_month_selector.value = "03"
    @browser.credit_card_year_selector.value = "2014"
    @browser.credit_card_security_code_field.value = "gs01"
    @browser.continue_button.click

	# Process for completing transaction 
    #@browser.purchase_as_gift_order_link.click

    #@browser.email_or_nickname_field.value = "foo@bar.com"
    #@browser.confirm_email_or_nickname_field.value = "foo@bar.com"
    #@browser.continue_button.click

	# Submit Order
    @browser.submit_order_button.click

	# Check for and record the order number
    link = @browser.order_number_link
    link.should_exist
    $tracer.trace("Order Number: " + link.innerText)
    #sleep 5
    #@browser.source().include?("Order Status").should == false
  end
  
end

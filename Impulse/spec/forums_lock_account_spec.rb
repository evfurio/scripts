require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

describe "Forums - Lock Account Suite" do

   before(:all) do
    csv = QACSV.new(csv_filename_parameter)
    @row = csv.find_row_by_name(csv_range_parameter)
	
    @start_page = "http://forums.impulsedriven.com"
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
    
   it "should verify login and then lockout an account from the Forums Login page " do
    WebSpec.default_timeout 10000
    
	# Login to Forums
	@browser.forums_recent_posts_label.should_exist
    @browser.forums_email_address_field.value = @row.find_value_by_name("user")
    @browser.forums_password_field.value = @row.find_value_by_name("password")
    @browser.forums_login_button.click	
	@browser.forums_my_account_link.should_exist
	@browser.forums_sign_out_link.click
	@browser.forums_email_address_field.should_exist
	
	# Login to Impulse Cart
	@browser.open("http://www.impulsedriven.com")	
	@browser.view_cart_link.click
	@browser.login_link.click
    @browser.email_address_field.value = @row.find_value_by_name("user")
    @browser.password_field.value = @row.find_value_by_name("password")
    @browser.sign_in_button.click	
	@browser.cart_my_account_link.should_exist
	@browser.cart_logout_link.click
	@browser.login_link.should_exist	
	
	# Login to Developer
	@browser.open("http://developer.impulsedriven.com")	
	@browser.developer_header_label.innerText.should == "Impulse Developers : Learn About Impulse"
	@browser.developer_login_link.click
    @browser.developer_header_label.innerText.should == "Impulse Developers : Login"
	@browser.forums_email_address_field.value = @row.find_value_by_name("user")
    @browser.forums_password_field.value = @row.find_value_by_name("password")
    @browser.developer_login_button.click	
	@browser.developer_welcome_label.should_exist
	@browser.developer_logout_link.click
	@browser.developer_login_link.should_exist		

	# Login to Community
	@browser.open("http://www.impulsedriven.net")	
	@browser.community_sign_up_link.should_exist
	@browser.forums_email_address_field.value = @row.find_value_by_name("user")
    @browser.forums_password_field.value = @row.find_value_by_name("password")
    @browser.developer_login_button.click	
	@browser.community_user_name_link.should_exist
	@browser.community_logoff_link.click
	@browser.developer_login_link.should_exist	

	# 1 - Failed login attempt
	@browser.open("http://forums.impulsedriven.com")			
	@browser.forums_recent_posts_label.should_exist
    @browser.forums_email_address_field.value = @row.find_value_by_name("user")
    @browser.forums_password_field.value = "nachopassword"
    @browser.forums_login_button.click	
	@browser.forums_invalid_login_label.should_exist	

	# 2 - Failed login attempt	
	@browser.forums_email_address_field.value = @row.find_value_by_name("user")
    @browser.forums_password_field.value = "nachopassword"
    @browser.forums_login_button.click	
	@browser.forums_invalid_login_label.should_exist	

	# 3 - Failed login attempt	
	@browser.forums_email_address_field.value = @row.find_value_by_name("user")
    @browser.forums_password_field.value = "nachopassword"
    @browser.forums_login_button.click	
	@browser.forums_invalid_login_label.should_exist	

	# 4 - Failed login attempt	
  	@browser.forums_email_address_field.value = @row.find_value_by_name("user")
    @browser.forums_password_field.value = "nachopassword"
    @browser.forums_login_button.click	
	@browser.forums_invalid_login_label.should_exist	

	# 5 - Failed login attempt	
    @browser.forums_email_address_field.value = @row.find_value_by_name("user")
    @browser.forums_password_field.value = "nachopassword"
    @browser.forums_login_button.click	
	@browser.forums_invalid_login_label.should_exist	
	
	# Forums - Valid Login attempt that should end in failure dure to locked out account
    @browser.forums_email_address_field.value = @row.find_value_by_name("user")
    @browser.forums_password_field.value = @row.find_value_by_name("password")
    @browser.forums_login_button.click	
	@browser.forums_invalid_login_label.should_exist	

	# Cart - Valid Login attempt that should end in failure dure to locked out account
	@browser.open("http://www.impulsedriven.com")		
	@browser.view_cart_link.click
	@browser.login_link.click
    @browser.email_address_field.value = @row.find_value_by_name("user")
    @browser.password_field.value = @row.find_value_by_name("password")
    @browser.sign_in_button.click	
	@browser.store_login_error_label.should_exist			

	# Developer - Valid Login attempt that should end in failure dure to locked out account
	@browser.open("http://developer.impulsedriven.com")	
	@browser.developer_header_label.innerText.should == "Impulse Developers : Learn About Impulse"
	@browser.developer_login_link.click
    @browser.developer_header_label.innerText.should == "Impulse Developers : Login"
	@browser.forums_email_address_field.value = @row.find_value_by_name("user")
    @browser.forums_password_field.value = @row.find_value_by_name("password")
    @browser.developer_login_button.click	
	@browser.developer_login_error_label.innerText.should == "The provided email address/password are invalid. Please try again. "
	
	# Community - Valid Login attempt that should end in failure dure to locked out account
	@browser.open("http://www.impulsedriven.net")		
	@browser.community_sign_up_link.should_exist
	@browser.forums_email_address_field.value = @row.find_value_by_name("user")
    @browser.forums_password_field.value = @row.find_value_by_name("password")
	@browser.developer_login_button.click	
	@browser.community_login_error_label.innerText.should == "It's that pesky caps-lock key I bet...\r\nThe email address/password combination you entered doesn't match up and we were unable to log you in. Please make sure you are entering the right information and try again. If you can't remember your login information, click here to be sent a reminder. "
	
	end  
   
end	
	
	
	
	
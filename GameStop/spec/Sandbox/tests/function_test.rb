#function tester
#	d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\function_test.rb --login david.test@r3nrut.com --password T3sting1 --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Test" do
  before(:each) do
    @browser = GameStopBrowser.new("chrome")
    @browser.cookie.all.delete
  end

	it "test function" do
		start_page = "http://qa.gamestop.com"
		@browser.open(start_page)
		@browser.log_in_link.click
		@browser.log_in(account_login_parameter, account_password_parameter)
		@browser.add_product_to_cart(product)
	end
	
	it "test function 2" do 
		#renewal_type = "physical"
		#url = @browser.add_renewal_sku_to_cart_by_url(renewal_type, start_page)
		#@browser.open(url)
		#@browser.log_out_link.click
	end
	it "test function" do
		start_page = "http://qa.gamestop.com"
		@browser.open(start_page)
		@browser.log_in_link.click
		@browser.log_in(account_login_parameter, account_password_parameter)
		@browser.add_product_to_cart(product)
	end
	
	it "test function 2" do 
		#renewal_type = "physical"
		#url = @browser.add_renewal_sku_to_cart_by_url(renewal_type, start_page)
		#@browser.open(url)
		#@browser.log_out_link.click
	end
	
end


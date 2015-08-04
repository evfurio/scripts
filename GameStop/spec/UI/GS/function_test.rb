#function tester
#	d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\function_test.rb --login david.test@r3nrut.com --password T3sting1 --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Test" do
  before(:each) do
   # @browser = GameStopBrowser.new("chrome")
   # @browser.cookie.all.delete
  end

	it "test function" do
		#puts GameStopCheckoutFinder.instance_methods
		#puts GameStopForgottenPasswordFinder.instance_methods
		#puts GameStopHopsFinder.instance_methods
		#puts GameStopHTMLFinder.instance_methods
		#puts GameStopOrderHistoryFinder.instance_methods
		#puts GameStopProductDetailFinder.instance_methods
		#puts GameStopSearchFinder.instance_methods
		#puts GameStopWishListFinder.instance_methods

    puts GameStopProductDetailRecommendationListItem.instance_methods(false)
		# start_page = "http://qa.gamestop.com"
		# @browser.open(start_page)
		# @browser.log_in_link.click
		# @browser.log_in(account_login_parameter, account_password_parameter)
		# @browser.add_product_to_cart(product)
	 end
	
end


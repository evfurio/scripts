#d-con %QAAUTOMATION_SCRIPTS%\WebInStore\spec\UI\wis_cert_test.rb --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"
# require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/web_in_store_common_dsl"
#require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "WIS Loop" do

  it "should validate cart functionality" do
	
	count = 0
	users = 2
	while count < users do
	  @browser = GameStopBrowser.new("chrome")
	  GameStopBrowser.delete_temporary_internet_files("chrome")
	  @browser.cookie.all.delete
	  url = "http://cert.gamestop.com/checkout/instore/product?store=6528&reg=1&pur=3876137669602&sku=909121&ctguest=true"
	  @browser.open(url)

	  @browser.search_field.value="909121"
	  @browser.search_button.click
		
	  item = @browser.product_search_list.at(0)
	  item.product_details_button.click
		
	  @browser.cart_quantity_field.should_exist
		
	  @browser.add_to_cart_button.click	
    end
  end
end
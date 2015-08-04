###################################################################
###################################################################
###################################################################
#WEBRick HTTP Post Receiver
#Author: dturner
#USAGE NOTES
###################################################################
###################################################################
###################################################################

qaautomation_dir = ENV['QAAUTOMATION_FILES']
require "#{qaautomation_dir}/common/src/base_requires"
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require 'webrick'


class HttpReceiver

	def run
		server = WEBrick::HTTPServer.new(:Port => 8080)
	end

end

class TestRun
	require 'HttpReceiver'
	

      $browser = GameStopBrowser.new(b)

	  

      $browser.open("http://qa.gamestop.com")

    
    it "should do something with #{b}" do
	  i = 0
	  derp = 1
	  server = HttpReciever.new
	  
	  while i < derp do 
		  $browser.instance_variable_get(:@driver).navigate.refresh
		  $browser.open("http://qa.gamestop.com/")
		  $browser.log_in_link.click
		  $browser.log_in(account_login_parameter, account_password_parameter)
		  $browser.instance_variable_get(:@driver).navigate.refresh
		  $browser.cookie.all.delete
	  end
      # $browser.search_field.value = "legos"
      # $browser.search_button.click
      
      # product = $browser.product_list.at(1)
      # name = product.name_link.inner_text
      # product.name_link.click
      # $browser.h1.className($browser.send(:create_ats_regex_string, "grid_17")).innerText.should include(name)
    end
    
    it "should do something else with #{b}" do
      $browser.search_field.value = "legos"
      $browser.search_button.click
    end
end

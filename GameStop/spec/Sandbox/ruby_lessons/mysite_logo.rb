require 'nokogiri'
require 'open-uri'
#jruby -S gem install httpclient
require 'httpclient'

#example only - no validation.
#tests to see if a specific element exists, if so it returns a http status code of 200
#dumps a copy of the html source to test.html
test_output = File.open("test.html", "w")

	
		url = 'http://www.gamestop.com'
		client = HTTPClient.new
		req = client.get(url)
		resp = req.content
		
		#print resp
		
		hdoc = Nokogiri::HTML(resp)
		puts req.status
		test_output.puts resp
		hdoc.xpath(".//*[@id='ctl00_cHeader_ctl00_Img1']").each do |attr| 
			puts attr
		end

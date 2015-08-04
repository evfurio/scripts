require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "GameStop SOAP Store Search Services Tests" do


    before(:all) do

       $tracer.mode = :on
       $tracer.echo = :on
	   @start_page = "http://qa.gamestop.com"
	   @browser = GameStopBrowser.new
       WebSpec.default_timeout 30000
       @store_search_svc = StoreSearchService.new("http://qa.services.gamestop.com/Ecom/Stores/Search/v1/StoreSearchService.svc?wsdl")
=begin	   
	   #######
	   # I might need to pull the db connect/result code back into the script to push the sth.fetch_hash to openstruct instead of putting it in an empty array.  Doesn't seem to work well when giving values keys.

		   def get_database_results(server, database, sql)
			   dbh = dbi_handle(server, database)
			   sth = dbh.execute(sql)
			   rows = []
			   sth.fetch_hash { |h| rows << h }
			   sth.finish
			   dbh.disconnect if dbh
			   return rows
		   end
=end
	   #Get setup data from data sources
		server = "GV1HQQDB50sql01.testgs.pvt\\inst01" #port 5510
		database = "StoreInformation"
		@sql_data = []
		path_abs = File.expand_path(File.dirname(__FILE__))
		puts "this is the path_abs: #{path_abs}" 
		sql_file  = File.open("#{path_abs}/./sql_queries/GetStoreInformation.sql") do |f|
			no = 1
			f.each do |lines|
				lines.gsub("\n","")
				lines.gsub("\t","")
				@sql_data << lines
				no += 1
				#break if no > 500
			end
			sql = @sql_data.join
			sql_str = sql.chomp
			rows = @browser.get_database_results(server, database, "#{sql_str}")
			
			
			
##TODO - Need to get the store data from @rows and popualte this data... Might need to stick this in a before(:each) block
## 		
			#headers = ['zipcode','Lat','Longitude','StoreNum','addr1','city','state']
			Store = Struct.new("Store", :zipcode, :Lat, :Longitude, :StoreNum, :addr1, :city, :state)
			@store_addr = Store.new("75060","","","420","625 Westport Pkwy","Grapevine","TX")
			
		end
       end
	

    it "should verify find stores in range response is correct" do
		session_id = generate_guid
		#pp @rows
		puts @store_addr.StoreNum
		puts @store_addr.addr1
		puts @store_addr.city
		puts @store_addr.state
		puts @store_addr.zipcode
		
		# converting the template into dot notaiton
		find_store_req = @store_search_svc.get_request_from_template_using_global_defaults("find_stores_in_range")
		
		find_store_req.find_tag("session_id").at(0).content = session_id
		# find_store_req.find_tag("address").at(0).content = "Dallas"
		# find_store_req.find_tag("country_code").at(0).content = "US"
		# find_store_req.body.radius_in_kilometers.
		
		req_input = find_store_req.find_tag("find_stores_in_range_request").at(0)
		req_input.address.content = "Dallas"
		req_input.country_code.content = "US"
		req_input.radius_in_kilometers.content = "5"
  
		# will dump the entire request into the trace file
		$tracer.trace(find_store_req.formatted_xml)
		
		# convert dot notation back to XML & calling the request
		 find_store_rsp = @store_search_svc.find_stores_in_range(find_store_req.xml)
		 
		 # will verify HTTP status code of 200
		 find_store_rsp.code.should == 200
  
		# output the response into the trace file
		$tracer.trace(find_store_rsp.http_body.formatted_xml)
		
		# store_list = find_store_rsp.http_body.find_tag("stores").at(0)
		store_item = find_store_rsp.http_body.find_tag("store").at(0)
		
		address_data = store_item.address
		address_data.city.content.should == "Dallas"
		address_data.country_code.content.should == "US"
		address_data.country_name.content.should == "US"
		
		geography_data = address_data.geography
		geography_data.distance.content.should == "4.143449"
		geography_data.latitude.content.should == "32.809766"
		geography_data.longitude.content.should == "-96.771940"
		
		address_data.line1.content.should == "5334 Ross Ave"
		address_data.line2.content.should == "STE 350"
		address_data.state.content.should == "TX"
		address_data.zip.content.should == "75206"
		
		store_item.hours.string.at(0).content.should  == "Mon-Sat 10am-9pm"
		store_item.hours.string.at(1).content.should  == "Sun 11am-6pm"
		
		store_item.mall.content.should == "Ross Henderson S/C"
		store_item.phone_number.content.should == "(214) 823-1061"
		store_item.store_name.content.should == "Game Stop"
		store_item.store_number.content.should == "3873"
		
      end
	  
	it "should verify find stores in range by geocode response is correct" do
		
		session_id = generate_guid
		
		# converting the template into dot notaiton
		find_store_req = @store_search_svc.get_request_from_template_using_global_defaults("find_stores_in_range_by_geocode")
		
		find_store_req.find_tag("session_id").at(0).content = session_id
		# find_store_req.find_tag("address").at(0).content = "Dallas"
		# find_store_req.find_tag("country_code").at(0).content = "US"
		# find_store_req.body.radius_in_kilometers.
		
		req_input = find_store_req.find_tag("find_stores_in_range_by_geocode_request").at(0)
		req_input.country_code.content = "US"
		req_input.latitude.content = "32.815303"
		req_input.longitude.content = "-96.770049"
		req_input.radius_in_kilometers.content = "1"
  
		# will dump the entire request into the trace file
		$tracer.trace(find_store_req.formatted_xml)
		
		# convert dot notation back to XML & calling the request
		 find_store_rsp = @store_search_svc.find_stores_in_range(find_store_req.xml)
		 
		 # will verify HTTP status code of 200
		 find_store_rsp.code.should == 200
  
		# output the response into the trace file
		$tracer.trace(find_store_rsp.http_body.formatted_xml)
		
		# store_list = find_store_rsp.http_body.find_tag("stores").at(0)
		store_item = find_store_rsp.http_body.find_tag("store").at(0)
		
		address_data = store_item.address
		address_data.city.content.should == "Dallas"
		address_data.country_code.content.should == "US"
		address_data.country_name.content.should == "US"
		
		geography_data = address_data.geography
		geography_data.distance.content.should == "0.640516"
		geography_data.latitude.content.should == "32.809766"
		geography_data.longitude.content.should == "-96.771940"
		
		address_data.line1.content.should == "5334 Ross Ave"
		address_data.line2.content.should == "STE 350"
		address_data.state.content.should == "TX"
		address_data.zip.content.should == "75206"
		
		store_item.hours.string.at(0).content.should  == "Mon-Sat 10am-9pm"
		store_item.hours.string.at(1).content.should  == "Sun 11am-6pm"
		
		store_item.mall.content.should == "Ross Henderson S/C"
		store_item.phone_number.content.should == "(214) 823-1061"
		store_item.store_name.content.should == "Game Stop"
		store_item.store_number.content.should == "3873"
		
  
    end  
end










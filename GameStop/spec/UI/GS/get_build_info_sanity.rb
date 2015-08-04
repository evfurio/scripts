#USAGE NOTES

###WEBSERVER BUILD INFO###
#d-Con --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url QA_GS --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\sanity_and_smoke_v2.csv --range TFSTEMP03 --login qa_ui_testing1@4test.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\get_build_info_sanity.rb --browser ie-webspec -e 'should get and compare all web server build numbers' --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"


describe "Pre-Sanity Build Deployment Validation Suite" do


	before(:all) do
		@browser = GameStopBrowser.new(browser_type_parameter)
		#$options.default_timeout = 10_000
		$tracer.mode=:on
		$tracer.echo=:on 
	end

	before(:each) do
    @browser.delete_all_cookies_and_verify

		#global_functions passes the csv row object and return the parameters.
		@global_functions = GlobalServiceFunctions.new()
		@global_functions.csv = @row
		@global_functions.parameters
		@sql = @global_functions.sql_file
		@db = @global_functions.db_conn
		
		@start_page = @global_functions.prop_url.find_value_by_name("url")
		
		#configuration service
		@account_svc, @account_svc_version  = @global_functions.account_svc
		@profile_svc, @profile_svc_version  = @global_functions.profile_svc
		@cart_svc, @cart_svc_version = @global_functions.cart_svc
		@catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
		@purchase_order_svc, @purchase_order_version = @global_functions.purchaseorder_svc
		#shipping service
		#velocity service
		#tax service
		@digital_content_svc, @digital_content_version = @global_functions.digitalcontent_svc		
		@digital_wallet_svc, @digital_wallet_version  = @global_functions.digitalwallet_svc
		#fraud service
		#payment service
		#store search service
		#ingegrated payment service

		#trade service
		#web order service
		#barcode service
	end

	after(:all) do
		$tracer.trace("after all")
		@browser.close_all()
	end

	after(:each) do
		@browser.cookie.all.delete
	end


	it "should get and compare all web server build numbers" do
	
		#HOSTS FILE - Add IP Address For Each Machine in VIP
		
		#Base properties (QA, QA2, QA3, QA4)
		# [cname].gamestop.com
		# [cname].ebgames.com
		# m.[cname].ebgames.com
		
		#Checkout
		# [cname].gamestop.com/checkout
		# [cname].gamestop.com/checkout/instore
		# [cname].ebgames.com/checkout
		# [cname].ebgames.com/checkout/instore
		
		#Extended
		# [cname].gamestop.com/poweruprewards
		# [cname].gamestop.com/wis2.1/0fn1dl1ub.txt
		# [cname].ebgames.ca
		# m.[cname].ebgames.ca
		
		#Services
		# [cname].services.gamestop.com
		
		#Production Akamai
		# origin-www.gamestop.com
		# origin-www.m.gamestop.com
		# origin-www.ebgames.com
		# origin-www.gamestop.com/Checkout
		# origin-www.ebgames.com/Checkout
		# origin-www.ebgames.ca
		# origin-www.m.ebgames.ca
		
		
		#Start with the base
		server = [@start_page]	
		
		#conditional statement to use regex to confirm that this is gamestop base property
		if @start_page == "http://qa.gamestop.com"
			server_list = ['http://dl1gsqweb03.testecom.pvt', 'http://dl1gsqweb04.testecom.pvt']
			@path = '/Old/9u35t0n1y/0fn1dl1ub.txt'
		end		
		
		if @start_page == "http://qa2.gamestop.com"
			server_list = ['http://dl1gsqweb05.testecom.pvt', 'http://dl1gsqweb06.testecom.pvt']
			#server_list = ['http://qa2.gamestop.com']
			@path = '/Old/9u35t0n1y/0fn1dl1ub.txt'
		end
		
		if @start_page == "http://qa3.gamestop.com"
			server_list = ['http://dl1gsqweb07.testecom.pvt', 'http://dl1gsqweb08.testecom.pvt']
			@path = '/Old/9u35t0n1y/0fn1dl1ub.txt'
		end
		
		
		puts server_list
		
			server_list.each do |f|
				server.push(f)
			end
			
			build_version = parse_server_build_info_txt(server)
			puts build_version
			#puts "THIS IS BUILD VERSION ARRAY #{build_version[0]}, #{build_version[1]}, #{build_version[2]}"
			confirm_build_base_prop(build_version)
			
		#conditional statement to use regex to confirm that this is a checkout property
		
		#conditional statement to use regex to confirm that this is an extended property
		
		#conditional statement to go to services assembly info
		
		#conditional statement to go to confirm that this is a production akamai property
		
		
		end
  

	
	def confirm_build_base_prop(build_version)
		build_version.each_with_index do |v,i|
			#build_version[i].all?{|z| build_version[0].include?(z)}
			[build_version[0].should == build_version[i]]
		end
	end
	
	def find_build_info_from_server(server)
		url = "#{server}#{@path}"
		version = @browser.open(url)
		#vernum = @browser.source.match(/(^Server Path)(.*)(_\d*\.\d*)/)[3]
		vernum = @browser.source.match(/(^Build Number)(.*)(_\d*\.\d*)/)[3]
		vernum = "" if vernum.nil?
		#puts "THIS IS THE VERSION #{vernum}"
		return vernum
    end
		
	def parse_server_build_info_txt(server)
		build_info = []
		puts "THIS IS THE FRACKING SERVER : #{server}"
		server.each_with_index { |p| build_info << find_build_info_from_server(p);
		}
		puts "THIS IS BUILD INFO #{build_info}"
		return build_info
	end
	
  
	def initialize_csv_params
		csv = QACSV.new(csv_filename_parameter)
		@row = csv.find_row_by_name(csv_range_parameter)
	end

end
# d-Con %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_product_details_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopRespMobile\spec\UI\mgs_responsive_dataset.csv --range TFS96873 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopRespMobile/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()
# USER_AGENT_STR = "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
$tracer.trace("THIS IS TEST DESC #{$tc_desc} \nTHIS IS TEST ID #{$tc_id}")

describe "MGS PDP Phone View" do

  before(:all) do
		#Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
    @shipping_svc, @shipping_svc_version = $global_functions.shipping_svc
		
		$options.http_proxy = "localhost"
    $options.http_proxy_port = "9091"

    $proxy = ProxyServerManager.new(9091)
		
		@browser = WebBrowser.new(browser_type_parameter, true)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 10_000
    $snapshots.setup(@browser, :all)
		
		# Load the size of device
		$tracer.trace("DEVICE SIZE - W: #{@params['device_width']}, H: #{@params['device_height']}")
    @browser.set_size(@params['device_width'].to_i, @params['device_height'].to_i)
  end

  before(:each) do
		$proxy.inspect
    $proxy.start
    sleep 5
		
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
  end

  after(:each) do
		$proxy.stop
    @browser.return_current_url
  end

  after(:all) do
		@browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
		# $proxy.start_capture(true)
		
		# Check if user is Authenticated or Guest
		unless @params['login'] == ""
			$tracer.trace("Goto Login page if Authenticated User")
			@open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
			@cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
			
			# Temporary approach while waiting for the mGS Header Cartridge
			login_url = "https://loginqa.gamestop.com/account/login?ReturnUrl="
			@browser.open("#{login_url}#{@start_page}/browse")
			
			@browser.username_field.value = @login
			@browser.password_field.value = @password
			@browser.log_in_button.click
		else
			@browser.open("#{@start_page}/browse")
		end
	
		# Construct SQL Query  -OR-  Use SKU from Dataset
		### TODO: Probably better if will be moved to dsl
		if @params['sku'] == ""
			$tracer.trace("Construct SQL Query")
			@esrb_ratings = @params['esrb_rating'].length > 1 ? @params['esrb_rating'].split(",").join("','") : @params['esrb_rating']
			@excluded_skus = @params['esrb_rating'].length > 1 ? @params['excluded_skus'].split(",").join("','") : @params['excluded_skus']
			@conditions = @params['condition'].length > 1 ? @params['condition'].split(",").join("','") : @params['condition']
			@availability = @params['availability'].length > 1 ? @params['availability'].split(",").join("','") : @params['availability']
			
			unless @params['product_limit'] == ""
				@product_limit = @params['product_limit'] == "NULL" ? "AND d.ProductLimit is NULL" : "AND d.ProductLimit = #{@params['product_limit']}" 
			else
				@product_limit = ""
			end
			unless @params['has_release_date'] == ""
				@release_date = @params['has_release_date'] == true ? "AND i.PreorderAvailabilityDate > GETDATE()" : "AND i.StreetDate is NULL AND i.PreorderAvailabilityDate is NULL"
			else
				@release_date = ""
			end
			unless @params['is_online_only_price'] == ""
				@online_only_price = @params['is_online_only_price'] == true ? "AND c.OnlineOnlyPrice = 1" : "AND c.OnlineOnlyPrice = 0"
			else
				@online_only_price = ""
			end
			unless @params['is_online_only'] == ""
				@online_only = @params['is_online_only'] == true ? "AND c.OnlineOnly = 1" : "AND c.OnlineOnly = 0"
			else
				@online_only = ""
			end
			
			sql_query = create_sql(@params['return_product_num'], @esrb_ratings, @params['on_hand_quantity'], @availability, @conditions, @params['is_available'], @params['is_searchable'], @product_limit, @excluded_skus, @release_date, @online_only_price, @online_only, @sql)
			@results_from_file = @db.exec_sql("#{sql_query}")
    else
			$tracer.trace("Use SKU from Dataset")
			@results_from_file = @params['sku'].split(",")
		end
		
		# Get Product Details from Catalog Service
		sku_id, *prod_attr, @product = @browser.get_product_from_query(@results_from_file, @catalog_svc, @catalog_svc_version, @params, @session_id)
		products_to_test = @product['product_urls']
		
    products_to_test.each_with_index do |tests, i|
			$tracer.report("VariantID SKU :::::   #{@product['sku_id'][i]}")
			$tracer.trace("Product URL :::::   #{@product['product_urls'][i].to_s.strip}")
			$tracer.trace("Display Name :::::   #{@product['display_name'][i].to_s.strip}")
			$tracer.trace("Platform :::::   #{@product['platform'][i].to_s.strip}")
			$tracer.trace("Platform Count :::::   #{@product['platform_count'][i]}")
			$tracer.trace("Review Count :::::   #{@product['review_count'][i]}")
			$tracer.trace("ESRB Image :::::   #{@product['esrb_img'][i].to_s.strip}")
			$tracer.trace("Developer :::::   #{@product['developer'][i].to_s.strip}")
			$tracer.trace("Publisher :::::   #{@product['publisher'][i].to_s.strip}")
			$tracer.trace("Availability :::::   #{@product['availability'][i].to_s.strip}")
			$tracer.trace("Condition :::::   #{@product['condition'][i].to_s.strip}")
			$tracer.trace("Product Type :::::   #{@product['product_type'][i].to_s.strip.upcase}")
			$tracer.trace("List Price :::::   #{@product['list_price'][i].to_s.strip}")
			
      url = @product['product_urls'][i].to_s.strip
      title = @product['display_name'][i].to_s.strip
			platform = @product['platform'][i].to_s.strip
			platform_count = @product['platform_count'][i].to_i
			review_count = @product['review_count'][i].to_i
			esrb_img = @product['esrb_img'][i].to_s.strip
			developer = @product['developer'][i].to_s.strip
			publisher = @product['publisher'][i].to_s.strip
			availability = @product['availability'][i].to_s.strip
      condition = @product['condition'][i].to_s.strip.upcase
			product_type = @product['product_type'][i].to_s.strip.upcase
      price = @product['list_price'][i].to_s.strip
			is_online_only = @product['is_online_only'][i].to_s.upcase.strip.eql?("TRUE") ? true : false
				
			# Load Product Details Page
			if platform_count > 1
				@browser.open("#{@start_page}/product/multiplatform#{url}")
				$tracer.trace("This product has MULTIPLE platform.")
			else
				@browser.open("#{@start_page}/product#{url}")
				$tracer.trace("This product has SINGLE platform.")
      end
			@browser.wait_for_landing_page_load
			
			# PRODUCT ZEN Cartridge 
			$tracer.trace("PRODUCT ZEN Cartridge")
			### TODO: Create a validation method for this and move it to dsl
			@browser.mgs_prodzen_section.should_exist
			@browser.mgs_prodzen_image.should_exist
			@browser.mgs_prodzen_label.should_exist
			$tracer.report("Product Name :::::   #{title}")
			$tracer.report("Platform :::::   #{platform}")
      @browser.mgs_prodzen_display_name.innerText.strip.should == "#{title}"
			@browser.mgs_prodzen_platform.innerText.strip.should == "#{platform}"
			@browser.mgs_prodzen_release_date.should_exist if (@params['has_release_date'] == true and @params['sku'] == "")
			@browser.mgs_prodzen_rating.should_exist if review_count > 0  
			
			# CONTENT SLOT TABS Cartridge 
			$tracer.trace("CONTENT SLOT TABS Cartridge")
			### TODO: Create a validation method for this and move it to dsl
			@browser.mgs_tabs_content_slot.should_exist
			@browser.mgs_tabs_content_slot.length.should > 0
			i = 0
			while i < @browser.mgs_tabs_content_slot.length
				if @browser.mgs_tab_details.exists == true
					if @browser.mgs_tab_details.call("style.display").include?("block") == true
						puts "^^^^^^^^^^^^^^^^^^^^^^^^^^ DETAILS " 
						@browser.validate_details_panel  
					end
				end
				if @browser.mgs_tab_images.exists == true
					if @browser.mgs_tab_images.call("style.display").include?("block") == true
						@browser.mgs_tab_images_list.length.should > 0
						puts "^^^^^^^^^^^^^^^^^^^^^^^^^^ IMAGES " 
						a = 0
						# while a < @browser.mgs_tab_images_list.length
							@browser.mgs_tab_images_list[a].click
							@browser.wait_for_landing_page_load
							@browser.validate_image_modal
							# a+=1
						# end
					end
				end
				if @browser.mgs_tab_videos.exists == true
					if @browser.mgs_tab_videos.call("style.display").include?("block") == true
						@browser.mgs_tab_videos_list.length.should > 0
						puts "^^^^^^^^^^^^^^^^^^^^^^^^^^ VIDEOS "
						b = 0
						while b < @browser.mgs_tab_videos_list.length
							@browser.mgs_tab_videos_list[b].click
							@browser.wait_for_landing_page_load
							@browser.validate_video_modal
							b+=1
						end
					end
				end
				i+=1
				@browser.mgs_tabs_content_slot[i].click if i < @browser.mgs_tabs_content_slot.length
				@browser.wait_for_landing_page_load
			end
			
			# REVIEWS Cartridge 
			### TODO: Create a validation method for this and move it to dsl
			$tracer.trace("REVIEWS Cartridge")
			unless @browser.mgs_prodreviews_section.call("style.display").eql?("none") == true
				@browser.mgs_prodreviews_section.should_exist
				@browser.mgs_prodreviews_readall_link.innerText.strip.upcase.should == "READ ALL"
				@browser.mgs_prodreviews_label.innerText.strip.upcase.should == "REVIEWS"				
				@browser.mgs_prodreviews_list.length.should > 0
				i=0
				while i < @browser.mgs_prodreviews_list.length
					@browser.mgs_prodreviews_list.at(i).tag_rating.should_exist
					@browser.mgs_prodreviews_list.at(i).comment.should_exist
					i+=1
				end
			else
				$tracer.trace("REVIEWS Cartridge not available for this Product")
			end
		
			# ESRB Cartridge 
			### TODO: Create a validation method for this and move it to dsl
			$tracer.trace("ESRB Cartridge")
			unless esrb_img == ""
				@browser.mgs_prodrating_section.should_exist
				@browser.mgs_prodrating_label.should_exist
				@browser.mgs_prodrating_image.get("src").include?("#{esrb_img}").should == true
				$tracer.report("ESRB Image :::::   #{esrb_img}")
				@browser.mgs_prodrating_details.should_exist
				@browser.mgs_prodrating_publisher.innerText.strip.should include "#{developer}"
				@browser.mgs_prodrating_publisher.innerText.strip.should include "#{publisher}"
				$tracer.report("Developer :::::   #{developer}")
				$tracer.report("Publisher :::::   #{publisher}")
			else
				$tracer.report("ESRB Cartridge not available for NONE Rating Products")
				@browser.mgs_prodrating_section.should_not_exist
			end
			
			# PURCHASE OPTIONS Cartridge 
			$tracer.trace("PURCHASE OPTIONS Cartridge")
			@browser.mgs_product_purchaseopt_section.should_exist

			if is_online_only == true or (product_type == "DIGITAL" and condition == "NEW")
				@browser.mgs_shipopt_list.should_not_exist
			end
			
			@browser.mgs_purchaseopt_section.should_exist
			@browser.mgs_purchaseopt_list.length.should > 0
			i=0
			while i < @browser.mgs_purchaseopt_list.length
				unless availability == "NFS"
						@browser.mgs_purchaseopt_label[0].should_exist
						if @params['is_online_only_price'] == true
							@browser.mgs_purchaseopt_onlineonly.at(0).should_exist 
							@browser.mgs_purchaseopt_onlineonly.at(0).innerText.strip.should == "(Online Only)"
						end
						condition = "PRE-OWNED" if condition == "USED"
						condition = "DIGITAL" if (product_type == "DIGITAL" and condition == "NEW")
						condition_ui = @browser.mgs_purchaseopt_condition[0].innerText.strip.upcase
						condition_ui.should == "#{condition}"
						$tracer.trace("SVC :::::  #{condition}     UI :::::  #{condition_ui}")
						
						list_price_svc = money_string_to_decimal(price)
						list_price_ui = money_string_to_decimal(@browser.mgs_purchaseopt_price[0].innerText.strip.gsub(/[$]/,''))
						list_price_svc.should == list_price_ui
						$tracer.trace("SVC :::::  #{list_price_svc}     UI :::::  #{list_price_ui}")
				else
					@browser.mgs_purchaseopt_label[0].innerText.strip.upcase.should include "NOT AVAILABLE ONLINE"
					@browser.mgs_purchaseopt_condition[0].should_not_exist
					@browser.mgs_purchaseopt_price[0].innerText.strip.should include "N/A"
				end
				i+=1
			end
			
			# RECOMMENDATIONS Cartridge
			$tracer.trace("RECOMMENDATIONS Cartridge")
			if @browser.mgs_prodrecommendations_section.exists == true
				i = 0
				while i < @browser.mgs_prodrecommendations_section.length
					if @browser.mgs_prodrecommendations_section.at(i).is_visible == true
						@browser.mgs_prodrecommendations_section.at(i).header.should_exist
						# Validations - Recommendation Subtitle
						if @params['device'].upcase.strip == "TABLET"
							@browser.mgs_prodrecommendations_section.at(i).description.is_visible.should == true
						else
							@browser.mgs_prodrecommendations_section.at(i).description.is_visible.should == false
						end						
						@browser.mgs_prodrecommendations_section.at(i).product_list.length.should > 0
						a = 0
						while a < @browser.mgs_prodrecommendations_section.at(i).product_list.length
							product_list = @browser.mgs_prodrecommendations_section.at(i).product_list
							product_list.at(a).product_link.should_exist
							product_list.at(a).product_image.should_exist
							product_list.at(a).product_label.should_exist
							product_list.at(a).product_link.click
							@browser.wait_for_landing_page_load
							@browser.back
							@browser.wait_for_landing_page_load
							a+=1
						end
					end
					i+=1
				end
			end
			
			@browser.take_snapshot("BERT")
		 end
 
	end	

	def create_sql(return_product_num, esrb_rating, on_hand_quantity, availability, condition, is_available, searchable, product_limit, excluded_skus, release_date, online_only_price, online_only, sql)
    template = explode_sql_from_file(sql)
		sql = ERB.new(template).result(binding)
    $tracer.trace("#{sql}")
    return sql
  end

  def explode_sql_from_file(filename)
    sql = ""
    filename = filename.gsub(/\\/, "/")
    if File.file?(filename)
      expanded_filename = File.realdirpath(filename)
      begin
        sql = File.read(expanded_filename)
      rescue Exception => ex
        raise ToolException.new(ex, "unable to perform sql statement, cannot read '#{expanded_filename}': #{ex.message}")
      end
    else
      raise Exception, "unable to perform sql statement: unable to locate '#{filename}'"
    end

    return sql
  end
	

end
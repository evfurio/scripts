require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

describe "Impulse Sanity Click Script" do

    before(:all) do

        WebSpec.default_timeout 30000
		
		# Environment Prefix to use in URLs
		@web_env_prefix = "http://qa1."
		@secure_env_prefix = "https://qa1."
		
		# URL domains to use and validate against
		@web_domain = "www.impulsedriven.com/"
		@store_domain = "impulsestore.gamestop.com/"
		@developer_domain = "developer.impulsedriven.com/"
		
        @start_page = (@web_env_prefix + @web_domain)
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

    it "should verify GameStop PC Downloads link is correct" do
        @browser.gamestop_logo_pc_downloads_link.should_exist
		@browser.gamestop_logo_pc_downloads_link.click
		@browser.url.should == @web_env_prefix+@web_domain
		#Verify home page is displayed by looking for Hero Ad
		@browser.hero_banner.should_exist
	end	
		
    it "should verify the View Cart link is correct" do
		#@browser.powered_by_impulse_image.should_exist
        
		@browser.view_cart_link.should_exist
		@browser.view_cart_link.click
		sleep 10
		@browser.url.should == @secure_env_prefix + @store_domain + 'cart.aspx?theme=impulse3'
		#Verify cart page is displayed by looking for My Cart label
		@browser.my_cart_label.should_exist
	end
	
	it "should verify the Checkout link is correct" do	
		@browser.checkout_link.should_exist
		@browser.checkout_link.click
		sleep 10
		@browser.url.should == @secure_env_prefix + @store_domain + 'checkout.aspx?theme=impulse3'
		#Verify cart page is displayed by looking for My Cart label
		@browser.my_cart_label.should_exist
	end
	
	it "should verify the Genre menu is present in the header" do	
        @browser.genres_menu_list.should_exist
	end
	
	it "should verify the Publishers menu is present in the header" do	
        @browser.publishers_menu_list.should_exist	
	end
	
	it "should verify the Browse By menu is present in the header" do	
        @browser.browse_by_menu_list.should_exist	
	end
	
	it "should verify the Forums header link is correct" do	
        @browser.forums_button.should_exist
		@browser.forums_button.click
		@browser.url.should == @web_env_prefix + 'forums.impulsedriven.com/'
		#Verify forums page is displayed by looking for Recent Posts label
		@browser.forums_recent_posts_label.should_exist
	end
	
	it "should verify the Support header link is correct" do	    
		@browser.support_button.should_exist
		@browser.support_button.click
		@browser.url.should == @web_env_prefix + @web_domain + 'support'
		#Verify support page is displayed by looking for Support label
		@browser.support_label.should_exist
	end
	
	it "should verify the Search field in the header is displayed" do	    
        @browser.search_field.should_exist
	end
	
	it "should verify the Search button in the header links correctly" do	    	
		@browser.search_field.value = "Delve Deeper"
        @browser.search_button.should_exist
		@browser.search_button.click
		@browser.url.should == @web_env_prefix + @web_domain + 'explore'
		
		#Verify you are on the Search Results page for Delve Deeper
		list = @browser.product_list
		list.should_exist
		item = list.at(0)
		item.should_exist
		item.product_title_link.innerText.should == "Delve Deeper"
    end


    it "should have a genres header menu that contains all appropriate items" do
        genre_arr = ["Action", "Adventure", "Casual", "MMO", "Puzzle", "RPGs", "Shooters", "Simulations", "Sports", "Strategy", "Explore All"] # order matters

        genre_arr.each_with_index do |g,i|
			menu = @browser.genres_menu_list
			menu.should_exist
			
            item = menu.at(i)
            $tracer.trace("Genre : " + g)
			item.should_exist
            item.innerText.should == g
			
			item.click
			case g
				when "Shooters"
					@browser.url.should == @web_env_prefix + @web_domain + 'explore/games/first-person_shooters'
					# Verify first result in page contains correct genre
					@browser.product_list.at(0).product_genre_label.inner_text.should include g
					
				when "Explore All"
					@browser.url.should == @web_env_prefix + @web_domain + 'explore/games'
				else
					#Code added to convert upperase to lowercase
					@browser.url.should == @web_env_prefix + @web_domain + 'explore/games/' + (g.downcase)
					
					# Verify first result in page contains correct genre
					@browser.product_list.at(0).product_genre_label.inner_text.should include g
			end
			@browser.open(@start_page)
        end
    end

    it "should have a publishers header menu that contains all appropriate items" do
        publishers_arr = [
            "Electronic Arts", "Ubisoft", "THQ", "Bethesda Softworks", "Activision", "Capcom", "Focus Home Interactive",
            "Kalypso Media", "Paradox Interactive", "Square Enix"
        ]

        publishers_arr.each do |p|
			menu = @browser.publishers_menu_list
			menu.should_exist
		
			item = menu.find(p)
			$tracer.trace("Publisher : " + p)
            item.should_exist
            item.innerText.should == p
			
			item.click
			#Code added to convert uppercase to lowercase and convert spaces into _
			@browser.url.should == @web_env_prefix + @web_domain + 'publisher/' + (p.downcase).tr(' ','_')
			
			#Verify first result in page has correct publisher
			@browser.product_list.at(0).product_publisher_label.inner_text.should == p
			@browser.open(@start_page)
        end
    end
	
	# it "should foo" do
		# @browser.open("http://qa1.www.impulsedriven.com/nwn")
		    # if @browser.source.include? "Age Verification"
			# $tracer.trace("age_year_selector")
			# tag = ToolTag.new(@browser.select.name("/year/"), "age_year_selector")
			# tag.option("1968").selected = true

			# $tracer.trace("submit_button")
			# tag = ToolTag.new(@browser.input.value("Submit"), "submit_button")
			# tag.click
			# end
	# end
	

    it "should have a browse by header menu that contains all appropriate items" do
        browse_by_arr = ["Top Sellers", "New Releases", "On Sale", "Coming Soon", "Explore All"] # order matters

        browse_by_arr.each_with_index do |b,i|
			menu = @browser.browse_by_menu_list
			menu.should_exist
			
            item = menu.at(i)
			$tracer.trace("Browse By : " + b)
            item.should_exist
            item.innerText.should == b
			
			item.click
			
			case b
				when "Top Sellers"
					@browser.url.should == @web_env_prefix + @web_domain + 'explore/games/sort/popularity/order/asc?om=bsellermore'
				when "New Releases"
					@browser.url.should == @web_env_prefix + @web_domain + 'explore/games/newreleases?om=anowmore'
				when "On Sale"
					@browser.url.should == @web_env_prefix + @web_domain + 'explore/games/onsale?om=onsalemore'
				when "Coming Soon"
					@browser.url.should == @web_env_prefix + @web_domain + 'explore/games/availability;preorder?om=csoonmore'
				when "Explore All"
					@browser.url.should == @web_env_prefix + @web_domain + 'explore/games'
			end
			
			# Verify first result in page contains a title 
			@browser.product_list.at(0).product_title_link.should_exist
			
			@browser.open(@start_page)
        end
    end

    it "should have hero ad present" do
        @browser.hero_left_arrow_button.should_exist
        @browser.hero_banner.should_exist
        @browser.hero_right_arrow_button.should_exist
    
		@browser.hero_banner.click
		### Commenting out and replacing with next validation due to URLs being created by marketing
		# @browser.url.should start_with(@web_env_prefix + @web_domain)
		
		## Will not work with qa1 since inner links are hardcoded by marketing
		# @browser.url.should start_with("http://"+ @web_domain)
		
		# WEB AGE GATE
		# If we got the age gate, change the year to an "old enough" value
        # and click "Continue".
        # If not, don't worry about that.
		if @browser.source.include? "Age Verification"
			$tracer.trace("age_year_selector")
			tag = ToolTag.new(@browser.select.name("/year/"), "age_year_selector")
			tag.option("1968").selected = true
			
			$tracer.trace("submit_button")
			tag = ToolTag.new(@browser.input.value("Submit"), "submit_button")
			tag.click
		end
		
		#Check if it is a product detail page or a search results page
		if @browser.url.include? "explore/search/"
			### Commenting out and replacing with next validation due to URLs being created by marketing
			# @browser.url.should start_with(@web_env_prefix + @web_domain)
			@browser.url.should start_with("http://"+ @web_domain)
			# Verify first result in page contains a title 
			@browser.product_list.at(0).product_title_link.should_exist
		else
			### Commenting out and replacing with next validation due to URLs being created by marketing
			# @browser.url.should start_with(@web_env_prefix + @web_domain)
			@browser.url.should start_with("http://"+ @web_domain)
			#Verify the Product Detail page is displayed
			@browser.product_header_label.should_exist
		end
	end

    it "should have download now ad present" do
        @browser.download_now_button.should_exist
        @browser.download_now_button.click
		@browser.url.should == @web_env_prefix + @web_domain + 'about'
	
	end

	it "should have daily deal present" do
		@browser.daily_deal_link.should_exist
		@browser.daily_deal_link.click
		### Commenting out and replacing with next validation due to URLs being created by marketing
		# @browser.url.should start_with(@web_env_prefix + @web_domain)
		@browser.url.should start_with("http://"+ @web_domain)
			
		# WEB AGE GATE
		# If we got the age gate, change the year to an "old enough" value
        # and click "Continue".
        # If not, don't worry about that.
		if @browser.source.include? "Age Verification"
			$tracer.trace("age_year_selector")
			tag = ToolTag.new(@browser.select.name("/year/"), "age_year_selector")
			tag.option("1968").selected = true
			
			$tracer.trace("submit_button")
			tag = ToolTag.new(@browser.input.value("Submit"), "submit_button")
			tag.click
		end
				
		#Check if it is a product detail page or a search results page
		if @browser.url.include? "explore/search/"
			### Commenting out and replacing with next validation due to URLs being created by marketing
			# @browser.url.should start_with(@web_env_prefix + @web_domain)
			@browser.url.should start_with("http://"+ @web_domain)
			# Verify first result in page contains a title 
			@browser.product_list.at(0).product_title_link.should_exist
		else
			### Commenting out and replacing with next validation due to URLs being created by marketing
			# @browser.url.should start_with(@web_env_prefix + @web_domain)
			@browser.url.should start_with("http://"+ @web_domain)
			#Verify the Product Detail page is displayed
			@browser.product_header_label.should_exist
		end
		@browser.product_header_label.should_exist
		
    end

    it "should have announcements rss and list, each with date and title" do
        @browser.announcements_rss_button.should_exist
		@browser.announcements_rss_button.click
		@browser.url.should == @web_env_prefix + 'www.impulsedriven.com/rss/news'
		
		@browser.source.include? "Game releases and breaking news."
		
		@browser.open(@start_page)
		
        list = @browser.announcements_list
        list.should_exist
		
        for i in (0...@browser.announcements_list.length-1)

			@browser.announcements_list.at(i).date_label.should_exist
			@browser.announcements_list.at(i).date_label.innerText.should match(/[A-Z][a-z]+, [A-Z][a-z]+ [0-3][0-9], 20[0-9]{2}/) # ie. Thursday, August 04, 2011
            news_date = @browser.announcements_list.at(i).date_label.innerText
			
			@browser.announcements_list.at(i).title_label.should_exist
			
			#Check if Game title link exists in announcement
			## Will not work with qa1 since inner links are hardcoded by marketing
			# if @browser.announcements_list.at(i).announcement_link.innerText != "read more"
				# # @browser.announcements_list.at(i).title_label.should_exist
				# @browser.announcements_list.at(i).announcement_link.click
				# ### Commenting out and replacing with next validation due to URLs being created by marketing
				# # @browser.url.should start_with(@web_env_prefix + @web_domain)
				# @browser.url.should start_with("http://"+ @web_domain)
				
				# #Verify the Product Detail page is displayed
				# @browser.product_header_label.should_exist
				
				# @browser.open(@start_page)
			
			# end
			
			@browser.announcements_list.at(i).read_more_link.should_exist
			@browser.announcements_list.at(i).read_more_link.click
			@browser.url.should start_with(@web_env_prefix + @web_domain + 'news/')
			
			#Verify News Article Detail is displayed
			@browser.news_article_date_label.innerText.should == news_date
			
			@browser.open(@start_page)
        end
    end

    it "should have a feature games rss and list with exactly 6 items, with buy or pre-purchase button" do
        @browser.featured_games_rss_button.should_exist
		@browser.featured_games_rss_button.click
		@browser.url.should == @web_env_prefix + @web_domain + 'rss/gamesbestsellers'
		
		#Verify RSS Feeds page is displayed
		@browser.source.include? "Weekly best sellers."
		#@browser.rss_feed_subtitle_label.innerText.should == 'Weekly best sellers.'
		
		@browser.open(@start_page)
		
        list = @browser.featured_games_list
        list.should_exist

        list.length.should == 6 # exactly 6
		
		for i in (0...@browser.featured_games_list.length-1)
		
			#Verify the Product Image Link Works
				@browser.featured_games_list.at(i).product_image_link.should_exist
				@browser.featured_games_list.at(i).product_image_link.click
				
				# WEB AGE GATE
				# If we got the age gate, change the year to an "old enough" value
				# and click "Continue".
				# If not, don't worry about that.
				if @browser.source.include? "Age Verification"
					@browser.url.should start_with(@web_env_prefix + @web_domain)
					$tracer.trace("age_year_selector")
					tag = ToolTag.new(@browser.select.name("/year/"), "age_year_selector")
					tag.option("1968").selected = true
			
					$tracer.trace("submit_button")
					tag = ToolTag.new(@browser.input.value("Submit"), "submit_button")
					tag.click
				end
				
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
				@browser.product_publisher_label.should_exist
			
				#Go back to the Home Page
				@browser.open(@start_page)
				
			#Verify the Product Price Link Works
				@browser.featured_games_list.at(i).price_button.should_exist
				@browser.featured_games_list.at(i).price_button.click
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
			
				#Go back to the Home Page
				@browser.open(@start_page)
			
            if @browser.featured_games_list.at(i).buy_button.exists
                
				#Verify the Buy Link works
					@browser.featured_games_list.at(i).buy_button.should_exist
					@browser.featured_games_list.at(i).buy_button.click
					@browser.url.should start_with(@web_env_prefix + @web_domain)
				
					#Verify the Product Detail page is displayed
					@browser.product_header_label.should_exist
				
			else
				
				#Verify the Pre-Purchase Link works
					@browser.featured_games_list.at(i).pre_purchase_button.should_exist
					@browser.featured_games_list.at(i).pre_purchase_button.click
					@browser.url.should start_with(@web_env_prefix + @web_domain)
			
					#Verify the Product Detail page is displayed
					@browser.product_header_label.should_exist
				
            end
			
			#Go back to the Home Page
			@browser.open(@start_page)
        end
    end


    it "should have a best sellers tab containing 10 items, with buy or pre-purchase button" do
        @browser.best_sellers_tab.should_exist
		
        list = @browser.best_sellers_list
        list.should_exist

        list.length.should == 10 # exactly 10

        for i in (0...@browser.best_sellers_list.length-1)
            #Verify the Product Title Link Works
				@browser.best_sellers_list.at(i).product_title_link.should_exist
				@browser.best_sellers_list.at(i).product_title_link.click
			
				# WEB AGE GATE
				# If we got the age gate, change the year to an "old enough" value
				# and click "Continue".
				# If not, don't worry about that.
				if @browser.source.include? "Age Verification"
					@browser.url.should start_with(@web_env_prefix + @web_domain)
					$tracer.trace("age_year_selector")
					tag = ToolTag.new(@browser.select.name("/year/"), "age_year_selector")
					tag.option("1968").selected = true
				
					$tracer.trace("submit_button")
					tag = ToolTag.new(@browser.input.value("Submit"), "submit_button")
					tag.click
				end
			
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
				
				#Go back to the Home Page
				@browser.open(@start_page)
            
			#Verify the Product Image Link Works
				@browser.best_sellers_list.at(i).product_image_link.should_exist
				@browser.best_sellers_list.at(i).product_image_link.click
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
			
				#Go back to the Home Page
				@browser.open(@start_page)

			#Verify the Product Price Link Works				
				@browser.best_sellers_list.at(i).price_button.should_exist
				@browser.best_sellers_list.at(i).price_button.click
				
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
			
				#Go back to the Home Page
				@browser.open(@start_page)
            
			if @browser.best_sellers_list.at(i).buy_button.exists
				#Verify the Buy Link works
					@browser.best_sellers_list.at(i).buy_button.should_exist
					@browser.best_sellers_list.at(i).buy_button.click
					@browser.url.should start_with(@web_env_prefix + @web_domain)
					
					#Verify the Product Detail page is displayed
					@browser.product_header_label.should_exist
            else
				#Verify Pre-Purchase Link Works
					@browser.best_sellers_list.at(i).pre_purchase_button.should_exist
					@browser.best_sellers_list.at(i).pre_purchase_button.click
					@browser.url.should start_with(@web_env_prefix + @web_domain)
					
					#Verify the Product Detail page is displayed
					@browser.product_header_label.should_exist
            end

			#Go back to the Home Page
			@browser.open(@start_page)
        end
    end

    it "should have an available now tab containing 10 items, with buy button" do
        @browser.available_now_tab.should_exist
		
        list = @browser.available_now_list
        list.should_exist

        list.length.should == 10 # exactly 10

        for i in (0...@browser.available_now_list.length-1)
			 #Verify the Product Title Link Works
				@browser.available_now_list.at(i).product_title_link.should_exist
				@browser.available_now_list.at(i).product_title_link.click
				
				# WEB AGE GATE
				# If we got the age gate, change the year to an "old enough" value
				# and click "Continue".
				# If not, don't worry about that.
				if @browser.source.include? "Age Verification"
					@browser.url.should start_with(@web_env_prefix + @web_domain)
					$tracer.trace("age_year_selector")
					tag = ToolTag.new(@browser.select.name("/year/"), "age_year_selector")
					tag.option("1968").selected = true
				
					$tracer.trace("submit_button")
					tag = ToolTag.new(@browser.input.value("Submit"), "submit_button")
					tag.click
				end
			
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
				
				#Go back to the Home Page
				@browser.open(@start_page)
				
			#Verify the Product Image Link Works
				@browser.available_now_list.at(i).product_image_link.should_exist
				@browser.available_now_list.at(i).product_image_link.click
			
				@browser.url.should start_with(@web_env_prefix + @web_domain)
				
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
			
				#Go back to the Home Page
				@browser.open(@start_page)
			
			#Verify the Product Price Link Works	
				@browser.available_now_list.at(i).price_button.should_exist
				@browser.available_now_list.at(i).price_button.click
				
				@browser.url.should start_with(@web_env_prefix + @web_domain)
				
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
			
				#Go back to the Home Page
				@browser.open(@start_page)
				
			#Verify the Buy Link works				
				@browser.available_now_list.at(i).buy_button.should_exist
				@browser.available_now_list.at(i).buy_button.click
				
				@browser.url.should start_with(@web_env_prefix + @web_domain)
				
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
			
				#Go back to the Home Page
				@browser.open(@start_page)
        end
    end

    it "should have a coming soon tab containing 10 items, with pre-purchase button" do
        @browser.coming_soon_tab.should_exist
		
        list = @browser.coming_soon_list
        list.should_exist

        list.length.should >= 1

        for i in (0...@browser.coming_soon_list.length-1)
			#Verify the Product Title Link Works
                @browser.coming_soon_list.at(i).product_title_link.should_exist
				@browser.coming_soon_list.at(i).product_title_link.click
				
				# WEB AGE GATE
				# If we got the age gate, change the year to an "old enough" value
				# and click "Continue".
				# If not, don't worry about that.
				if @browser.source.include? "Age Verification"
					@browser.url.should start_with(@web_env_prefix + @web_domain)
					$tracer.trace("age_year_selector")
					tag = ToolTag.new(@browser.select.name("/year/"), "age_year_selector")
					tag.option("1968").selected = true
				
					$tracer.trace("submit_button")
					tag = ToolTag.new(@browser.input.value("Submit"), "submit_button")
					tag.click
				end
			
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
				
				#Go back to the Home Page
				@browser.open(@start_page)
			
			#Verify the Product Image Link Works
				@browser.coming_soon_list.at(i).product_image_link.should_exist
				@browser.coming_soon_list.at(i).product_image_link.click
				
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
			
				#Go back to the Home Page
				@browser.open(@start_page)
			
			#Verify the Product Price Link Works	
				@browser.coming_soon_list.at(i).price_button.should_exist
				@browser.coming_soon_list.at(i).price_button.click
			
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
			
				#Go back to the Home Page
				@browser.open(@start_page)
				
			#Verify the Pre-Purchase Link works
				@browser.coming_soon_list.at(i).pre_purchase_button.should_exist
				@browser.coming_soon_list.at(i).pre_purchase_button.click
			
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
			
				#Go back to the Home Page
				@browser.open(@start_page)
        end
    end

    it "should have an on sale tab containing at least 1 item, with buy button, and buy button" do
        @browser.on_sale_tab.should_exist
		
        list = @browser.on_sale_list
        list.should_exist

        list.length.should >= 1  # at least 1

        for i in (0...@browser.on_sale_list.length-1)
			#Verify the Product Title Link Works
				@browser.on_sale_list.at(i).product_title_link.should_exist
				@browser.on_sale_list.at(i).product_title_link.click
				
				# WEB AGE GATE
				# If we got the age gate, change the year to an "old enough" value
				# and click "Continue".
				# If not, don't worry about that.
				if @browser.source.include? "Age Verification"
					@browser.url.should start_with(@web_env_prefix + @web_domain)
					$tracer.trace("age_year_selector")
					tag = ToolTag.new(@browser.select.name("/year/"), "age_year_selector")
					tag.option("1968").selected = true
				
					$tracer.trace("submit_button")
					tag = ToolTag.new(@browser.input.value("Submit"), "submit_button")
					tag.click
				end
			
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
				
				#Go back to the Home Page
				@browser.open(@start_page)
				
			#Verify the Product Image Link Works
				@browser.on_sale_list.at(i).product_image_link.should_exist
				@browser.on_sale_list.at(i).product_image_link.click
				
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
				
				#Go back to the Home Page
				@browser.open(@start_page)
				
			#Verify the Product Price Link Works					
				@browser.on_sale_list.at(i).price_button.should_exist
				@browser.on_sale_list.at(i).price_button.click
				
				@browser.url.should start_with(@web_env_prefix + @web_domain)
			
				#Verify the Product Detail page is displayed
				@browser.product_header_label.should_exist
				
				#Go back to the Home Page
				@browser.open(@start_page)
				
			if @browser.on_sale_list.at(i).buy_button.exists
				#Verify the Buy Link works
					@browser.on_sale_list.at(i).buy_button.should_exist
					@browser.on_sale_list.at(i).buy_button.click
					
					@browser.url.should start_with(@web_env_prefix + @web_domain)
			
					#Verify the Product Detail page is displayed
					@browser.product_header_label.should_exist
					
				else
				#Verify Pre-Purchase Link Works
					@browser.on_sale_list.at(i).pre_purchase_button.should_exist
					@browser.on_sale_list.at(i).pre_purchase_button.click
					
					@browser.url.should start_with(@web_env_prefix + @web_domain)
			
					#Verify the Product Detail page is displayed
					@browser.product_header_label.should_exist
				end
				
				#Go back to the Home Page
				@browser.open(@start_page)
        end
    end

	## New Browser Window
    it "should have a correct GameStop Network link " do
		@browser.part_of_the_gamestop_network_logo_link.should_exist
		### Commented out due to WebSpec unable to bring up second browser window
		# @browser.part_of_the_gamestop_network_logo_link.click
		# @browser.url.should == 'http://www.gamestop.com/pcgames'
	end
	
	## New Browser Window
	it "should have a correct GameStop link " do
		@browser.gamestop_logo_link.should_exist
		### Commented out due to WebSpec unable to bring up second browser window
		# @browser.gamestop_logo_link.click
		# @browser.url.should == 'http://www.gamestop.com/'
	end
	
	## New Browser Window
	it "should have a correct GameInformer link " do
		@browser.gameinformer_logo_link.should_exist
		### Commented out due to WebSpec unable to bring up second browser window
		# @browser.gameinformer_logo_link.click
		# @browser.url.should == 'http://www.gameinformer.com/'
	end
	
	## New Browser Window
	it "should have a correct Kongregate link " do
		@browser.kongregate_logo_link.should_exist
		### Commented out due to WebSpec unable to bring up second browser window
		# @browser.kongregate_logo_link.click
		# @browser.url.should == 'http://www.kongregate.com/'
	end
	
	# About Section of the Footer
	it "should have a correct About label " do
		@browser.about_label.should_exist
	end
	
	it "should have a correct Corporate link " do	
		@browser.corporate_link.should_exist
		### Commented out due to WebSpec unable to bring up second browser window
		# @browser.corporate_link.click
		# @browser.url.should == 'http://news.gamestop.com/'
	end
	
	it "should have a correct About GameStop PC Downloads link " do		
		@browser.about_impulse_link.should_exist
		@browser.about_impulse_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'about')
		# @browser.download_pc_app_button.should_exist
	end
	
	it "should have a correct Developers link " do
		@browser.developers_link.should_exist
		@browser.developers_link.click
		@browser.url.should == (@secure_env_prefix + @developer_domain)
		@browser.developer_login_link.should_exist
	end
	
	it "should have a correct Developer Tools link " do		
		@browser.developers_tools_link.should_exist
		@browser.developers_tools_link.click
		@browser.url.should == (@secure_env_prefix + @developer_domain + '#tools')
		@browser.developer_login_link.should_exist
	end
		
	# Genres Section of the Footer
	it "should have a correct Genres label" do	
		@browser.genres_label.should_exist
	end

	it "should have a correct Action Genre link " do		
		@browser.action_link.should_exist
		@browser.action_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/action')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Action"
	end
	
	it "should have a correct Adventure Genre link " do		
		@browser.adventure_link.should_exist
		@browser.adventure_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/adventure')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Adventure"
	end
	
	it "should have a correct Casual Genre link " do				
		@browser.casual_link.should_exist
		@browser.casual_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/casual')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Casual"
	end
	
	it "should have a correct Indie Publishers Genre link " do				
		@browser.indie_publishers_link.should_exist
		@browser.indie_publishers_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/independent')
		# Cannot search for "Independent" Genre since one doesnt exist - instead make sure product list is displayed
		@browser.product_list.at(0).product_title_link.should_exist
	end
	
	it "should have a correct MMO Genre link " do			
		@browser.mmo_link.should_exist
		@browser.mmo_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/mmo')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "MMO"
	end
	
	it "should have a correct Puzzle Genre link " do					
		@browser.puzzle_link.should_exist
		@browser.puzzle_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/puzzle')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Puzzle"
	end
	
	it "should have a correct RPGs Genre link " do				
		@browser.rpgs_link.should_exist
		@browser.rpgs_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/rpgs')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "RPGs"
	end
	
	it "should have a correct Shooters Genre link " do					
		@browser.shooters_link.should_exist
		@browser.shooters_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/first-person_shooters')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "First-Person Shooters"
	end
	
	it "should have a correct Simulations Genre link " do			
		@browser.simulation_link.should_exist
		@browser.simulation_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/simulations')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Simulations"
	end
	
	it "should have a correct Sports Genre link " do		
		@browser.sports_link.should_exist
		@browser.sports_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/sports')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Sports"
	end
	
	it "should have a correct Staff Picks Genre link " do				
		@browser.staff_picks_link.should_exist
		@browser.staff_picks_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/staff_picks')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Staff Picks"
	end
	
	it "should have a correct Strategy Genre link " do						
		@browser.strategy_link.should_exist
		@browser.strategy_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/strategy')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Strategy"
	end	
	
	# Categories Section of the Footer
	it "should have a correct Categories label " do
		@browser.categories_label.should_exist
	end
	
	it "should have a correct Top Sellers link " do							
		@browser.top_sellers_link.should_exist
		@browser.top_sellers_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/sort/popularity/order/asc')
		# Verify first result in page contains a title 
		@browser.product_list.at(0).product_title_link.should_exist
	end
	
	it "should have a correct New Releases link " do						
		@browser.new_releases_link.should_exist
		@browser.new_releases_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games')
		# Verify first result in page contains a title 
		@browser.product_list.at(0).product_title_link.should_exist
	end
	
	it "should have a correct On Sale link " do					
		@browser.on_sale_link.should_exist
		@browser.on_sale_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/onsale')
		# Verify first result in page contains a title 
		@browser.product_list.at(0).product_title_link.should_exist
	end
	
	it "should have a correct Coming Soon link " do						
		@browser.coming_soon_link.should_exist
		@browser.coming_soon_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/availability/preorder')
		# Verify first result in page contains a title 
		@browser.product_list.at(0).product_title_link.should_exist
	end
		

	# Keep in Touch Section of the Footer	
	it "should have a correct Keep in Touch label " do
		@browser.keep_in_touch_label.should_exist
	end
	
	it "should have a correct Support link " do						
		@browser.support_link.should_exist
		@browser.support_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'support')
		@browser.support_label.should_exist
	end

	it "should have a correct GameStop Events link " do							
		@browser.gamestop_events_link.should_exist
		### Commented out due to WebSpec unable to bring up second browser window
		# @browser.gamestop_events_link.click
		# @browser.browser_count.should == 2
		# @browser.browser(1)
		# @browser.url.should == ('http://www.gamestop.com/gs/gamestopevents/')
		# @browser.close
		# @browser.browser_count.should == 1
	end
	
	it "should have a correct Blogs link " do			
		@browser.blogs_link.should_exist
		@browser.blogs_link.click
		@browser.url.should == (@web_env_prefix + 'www.impulsedriven.net/')
		@browser.community_log_in_label.should_exist
	end
	
	it "should have a correct Forums link " do					
		@browser.forums_link.should_exist
		@browser.forums_link.click
		@browser.url.should == (@web_env_prefix + 'forums.impulsedriven.com/')
		@browser.forums_recent_posts_label.should_exist
	end	
	
	# Legal Section of the Footer
	it "should have a correct Copyright Label" do						
		@browser.impulse_copyright_label.should_exist
	end
	
	it "should have a correct License Link" do							
		@browser.license_link.should_exist
		@browser.license_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'license')
		@browser.gamestop_pc_downloads_eula_label.should_exist
	end
	
	it "should have a correct Sales FAQ link " do					
		@browser.sales_faq_link.should_exist
		@browser.sales_faq_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'support/sales-faq')
		@browser.gamestop_support_sales_faq_label.should_exist
	end
	
	it "should have a correct Privacy Policy link " do						
		@browser.privacy_policy_link.should_exist
		@browser.privacy_policy_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'support/privacy')
		@browser.gamestop_pc_downloads_privacy_policy_label.should_exist
	end
	
	it "should have a correct Return Policy link " do							
		@browser.return_policy_link.should_exist
		@browser.return_policy_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'support/returns')
		@browser.gamestop_pc_downloads_return_policy_label.should_exist
	end
	
	it "should have a correct Terms of Service link " do						
		@browser.terms_of_service_link.should_exist
		@browser.terms_of_service_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'terms')
		@browser.gamestop_pc_downloads_terms_of_service_label.should_exist
	end
	
	# Connect Section of the Footer
	it "should have a correct Connect label" do					
		@browser.connect_label.should_exist
	end
	
	it "should have a correct Twitter link " do							
		@browser.twitter_link.should_exist
		@browser.twitter_link.click
		@browser.url.should == 'http://twitter.com/#!/gamestopdl'
	end  		
	
	it "should have a correct Facebook link " do							
		@browser.facebook_link.should_exist
		@browser.facebook_link.click
		@browser.url.should == 'http://www.facebook.com/gamestopdownloads'
	end  
	
	it "should have a correct RSS Feed link " do	
		@browser.announcements_rss_link.should_exist
		@browser.announcements_rss_link.click
		@browser.url.should == (@web_env_prefix + @web_domain + 'rss/news')
		@browser.source.include? "Game releases and breaking news."
    end

end

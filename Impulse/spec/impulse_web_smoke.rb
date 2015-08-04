require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

describe "Impulse Web Smoke Script" do

    before(:all) do
		########## This script is run using impulse_smoke_variables.csv ###########
		csv = QACSV.new(csv_filename_parameter)
		@row = csv.find_row_by_name(csv_range_parameter)
	
		WebSpec.default_timeout 30000
		
		# Environment Prefix to use in URLs
		@web_env_prefix = ("http://" + @row.find_value_by_name("Env_Prefix"))
		@secure_env_prefix = ("https://" + @row.find_value_by_name("Env_Prefix"))
		
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

	it "should have a proper header" do
        @browser.gamestop_logo_pc_downloads_link.should_exist
        @browser.powered_by_impulse_image.should_exist
        @browser.view_cart_link.should_exist
        @browser.checkout_link.should_exist
        @browser.genres_menu_list.should_exist
        @browser.publishers_menu_list.should_exist
        @browser.browse_by_menu_list.should_exist

        @browser.forums_button.should_exist
        @browser.support_button.should_exist

        @browser.search_field.should_exist
        @browser.search_button.should_exist
    end
	
	it "should verify the Support header link is correct" do	    
		@browser.support_button.should_exist
		@browser.support_button.click
		@browser.url.should == @web_env_prefix + @web_domain + 'support'
		#Verify support page is displayed by looking for Support label
		@browser.support_label.should_exist
	end
	
	it "should verify the Search button in the header links correctly" do	    	
		@browser.search_field.value = "Dead Island"
        @browser.search_button.should_exist
		@browser.search_button.click
		@browser.url.should == @web_env_prefix + @web_domain + 'explore'
		
		#Verify you are on the Search Results page for Dead Island
		list = @browser.product_list
		list.should_exist
		item = list.at(0)
		item.should_exist
		item.product_title_link.innerText.should == "Dead Island"
		item.product_title_link.click
		
		#Verify the Product Detail page is displayed
		################ MUST UPDATE FINDER ################
		# @browser.product_header_label.should_exist
		
    end


    it "should have a genres header menu that contains the Action genre" do
        genre_arr = ["Action"] 

        genre_arr.each_with_index do |g,i|
			menu = @browser.genres_menu_list
			menu.should_exist
			
            item = menu.at(i)
            $tracer.trace("Genre : " + g)
			item.should_exist
            item.innerText.should == g
			
			item.click
			#Code added to convert upperase to lowercase
			@browser.url.should == @web_env_prefix + @web_domain + 'explore/games/' + (g.downcase)
					
			# Verify first result in page contains correct genre
			@browser.product_list.at(0).product_genre_label.inner_text.should include g
			
        end
    end


    it "should have a browse by header menu that contains all appropriate items" do
        browse_by_arr = ["Top Sellers"] 

        browse_by_arr.each_with_index do |b,i|
			menu = @browser.browse_by_menu_list
			menu.should_exist
			
            item = menu.at(i)
			$tracer.trace("Browse By : " + b)
            item.should_exist
            item.innerText.should == b
			
			item.click
			
			@browser.url.should == @web_env_prefix + @web_domain + 'explore/games/sort/popularity/order/asc?om=bsellermore'
			
			# Verify first result in page contains a title 
			@browser.product_list.at(0).product_title_link.should_exist
			
		end
    end

    it "should have hero ad present" do
        @browser.hero_left_arrow_button.should_exist
        @browser.hero_banner.should_exist
        @browser.hero_right_arrow_button.should_exist
    
	end

    it "should have download now ad present" do
        @browser.download_now_link.should_exist
     	
	end

	it "should have daily deal present" do
		@browser.daily_deal_link.should_exist
	
    end

    it "should have announcements rss and list, each with date and title" do
        @browser.announcements_rss_button.should_exist
		@browser.announcements_rss_button.click
		@browser.url.should == @web_env_prefix + 'www.impulsedriven.com/rss/news'
		
		@browser.source.include? "Game releases and breaking news."
		
		@browser.open(@start_page)
		
        list = @browser.announcements_list
        list.should_exist
		
        # for i in (0...1)

			# ################ MUST UPDATE FINDER ################
			# # @browser.announcements_list.at(i).date_label.should_exist
			# # @browser.announcements_list.at(i).date_label.innerText.should match(/[A-Z][a-z]+, [A-Z][a-z]+ [0-3][0-9], 20[0-9]{2}/) # ie. Thursday, August 04, 2011
            # # news_date = @browser.announcements_list.at(i).date_label.innerText
			
			# ################ Not Valid in ebspec with IE9 ############
			# @browser.announcements_list.at(i).title_label.should_exist
			
        # end
    end

    it "should have a feature games rss and list with exactly 6 items" do
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
		
		################ MUST UPDATE FINDER ################
		# for i in (0...1)
		
			# #Verify the Product Image Link Works
				# @browser.featured_games_list.at(i).product_image_link.should_exist
								
			# #Verify the Product Price Link Works
				# @browser.featured_games_list.at(i).price_button.should_exist
				
	
        # end
    end


    it "should have a best sellers tab containing 10 items" do
        @browser.best_sellers_tab.should_exist
		
        list = @browser.best_sellers_list
        list.should_exist

        list.length.should == 10 # exactly 10

        for i in (0...1)
            #Verify the Product Title Link Works
				@browser.best_sellers_list.at(i).product_title_link.should_exist
				
			#Verify the Product Image Link Works
				@browser.best_sellers_list.at(i).product_image_link.should_exist
				
			#Verify the Product Price Link Works				
				@browser.best_sellers_list.at(i).price_button.should_exist
			            

        end
    end

    it "should have an available now tab containing 10 items, with buy button" do
        @browser.available_now_tab.should_exist
		
        list = @browser.available_now_list
        list.should_exist

        list.length.should == 10 # exactly 10

        for i in (0...1)
			 #Verify the Product Title Link Works
				@browser.available_now_list.at(i).product_title_link.should_exist
				
			#Verify the Product Image Link Works
				@browser.available_now_list.at(i).product_image_link.should_exist
			
			#Verify the Product Price Link Works	
				@browser.available_now_list.at(i).price_button.should_exist
			
			#Verify the Buy Link works				
				@browser.available_now_list.at(i).buy_button.should_exist
			
        end
    end

    it "should have a coming soon tab containing 10 items, with pre-purchase button" do
        @browser.coming_soon_tab.should_exist
		
        list = @browser.coming_soon_list
        list.should_exist

        list.length.should >= 1

        for i in (0...1)
			#Verify the Product Title Link Works
                @browser.coming_soon_list.at(i).product_title_link.should_exist
				
			#Verify the Product Image Link Works
				@browser.coming_soon_list.at(i).product_image_link.should_exist
				
			#Verify the Product Price Link Works	
				@browser.coming_soon_list.at(i).price_button.should_exist
			
			#Verify the Pre-Purchase Link works
				@browser.coming_soon_list.at(i).pre_purchase_button.should_exist
				
        end
    end

    it "should have an on sale tab containing at least 1 item, with buy button, and buy button" do
        @browser.on_sale_tab.should_exist
		
        list = @browser.on_sale_list
        list.should_exist

        list.length.should >= 1  # at least 1

        for i in (0...1)
			#Verify the Product Title Link Works
				@browser.on_sale_list.at(i).product_title_link.should_exist
				
			#Verify the Product Image Link Works
				@browser.on_sale_list.at(i).product_image_link.should_exist
			
			#Verify the Product Price Link Works					
				@browser.on_sale_list.at(i).price_button.should_exist
			
			if @browser.on_sale_list.at(i).buy_button.exists
				#Verify the Buy Link works
					@browser.on_sale_list.at(i).buy_button.should_exist
					
				else
				#Verify Pre-Purchase Link Works
					@browser.on_sale_list.at(i).pre_purchase_button.should_exist
				
				end
				
        end
    end


    it "should have a proper footer" do
      @browser.part_of_the_gamestop_network_logo_link.should_exist
      @browser.gamestop_logo_link.should_exist
      @browser.gameinformer_logo_link.should_exist
      @browser.kongregate_logo_link.should_exist
      @browser.about_label.should_exist
      @browser.genres_label.should_exist
      @browser.categories_label.should_exist
      @browser.keep_in_touch_label.should_exist
      @browser.corporate_link.should_exist
      @browser.about_impulse_link.should_exist
      @browser.developers_link.should_exist
      @browser.developers_tools_link.should_exist
      @browser.action_link.should_exist
      @browser.adventure_link.should_exist
      @browser.casual_link.should_exist
      @browser.indie_publishers_link.should_exist
      @browser.mmo_link.should_exist
      @browser.puzzle_link.should_exist
      @browser.rpgs_link.should_exist
      @browser.shooters_link.should_exist
      @browser.simulation_link.should_exist
      @browser.sports_link.should_exist
      @browser.staff_picks_link.should_exist
      @browser.strategy_link.should_exist
      @browser.top_sellers_link.should_exist
      @browser.new_releases_link.should_exist
      @browser.on_sale_link.should_exist
      @browser.coming_soon_link.should_exist
      @browser.support_link.should_exist
      @browser.gamestop_events_link.should_exist
      @browser.forums_link.should_exist
      @browser.impulse_copyright_link.should_exist
      @browser.license_link.should_exist
      @browser.sales_faq_link.should_exist
      @browser.privacy_policy_link.should_exist
      @browser.return_policy_link.should_exist
      @browser.terms_of_service_link.should_exist
      @browser.connect_label.should_exist
      @browser.twitter_link.should_exist
      @browser.facebook_link.should_exist
      @browser.announcements_rss_link.should_exist
    end


end

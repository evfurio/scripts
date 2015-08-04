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
		
        # @start_page = (@secure_env_prefix + @store_domain + "cart.aspx")
		# @start_page = (@secure_env_prefix + @store_domain + "ns/login")
		@start_page = (@secure_env_prefix + @store_domain + "redeempos")
        # if os_name == "darwin"
            # @browser = ImpulseBrowser.new.safari
        # else
            # @browser = ImpulseBrowser.new.ie
        # end

        $snapshots.setup(@browser, :all)
        $tracer.mode = :on
        $tracer.echo = :on
    end

    before(:each) do
        if os_name == "darwin"
            @browser = ImpulseBrowser.new.safari
        else
            @browser = ImpulseBrowser.new.ie
        end	
        @browser.browser(0).open(@start_page)
    end
	
	after(:each) do
		@browser.close_all
	end
		
    after(:all) do
        $tracer.trace("after :all")
        @browser.close_all
    end


	## New Browser Window
    it "should have a correct GameStop Network link " do
		@browser.part_of_the_gamestop_network_logo_link.should_exist
		### Commented out due to WebSpec unable to bring up second browser window
		@browser.part_of_the_gamestop_network_logo_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == 'http://www.gamestop.com/pcgames'
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	## New Browser Window
	it "should have a correct GameStop link " do
		@browser.gamestop_logo_link.should_exist
		### Commented out due to WebSpec unable to bring up second browser window
		@browser.gamestop_logo_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == 'http://www.gamestop.com/'
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	## New Browser Window
	it "should have a correct GameInformer link " do
		@browser.gameinformer_logo_link.should_exist
		### Commented out due to WebSpec unable to bring up second browser window
		@browser.gameinformer_logo_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == 'http://www.gameinformer.com/'
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	## New Browser Window
	it "should have a correct Kongregate link " do
		@browser.kongregate_logo_link.should_exist
		### Commented out due to WebSpec unable to bring up second browser window
		@browser.kongregate_logo_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == 'http://www.kongregate.com/'
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	# About Section of the Footer
	it "should have a correct About label " do
		@browser.about_label.should_exist
	end
	
	it "should have a correct Corporate link " do	
		@browser.corporate_link.should_exist
		### Commented out due to WebSpec unable to bring up second browser window
		@browser.corporate_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == 'http://news.gamestop.com/'
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct About GameStop PC Downloads link " do		
		@browser.about_impulse_link.should_exist
		@browser.about_impulse_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'about')
		# @browser.download_pc_app_button.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Developers link " do
		@browser.developers_link.should_exist
		@browser.developers_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@secure_env_prefix + @developer_domain)
		@browser.developer_login_link.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	# it "should have a correct Developer Tools link " do		
		# @browser.developers_tools_link.should_exist
		# @browser.developers_tools_link.click
		# sleep 1
		# @browser.browser_count.should == 2
		# @browser.browser(1)		
		# @browser.url.should == (@secure_env_prefix + @developer_domain + '#tools')
		# @browser.developer_login_link.should_exist
		# @browser.close
		# sleep 1
		# @browser.browser_count.should == 1
		# @browser.browser(0)	
	# end
		
	# Genres Section of the Footer
	it "should have a correct Genres label" do	
		@browser.genres_label.should_exist
	end

	it "should have a correct Action Genre link " do		
		@browser.action_link.should_exist
		@browser.action_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/action')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Action"
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Adventure Genre link " do		
		@browser.adventure_link.should_exist
		@browser.adventure_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/adventure')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Adventure"
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Casual Genre link " do				
		@browser.casual_link.should_exist
		@browser.casual_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/casual')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Casual"
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Indie Publishers Genre link " do				
		@browser.indie_publishers_link.should_exist
		@browser.indie_publishers_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/independent')
		# Cannot search for "Independent" Genre since one doesnt exist - instead make sure product list is displayed
		@browser.product_list.at(0).product_title_link.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct MMO Genre link " do			
		@browser.mmo_link.should_exist
		@browser.mmo_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/mmo')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "MMO"
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Puzzle Genre link " do					
		@browser.puzzle_link.should_exist
		@browser.puzzle_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/puzzle')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Puzzle"
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct RPGs Genre link " do				
		@browser.rpgs_link.should_exist
		@browser.rpgs_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/rpgs')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "RPGs"
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Shooters Genre link " do					
		@browser.shooters_link.should_exist
		@browser.shooters_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/first-person_shooters')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "First-Person Shooters"
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Simulations Genre link " do			
		@browser.simulation_link.should_exist
		@browser.simulation_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/simulations')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Simulations"
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Sports Genre link " do		
		@browser.sports_link.should_exist
		@browser.sports_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)	
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/sports')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Sports"
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Staff Picks Genre link " do				
		@browser.staff_picks_link.should_exist
		@browser.staff_picks_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)	
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/staff_picks')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Staff Picks"
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)		
	end
	
	it "should have a correct Strategy Genre link " do						
		@browser.strategy_link.should_exist
		@browser.strategy_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)	
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/strategy')
		@browser.product_list.at(0).product_genre_label.inner_text.should include "Strategy"
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)		
	end	
	
	# Categories Section of the Footer
	it "should have a correct Categories label " do
		@browser.categories_label.should_exist
	end
	
	it "should have a correct Top Sellers link " do							
		@browser.top_sellers_link.should_exist
		@browser.top_sellers_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)	
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/sort/popularity/order/asc')
		# Verify first result in page contains a title 
		@browser.product_list.at(0).product_title_link.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)		
	end
	
	it "should have a correct New Releases link " do						
		@browser.new_releases_link.should_exist
		@browser.new_releases_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)	
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games')
		# Verify first result in page contains a title 
		@browser.product_list.at(0).product_title_link.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)		
	end
	
	it "should have a correct On Sale link " do					
		@browser.on_sale_link.should_exist
		@browser.on_sale_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)	
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/onsale')
		# Verify first result in page contains a title 
		@browser.product_list.at(0).product_title_link.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)		
	end
	
	it "should have a correct Coming Soon link " do						
		@browser.coming_soon_link.should_exist
		@browser.coming_soon_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'explore/games/availability/preorder')
		# Verify first result in page contains a title 
		@browser.product_list.at(0).product_title_link.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)		
	end
		

	# Keep in Touch Section of the Footer	
	it "should have a correct Keep in Touch label " do
		@browser.keep_in_touch_label.should_exist
	end
	
	it "should have a correct Support link " do						
		@browser.support_link.should_exist
		@browser.support_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'support')
		@browser.support_label.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)		
	end

	it "should have a correct GameStop Events link " do							
		@browser.gamestop_events_link.should_exist
		### Commented out due to WebSpec unable to bring up second browser window
		@browser.gamestop_events_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)
		@browser.url.should == ('http://www.gamestop.com/gs/gamestopevents/')
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)
	end

	it "should have a correct Forums link " do					
		@browser.forums_link.should_exist
		@browser.forums_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@secure_env_prefix + 'forums.impulsedriven.com/')
		@browser.forums_recent_posts_label.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end	
	
	# Legal Section of the Footer
	it "should have a correct Copyright Label" do						
		@browser.impulse_copyright_label.should_exist
	end
	
	it "should have a correct License Link" do							
		@browser.license_link.should_exist
		@browser.license_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'license')
		@browser.gamestop_pc_downloads_eula_label.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Sales FAQ link " do					
		@browser.sales_faq_link.should_exist
		@browser.sales_faq_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'support/sales-faq')
		@browser.gamestop_support_sales_faq_label.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Privacy Policy link " do						
		@browser.privacy_policy_link.should_exist
		@browser.privacy_policy_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'support/privacy')
		@browser.gamestop_pc_downloads_privacy_policy_label.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Return Policy link " do							
		@browser.return_policy_link.should_exist
		@browser.return_policy_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'support/returns')
		@browser.gamestop_pc_downloads_return_policy_label.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	it "should have a correct Terms of Service link " do						
		@browser.terms_of_service_link.should_exist
		@browser.terms_of_service_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'terms')
		@browser.gamestop_pc_downloads_terms_of_service_label.should_exist
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end
	
	# Connect Section of the Footer
	it "should have a correct Connect label" do					
		@browser.connect_label.should_exist
	end
	
	it "should have a correct Twitter link " do							
		@browser.twitter_link.should_exist
		@browser.twitter_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == 'http://twitter.com/#!/gamestopdl'
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end  		
	
	it "should have a correct Facebook link " do							
		@browser.facebook_link.should_exist
		@browser.facebook_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == 'https://www.facebook.com/gamestopdownloads'
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
	end  
	
	it "should have a correct RSS Feed link " do	
		@browser.announcements_rss_link.should_exist
		@browser.announcements_rss_link.click
		sleep 1
		@browser.browser_count.should == 2
		@browser.browser(1)		
		@browser.url.should == (@web_env_prefix + @web_domain + 'rss/news')
		@browser.source.include? "Game releases and breaking news."
		@browser.close
		sleep 1
		@browser.browser_count.should == 1
		@browser.browser(0)	
    end

end

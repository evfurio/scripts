require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

describe "Impulse Sanity" do

    before(:all) do

        WebSpec.default_timeout 30000
        @start_page = "http://www.impulsedriven.com"
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


    it "should have a genres header menu that contains all appropriate items" do
        genre_arr = ["Action", "Adventure", "Casual", "MMO", "Puzzle", "RPGs", "Shooters", "Simulations", "Sports", "Strategy", "Explore All"] # order matters

        menu = @browser.genres_menu_list
        menu.should_exist

        genre_arr.each_with_index do |g,i|
            item = menu.at(i)
            item.should_exist
            item.innerText.should == g
        end
    end

    it "should have a publishers header menu that contains all appropriate items" do
        publishers_arr = [
            "Electronic Arts", "Ubisoft", "THQ", "Bethesda Softworks", "Activision", "Capcom", "Focus Home Interactive",
            "Kalypso Media", "Paradox Interactive", "Square Enix"
        ]

        menu = @browser.publishers_menu_list
        menu.should_exist

        publishers_arr.each do |p|
            item = menu.find(p)
            item.should_exist
            item.innerText.should == p
        end
    end

    it "should have a browse by header menu that contains all appropriate items" do
        browse_by_arr = ["Top Sellers", "New Releases", "On Sale", "Coming Soon", "Explore All"] # order matters

        menu = @browser.browse_by_menu_list
        menu.should_exist

        browse_by_arr.each_with_index do |b,i|
            item = menu.at(i)
            item.should_exist
            item.innerText.should == b
        end
    end

    it "should have hero ad present" do
        @browser.hero_left_arrow_button.should_exist
        @browser.hero_banner.should_exist
        @browser.hero_right_arrow_button.should_exist
    end

    it "should have download and daily deal present" do
        @browser.download_now_button.should_exist
        # commented out until it's decided how QA is to behave
        # (currently, no deal of the day is displayed unless refreshed daily)
        #@browser.daily_deal_link.should_exist
    end

    it "should have announcements rss and list, each with date and title" do
        @browser.announcements_rss_button.should_exist

        list = @browser.announcements_list
        list.should_exist
        for i in (0...list.length)
            item = list.at(i)
            item.should_exist
            item.date_label.should_exist
            item.title_label.should_exist
            item.date_label.innerText.should match(/[A-Z][a-z]+, [A-Z][a-z]+ [0-3][0-9], 20[0-9]{2}/) # ie. Thursday, August 04, 2011
            item.read_more_link.should_exist
        end
    end

    it "should have a feature games rss and list with exactly 6 items, with buy or pre-purchase button" do
        @browser.featured_games_rss_button.should_exist

        list = @browser.featured_games_list
        list.should_exist

        list.length.should == 6 # exactly 6

        for i in (0...list.length)
            item = list.at(i)
            item.should_exist
            item.product_image_link.should_exist
            item.price_button.should_exist

            if item.buy_button.exists
                item.buy_button.should_exist
            else
                item.pre_purchase_button.should_exist
            end
        end
    end


    it "should have a best sellers tab containing 10 items, with buy button" do
        @browser.best_sellers_tab.should_exist
        list = @browser.best_sellers_list
        list.should_exist

        list.length.should == 10

        for i in (0...list.length)
            item = list.at(i)
            item.should_exist
            item.product_title_link.should_exist
            item.product_image_link.should_exist
            item.price_button.should_exist
            
            if item.buy_button.exists
                item.buy_button.should_exist
            else
                item.pre_purchase_button.should_exist
            end

        end
    end

    it "should have an available now tab containing 10 items, with buy button" do
        @browser.available_now_tab.should_exist
        list = @browser.available_now_list
        list.should_exist

        list.length.should == 10

        for i in (0...list.length)
            item = list.at(i)
            item.should_exist
            item.product_title_link.should_exist
            item.product_image_link.should_exist
            item.price_button.should_exist
            item.buy_button.should_exist
        end
    end

    it "should have a coming soon tab containing 10 items, with pre-purchase button" do
        @browser.coming_soon_tab.should_exist
        list = @browser.coming_soon_list
        list.should_exist

        list.length.should == 10

        for i in (0...list.length)
            item = list.at(i)
            item.should_exist
            item.product_title_link.should_exist
            item.product_image_link.should_exist
            item.price_button.should_exist
            item.pre_purchase_button.should_exist
        end
    end

    it "should have an on sale tab containing at least 1 item, with buy button, and buy button" do
        @browser.on_sale_tab.should_exist
        list = @browser.on_sale_list
        list.should_exist

        list.length.should >= 1  # at least 1

        for i in (0...list.length)
            item = list.at(i)
            item.should_exist
            item.product_title_link.should_exist
            item.product_image_link.should_exist
            item.price_button.should_exist
            item.buy_button.should_exist

            if item.buy_button.exists
                item.buy_button.should_exist
            else
                item.pre_purchase_button.should_exist
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
      @browser.blogs_link.should_exist
      @browser.forums_link.should_exist
      @browser.impulse_copyright_label.should_exist
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

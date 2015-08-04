#USAGE NOTES#
# this script is for the GameInformer Weekend maintenance
# all scenarios are associated with a manual test case in MTM
# GameInformer project/Regression Tests plan

### QA ENV ###
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Weekend_Maint.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS66752 --browser chrome --or

### PRODUCTION ENV ###
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Weekend_Maint.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS66753 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameInformer/dsl/src/dsl"

$tracer.mode = :on
$tracer.echo = :on
$global_functions = GlobalFunctions.new()

describe "GI Weekend Maintenance" do

  # define methods for generating name/email
  def auto_generate_username(t = nil)
	  t ||= Time.now
	  return "gi" + t.strftime("%Y%m%d_%H%M%S")
  end
	
	def auto_generate_emailaddr(t = nil)
	  t ||= Time.now
	  return "gi" + t.strftime("%Y%m%d_%H%M%S") + "@gspcauto.fav.cc"
	end

  before(:all) do
    $options.default_timeout = 30_000
    @browser = WebBrowser.new(browser_type_parameter)
    $snapshots.setup(@browser, :all)

    #Get the parameters from the csv dataset
    @params = $global_functions.csv
    puts @params['PROP_URL']
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    $user_pwd = @params['user_pwd']
    $admin_user = @params["admin_user"]
    $admin_pwd = @params["admin_pwd"]
    $digimag_user = @params["digimag_user"]
    $digimag_pwd = @params["digimag_pwd"]
    $search_name = @params["search_name"]
    $do_prod = @params["do_prod"]
  end
	
  before(:each) do
    @browser.open(@start_page)
    @browser.cookie.all.delete	
	  GameInformerBrowser.delete_temporary_internet_files(browser_type_parameter)
    sleep 3
  end	

  after(:each) do

  end
		
  after(:all) do
    $tracer.trace("after all")
    @browser.close_all()
  end

  it "should create a new account through control panel / membership admin" do

    # not running in prod, only qa
    pending("NOT EXECUTED - IN PRODUCTION") if $do_prod

    # login with admin user
    @browser.sign_in_link.should_exist
	  @browser.sign_in_link.click
	  @browser.sign_in_label.innerText.should == "Sign in"
    @browser.sign_in_name_field.value = $admin_user
	  @browser.sign_in_password_field.value = $admin_pwd
	  @browser.keep_signedin_checkbox.click
	  @browser.keep_signedin_checkbox.checked = false
	  @browser.sign_in_button.click
	  @browser.feed_tabs_panel.should_exist
	  @browser.user_profile_name_link.value == $admin_user
    
	  # go to control panel and create random-ish user
	  username = auto_generate_username
	  emailaddr = auto_generate_emailaddr
		
	  @browser.control_panel_link.click
	  @browser.membership_admin_link.click
	  @browser.membership_admin_label.should_exist
	  @browser.create_new_acct_link.click
	  @browser.adm_signin_name_field.should_exist
	  @browser.adm_signin_name_field.value = username
	  @browser.adm_password_field.value = $user_pwd
	  @browser.adm_reenter_password_field.value = $user_pwd
	  @browser.adm_email_address_field.value = emailaddr
	  @browser.adm_timezone_field.option.selected(true).innerText.strip.should == "(UTC-06:00) Central Time (US & Canada)"
    sleep 2
	  @browser.adm_create_acct_button.click
    @browser.adm_user_create_success_label.should_exist
	  sleep 2
  end    
  
  it "testing DSLs" do

    # not running in prod, only qa
    pending("NOT EXECUTED - IN PRODUCTION") if $do_prod

    # login with admin user - dsl
	  @browser.login_user_admin($admin_user, $admin_pwd)
    
	  # go to control panel and create random-ish user - dsl
    @browser.create_user_admin($user_pwd, $user_pwd)
	  sleep 2
  end    
  
  it "26458 - GI Footer" do
    # Cover Stories panel on footer
   list = @browser.footer_cover_stories_label("Cover Stories")
	  length = list.length
	  $tracer.trace(list.at(0).inner_text)
   (0..( length - 1) ).each do | x |
	  destination_name = list.at(x).innerText
   $tracer.trace(destination_name)
	  list.at(x).click
	  @browser.url.should_not == @start_page
	  @browser.head.title.innerText.should match(/#{destination_name}/)
	  @browser.open(@start_page)
	  list = @browser.footer_cover_stories_label("Cover Stories")
  end

   # hubs panel on footer
	  list = @browser.footer_cover_stories_label("Hubs")
	  length = list.length
	  $tracer.trace(list.at(0).inner_text)
   (0..( length - 1) ).each do | x |
	  destination_name = list.at(x).innerText.downcase
   $tracer.trace(destination_name)
   list.at(x).click
	  @browser.url.should_not == @start_page
	  @browser.head.title.innerText.downcase.should match(/#{destination_name}/)
	  @browser.open(@start_page)
	  list = @browser.footer_cover_stories_label("Hubs")
	end

   # Podcasts panel on footer
   list = @browser.footer_cover_stories_label("Podcasts")
	  length = list.length
	  $tracer.trace(list.at(0).inner_text)
   (0..( length - 1) ).each do | x |
	  destination_name = list.at(x).innerText.downcase
   $tracer.trace(destination_name)
   $tracer.trace(list.at(x).innerText)
   list.at(x).click
	  @browser.url.should_not == @start_page
	  @browser.head.title.innerText.downcase.should match(/#{destination_name}/i)
	  @browser.open(@start_page)
	  list = @browser.footer_cover_stories_label("Podcasts")
	end

   # Must Read panel on footer
   list = @browser.footer_cover_stories_label("Must Read")
	  length = list.length
	  $tracer.trace(list.at(0).inner_text)
   (0..( length - 1) ).each do | x |
	  destination_name = list.at(x).innerText.downcase
   $tracer.trace(destination_name)
   $tracer.trace(list.at(x).innerText)
   list.at(x).click
	  sleep 3
	  @browser.url.should_not == @start_page
	  @browser.head.title.innerText.downcase.should match(/#{destination_name}/i)
	  @browser.open(@start_page)
	  list = @browser.footer_cover_stories_label("Must Read")
	end

   # Magazine panel on footer
   list = @browser.footer_cover_stories_label("Magazine")
	  length = list.length
	  $tracer.trace(list.at(0).inner_text)
   (0..( length - 1) ).each do | x |
	  destination_name = list.at(x).innerText
   $tracer.trace(destination_name)
   $tracer.trace(list.at(x).innerText)
   list.at(x).click
	  sleep 3
	  @browser.url.should_not == @start_page
	  if destination_name.include?("Read Current Issue")
		@browser.head.title.innerText.should match(/GameInformer - /)
      elsif destination_name.include?("iPad App")
	    @browser.head.title.innerText.should match(/Game Informer on the App Store on iTunes/)
      elsif destination_name.include?("Android App")
	    @browser.head.title.innerText.should match(/Game Informer - Android Apps on Google Play/)
      elsif destination_name.include?("Google Play")
	    @browser.head.title.innerText.should match(/Game Informer - Newsstand on Google Play/)
      elsif destination_name.include?("Cover Gallery")
	    @browser.head.title.innerText.should match(/GameInformer Covers/)
	  else
	    @browser.head.title.innerText.should match(/#{destination_name}/)
	  end
	  @browser.open(@start_page)
	  list = @browser.footer_cover_stories_label("Magazine")
	end

   # Service panel on footer
   list = @browser.footer_cover_stories_label("Service")
	  length = list.length
	  $tracer.trace(list.at(0).inner_text)
   (0..( length - 1) ).each do | x |
	  destination_name = list.at(x).innerText
   $tracer.trace(destination_name)
   $tracer.trace(list.at(x).innerText)
   list.at(x).click
	  sleep 3
	  @browser.url.should_not == @start_page
	  if destination_name.include?("Site Help")
		@browser.head.title.innerText.should match(/www.GameInformer.com/)
      elsif destination_name.include?("Site Feedback")
	    @browser.head.title.innerText.should match(/www.GameInformer.com/)
      elsif destination_name.include?("Service Form")
	    @browser.head.title.innerText.should match(/www.GameInformer.com/)
      elsif destination_name.include?("Registration F.A.Q.")
	    @browser.head.title.innerText.should match(/GameInformer F.A.Q./)
	  else
	    @browser.head.title.innerText.should match(/#{destination_name}/)
	  end
	  @browser.open(@start_page)
	  list = @browser.footer_cover_stories_label("Service")
	end
	
    # gs network on footer
    @browser.footer_gs_network_link.click
    @browser.head.title.innerText.should match(/Video Games for Xbox One, PS4, Wii U, PC, Xbox 360, PS3 & 3DS | GameStop/)
    @browser.open(@start_page)
	
    # gs com on footer
    @browser.footer_gs_com_link.click
    @browser.head.title.innerText.should match(/Video Games for Xbox One, PS4, Wii U, PC, Xbox 360, PS3 & 3DS | GameStop/)
    @browser.open(@start_page)		
	
    # pc downloads on footer
    @browser.footer_pc_downloads_link.click
    @browser.head.title.innerText.should match(/GameStop PC Downloads : Home : Digital Download Store, Latest Gaming News/)
    @browser.open(@start_page)		
	
    # gameinformer on footer
    @browser.footer_gi_link.click
    @browser.head.title.innerText.should match(/Home - www.GameInformer.com/)
    @browser.open(@start_page)
	
    # kongregate on footer		
    @browser.footer_kongregate_link.click
    @browser.head.title.innerText.should match(/Kongregate: Play free games online/)
    @browser.open(@start_page)
	
    # Contact Us on footer		
    @browser.footer_contact_us_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/contactus/)
    test.should equal true	
    @browser.open(@start_page)	
	
    # Staff Bios on footer		
    @browser.footer_staff_bios_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/staff/)
    test.should equal true		
    @browser.open(@start_page)
	
    # Terms and Conditions on footer		
    @browser.footer_terms_conditions_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/terms/)
    test.should equal true		
    @browser.open(@start_page)	
	
    # Privacy Policy on footer		
    @browser.footer_privacy_policy_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/privacy/)
    test.should equal true		
    @browser.open(@start_page)	
	
    # Customer Service on footer		
    @browser.footer_customer_service_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/contactus/)
    test.should equal true		
    @browser.open(@start_page)	
	
    # Corporate Information on footer		
    @browser.footer_corporate_information_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/corporateinfo/)
    test.should equal true		
    @browser.open(@start_page)	
	
    # Advertising on footer		
    @browser.footer_advertising_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/advertising/)
    test.should equal true		
    @browser.open(@start_page)	
	
    # The Laboratory on footer		
    @browser.footer_the_laboratory_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/thelab/)
    test.should equal true		
    @browser.open(@start_page)	
	
    # The twitter link on footer		
    @browser.footer_twitter_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/twitter/)
    test.should equal true	
    @browser.open(@start_page)	

    # The facebook link on footer		
    @browser.footer_facebook_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/facebook/)
    test.should equal true	
    @browser.open(@start_page)	

    # The rss link on footer		
    @browser.footer_rss_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/rss/)
    test.should equal true	
    @browser.open(@start_page)	

    # The youtube link on footer		
    @browser.footer_youtube_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/youtube/)
    test.should equal true	
    @browser.open(@start_page)

    # The webby awards link on footer		
    @browser.footer_webby_awards_link.click
	  @browser.browser(1)
	  sleep 3
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/webbyawards/)
    test.should equal true	
	  @browser.close
	  @browser.browser(0)
	  sleep 2
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/gameinformer/)
    @browser.open(@start_page)

    # The gi logo link on footer		
    @browser.footer_gi_logo_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/gameinformer/)
    test.should equal true	
    @browser.open(@start_page)
	
    # The about link on footer		
    @browser.footer_about_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/corporateinfo/)
    @browser.open(@start_page)
	
    # The join link on footer		
    @browser.footer_join_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/createuser/)
    test.should equal true	
    @browser.open(@start_page)
	
    # The sign in link on footer		
    @browser.footer_sign_in_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/login/)
    test.should equal true	
    @browser.open(@start_page)
  end

  it "26455 - GI Take Part Blog" do
    @browser.sign_in_link.should_exist
    @browser.navlistbar_blogs_link.click	
	  @browser.user_blogs_label.should_exist
	  @browser.user_blogs_list.at(0).should_exist
	  @browser.user_blogs_list.at(0).click
    @browser.user_blogs_post_label.should_exist	
  end 
	
  it "64185 - GI take part community" do
    @browser.sign_in_link.should_exist
    @browser.navlistbar_forums_link.click	
	  @browser.user_forums_label.should_exist
	  @browser.forums_general_gaming_link.click
    @browser.forums_general_gaming_label.should_exist	
	  @browser.forums_gamer_helpline_link.click
	  @browser.forums_posts_list.at(0).should_exist
	  @browser.forums_post_link.at(0).click
	  @browser.forums_post_title_label.should_exist
  end
	
  it "64253 - GI take part guides" do
    @browser.sign_in_link.should_exist
    @browser.navlistbar_guides_link.click	
	  @browser.user_guides_label.should_exist
    @browser.guides_newpages_link.click
	  @browser.user_guides_label.should_exist
    @browser.guides_updatedpages_link.click
	  @browser.user_guides_label.should_exist
	  @browser.guides_allpages_link.click
	  @browser.user_guides_label.should_exist
	  @browser.guides_posts_list.at(0).should_exist
    @browser.guides_posts_link.at(0).click
    # currently broken in prod
    # @browser.guides_posts_title_label.should_exist
  end

  it "64256 - GI: hubs pages testing - exploratory" do
    # normally would not automate exploratory test, this is for weekend maint tho
    @browser.sign_in_link.should_exist
    list = @browser.navlistbar_hubs_link
	  length = list.length
	  $tracer.trace(list.at(0).inner_text)
    (0..( length - 1) ).each do | x |
	  destination_name = list.at(x).innerText
	  $tracer.trace(destination_name)
    $tracer.trace(list.at(x).innerText)
    list.at(x).click
	  sleep 3
	  @browser.url.should_not == @start_page
	  if destination_name.include?("The GI Show")
		@browser.head.title.innerText.should match(/The Game Informer Show/)
      elsif destination_name.include?("More...")
	    @browser.head.title.innerText.should match(/Game Informer Hubs/)
      elsif destination_name.include?("MGS V")
        @browser.head.title.innerText.should match(/Metal Gear Solid V/)
	  else
	    @browser.head.title.innerText.should match(/#{destination_name}/i)	 	  
	  end	  	  
	  @browser.open(@start_page)
	  list = @browser.navlistbar_hubs_link
    end

  end
  
  it "26449 - GI Lights Test" do
    @browser.feed_tabs_panel.should_exist
    @browser.light_switch_button.click
    @browser.light_status_label.innerText.should == "The lights are off"
    @browser.light_switch_button.click
    @browser.light_status_label.innerText.should == "The lights are on"
	  sleep 1
    @browser.feed_tabs_panel.should_exist	
  end  
  
  it "63188 - GI: Digimag flow - user not signed in, registered, linked" do
    @browser.feed_tabs_panel.should_exist
    @browser.navlistbar_digimag_link.click
	  @browser.digital_mag_edition_label.should_exist
	  @browser.pc_mac_mag_button.click
	  @browser.gi_digital_mag_label.should_exist
	  @browser.digimag_signin_name_field.value = $digimag_user
	  @browser.digimag_signin_password_field.value = $digimag_pwd
	  @browser.digimag_keep_signin_checkbox.click
	  @browser.digimag_login_button.click
	  sleep 20
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/editiondigital.net/)
    test.should equal true
  end
  
  it "36425 - GI Join Test (an offshoot for wknd maint)" do

    # not running in prod, only qa
    pending("NOT EXECUTED - IN PRODUCTION") if $do_prod

	# test sign in and join links
    @browser.feed_tabs_panel.should_exist
    @browser.sign_in_link.click
    @browser.sign_in_label.innerText.should == "Sign in"
	  @browser.gi_header_link.click
    @browser.feed_tabs_panel.should_exist
    @browser.join_link.click
    @browser.join_join_label.should_exist
    @browser.gi_header_link.click
	  @browser.feed_tabs_panel.should_exist

    # incorrect captcha from joining
    @browser.feed_tabs_panel.should_exist
	  @browser.join_link.click
	  @browser.join_join_label.should_exist
	  @browser.join_signin_name_field.value = "TestQAAutomation0"
	  @browser.join_choose_password_field.value = "test1234"
	  @browser.join_reenter_password_field.value = "test1234"
    @browser.join_email_address_field.value = "jlafortutest0@gspcauto.fav.cc"  
    @browser.join_reenter_email_address_field.value = "jlafortutest0@gspcauto.fav.cc"
	  sleep 1
	  @browser.join_now_button.click
	  @browser.incorrect_captcha_label.innerText.should == "Please try playing the game below again correctly"
	  $tracer.trace("test over")
  end  
  
  it "26450 - GI News Feed Testfeed links" do
    @browser.newsfeed_community_link.click
    @browser.newsfeed_guides_link.click
    @browser.newsfeed_blogs_link.click	
	  @browser.newsfeed_feed_link.click
    @browser.feed_tabs_panel.should_exist	
  end 
  
  it "26448 - GI Member Groups" do
    @browser.feed_tabs_panel.should_exist
	  @browser.navlistbar_groups_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/membergroups/)
    test.should equal true	
	  @browser.membergroups_gameinformer_label.should_exist
	  @browser.membergroups_sitefeedback_link.click
  	@browser.sitefeedback_sitefeedback_label.should_exist
   	@browser.sitefeedback_blogtab_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/weblog/)
    test.should equal true	
	
	#FIXME
	  # broken in qa/prod right now - will add back to script when forum link fixed###
	  # @browser.sitefeedback_forumtab_link.click
	  # url = @browser.url
	  # $tracer.trace("Trace of URL: " + url)
    # test = true if url.match(/258/)
    # test.should equal true	

	  @browser.sitefeedback_filestab_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/mediagallery/)
    test.should equal true

    # broken in qa/prod right now - will add back to script when forum link fixed###
	  # @browser.sitefeedback_wikitab_link.click
	  # url = @browser.url
	  # $tracer.trace("Trace of URL: " + url)
    # test = true if url.match(/wiki/)
    # test.should equal true
	  @browser.sitefeedback_hometab_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/default/)
    test.should equal true	
	  sleep 2
    @browser.sitefeedback_hometabposts_panel.should_exist
  end 

  it "26452 - GI News" do
    @browser.feed_tabs_panel.should_exist
	  @browser.navlistbar_news_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/news/)
    test.should equal true		
	  @browser.news_recent_link.click
	  @browser.news_recent_link.get("class").should == " active"
	  @browser.news_popular_link.click
	  @browser.news_popular_link.get("class").should == " active"
  end
  
  it "26454 - GI Podcasts" do
    @browser.feed_tabs_panel.should_exist
	  @browser.navlistbar_podcasts_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/podcasts/)
    test.should equal true		
	  @browser.podcasts_podcasts_label.should_exist
	  @browser.podcasts_podcasts_panel.should_exist
  end 

  it "26453 - GI Reviews" do
    @browser.feed_tabs_panel.should_exist
	  @browser.navlistbar_reviews_link.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/reviews/)
    test.should equal true	
	  @browser.reviews_featured_reviews_label.should_exist
	  @browser.reviews_userreviews_button.click
	  @browser.reviews_userreviews_button.get("class").should == "active"
	  @browser.reviews_editorreviews_button.click
	  @browser.reviews_editorreviews_button.get("class").should == "active"
	  @browser.reviews_reviews_panel.should_exist
  end 
  
  it "26447 - GI Site Search" do
    @browser.feed_tabs_panel.should_exist
	  @browser.search_field.value = $search_name
    search_results_name = $search_name
    @browser.search_button.click
	  @browser.search_results_panel.should_exist
	  @browser.head.title.innerText.should match(/#{search_results_name}/i)
  end  
  
end
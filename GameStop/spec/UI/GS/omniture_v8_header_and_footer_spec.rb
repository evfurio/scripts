#Author  - Hanif Khan
# This verifies all eVar8 and its valus on Header and footer against the Data_track/Anchor tag/url values.

# Verify data-track element and eVar3 for omniture.
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\omniture_v8_header_and_footer_spec.rb --browser chrome --or
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\omniture_v8_header_and_footer_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv --url QA2_GS --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

describe "Omniture eVar8 - Header and Footer" do
  before(:all) do

    # Added  proxy information
    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9090"
    @browser = GameStopBrowser.new(browser_type_parameter)

    #Set the ProxyServer
    @proxy = ProxyServerManager.new(9090)

    GameStopBrowser.delete_temporary_internet_files(browser_type_parameter)
    $snapshots.setup(@browser, :all)
    $tracer.mode=:on
    $tracer.echo=:on

  end

  before(:each) do
    @proxy.start

    # Make sure not to capture headers and content
    @proxy.set_capture_headers(false)
    @proxy.set_capture_content(false)

    @start_page = "http://qa.gamestop.com"

    @browser.delete_all_cookies_and_verify
  end

  after(:all) do
    @browser.close_all()
  end

  after(:each) do
    @browser.return_current_url
    @proxy.stop
  end

  it "Validate eVar8 - Need Help Under Header - Navline1 " do

    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    @browser.need_help_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    #v8_value_list[3].should == data_track_product_offers_deals_list_location
    v8_value_list.should include("header", "need help?")
  end

  it "Validate eVar8 - PowerUp Rewards Under Header - Navline1 " do

    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    @browser.powerup_rewards_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    #v8_value_list[3].should == data_track_product_offers_deals_list_location
    v8_value_list.should include("header", "powerup rewards")
  end

  it "Validate eVar8 - Find a Store Under Header - Navline1 " do

    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    @browser.find_a_store_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    #v8_value_list[3].should == data_track_product_offers_deals_list_location
    v8_value_list.should include("header", "find a store")
  end

  it "Validate eVar8 - Gift Cards Under Header - Navline1 " do

    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    @browser.gift_cards_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    #v8_value_list[3].should == data_track_product_offers_deals_list_location
    v8_value_list.should include("header", "gift cards")
  end

  it "Validate eVar8 - Gift Cards Under Header - Navline1 " do

    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    @browser.weekly_ad_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    #v8_value_list[3].should == data_track_product_offers_deals_list_location
    v8_value_list.should include("header", "weekly ad")
  end

  it "Validate eVar8 - GS Logo Under Header - Navline1 " do

    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    @browser.gamestop_logo_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    #v8_value_list[3].should == data_track_product_offers_deals_list_location
    v8_value_list.should include("header")
  end

  it "Validate eVar8 - Promo Banner Under Header - Navline1" do

    #$tracer.trace("Starting tests for Featured Offers and Deals Position number: #{item_count} (0-based)")
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    promo_banner = @browser.header_promo_banner
    data_track_array = promo_banner.get("data-track")
    data_track_product_name = data_track_array

    promo_banner.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1


    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("header", data_track_product_name)
  end
=begin	 
   # Unable to capture proxy due to SSL state. Bob is working on a solution
	it "Validate eVar8 - Sign In Link Under Header - Navline2 " do
		@browser.open(@start_page)
				
		@proxy.start_capture(true) # force new capture
							
		@browser.log_in_link.click
				
		capture_data = @proxy.get_capture
		omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
		@browser.trace_omniture_request_query_strings(omniture_list)
				
		#Used to show what data is being gathered
		#$tracer.trace(capture_data.formatted_json)
		omniture_list.length.should == 1

		#Perform checks
		#omniture_list[0].query_string_hash["events"].should == "event40"
		#omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
		#omniture_list[0].query_string_hash["c14"].should == "logged-in"

		v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
		v8_value_list.length.should == 2
		#v8_value_list[3].should == data_track_product_offers_deals_list_location
		v8_value_list.should include("search", "gift cards")
	end	
	
	it "Validate eVar8 Your cart Button Under Header - Navline2 " do
		@browser.open(@start_page)
				
		@proxy.start_capture(true) # force new capture
							
		@browser.my_cart_button.click
				
		capture_data = @proxy.get_capture
		omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
		@browser.trace_omniture_request_query_strings(omniture_list)
				
		#Used to show what data is being gathered
		#$tracer.trace(capture_data.formatted_json)
		omniture_list.length.should == 1

		#Perform checks
		#omniture_list[0].query_string_hash["events"].should == "event40"
		#omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
		#omniture_list[0].query_string_hash["c14"].should == "logged-in"

		v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
		v8_value_list.length.should == 2
		#v8_value_list[3].should == data_track_product_offers_deals_list_location
		v8_value_list.should include("search", "gift cards")
	end					
=end
  it "Validate eVar8 - XboxOne Menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    menu_name = @browser.xboxone_header_menu.inner_text.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    @browser.xboxone_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end

  it "Validate eVar8 - PS4 Menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    menu_name = @browser.ps4_header_menu.inner_text.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    @browser.ps4_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end

  it "Validate eVar8 - Xbox360 Menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    menu_name = @browser.xbox_360_header_menu.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    @browser.xbox_360_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end

  it "Validate eVar8 - PS3 Menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    menu_name = @browser.ps3_header_menu.inner_text.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    @browser.ps3_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end

  it "Validate eVar8 - PC Menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    menu_name = @browser.pc_header_menu.inner_text.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    @browser.pc_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end

  it "Validate eVar8 - WiiU Menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    menu_name = @browser.wiiu_header_menu.inner_text.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    @browser.wiiu_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end

  it "Validate eVar8 - 3DS Menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    menu_name = @browser._3ds_header_menu.inner_text.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    @browser._3ds_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end

  it "Validate eVar8 - PS Vita Menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    menu_name = @browser.psvita_header_menu.inner_text.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    @browser.psvita_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end

  it "Validate eVar8 - Headsets Under More menu on Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture
    headsets_header_menu = @browser.more_header_menu.at(0)

    menu_name = headsets_header_menu.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    headsets_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-moreplatforms", menu_name)
  end

  it "Validate eVar8 - Wii Under More menu on Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture
    wii_header_menu = @browser.more_header_menu.at(1)

    menu_name = wii_header_menu.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    wii_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-moreplatforms", menu_name)
  end

  it "Validate eVar8 - Nintendo DS Under More menu on Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture
    nintendods_header_menu = @browser.more_header_menu.at(2)

    menu_name = nintendods_header_menu.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    nintendods_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-moreplatforms", menu_name)
  end

  it "Validate eVar8 - PSP Under More menu on Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture
    psp_header_menu = @browser.more_header_menu.at(3)

    menu_name = psp_header_menu.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    psp_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-moreplatforms", menu_name)
  end

  it "Validate eVar8 - PlayStation 2 Under More menu on Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture
    ps2_header_menu = @browser.more_header_menu.at(4)

    menu_name = ps2_header_menu.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    ps2_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-moreplatforms", menu_name)
  end

  it "Validate eVar8 - Xbox Under More menu on Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture
    xbox_header_menu = @browser.more_header_menu.at(5)

    menu_name = xbox_header_menu.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    xbox_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-moreplatforms", menu_name)
  end

  it "Validate eVar8 - GameCube Under More menu on Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture
    gamecube_header_menu = @browser.more_header_menu.at(6)

    menu_name = gamecube_header_menu.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    gamecube_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-moreplatforms", menu_name)
  end

  it "Validate eVar8 - Nintendo GBA Under More menu on Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture
    nintendogba_header_menu = @browser.more_header_menu.at(7)

    menu_name = nintendogba_header_menu.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    nintendogba_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-moreplatforms", menu_name)
  end

  it "Validate eVar8 - Pre-Owned menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture
    preowned_header_menu = @browser.hot_header_menu.at(0)

    menu_name = preowned_header_menu.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    preowned_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end

  it "Validate eVar8 - Trade Offers menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture
    tradeoffers_header_menu = @browser.hot_header_menu.at(1)

    menu_name = tradeoffers_header_menu.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    tradeoffers_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end

  it "Validate eVar8 - Deals menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture
    deals_header_menu = @browser.hot_header_menu.at(2)

    menu_name = deals_header_menu.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    deals_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end

  it "Validate eVar8 - Phones & Media Players menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get value from href url string
    url_string = @browser.phones_header_menu.get("href")
    url = URL.new(url_string)
    url.path
    $tracer.trace("#########Menu name#####"+ url.path)

    menu_name = url.path
    @browser.phones_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end

  it "Validate eVar8 - Tablets & Laptops menu Under Header - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get value from href url string
    url_string = @browser.tablets_header_menu.get("href")
    url = URL.new(url_string)
    url.path
    $tracer.trace("#########Menu name#####"+ url.path)


    menu_name = url.path
    @browser.tablets_header_menu.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("nav", menu_name)
  end


  it "Validate eVar8 - Everyone link under Xbox360 sub menu - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get Menu Name.
    xbox360_everyone_link = @browser.xbox360_sub_menu.at(41)
    menu_name = xbox360_everyone_link.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    xbox360_everyone_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-xbox360", menu_name)
  end

  it "Validate eVar8 - 3D link under PS3 sub menu - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get Menu Name.
    ps3_3d_link= @browser.ps3_sub_menu.at(7)
    menu_name = ps3_3d_link.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    ps3_3d_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-ps3", menu_name)
  end

  it "Validate eVar8 - Under $20 link under PC sub menu - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get Menu Name.
    pc_under20_link = @browser.pc_sub_menu.at(23)
    menu_name = pc_under20_link.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    pc_under20_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-pc", menu_name)
  end

  it "Validate eVar8 - All link under WiiU sub menu - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get Menu Name.
    wiiu_all_link = @browser.wiiu_sub_menu.at(6)
    menu_name = wiiu_all_link.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    wiiu_all_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-wiiu", menu_name)
  end

  it "Validate eVar8 - All link under WiiU sub menu - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get Menu Name.
    controllers_under_3ds = @browser._3ds_sub_menu.at(24)
    menu_name = controllers_under_3ds.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    controllers_under_3ds.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-3ds", menu_name)
  end

  it "Validate eVar8 - Price Drop link under PS Vita sub menu - Navline3 " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get Menu Name.
    pricedrop_under_psvita = @browser.psvita_sub_menu.at(17)
    menu_name = pricedrop_under_psvita.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    pricedrop_under_psvita.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 3
    v8_value_list.should include("nav", "sub-psvita", menu_name)
  end


  it "Validate eVar8 - Upcoming Video Games link under Looking for? - Footer " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get Menu Name.
    upcoming_video_games_link = @browser.footer_menu.at(0)
    menu_name = upcoming_video_games_link.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    upcoming_video_games_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("footer", menu_name)
  end

  it "Validate eVar8 - Sign Up for Deals link under Looking for? - Footer " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get Menu Name.
    signup_for_deals_link = @browser.footer_menu.at(1)
    menu_name = signup_for_deals_link.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    signup_for_deals_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("footer", menu_name)
  end

  it "Validate eVar8 - RSS Feed link under Looking for? - Footer " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get Menu Name.
    rss_feeds_link = @browser.footer_menu.at(2)
    menu_name = rss_feeds_link.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    rss_feeds_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("footer", menu_name)
  end

  it "Validate eVar8 - Events link under Looking for? - Footer " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get Menu Name.
    events_link = @browser.footer_menu.at(3)
    menu_name = events_link.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    events_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("footer", menu_name)
  end

=begin
   # Unable to capture proxy due to SSL state. Bob is working on a solution	
	it "Validate eVar8 - Sweepstakes link under Looking for? - Footer " do
		@browser.open(@start_page)
				
		@proxy.start_capture(true) # force new capture
		
		#Get Menu Name.
		sweepstakes_link = @browser.footer_menu.at(4)
		menu_name = sweepstakes_link.innerText.downcase
		$tracer.trace("#########Menu name#####"+ menu_name)
							
		sweepstakes_link.click
		sleep 10
				
		capture_data = @proxy.get_capture
		omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
		@browser.trace_omniture_request_query_strings(omniture_list)
				
		#Used to show what data is being gathered
		#$tracer.trace(capture_data.formatted_json)
		omniture_list.length.should == 1

		v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
		v8_value_list.length.should == 2
		v8_value_list.should include("footer", menu_name)
	end	
=end
  it "Validate eVar8 - Site Map link under Looking for? - Footer " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get Menu Name.
    site_map_link = @browser.footer_menu.at(5)
    menu_name = site_map_link.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    site_map_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("footer", menu_name)
  end

  it "Validate eVar8 - Help Center link under Need Help? - Footer " do
    @browser.open(@start_page)

    @proxy.start_capture(true) # force new capture

    #Get Menu Name.
    help_center_link = @browser.footer_menu.at(6)
    menu_name = help_center_link.innerText.downcase
    $tracer.trace("#########Menu name#####"+ menu_name)

    help_center_link.click

    capture_data = @proxy.get_capture
    omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
    @browser.trace_omniture_request_query_strings(omniture_list)

    #Used to show what data is being gathered
    #$tracer.trace(capture_data.formatted_json)
    omniture_list.length.should == 1

    #Perform checks
    #omniture_list[0].query_string_hash["events"].should == "event40"
    #omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
    #omniture_list[0].query_string_hash["c14"].should == "logged-in"

    v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
    v8_value_list.length.should == 2
    v8_value_list.should include("footer", menu_name)
  end
=begin	
  # Unable to capture proxy due to SSL state. Bob is working on a solution	
	it "Validate eVar8 - Gift Card Balance link under Need Help? - Footer " do
		@browser.open(@start_page)
				
		@proxy.start_capture(true) # force new capture
		
		#Get Menu Name.
		gift_card_balance_link = @browser.footer_menu.at(7)
		menu_name = gift_card_balance_link.innerText.downcase
		$tracer.trace("#########Menu name#####"+ menu_name)
							
		gift_card_balance_link.click
				
		capture_data = @proxy.get_capture
		omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
		@browser.trace_omniture_request_query_strings(omniture_list)
				
		#Used to show what data is being gathered
		#$tracer.trace(capture_data.formatted_json)
		omniture_list.length.should == 1

		#Perform checks
		#omniture_list[0].query_string_hash["events"].should == "event40"
		#omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
		#omniture_list[0].query_string_hash["c14"].should == "logged-in"

		v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
		v8_value_list.length.should == 2
		v8_value_list.should include("footer", menu_name)	
	end	

	it "Validate eVar8 - Order History link under Need Help? - Footer " do
		@browser.open(@start_page)
				
		@proxy.start_capture(true) # force new capture
		
		#Get Menu Name.
		order_history_link = @browser.footer_menu.at(8)
		menu_name = order_history_link.innerText.downcase
		$tracer.trace("#########Menu name#####"+ menu_name)
							
		order_history_link.click
				
		capture_data = @proxy.get_capture
		omniture_list = @browser.get_omniture_request_query_strings_for_url((capture_data), "metrics.gamestop.com")
		@browser.trace_omniture_request_query_strings(omniture_list)
				
		#Used to show what data is being gathered
		#$tracer.trace(capture_data.formatted_json)
		omniture_list.length.should == 1

		#Perform checks
		#omniture_list[0].query_string_hash["events"].should == "event40"
		#omniture_list[0].query_string_hash["c12"].should == "qa_ui_testing1@qagsecomprod.oib.com"
		#omniture_list[0].query_string_hash["c14"].should == "logged-in"

		v8_value_list = omniture_list[0].query_string_hash["v8"].split("|")
		v8_value_list.length.should == 2
		v8_value_list.should include("footer", menu_name)	
	end	
=end
end
	


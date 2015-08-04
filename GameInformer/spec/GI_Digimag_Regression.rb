#USAGE NOTES#
# this script is for the GameInformer Digital Magazine regression
# all scenarios are associated with a manual test case in MTM
# GameInformer project/Regression Tests plan

### QA ENV ###
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Digimag_Regression.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS65812 --browser chrome --or
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Digimag_Regression.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS63188 --browser chrome --or
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Digimag_Regression.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS63191 --browser chrome --or
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Digimag_Regression.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS63190 --browser chrome --or
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Digimag_Regression.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS63189 --browser chrome --or
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Digimag_Regression.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS63192 --browser chrome --or

### PRODUCTION ENV ###
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Digimag_Regression.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS67045 --browser chrome --or
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Digimag_Regression.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS67040 --browser chrome --or
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Digimag_Regression.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS67041 --browser chrome --or
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Digimag_Regression.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS67042 --browser chrome --or
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Digimag_Regression.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS67043 --browser chrome --or
# d-con %QAAUTOMATION_SCRIPTS%\GameInformer\spec\GI_Digimag_Regression.rb --csv %QAAUTOMATION_SCRIPTS%\GameInformer\spec\gameinformer_cs_dataset.csv --range TFS67044 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameInformer/dsl/src/dsl"

$tracer.mode = :on
$tracer.echo = :on
$global_functions = GlobalFunctions.new()

describe "GI Digimag Regression" do

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
    $digimag_zip = @params["digimag_zip"]
    $digimag_crm = @params["digimag_crm"]
    $do_prod = @params["do_prod"]
  end
	
  before(:each) do
    @browser.open(@start_page)
    @browser.cookie.all.delete	
	  WebBrowser.delete_temporary_internet_files(browser_type_parameter)
    sleep 3
  end	

  after(:all) do
    $tracer.trace("after all")
    @browser.close_all()
  end


  it "should test dsl for validating digimag sub" do
    @browser.validate_digimag_subscription($digimag_user, $digimag_pwd)
  end

  it "65812 - GI: digimag exploratory functional charter" do
    # automating part of this test, to validate links to other pages, page objects, etc.
    # testing out the 4 digimag type buttons (IOS, PC, Android x 2)
    @browser.feed_tabs_panel.should_exist
    @browser.navlistbar_digimag_link.click
	  @browser.digital_mag_edition_label.should_exist
	  @browser.pc_mac_mag_button.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/bluetoadmag/)
    test.should be_true
	  @browser.open(@start_page)

    @browser.feed_tabs_panel.should_exist
    @browser.navlistbar_digimag_link.click
	  @browser.digital_mag_edition_label.should_exist
	  @browser.digimag_apple_store_button.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/itunes.apple/)
    test.should be_true
    @browser.open(@start_page) 

	  @browser.feed_tabs_panel.should_exist
    @browser.navlistbar_digimag_link.click
	  @browser.digital_mag_edition_label.should_exist
	  @browser.digimag_google_play_button.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/apps/)
    test.should be_true
    @browser.open(@start_page) 
	
    @browser.feed_tabs_panel.should_exist
    @browser.navlistbar_digimag_link.click
	  @browser.digital_mag_edition_label.should_exist
	  @browser.digimag_google_magazine_button.click
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/newsstand/)
    test.should be_true	
    @browser.open(@start_page) 
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
	  sleep 10
	  url = @browser.url
	  $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/editiondigital.net/)
    test.should equal true
  end
 
  it "63191 - GI: Digimag flow - user signed in, registered, linked" do
    @browser.feed_tabs_panel.should_exist
    @browser.login_user_admin($digimag_user, $digimag_pwd)
    @browser.navlistbar_digimag_link.click
    @browser.digital_mag_edition_label.should_exist
    @browser.pc_mac_mag_button.click
    sleep 10
    url = @browser.url
    $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/editiondigital.net/)
    test.should equal true
  end

  it "63190 - GI: Digimag flow - user signed in, registered, not linked" do

    # validate user has active digimag sub
    @browser.validate_digimag_subscription($digimag_user, $digimag_pwd)
    @browser.open(@start_page)
    @browser.sign_out_link.click

    @browser.open(@start_page)

    # unlink from sub for this test
    @browser.unlink_digimag_subscription($digimag_user, $digimag_pwd)
    @browser.open(@start_page)
    @browser.sign_out_link.click

    # start test
    @browser.open(@start_page)
    @browser.feed_tabs_panel.should_exist
    @browser.login_user_admin($digimag_user, $digimag_pwd)
    @browser.navlistbar_digimag_link.click
    @browser.digital_mag_edition_label.should_exist
    @browser.pc_mac_mag_button.click

    # need to go to iframe page to link sub for now, d-con limitation
    # script won't work without sleep statements, runs too fast
    @browser.open("http://qa.awesome.gameinformer.com/subscriptionmanagement")
    @browser.linkwizard_findsub_label.should_exist
    sleep 2
    @browser.linkwizard_zip_field.value = $digimag_zip
    sleep 2
    @browser.linkwizard_next_button.click
    sleep 2
    @browser.linkwizard_findsub_label.should_exist
    sleep 2
    @browser.linkwizard_crm_num_field.value = $digimag_crm
    sleep 2
    @browser.linkwizard_find_button.click
    sleep 2
    @browser.linkwizard_confirm_button.should_exist
    @browser.linkwizard_confirm_button.click
    @browser.open(@start_page)
    @browser.feed_tabs_panel.should_exist
    @browser.navlistbar_digimag_link.click
    @browser.digital_mag_edition_label.should_exist
    @browser.pc_mac_mag_button.click
    sleep 10
    url = @browser.url
    $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/editiondigital.net/)
    test.should equal true

    # validate user has active digimag sub
    @browser.open(@start_page)
    @browser.validate_digimag_subscription($digimag_user, $digimag_pwd)
  end

  it "63189 - GI: Digimag flow - user not signed in, not registered, not linked" do

    # can't be automated - captcha prevents user creation through automation

  end

  it "63192 - GI: Digimag flow - user not signed in, registered, not linked" do

    # validate user has active digimag sub
    @browser.validate_digimag_subscription($digimag_user, $digimag_pwd)
    @browser.open(@start_page)
    @browser.sign_out_link.click

    @browser.open(@start_page)

    # unlink from sub for this test
    @browser.unlink_digimag_subscription($digimag_user, $digimag_pwd)
    @browser.open(@start_page)
    @browser.sign_out_link.click

    # start test
    @browser.open(@start_page)
    @browser.feed_tabs_panel.should_exist

    @browser.navlistbar_digimag_link.click
    @browser.digital_mag_edition_label.should_exist
    @browser.pc_mac_mag_button.click
    @browser.gi_digital_mag_label.should_exist
    @browser.digimag_signin_name_field.value = $digimag_user
    @browser.digimag_signin_password_field.value = $digimag_pwd
    @browser.digimag_keep_signin_checkbox.click
    @browser.digimag_login_button.click
    @browser.user_profile_settings_label.should_exist

    # need to go to iframe page to link sub for now, d-con limitation
    # script won't work without sleep statements, runs too fast
    @browser.open("http://qa.awesome.gameinformer.com/subscriptionmanagement")
    @browser.linkwizard_findsub_label.should_exist
    sleep 2
    @browser.linkwizard_zip_field.value = $digimag_zip
    sleep 2
    @browser.linkwizard_next_button.click
    sleep 2
    @browser.linkwizard_findsub_label.should_exist
    sleep 2
    @browser.linkwizard_crm_num_field.value = $digimag_crm
    sleep 2
    @browser.linkwizard_find_button.click
    sleep 2
    @browser.linkwizard_confirm_button.should_exist
    @browser.linkwizard_confirm_button.click
    @browser.open(@start_page)
    @browser.feed_tabs_panel.should_exist
    @browser.navlistbar_digimag_link.click
    @browser.digital_mag_edition_label.should_exist
    @browser.pc_mac_mag_button.click
    sleep 10
    url = @browser.url
    $tracer.trace("Trace of URL: " + url)
    test = true if url.match(/editiondigital.net/)
    test.should equal true

    # validate user has active digimag sub
    @browser.open(@start_page)
    @browser.validate_digimag_subscription($digimag_user, $digimag_pwd)
  end

end
##USAGE##
## d-con %QAAUTOMATION_SCRIPTS%\GameStopMobile\Spec\Pur_Activation\gsmobile_pur_activation.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\Spec\UI\mobile_dataset.csv --range ACTIVATE1 --login enrolltestemail2709@gs.com --password fr@ud123 --browser chrome --or


# 1. generate email address, default password
# 2. trace in report the generated email
# 3. finish the hack to get loyalty enrollment
# 4. finders


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name("ID")
$tc_desc = id_row.find_value_by_name("TestDescription")
$tc_desc = "Test case description was not found" if $tc_desc == ""

describe "PowerUp Rewards Activation" do

  before(:all) do
    $tracer.mode=:on
    $tracer.echo=:on
    $options.default_timeout = 10_000
    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9091"
    (browser_type_parameter == "chrome") ?
        @browser = GameStopMobileBrowser.new(browser_type_parameter, true) :
        @browser = GameStopMobileBrowser.new(browser_type_parameter)
    $snapshots.setup(@browser, :all)
    @proxy = ProxyServerManager.new(9091)
    @proxy.start
  end

  before(:each) do
    #Initialize the dataset parameters
    @params = @browser.get_params_from_csv
    #Initialize global functions for services
    @global_functions = GlobalServiceFunctions.new
    @global_functions.csv = @params["row"]
    @global_functions.parameters
    @db = @global_functions.db_conn
    #@catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
    #@loyaltymembership_svc = @global_functions.loyaltymembership_svc

    #@start_page = @global_functions.prop_url.find_value_by_name("url")
    @start_page = "http://m.qa.gamestop.com/poweruprewards"
    @session_id = generate_guid

    #Setup the browser
    @browser.cookie.all.delete

    #TODO put the user agent into the dataset
    user_agent = "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"

    @proxy.set_request_header("User-Agent", user_agent)
    @browser.open(@start_page)

    @email = auto_generate_emailaddr

    @browser.enroll_pur_user(first_name, last_name, address_line1, address_line2, city, state, zip, country, phone_number, birth_date, store_number, tier)
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @proxy.stop
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    #@browser.validate_analytics(@params)

    #&browser.a.href("/activation/").click--other
    #GO https://m.qa.gamestop.com/poweruprewards link and click on button

    #Once this gets put into the finders, you'd call it by @browser.activate_pur_card_btn.click
    self.activate_pur_card_btn.click
    sleep 3
    #@browser.img.alt("Activate PowerUp Card").click
    #Redirecting to Step1page
    @browser.div.className("/step/").innerText.should == "Step 1: Sign In or Create an Account"
    #validation of forgotpassword
    @browser.a.href("/forgotpassword/").innerText("/forgotpassword/").click
    @browser.back
    #@browser.a.href("/powerupinfo/").innerText.should == "Don't have a card?"
    @browser.a.href("/powerupinfo/").innerText("Don't have a card?").click
    @browser.a.className("/sign-in/").innerText("Return to sign in").click

    @browser.button.className("/ats-createacctbtn/").click
    #Step1 Create Account
    @browser.input.className("ats-createemailaddr").value = "EnrollTestEmail2709@gs.com"
    @browser.input.className("ats-createpwdfield").value = "fr@ud123"
    @browser.button.className("/ats-submitbtn/").click
    #@browser.button.className(create_ats_regex_string("ats-loginbtn")).click
    #Redirecting to Step2
    sleep 10
    @browser.div.className("/step/").innerText.should == "Step 2: Enter card number"
    $tracer.trace("step2 page")
    sleep 3
    @browser.input.className("ats-purnumber").value = "3876179500510"
    sleep 3
    $tracer.trace("step2 page123")
    @browser.input.className("ats-puremailfield").value = "karunyadamarla@gamestop.com"
    $tracer.trace("step2 page1234")
    @browser.input.className("ats-purphonefield").value = "9492319091"
    @browser.button.className("/ats-purcontinuebtn/").click
    sleep 10

  end

  ###################FINDER TEMP METHODS#########################
  def activate_pur_card_btn
    #unit_test_generate: activate_pur_card_btn, img.alt("Activate PowerUp Card")
    $tracer.trace(__method__)
    return ToolTag.new(img.alt("Activate PowerUp Card"), __method__)
  end

  def activate_step_one_txt

  end

  def activate_step_two_txt

  end

  def loyalty_number_field

  end

  def pur_email_field

  end

  def pur_phone_field

  end

  def continue_btn

  end

  def forgot_password_link

  end

  def no_pur_card_link

  end

  def return_to_sign_in_link

  end

  def create_acct_btn

  end

  def create_email_addr_field

  end

  def create_password_field

  end

  def submit_btn

  end

  #HACK - DSL THIS
  def auto_generate_username(t = nil)
    t ||= Time.now
    return "pur" + t.strftime("%Y%m%d_%H%M%S")
  end

  def auto_generate_emailaddr(t = nil)
    t ||= Time.now
    email = "pur" + t.strftime("%Y%m%d_%H%M%S") + "@gspcauto.fav.cc"
    tracer.report(email)
    return email
  end

end
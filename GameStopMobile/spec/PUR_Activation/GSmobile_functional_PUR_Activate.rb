#USAGE: d-con %QAAUTOMATION_SCRIPTS%\GameStopMobile\Spec\Pur_Activation\gsmobile_functional_pur_activate.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\Spec\UI\mobile_dataset.csv --range ACTIVATE1 --login enrolltestemail2709@gs.com --password fr@ud123 --browser chrome --or


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"
## the following are needed for PUR enrollment 
#require "#{qaautomation_dir}/dsl/GameStopMobile/src/Services/game_stop_pur_enrollment"
#require "#{qaautomation_dir}/dsl/GameStopMobile/src/Services/REST/game_stop_rest_services_requires"
class PurEnrollmentService
  include GameStopPurEnrollmentServiceDSL
end

USER_AGENT_STR = "Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Version/6.0 Mobile/10A5376e Safari/8536.25"
describe "GSMobile Functional Tests" do

  before(:all) do
    $tracer.echo = :on

    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9090"

    if browser_type_parameter == "chrome"
      @browser = GameStopMobileBrowser.new(browser_type_parameter, true)
    else
      @browser = GameStopMobileBrowser.new(browser_type_parameter)
    end
    @proxy = ProxyServerManager.new(9090)

    $snapshots.setup_browser(@browser, :all)

    @start_page = "http://m.qa.gamestop.com/poweruprewards"
    @proxy.start
    @proxy.set_request_header("User-Agent", USER_AGENT_STR)
    @browser.open(@start_page)
    #@browser.delete_temporary_internet_files
    @browser.cookie.all.delete

    #create newly enrolled pur member account
    @enroll_svc = PurEnrollmentService.new()
    enrolled_user = @enroll_svc.enroll_pur_user("Jon", "Testqa", "625 Westport Pkwy", nil, "Grapevine", "TX", "76051", "US", "1112223333", "1970-07-10T13:17:00.8835941-05:00", "1356", "3875")

    $tracer.trace(enrolled_user.inspect)
  end

  after(:each) do
    @browser.return_current_url
  end

  it "Card activation Button" do
    #&browser.a.href("/activation/").click--other
    #GO https://m.qa.gamestop.com/poweruprewards link and click on button
    @browser.img.alt("Activate PowerUp Card").click
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


end
##KArunya Comments## Brian's Comment
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"
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
  end

  after(:each) do
    @browser.return_current_url
  end

  it "Card activation Button" do
    $tracer.trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
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
    #Step1 Sign in
    @browser.input.className("ats-emailaddrfield").value = "karunyadamarla@gamestop.com"
    @browser.input.className("ats-pwdfield").value = "Password1"
    @browser.button.className("/ats-loginbtn/").click
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
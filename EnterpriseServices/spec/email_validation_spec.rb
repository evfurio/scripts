#d-con %QAAUTOMATION_SCRIPTS%\EnterpriseServices\spec\email_validation_spec.rb --csv C:\dev\QAAutomationScripts\EnterpriseServices\spec\enterprise_services_dataset.csv --range TC_CP --svc %QAAUTOMATION_SCRIPTS%\Common\config\endpoints.csv --svc_env QA_V1 --login gsautoskynet@gmail.com --password 6abF129056 --or

#prev email, current email.  need to support returning from more than one email.

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

#global_functions passes the csv row object and return the parameters.
#These should be the only global variables used.

#trace to the output file in C:\Users\Public\d_con_output
$tracer.mode = :on
$tracer.echo = :on

#initialize the global functions to use login and password from the command line
$global_functions = GlobalFunctions.new()

describe "Email Client Validation" do

  before(:all) do
    @params = $global_functions.csv
    @login = $global_functions.login
    puts @params.inspect
    @password = $global_functions.password
    @multipass_svc = $global_functions.multipass_svc
  end

  before(:each) do
    #setup a new user
    #We're initializing phantomjs here to utilize functions in common with a headless browser instance
    @client = WebBrowser.new("phantomjs")
    $tracer.report("Start Time: #{Time.now}")
  end

  it "should validate the change password email" do
    #setup the test expectations, this should be driven from a data set per test
    #pass in the email address, password and expected string values to validate
    @user = "gsautoskynet@gmail.com"
    @password = "6abF129056"
    @subject = "This is a subject test"
    @body = "This is a body test"

    #change the password
    # function to send change password email

    ### FOR TESTING STUB PURPOSES ONLY, DO NOT LEAVE IN SCRIPT ###
    ### Sends a default template email to the above gmail account and verifies it ###
    @client.send_test_email(@user)

    # give the internet 5 seconds to send the email to the gmail account
    sleep 5

    #Call to common_functions.rb to get the latest email from the account provided, user and password were passed in the cmd args
    subject, body = @client.get_gmail_list(@user, @password)
    $tracer.report("User: #{@user}")
    $tracer.report("Password: #{@password}")
    $tracer.report("This is the email subject: #{subject.inspect}")
    $tracer.report("This is the email body: #{body.inspect}")

    #Force the subject and assertion to downcase to ensure match of text, unless we're asserting for correctness in capitalization which in case, remove the downcase function
    #threw in a few more validations as examples, you don't need to use all of them.  Just use what's necessary for the test.
    subject.downcase.should include @subject.downcase
    subject.should include @subject
    subject.should == @subject

    #Scan the message body to ensure the phase is delivered at least once
    #Currently we are unable to do a one for one comparison of the text body or html body response, will include in future iterations

    #assertion examples
    body.scan(/This is a body test/).length.should > 1

    #exact body match stripping the return and newline characters
    body.gsub(/\\r\\n +/, ' ').should include @body

    #exact string match stripping the return and newline characters
    body.gsub(/\\r\\n +/, ' ').should include "This is a subject test"

    #change the string value to see failure
    body.gsub(/\\r\\n +/, ' ').should include "This is a body test"
  end

  it "should trigger and validate change password email" do

    change_password_req = @multipass_svc.get_request_from_template_using_global_defaults(:change_password, MultipassServiceRequestTemplates.const_get("CHANGE_PASSWORD"))
    $tracer.trace(change_password_req.formatted_xml)

    change_password_req.find_tag("machine_name").content = "Test_David"
    change_password_req.find_tag("new_password").content = "T3sting1"
    change_password_req.find_tag("old_password").content = "T3sting2"
    change_password_req.find_tag("open_id_claimed_identifier").content = "https://loginqa.testecom.pvt/ID/jvTVgU-R8kCX93yw5lOZqQ"

    $tracer.trace(change_password_req.formatted_xml)
    change_password_rsp = @multipass_svc.change_password(change_password_req.xml)
    status = change_password_rsp.http_body.find_tag("status_reason").content
    code = change_password_rsp.http_body.find_tag("status_code").content

    $tracer.trace(status)
    $tracer.trace(code)
  end

  it "should trigger and validate account locked email" do
    # Wire up multipass to use the authenticate client operation to lock account
  end

end
#d-con %QAAUTOMATION_SCRIPTS%\GameStop\spec\Utilities\email_validation_spec.rb --login gsautoskynet@gmail.com --password 6abF129056

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

#global_functions passes the csv row object and return the parameters.
#These should be the only global variables used.

#trace to the output file in C:\Users\Public\d_con_output
$tracer.mode = :on
$tracer.echo = :on
$options.email_notify="davidturner@gamestop.com"

#initialize the global functions to use login and password from the command line
#$global_functions = GlobalFunctions.new()

describe "Email Client Validation" do

  before(:each) do
    #setup a new user
    #We're initializing phantomjs here to utilize functions in common with a headless browser instance
    @client = WebBrowser.new("phantomjs")
    $tracer.trace("Start Time: #{Time.now}")

  end

  it "should validate the change password email" do

    #setup the test expectations, this should be driven from a data set per test
    @user = "gsautoskynet@gmail.com"
    @password = "6abF129056"
    @subject = "This is a subject test"
    @body = "This is a body test"

    ### FOR TESTING PURPOSES ONLY, DO NOT LEAVE IN SCRIPT ###
    @client.send_test_email(@user)

    #change the password
    # function to send change password email

    # give the internet 5 seconds to send the email to the gmail account
    sleep 5

    #Call to common_functions.rb to get the latest email from the account provided, user and password were passed in the cmd args
    subject, body = @client.get_gmail_list(@user, @password)
    $tracer.trace("User: #{@user}")
    $tracer.trace("Password: #{@password}")

    #Force the subject and assertion to downcase to ensure match of text, unless we're asserting for correctness in capitalization which in case, remove the downcase function
    subject.downcase.should include @subject.downcase

    #Scan the message body to ensure the phase is delivered at least once
    body.scan(/This is a body test/).length.should > 1

  end

end
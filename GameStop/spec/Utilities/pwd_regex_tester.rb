# All Parameters in CMD
#d-con %QAAUTOMATION_SCRIPTS%\GameStop\spec\Utilities\pwd_regex_tester.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "#{ENV['QAAUTOMATION_SCRIPTS']}/Common/dsl/src/password_generator"

$tracer.mode=:on
$tracer.echo=:on

describe "Describe Test" do

  it "should test it" do
    @client = PasswordGenerator.new
    i = 1
    a = 100
    while a > i do
      #@browser.open(@start_page)
      #@browser.retry_until_found(lambda{@browser.log_in_link.exists != true})
      password = @client.generate_password(50)
      $tracer.trace(password)
      status, pwd_len = @client.verify_password(password)
      pwd_len.should be <= 50
      pwd_len.should be >= 8
      status.should == true
      #$tracer.report(password)
      a -= 1
    end
  end

end
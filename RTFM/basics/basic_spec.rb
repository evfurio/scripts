#USAGE NOTES#
#basic spec tutorial

#Command line arguments required to execute this script and output the report to the standard out
#d-Con %QAAUTOMATION_SCRIPTS%\RTFM\basics\basic_spec.rb --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Basics" do

#Setup before any tests start
  before(:all) do
    $tracer.mode=:on
    $tracer.echo=:on
    $tracer.trace("STEP 1: This is before all")
  end

#Setup before the test steps start but occurs in the test method
  before(:each) do
    $tracer.trace("STEP 2: This is before each")
  end

#Tear down after each test but occurs in the test method
  after(:each) do
    $tracer.trace("STEP 4: This is after each")
  end

#Tear down after all tests are complete.
  after(:all) do
    $tracer.trace("STEP 5: This is after all")
  end

#Test method, multiple test methods can be created and will be executed from top down
  it "basic test function" do
    $tracer.trace("STEP 3: You made it to the test function")
    sleep 10
  end

end

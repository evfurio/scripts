#USAGE NOTES#
#basic 2 spec tutorial
# This tutorial covers the basis of creating an rspec formatted functional automation test and invoking the webdriver with $browser.
# Expected results is that the scripts starts, outputs the trace events, starts a chrome browser, opens qa.gamestop.com and searches four keywords using a loop of an array.

#d-Con %QAAUTOMATION_SCRIPTS%\RTFM\basics\basic_browser_setup.rb --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Basics - Setup" do

  before(:all) do
    #TraceLogger (d-con) C:\dev\QAAutomationCurrent\GameStopDoc\TraceLogger.html
    $tracer.mode=:on
    $tracer.echo=:on
    $tracer.report("STEP 1: This is before all")
    #creates a new instance of the GameStopBrowser
    #RDOC C:\dev\QAAutomationCurrent\GameStopDoc\GameStopBrowser.html
    $browser = WebBrowser.new("chrome")
  end

  before(:each) do
    $tracer.report("STEP 2: This is before each")
  end

  after(:each) do
    $tracer.report("STEP 4: This is after each")
  end

  after(:all) do
    $tracer.report("STEP 5: This is after all")
    $browser.close
  end

  it "Invoke the browser and search for a keyword" do
    $tracer.report("STEP 3: You made it to the test function")
    #opens the statically defined url
    $browser.open("http://qa.gamestop.com")
    #searches for a product by static keyword
    $browser.search_field.value = "warfare"
    sleep 5
    #searches for a list of products by static keywords
    search_terms = ["mature", "ps3", "activision", "littlebigplanet"]
    search_terms.each_with_index { |y|
      $browser.search_field.value = y
      sleep 2
    }
    sleep 5
    $tracer.report("end of test")
  end

end

#USAGE NOTES#
#basic search using array spec tutorial
# This tutorial covers the basis of creating an rspec formatted functional automation test and invoking the webdriver with $browser.
# Expected results is that the scripts starts, outputs the trace events, starts a chrome browser, opens qa.gamestop.com and searches four keywords using a loop of an array.
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Sandbox\tutorials\basic_using_array.rb --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Basics - Search" do

  before(:all) do
  	#TraceLogger (d-con) C:\dev\QAAutomationCurrent\GameStopDoc\TraceLogger.html
    $tracer.mode=:on
	  $tracer.echo=:on
    $tracer.trace("STEP 1: This is before all")

    #Create a new instance of the GameStopBrowser class and assign it to $browser
    $browser = GameStopBrowser.new("chrome")
  end

  before(:each) do
    $tracer.trace("STEP 2: This is before each")

    #Open a web site in the browser
    $browser.open("http://qa.gamestop.com")
  end

  after(:each) do
    $tracer.trace("STEP 4: This is after each")
  end

  after(:all) do
    $tracer.trace("STEP 5: This is after all")
    $browser.close
  end

	it "Use an array to iterate through searches" do
		$tracer.trace("STEP 3: You made it to the test function")
   #Define the product array.
		#Ruby syntax: array = []
		#Array
		#http://ruby-doc.org/stdlib-1.9.3/libdoc/csv/rdoc/Array.html
		prod_array = ["warfare", "call of", "batman", "activision"]

		#Enumerable - http://ruby-doc.org/core-1.9.3/Enumerable.html
		#http://ruby-doc.org/core-1.9.3/Enumerable.html#method-i-each_with_index
		prod_array.each do |p|
		  $tracer.trace(p)
      $browser.search_field.value = p
      $browser.search_button.click
		end
    $tracer.trace("end of test")
	end

end
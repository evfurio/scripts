#USAGE NOTES#
#basic search using array spec tutorial
# This tutorial covers the basis of creating an rspec formatted functional automation test and invoking the webdriver with $browser.
# Expected results is that the scripts starts, outputs the trace events, starts a chrome browser, opens qa.gamestop.com and searches four keywords using a loop of an array.
#d-Con %QAAUTOMATION_SCRIPTS%\RTFM\basics\basic_add_product_to_cart.rb --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Basics - Search" do

  before(:all) do
    #TraceLogger (d-con) C:\dev\QAAutomationCurrent\GameStopDoc\TraceLogger.html
    $tracer.mode=:on
    $tracer.echo=:on
    $tracer.report("STEP 1: Set options; create browser object")

    #Create a new instance of the GameStopBrowser class and assign it to $browser
    #Browser types available: chrome, ie, firefox, safari
    $browser = WebBrowser.new("chrome")
  end

  before(:each) do
    $tracer.report("STEP 2: Start the browser in the before each, this allows a new instance per test method")

    #Set the start page, for this example we are hard coding the value but this should be a parameter
    start_page = "http://qa.gamestop.com"
    #Open a web site in the browser
    $browser.open(start_page)
  end

  after(:each) do
    $tracer.report("STEP 4: This is after each")
  end

  after(:all) do
    $tracer.report("STEP 5: This is after all; we're ensuring the browser closed despite the outcome of the test")
    $browser.close
  end

  it "Use an array to iterate through searches" do
    $tracer.trace("STEP 3: We're going to iterate through several searches and add the first product from each to the cart")
    #Define the product array.
    #Ruby syntax: array = []
    #Array
    #http://ruby-doc.org/stdlib-1.9.3/libdoc/csv/rdoc/Array.html
    prod_array = ["warfare", "call of", "batman", "activision"]

    #Enumerable - http://ruby-doc.org/core-1.9.3/Enumerable.html
    #http://ruby-doc.org/core-1.9.3/Enumerable.html#method-i-each_with_index
    prod_array.each_with_index do |p|
      $tracer.trace(p)
      $browser.search_field.value = p
      $browser.search_button.click
      $tracer.trace($browser.product_list.length)
      #products = $browser.product_list.length
      $browser.product_list.at(0).add_to_cart_button.click
    end

    $tracer.trace("end of test")
  end

end

ENV['QAAUTOMATION_FILES'] = "#{ENV["QAAUTOMATION_TOOLS"]}/QAAutomation"
rel_dir = ENV['QAAUTOMATION_FILES']
script_dir = "#{ENV['QAAUTOMATION_SCRIPTS']}"
require "#{script_dir}/GameStop/dsl/src/dsl"

default_timeout = 2000
WebSpec.silent_mode true
WebSpec.default_timeout default_timeout

class DSLWebSpecTestClass
  def self.new
    org.watij.webspec.dsl.WebSpec.module_eval do
      include GameStopCartFinder
      include GameStopDSL
    end

    WebSpec.new

  end

end

describe "Game Stop DSL" do
  file_prefix = "file:///" + rel_dir

  before(:all) do
    @start_page = file_prefix + "/dsl/GameStop/spec/game_stop_html_finder.html"

    @browser = DSLWebSpecTestClass.new
    #@browser.mozilla.open(@start_page)

    if os_name == "mswin32"
      @browser.ie.open(@start_page)
    elsif os_name == "darwin"
      @browser.safari.open(@start_page)
    else
      puts "ERROR: unsupported OS: #{os_name}"
    end

    $tracer.mode = :on
  end

  before(:each) do
    # We only need to go back to the start page if we went away from it.
    # It's faster to do this check than to go back to start every time.
    for i in 0..(@browser.browser_count - 1)
      @browser.browser(i)
      @browser.open(@start_page) if !(@browser.timeout(100).log_in_link.exists)
    end
  end

  after(:all) do
    $tracer.trace("after all")
    @browser.close_all
  end

  it "should be able to calculate the shopping cart total" do
    for i in 0..(@browser.browser_count - 1)
      @browser.browser(i)
      total = @browser.calculate_cart_total
      total.should == BigDecimal.new("26.98")
    end
  end
end

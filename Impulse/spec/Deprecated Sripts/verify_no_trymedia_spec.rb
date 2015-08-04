require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

describe "Verify No Trymedia" do


  before(:all) do
    @start_page = "http://www.gamestop.com"
    if os_name == "darwin"
      @browser = GameStopBrowser.new.safari
    else
      @browser = GameStopBrowser.new.ie
    end

    $snapshots.setup(@browser, :all)
    $tracer.mode = :on
    $tracer.echo = :on
  end

  before(:each) do
    @browser.browser(0).open(@start_page)
  end

  after(:all) do
    $tracer.trace("after :all")
    @browser.close_all
  end

  it "should have no trymedia references" do
    $options.default_timeout = 10000
    # Search for all products
    @browser.search_button.click

    # Filter on "available for download"
    @browser.a("/Available for Download/").click

    # Filter on "PC"
    @browser.a("/PC/").at(3).click

    # Show 50 items on the page
    @browser.a.id("/btn50Recs/").click

    # Get number of pages
    num_pages_str = @browser.div.className("pagination_controls").strong.at(1).innerText.strip
    num_pages = num_pages_str.to_i
    for i in 1..num_pages do
    @browser.source.downcase.should_not include("trymedia")
      if i < num_pages
        @browser.a.className("next_page").click
      end
    end
  end
  
end

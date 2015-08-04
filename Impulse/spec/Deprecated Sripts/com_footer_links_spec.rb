require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

# The purpose of this script is to click the footer links on impulsedriven.com and verify the resulting URL

describe "ImpulseDriven.com Footer Links Suite" do

   before(:all) do
    # csv = QACSV.new(csv_filename_parameter)
    # @row = csv.find_row_by_name(csv_range_parameter)
	
    @start_page = "http://www.impulsedriven.com"
    if os_name == "darwin"
      @browser = ImpulseBrowser.new.safari
    else
      @browser = ImpulseBrowser.new.ie
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
    
   it "should verify the footer - Twitter link destination" do
   
	@browser.twitter_link.click
	@browser.url.should == 'http://twitter.com/gamestopdl'
	end  
	
   it "should verify the footer - Facebook link destination" do
	@browser.facebook_link.click
	@browser.url.should == 'https://www.facebook.com/gamestopdownloads'
	end  
	
   it "should verify the footer - RSS link destination" do
	@browser.announcements_rss_link.click
	@browser.url.should == 'http://www.impulsedriven.com/rss/news'
	end  	
   
   it "should verify the footer - License link destination" do
	@browser.license_link.click
	@browser.url.should == 'http://www.impulsedriven.com/license'
	@browser.gamestop_logo_pc_downloads_link.should_exist
	end  
	
   it "should verify the footer - Sales FAQ link destination" do
	@browser.sales_faq_link.click
	@browser.url.should == 'http://www.impulsedriven.com/support/sales-faq'
	@browser.gamestop_logo_pc_downloads_link.should_exist
	end  
   
   it "should verify the footer - Privacy Policy link destination" do
	@browser.privacy_policy_link.click
	@browser.url.should == 'http://www.impulsedriven.com/support/privacy'
	@browser.gamestop_logo_pc_downloads_link.should_exist
	end  
	
   it "should verify the footer - Return Policy link destination" do
	@browser.return_policy_link.click
	@browser.url.should == 'http://www.impulsedriven.com/support/returns'
	@browser.gamestop_logo_pc_downloads_link.should_exist	
	end     
	
   it "should verify the footer - Terms of Service link destination" do
	@browser.terms_of_service_link.click
	@browser.url.should == 'http://www.impulsedriven.com/terms'
	@browser.gamestop_logo_pc_downloads_link.should_exist	
	end     	
end	
	
	
	
	
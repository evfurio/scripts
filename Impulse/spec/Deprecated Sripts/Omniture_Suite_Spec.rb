require "#{ENV['QAAUTOMATION_SCRIPTS']}/Impulse/dsl/src/dsl"

describe "Omniture Homepage Link Suite Spec" do

   before(:all) do
    @start_page = "http://www.impulsedriven.com"
	@count = 100
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
  
   it "should click the featured item 1 links on the homepage" do
    WebSpec.default_timeout 10000
	
	@count.times do
    @browser.feature1_image_link.click
	@browser.gamestop_logo_pc_downloads_link.click
	end
    
	@count.times do
	@browser.feature1_price_link.click
	@browser.gamestop_logo_pc_downloads_link.click
	end
	
	# if @browser.feature1_buy_link.exist?
		# @count.times do
		# @browser.feature1_buy_link.click
		# @browser.gamestop_logo_pc_downloads_link.click	
		# end
	# else
		@count.times do
		@browser.feature1_pre_purchase_link.click
		@browser.gamestop_logo_pc_downloads_link.click	
		end
	# end	
	
  end

   # it "should click the featured item 2 links on the homepage" do
    # WebSpec.default_timeout 10000
	
	# @count.times do
    # @browser.feature2_image_link.click
	# @browser.gamestop_logo_pc_downloads_link.click
	# end
    
	# @count.times do
	# @browser.feature2_price_link.click
	# @browser.gamestop_logo_pc_downloads_link.click
	# end
	
	# # if @browser.feature2_buy_link.exist?
		# @count.times do
		# @browser.feature2_buy_link.click
		# @browser.gamestop_logo_pc_downloads_link.click	
		# end
	# # else
		# # @count.times do
		# # @browser.feature2_pre_purchase_link.click
		# # @browser.gamestop_logo_pc_downloads_link.click	
		# # end
	# # end	
	
  # end  

   # it "should click the featured item 3 links on the homepage" do
    # WebSpec.default_timeout 10000
	
	# @count.times do
    # @browser.feature3_image_link.click
	# @browser.gamestop_logo_pc_downloads_link.click
	# end
    
	# @count.times do
	# @browser.feature3_price_link.click
	# @browser.gamestop_logo_pc_downloads_link.click
	# end
	
	# # if @browser.feature3_buy_link.exist?
		# @count.times do
		# @browser.feature3_buy_link.click
		# @browser.gamestop_logo_pc_downloads_link.click	
		# end
	# # else
		# # @count.times do
		# # @browser.feature3_pre_purchase_link.click
		# # @browser.gamestop_logo_pc_downloads_link.click	
		# # end
	# # end	
	
  # end  

   # it "should click the featured item 4 links on the homepage" do
    # WebSpec.default_timeout 10000
	
	# @count.times do
    # @browser.feature4_image_link.click
	# @browser.gamestop_logo_pc_downloads_link.click
	# end
    
	# @count.times do
	# @browser.feature4_price_link.click
	# @browser.gamestop_logo_pc_downloads_link.click
	# end
	
	# # if @browser.feature4_buy_link.exist?
		# @count.times do
		# @browser.feature4_buy_link.click
		# @browser.gamestop_logo_pc_downloads_link.click	
		# end
	# # else
		# # @count.times do
		# # @browser.feature4_pre_purchase_link.click
		# # @browser.gamestop_logo_pc_downloads_link.click	
		# # end
	# # end	
	
  # end  

   # it "should click the featured item 5 links on the homepage" do
    # WebSpec.default_timeout 10000
	
	# @count.times do
    # @browser.feature5_image_link.click
	# @browser.gamestop_logo_pc_downloads_link.click
	# end
    
	# @count.times do
	# @browser.feature5_price_link.click
	# @browser.gamestop_logo_pc_downloads_link.click
	# end
	
	# # if @browser.feature5_buy_link.exist?
		# @count.times do
		# @browser.feature5_buy_link.click
		# @browser.gamestop_logo_pc_downloads_link.click	
		# end
	# # else
		# # @count.times do
		# # @browser.feature5_pre_purchase_link.click
		# # @browser.gamestop_logo_pc_downloads_link.click	
		# # end
	 # # end	
	
  # end  


   # it "should click the featured item 6 links on the homepage" do
    # WebSpec.default_timeout 10000
	
	# @count.times do
    # @browser.feature6_image_link.click
	# @browser.gamestop_logo_pc_downloads_link.click
	# end
    
	# @count.times do
	# @browser.feature6_price_link.click
	# @browser.gamestop_logo_pc_downloads_link.click
	# end
	
	# # if @browser.feature6_buy_link.exist?
		# # @count.times do
		# # @browser.feature6_buy_link.click
		# # @browser.gamestop_logo_pc_downloads_link.click	
		# # end
	# # else
		# @count.times do
		# @browser.feature6_pre_purchase_link.click
		# @browser.gamestop_logo_pc_downloads_link.click	
		# end
	# # end	
	
  # end  
  
end	
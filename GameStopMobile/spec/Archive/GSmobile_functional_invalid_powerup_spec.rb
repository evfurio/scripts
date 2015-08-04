#d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\GSmobile_functional_invalid_powerup_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\Spec\MobileUI.csv --range "TFS47517" --browser chrome --or 
#
#
###########################################################################################################################################################
###                                      Should NOT take Invalid PowerUp Number under Cart                                                              ###          
###########################################################################################################################################################



require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStopMobile/dsl/src/dsl"

describe "GSMobile Functional Tests" do
  before(:all) do
    $tracer.echo = :on

    # get the --csv parameter and read the file, --range identifies the row of data to use per test case
	# range will now define the TFS ID to use in relation to the MTM test case created.
	csv = QACSV.new(csv_filename_parameter)
	@row = csv.find_row_by_name(csv_range_parameter)
	
	# set instance variables for csv driven data elements
	initialize_csv_params

    @start_page = @main_url
	@product_page = @product_url
	
    # TODO: MOBILE WEB: Kludge - need to remove the if condition.
    if browser_type_parameter == "chrome"
      @browser = GameStopMobileBrowser.new(browser_type_parameter, true)
    else
      @browser = GameStopMobileBrowser.new(browser_type_parameter)
    end

    $snapshots.setup_browser(@browser, :all)

    @browser.open(@start_page)
	@browser.cookie.all.delete
  end

  before(:each) do
	 if (@browser.timeout(5000).log_out_link.exists)
      @browser.log_out_link.click
    end    	   
  end

  after(:all) do
    $tracer.trace("after all")
    @browser.close_all()
  end
  
  it "Should NOT take Invalid PowerUp Number under Cart" do
    @browser.open(@start_page)
    
	@products.each_with_index do |product, i|
		#@browser.search_field.value = "\\" + product
		#@browser.search_field.click
		@browser.open(@product_page + product)		
		@browser.product_price_list.at(0).add_to_cart_button.click
		
		if i < (@products.count - 1)
			@browser.open(@start_page)
		end
    end
	   
	@browser.powerup_reward_field.value = @pur_num
	@browser.promotion_code_apply_button.click
	@browser.confirm_pur_number_warning
  end

	def initialize_csv_params
	   #PowerUp Number
		@pur_num = @row.find_value_by_name("PUR")
    	
		#get product using sku
		@products = @row.find_value_by_name("SKUS").split(",")
		@get_single_product = @products.first
		
		#Enviroment
	   @main_url = @row.find_value_by_name("MainURL")
	   @product_url = @row.find_value_by_name("ProductURL")
	end
end


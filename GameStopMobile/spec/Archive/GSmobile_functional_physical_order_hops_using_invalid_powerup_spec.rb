#d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\GSmobile_functional_physical_order_hops_using_invalid_powerup_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\Spec\MobileUI.csv --range "TFS47506" --browser chrome --or 
#
#
###########################################################################################################################################################
###                                    Physical Product HOPS Purchase using Invalid PowerUp                                                             ###          
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
  
  it "Physical Product HOPS Purchase using Invalid PowerUp" do
    @browser.open(@start_page)
    
	@products.each_with_index do |product, i|
		#@browser.search_field.value = "\\" + product
		#@browser.search_field.click
		@browser.open(@product_page + product)		
		@browser.store_pickup_hops.click
		
		if i < (@products.count - 1)
			@browser.open(@start_page)
		end
    end
	   
	@browser.new_store_pickup_hops_button.click
    @browser.store_pickup_hops_checkout.click

    #Personal Info
    @browser.enter_personal_info_plus_email(
      @first_name,
      @last_name,
      @ShippingEmail,
	  @ShippingPhone
    )

	#PowerUp Number
	@browser.powerup_number_hops_field.value = @pur_num
	@browser.finish_hops_button.click
	@browser.confirm_pur_number_warning_hops
	
		
  end

	def initialize_csv_params
	   #Shipping address
		@first_name = @row.find_value_by_name("FirstName")
		@last_name = @row.find_value_by_name("LastName")
		@ShippingLine1 = @row.find_value_by_name("ShippingLine1")
		@ShippingCity = @row.find_value_by_name("ShippingCity")
		@ShippingState = @row.find_value_by_name("ShippingState")
		@ShippingZip = @row.find_value_by_name("ShippingZip")
		@ShippingPhone = @row.find_value_by_name("ShippingPhone")
		@ShippingEmail = @row.find_value_by_name("ShippingEmail")
		#$tracer.trace(@first_name.to_s)
		
		#PUR info
		@pur_num = @row.find_value_by_name("PUR")		
		
		#get product using sku
		@products = @row.find_value_by_name("SKUS").split(",")
		@get_single_product = @products.first
		
		#Enviroment
	@main_url = @row.find_value_by_name("MainURL")
	@product_url = @row.find_value_by_name("ProductURL")
	end
end


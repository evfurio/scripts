#d-Con %QAAUTOMATION_SCRIPTS%\GameStopMobile\spec\GSmobile_functional_edit_cart_remove_partial_auth_user_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStopMobile\Spec\MobileUI.csv --range "TFS47462" --browser chrome --or 
#
#
#######################################################################################################################################################################
###                                              Remove one item from the cart holding multiple products   - Auth User                                              ###          
#######################################################################################################################################################################



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
    	   
  end

  after(:all) do
    $tracer.trace("after all")
    @browser.close_all()
  end
  
  it "Remove one item from the cart holding multiple products-Auth User" do
	 @browser.open(@start_page)
	 
	@browser.view_cart_button.click
	
    if (@browser.timeout(5000).log_out_link.exists)
      @browser.log_out_link.click
    end	
	
	@browser.log_in_link.click
	@browser.log_into_my_account_button.click
	
    # Login Credentials.
    @browser.enter_login_credentials(
      @Username,
      @Password
	)
	
	@browser.user_login_button.click
	@browser.empty_new_cart
    
	@products.each_with_index do |product, i|
		#@browser.search_field.value = "\\" + product
		#@browser.search_field.click
		@browser.open(@product_page + product)		
		@browser.product_price_list.at(0).add_to_cart_button.click
		
		if i < (@products.count - 1)
			@browser.open(@start_page)
		end
    end
	   
	@browser.edit_cart_link.click
	@browser.remove_item_link.at(1).click
	@browser.line_item_label.length.should == 2
	
  end

	def initialize_csv_params	
		#get product using sku
		@products = @row.find_value_by_name("SKUS").split(",")
		@get_single_product = @products.first
		
		#login Credentials.
	    @Username = @row.find_value_by_name("Username")
	    @Password = @row.find_value_by_name("Password")
		
	    #Enviroment
	    @main_url = @row.find_value_by_name("MainURL")
	    @product_url = @row.find_value_by_name("ProductURL")

	end
end


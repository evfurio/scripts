# encoding: utf-8

# d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_catalog_search_spec.rb --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS49682 --browser ie  --or 

require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name('ID')
$tc_desc = id_row.find_value_by_name('TestDescription')
$tc_desc = 'Test case description was not found' if $tc_desc == ''
	
describe 'Test for Catalog Search Scenarios' do
  before(:all) do
    @browser = WebInStoreBrowser.new(browser_type_parameter)
		$options.default_timeout = 10_000
		$snapshots.setup(@browser, :all)
		$tracer.mode=:on
		$tracer.echo=:on 
  end

	before(:each) do
		@browser.cookie.all.delete
		@params = @browser.get_params_from_csv
		@global_functions = GlobalServiceFunctions.new
		@global_functions.csv = @params['row']
		@global_functions.parameters
		@sql = @global_functions.sql_file
		@db = @global_functions.db_conn 
		@start_page = @global_functions.prop_url.find_value_by_name('url')
		@session_id = generate_guid  
		@store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc
		@catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
		
		@product_sku, @out_of_stock, @low_stock = @browser.load_test_skus_from_db(@db, @sql.to_s)
		@store_addresses = @store_search_svc.perform_get_all_stores_in_range(@session_id, 'GS_US', 'en-US', @store_search_svc_version, '75061', '10')
		@store = @store_addresses[0].store_number.content 
		$tracer.trace("Product Sku  :  #{@product_sku}")
		$tracer.trace("Store Number :  #{@store}")
  end

  after(:each) do
    @browser.return_current_url
  end
		
	after(:all) do
    @browser.close_all
	end

	it "#{$tc_id} #{$tc_desc}" do
		product_url="#{@start_page}/Checkout/instore/product?store=#{@store}&reg=3&sku=#{@product_sku}&ctguest=true"
		url = "#{@start_page}/Checkout/instore/product?store=#{@store}&reg=3"
		
		@browser.open(url)

    unless @params['pur_number'] == ''
      # TFS49602
      @browser.search_button.should_exist
      @browser.search_button.click
      @browser.wait_for_landing_page_load
      @expected = 7
      @browser.search_product_name.should_exist
      @expected.should == @browser.search_product_name.length
      @browser.pagination_field.should_exist

      # TFS49682
      @browser.order_lookup_button.should_exist
      @browser.order_lookup_button.click
			puts "---------------------------------------------   #{@params['pur_number']}"
      @browser.search_pur_field.should_exist
      @browser.search_pur_field.value = @params['pur_number']
      @browser.search_go_button.click
      @expected = 9
      @browser.order_number_list.should_exist
      @expected.should == @browser.order_number_list.length
      @browser.pagination_field.should_exist
    end

		# TFS49610
		if @out_of_stock
			@browser.open(product_url)
			@browser.out_of_stock_label.should_exist
			@browser.out_of_stock_label.innerText.should == 'OUT OF STOCK'
			@browser.wait_for_landing_page_load
		end
		
		# TFS49619
		if @low_stock
			@browser.open(product_url)
			@browser.low_stock_label.should_exist
			@browser.low_stock_label.innerText.should == 'LOW STOCK'
			@browser.wait_for_landing_page_load
		end
	
		@dafault_value = 'Search All'
    descending_image = '▼'
    # dsc_img = 'u25BC'.force_encoding(@encoding)
	# descending_image = dsc_img.encode(@encoding, "binary", :undef => :replace)
    ascending_image = '▲'
    # asc_img = 'u25B2'.force_encoding(@encoding)
    # ascending_image = asc_img.encode(@encoding, "binary", :undef => :replace)

    if @params['category_drop_down_test']
			# TFS49596
			@browser.category_drop_down.should_exist
			@browser.category_drop_down.value.should == @dafault_value
			@browser.category_drop_down.value = @params['category_drop_down_value']
			@browser.search_button.should_exist
			@browser.search_button.click
			
			@browser.category_drop_down.value.should == @params['category_drop_down_value']
			@browser.search_result_label.should_exist
			$tracer.trace("#{@browser.search_result_label.innerText}")
			@browser.search_result_label.innerText.should include "#{@params['category_drop_down_value']}"
			
			# TFS49597
			item = @browser.product_search_list.at(1)
			item.product_details_button.should_exist
			item.product_details_button.click
			@browser.wait_for_landing_page_load
			# Check if redirected successfully to Product Details page
				 
			# TF49598
			@browser.home_page.should_exist
			@browser.home_page.click
			@browser.wait_for_landing_page_load
			
			@browser.category_drop_down.should_exist
			@browser.category_drop_down.value = @params['category_drop_down_value']
			@browser.search_field.value = @product_sku
			@browser.search_button.should_exist
			@browser.search_button.click
			@browser.wait_for_landing_page_load

      		@expected_str_result = 'Your search did not match any products'
			$tracer.trace("#{@browser.message.innerText}")
			@browser.message.innerText.should include "#{@expected_str_result}"
			@browser.category_drop_down.value.should == @dafault_value
		end

    unless @params['category_drop_down_test']
      # TFS49627 | # TFS49630
       @browser.category_drop_down.value.should == @dafault_value
      @browser.validate_search_result(@params)

      # Best Selling is on descending order
	   # @browser.sort_best_selling.innerText.should include expected_result
	   @browser.validate_label(@browser.sort_best_selling.innerText,descending_image)
	 
      # Verify search results by Best Selling. It should match records from endeca.

      # TFS49631
      @browser.wait_for_landing_page_load
      @browser.sort_price.should_exist
      @browser.sort_price.click
      # Lowest Price is on ascending order
      # @browser.sort_price.innerText.should include ascending_image
			puts"*************************************    #{@browser.sort_price.innerText}"
	  @browser.validate_label(@browser.sort_price.innerText,ascending_image)
	
      # Verify search results by Lowest Price. It should match records from endeca.

      # TFS49631
      @browser.wait_for_landing_page_load
      @browser.sort_release_date.should_exist
      @browser.sort_release_date.click
      # Release Date is on ascending order
	  @browser.validate_label(@browser.sort_release_date.innerText,ascending_image)
      # @browser.sort_release_date.innerText.should include ascending_image
	  
      # Verify search results by release date. It should match records from endeca.

      total_records = @browser.product_search_sku.length
      $tracer.trace("Total Records : #{total_records}")
    end
		
	end
end

#Search Tests

# Usage Notes
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Search\search_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_products_with_titles.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog"  --browser chrome --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS -e "should search for bulk results and validate" --or
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Search\search_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_products_with_titles.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog"  --browser chrome --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS -e "should search by targeted keywords" --or
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Search\search_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --browser chrome --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA3_GS -e "should validate nfs puas button from bulk search"  --or
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Search Scenarios" do
  $tracer.mode=:on
  $tracer.echo=:on
  #global_functions passes the csv row object and return the parameters.
  $global_functions = GlobalFunctions.new()

  before(:all) do
    $options.default_timeout = 90_000
    @browser = WebBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
  end

  before(:each) do
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
    #get results from the sql file
    sql = @sql.to_s
    @results_from_file = @db.exec_sql_from_file(sql)
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end


  it "should search for bulk results and validate" do
    #What does this test do?
    #Will do a bulk search from gamestop.com
    #Opens http://{subdomain}.gamestop.com and presses the search iconography without any defined search criteria in the search field
    #Validates that results were returned, the length of results and the name of the first item in the list

    #Returns the first item's display name from a bulk search using the catalog service
    svc_prod_rsp = @catalog_svc.perform_bulk_search(@catalog_svc_version)

    #Opens the browser to the start page as defined in the properties.csv
    @browser.open(@start_page)

    #Passing nil to the search_for_product method will invoke a bulk search where the user searches the entire catalog by best sellers.
    empty = ""
    @browser.search_for_product(empty)

    #Allows to select the next page.  For future use.
    #@browser.next_page_productlist.click

    #Get's the search list results and determines how many are returned.  Current business rules are to return 25 results per page unless otherwise selected by the user.
    product_list = @browser.product_list
    prod_list_length = product_list.length
    $tracer.trace("How many products were returned #{prod_list_length}")

    #Validates that only 12 or less products were returned.  In a bulk search it should always be 25, consider that Ruby counts from 0, so the length is returned as 24 but it's really 25.
    $tracer.trace("Validate the search list length is less than 25")
    (prod_list_length < 25) ? length_chk = true : length_chk = false
    length_chk.should == true

    #Get the product name from the first product in the list
    product_name = @browser.product_list.at(1).name_link.innerText
    $tracer.trace("First product's name: #{product_name}")

    #Comparing the first 5 characters in the string.  This is because I haven't figured out a good way to handle special characters like the trademark or reserved characters.  Anticipate the occasional false positives from this assertion.
    svc_prod_rsp.split(//).first(5).to_s.should == product_name.split(//).first(5).to_s

    #Ensure that the product title can be clicked and drills into the PDP
    product = @browser.product_list.at(1).name_link.click
    @browser.wait_for_landing_page_load
    @browser.ensure_header_loaded
  end

  it "should search by targeted keywords" do
    KEYWORDS_LIST = "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/Spec/UI/Search/keywords.csv"
    keywords = QACSV.new(KEYWORDS_LIST)
    $tracer.trace("Total number of keywords from csv ::: #{keywords.max_row}")

    arr_keys = []
    keywords.each_with_index do |r|
      arr_keys << r.find_value_at(1)
    end

    i = 0
    product = arr_keys.sample
    #while i < arr_keys.length
      @browser.open(@start_page)

      ## USE KEYWORD FOR A SEARCH
      #@browser.search_for_product(arr_keys[i])
      @browser.search_for_product(product)
#gets stuck after the retry logic is passed.
      if @browser.retry_until_found(lambda { @browser.search_result_section.exists != true })
        @browser.search_no_result_header.exists == true
        @browser.search_no_result_header.content == "Searched Item Not Found, Try Something Else."
        $tracer.trace("Recommended products page, no items returned for search critiera")
      end

      if @browser.search_result_section.exists == true
        product_list = @browser.product_list
        prod_list_length = product_list.length
        $tracer.trace("How many products were returned #{prod_list_length}")

        #Validates that only 25 or less products were returned.  In a bulk search it should always be 25, consider that Ruby counts from 0, so the length is returned as 24 but it's really 25.
        $tracer.trace("Validate the search list length is less than 25")
        (prod_list_length < 25) ? length_chk = true : length_chk = false
        length_chk.should == true
        puts "Should redirect to Product list page"


      end

    # TODO: Need to allow for single product returns that will drop directly on the PDP
      # if @browser.product_title_label.exists == true
      # puts "Should redirect to Product details page"
      # else
      # puts "Should redirect to Recommended products page"
      # end

     # i += 1
    #end
  end

  it "should search for product available for 24 hr shipping" do
    @browser.open(@start_page)
    ## FILTER OR USE PAGINATION TO VARY RESULTS
    product = ""
    @browser.search_for_product_with_24_hour_availability(product)
    product_name = @browser.product_list.at(1).name_link.innerText
    product = @browser.product_list.at(1).name_link.click
    @browser.wait_for_landing_page_load
    @browser.ensure_header_loaded
  end

  it "should search for accessories" do
    @browser.open(@start_page)
    ## FILTER OR USE PAGINATION TO VARY RESULTS
    product = ""
    @browser.search_for_product(product)
    @browser.accessories_link.click
    @browser.wait_for_landing_page_load
    @browser.breadcrumbs_label("/Accessories/").should_exist
    product = @browser.product_list.at(1).name_link.click
    @browser.wait_for_landing_page_load
    @browser.ensure_header_loaded
  end

  it "should search for preowned product" do
    @browser.open(@start_page)
    product = ""
    @browser.search_for_product(product)
    @browser.preowned_link.at(1).click
    @browser.wait_for_landing_page_load
    product = @browser.product_list.at(1).name_link.click
    @browser.wait_for_landing_page_load
    @browser.ensure_header_loaded
  end

  it "should search for pick up at store product" do
    @browser.open(@start_page)
    product = ""
    @browser.search_for_product_with_pickup_at_store(product)
    product_name = @browser.product_list.at(1).name_link.innerText
    @browser.product_list.at(1).name_link.click
    @browser.ensure_header_loaded
    #compare the product details page product title with the product name given in the search list
  end

  it "should search for downloadable product" do
    @browser.open(@start_page)
    product = ""
    @browser.search_for_product(product)
    @browser.available_for_download_link.click
    @browser.wait_for_landing_page_load
    @browser.breadcrumbs_label("/Available for Download/").should_exist
    product = @browser.product_list.at(1).name_link.click
    @browser.wait_for_landing_page_load
    @browser.ensure_header_loaded
  end
	
	it "should validate nfs puas button from bulk search" do
		@browser.open(@start_page)
		empty = ""
    @browser.search_for_product(empty)
		
		# Pointed to the second button as the first one doesn't return stores for that product. Product is Destiny for PS4
    @browser.nfs_pickup_at_store_button[1].click
		@browser.wait_for_landing_page_load
		
		popup_visible = (@browser.hops_no_stores_popup.call("style.display").eql?("none") ? true : false )
		unless popup_visible == true
			@browser.hops_no_stores_button.click
      @browser.wait_for_landing_page_load
    end
		@browser.hops_zip_code_search_field.value = ''
		@browser.hops_zip_code_search_field.value = @params['ship_zip']
		@browser.wait_for_landing_page_load
    @browser.hops_zip_code_search_button.click
		sleep 5
		
		@browser.hops_store_list.at(0).pickup_at_store_button.click
		@browser.wait_for_landing_page_load
		@browser.first_name_field.value = @params['bill_first_name']
    @browser.last_name_field.value = @params['bill_last_name']
    @browser.email_address_field.value = @params['bill_email']
    @browser.confirm_email_address_field.value = @params['bill_email']
    @browser.phone_number_field.value = @params['bill_phone']
    
		@browser.hops_finish_button.click
    @browser.wait_for_landing_page_load

		if @browser.hops_alternate_store_popup_panel.exists
			@browser.hops_alternate_store_popup_panel.set_alternate_store_button.click
			@browser.wait_for_landing_page_load
		end

    @browser.hops_accepted_page_title.should_exist
    @browser.hops_accepted_page_message.inner_text.should start_with "Sweet! We've sent an email to"
		sleep 5
	end
	
end

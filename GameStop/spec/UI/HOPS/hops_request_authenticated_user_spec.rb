##USAGE NOTES
#d-Con --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_dataset.csv --range HOPS01 --svc %QAAUTOMATION_SCRIPTS%\Common\config\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_request_authenticated_user_spec.rb --browser chrome -e 'Should be able to submit a HOPS request for the sake of sanity' --or
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_request_authenticated_user_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_dataset.csv --range HOPS01 --login tstr3@gs.com --password T3sting --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv --url QA_GS --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_hops_product.sql --svc %QAAUTOMATION_SCRIPTS%\Common\config\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --browser chrome -e 'RequestHops as AuthenticatedUser when ShowHopsPURandCC is TRUE' --or
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_request_authenticated_user_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_dataset.csv --range HOPS01 --login tstr3@gs.com --password T3sting  --browser chrome -e 'Should be able to submit a HOPS reqeust for the sake of sanity' --or
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_request_authenticated_user_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_dataset.csv --range TFS48821 --login tstr3@gs.com --password T3sting --browser chrome -e 'RequestHops as AuthenticatedUser when ShowHopsPURandCC is TRUE' --or
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_request_authenticated_user_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_dataset.csv --range TFS48821 --login tstr3@gs.com --password T3sting --browser chrome -e 'RequestHops as AuthenticatedUser when ShowHopsPURandCC is FALSE' --or

# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_request_authenticated_user_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\HOPS\hops_dataset.csv --range HOPS01 --login hops_tester1@qagsecomprod.oib.com --password T3sting1 --browser chrome -e 'Should be able to submit a HOPS request for the sake of sanity' --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()
#$tc_desc = $global_functions.desc
#$tc_id = $global_functions.id

describe "PickUp@Store Authenticated" do

  before(:all) do
    @browser = WebBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 30_000
    $snapshots.setup(@browser, :all)

    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
  end

  before(:each) do
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid

    $tracer.trace(" *** Get Product Data *** ")
    @product_cond = get_sku_and_store_data
    @product_url = @catalog_svc.perform_get_product_url(@catalog_svc_version, @session_id, @sku)

    #For getting the home store
    @open_id = @account_svc.perform_authorization_and_return_open_id(@session_id, @login, @password, @account_svc_version)
    @store_info = @profile_svc.get_store_address_by_user_id(@open_id, @session_id, "GS_US", @profile_svc_version)
    #"store_number, phone_number, mall_name, address_line1, address_line2, city, state, zip, country"
    @home_store = @store_info[0]
    @browser.open(@start_page)
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "Should be able to submit a HOPS request for the sake of sanity" do
    #Reduced functionality to ensure that a HOPS request can be made for sanity and smoke tests SLA < 60 seconds

    # Log in with existing user
    @browser.log_in_link.click
    @browser.log_in(@login, @password)
    @browser.log_out_link.exists
    # Go directly to the HOPS Request page for an available SKU and Store
    @browser.open("#{@start_page}/Orders/HoldRequest.aspx?store=#{@store}&sku=#{@sku}")
    # Validate logged in
    @browser.log_out_link.exists
    # Enter in values for first and last name
    @browser.first_name_field.value = @params['bill_first_name']
    @browser.last_name_field.value = @params['bill_last_name']
    # Validate email address is populated based upon logged in user
    @browser.email_address_field.value.should == @login
    @browser.confirm_email_address_field.value.should == @login
    # Enter in phone number if blank
    @browser.phone_number_field.value = @params['bill_phone'] if @browser.phone_number_field.value == ""
    # Feature flag controls this in the environment and is currently not turned on (this needs to be validated as still working)
    if @params['pur_feature_flag']
    ##Validate if user is PUR || NonPUR
      if @browser.hops_pur_textbox.value == ""
        #This will appear if cc info has not been entered yet in Account details
        if @browser.hops_pur_not_member_radio_button.exists == true
          @browser.hops_pur_not_member_radio_button.checked = "checked"
          @browser.hops_not_member_panel.should be_visible
          @browser.hops_cc_dropdown.value = @params['cc_type']
          @browser.hops_cc_textbox.value = @params['cc_number']
          @browser.hops_cc_dropdown.value.should_not == ""
          @browser.hops_cc_textbox.value.should_not == ""
        end
      else
        @browser.hops_pur_textbox.value.should_not == ""
        @browser.hops_not_member_panel.should_not_exist
      end
    end
    # Click on the Finish button to submit the form
    @browser.hops_finish_button.click
    # Part of feature flag
    if @params['pur_feature_flag']
      @browser.hops_pur_validator.should_not_exist
      @browser.hops_cc_validator.should_not be_visible if @browser.hops_not_member_panel.exists == true
    end
    # Validates alternate store popup displays just in case user wants to select another store
    @browser.hops_alternate_store_popup_panel.should be_visible
    @browser.hops_alternate_store_popup_panel.set_alternate_store_button.click
    @browser.wait_for_landing_page_load
    @browser.hops_accepted_page_title.should_exist
    @browser.hops_accepted_page_message.inner_text.should start_with "Sweet! We've sent an email to"
    @browser.log_out_link.click #assert that we were still logged in by logging out
  end

  it "Should perform HOPS request and store search for Smoke Validation" do
    # Log in with existing user
    @browser.log_in_link.click
    @browser.log_in(@login, @password)
    @browser.log_out_link.exists
    # Go directly to the HOPS page for an available SKU
    @browser.open("#{@start_page}/browse/storesearch.aspx?sku=#{@sku}")

    # Search for stores with the provided zip code
    if @browser.hops_zip_code_search_field.exists == true
      #@browser.hops_zip_code_search_button.should_exist
      @browser.hops_zip_code_search_field.value = @params['ship_zip']
      sleep 2 #Script race condition.  Search postal code was clicking before the zip code was entered.
      @browser.hops_zip_code_search_button.click
      sleep 3
      # Validates Pick Up At Store link exists for each store in the search results and click on the last link
      a = 0
      while a < @browser.hops_store_list.length
        item = @browser.hops_store_list.at(a)
        item.pickup_at_store_button.should_exist
        if a == @browser.hops_store_list.length - 1
          item.pickup_at_store_button.click
        end
        a = a + 1
      end
    end

    # Validate logged in
    @browser.log_out_link.exists
    # Enter in values for first and last name
    @browser.first_name_field.value = @params['bill_first_name']
    @browser.last_name_field.value = @params['bill_last_name']
    # Validate email address is populated based upon logged in user
    @browser.email_address_field.value.should == @login
    @browser.confirm_email_address_field.value.should == @login
    # Enter in phone number if blank
    @browser.phone_number_field.value = @params['bill_phone'] if @browser.phone_number_field.value == ""
    # Feature flag controls this in the environment and is currently not turned on (this needs to be validated as still working)
    if @params['pur_feature_flag']
      ##Validate if user is PUR || NonPUR
      if @browser.hops_pur_textbox.value == ""
        #This will appear if cc info has not been entered yet in Account details
        if @browser.hops_pur_not_member_radio_button.exists == true
          @browser.hops_pur_not_member_radio_button.checked = "checked"
          @browser.hops_not_member_panel.should be_visible
          @browser.hops_cc_dropdown.value = @params['cc_type']
          @browser.hops_cc_textbox.value = @params['cc_number']
          @browser.hops_cc_dropdown.value.should_not == ""
          @browser.hops_cc_textbox.value.should_not == ""
        end
      else
        @browser.hops_pur_textbox.value.should_not == ""
        @browser.hops_not_member_panel.should_not_exist
      end
    end
    # Click on the Finish button to submit the form
    @browser.hops_finish_button.click
    # Part of feature flag
    if @params['pur_feature_flag']
      @browser.hops_pur_validator.should_not_exist
      @browser.hops_cc_validator.should_not be_visible if @browser.hops_not_member_panel.exists == true
    end
    # Validates alternate store popup displays just in case user wants to select another store
    @browser.hops_alternate_store_popup_panel.should be_visible
    @browser.hops_alternate_store_popup_panel.set_alternate_store_button.click
    @browser.wait_for_landing_page_load
    @browser.hops_accepted_page_title.should_exist
    @browser.hops_accepted_page_message.inner_text.should start_with "Sweet! We've sent an email to"
    @browser.log_out_link.click #assert that we were still logged in by logging out
  end

  it "RequestHops as AuthenticatedUser when ShowHopsPURandCC is TRUE" do
    @browser.log_in_link.click
    @browser.log_in(@login, @password)

    @browser.open("#{@start_page}#{@product_url}")

    #FIXME : this is wrong.  We can't drop on the PDP, check if the product is new, and if so click on the pick up at store link...
    #the code line following this condition says to open the URL direct to the store search for a specific sku.  Kinda defeats
    #the point of clicking on the pickup at store link?  Just seems odd...
    if @product_cond == "NEW"
      @browser.hops_pickup_at_store_link.should_exist
      @browser.hops_pickup_at_store_link.click
    end
    @browser.open("#{@start_page}/browse/storesearch.aspx?sku=#{@sku}")

    $tracer.trace("Generated Store   ::::   #{@store}")
    $tracer.trace("Home Store   ::::   #{@home_store}")

    # TODO : Put this in a DSL
    #Validate if product is available for pickup @ homestore
    if @browser.hops_zip_code_search_field.exists == true
      @browser.hops_zip_code_search_button.should_exist
      @browser.hops_zip_code_search_field.value = @params['ship_zip']
      @browser.hops_zip_code_search_button.click
      a = 0
      while a < @browser.hops_store_list.length
        item = @browser.hops_store_list.at(a)
        item.pickup_at_store_button.should_exist
        if a = @browser.hops_store_list.length
          item.pickup_at_store_button.click
        end
        a = a + 1
      end
    end

    @browser.log_out_link.exists
    @browser.first_name_field.value = @params['bill_first_name']
    @browser.last_name_field.value = @params['bill_last_name']
    @browser.email_address_field.value.should == @login
    @browser.confirm_email_address_field.value.should == @login
    @browser.email_address_field.value = "testing email"
    @browser.confirm_email_address_field.value = "testing confirm"
    @browser.phone_number_field.value = @params['bill_phone'] if @browser.phone_number_field.value == ""
    #Validate if user is PUR || NonPUR
    if @browser.hops_pur_textbox.value == ""
      #This will appear if cc info has not been entered yet in Account details
      if @browser.hops_pur_not_member_radio_button.exists == true
        @browser.hops_pur_not_member_radio_button.checked = "checked"
        @browser.hops_not_member_panel.should be_visible
        @browser.hops_cc_dropdown.value = @params['cc_type']
        @browser.hops_cc_textbox.value = @params['cc_number']
        @browser.hops_cc_dropdown.value.should_not == ""
        @browser.hops_cc_textbox.value.should_not == ""
      end
    else
      @browser.hops_pur_textbox.value.should_not == ""
      @browser.hops_not_member_panel.should_not_exist
    end
    @browser.hops_finish_button.click
    #Validate if PUR || CC number is correct
    @browser.hops_pur_validator.should_not_exist
    @browser.hops_cc_validator.should_not be_visible if @browser.hops_not_member_panel.exists == true
    @browser.hops_alternate_store_popup_panel.should be_visible
    @browser.hops_alternate_store_popup_panel.cancel_link.click
    @browser.wait_for_landing_page_load
    @browser.hops_alternate_store_popup_panel.should_not be_visible
    @browser.hops_pur_validator.should_not_exist
    @browser.hops_cc_validator.should_not be_visible if @browser.hops_not_member_panel.exists == true
    @browser.hops_finish_button.click
    @browser.hops_alternate_store_popup_panel.should be_visible
    @browser.hops_alternate_store_popup_panel.set_alternate_store_button.click
    @browser.wait_for_landing_page_load
    @browser.hops_accepted_page_title.should_exist
    @browser.hops_accepted_page_message.inner_text.should start_with "Sweet! We've sent an email to"
    @browser.log_out_link.click
  end

  it "RequestHops as AuthenticatedUser when ShowHopsPURandCC is FALSE" do
    @browser.log_in_link.click
    @browser.log_in(@login, @password)

    @browser.open("#{@start_page}#{@product_url}")
    sleep 1 #wait for all the third party requests to do there thing
    @browser.hops_pickup_at_store_link.click
    @browser.hops_pickup_at_store_tooltip.should_exist
    @browser.open("#{@start_page}/browse/storesearch.aspx?sku=#{@sku}")

    if @browser.hops_zip_code_search_field.exists == true
      @browser.hops_zip_code_search_button.should_exist
      @browser.hops_zip_code_search_field.value = @ship_zip
      @browser.hops_zip_code_search_button.click
      a = 0
      while a < @browser.hops_store_list.length
        item = @browser.hops_store_list.at(a)
        item.pickup_at_store_button.should_exist
        item.pickup_at_store_button.click if a = @browser.hops_store_list.length
        a = a + 1
      end
    end

    @browser.log_out_link.exists
    @browser.first_name_field.value = @params['bill_first_name']
    @browser.last_name_field.value = @params['bill_last_name']
    @browser.email_address_field.value.should == @login
    @browser.confirm_email_address_field.value.should == @login
    @browser.phone_number_field.value = @params['bill_phone']

    #Validate if PUR and CC panel exist
    @browser.hops_pur_textbox.should_not_exist
    @browser.hops_finish_button.click
    @browser.hops_alternate_store_popup_panel.should be_visible
    @browser.hops_alternate_store_popup_panel.cancel_link.click
    @browser.wait_for_landing_page_load
    @browser.hops_alternate_store_popup_panel.should_not be_visible
    @browser.hops_finish_button.click
    @browser.hops_alternate_store_popup_panel.should be_visible
    @browser.hops_alternate_store_popup_panel.set_alternate_store_button.click
    @browser.wait_for_landing_page_load
    @browser.hops_accepted_page_title.should_exist
    @browser.hops_accepted_page_message.inner_text.should start_with "Sweet! We've sent an email to"
    @browser.log_out_link.click
  end

  def get_sku_and_store_data
    store_query = "SELECT top 50 a.[StoreID] as storeid, a.[QtyOnHand] as onhand, d.[ProductID] as productid, d.[Sku] as sku, f.[HopsEnabled] as hopsenabled, f.[StoreNumber] as storenumber
FROM [StoreInformation].[dbo].[StoreInventory] a with (NOLOCK)
INNER JOIN [StoreInformation].[dbo].[Product] d on a.ProductID = d.ProductID
INNER JOIN [StoreInformation].[dbo].[Store] f on a.StoreID = f.StoreID
WHERE a.QtyOnHand > 10 and  f.HopsEnabled = 1 ORDER BY NEWID()"

    @results_from_file = @db.exec_sql("#{store_query}")

    #@sku_match needs to be an array from the list of skus we get back from store information
    sku_match = []
    index = 0
    @results_from_file.each_with_index do |variant, i|
      store = @results_from_file.at(index).storenumber
      sku_match.push(variant.sku, store)
      index += 1
    end

    #puts *sku_match
    sku_store_hash = Hash[*sku_match]
    puts sku_store_hash

    availability = ""
    ind = 0
    ind_len = sku_store_hash.keys.length

    sku_store_hash.each_with_index do |(sku, store), i|
      $tracer.trace("THIS IS THE INDEX #{i}")
      begin
        #call to the catalog service to find a product that is available, if not, get the next sku in the array
        get_products_req = @catalog_svc.get_request_from_template_using_global_defaults(:get_products, CatalogServiceRequestTemplates.const_get("GET_PRODUCTS#{@catalog_svc_version}"))
        get_products_request_data = get_products_req.find_tag("get_products_request").at(0)
        get_products_request_data.session_id.content = @session_id
        get_products_request_data.skus.string.at(0).content = sku
        get_products_rsp = @catalog_svc.get_products(get_products_req.xml)
        $tracer.trace(get_products_req.formatted_xml)
        get_products_rsp.code.should == 200
        $tracer.trace("GET PRODUCTS RESPONSE")
        catalog_get_product_data = get_products_rsp.http_body.find_tag("product").at(0)
        availability = catalog_get_product_data.availability.content
        @condition = catalog_get_product_data.condition.content
        can_do_hops = catalog_get_product_data.is_in_store_pickup_for_hops.content
        $tracer.trace("THIS IS THE FLAG FOR CAN DO HOPS: #{can_do_hops} FOR #{sku}")
        $tracer.trace("THIS IS THE AVAILABILITY: #{availability} FOR #{sku}")
        #$tracer.trace(get_products_rsp.formatted_xml)
        #$tracer.trace("\tTHIS IS THE INDEX #{ind}\n\n")
        @sku = sku.to_s
        @store = store.to_s
          # ind += 1
      rescue Exception => ex
        @sku = sku.to_s
        @store = store.to_s
        # ind += 1
        $tracer.trace("THIS IS THE INDEX #{ind} OF #{ind_len}")
        $tracer.trace("CRITERIA NOT MET, KEEP LOOKING FOR YOU DROIDS")
        #break if ind_len == ind
      end
      break if (can_do_hops == "true" && availability == "A")
    end
    return @condition
  end
end
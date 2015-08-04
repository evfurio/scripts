##USAGE NOTES
##
##d-Con --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url QA_GS --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\hops_dataset.csv --range HOPS03 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_hops_product.sql --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\hops_request_guest_spec.rb --browser chrome -e 'RequestHops as Guest when ShowHopsPURandCC is TRUE' --or
##d-Con --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url QA2_GS --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\hops_dataset.csv --range HOPS03 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_hops_product.sql --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\hops_request_guest_spec.rb --browser chrome -e 'RequestHops as Guest when ShowHopsPURandCC is FALSE' --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()
#$tc_desc = $global_functions.desc
#$tc_id = $global_functions.id

describe "PickUp@Store Guest" do

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
    @browser.cookie.all.delete
    @session_id = generate_guid

    $tracer.trace(" *** Get Product Data *** ")
    get_sku_and_store_data
    @product_url = @catalog_svc.perform_get_product_url(@catalog_svc_version, @session_id, @sku)

    @browser.open(@start_page)
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    $tracer.trace("after all")
    @browser.close_all()
  end

  it "RequestHops as Guest when ShowHopsPURandCC is TRUE" do
    @browser.open("#{@start_page}#{@product_url}")
    @browser.hops_pickup_at_store_link.should_exist
    @browser.hops_pickup_at_store_link.click
    @browser.hops_pickup_at_store_tooltip.should_exist
    @browser.open("#{@start_page}/browse/storesearch.aspx?sku=#{@sku}")

    if @browser.hops_no_stores_popup.exists == true
      @browser.hops_no_stores_button.click
      @browser.wait_for_landing_page_load
    end
    @browser.hops_zip_code_search_field.should_exist
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

    @browser.log_out_link.exists
    @browser.hops_pur_member_radio_button.should_exist
    @browser.hops_pur_not_member_radio_button.should_exist
    @browser.first_name_field.value = @params['bill_first_name']
    @browser.last_name_field.value = @params['bill_last_name']
    @browser.email_address_field.value = @params['bill_email']
    @browser.confirm_email_address_field.value = @params['bill_email']
    @browser.phone_number_field.value = @params['bill_phone']
    @browser.hops_pur_not_member_radio_button.checked = "checked"
    sleep 1

    @browser.hops_not_member_panel.should be_visible
    @browser.hops_cc_dropdown.value = @params['cc_type']
    @browser.hops_cc_textbox.value = @params['cc_number']

    #Validate if CC info contains value
    @browser.hops_cc_dropdown.value.should_not == ""
    @browser.hops_cc_textbox.value.should_not == ""
    @browser.hops_finish_button.click
    sleep 1

    #Validate if CC number is correct
    if @browser.hops_not_member_panel.exists == true
      @browser.hops_cc_validator.should_not be_visible
    end

    @browser.hops_alternate_store_popup_panel.should be_visible
    @browser.hops_alternate_store_popup_panel.cancel_link.click
    @browser.wait_for_landing_page_load
    @browser.hops_alternate_store_popup_panel.should_not be_visible
    @browser.hops_finish_button.click
    sleep 1

    @browser.hops_alternate_store_popup_panel.should be_visible
    @browser.hops_alternate_store_popup_panel.set_alternate_store_button.click
    @browser.wait_for_landing_page_load

    @browser.hops_accepted_page_title.should_exist
    @browser.hops_accepted_page_message.inner_text.should start_with "Sweet! We've sent an email to"

  end

  it "RequestHops as Guest when ShowHopsPURandCC is FALSE" do
    @browser.open("#{@start_page}#{@product_url}")
    @browser.hops_pickup_at_store_link.should_exist
    @browser.hops_pickup_at_store_link.click
    @browser.hops_pickup_at_store_tooltip.should_exist
    @browser.open("#{@start_page}/browse/storesearch.aspx?sku=#{@sku}")

    if @browser.hops_no_stores_popup.exists == true
      @browser.hops_no_stores_button.click
      @browser.wait_for_landing_page_load
    end
    @browser.hops_zip_code_search_field.should_exist
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
    @browser.log_out_link.exists
    @browser.first_name_field.value = @params['bill_first_name']
    @browser.last_name_field.value = @params['bill_last_name']
    @browser.email_address_field.value = @params['bill_email']
    @browser.confirm_email_address_field.value = @params['bill_email']
    @browser.phone_number_field.value = @params['bill_phone']

    #Validate if PUR and CC panel exist
    @browser.hops_pur_textbox.should_not_exist
    @browser.hops_finish_button.click
    sleep 1

    @browser.hops_alternate_store_popup_panel.should be_visible
    @browser.hops_alternate_store_popup_panel.cancel_link.click
    @browser.wait_for_landing_page_load
    @browser.hops_alternate_store_popup_panel.should_not be_visible
    @browser.hops_finish_button.click
    sleep 1

    @browser.hops_alternate_store_popup_panel.should be_visible
    @browser.hops_alternate_store_popup_panel.set_alternate_store_button.click
    @browser.wait_for_landing_page_load

    @browser.hops_accepted_page_title.should_exist
    @browser.hops_accepted_page_message.inner_text.should start_with "Sweet! We've sent an email to"

  end

  def get_sku_and_store_data
    store_query = "SELECT top 100 a.[StoreID] as storeid, a.[QtyOnHand] as onhand, d.[ProductID] as productid, d.[Sku] as sku, f.[HopsEnabled] as hopsenabled, f.[StoreNumber] as storenumber
FROM [StoreInformation].[dbo].[StoreInventory] a with (NOLOCK) 
INNER JOIN [StoreInformation].[dbo].[Product] d on a.ProductID = d.ProductID 
INNER JOIN [StoreInformation].[dbo].[Store] f on a.StoreID = f.StoreID
WHERE a.QtyOnHand > 2 and  f.HopsEnabled = 1 ORDER BY NEWID()"


    server = "GV1HQDDB50SQL03.testgs.pvt\\INST03"
    database = "StoreInformation"

    @db = DbManager.new(server, database)
    sql2 = store_query
    @results_from_file = @db.exec_sql("#{sql2}")

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
        availability = catalog_get_product_data.availability.content.to_s
        can_do_hops = catalog_get_product_data.is_in_store_pickup_for_hops.content.to_s
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
  end

end
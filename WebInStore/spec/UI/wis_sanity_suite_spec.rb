####################################################################################################################################################################################################################################
###                                        Single execution in QA2 using available products                                                                                                                                      ###          
#################################################################################################################################################################################################################################### 
###
###  d-Con %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_sanity_suite_spec.rb --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv --url QA_EB --csv %QAAUTOMATION_SCRIPTS%\WebInStore\Spec\UI\wis_UI_dataset.csv --range TFS0001 --browser ie-webspec  --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --or 


require "#{ENV['QAAUTOMATION_SCRIPTS']}/WebInStore/dsl/src/dsl"
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"


describe "Sanity Test" do
  before(:all) do
    $options.default_timeout = 90_000
    $tracer.mode = :on
    $tracer.echo = :on
  end

  before(:each) do
    csv = QACSV.new(csv_filename_parameter)
    @row = csv.find_row_by_name(csv_range_parameter)

    #@browser.setup_before_each_scenario(@start_page)
    @browser = WebInStoreBrowser.new(browser_type_parameter)
    @global_functions = GlobalServiceFunctions.new()
    @global_functions.csv = @row
    @global_functions.parameters
    #@global_functions.csv_params
    @sql = @global_functions.sql_file
    @db = @global_functions.db_conn
    @store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc

    initialize_csv_params
    @store = get_store
    sql = @sql.to_s
    @results_from_file = @db.exec_sql_from_file(sql)
    @product_sku = @results_from_file.at(0).SKU
  end

  after(:each) do
    @browser.return_current_url
    @browser.close_all()
  end

  after(:all) do
    $tracer.trace("after all")
  end

  it "should verify all finders exists in header and check mature products tags" do
    url = "#{@url}/Checkout/instore/product?store=#{@store}&reg=3&pur=3876234510006&sku=#{@product_sku}&ctguest=true"
    # ensure_only_one_browser_window_open
    @browser.open(url)
    # wait_for_landing_page_load
    # @browser.search_field("Halo")
    @browser.search_all_button.should_exist
    # @browser.search_all_button.flash
    @browser.search_exp_selection_button.should_exist
    # @browser.search_online_button.flash
    @browser.search_field.should_exist
    # @browser.search_field.flash
    @browser.gamestop_logo.should_exist
    # @browser.gslogo.flash
    @browser.clear_customer_info_button.should_exist
    # @browser.clear_customer_info.flash
    @browser.best_sellers_button.should_exist
    # @browser.best_sellers_link.flash
    @browser.order_lookup_button.should_exist
    # @browser.order_lookup_link.flash
    @browser.view_cart_button.should_exist
    # @browser.view_cart_button.flash
    @browser.customer_info.should_exist
    @browser.esc_to_close_label.should_exist
    @browser.esrb_rating_image.should_exist
    @browser.age_verification_required_label.should_exist
    # @browser.age_warning_message.flash
    @browser.age_warning_checkbox.should_exist
    @browser.age_warning_checkbox.click
    # @browser.esrb_rating_img.flash
    # TODO @browser.also_available_label.should_exist
    # @browser.also_available_label.flash
    # TODO @browser.product_details_button.should_exist
    # @browser.product_details_button.flash

  end

  it "should verify all finders exists in header" do
    url = "#{@url}/Checkout/instore/product?store=#{@store}&reg=3&pur=3876234510006&sku=#{@product_sku}&ctguest=true"
    @browser.open(url)

    @browser.product_details_label.should_exist
    # @browser.product_details_label.flash
    @browser.product_name.should_exist
    # @browser.product_name_label.flash
    @browser.product_sku.should_exist
    # @browser.product_sku.flash
    @browser.quantity_field.should_exist
    # @browser.quantity_label.flash
    @browser.add_to_cart_button.should_exist
    # @browser.add_to_cart_button.flash
    @browser.product_condition.should_exist
    # @browser.item_condition_label.flash
    @browser.product_price.should_exist
    # @browser.item_price_label.flash
    @browser.product_description.should_exist
    # @browser.item_short_description.flash
    @browser.product_image.should_exist
    # @browser.product_image.flash
    @browser.product_user_rating.should_exist
    # @browser.user_rating_label.flash

    @browser.add_to_cart_button.click
    @browser.added_to_cart_label.should_exist
    puts " ################################# 4"
    # @browser.cart_label.should_exist
    @browser.subtotal_label.should_exist
    @browser.subtotal_ammount.should_exist
    @browser.discount_label.should_exist
    @browser.discount_ammount.should_exist
    @browser.order_total_label.should_exist
    @browser.order_total_ammount.should_exist
    @browser.cart_note.should_exist
    @browser.update_button.should_exist
    # @browser.item_added_to_cart_label.flash

    cart_list = @browser.cart_list
    item = cart_list.at(0)
    item.product_title.should_exist
    item.product_price.should_exist
    item.quantity_field.should_exist
    item.product_sku.should_exist
    item.delete_button.should_exist
    puts " ############################################# 5"
    @browser.checkout_button.should_exist
    @browser.continue_button.click

    @browser.shipping_information_label.should_exist

    @browser.country_selector.should_exist
    @browser.first_name_field.should_exist
    @browser.last_name_field.should_exist
    @browser.address_line_1_field.should_exist
    @browser.address_line_2_field.should_exist
    @browser.city_field.should_exist
    @browser.state_selector.should_exist
    @browser.postal_code_field.should_exist
    @browser.phone_field.should_exist
    @browser.email_field.should_exist
    @browser.confirm_email_field.should_exist

    @browser.address_verification_checkbox.should_exist
    @browser.address_verification_checkbox.click

    @browser.clear_all_fields_button.should_exist

    @browser.continue_button.click
    puts " ########################################## 6"
    @browser.cart_message.should_exist

    @browser.shipping_options_label.should_exist

    # FIX: needed implementation
    #@browser.handling_method_buttons.should_exist
    #options = @browser.handling_method_buttons
    #options.value = "Two Day"

    @browser.gift_message_checkbox.should_exist
    @browser.gift_message_field.should_exist
    @browser.address_information_label.should_exist
    @browser.first_name.should_exist
    @browser.last_name.should_exist
    @browser.address_line1.should_exist
    @browser.address_city.should_exist
    @browser.address_state.should_exist
    @browser.address_postal_code.should_exist
    @browser.address_email.should_exist

    @browser.subtotal_label.should_exist
    @browser.subtotal_ammount.should_exist
    @browser.shipping_method_label.should_exist
    @browser.shipping_method.should_exist
    @browser.sales_tax_label.should_exist
    @browser.sales_tax_ammount.should_exist
    @browser.discount_label.should_exist
    @browser.discount_ammount.should_exist
    @browser.order_total_label.should_exist
    @browser.order_total_ammount.should_exist

    @browser.submit_button.should_exist
    puts " ##################################### 7"
  end

  it "should verify all finders exist on Shipping page" do
    WebSpec.default_timeout 5000

    url = "#{@url}/Checkout/instore/product?store=#{@store}&reg=3"
    @browser.open(url)

    url = "#{@url}/Checkout/instore/product?sku=#{@product_sku}"
    @browser.open(url)
    @browser.add_to_cart_button.should_exist

    @browser.add_to_cart_button.click

    @browser.checkout_button.should_exist
    @browser.checkout_button.click
    @browser.address_verification_checkbox.click
    @browser.continue_button.should_exist
    @browser.continue_button.click

    @browser.customer_search_label.should_exist
    @browser.search_last_name_field.should_exist
    @browser.search_postal_code_field.should_exist
    @browser.search_phone_field.should_exist
    @browser.search_email_field.should_exist
    @browser.search_pur_field.should_exist
    @browser.search_go_button.should_exist

  end

  it "should verify order lookup" do
    @browser.open("#{@url}/Checkout/instore/Order/Search")

    @browser.last_name_field.should_exist
    @browser.postal_code_field.should_exist
    @browser.order_field.should_exist
    @browser.phone_field.should_exist
    @browser.email_field.should_exist
    @browser.pur_field.should_exist
    @browser.go_button.should_exist
  end

  it "should verify search" do
    @browser.open("#{@url}/Checkout/instore/Product/Search?searchtype=1&searchtext=lego")

    @browser.search_results_label.should_exist
    list = @browser.product_list
    item = list.at(0)
    item.product_title.should_exist
    item.product_title_link.should_exist
    item.product_price.should_exist
    item.product_details_button.should_exist
    item.product_sku.should_exist

    item.product_title_link.click
  end


  def initialize_csv_params
    @url = @row.find_value_by_name("url")
    @client_channel = @row.find_value_by_name("client_channel")
  end

  def get_store

    @session_id = generate_guid
    find_stores_in_range_req = @store_search_svc.get_request_from_template_using_global_defaults(:find_stores_in_range, StoreSearchServiceRequestTemplates.const_get("FIND_STORES_IN_RANGE#{@store_search_svc_version}"))

    find_stores_in_range_req.find_tag("session_id").at(0).content = @session_id # oddly found in header
    find_stores_in_range_req.find_tag("client_channel").at(0).content = @client_channel
    $tracer.trace(find_stores_in_range_req.formatted_xml)
    find_stores_data = find_stores_in_range_req.find_tag("find_stores_in_range_request").at(0)
    find_stores_data.address.content = '75038'
    find_stores_data.country_code.content = 'US'
    find_stores_data.radius_in_kilometers.content = '10'

    #$tracer.trace(find_stores_in_range_req.formatted_xml)

    find_stores_in_range_rsp = @store_search_svc.find_stores_in_range(find_stores_in_range_req.xml)

    find_stores_in_range_rsp.code.should == 200

    #$tracer.trace(find_stores_in_range_rsp.http_body.formatted_xml)

    store = find_stores_in_range_rsp.http_body.find_tag("store").at(0)

    return store.store_number.content
  end

end

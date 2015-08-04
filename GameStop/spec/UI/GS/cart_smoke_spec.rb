# USAGE NOTES
# Checkout as an Authenitcated User
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\cart_smoke_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_ten_products.sql --browser chrome --or


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Cart Validation" do
  before(:all) do
    @browser = GameStopBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 30_000
    $snapshots.setup(@browser, :all)

    #Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
  end

  before(:each) do
    @browser.cookie.all.delete
    @session_id = generate_guid
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    $tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id) unless @params["renew_pur"]

    $tracer.trace(" *** Clear Cart *** ")
    @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)

    @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
    @cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)

    @browser.open(@start_page)
    @browser.validate_cookies_and_tags(@params)
    if @params["do_merge_cart"]
      $tracer.trace("Add to cart by service invocation")
      @matured_product_svc, @physical_product_svc = @browser.add_products_to_cart_by_service(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id, @cart_id, @cart_svc, @cart_svc_version)
    end
    @browser.log_in_link.click
    @browser.log_in(@login, @password)
    sleep 5
    #@browser.empty_new_cart unless @params["do_merge_cart"]
    @browser.check_adroll_on_other_pages(@params, @start_page) if @params["do_adroll"]

    if @params["renew_pur"]
      $tracer.trace("PUR Renewal")
      pur_renewal_url = @browser.add_renewal_sku_to_cart_by_url(@params["renewal_type"], @start_page)
      # @physical_pur = @params["renewal_type"].eql?("Physical") ? true : false
      @physical_pur = true # This is always true b/c both renewal type (Physical and Digital) are being shipped to address.
      @browser.open(pur_renewal_url)
    else
      @matured_product, @physical_product = @browser.add_products_to_cart_by_service(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id, @cart_id, @cart_svc, @cart_svc_version)
      #@browser.add_products_to_cart_by_url(@product_urls, @start_page, @params)

      #verify "Your Cart" button
      @browser.my_cart_button.should_exist
      @browser.my_cart_button.click

      @browser.add_powerup_rewards_number(@params)
      $tracer.trace("Check subtotal and total")
      subtotal = @browser.check_cart_subtotal_and_discount(@params)
    end

    ###Begin Validations

    #verify empty cart function
    @browser.empty_cart

    #verify "Shipping Options"
    @matured_product, @physical_product = @browser.add_products_to_cart_by_service(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id, @cart_id, @cart_svc, @cart_svc_version)
    @browser.refresh_page
    sleep 1
    @browser.cart_list.at(0).shipping_option_buttons.should_exist

    #verify "Product Description"
    @browser.cart_list.at(0).name_link.should_exist

    #verify "Availability"
    @browser.cart_list.at(0).availability_label.should_exist
    @browser.cart_list.at(0).availability_link.should_exist

    #verify "Qty"
    @browser.cart_list.at(0).quantity_field.should_exist

    #verify "Update"
    @browser.cart_list.at(0).update_link.should_exist

    #verify "Trash"
    trash = @browser.cart_list.at(0).remove_button.innerText
    trash == "trash"

    #verify "Price"
    @browser.cart_list.at(0).price.should_exist

    #verify "Sub-Total"
    @browser.cart_subtotal_value.should_exist
    subtotal = @browser.cart_subtotal_value.innerText

    #verify "PUR # Field"
    @browser.powerup_rewards_number_field.should_exist

    #verify "PUR Points Label"
    @browser.powerup_rewards_points_label.should_exist

    #verify "PUR Discount Label"
    @browser.powerup_rewards_discount_label.should_exist

    #verify Empty Cart Label
    @browser.empty_cart_label.should_exist

    #verify pre-discount value
    @browser.cart_pre_discount_value.should_exist

    #verify cart discounts list
    @browser.cart_discounts_list.should_exist

    #verify remove promo code button
    @browser.remove_promo_code_button.should_exist

    #verify previous cart items label
    @browser.previous_cart_items_label.should_exist

    #verify invalid quantity message label
    @browser.cart_list.at(0).invalid_quantity_message_label.should_exist

    #verify Promo Code Label
    @browser.promo_code_label.should_exist

    #verify Invalid Promo Code Message
    @browser.promo_code_label.should_exist

    #verify "Promo Code" field
    @browser.promo_code_field.should_exist

    #verify "Apply" button
    #verify "PUR card image"
    #verify "View Handling Rates and Exceptions
    #verify "Continue Shopping" butotn
    #verify "Continue Checkout" button
    #verify "Recommendations"

    #verify Shopping Cart Label
    @browser.shopping_cart_label.should == "Shopping Cart"

    #verify Continue Checkout Button
    @browser.continue_checkout_button.should_exist

  end
end
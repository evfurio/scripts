#USAGE NOTES#
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_EF_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range EF02 --browser chrome --or 

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "EF Guest" do

  before(:all) do
    #Set proxy for the web driver
    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9091"

    $proxy = ProxyServerManager.new(9091)
    @browser = WebBrowser.new(browser_type_parameter)

		@browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 10_000
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
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
		
  end

  before(:each) do
    $proxy.inspect
    $proxy.start
    sleep 5
		
		@browser.delete_all_cookies_and_verify
    @session_id = generate_guid
    $tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)

  end

  after(:each) do
    $proxy.stop
		@browser.return_current_url
  end

  after(:all) do
    @browser.close
  end

	it "#{$tc_id} #{$tc_desc}" do
    $proxy.start_capture(true)
		@browser.open($global_functions.prop_url.find_value_by_name("affiliate_url")) if @params["do_ef"]
		@ef_id = @browser.get_ef_id(@browser.url_data.full_url)
				
		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, '', @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Click Checkout As Guest")
		@browser.chkoutbuy_as_guest_button.click
		@browser.wait_for_landing_page_load
			
		@browser.handle_mature_product_screen(@params) if @matured_product
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Fill Out Shipping Address Form")
		@browser.fill_out_shipping_form(@params)
		@browser.same_address_checkbox.click
		@browser.wait_for_landing_page_load
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Handling Options")
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Enter Credit Card Info")
		@browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])
		@browser.wait_for_landing_page_load
		
		$tracer.trace("Submitted Order")
    @browser.submit_order_button.click
		@browser.wait_for_landing_page_load
		
    $tracer.trace("Order Confirmation")
    @browser.ensure_header_loaded
    @browser.create_acct_modal_panel.modal_close_button.click if @browser.create_acct_modal_panel.exists
    @browser.wait_for_landing_page_load
    @browser.retry_until_found(lambda{@browser.order_confirmation_label.exists != true})
    @browser.order_confirmation_label.should_exist

		@browser.get_ef_cookies(@ef_id) if @params["do_ef"]	

	end

end
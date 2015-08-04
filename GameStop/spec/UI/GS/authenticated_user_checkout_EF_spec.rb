# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_EF_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range EF01 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "EF cookies Authenticated User Checkout" do
  before(:all) do
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
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
    @shipping_svc, @shipping_svc_version = $global_functions.shipping_svc
  end

  before(:each) do
		$proxy.inspect
    $proxy.start
    sleep 5
		
    @env_name, @release_id = @browser.get_octopus_release
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
  end

  after(:each) do
		$proxy.stop
		@browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
    $tracer.report("Environment : #{@env_name}, Release ID : #{@release_id}")
  end

  it "#{$tc_id} #{$tc_desc}" do
    $tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id) unless @params["renew_pur"]

    $tracer.trace(" *** Clear Cart *** ")
    @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
		@cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
    @cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)

		$proxy.start_capture(true)
    @browser.open($global_functions.prop_url.find_value_by_name("affiliate_url"))
		
		@id = @browser.url_data.full_url.split("ef_id=")
    @ef_id = @id[1].split(":")
    $tracer.report("EF ID from URL ::   #{@ef_id[0]}")

    @browser.log_in_link.click
    @browser.log_in(@login, @password)
    @browser.empty_new_cart
    @browser.wait_for_landing_page_load

		@browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, @cart_id, @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
		@browser.wait_for_landing_page_load
    		
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load

    @browser.handle_mature_product_screen(@params) if @matured_product
    @browser.wait_for_landing_page_load

    $tracer.trace("Enter Shipping Address Info.")
		@browser.fill_out_shipping_form(@params)
    @browser.same_address_checkbox.click
		@browser.wait_for_landing_page_load
    @browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load
        
    $tracer.trace("Handling Options")
		@browser.continue_checkout_button.click
		@browser.wait_for_landing_page_load

    $tracer.trace("Payment Options")
    @browser.wallet_label.value = "-- Select a Card--" if @browser.wallet_label.exists
		$tracer.trace("Enter Credit Card Info")
    @browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])
		@browser.wait_for_landing_page_load

		$tracer.trace("Submitted Order")
    @browser.submit_order_button.click
		@browser.wait_for_landing_page_load

    $tracer.trace("Order Confirmation")
    @browser.ensure_header_loaded
		@browser.wait_for_landing_page_load
    @browser.retry_until_found(lambda{@browser.order_confirmation_label.exists != true})
    @browser.order_confirmation_label.should_exist

		capture_data = $proxy.get_capture
		$tracer.trace(capture_data.formatted_json)
		
    url = @browser.return_current_url
    ef_cookies = get_request_from_url((capture_data), url)
		trace_request_cookies(ef_cookies, @ef_id[0])
  end
		
	def get_request_from_url(capture_data, url, page = nil, requested_cookie_array = nil)
    list = []
		entries_list = capture_data.log.entries
    $tracer.trace(entries_list)
    unless entries_list.length > 0
      raise Exception, "no 'entries' found to test"
    end

    entries_list.each do |e|
			if e.request.exists && (e.request.url.content.include?("pixel.everesttech.net") && e.request.url.content.include?("qa.gamestop.com")) && (page.nil? || e.pageref.content.downcase == page.downcase)
        Struct.new("CookieData", :page, :url, :cookie_hash)
        record = Struct::CookieData.new(nil, nil, {})
				$tracer.report("PageRef :: #{e.pageref.content}")
				$tracer.report("URL :: #{e.request.url.content}")
				cookies_list = e.response.cookies
        cookies_list.each do |item|
          if requested_cookie_array.nil? || requested_cookie_array.include?(item.name.content)
            record.cookie_hash[item.name.content] = item.value.content
          end
        end
        list << record
			end
    end
		return list
  end
	
	def trace_request_cookies(ef_cookies, ef_id_from_url)
    ef_cookies.each do |rec|
      if rec.class.eql?(Struct::CookieData)
        rec.cookie_hash.each do |k, v|
          $tracer.trace("\t ------ #{k}: #{v}")
					v.should include ef_id_from_url
					$tracer.report("EF cookie (should contain EF ID from URL) ::   #{v}")
        end
      else
        raise Exception, "ef cookies must be from get_request_from_url() call"
      end
    end
  end
	
end
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\oms_checkout_regular_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\oms_checkout_dataset.csv --range TFS18130 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "#{$tc_id} OMS" do
  before(:all) do
    @browser = WebBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 60_000
    $snapshots.setup(@browser, :all)

    @params = $global_functions.csv
    # @sql = $global_functions.sql_file
    # @db = $global_functions.db_conn
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
    @before_env_name, @before_release_id = @browser.get_octopus_release
    $tracer.report("Environment : #{@before_env_name}, Release ID : #{@before_release_id}")
    $tracer.trace("#{@env_name}; #{@release_id}")
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @after_env_name, @after_release_id = @browser.get_octopus_release
    $tracer.report("Environment : #{@after_env_name}, Release ID : #{@after_release_id}")
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    $tracer.trace("Get products")  
		@product_urls, @matured_product, @physical_product, @condition, @db_result = load_test_skus_from_csv(@velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)

    @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
    @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
    @cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)
    @browser.open(@start_page)

    @browser.log_in_link.click
    @browser.log_in(@login, @password)

    if @params["renew_pur"]
      $tracer.trace("PUR Renewal")
      pur_renewal_url = @browser.add_renewal_sku_to_cart_by_url(@params["renewal_type"], @start_page)
      @physical_pur = true # This is always true b/c both renewal type (Physical and Digital) are being shipped to address.
      @browser.open(pur_renewal_url)
    else
		
		
		
		
		
		
      # @browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, @cart_id, @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
      
			sku_qty = @params["qty"].split("|") unless @params["qty"] == ""
			i = 0
			@product_urls.each_with_index do |url|
				@browser.open("#{@start_page}#{url}")
				@browser.buy_first_panel.add_to_cart_button.click
				@browser.upsell_checkout_button.click if @browser.upsell_modal_panel.exists == true
				sleep 3
				unless sku_qty[i] == "1"
					@browser.cart_list.at(i).quantity_field.value = sku_qty[i]
					@browser.cart_list.at(i).update_link.click
					@browser.wait_for_landing_page_load
				end
				i += 1
			end
			
			
			
			
			
			
			@browser.take_snapshot("bert")
			promo_code = @params["promo_code_number"].split("|")
			ctr = 0
			while ctr < promo_code.length do	
				@browser.promo_code_field.value = promo_code[ctr]
				@browser.apply_button.click
				sleep 3
				ctr += 1
			end
			@browser.wait_for_landing_page_load
			
			
			

      # @browser.add_powerup_rewards_number(@params)
      # $tracer.trace("Check subtotal and total")
      # subtotal = @browser.check_cart_subtotal_and_discount(@params)
      # @browser.paypal_chkout_button.should_exist 

      $tracer.trace("THIS IS THE ENTRY TO PAYPAL IN THE CART")
      if @params["use_paypal_at_cart"]
        @browser.paypal_chkout_button.click
        @browser.paypal_sandbox_login
        sleep 3
      else
        @browser.continue_checkout_button.click
      end
    end
    @browser.wait_for_landing_page_load

    # Mature or Adult Audience confirmation page
    if @matured_product || @matured_product_svc
      @browser.handle_mature_product_screen(@params) unless @params["use_paypal_at_cart"]
    end

    if @params["use_paypal_at_cart"]
      $tracer.trace("Continue through PayPal")
      @browser.paypal_test_acct_continue_button.click
      sleep 3
      $tracer.trace("----------RETURN TO GAMESTOP.COM AgeConfirmation page if MaturedProduct and/or HandlingOptions page if PhysicalProduct----------")
      @browser.handle_mature_product_screen(@params) if @matured_product
      @browser.enter_handling_options(@params) if @physical_product
    else
      if @physical_product || @physical_pur
        if @params["load_ship_addr_from_profile"]
          $tracer.trace("Load Shipping Address Info From Profile.")
          @browser.check_checkout_shipping_fields_exist
        else
          $tracer.trace("Enter Shipping Address Info.")
          @browser.fill_out_shipping_form(@params)
        end

        # Billing Address and shipping address same
        if @params["billing_address_same_as_shipping"]
          $tracer.report("Use same address for billing and shipping")
          @browser.same_address_checkbox.click
          @browser.continue_checkout_button.click
        else
          @browser.continue_checkout_button.click
          @browser.wait_for_landing_page_load
          if @params["load_bill_addr_from_profile"]
            $tracer.report("Load Billing Address Info From Profile.")
            @browser.check_checkout_billing_fields_exist
          else
            $tracer.report("Enter Billing Address Info.")
            @browser.fill_out_billing_form(@params)
          end
          @browser.validate_cookies_and_tags(@params)
          @browser.validate_cart_badge(@session_id, @cart_id, @cart_svc, @cart_svc_version, @params)
          @browser.continue_checkout_button.click
          @browser.wait_for_landing_page_load
        end
        $tracer.trace("Handling Options")
        @browser.wait_for_landing_page_load
        i = 0
        while i < @browser.handling_options_page_panel.length
          panel = @browser.handling_options_page_panel.at(i)
          if  panel.title.innerText.eql? ("Pick Up At Store")
            $tracer.trace("Choose Store For ISPU product")
            panel.choose_store_link.click
            sleep 5
            @browser.search_store_adress.should_exist
            @browser.search_store_adress.value = @params["ship_zip"]
            @browser.search_store_adress_button.should_exist
            @browser.search_store_adress_button.click
            sleep 5
            @browser.choose_store_button.should_exist
            @browser.choose_store_button.click
            @browser.wait_for_landing_page_load
            @browser.ispu_phone_number.value = @params["bill_phone"]
          end
          i = i +1
        end
        @browser.continue_checkout_button.click
      else
        #Verify Checkout page (Billing Address Info)
        $tracer.trace("Billing Address Info.")
        @browser.wait_for_landing_page_load
        @browser.check_checkout_billing_fields_exist
        @browser.continue_checkout_button.click
      end

      #Checkout - Payment Options
      $tracer.trace("Payment Options")
      @browser.wait_for_landing_page_load
      @browser.validate_payment_options_and_total(@condition, @physical_product, @params)
      order_summary_total = money_string_to_decimal(@browser.order_summary_total.innerText)
      @browser.paypal_payment_selector.should_exist

      if @params["pay_from_digital_wallet"]
        @browser.enter_digital_wallet_info(@digital_wallet_svc, @digital_wallet_version, @open_id, @params)
      elsif @params["use_paypal_at_payment"]
        @browser.paypal_payment_selector.click
        @browser.paypal_chkout_button.click
        # Log into PayPal sandbox
        $tracer.trace("Log Into PayPal")
        @browser.paypal_sandbox_login

        $tracer.trace("Continue through PayPal")
        @browser.paypal_test_acct_continue_button.click
        #Should be back on the gamestop.com handling options page now
        sleep 3
      else
        @browser.wallet_label.value = "-- Select a Card--" if @browser.wallet_label.exists

        #FIXME : This doesn't feel right.  Should have a flag to tell the test to use SVS or not.
        if @params["svs"].empty?
          $tracer.trace("Enter Credit Card Info")
          @browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])
        else
          $tracer.trace("Pay with Gift Card")
          svs_balance = @purchase_order_svc.perform_get_svs_balance(@params["svs"], @params["pin"], @session_id, @purchase_order_svc_version)
          @browser.enter_svs_info(@params["svs"], @params["pin"], svs_balance, order_summary_total)
          @browser.wait_for_landing_page_load
        end
      end
      sleep 5
    end

    #Submit the order only if the value of submit_order_flag from csv file is 'true'
    if @params["submit_order_flag"]
      $tracer.trace("Submitted Order")
      order_num = @browser.submit_and_confirm_order(@params, @condition)
      # @browser.check_confirmation_page_subtotal(subtotal) unless @params["renew_pur"]
     
      # $tracer.trace("Call purchase order service to get order information")
      # get_purchase_order_by_tracking_number_rsp = @purchase_order_svc.perform_get_placed_order(@session_id, "GS_US", "en-US", order_num, @purchase_order_svc_version)

      # $tracer.trace(get_purchase_order_by_tracking_number_rsp.http_body.formatted_xml)
      # get_purchase_order_by_tracking_number_rsp.code.should == 200
      # get_purchase_order_by_tracking_number_rsp.http_body.find_tag("owner_id").content.should == @cart_id

      # # Billing information not present for PayPal
      # if !@params["use_paypal_at_cart"] && !@params["use_paypal_at_payment"]
        # customer_billing = get_purchase_order_by_tracking_number_rsp.http_body.find_tag("customer").bill_to
        # if @params["load_bill_addr_from_profile"]
          # @browser.check_address_equivalence(customer_billing, @billing_address)
        # else
          # @browser.check_address_equivalence_against_params(customer_billing, @params)
        # end
      # end
			po_date = Time.now
			po_date = po_date.strftime("%Y-%m-%dT%H:%M:%S.000-06:00")
			results_to_csv($tc_id, order_num, po_date)
    end
  end
	
	def load_test_skus_from_csv(velocity_svc, velocity_svc_version, catalog_svc, catalog_svc_version, params, session_id)
		$tracer.trace("GameStopCartFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    product_urls = []
    condition = []
    matured_product = false
    physical_product = false
		
		sku = @params["sku"].split("|")
		ctr = 0
		while ctr < sku.length do	
				$tracer.trace("Product Sku from csv :::::  #{sku[ctr]}")
				
				catalog_rsp = catalog_svc.perform_get_product_by_sku(catalog_svc_version, session_id, sku[ctr])
				product_urls << catalog_rsp.http_body.find_tag("product").at(0).url.content
				matured_product = (catalog_rsp.http_body.find_tag("product").at(0).esrb_rating.content.eql?("M") ? true : false) if !matured_product
				physical_product = (catalog_rsp.http_body.find_tag("product").at(0).product_type.content.eql?("Digital") ? false : true) if !physical_product
				condition << catalog_rsp.http_body.find_tag("product").at(0).product_type.content.upcase
				
				$tracer.trace("Product URL :::::  #{catalog_rsp.http_body.find_tag("product").at(0).url.content}")
				$tracer.trace("ESRB Rating :::::  #{catalog_rsp.http_body.find_tag("product").at(0).esrb_rating.content}")
				$tracer.trace("Condition :::::  #{catalog_rsp.http_body.find_tag("product").at(0).product_type.content}")
				$tracer.trace("Matured_product :::::  #{matured_product}     Physical_product :::::  #{physical_product}")
				ctr += 1
		
		end
		puts "====================================================================================== #{condition}"
		return product_urls, matured_product, physical_product, condition, nil
  end
	
	def results_to_csv(tc_id, order_number, time)
		dump_to_csv = "true"
		
		if dump_to_csv == "true"
			header = []
			test_info = []
			header << "TFS_ID, ORDER_Number, TIME"
			test_info << "#{tc_id},'#{order_number},'#{time}"
			puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  #{order_number}"
			puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  #{test_info}"
			path = "#{ENV['QAAUTOMATION_SCRIPTS']}/OMS/"
			Dir.mkdir(path) unless File.exists?(path)
			
			test_info.each do |i|
				csv_builder(test_info)
				
				CSV.open("#{path}\\oms_ui_regression_results.csv", "a") do |csv|
					csv << @data
				end
			end
		end
  end
  
  def csv_builder(tst_info)
		test_info = tst_info.join(",")
		csv_data = "#{test_info}"

		# The parser just converts these into an array of CSV cells
		array_of_csv_cells = CSV.parse csv_data
		
		# The first CVS row are the headings
		@data = array_of_csv_cells.shift.map {|rd| rd.to_s}

		# Convert the array of CSV cells into an Array of Hashes
		products_in_structures = array_of_csv_cells.map do |cells|
			hsh = {}
			(cells.map {|cell| cell.to_s}).each_with_index do |cell_str, index|
			hsh[index] = cell_str
			end
		hsh
		end	

		return @data
	end
	
end
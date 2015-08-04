#USAGE NOTES
#d-Con --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv  --url QA_GS --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\sanity_and_smoke.csv --range TFSTEMP01 --login qa_ui_testing1@4test.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\host_file_modification.rb --browser chrome -e 'should get omniture variables from the cart' --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"


describe "GS Omniture Checkout Variables Suite" do


  before(:all) do
    @browser = GameStopBrowser.new(browser_type_parameter)
    #$options.default_timeout = 10_000
    $tracer.mode=:on
    $tracer.echo=:on
    #@browser.setup_before_all_scenarios
  end

  before(:each) do
    @browser.delete_all_cookies_and_verify

    #Get necessary GUID's per test method execution
    @session_id = generate_guid
    @params = @browser.initialize_params_from_csv(QACSV.new(csv_filename_parameter), csv_range_parameter)

    #global_functions passes the csv row object and return the parameters.
    @global_functions = GlobalServiceFunctions.new()
    @global_functions.csv = @row
    @global_functions.parameters
    @global_functions.csv = @params["row"]
    @sql = @global_functions.sql_file
    @db = @global_functions.db_conn
    @catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
    @start_page = @global_functions.prop_url.find_value_by_name("url")
    @cart_svc, @cart_svc_version = @global_functions.cart_svc
    @account_svc, @account_svc_version = @global_functions.account_svc
    @profile_svc, @profile_svc_verzion = @global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_verzion = @global_functions.digitalwallet_svc

    @inj_host == @params["inj_host"] if @params["host_file"] == true
    #Inject HOSTS modifications if necessary.  This should really only be used if you're testing individual servers in a VIP
    begin
      #this should be a CSV parameter
      inj_path = "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/Spec/UI/GS/#{@inj_host}"
      ModHost.mod_hosts(inj_path)
      $tracer.trace("Changes were applied to #{inj_path}")
    rescue Exception => ex
      $tracer.trace("No modifications made to HOSTS")
    end

    $tracer.trace(" *** Clear Cart *** ")
    @user_id = @account_svc.perform_authorization_and_return_owner_id(@session_id, account_login_parameter, account_password_parameter, @account_svc_version)
    @cart_svc.perform_empty_cart(@session_id, @user_id, 'GS_US', 'en-US', @cart_svc_version)

    $tracer.trace(" *** GET Profile *** ")

    shipping_address, billing_address = @profile_svc.get_address_by_user_id(@user_id, @session_id, "GS_US", @profile_svc_version)

    if shipping_address == nil

    end


    #@browser.setup_before_each_scenario(@start_page)
    sql = @sql.to_s
    @results_from_file = @db.exec_sql_from_file("#{sql}")

    #uses the sku(s) returned from the SQL query to get product details information from the catalog service
    $tracer.trace(" *** Get Product Data *** ")
    get_product_data

    # checking to see if we're still logged in, if so, log out.  fix for the auth "states".


    @browser.open(@start_page)
    if @browser.log_out_link.exists
      @browser.log_out_link.click
    end

  end

  after(:all) do
    $tracer.trace("after all")

=begin	
	if @add_digital_wallet == "True"
	      digital_wallet_req = @digital_wallet_svc.get_request_from_template_using_global_defaults(:get_digital_wallets, DigitalWalletServiceRequestTemplates.const_get("GET_DIGITAL_WALLETS#{@digital_wallet_verzion}"))
          get_digital_wallets_request_data = digital_wallet_req.find_tag("get_digital_wallets_request").at(0)    
          get_digital_wallets_request_data.open_id_claimed_identifiers.string.at(0).content = "https://loginqa.testecom.pvt/ID/pG3CGKdHnke6jXwPa6pAcw"        
		 
		  puts digital_wallet_req.formatted_xml
		 
		 
		 digital_wallet_rsp = @digital_wallet_svc.get_digital_wallets(digital_wallet_req.xml)
		 
		   $tracer.trace(digital_wallet_rsp.http_body.formatted_xml)
	end
=end

    @browser.close_all()
  end

  after(:each) do
    ModHost.mess_cleaner
    $tracer.trace("Changes were reverted to for the HOSTS file.")
  end


  it "should get omniture variables from the cart" do
    @browser.log_in_link.click
    @browser.log_in(account_login_parameter, account_password_parameter)
    #@browser.empty_new_cart


    # expected to be on the product details page at this point.
    $tracer.trace("#{@url}")
    url = "#{@start_page}#{@url}"
    @browser.open(url)
  end

  def initialize_csv_params
    csv = QACSV.new(csv_filename_parameter)
    @row = csv.find_row_by_name(csv_range_parameter)
    @sign_up_weekly_ads = @row.find_value_by_name("sign_up_weekly_ads")
    @power_up_rewards_number = @row.find_value_by_name("power_up_rewards_number")
    @promo_code_number = @row.find_value_by_name("promo_code_number")
    @add_free_gift = @row.find_value_by_name("add_free_gift")
    @add_digital_wallet = @row.find_value_by_name("add_digital_wallet")
    @billing_address_same_as_shipping = @row.find_value_by_name("billing_address_same_as_shipping")
    @credit_card = @row.find_value_by_name("cc_number")
    @cc_type = @row.find_value_by_name("cc_type")
    @exp_month = @row.find_value_by_name("cc_month")
    @exp_year = @row.find_value_by_name("cc_year")
    @svs = @row.find_value_by_name("cvv")
    @shipping_option = @row.find_value_by_name("shipping_option")
    @submit_order_flag = @row.find_value_by_name("submit_order_flag")
    @gift_msg = "Gift message string"
    @ship_first_name = @row.find_value_by_name("ship_first_name")
    @ship_last_name = @row.find_value_by_name("ship_last_name")
    @ship_addr1 = @row.find_value_by_name("ship_addr1")
    @ship_addr2 = @row.find_value_by_name("ship_addr2")
    @ship_city = @row.find_value_by_name("ship_city")
    @ship_state = @row.find_value_by_name("ship_state")
    @ship_zip = @row.find_value_by_name("ship_zip")
    @ship_phone = @row.find_value_by_name("ship_phone")
    @ship_email = @row.find_value_by_name("ship_email")
    @ship_country = @row.find_value_by_name("ship_country")
    @bill_country = @row.find_value_by_name("bill_country")
    @bill_first_name = @row.find_value_by_name("bill_first_name")
    @bill_last_name = @row.find_value_by_name("bill_last_name")
    @bill_addr1 = @row.find_value_by_name("bill_addr1")
    @bill_addr2= @row.find_value_by_name("bill_addr2")
    @bill_city= @row.find_value_by_name("bill_city")
    @bill_state= @row.find_value_by_name("bill_state")
    @bill_zip= @row.find_value_by_name("bill_zip")
    @bill_phone = @row.find_value_by_name("bill_phone")
    @bill_email = @row.find_value_by_name("bill_email")
    @inj_host = "hosts.ebgames"
  end

  def get_product_data
    #############################DSL#####################################
    #call to the catalog service to get the entity.url if the service is up
    ### GET_PRODUCT URL### THIS NEEEDS TO BE IN A DSL AND CALLED IN BEFORE EACH
    @sku = @results_from_file.at(0).variantid
    $tracer.trace("VariantID used for test: #{@sku}")

    get_products_req = @catalog_svc.get_request_from_template_using_global_defaults(:get_products, CatalogServiceRequestTemplates.const_get("GET_PRODUCTS#{@catalog_svc_version}"))
    get_products_request_data = get_products_req.find_tag("get_products_request").at(0)
    get_products_request_data.session_id.content = @session_id
    get_products_request_data.skus.string.at(0).content = @sku
    # $tracer.trace(get_products_req.formatted_xml)
    get_products_rsp = @catalog_svc.get_products(get_products_req.xml)
    get_products_rsp.code.should == 200
    # $tracer.trace(get_products_rsp.http_body.formatted_xml)
    catalog_get_product_data = get_products_rsp.http_body.find_tag("product").at(0)
    @url = catalog_get_product_data.url.content
    @product_name = catalog_get_product_data.display_name.content
  end


end
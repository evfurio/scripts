# Command line arguments
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\subscribe_unsubscribe_to_mailing_list_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range Unsubscribe --browser chrome -e 'Unsubscribe :: Newsletter subscribe when registering a new user in checkout' --or 
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\subscribe_unsubscribe_to_mailing_list_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range Unsubscribe --browser chrome -e 'Unsubscribe :: Newsletter subscribe when registering a new user through the profile app' --or 
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\subscribe_unsubscribe_to_mailing_list_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range Unsubscribe --browser chrome -e 'Unsubscribe :: Newsletter subscribe in checkout' --or 

# Append this in the command line
#-e 'Unsubscribe :: Newsletter subscribe in checkout'
#-e 'Unsubscribe :: Newsletter subscribe when registering a new user in checkout'
#-e 'Unsubscribe :: Newsletter subscribe when registering a new user through the profile app'

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Subscribe Unsubscribe to Mailing List" do
  before(:all) do
    @browser = GameStopBrowser.new(browser_type_parameter)
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

  it "Unsubscribe :: Newsletter subscribe when registering a new user in checkout" do
    #This scenario should subscribe new user (created in checkout) from the mailing list then unsubscribe via service call.
    @user_name = @browser.generate_new_user_credentials(prefix = "ui_autogen", domain = "qagsecomprod.oib.com")
    @password = $global_functions.password_generator(10)

    $tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id) unless @params["renew_pur"]

    @browser.open(@start_page)
    @browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, @cart_id, @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
    @browser.wait_for_landing_page_load
    @browser.continue_checkout_button.click
    @browser.wait_for_landing_page_load

    @browser.create_account_link.click
    @browser.wait_for_landing_page_load
    @browser.create_account_form_email.value = @user_name
    @browser.create_account_form_confirm_email.value = @user_name
    @browser.create_account_form_password.value = @password
    @browser.create_account_form_confirm_password.value = @password
    @browser.create_account_form_submit_button.click
    @browser.wait_for_landing_page_load

    @browser.continue_checkout_button.click
    @browser.wait_for_landing_page_load

    if @matured_product || @matured_product_svc
      @browser.handle_mature_product_screen(@params)
    end

    $tracer.trace("Enter Shipping Address Info.")
    @browser.fill_out_shipping_form(@params)
    #Uncheck weeklyadoffers from shipping screen bec it has been checked already in create account screen
    #@browser.chkoutweeklyadoffers_label.click
    if @params["billing_address_same_as_shipping"]
      @browser.same_address_checkbox.click
      @browser.continue_checkout_button.click
    end

    $tracer.trace("Handling Options")
    @browser.wait_for_landing_page_load
    @browser.enter_handling_options(@params)

    $tracer.trace("Payment Options")
    @browser.wait_for_landing_page_load
    @browser.wallet_label.value = "-- Select a Card--" if @browser.wallet_label.exists
    $tracer.trace("Enter Credit Card Info")
    @browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])

    $tracer.trace("Submitted Order")
    @browser.submit_order_button.click
    @browser.wait_for_landing_page_load

    if @params["unsubscribe"]
      sleep 10
      get_results_from_db(@user_name)
      # @unsubscribe = @profile_svc.perform_unsubscribe_to_mailing_list(@login, @session_id, 'GS_US', 'en-US', @profile_svc_version)
    end
  end


  it "Unsubscribe :: Newsletter subscribe when registering a new user through the profile app" do
    #This scenario should subscribe new user (created in profile) from the mailing list then unsubscribe via service call.
    @user_name, @password = generate_new_user_credentials

    $tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id)

    @browser.open(@start_page)
    $tracer.trace("Register user and populate profile")
    @browser.register_link.click
    @browser.create_account_form_email.should_exist
    @browser.create_account_form_email.value = @user_name
    @browser.create_account_form_password.should_exist
    @browser.create_account_form_password.value = @password
    @browser.create_account_form_confirm_password.should_exist
    @browser.create_account_form_confirm_password.value = @password
    @browser.create_account_submit_button.should_exist
    @browser.create_account_submit_button.click
    sleep 5

    @browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, @cart_id, @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
    @browser.wait_for_landing_page_load
    @browser.continue_checkout_button.click
    @browser.wait_for_landing_page_load

    if @matured_product || @matured_product_svc
      @browser.handle_mature_product_screen(@params)
    end

    $tracer.trace("Enter Shipping Address Info.")
    @browser.fill_out_shipping_form(@params)

    if @params["billing_address_same_as_shipping"]
      @browser.same_address_checkbox.click
      @browser.continue_checkout_button.click
    end

    $tracer.trace("Handling Options")
    @browser.wait_for_landing_page_load
    @browser.enter_handling_options(@params)

    $tracer.trace("Payment Options")
    @browser.wait_for_landing_page_load
    @browser.wallet_label.value = "-- Select a Card--" if @browser.wallet_label.exists
    $tracer.trace("Enter Credit Card Info")
    @browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])

    $tracer.trace("Submitted Order")
    @browser.submit_order_button.click
    @browser.wait_for_landing_page_load

    if @params["unsubscribe"]
      sleep 10
      get_results_from_db(@user_name)
      # @unsubscribe = @profile_svc.perform_unsubscribe_to_mailing_list(@login, @session_id, 'GS_US', 'en-US', @profile_svc_version)
    end
  end


  it "Unsubscribe :: Newsletter subscribe in checkout" do
    #This scenario should unsubscribe an authenticated user from the mailing list.
    $tracer.trace("Get products")
    @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id) unless @params["renew_pur"]

    $tracer.trace(" *** Clear Cart *** ")
    @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
    @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
    @cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)

    @browser.open(@start_page)
    @browser.log_in_link.click
    @browser.log_in(@login, @password)
    sleep 5

    @browser.add_products_to_cart_by_url(@product_urls, @start_page, @condition, @params, @db_result, @session_id, @cart_id, @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
    @browser.wait_for_landing_page_load
    @browser.continue_checkout_button.click
    @browser.wait_for_landing_page_load

    if @matured_product || @matured_product_svc
      @browser.handle_mature_product_screen(@params)
    end

    $tracer.trace("Enter Shipping Address Info.")
    @browser.fill_out_shipping_form(@params)
    if @params["billing_address_same_as_shipping"]
      @browser.same_address_checkbox.click
      @browser.continue_checkout_button.click
    end

    $tracer.trace("Handling Options")
    @browser.wait_for_landing_page_load
    @browser.enter_handling_options(@params)

    $tracer.trace("Payment Options")
    @browser.wait_for_landing_page_load
    @browser.wallet_label.value = "-- Select a Card--" if @browser.wallet_label.exists
    $tracer.trace("Enter Credit Card Info")
    @browser.enter_chkcredit_card_info(@params["cc_type"], @params["cc_number"], @params["cc_month"], @params["cc_year"], @params["cvv"])

    $tracer.trace("Submitted Order")
    @browser.submit_order_button.click
    sleep 5
    @browser.wait_for_landing_page_load
    @browser.ensure_header_loaded

    if @params["unsubscribe"]
      $tracer.trace("Perform Subscribe Unsubscribe to Mailing list")
      @unsubscribe = @profile_svc.perform_unsubscribe_to_mailing_list(@login, @session_id, 'GS_US', 'en-US', @profile_svc_version)
      #@subscribe = @profile_svc.perform_subscribe_to_mailing_list(@login, @session_id, 'GS_US', 'en-US', @profile_svc_version)
      get_results_from_db(@login)
    end
  end

# TODO : The methods below need to be put into a function library
  def get_results_from_db(user_name)
    sql_query = "SELECT Top 1 EmailAddr_, MemberType_, DateJoined_, DateUnsub_ FROM members_web WHERE EmailAddr_ = '#{user_name}' ORDER BY DateJoined_ ASC"
    server = "dl1gsqdb10sql1.testecom.pvt\\inst1"
    database = "LyrisTestHarness"

    $tracer.trace("#{sql_query}")
    @db = DbManager.new(server, database)
    @results_from_file = @db.exec_sql("#{sql_query}")
    puts "/////////////////////////////////////   #{@results_from_file.length}"
    list = []
    index = 0
    @results_from_file.each_with_index do |item, i|
      email = @results_from_file.at(index).EmailAddr_
      memtype = @results_from_file.at(index).MemberType_
      dtjoined = @results_from_file.at(index).DateJoined_
      dtunsub = @results_from_file.at(index).DateUnsub_
      list.push(email, memtype, dtjoined, dtunsub)
      index += 1
      puts "#{email}"
      puts "#{memtype}"
      puts "#{dtjoined}"
      puts "#{dtunsub}"

      expected_result = true
      actual_result = (memtype.eql?("normal") ? true : false)
      expected_result.should == actual_result
    end
  end


  def format_date
    year = DateTime.now.strftime("%Y")
    month = DateTime.now.strftime("%m")
    day = month = DateTime.now.strftime("%d")
    expected_date = "#{year}-#{month}-#{day}"
    $tracer.trace("Expected Date #{expected_date}")
    return expected_date
  end

end
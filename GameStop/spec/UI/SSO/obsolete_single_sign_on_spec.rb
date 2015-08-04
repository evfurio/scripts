# Validates SSO implementation is working as expected.

#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\SSO\single_sign_on_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\SSO\single_sign_on_dataset.csv --range TFS60916 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products_with_titles.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --browser chrome --prop QA_GS -e "Verify Authenticated Cookies for SSO states on GameStop.com" --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "#{ENV['QAAUTOMATION_TOOLS']}/QAAutomation/common/src/qaautomation_formatter.rb"

#Get the test ID and description from the CSV to populate the test method.
#This should only apply to data driven test cases using single test method execution.
id_csv = QACSV.new(csv_filename_parameter)
id_row = id_csv.find_row_by_name(csv_range_parameter)
$tc_id = id_row.find_value_by_name("ID")
$tc_desc = id_row.find_value_by_name("TestDescription")
if $tc_desc == ""
  $tc_desc = "Test case description was not found"
end


describe "Single Sign-On" do

  before(:all) do
    $options.default_timeout = 90_000
    $tracer.mode=:on
    $tracer.echo=:on
    @browser = GameStopBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
  end

  before(:each) do
    @browser.cookie.all.delete

    csv = QACSV.new(csv_filename_parameter)
    @row = csv.find_row_by_name(csv_range_parameter)

    #Get necessary GUID's per test method execution
    @session_id = generate_guid

    #global_functions passes the csv row object and return the parameters.
    @global_functions = GlobalServiceFunctions.new()
    @global_functions.csv = @row
    @global_functions.parameters
    @sql = @global_functions.sql_file
    @db = @global_functions.db_conn
    #Initialize Services
    @cart_svc, @cart_svc_version = @global_functions.cart_svc
    @account_svc, @account_svc_version = @global_functions.account_svc
    @catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
    @purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
    @shipping_svc, @shipping_svc_version = @global_functions.shipping_svc
    @digitalwallet_svc, @digitalwallet_svc_version = @global_functions.digitalwallet_svc
    @tax_svc, @tax_svc_version = @global_functions.tax_svc
    @profile_svc, @profile_svc_version = @global_functions.profile_svc
    @digitalcontent_svc, @digitalcontent_svc_version = @global_functions.digitalcontent_svc
    @velocity_svc, @velocity_svc_version = @global_functions.velocity_svc
    @payment_svc, @payment_svc_version = @global_functions.payment_svc
    @storesearch_svc, @storesearch_svc_version = @global_functions.storesearch_svc
    @start_page = @global_functions.prop_url.find_value_by_name("url")

    #get results from the sql file
    sql = @sql.to_s
    @results_from_file = @db.exec_sql_from_file(sql)
    #get_product_data

    #set instance variables for csv driven data elements
    #initialize_csv_params

    #get system snapshot
    @services = [@cart_svc, @account_svc, @catalog_svc, @purchase_order_svc, @shipping_svc, @digitalwallet_svc, @tax_svc, @profile_svc, @digitalcontent_svc, @velocity_svc, @payment_svc, @storesearch_svc]

    @services_version = [@cart_svc_version, @account_svc_version, @catalog_svc_version, @purchase_order_svc_version, @shipping_svc_version, @digitalwallet_svc_version, @tax_svc_version, @profile_svc_version, @digitalcontent_svc_version, @velocity_svc_version, @payment_svc_version, @storesearch_svc_version]

    #@global_functions.svc_assembly_info(@services, @services_version)

    @open_id, @user_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, account_login_parameter, account_password_parameter, @account_svc_version)
    @cart_svc.perform_empty_cart(@session_id, @user_id, 'GS_US', 'en-US', @cart_svc_version)

  end

  after(:each) do
    @browser.cookie.all.delete
  end

  after(:all) do
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do

    #Clean up your cookies!!!
    $tracer.trace("Clear All The Cookies!!!")
    @browser.delete_all_cookies_and_verify

    @browser.open(@start_page)
    @browser.log_in_link.click

    #Get all the cookies from the jar
    cookie_list = @browser.get_all_cookies
    cookie_list_length = cookie_list.length

    $tracer.trace("There are a total of #{cookie_list_length} cookies.")

    @browser.log_in(account_login_parameter, account_password_parameter)

    $tracer.trace("Verify the authenticated user cookies on GS.com")
    @browser.verify_secure_auth_user_cookies

    #Do some validitaion from the cart
    @browser.my_cart_button.click
    @browser.log_out_link.should_exist

    $tracer.trace("Verify authenticated cart cookies")
    @browser.verify_secure_auth_user_cookies

    @browser.open(@start_page)
    $tracer.trace("Verify cookies for an authenticated user on an unsecure page")
    @browser.verify_unsecure_auth_user_cookies

    #Log out!!!
    $tracer.trace("Log out")
    @browser.log_out_link.click
    @browser.log_in_link.should_exist

    @browser.my_cart_button.click
    #verify_logged_out_cookies
    @browser.log_in_link.should_exist

    $tracer.trace("Log in again!")
    @browser.log_in_link.click
    @browser.log_in(account_login_parameter, account_password_parameter)

    #This is a fun idea but doesn't seem to work.  If I close the selenium browser and start a new instance it dumps all the cookies.

    #last_page = @browser.url_data.full_data
    #$tracer.trace("THIS IS THE LAST PAGE\n #{last_page}")
    #@browser.close_all()
    #@browser2 = GameStopBrowser.new(browser_type_parameter)
    #@browser2.open(@start_page)
    #@browser2.log_out_link.should_exist
    #@browser2.verify_returned_auth_cookies
  end

end
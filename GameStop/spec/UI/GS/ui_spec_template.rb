#This is a base template to construct new UI based scripts from.  
#
# DO NOT SAVE TO THIS FILE.  Make a copy and rename it for whatever test you are constructing.

# Usage Notes
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\yourfilename.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS# --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products_with_titles.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog"  --browser ie-webspec --prop QA_GS --or


#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\ui_spec_template.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products_with_titles.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog"  --browser ie-webspec --prop QA_GS --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

# NOTE
# If you are using test id and test description to run specific tests, you can use the below to load.
# If you have several test methods this is not ideal.
#$tc_desc = $global_functions.desc
#$tc_id = $global_functions.id

describe "Describe Test" do

  before(:all) do
    @browser = WebBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 1_000
    $snapshots.setup(@browser, :all)

    #Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")

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

  end

  before(:each) do
    @browser.delete_all_cookies_and_verify
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    $tracer.trace(get_ip)
    $tracer.trace("after all")
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    #Example Script
    @browser.open(@start_page)
    @browser.log_in_link.click
    @browser.log_in(account_login_parameter, account_password_parameter)

  end

  def verify_all_headers
    #get the cookie for which header is being used
    @browser.wait_for_landing_page_load
    @browser.ensure_header_loaded
    @browser.find_a_store_link.should_exist
    @browser.gift_cards_link.should_exist
    @browser.my_account_link.should_exist
    @browser.order_history_link.should_exist
    @browser.pc_downloads_link.should_exist
    @browser.wish_list_link.should_exist
    @browser.gamestop_logo_link.should_exist
    @browser.my_cart_button.should_exist
    @browser.search_field.should_exist
    @browser.search_button.should_exist
  end

end
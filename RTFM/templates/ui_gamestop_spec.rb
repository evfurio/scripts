#This is a base template to construct new UI based scripts from.
# USAGE NOTES
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\spec\Sandbox\tutorials\templates\ui_gamestop_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Sandbox\tutorials\templates\sample_dataset.csv --range SampleTC01 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_products_with_titles.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog"  --browser ie-webspec --prop QA_GS --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "GameStop - UI Spec Template" do
  # DO NOT SAVE TO THIS FILE.  Make a copy and rename it for whatever test you are constructing.

  before(:all) do
    $browser = WebBrowser.new(browser_type_parameter)
    $browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 30_000
    $snapshots.setup($browser, :all)

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
    $browser.delete_all_cookies_and_verify
    @session_id = generate_guid
    $tracer.trace(" *** Clear Cart *** ")
    @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @login, @password, @account_svc_version)
    @cart_id = @profile_svc.perform_get_cart_id(@open_id, @session_id, 'GS_US', @profile_svc_version)
    @cart_svc.perform_empty_cart(@session_id, @cart_id, 'GS_US', 'en-US', @cart_svc_version)
  end

  after(:all) do
    $browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    #Example Script
    $browser.open(@start_page)
    $browser.log_in_link.click
    $browser.log_in(@login, @password)
    $browser.log_out_link.should_exist
  end

end
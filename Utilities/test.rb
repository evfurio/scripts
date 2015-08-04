# All Parameters in CMD
#d-con %QAAUTOMATION_SCRIPTS%\GameStop\test.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --login david@r3nrut --password T3sting1 --sql %QAAUTOMATION_SCRIPTS%\Common\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\Common\config\databases.csv --db_env "QA_Catalog" --svc_env QA_V1 --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_GS --browser chrome --or

# No --login, no --password, defaults to CSV
#d-con %QAAUTOMATION_SCRIPTS%\GameStop\test.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --svc_env QA_V1 --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv --url QA_GS --browser chrome --or

# --login and --password, no login/password in CSV "GUEST USER"
#d-con %QAAUTOMATION_SCRIPTS%\GameStop\test.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --svc_env QA_V1 --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv --url QA_GS --browser chrome --or

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

    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @shipping_svc, @shipping_svc_version = $global_functions.shipping_svc
    @digitalwallet_svc, @digitalwallet_svc_version = $global_functions.digitalwallet_svc
    @tax_svc, @tax_svc_version = $global_functions.tax_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
    @digitalcontent_svc, @digitalcontent_svc_version = $global_functions.digitalcontent_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
    @payment_svc, @payment_svc_version = $global_functions.payment_svc
    @storesearch_svc, @storesearch_svc_version = $global_functions.storesearch_svc
  end
  
  before(:each) do
    @browser.delete_all_cookies_and_verify
  end

#  NOTE
#	If you are loading test case id and test case description from your CSV dataset, use the below "it" method
#  it "#{$tc_id} #{$tc_desc}" do
  it "should test it" do
    @browser.open(@start_page)
    @browser.retry_until_found(lambda{@browser.log_in_link.exists != true})
	  $tracer.trace("Test found log in link")
  end

end
###USAGE - Calls to each service and validates that all the operations are available
### d-Con %QAAUTOMATION_SCRIPTS%\Monitoring\spec\ecom_svc_is_alive.rb --csv %QAAUTOMATION_SCRIPTS%\Monitoring\spec\monitor_dataset.csv --range QA --or
### d-con --svc .\endpoints.csv --svc_env DEV_V1 .\ecom_svc_is_alive.rb --or
### d-con --svc .\endpoints.csv --svc_env QA_V1 .\ecom_svc_is_alive.rb --or
### d-con --svc .\endpoints.csv --svc_env CERT_V1 .\ecom_svc_is_alive.rb --or
### d-con --svc .\endpoints.csv --svc_env PROD_V1 .\ecom_svc_is_alive.rb --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

describe "GameStop Ecommerce Service Is Alive Check" do

  before(:all) do
    #Get the parameters from the csv dataset
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @client = WebBrowser.new("phantomjs")

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

    #get the latest deployment and build per environment
  end

  after(:all) do
    #get the latest deployment and build per environment
    #verify it is the same as the capture from the before all
  end

    
	it "should contain operations for the Catalog service" do
    @catalog_svc.verify_operations(@catalog_svc.operations).should be_true
    $tracer.trace(@catalog_svc_version)
	end

	it "should contain operations for the Cart service" do
    @cart_svc.verify_operations(@cart_svc.operations).should be_true
    $tracer.trace(@cart_svc_version)
	end

	it "should contain operations for the Account service" do
		@account_svc.verify_operations(@account_svc.operations).should be_true
    $tracer.trace(@account_svc_version)
	end

	it "should contain operations for the Profile service" do
    @profile_svc.verify_operations(@profile_svc.operations).should be_true
    $tracer.trace(@profile_svc_version)
	end	

	it "should contain operations for the Digital Wallet service" do
    @digitalwallet_svc.verify_operations(@digitalwallet_svc.operations).should be_true
    $tracer.trace(@digitalwallet_svc_version)
	end
	
	it "should contain operations for the Digital Content service" do
    @digitalcontent_svc.verify_operations(@digitalcontent_svc.operations).should be_true
    $tracer.trace(@digitalcontent_svc_version)
	end
	
	it "should contain operations for the Shipping service" do
    @shipping_svc.verify_operations(@shipping_svc.operations).should be_true
    $tracer.trace(@shipping_svc_version)
	end

	it "should contain operations for the Velocity service" do
		@velocity_svc.verify_operations(@velocity_svc.operations).should be_true
    $tracer.trace(@velocity_svc_version)
	end
	
	it "should contain operations for the Purchase Order service" do
    @purchase_order_svc.verify_operations(@purchase_order_svc.operations).should be_true
    $tracer.trace(@purchase_order_svc_version)
	end
	
	it "should contain operations for the Tax service" do
    @tax_svc.verify_operations(@tax_svc.operations).should be_true
    $tracer.trace(@tax_svc_version)
	end

	it "should contain operations for the Payment service" do
    @payment_svc.verify_operations(@payment_svc.operations).should be_true
    $tracer.trace(@payment_svc_version)
	end

	it "should contain operations for the Store Search service" do
    @storesearch_svc.verify_operations(@storesearch_svc.operations).should be_true
    $tracer.trace(@storesearch_svc_version)
  end

end


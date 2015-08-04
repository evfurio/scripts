#USAGE NOTES
# # d-con %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\member_activations_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\profile_dataset.csv --range TFS68458 --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require 'timeout'

$tracer.mode = :on
$tracer.echo = :on
$global_functions = GlobalFunctions.new()

describe "Enroll and Activate PUR" do

  before(:all) do
    @browser = WebBrowser.new
    @params = $global_functions.csv
    @loyaltymembership_svc = $global_functions.loyaltymembership_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @membership_svc = $global_functions.membership_svc
    @digital_wallet_svc, @digital_wallet_version = $global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @payment_svc, @payment_svc_version = $global_functions.payment_svc
    @customerprofile_svc = $global_functions.customerprofile_svc
  end

  before(:each) do
    @session_id = generate_guid
    @user_id = generate_guid
  end

  after(:each) do
    @browser.return_current_url
  end

    it "should do awesomeness with the customer profile v2" do

    end

  end

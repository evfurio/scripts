# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\PaymentAndFraud\payment_service_v4_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\PaymentAndFraud\payment_service_v4_dataset.csv --range PMT01  --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on

$global_functions = GlobalFunctions.new()
$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Payment Service V4" do

  before(:all) do
		@params = $global_functions.csv
		@payment_svc, @payment_svc_version = $global_functions.payment_svc
		@account_svc, @account_svc_version = $global_functions.account_svc
		@session_id = generate_guid
  end

  it "perform_auth_and_settle" do
		@auth_settle_rsp = @payment_svc.perform_auth_and_settle(@params, @payment_svc_version)		
		$tracer.report("Service Response: #{@auth_settle_rsp.http_body.find_tag("result").content}       Expected: #{@params["result"]}")
		@auth_settle_rsp.http_body.find_tag("result").content.should == @params["result"]
	end
	
	it "perform_authorize_payment" do
		@authorize_payment_rsp = @payment_svc.perform_authorize_payment(@params, @payment_svc_version)
		$tracer.report("Service Response: #{@authorize_payment_rsp.http_body.find_tag("result").content}       Expected: #{@params["result"]}")
		@authorize_payment_rsp.http_body.find_tag("result").content.should == @params["result"]
	end
	
	it "perform_check_fraud" do
		# @open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @params["email"], "T3sting12", @account_svc_version)
		@fraud_check_rsp = @payment_svc.perform_check_fraud(@params, @payment_svc_version)
		$tracer.report("Service Response: #{@fraud_check_rsp.http_body.find_tag("fraud_check").at(0).result.content}       Expected: #{@params["result"]}")
		@fraud_check_rsp.http_body.find_tag("fraud_check").at(0).result.content.should == @params["result"]
	end
	
	it "perform_create_vendor_agreement" do
		@create_vendor_agreement_rsp = @payment_svc.perform_create_vendor_agreement(@params, @session_id, @payment_svc_version)
		$tracer.report("Service Response: #{@create_vendor_agreement_rsp.http_body.find_tag("result").content}       Expected: #{@params["result"]}")
		@create_vendor_agreement_rsp.http_body.find_tag("result").content.should == @params["result"]
	end
	
	it "perform_credit" do
		@credit_rsp = @payment_svc.perform_credit(@params, @payment_svc_version)
		$tracer.report("Service Response: #{@credit_rsp.http_body.find_tag("result").content}       Expected: #{@params["result"]}")
		@credit_rsp.http_body.find_tag("result").content.should == @params["result"]
	end
	
	it "perform_get_stored_value_balances" do
		@get_stored_value_balances_rsp = @payment_svc.perform_get_stored_value_balances(@params, @payment_svc_version)
		$tracer.report("Service Response: #{@get_stored_value_balances_rsp.http_body.find_tag("result").content}       Expected: #{@params["result"]}")
		@get_stored_value_balances_rsp.http_body.find_tag("result").content.should == @params["result"]
	end
	
	it "perform_get_vendor_agreement_details" do
		@get_vendor_agreement_details_rsp = @payment_svc.perform_get_vendor_agreement_details(@params, @payment_svc_version)
		$tracer.report("Service Response: #{@get_vendor_agreement_details_rsp.http_body.find_tag("user_status").content}       Expected: #{@params["result"]}")
		@get_vendor_agreement_details_rsp.http_body.find_tag("user_status").content.should == @params["result"]
	end

	it "perform_issue_stored_value_card" do
		@issue_stored_value_card_rsp = @payment_svc.perform_issue_stored_value_card(@params, @payment_svc_version)
		$tracer.report("Service Response: #{@issue_stored_value_card_rsp.http_body.find_tag("result").content} ")
		@issue_stored_value_card_rsp.http_body.find_tag("result").content.should_not == "Failed"
	end

	it "perform_save_payment_methods" do
		@save_payment_methods_rsp = @payment_svc.perform_save_payment_methods(@params, @payment_svc_version)
		$tracer.report("Service Response: #{@save_payment_methods_rsp.http_body.find_tag("result_code").content}       Expected: #{@params["result"]}")
		$tracer.report("Payment Token: #{@save_payment_methods_rsp.http_body.find_tag("payment_token").content}")
		@save_payment_methods_rsp.http_body.find_tag("result_code").content.should == @params["result"]
	end

	it "save_payment_methods_to_wallet" do
		@open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @params["email"], "T3sting12", @account_svc_version)
		@save_payment_methods_to_wallet_rsp = @payment_svc.perform_save_payment_methods_to_wallet(@params, @open_id, @payment_svc_version)
		$tracer.report("Service Response: #{@save_payment_methods_to_wallet_rsp.http_body.find_tag("result_code").content}       Expected: #{@params["result"]}")
		$tracer.report("Payment Token: #{@save_payment_methods_to_wallet_rsp.http_body.find_tag("payment_token").content}")
		@save_payment_methods_to_wallet_rsp.http_body.find_tag("result_code").content.should == @params["result"]
	end

	it "perform_save_tokens_to_wallet" do
		@open_id = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @params["email"], "T3sting12", @account_svc_version)
		@save_tokens_rsp = @payment_svc.perform_save_tokens_to_wallet(@params, @open_id, @payment_svc_version)
		$tracer.report("Service Response: #{@save_tokens_rsp.http_body.find_tag("result").content} ")
		@save_tokens_rsp.http_body.find_tag("result").content.should == "Success"
	end

	it "perform_transfer" do
		@perform_transfer_rsp = @payment_svc.perform_transfer(@params, @payment_svc_version)
		$tracer.report("Service Response: #{@perform_transfer_rsp.http_body.find_tag("result").content} ")
		@perform_transfer_rsp.http_body.find_tag("result").content.should_not == "Failed"
	end
		
	it "perform_validate_payment_method_tokens" do
		@validate_payment_method_tokens = @payment_svc.perform_validate_payment_method_tokens(@params, @payment_svc_version)
		$tracer.report("Service Response: #{@validate_payment_method_tokens.http_body.find_tag("result").content}       Expected: #{@params["result"]}")
		@validate_payment_method_tokens.http_body.find_tag("result").content.should == @params["result"]
	end

	it "perform_validate_vendor_agreement" do
		@create_vendor_agreement_rsp = @payment_svc.perform_create_vendor_agreement(@params, @session_id, @payment_svc_version)
		@agreement_content = @create_vendor_agreement_rsp.http_body.find_tag("agreement_content").content
		$tracer.report("Agreement Content: #{@agreement_content}")
		@payment_svc.perform_validate_vendor_agreement(@params, @agreement_content, @payment_svc_version)	
	end	

end
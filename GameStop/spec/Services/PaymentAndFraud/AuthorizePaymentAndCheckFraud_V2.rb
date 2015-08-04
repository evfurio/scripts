#############Usage Notes###############
# Run this script using the following command
#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\PaymentAndFraud\AuthorizePaymentAndCheckFraud_V2.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\PaymentAndFraud\AuthorizePaymentAndCheckFraud.csv --range TFSVISA --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA2_Paypal1 --or
# This script is used to validate cvv codes for different credit card types and to either accept or reject the order
#######################################
#v2 : David Turner

#qaautomation_dir = ENV['QAAUTOMATION_FILES']

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Should do Credit Card CVV validation" do
				
    before(:all) do
      $tracer.mode = :on
      $tracer.echo = :on
    end 

	  before(:each) do
      @session_id = generate_guid
      @client_payment_method_id = generate_guid
      @shipment_id = generate_guid
      @transaction_id = generate_guid

      csv = QACSV.new(csv_filename_parameter)
      @row = csv.find_row_by_name(csv_range_parameter)
      
      #initialize the services to be used for the test
      @global_functions = GlobalServiceFunctions.new()
      @global_functions.csv = @row
      @global_functions.parameters
      @sql = @global_functions.sql_file
      @db = @global_functions.db_conn
      @cart_svc, @cart_svc_version = @global_functions.cart_svc
      @account_svc, @account_svc_version = @global_functions.account_svc
      @purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
      @shipping_svc, @shipping_svc_version = @global_functions.shipping_svc
      @tax_svc, @tax_svc_version = @global_functions.tax_svc
      @payment_svc, @payment_svc_version = @global_functions.payment_svc

    #Example of services getting assembly version 

     # @global_functions.svc_assembly_info
      initialize_csv_params
    
    end
   	
    it "should authorize payment check fraud and CVV validation" do
		#Calling the operation "SavePaymentMethods" to save the payment and obtain payment token
		
		#########SAVE_PAYMENT_METHODS###################
	    save_payment_methods_req = @payment_svc.get_request_from_template_using_global_defaults(:save_payment_methods,PaymentServiceRequestTemplates.const_get("SAVE_PAYMENT_METHODS_WITH_CREDIT_CARD#{@payment_svc_version}"))
      save_payment_methods_data = save_payment_methods_req.find_tag("save_payment_methods_request").at(0)
      #payment_method_data = save_payment_methods_data.payment_methods.payment_method
      credit_card_payment = save_payment_methods_data.find_tag("credit_card").at(0)
      gift_card_payment = save_payment_methods_data.gift_cards.at(0)
      paypal_account = save_payment_methods_data.pay_pal_account.at(0)
      credit_card_payment.client_payment_method_id.content =  @client_payment_method_id
      credit_card_payment.credit_card.credit_card_number.content = @cc_number
      credit_card_payment.credit_card.expiration_month.content = @cc_exp_month
      credit_card_payment.credit_card.expiration_year.content = @cc_exp_year
      credit_card_payment.credit_card.name_on_card.content = "Generic Tester"
      #<!--type: CreditCardType - enumeration: [Visa,MasterCard,AmericanExpress,Discover,JCB,Diners]-->
      credit_card_payment.credit_card.at(0).type.content = @cc_type
      gift_card_payment.giftcard.remove_self
      paypal_account.remove_self
				
      #puts save_payment_methods_req.formatted_xml
		
      $tracer.trace(save_payment_methods_req.formatted_xml)
      save_payment_methods_rsp = @payment_svc.save_payment_methods(save_payment_methods_req.xml)
				
      save_payment_methods_rsp.code.should == 200

      $tracer.trace(save_payment_methods_rsp.http_body.formatted_xml)
				
      payment_token = save_payment_methods_rsp.http_body.find_tag("payment_token").at(0).content
      save_payment_methods_rsp.http_body.find_tag("result_code").content.should == "Success"
      save_payment_methods_rsp.http_body.find_tag("result_message").content.should == "success"
					
      #Calling the opearion "AuthorizePaymentAndCheckFraud"
		
      ######AUTHORIZE_PAYMENT_AND_CHECK_FRAUD######
		
      authorize_payment_and_check_fraud_req = @payment_svc.get_request_from_template_using_global_defaults("authorize_payment_and_check_fraud", PaymentServiceRequestTemplates::AUTHORIZE_PAYMENT_AND_CHECK_FRAUD)
      authorize_payment_and_check_fraud_data = authorize_payment_and_check_fraud_req.find_tag("authorization_payment_and_check_fraud_request").at(0)

      identification_data = authorize_payment_and_check_fraud_data.fraud_check_information.identification
      identification_data.browser_cookie.remove_self
      identification_data.client_ip.remove_self
      identification_data.device_fingerprint.remove_self
      identification_data.is_registered_user.remove_self
      identification_data.user_profile.email_address.content  = "test@gamestop.com"
      identification_data.user_profile.account_id.remove_self
      identification_data.user_profile.customer_id.remove_self
      identification_data.user_profile.first_name.content = "TestFirst"
      identification_data.user_profile.last_name.content = "TestLast"
      identification_data.user_profile.failed_transactions_window_begin_time.remove_self
      identification_data.user_profile.failed_transactions_window_end_time.remove_self
      identification_data.user_profile.first_purchase_date.remove_self
      identification_data.user_profile.hashed_password.remove_self
      identification_data.user_profile.last_address_changed_date.remove_self
      identification_data.user_profile.last_login_date.remove_self
      identification_data.user_profile.last_purchase_date.remove_self
      identification_data.user_profile.lifetime_purchase_amount.remove_self
      identification_data.user_profile.loyalty_number.remove_self
      identification_data.user_profile.loyalty_registration_date.remove_self
      identification_data.user_profile.middle_name.remove_self
      identification_data.user_profile.registered_date.remove_self
      identification_data.user_profile.registered_ip_address.remove_self
      identification_data.user_profile.total_number_successful_transactions.remove_self

      transaction_data = authorize_payment_and_check_fraud_data.fraud_check_information.transaction
      transaction_data.currency.content  = "USD"
      transaction_data.affiliate_code.remove_self
      transaction_data.order_status.remove_self
      transaction_data.shipments.shipment.fulfillment_channel.content  = "ShipToAddress"
      transaction_data.shipments.shipment.is_gift.content  = "true"
      transaction_data.shipments.shipment.shipment_id.content  = @shipment_id
      transaction_data.shipments.shipment.shipping_cost.content  = "2.99"
      transaction_data.shipments.shipment.shipping_email_address.content  = "Test@gamestop.com"
      transaction_data.shipments.shipment.shipping_method.content  = "value"
      transaction_data.shipments.shipment.shipping_tax.content  = "0.50"
      transaction_data.shipments.shipment.tax.content  = "0.80"
      transaction_data.shipping_amount.content = "2.99"
      transaction_data.tax_amount.content = "0.50"
      transaction_data.total_amount.content = "3.49"
      transaction_data.transaction_date.content = "2012-11-07T00:00:00.000-05:00"
      transaction_data.transaction_id.content = @transaction_id
      #authorize_payment_and_check_fraud_data.find_tag("transaction").shipments.shipment.fulfillment_channel.at(0).content = "ShipToAddress"

      payment_data = authorize_payment_and_check_fraud_data.payment
      payment_data.amount.content  = payment_amount
      payment_data.billing_address.city.content  = "irving"
      payment_data.billing_address.country_code.content  = "US"
      payment_data.billing_address.line1.content  = "625 westport pkwy"
      payment_data.billing_address.line2.content  = ""
      payment_data.billing_address.phone_number.content  = "1231231234"
      payment_data.billing_address.postal_code.content  = "76051"
      payment_data.billing_address.state.content  = "TX"
      payment_data.billing_address.first_name.content  = "testfirst"
      payment_data.billing_address.last_name.content  = "testlast"
      payment_data.csc.content  = @cvv
      payment_data.currency.content  = "USD"
      payment_data.email_address.content  = "test@gamestop.com"
      payment_data.token.content  = payment_token

      authorize_payment_and_check_fraud_data.reference_number.content  = "1234"

      #puts authorize_payment_and_check_fraud_req.formatted_xml

      $tracer.trace(authorize_payment_and_check_fraud_req.formatted_xml)
      authorize_payment_and_check_fraud_rsp = @payment_svc.authorize_payment_and_check_fraud(authorize_payment_and_check_fraud_req.xml)

		#puts authorize_payment_and_check_fraud_rsp.http_body.get_received_msg
        authorize_payment_and_check_fraud_rsp.code.should == 200
		
        $tracer.trace(authorize_payment_and_check_fraud_rsp.http_body.formatted_xml)
		
		#assert fraud check result is as expected
		authorize_payment_and_check_fraud_rsp.http_body.find_tag("result").content.should == result
		
	end

  def initialize_csv_params     
	#read the data from csv file and assign to the variables
     @cc_type = @row.find_value_by_name("CC_type")
     @cc_number = @row.find_value_by_name("CC_number")
	   @cc_exp_month = @row.find_value_by_name("CC_exp_month")
	   @cc_exp_year = @row.find_value_by_name("CC_exp_year")
	   @cvv = @row.find_value_by_name("cvv")
	   @payment_amount = @row.find_value_by_name("payment_amount")
	   @result = @row.find_value_by_name("order_status")
  end

end


#############Usage Notes###############
# Run this script using the following command
#d-con.bat %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\PaymentAndFraud\CheckFraud_InvalidCard.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\PaymentAndFraud\CheckFraud.csv --range TFSNumberNeeded --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env Dev_Accertify1 --or
# This script is used to check fraud for different credit card types and to either accept or reject the order
#######################################
#v3 : David Turner / Tim Tye

#qaautomation_dir = ENV['QAAUTOMATION_FILES']

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Should Check Fraud" do
				
    before(:all) do
      $tracer.mode = :on
      $tracer.echo = :on
    end 

	before(:each) do
	@cc_payment_method_id = generate_guid
	@svs_payment_method_id = generate_guid
	@shipment_id = generate_guid
	@transaction_id = generate_guid
	@session_id = generate_guid

	csv = QACSV.new(csv_filename_parameter)
	@row = csv.find_row_by_name(csv_range_parameter)
      
	#initialize the services to be used for the test
	@global_functions = GlobalServiceFunctions.new()
	@global_functions.csv = @row
	@global_functions.parameters
	#@sql = @global_functions.sql_file
	@db = @global_functions.db_conn
	@payment_svc, @payment_svc_version = @global_functions.payment_svc
	@catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
	
	#get results from the sql file
	#sql = @sql.to_s
	#@results_from_file = @db.exec_sql_from_file(sql)

	#Example of services getting assembly version 

	#@global_functions.svc_assembly_info
	initialize_payment_params
    
    end	
		
    it "Should Check Fraud" do	
	
		if @should_tokenize_payments == "TRUE"
		
			#Calling the operation "SavePaymentMethods" to save the payment and obtain payment token

			#########SAVE_PAYMENT_METHODS###################
			save_payment_methods_req = @payment_svc.get_request_from_template_using_global_defaults(:save_payment_methods,PaymentServiceRequestTemplates.const_get("SAVE_PAYMENT_METHODS_WITH_CREDIT_CARD#{@payment_svc_version}"))
			save_payment_methods_data = save_payment_methods_req.find_tag("save_payment_methods_request").at(0)
			#payment_method_data = save_payment_methods_data.payment_methods.payment_method
			credit_card_payment = save_payment_methods_data.find_tag("credit_card").at(0)
			gift_card_payment = save_payment_methods_data.find_tag("stored_value_card").at(0).stored_value_card
			paypal_account = save_payment_methods_data.pay_pal_account.at(0)
				
			if ! @cc_identifier.to_s.empty?
				credit_card_payment.client_payment_method_id.content =  @cc_payment_method_id
				credit_card_payment.credit_card_number.content = @cc_identifier
				credit_card_payment.expiration_month.content = @cc_exp_month
				credit_card_payment.expiration_year.content = @cc_exp_year
				credit_card_payment.name_on_card.content = "Generic Tester"
				#<!--type: CreditCardType - enumeration: [Visa,MasterCard,AmericanExpress,Discover,JCB,Diners]-->
				credit_card_payment.type.content = @cc_type
			else
				credit_card_payment.remove_self
			end
		
			if ! @svs_identifier.to_s.empty?
				gift_card_payment.client_payment_method_id.content = @svs_payment_method_id
				gift_card_payment.stored_value_card_number.content = @svs_identifier
			else
				gift_card_payment.remove_self
			end
		
			#TODO: Implement Paypal
			paypal_account.remove_self
						
			$tracer.trace(save_payment_methods_req.formatted_xml)
			save_payment_methods_rsp = @payment_svc.save_payment_methods(save_payment_methods_req.xml)
	
			save_payment_methods_rsp.code.should == 200

			$tracer.trace(save_payment_methods_rsp.http_body.formatted_xml)
		
			for p in save_payment_methods_rsp.http_body.find_tag("saved_payment_method")
			
				payment_method_id =  p.find_tag("save_payment_method_id").at(0).content
			
				if payment_method_id == @cc_payment_method_id
				
					@cc_identifier = p.find_tag("payment_token").at(0).content	
				
					$tracer.trace("######CreditCard was tokenized#########")
					$tracer.trace(@cc_identifier)
					$tracer.trace("#######################################")
				elsif payment_method_id == @svs_payment_method_id
					
					@svs_identifier = p.find_tag("payment_token").at(0).content
				
					$tracer.trace("######GiftCard was tokenized#########")
					$tracer.trace(@svs_identifier)
					$tracer.trace("#######################################")
				end
			end	
		    $tracer.trace(save_payment_methods_rsp.http_body.find_tag("result_code").content)
			$tracer.trace(save_payment_methods_rsp.http_body.find_tag("result_message").content)
			
			save_payment_methods_rsp.http_body.find_tag("result_code").content.should == "InvalidPan"			       
		end		
	end

	def initialize_payment_params     
		#read the data from csv file and assign to the variables
		@client_channel = @row.find_value_by_name("ClientChannel")
		@should_tokenize_payments = @row.find_value_by_name("ShouldTokenizePayments")
		@skus = @row.find_value_by_name("SKUS").split(",")
		@discount_code = @row.find_value_by_name("DiscountCode")
		@fulfillment_channel = @row.find_value_by_name("FulfillmentChannel")
		
		#CreditCard Params
		@cc_type = @row.find_value_by_name("CCType")
		@cc_identifier = @row.find_value_by_name("CCNumber")
		@cc_exp_month = @row.find_value_by_name("ExpMonth")
		@cc_exp_year = @row.find_value_by_name("ExpYear")
		@cvv = @row.find_value_by_name("CVV")
		@payment_amount = @row.find_value_by_name("CCAmount")
		@result = @row.find_value_by_name("Result")
		@email_id = @row.find_value_by_name("EmailId")
        @fname = @row.find_value_by_name("Fname")	
		#SVS Params
		@svs_identifier = @row.find_value_by_name("SVSNumber")
		@svs_pin = @row.find_value_by_name("SVSPin")
		@svs_amount = @row.find_value_by_name("SVSAmount")
		@svs_purchase_amount = @row.find_value_by_name("SVSPurchaseAmount")
				
		#Electronic Account Params
		
		#Address Params
		@billing_line_1 = @row.find_value_by_name("BillingLine1")
		@billing_line_2 = @row.find_value_by_name("BillingLine2")
		@billing_city = @row.find_value_by_name("BillingCity")
		@billing_state = @row.find_value_by_name("BillingState")
		@billing_zip = @row.find_value_by_name("BillingZip")
		@billing_country = @row.find_value_by_name("BillingCountry")	
		
		@shipping_line_1 = @row.find_value_by_name("ShippingLine1")
		@shipping_line_2 = @row.find_value_by_name("ShippingLine2")
		@shipping_city = @row.find_value_by_name("ShippingCity")
		@shipping_state = @row.find_value_by_name("ShippingState")
		@shipping_zip = @row.find_value_by_name("ShippingZip")
		@shipping_country = @row.find_value_by_name("ShippingCountry")
			
	end
end
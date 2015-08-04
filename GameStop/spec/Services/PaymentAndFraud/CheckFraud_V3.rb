#############Usage Notes###############
# Run this script using the following command
#d-con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\PaymentAndFraud\CheckFraud_V3.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\PaymentAndFraud\CheckFraud.csv --range TFS46800 --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --or
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
		
			save_payment_methods_rsp.http_body.find_tag("result_code").content.should == "Success"
			save_payment_methods_rsp.http_body.find_tag("result_message").content.should == "success"        
		end
	
		#Calling the operation "CheckFraud"
	  
		######CHECK_FRAUD######
		
		check_fraud_req = @payment_svc.get_request_from_template_using_global_defaults(:check_fraud, PaymentServiceRequestTemplates.const_get("CHECK_FRAUD#{@payment_svc_version}"))
		check_fraud_data = check_fraud_req.find_tag("check_fraud_request").at(0)
		check_fraud_data.client_channel.content = @client_channel	
	
		identification_data = check_fraud_data.fraud_check_information.identification
		identification_data.browser_cookie.remove_self
		identification_data.client_ip.remove_self
		identification_data.device_fingerprint.content = "Fr4uD$t3R"
		identification_data.is_registered_user.remove_self
		identification_data.user_profile.email_address.content  = @email_id	
		identification_data.user_profile.account_id.remove_self
		identification_data.user_profile.customer_id.remove_self
		identification_data.user_profile.first_name.content = @fname
		identification_data.user_profile.last_name.content = "Tester"
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

		transaction_data = check_fraud_data.fraud_check_information.transaction
		transaction_data.client_transaction_id.content = @transaction_id	 
		transaction_data.currency.content  = "USD"
		transaction_data.transaction_date.content ="2013-02-28T00:00:00.000-05:00"
		transaction_data.shipping_amount.content = "2.99"
		transaction_data.tax_amount.content = "0.50"
		transaction_data.total_amount.content = "3.49"
		transaction_data.affiliate_code.remove_self
		transaction_data.order_status.content = "Completed"
	  
		transaction_data.shipments.shipment.shipment_id.content  = @shipment_id
		transaction_data.shipments.shipment.tax.content  = "0.80"
				
		transaction_data.shipments.shipment.ship_to.first_name.content = @fname
		transaction_data.shipments.shipment.ship_to.last_name.content = "Tester"
		transaction_data.shipments.shipment.ship_to.line1.content = @shipping_line_1
		transaction_data.shipments.shipment.ship_to.line2.content = @shipping_line_2
		transaction_data.shipments.shipment.ship_to.city.content = @shipping_city
		transaction_data.shipments.shipment.ship_to.state.content = @shipping_state		
		transaction_data.shipments.shipment.ship_to.county.remove_self
		transaction_data.shipments.shipment.ship_to.postal_code.content = @shipping_zip
		transaction_data.shipments.shipment.ship_to.country_code.content = @shipping_country
		transaction_data.shipments.shipment.ship_to.phone_number.content  = "1231231234"
	
		transaction_data.shipments.shipment.shipping_email_address.content  = @email_id	
		transaction_data.shipments.shipment.shipping_cost.content  = "2.99"
		transaction_data.shipments.shipment.shipping_tax.content  = "0.50"	  
		transaction_data.shipments.shipment.is_gift.content  = "true"	  
		transaction_data.shipments.shipment.fulfillment_channel.content  = @fulfillment_channel  
		transaction_data.shipments.shipment.shipping_method.content  = "value"
		
		#Add Promo Code
		if ! @discount_code.to_s.empty?
			discount = transaction_data.find_tag("discount").at(0)
			discount.amount.content = 10
			discount.coupon_code.code.content = @discount_code
			discount.coupon_code.description.content = @discount_code
			discount.discount_level.content = "Order"
			discount.line_item_id.remove_self
		else
			transaction_data.find_tag("discounts").at(0).remove_self
		end
				
		#Set CreditCard Values
	
		if ! @cc_identifier.to_s.empty?
			transaction_data.credit_card.client_payment_method_id.content = @cc_payment_method_id
			transaction_data.credit_card.name_on_card.content = "Generic Tester"
			transaction_data.credit_card.at(0).type.content = @cc_type	
			transaction_data.credit_card.identifier.content  = @cc_identifier
			transaction_data.credit_card.expiration_month.content = @cc_exp_month
			transaction_data.credit_card.expiration_year.content = @cc_exp_year
			transaction_data.credit_card.csc.content  = @cvv
			transaction_data.credit_card.currency.content  = "USD"
			transaction_data.credit_card.amount.content  = @payment_amount 					
			transaction_data.credit_card.email_address.content  = @email_id		
			transaction_data.credit_card.billing_address.first_name.content  = @fname
			transaction_data.credit_card.billing_address.last_name.content  = "Tester"			
			transaction_data.credit_card.billing_address.line1.content  = @billing_line_1
			transaction_data.credit_card.billing_address.line2.content  = @billing_line_2
			transaction_data.credit_card.billing_address.city.content  = @billing_city			
			transaction_data.credit_card.billing_address.state.content  = @billing_state			
			transaction_data.credit_card.billing_address.county.remove_self			
			transaction_data.credit_card.billing_address.postal_code.content  = @billing_zip
			transaction_data.credit_card.billing_address.country_code.content  = @billing_country
			transaction_data.credit_card.billing_address.phone_number.content  = "1231231234"
		else
			transaction_data.credit_card.remove_self
		end
				
		if ! @svs_identifier.to_s.empty?
			gift_card = transaction_data.stored_value_cards.stored_value_payment.at(0)
			gift_card.client_payment_method_id.content = @svs_payment_method_id
			gift_card.identifier.content = @svs_identifier
			gift_card.pin.content = @svs_pin
			gift_card.currency.content = "USD"
			gift_card.amount.content = @svs_amount
			gift_card.balance.remove_self
			gift_card.billing_address.first_name.content  = @fname
			gift_card.billing_address.last_name.content  = "Tester"			
			gift_card.billing_address.line1.content  = @billing_line_1
			gift_card.billing_address.line2.content  = @billing_line_2
			gift_card.billing_address.city.content  = @billing_city			
			gift_card.billing_address.state.content  = @billing_state			
			gift_card.billing_address.county.remove_self			
			gift_card.billing_address.postal_code.content  = @billing_zip
			gift_card.billing_address.country_code.content  = @billing_country
			gift_card.billing_address.phone_number.content  = "1231231234"			
		else
			transaction_data.stored_value_cards.remove_self
		end
	  
		#TODO: Implement Paypal
		transaction_data.electronic_account_payment.remove_self
		
		### GET_PRODUCTS ###			

		get_products_req = @catalog_svc.get_request_from_template_using_global_defaults(:get_products,CatalogServiceRequestTemplates.const_get("GET_PRODUCTS"))
		get_products_request_data = get_products_req.find_tag("get_products_request").at(0)
		get_products_request_data.session_id.content = @session_id    
		
		@skus.each_with_index do |sku, i|
			get_products_request_data.skus.string.clone_as_sibling if i > 0
			get_products_request_data.skus.string.at(i).content = sku
		end
		
		$tracer.trace(get_products_req.formatted_xml)

		get_products_rsp = @catalog_svc.get_products(get_products_req.xml)

		get_products_rsp.code.should == 200

		$tracer.trace(get_products_rsp.http_body.formatted_xml)	
		
		get_products_rsp.http_body.find_tag("product").each_with_index do |sku, i|
			
			#Products
			transaction_data.find_tag("products").at(0).product.at(0).clone_as_sibling if i > 0
						
			product = transaction_data.find_tag("products").at(0).product.at(i)
			product.product_id.content = generate_guid
			product.sku.content = sku.sku.content
			product.name.content = sku.display_name.content
			#product.description.content = sku.short_description.content
			product.unit_price.content = sku.list_price.content
			
			#Add product price to total amount
			transaction_data.total_amount.content = (transaction_data.total_amount.content.to_f + sku.list_price.content.to_f).to_s
			
			#Add the giftcard amount when purchasing a giftcard.
			if ! @svs_purchase_amount.to_s.empty?
				transaction_data.total_amount.content = (transaction_data.total_amount.content.to_f + @svs_purchase_amount.to_f).to_s
			end
			
			#Switch product type from catalog service to payment gateway enum.
			case sku.product_type.content
				when "Product"
					product.product_type.content = "PhysicalProduct"
				when "Digital"
					product.product_type.content = "DigitalProduct"
				when "GiftCard"
					product.product_type.content = "PhysicalGiftCard"
				when "DigitalGiftCertificate"
					product.product_type.content = "DigitalGiftCard"
				else
					raise "#{sku.product_type.content} is not a supported ProductType for this test."
			end
			
			#LineItems
			transaction_data.find_tag("line_items").at(0).line_item.at(0).clone_as_sibling if i > 0
			
			lineitem = transaction_data.find_tag("line_items").at(0).line_item.at(i)
			lineitem.sku.content = sku.sku.content
			
			if i == 0				
				product.release_date.remove_self
				product.available_date.remove_self
				product.genres.remove_self
				product.developer_name.remove_self
				product.publisher_name.remove_self
				product.rating.remove_self
				product.properties.remove_self
			
				lineitem.description.remove_self
				lineitem.line_item_id.remove_self
				lineitem.quantity.content = "1" #remove_self
				lineitem.shipping_cost.remove_self
				lineitem.shipping_tax.remove_self
				lineitem.tax.remove_self 
				lineitem.total_amount.remove_self
				lineitem.unit_price_with_discounts.remove_self
				
			end
		end

		$tracer.trace(check_fraud_req.formatted_xml)
		check_fraud_rsp = @payment_svc.check_fraud(check_fraud_req.xml)

		#puts check_fraud_rsp.http_body.get_received_msg
		check_fraud_rsp.code.should == 200
		
		$tracer.trace(check_fraud_rsp.http_body.formatted_xml)
		
		#assert fraud check result is as expected
		check_fraud_rsp.http_body.find_tag("result").at(0).content.should == @result
		
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
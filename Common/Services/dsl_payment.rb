module GameStopPaymentServiceDSL
	
	
	def perform_auth_and_settle(params, version)
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		auth_and_settle_req = self.get_request_from_template_using_global_defaults(:auth_and_settle, PaymentServiceRequestTemplates.const_get("AUTH_AND_SETTLE#{version}"))
		auth_and_settle_req_data = auth_and_settle_req.find_tag("auth_and_settle_request").at(0)
	
		auth_and_settle_req_data.client_channel.content = params["client_channel"]
			auth_and_settle_req_data.credit_card.amount.content = params["payment_amount"]
				billing_address_data = auth_and_settle_req_data.credit_card.billing_address
				billing_address_data.city.content = params["billing_city"]
				billing_address_data.country_code.content = params["billing_country"]
				billing_address_data.county.content = params["billing_county"]
				billing_address_data.line1.content = params["billing_line1"]
				billing_address_data.line2.content = params["billing_line2"]
				billing_address_data.phone_number.content = params["billing_phone"]
				billing_address_data.postal_code.content = params["billing_zip"]
				billing_address_data.state.content = params["billing_state"]
				billing_address_data.first_name.content = params["first_name"]
				billing_address_data.last_name.content = params["last_name"]
			auth_and_settle_req_data.credit_card.csc.content = params["cvv"]
			auth_and_settle_req_data.credit_card.client_payment_method_id.content = generate_guid
			auth_and_settle_req_data.credit_card.currency.content = params["currency"]
			auth_and_settle_req_data.credit_card.email_address.content = params["email"]
			auth_and_settle_req_data.credit_card.expiration_month.content = params["cc_exp_month"]
			auth_and_settle_req_data.credit_card.expiration_year.content = params["cc_exp_year"]
			auth_and_settle_req_data.credit_card.identifier.content = params["cc_number"]
			auth_and_settle_req_data.credit_card.name_on_card.content = "#{params["first_name"]} #{params["last_name"]}"
			auth_and_settle_req_data.credit_card.type.content = params["cc_type"]
		auth_and_settle_req_data.reference_number.content = params["reference_number"]
		
		auth_and_settle_req_data.stored_value_card.remove_self
		auth_and_settle_req_data.electronic_account_payment.remove_self
	
		$tracer.trace(auth_and_settle_req.formatted_xml)
    rsp = self.auth_and_settle(auth_and_settle_req.xml)
    rsp.code.should == 200

    $tracer.trace(rsp.http_body.formatted_xml)
    return rsp
	end
	
	def perform_authorize_payment(params, version)
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		authorize_payment_req = self.get_request_from_template_using_global_defaults(:authorize_payment, PaymentServiceRequestTemplates.const_get("AUTHORIZE_PAYMENT#{version}"))
		authorize_payment_data = authorize_payment_req.find_tag("authorize_payment_request").at(0)
	
		authorize_payment_data.client_channel.content = params["client_channel"]
			authorize_payment_data.credit_card.amount.content = params["payment_amount"]
				billing_address_data = authorize_payment_data.credit_card.billing_address
				billing_address_data.city.content = params["billing_city"]
				billing_address_data.country_code.content = params["billing_country"]
				billing_address_data.county.content = params["billing_county"]
				billing_address_data.line1.content = params["billing_line1"]
				billing_address_data.line2.content = params["billing_line2"]
				billing_address_data.phone_number.content = params["billing_phone"]
				billing_address_data.postal_code.content = params["billing_zip"]
				billing_address_data.state.content = params["billing_state"]
				billing_address_data.first_name.content = params["first_name"]
				billing_address_data.last_name.content = params["last_name"]
			authorize_payment_data.credit_card.csc.content = params["cvv"]
			authorize_payment_data.credit_card.client_payment_method_id.content = generate_guid
			authorize_payment_data.credit_card.currency.content = params["currency"]
			authorize_payment_data.credit_card.email_address.content = params["email"]
			authorize_payment_data.credit_card.expiration_month.content = params["cc_exp_month"]
			authorize_payment_data.credit_card.expiration_year.content = params["cc_exp_year"]
			authorize_payment_data.credit_card.financing_code.remove_self
			authorize_payment_data.credit_card.identifier.content = params["cc_number"]
			authorize_payment_data.credit_card.name_on_card.content = "#{params["first_name"]} #{params["last_name"]}"
			authorize_payment_data.credit_card.type.content = params["cc_type"]
		authorize_payment_data.message_id.content = generate_guid
		authorize_payment_data.reference_number.content = params["reference_number"]
		
		authorize_payment_data.stored_value_card.remove_self
		authorize_payment_data.electronic_account_payment.remove_self
	
		$tracer.trace(authorize_payment_req.formatted_xml)
    rsp = self.authorize_payment(authorize_payment_req.xml)
    rsp.code.should == 200

    $tracer.trace(rsp.http_body.formatted_xml)
    return rsp
	end
	
	# def perform_cancel(version)
	
	def perform_check_fraud(params, version)
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		svc_req = self.get_request_from_template_using_global_defaults(:check_fraud, PaymentServiceRequestTemplates.const_get("CHECK_FRAUD#{version}"))
		svc_req_data = svc_req.find_tag("check_fraud_request").at(0)
	
		svc_req_data.client_channel.content = "GS_US"
		fraud_check = svc_req_data.fraud_check_information
		fraud_check.session_id.content = "d76d8310-d9a4-4918-a303-3532cb605394"
		identification = fraud_check.identification
		transaction = fraud_check.transaction
		
		identification.browser_cookie.remove_self
		identification.client_ip.content = "192.168.1.1"
		identification.device_fingerprint.content = "Fr4uD$t3R"
		identification.is_registered_user.content = false
		identification.physical_location.city.content = params["billing_city"]
		identification.physical_location.country_code.content = params["billing_country"]
		identification.physical_location.county.content = nil
		identification.physical_location.line1.content = params["billing_line1"]
		identification.physical_location.line2.content = nil
		identification.physical_location.phone_number.content = params["billing_phone"]
		identification.physical_location.postal_code.content = params["billing_zip"]
		identification.physical_location.state.content = params["billing_state"]
		
		identification.user_profile.account_id.content = "https://loginqa.testecom.pvt/ID/1vP_otfMkES8Go6YCxZRvA"
		identification.user_profile.customer_id.content = "0d1bc807-ced8-470d-9fa0-6020db02f369"
		identification.user_profile.email_address.content = "hanifkhan@gamestop.com"
		identification.user_profile.failed_transactions_window_begin_time.content = "0001-01-01T00:00:00"
    identification.user_profile.failed_transactions_window_end_time.content = "0001-01-01T00:00:00"
    identification.user_profile.first_purchase_date.content = "2013-03-20T09:32:35"
    identification.user_profile.last_address_changed_date.content = "2014-11-24T15:25:35"
    identification.user_profile.last_login_date.content = "2014-11-24T15:25:35"
    identification.user_profile.last_purchase_date.content = "2014-11-24T15:25:35"
    identification.user_profile.lifetime_purchase_amount.content = "0"
    identification.user_profile.loyalty_registration_date.content = "0001-01-01T00:00:00"
    identification.user_profile.registered_date.content = "0001-01-01T00:00:00"
		identification.user_profile.first_name.remove_self
		identification.user_profile.hashed_password.remove_self
		identification.user_profile.last_name.remove_self
		identification.user_profile.loyalty_number.remove_self
		identification.user_profile.middle_name.remove_self
		identification.user_profile.registered_ip_address.remove_self
		identification.user_profile.total_number_successful_transactions.content = "0"
		identification.user_profile.properties.name_value_property.name.content = "hanifkhan@gamestop.com"
		identification.user_profile.properties.name_value_property.value.content = nil
		
      default_billing = identification.user_profile.default_billing_address
      default_billing.city.content = params["billing_city"]
      default_billing.country_code.content = params["billing_country"]
      default_billing.county.content = nil
      default_billing.line1.content = params["billing_line1"]
      default_billing.line2.content = nil
      default_billing.phone_number.content = params["billing_phone"]
      default_billing.postal_code.content = params["billing_zip"]
      default_billing.state.content = params["billing_state"]
      default_billing.first_name.content = params["first_name"]
      default_billing.last_name.content = params["last_name"]

			failed_transaction = identification.user_profile.failed_transactions.transaction.at(0)
			failed_transaction.affiliate_code.content = nil
			failed_transaction.client_transaction_id.content = "4141216074545111"
			failed_transaction.currency.content = "USD"
			failed_transaction.order_status.content = "draft"
			failed_transaction.shipping_address_changed.content = true
			failed_transaction.shipping_amount.content = "0"
			failed_transaction.tax_amount.content = "5.77"
			failed_transaction.total_amount.content = "75.7600"
			failed_transaction.transaction_date.remove_self

			failed_transaction_billing = failed_transaction.billing_address
				failed_transaction_billing.city.content = params["billing_city"]
				failed_transaction_billing.country_code.content = params["billing_country"]
				failed_transaction_billing.county.content = nil
				failed_transaction_billing.line1.content = params["billing_line1"]
				failed_transaction_billing.line2.content = nil
				failed_transaction_billing.phone_number.content = params["billing_phone"]
				failed_transaction_billing.postal_code.content = params["billing_zip"]
				failed_transaction_billing.state.content = params["billing_state"]
				failed_transaction_billing.first_name.content = params["first_name"]
				failed_transaction_billing.last_name.content = params["last_name"]
				
			failed_transaction_cc = failed_transaction.credit_card
				failed_transaction_cc.amount.content = "75.76"
				failed_transaction_cc.client_payment_method_id.content = "68d1efeb-5a50-4081-b814-675a1e6286b0"
				failed_transaction_cc.currency.content = "USD"
				failed_transaction_cc.email_address.content = "hanifkhan@gamestop.com"
				failed_transaction_cc.expiration_month.content = "5"
				failed_transaction_cc.expiration_year.content = "2020"
				failed_transaction_cc.name_on_card.content = "Accept"
				failed_transaction_cc.processor_transaction_id.content = nil
				failed_transaction_cc.type.content = "Visa"
				failed_transaction_cc.csc.remove_self
				failed_transaction_cc.identifier.remove_self
			
			failed_transaction_discount = failed_transaction.discounts.discount.at(0)
				failed_transaction_discount.amount.content = "3.00"
				failed_transaction_discount.coupon_code.code.content = "123456"
				failed_transaction_discount.coupon_code.description.content = "FREE SHIPPING"
				failed_transaction_discount.discount_level.content = "Order"
				failed_transaction_discount.line_item_id.remove_self
				
			failed_transaction_product = failed_transaction.products.product.at(0)
				failed_transaction_product.available_date.content = "2014-09-23T00:00:00"
				failed_transaction_product.description.remove_self
				failed_transaction_product.developer_name.content = "Electronic Arts"
				failed_transaction_product.genres.genre.at(0).id.content = "36311b82-bb5a-49e4-a774-91a6cdd740f5"
				failed_transaction_product.genres.genre.at(0).name.remove_self
				failed_transaction_product.name.content = "Soccer"
				failed_transaction_product.product_id.content = "ed4f083d-c91d-46c7-8fb3-e0ec7403ff2a"
				failed_transaction_product.product_type.remove_self
				failed_transaction_product.properties.name_value_property.at(0).name.content = "FIFA 15 Ultimate Team Edition"
				failed_transaction_product.properties.name_value_property.at(0).value.content = nil
				failed_transaction_product.publisher_name.content = "Electronic Arts"
				failed_transaction_product.rating.content = "5"
				failed_transaction_product.release_date.content = "2014-09-23T00:00:00"
				failed_transaction_product.sku.remove_self
				failed_transaction_product.unit_price.remove_self
				
			failed_transaction_property = failed_transaction.properties.name_value_property.at(0)
				failed_transaction_property.name.content = nil
				failed_transaction_property.value.content = nil
			
			failed_transaction_shipment = failed_transaction.shipments.shipment.at(0)
				failed_transaction_shipment.fulfillment_channel.content = "ShipToAddress"
				failed_transaction_shipment.is_gift.content = false
				failed_transaction_shipment.message.content = nil
				failed_transaction_shipment.shipment_id.content = "3e4d8c3f-99c8-4c58-a866-3366376e0f5a"
				failed_transaction_shipment.shipping_method.content = "Value"
				failed_transaction_shipment.shipping_tax.content = "0"
				failed_transaction_shipment.shipping_cost.remove_self
				failed_transaction_shipment.shipping_email_address.remove_self
				failed_transaction_shipment.tax.remove_self
				failed_transaction_line_item = failed_transaction_shipment.line_items.line_item.at(0)
				failed_transaction_line_item.description.content = "FIFA 15 Ultimate Team Edition"
				failed_transaction_line_item.line_item_id.content = "376e16e5-2879-47c0-af3d-f3d21c9bf140"
				failed_transaction_line_item.quantity.content = "1"
				failed_transaction_line_item.shipping_cost.content = "0"
				failed_transaction_line_item.shipping_tax.content = "0"
				failed_transaction_line_item.sku.remove_self
				failed_transaction_line_item.unit_price_with_discounts.remove_self
				failed_transaction_line_item.tax.content = "0"
				failed_transaction_line_item.total_amount.content = "0"
				
				failed_transaction_ship_to = failed_transaction_shipment.ship_to
				failed_transaction_ship_to.city.content = params["shipping_city"]
				failed_transaction_ship_to.country_code.content = params["shipping_country"]
				failed_transaction_ship_to.county.content = nil
				failed_transaction_ship_to.line1.content = params["shipping_line1"]
				failed_transaction_ship_to.line2.content = nil
				failed_transaction_ship_to.phone_number.content = params["shipping_phone"]
				failed_transaction_ship_to.postal_code.content = params["shipping_zip"]
				failed_transaction_ship_to.state.content = params["shipping_state"]
				failed_transaction_ship_to.first_name.content = params["first_name"]
				failed_transaction_ship_to.last_name.content = params["last_name"]
			
			failed_transaction.electronic_account_payment.remove_self
			failed_transaction.nu_data_response.remove_self
			failed_transaction.stored_value_cards.remove_self

		transaction.affiliate_code.content = nil
		transaction.client_transaction_id.content = "4141216074545111"
		transaction.currency.content = "USD"
		transaction.order_status.content = nil
		transaction.billing_address.city.content = ""
		transaction.billing_address.city.content = params["billing_city"]
		transaction.billing_address.country_code.content = params["billing_country"]
		transaction.billing_address.county.content = nil
		transaction.billing_address.line1.content = params["billing_line1"]
		transaction.billing_address.line2.content = nil
		transaction.billing_address.phone_number.content = params["billing_phone"]
		transaction.billing_address.postal_code.content = params["billing_zip"]
		transaction.billing_address.state.content = params["billing_state"]
		transaction.billing_address.first_name.content = params["first_name"]
		transaction.billing_address.last_name.content = params["last_name"]
		transaction.shipping_address_changed.remove_self
		transaction.shipping_amount.remove_self
		transaction.tax_amount.remove_self
		transaction.total_amount.remove_self
		transaction.transaction_date.remove_self
		
		transaction.credit_card.remove_self
		transaction.discounts.remove_self
		transaction.electronic_account_payment.remove_self
		transaction.nu_data_response.remove_self
		transaction.products.remove_self
		transaction.properties.remove_self
		transaction.shipments.remove_self
		transaction.stored_value_cards.remove_self
		
		$tracer.trace(svc_req.formatted_xml)
    svc_rsp = self.check_fraud(svc_req.xml)
    svc_rsp.code.should == 200

    $tracer.trace(svc_rsp.http_body.formatted_xml)
    return svc_rsp
	end
	
	# def perform_close_order(version)
	
	def perform_create_vendor_agreement(params, session_id, version)
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		svc_req = self.get_request_from_template_using_global_defaults(:create_vendor_agreement, PaymentServiceRequestTemplates.const_get("CREATE_VENDOR_AGREEMENT#{version}"))
		svc_req_data = svc_req.find_tag("create_vendor_agreement_request").at(0)
	
		svc_req_data.client_channel.content = params["client_channel"]
		svc_req_data.identifier.content = nil
		svc_req_data.recurring.content = false
		svc_req_data.reference_number.content = params["reference_number"]	
		svc_req_data.session_id.content = session_id
		
		electronic_acct = svc_req_data.electronic_account
		electronic_acct.account_email_address.content = params["email"]
		electronic_acct.account_type.content = params["payment_type"]
		electronic_acct.amount.content = params["payment_amount"]
		electronic_acct.currency.content = params["currency"]
		electronic_acct.shipping_amount.content = "0"
		electronic_acct.shipping_discount.content = "0"
		electronic_acct.tax_amount.content = "0"
			
			brand = electronic_acct.brand_settings
			brand.brand_color.content = "Red"
			brand.failure_url.content = "qa.gamestop.com"
			brand.logo_url.content = "qa.gamestop.com"
			brand.return_url.content = "qa.gamestop.com"
			brand.success_url.content = "qa.gamestop.com"
		
			order = electronic_acct.order_items.order_item.at(0)
			order.product_description.content = "Fifa"
			order.product_name.content = "Fifa"
			order.product_price.content = "9.99"
			order.product_quantity.content = "1"
	
			ship = electronic_acct.shipping_address
			ship.city.content = params["shipping_city"]
			ship.country_code.content = params["shipping_country"]
			ship.county.content = params["shipping_county"]
			ship.line1.content = params["shipping_line1"]
			ship.line2.content = params["shipping_line2"]
			ship.phone_number.content = params["shipping_phone"]
			ship.postal_code.content = params["shipping_zip"]
			ship.state.content = params["shipping_state"]
			ship.first_name.content = params["first_name"]
			ship.last_name.content = params["last_name"]
		
		$tracer.trace(svc_req.formatted_xml)
    svc_rsp = self.create_vendor_agreement(svc_req.xml)
    svc_rsp.code.should == 200

    $tracer.trace(svc_rsp.http_body.formatted_xml)
    return svc_rsp
	end
	
	def perform_credit(params, version)
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		credit_req = self.get_request_from_template_using_global_defaults(:credit, PaymentServiceRequestTemplates.const_get("CREDIT#{version}"))
		credit_data = credit_req.find_tag("credit_request").at(0)
	
		credit_data.client_channel.content = params["client_channel"]
		credit_data.amount.content = params["payment_amount"]
		credit_data.currency.content = params["currency"]
		credit_data.reference_number.content = params["reference_number"]
		
		cc_info = credit_data.credit_card
		cc_info.client_payment_method_id.content = generate_guid
		cc_info.credit_card_number.content = params["cc_number"]
		cc_info.expiration_month.content = params["cc_exp_month"]
		cc_info.expiration_year.content = params["cc_exp_year"]
		cc_info.type.content = params["cc_type"]
	
		$tracer.trace(credit_req.formatted_xml)
    rsp = self.credit(credit_req.xml)
    rsp.code.should == 200

    $tracer.trace(rsp.http_body.formatted_xml)
    return rsp
		
	end
	
	# def perform_get_enhanced_stored_value_balances
	
	def perform_get_stored_value_balances(params, version)
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		get_stored_value_balances_req = self.get_request_from_template_using_global_defaults(:get_stored_value_balances, PaymentServiceRequestTemplates.const_get("GET_STORED_VALUE_BALANCES#{version}"))
		get_stored_value_balances_data = get_stored_value_balances_req.find_tag("get_stored_value_balance_request").at(0)

		get_stored_value_balances_data.client_channel.content = params["client_channel"]
    get_stored_value_balances_data.stored_value_card.check_balance_gift_card.pin.content = params["svs_pin"]
    get_stored_value_balances_data.stored_value_card.check_balance_gift_card.stored_value_card_number.content = params["svs_number"]
		
		$tracer.trace(get_stored_value_balances_req.formatted_xml)
    get_stored_value_balances_rsp = self.get_stored_value_balances(get_stored_value_balances_req.xml)
    get_stored_value_balances_rsp.code.should == 200

    $tracer.trace(get_stored_value_balances_rsp.http_body.formatted_xml)
    return get_stored_value_balances_rsp
	end
	
	# def perform_get_stored_value_balances_by_loyalty_card_number(pin, card_number, version)
	
	def perform_get_vendor_agreement_details(params, version) 
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		svc_req = self.get_request_from_template_using_global_defaults(:get_vendor_agreement_details, PaymentServiceRequestTemplates.const_get("GET_VENDOR_AGREEMENT_DETAILS#{version}"))
		svc_req_data = svc_req.find_tag("get_vendor_agreement_details_request").at(0)

		svc_req_data.client_channel.content = params["client_channel"]
		svc_req_data.reference_number.content = params["reference_number"]
		
		$tracer.trace(svc_req.formatted_xml)
    svc_rsp = self.get_vendor_agreement_details(svc_req.xml)
    svc_rsp.code.should == 200

    $tracer.trace(svc_rsp.http_body.formatted_xml)
    return svc_rsp
	end
	
	# def perform_initialize_payment
	
	def perform_issue_stored_value_card(params, version) 
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		svc_req = self.get_request_from_template_using_global_defaults(:issue_stored_value_card, PaymentServiceRequestTemplates.const_get("ISSUE_STORED_VALUE_CARD#{version}"))
		svc_req_data = svc_req.find_tag("issue_stored_value_card_request").at(0)

		svc_req_data.client_channel.content = params["client_channel"]
		svc_req_data.currency.content = params["currency"]
		svc_req_data.identifier.content = params["svs_number"]
		svc_req_data.issue_amount.content = params["payment_amount"]
		svc_req_data.reference_number.content = params["reference_number"]
		
		$tracer.trace(svc_req.formatted_xml)
    svc_rsp = self.issue_stored_value_card(svc_req.xml)
    svc_rsp.code.should == 200

    $tracer.trace(svc_rsp.http_body.formatted_xml)
    return svc_rsp
	end
	
	# perform_refund
	
	# perform_reverse_authorizations
	
	def perform_save_payment_methods(params, version) 
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		svc_req = self.get_request_from_template_using_global_defaults(:save_payment_methods, PaymentServiceRequestTemplates.const_get("SAVE_PAYMENT_METHODS#{version}"))
		svc_req_data = svc_req.find_tag("save_payment_methods_request").at(0)

		svc_req_data.client_channel.content = params["client_channel"]
		svc_req_data.credit_card.client_payment_method_id.content = generate_guid  #"123456"
		svc_req_data.credit_card.credit_card_number.content = params["cc_number"]
		svc_req_data.credit_card.expiration_month.content = params["cc_exp_month"]
		svc_req_data.credit_card.expiration_year.content = params["cc_exp_year"]
		svc_req_data.credit_card.name_on_card.content = "#{params["first_name"]} #{params["last_name"]}"
		svc_req_data.credit_card.type.content = params["cc_type"]
		
		svc_req_data.electronic_account.remove_self
		svc_req_data.stored_value_card.remove_self
		
		$tracer.trace(svc_req.formatted_xml)
    svc_rsp = self.save_payment_methods(svc_req.xml)
    svc_rsp.code.should == 200

    $tracer.trace(svc_rsp.http_body.formatted_xml)
    return svc_rsp
	end
	
	def perform_save_payment_methods_to_wallet(params, open_id, version) 
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		svc_req = self.get_request_from_template_using_global_defaults(:save_payment_methods_to_wallet, PaymentServiceRequestTemplates.const_get("SAVE_PAYMENT_METHODS_TO_WALLET#{version}"))
		svc_req_data = svc_req.find_tag("save_payment_methods_to_wallet_request").at(0)

		svc_req_data.client_channel.content = params["client_channel"]
		svc_req_data.credit_card.client_payment_method_id.content = generate_guid  #"0a1b82cd-3565-4ae0-a6ce-5abe8f7650e3"
		svc_req_data.credit_card.credit_card_number.content = params["cc_number"]
		svc_req_data.credit_card.expiration_month.content = params["cc_exp_month"]
		svc_req_data.credit_card.expiration_year.content = params["cc_exp_year"]
		svc_req_data.credit_card.name_on_card.content = "#{params["first_name"]} #{params["last_name"]}"
		svc_req_data.credit_card.type.content = params["cc_type"]
		
		svc_req_data.open_id_claimed_identifier.content = open_id
		
		
		svc_req_data.electronic_account.remove_self
		svc_req_data.stored_value_card.remove_self
		
		$tracer.trace(svc_req.formatted_xml)
    svc_rsp = self.save_payment_methods_to_wallet(svc_req.xml)
    svc_rsp.code.should == 200

    $tracer.trace(svc_rsp.http_body.formatted_xml)
    return svc_rsp
	end
	
	def perform_save_tokens_to_wallet(params, open_id, version) 
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		svc_req = self.get_request_from_template_using_global_defaults(:save_tokens_to_wallet, PaymentServiceRequestTemplates.const_get("SAVE_TOKENS_TO_WALLET#{version}"))
		svc_req_data = svc_req.find_tag("save_tokens_to_wallet_request").at(0)

		svc_req_data.client_channel.content = params["client_channel"]		
		svc_req_data.open_id_claimed_identifier.content = open_id   #"https://loginqa.gamestop.com/ID/mtAFdShJhUqb06Y60G9vbg"
		svc_req_data.tokens.string.at(0).content = "K4QA4YWLYNV20019"
		
		$tracer.trace(svc_req.formatted_xml)
    svc_rsp = self.save_tokens_to_wallet(svc_req.xml)
    svc_rsp.code.should == 200

    $tracer.trace(svc_rsp.http_body.formatted_xml)
    return svc_rsp
	end
	
	# perform_settle
	
	def perform_transfer(params, version)
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		svc_req = self.get_request_from_template_using_global_defaults(:transfer, PaymentServiceRequestTemplates.const_get("TRANSFER#{version}"))
		svc_req_data = svc_req.find_tag("transfer_request").at(0)

		svc_req_data.client_channel.content = params["client_channel"]	
		svc_req_data.order_number.content = params["reference_number"]
		svc_req_data.recipients.string.at(0).content = params["svs_number"]
		svc_req_data.refund_amount.content = params["payment_amount"]
		svc_req_data.store_number.content = "480"
		svc_req_data.transferrer_card_number.content = "6006493711999901298"
		
		$tracer.trace(svc_req.formatted_xml)
    svc_rsp = self.transfer(svc_req.xml)
    svc_rsp.code.should == 200

    $tracer.trace(svc_rsp.http_body.formatted_xml)
    return svc_rsp
	end
	
	def perform_validate_payment_method_tokens(params, version)
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		svc_req = self.get_request_from_template_using_global_defaults(:validate_payment_method_tokens, PaymentServiceRequestTemplates.const_get("VALIDATE_PAYMENT_METHOD_TOKENS#{version}"))
		svc_req_data = svc_req.find_tag("validate_payment_method_tokens_request").at(0)

		svc_req_data.client_channel.content = params["client_channel"]	
		svc_req_data.payment_method_tokens.string.at(0).content = "K4QA4YWLYNV20019"
				
		$tracer.trace(svc_req.formatted_xml)
    svc_rsp = self.validate_payment_method_tokens(svc_req.xml)
    svc_rsp.code.should == 200

    $tracer.trace(svc_rsp.http_body.formatted_xml)
    return svc_rsp
	end
		
	def perform_validate_vendor_agreement(params, agreement_content, version)
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")
		svc_req = self.get_request_from_template_using_global_defaults(:validate_vendor_agreement, PaymentServiceRequestTemplates.const_get("VALIDATE_VENDOR_AGREEMENT#{version}"))
		svc_req_data = svc_req.find_tag("validate_vendor_agreement_request").at(0)

		svc_req_data.client_channel.content = params["client_channel"]			
		svc_req_data.agreement_content.content = agreement_content    #"202|50538|0FJadLJ37sBDc05Ijoh0|PP"
		svc_req_data.reference_number.content = params["reference_number"]
				
		$tracer.trace(svc_req.formatted_xml)
    svc_rsp = self.validate_vendor_agreement(svc_req.xml)
    svc_rsp.code.should == 200

    $tracer.trace(svc_rsp.http_body.formatted_xml)
    return svc_rsp
	end

  def verify_operations(payment_svc)
    $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace(payment_svc)
    begin
      payment_svc.include?(:authorize_payment) == true
      payment_svc.include?(:authorize_payment_and_check_fraud) == true
      payment_svc.include?(:get_stored_value_balances) == true
      payment_svc.include?(:reverse_authorizations) == true
      payment_svc.include?(:save_payment_methods) == true
      payment_svc.include?(:save_payment_methods_to_wallet) == true
      payment_svc.include?(:save_tokens_to_wallet) == true
      payment_svc.include?(:validate_payment_method_tokens) == true
    rescue
      false
    end
  end

	def hash_the_data(cc, params, date_time, transaction_uuid, reference_number)
		$tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
		$tracer.report("Should #{__method__}.")

		#INFO: access key expires in 2017
		signed_field_names = 'access_key,profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency,payment_method,bill_to_forename,bill_to_surname,bill_to_email,bill_to_address_line1,bill_to_address_city,bill_to_address_state,bill_to_address_country,bill_to_address_postal_code'.split(',')
		signed_field_name_string = "access_key profile_id transaction_uuid signed_field_names unsigned_field_names signed_date_time locale transaction_type reference_number amount currency payment_method bill_to_forename bill_to_surname bill_to_email bill_to_address_line1 bill_to_address_city bill_to_address_state bill_to_address_country bill_to_address_postal_code"
		field_values = "61852f33714536a98fe3835ac163c7ee,1979EB50-F7F8-495B-841B-F1C8AC7568B4,#{transaction_uuid},#{signed_field_name_string},card_type card_number card_expiry_date card_cvn,#{date_time},en,create_payment_token,#{reference_number},0.00,usd,card,#{params['BillFirstName']},#{params['BillLastName']},#{params['BillEmail']},#{params['BillLine1']},#{params['BillCity']},#{params['BillState']},#{params['BillCountryCode']},#{params['BillPostalCode']}".split(',')
		field_values.map { |i| i.include?(',') ? (i.split /,/) : i }
		data_to_sign = Hash[signed_field_names.zip(field_values.map { |i| i.include?(',') ? (i.split /,/) : i })]
		data_to_sign['signed_field_names'] = data_to_sign['signed_field_names'].to_s.gsub(' ',',')
		data_to_sign['unsigned_field_names'] = data_to_sign['unsigned_field_names'].to_s.gsub(' ',',')
		return data_to_sign
	end

	def call_for_signature(data, transaction_uuid, reference_number, login)
		config = RestAgentConfig.new
		config.set_option("Content-Type", 'application/json')
		config.set_option("Accept", '*/*')

		uri = "https://qa.gamestop.com/Checkout/en/CyberSource/Sign"

		get_signature = <<eos
{"paramsArray": [{"Key":"access_key","Value":"#{data['access_key']}"},
        {"Key":"profile_id","Value":"#{data['profile_id']}"},
        {"Key":"transaction_uuid","Value":"#{transaction_uuid}"},
        {"Key":"signed_field_names","Value":"#{data['signed_field_names']}"},
        {"Key":"unsigned_field_names","Value":"#{data['unsigned_field_names']}"},
        {"Key":"signed_date_time","Value":""},
        {"Key":"locale","Value":"en"},
        {"Key":"transaction_type","Value":"create_payment_token"},
        {"Key":"reference_number","Value":"#{reference_number}"},
        {"Key":"amount","Value":"0.00"},
        {"Key":"currency","Value":"usd"},
        {"Key":"payment_method","Value":"card"},
        {"Key":"bill_to_forename","Value":"#{data['bill_to_forename']}"},
        {"Key":"bill_to_surname","Value":"#{data['bill_to_surname']}"},
        {"Key":"bill_to_email","Value":"#{login}"},
        {"Key":"bill_to_address_line1","Value":"#{data['bill_to_address_line1']}"},
        {"Key":"bill_to_address_city","Value":"#{data['bill_to_address_city']}"},
        {"Key":"bill_to_address_state","Value":"#{data['bill_to_address_state']}"},
        {"Key":"bill_to_address_country","Value":"#{data['bill_to_address_country']}"},
        {"Key":"bill_to_address_postal_code","Value":"#{data['bill_to_address_postal_code']}"}]}
eos

		$tracer.trace(get_signature.class)
		client = RestAgent.new(config)
		wc = JsonMessage.new(get_signature, HttpBody::REQUEST)
		$tracer.trace(wc.formatted_json)
		resp = client.post(uri, wc.json)
		puts resp.json
		signature = resp.http_body.signature.content
		date_time = resp.http_body.request_date_time.content

		return signature, date_time
	end

	def call_to_silent_pay(transaction_uuid, reference_number, login, signature, date_time, data, cc, cc_enum, total)
		uri_pay = "https://testsecureacceptance.cybersource.com/silent/pay"
		client2 = Mechanize.new{|a|
			# Uncomment the line below if you need to trace the call through Fiddler, do not keep this proxy setting enabled when pushing to the lab
			#a.set_proxy('127.0.0.1',8888,nil,nil)
			a.verify_mode = OpenSSL::SSL::VERIFY_NONE
		}
		$tracer.report("CC Expiration Month and Year #{cc[:expmnth].to_s.rjust(2,'0')}-#{cc[:expyr]}")
		resp2 = client2.post(uri_pay, {"access_key" => "#{data['access_key']}",
																	 "profile_id" => "#{data['profile_id']}",
																	 "transaction_uuid" => "#{transaction_uuid}",
																	 "signed_field_names" => "#{data['signed_field_names']}",
																	 "unsigned_field_names" => "#{data['unsigned_field_names']}",
																	 "signed_date_time" => "#{date_time}",
																	 "locale" => "en",
																	 "transaction_type" => "create_payment_token",
																	 "reference_number" => "#{reference_number}",
																	 "amount" => "0.00",
																	 "currency" => "usd",
																	 "payment_method" => "card",
																	 "bill_to_forename" => "#{data['bill_to_forename']}",
																	 "bill_to_surname" => "#{data['bill_to_surname']}",
																	 "bill_to_email" => "#{login}",
																	 "bill_to_address_line1" => "#{data['bill_to_address_line1']}",
																	 "bill_to_address_city" => "#{data['bill_to_address_city']}",
																	 "bill_to_address_state" => "#{data['bill_to_address_state']}",
																	 "bill_to_address_country" => "#{data['bill_to_address_country']}",
																	 "bill_to_address_postal_code" => "#{data['bill_to_address_postal_code']}",
																	 "signature" => "#{signature}",
																	 "card_type" => "#{cc_enum}",
																	 "card_number" => cc[:cnum],
																	 "card_expiry_date" => "#{cc[:expmnth].to_s.rjust(2,'0')}-#{cc[:expyr]}",
																	 "card_cvn" => "#{cc[:cvv]}",
																	 "response_signature" => "",
																	 "CyberSourceDecision" => "",
																	 "Message" => "",
																	 "PaymentToken" => "",
																	 "CardType" => "",
																	 "CardExpiration" => "",
																	 "AuthResponse" => "",
																	 "ReasonCode" => "",
																	 "AuthCode" => "",
																	 "InvalidData" => ""})

	end

	def build_query_string(parameters, enc = 'UTF-8')
		parameters.map { |k,v|
			[CGI.escape(k), CGI.escape(v)].join("=") if k
		}.compact.join('&').to_s.strip
	end

	def credit_card_type_mapping(cc)
		card_names = "Visa,MasterCard,AmericanExpress,Discover,JCB,Diners,PURCC".split(',')
		card_types = "001,002,003,004,005,006,007".split(',')
		card_types.map { |i| i.include?(',') ? (i.split /,/) : i }
		cc_id = Hash[card_names.zip(card_types.map { |i| i.include?(',') ? (i.split /,/) : i.gsub(' ','') })]
		ctype = cc[:ctype].to_s.gsub(' ','')
		ctype.slice(0, 1).capitalize + ctype.slice(1..-1)
		cc_val = cc_id[ctype].to_s if cc_id.has_key?(ctype)
		return cc_val
	end

end
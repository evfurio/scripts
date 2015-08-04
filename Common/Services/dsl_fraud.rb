module GameStopFraudServiceDSL

  def perform_check_fraud(session_id, owner_id, payment_svc, params, get_purchase_order_rsp, payment_svc_version)
    $tracer.trace("GameStopFraudServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    @transaction_id = generate_guid
    check_fraud_req = @payment_svc.get_request_from_template_using_global_defaults(:check_fraud, PaymentServiceRequestTemplates.const_get("CHECK_FRAUD#{@payment_svc_version}"))
    check_fraud_data = check_fraud_req.find_tag("check_fraud_request").at(0)
    check_fraud_data.client_channel.content = @client_channel

    identification_data = check_fraud_data.fraud_check_information.identification
    identification_data.browser_cookie.remove_self
    identification_data.client_ip.remove_self
    identification_data.device_fingerprint.content = "Fr4uD$t3R"
    identification_data.is_registered_user.remove_self
    identification_data.user_profile.email_address.content = @params['BillEmail']
    identification_data.user_profile.account_id.remove_self
    identification_data.user_profile.customer_id.remove_self
    identification_data.user_profile.first_name.content = @params['BillFirstName']
    identification_data.user_profile.last_name.content = @params['BillLastName']
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
    transaction_data.currency.content  = @params['Currency']
    transaction_data.transaction_date.content = Time.now.strftime("%Y-%m-%dT%H:%M:%S.000-06:00")
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
  end

end
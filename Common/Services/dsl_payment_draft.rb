def perform_save_payment_methods_with_credit_card(cc_number, cc_exp_month, cc_exp_year, name_on_card, cc_type, version)
  $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
  $tracer.report("Should #{__method__}.")
  save_payment_methods_req = self.get_request_from_template_using_global_defaults(:save_payment_methods, PaymentServiceRequestTemplates.const_get("SAVE_PAYMENT_METHODS_WITH_CREDIT_CARD#{@payment_svc_version}"))
  save_payment_methods_data = save_payment_methods_req.find_tag("save_payment_methods_request").at(0)

  credit_card_payment = save_payment_methods_data.find_tag("credit_card").at(0)
  credit_card_payment.client_payment_method_id.content = generate_guid
  credit_card_payment.credit_card_number.content = cc_number
  credit_card_payment.expiration_month.content = cc_exp_month
  credit_card_payment.expiration_year.content = cc_exp_year
  credit_card_payment.name_on_card.content = name_on_card
  # <!--type: CreditCardType - enumeration: [Visa,MasterCard,AmericanExpress,Discover,JCB,Diners]-->
  credit_card_payment.type.content = cc_type
end

def perform_save_payment_methods_with_gift_card(svs_number, version)
  $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
  $tracer.report("Should #{__method__}.")
  save_payment_methods_req = self.get_request_from_template_using_global_defaults(:save_payment_methods, PaymentServiceRequestTemplates.const_get("SAVE_PAYMENT_METHODS_WITH_GIFT_CARD#{@payment_svc_version}"))
  save_payment_methods_data = save_payment_methods_req.find_tag("save_payment_methods_request").at(0)

  gift_card_payment = save_payment_methods_data.find_tag("stored_value_card").at(0).stored_value_card
  gift_card_payment.client_payment_method_id.content = generate_guid
  gift_card_payment.stored_value_card_number.content = svs_number
end

def perform_save_payment_methods_with_electronic_account(acc_type, agreement_number, version)
  $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
  $tracer.report("Should #{__method__}.")
  save_payment_methods_req = self.get_request_from_template_using_global_defaults(:save_payment_methods, PaymentServiceRequestTemplates.const_get("SAVE_PAYMENT_METHODS_WITH_ELECTRONIC_ACCOUNT#{@payment_svc_version}"))
  save_payment_methods_data = save_payment_methods_req.find_tag("save_payment_methods_request").at(0)

  Papal_payment = save_payment_methods_data.find_tag("ELECTRONIC_ACCOUNT").at(0).ELECTRONIC_ACCOUNT
  Papal_payment.account_type.content = acc_type
  Papal_payment.agreement_number.content = agreement_number
  Papal_payment.client_payment_method_id.content = generate_guid
end

def perform_authorize_payment()
  $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
  $tracer.report("Should #{__method__}.")
  authorize_payment_req = self.get_request_from_template_using_global_defaults(:authorize_payment, PaymentServiceRequestTemplates.const_get("AUTHORIZE_PAYMENT#{version}"))
  authorize_payment_data = authorize_payment_req.find_tag("authorize_payment_request").at (0)
  authorize_payment_data.client_channel.content = client_channel
  authorize_payment_data.reference_number.remove_self

  authorize_payment_data.credit_card.amount.remove_self
  authorize_payment_data.credit_card.csc.remove_self
  authorize_payment_data.credit_card.client_payment_method_id.remove_self
  authorize_payment_data.credit_card.currency.remove_self
  authorize_payment_data.credit_card.expiration_month.remove_self
  authorize_payment_data.credit_card.expiration_year.remove_self
  authorize_payment_data.credit_card.identifier.remove_self
  authorize_payment_data.credit_card.name_on_card.remove_self
  authorize_payment_data.credit_card.at(0).type.remove_self

  authorize_payment_data.credit_card.billing_address.first_name.remove_self
  authorize_payment_data.credit_card.billing_address.last_name.remove_self
  authorize_payment_data.credit_card.billing_address.line1.remove_self
  authorize_payment_data.credit_card.billing_address.line2.remove_self
  authorize_payment_data.credit_card.billing_address.city.remove_self
  authorize_payment_data.credit_card.billing_address.state.remove_self
  authorize_payment_data.credit_card.billing_address.county.remove_self
  authorize_payment_data.credit_card.billing_address.postal_code.remove_self
  authorize_payment_data.credit_card.billing_address.country_code.remove_self
  authorize_payment_data.credit_card.billing_address.phone_number.remove_self

  authorize_payment_data.electronic_account_payment.account_email_address.remove_self
  authorize_payment_data.electronic_account_payment.account_type.content = "Paypal"
  authorize_payment_data.electronic_account_payment.amount.remove_self
  authorize_payment_data.electronic_account_payment.client_payment_method_id.remove_self
  authorize_payment_data.electronic_account_payment.currency.remove_self
  authorize_payment_data.electronic_account_payment.identifier.remove_self

  authorize_payment_data.stored_value_card.amount.remove_self
  authorize_payment_data.stored_value_card.client_payment_method_id.remove_self
  authorize_payment_data.stored_value_card.currency.remove_self
  authorize_payment_data.stored_value_card.identifier.remove_self
  authorize_payment_data.stored_value_card.pin.remove_self

end


def perform_check_fraud()
  $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
  $tracer.report("Should #{__method__}.")
  check_fraud_req = self.get_request_from_template_using_global_defaults(:check_fraud, PaymentServiceRequestTemplates.const_get("CHECK_FRAUD#{@payment_svc_version}"))
  check_fraud_data = check_fraud_req.find_tag("check_fraud_request").at(0)
  check_fraud_data.client_channel.content = client_channel

  identification_data = check_fraud_data.fraud_check_information.identification
  identification_data.browser_cookie.remove_self
  identification_data.client_ip.remove_self
  identification_data.device_fingerprint.remove_self
  identification_data.is_registered_user.remove_self

  identification_data.user_profile.account_id.remove_self
  identification_data.user_profile.customer_id.remove_self
  identification_data.user_profile.email_address.remove_self
  identification_data.user_profile.first_name.remove_self
  identification_data.user_profile.last_name.content.remove_self
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


  identification_data.user_profile.default_billing_address.first_name.remove_self
  identification_data.user_profile.default_billing_address.last_name.remove_self
  identification_data.user_profile.default_billing_address.line1.remove_self
  identification_data.user_profile.default_billing_address.line2.remove_self
  identification_data.user_profile.default_billing_address.city.remove_self
  identification_data.user_profile.default_billing_address.state.remove_self
  identification_data.user_profile.default_billing_address.county.remove_self
  identification_data.user_profile.default_billing_address.postal_code.remove_self
  identification_data.user_profile.default_billing_address.country_code.remove_self
  identification_data.user_profile.default_billing_address.phone_number.remove_self


  transaction_data = check_fraud_data.fraud_check_information.transaction
  transaction_data.affiliate_code.remove_self
  transaction_data.client_transaction_id.remove_self
  transaction_data.currency.remove_self
  transaction_data.order_status.remove_self
  transaction_data.shippin_address_changed.remove_self
  transaction_data.shipping_amount.remove_self
  transaction_data.tax_amount.remove_self
  transaction_data.total_amount.remove_self
  transaction_data.transaction_date.content ="2013-02-28T00:00:00.000-05:00"


  transaction_data.shipments.shipment.shipment_id.remove_self
  transaction_data.shipments.shipment.tax.remove_self
  transaction_data.shipments.shipment.shipping_email_address.remove_self
  transaction_data.shipments.shipment.shipping_cost.remove_self
  transaction_data.shipments.shipment.shipping_tax.remove_self
  transaction_data.shipments.shipment.is_gift.remove_self
  transaction_data.shipments.shipment.fulfillment_channel.remove_self
  transaction_data.shipments.shipment.shipping_method.remove_self
  transaction_data.shipments.shipment.message.remove_self

  transaction_data.shipments.shipment.ship_to.first_name.remove_self
  transaction_data.shipments.shipment.ship_to.last_name.remove_self
  transaction_data.shipments.shipment.ship_to.line1.remove_self
  transaction_data.shipments.shipment.ship_to.line2.remove_self
  transaction_data.shipments.shipment.ship_to.city.remove_self
  transaction_data.shipments.shipment.ship_to.state.remove_self
  transaction_data.shipments.shipment.ship_to.county.remove_self
  transaction_data.shipments.shipment.ship_to.postal_code.remove_self
  transaction_data.shipments.shipment.ship_to.country_code.remove_self
  transaction_data.shipments.shipment.ship_to.phone_number.remove_self

  discount = transaction_data.find_tag("discount").at(0)
  discount.amount.remove_self
  discount.coupon_code.code.remove_self
  discount.coupon_code.description.remove_self
  discount.discount_level.remove_self
  discount.line_item_id.remove_self


  transaction_data.products.product.available_date.remove_self
  transaction_data.products.product.description.remove_self
  transaction_data.products.product.developer_name.remove_self
  transaction_data.products.product.name.remove_self
  transaction_data.products.product.product_id.remove_self
  transaction_data.products.product.product_type.remove_self
  transaction_data.products.product.publisher_name.remove_self
  transaction_data.products.product.rating.remove_self
  transaction_data.products.product.release_date.remove_self
  transaction_data.products.product.sku.remove_self
  transaction_data.products.product.unit_price.remove_self
  transaction_data.products.product.genres.genre.id
  transaction_data.products.product.genres.genre.name
  transaction_data.products.product.properties.name_value_property.name
  transaction_data.products.product.properties.name_value_property.value

  transaction_data.properties.name_value_property.name
  transaction_data.properties.name_value_property.value


  #Set CreditCard Values

  transaction_data.credit_card.amount.remove_self
  transaction_data.credit_card.csc.remove_self
  transaction_data.credit_card.client_payment_method_id.remove_self
  transaction_data.credit_card.currency.remove_self
  transaction_data.credit_card.email_address.remove_self
  transaction_data.credit_card.expiration_month.remove_self
  transaction_data.credit_card.expiration_year.remove_self
  transaction_data.credit_card.identifier.remove_self
  transaction_data.credit_card.name_on_card.remove_self
  transaction_data.credit_card.processor_transaction_id.remove_self
  transaction_data.credit_card.at(0).type.remove_self

  transaction_data.credit_card.billing_address.first_name.remove_self
  transaction_data.credit_card.billing_address.last_name.remove_self
  transaction_data.credit_card.billing_address.line1.remove_self
  transaction_data.credit_card.billing_address.line2.remove_self
  transaction_data.credit_card.billing_address.city.remove_self
  transaction_data.credit_card.billing_address.state.remove_self
  transaction_data.credit_card.billing_address.county.remove_self
  transaction_data.credit_card.billing_address.postal_code.remove_self
  transaction_data.credit_card.billing_address.country_code.remove_self
  transaction_data.credit_card.billing_address.phone_number.remove_self

  #gift card values

  gift_card = transaction_data.stored_value_cards.stored_value_payment.at(0)
  gift_card.amount.remove_self
  gift_card.balance.remove_self
  gift_card.client_payment_method_id.remove_self
  gift_card.currency.remove_self
  gift_card.identifier.remove_self
  gift_card.pin.remove_self


  gift_card.billing_address.first_name.remove_self
  gift_card.billing_address.last_name.remove_self
  gift_card.billing_address.line1.remove_self
  gift_card.billing_address.line2.remove_self
  gift_card.billing_address.city.remove_self
  gift_card.billing_address.state.remove_self
  gift_card.billing_address.county.remove_self
  gift_card.billing_address.postal_code.remove_self
  gift_card.billing_address.country_code.remove_self
  gift_card.billing_address.phone_number.remove_self


  #paypal values

  paypal = transaction_data.ElectronicAccountPayment.at(0)
  paypal.account_email_address.remove_self
  paypal.account_status.remove_self
  paypal.account_type.content = "Paypal"
  paypal.amount.remove_self
  paypal.client_payment_method_id.remove_self
  paypal.currency.remove_self
  paypal.identifier.remove_self

  paypal.billing_address.first_name.remove_self
  paypal.billing_address.last_name.remove_self
  paypal.billing_address.line1.remove_self
  paypal.billing_address.line2.remove_self
  paypal.billing_address.city.remove_self
  paypal.billing_address.state.remove_self
  paypal.billing_address.county.remove_self
  paypal.billing_address.postal_code.remove_self
  paypal.billing_address.country_code.remove_self
  paypal.billing_address.phone_number.remove_self

end


def perform_create_vendor_agreement()
  $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
  $tracer.report("Should #{__method__}.")
  create_vendor_agreement_req = self.get_request_from_template_using_global_defaults(:create_vendor_agreement, PaymentServiceRequestTemplates.const_get("CREATE_VENDOR_AGREEMENT#{@payment_svc_version}"))
  create_vendor_agreement_data = create_vendor_agreement_req.find_tag("create_vendor_agreement_request").at(0)
  create_vendor_agreement_data.client_channel.content = client_channel
  create_vendor_agreement_data.identifier.remove_self
  create_vendor_agreement_data.recurring.content = "False"
  create_vendor_agreement_data.reference_number.remove_self
  create_vendor_agreement_data.session_id.content = generate_guid


  create_vendor_agreement_data.electronic_account.account_email_address
  create_vendor_agreement_data.electronic_account.account_type.content = "Paypal"
  create_vendor_agreement_data.electronic_account.amount.remove_self
  create_vendor_agreement_data.electronic_account.currency.remove_self
  create_vendor_agreement_data.electronic_account.shipping_amount.remove_self
  create_vendor_agreement_data.electronic_account.tax_amount.remove_self

  brand_settings = create_vendor_agreement_data.electronic_account.brand_settings
  brand_settings.branch_color.remove_self
  brand_settings.failure_url.remove_self
  brand_settings.logo_url.remove_self
  brand_settings.return_url.remove_self
  brand_settings.success_url.remove_self

  order_item = create_vendor_agreement_data.electronic_account.order_items.order_item
  order_item.product_description.remove_self
  order_item.product_name.remove_self
  order_item.product_price.remove_self
  order_item.product_quantity.remove_self
  order_item.sku.remove_self

  create_vendor_agreement_data.electronic_account.shipping_address.first_name.remove_self
  create_vendor_agreement_data.electronic_account.shipping_address.last_name.remove_self
  create_vendor_agreement_data.electronic_account.shipping_address.line1.remove_self
  create_vendor_agreement_data.electronic_account.shipping_address.line2.remove_self
  create_vendor_agreement_data.electronic_account.shipping_address.city.remove_self
  create_vendor_agreement_data.electronic_account.shipping_address.state.remove_self
  create_vendor_agreement_data.electronic_account.shipping_address.county.remove_self
  create_vendor_agreement_data.electronic_account.shipping_address.postal_code.remove_self
  create_vendor_agreement_data.electronic_account.shipping_address.country_code.remove_self
  create_vendor_agreement_data.electronic_account.shipping_address.phone_number.remove_self


end

def perform_validate_vendor_agreement()
  $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
  $tracer.report("Should #{__method__}.")
  validate_vendor_agreement_req = self.get_request_from_template_using_global_defaults(:validate_vendor_agreement, PaymentServiceRequestTemplates.const_get("VALIDATE_VENDOR_AGREEMENT#{@payment_svc_version}"))
  validate_vendor_agreement_data = validate_vendor_agreement_req.find_tag("validate_vendor_agreement_request").at(0)
  validate_vendor_agreement_data.client_channel.content = client_channel
  validate_vendor_agreement_data.agreement_content.remove_self
  validate_vendor_agreement_data.reference_number.remove_self

end


def perform_initialize_payment()
  $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
  $tracer.report("Should #{__method__}.")
  initialize_payment_req = self.get_request_from_template_using_global_defaults(:initialize_payment, PaymentServiceRequestTemplates.const_get("INITIALIZE_PAYMENT#{@payment_svc_version}"))
  initialize_payment_data = initialize_payment_req.find_tag("create_vendor_agreement_request").at(0)
  initialize_payment_data.client_channel.content = client_channel
  initialize_payment_data.reference_number.remove_self

  initialize_payment_data.electronic_account.account_email_address
  initialize_payment_data.electronic_account.account_type.content = "Paypal"
  initialize_payment_data.electronic_account.amount.remove_self
  initialize_payment_data.electronic_account.currency.remove_self
  initialize_payment_data.client_payment_method_id.remove_self
  initialize_payment_data.identifier.remove_self

  initialize_payment_data.shipping_address.first_name.remove_self
  initialize_payment_data.shipping_address.last_name.remove_self
  initialize_payment_data.shipping_address.line1.remove_self
  initialize_payment_data.shipping_address.line2.remove_self
  initialize_payment_data.shipping_address.city.remove_self
  initialize_payment_data.shipping_address.state.remove_self
  initialize_payment_data.shipping_address.county.remove_self
  initialize_payment_data.shipping_address.postal_code.remove_self
  initialize_payment_data.shipping_address.country_code.remove_self
  initialize_payment_data.shipping_address.phone_number.remove_self

end

def perform_get_vendor_agreement_details()
  $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
  $tracer.report("Should #{__method__}.")
  get_vendor_agreement_details_req = self.get_request_from_template_using_global_defaults(:get_vendor_agreement_details, PaymentServiceRequestTemplates.const_get("GET_VENDOR_AGREEMENT_DETAILS#{@payment_svc_version}"))
  get_vendor_agreement_details_data = get_vendor_agreement_details_req.find_tag("get_vendor_agreement_details_request").at(0)
  get_vendor_agreement_details_data.reference_number.remove_self

end

def perform_validate_payment_method_tokens()
  $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
  $tracer.report("Should #{__method__}.")
  validate_payment_method_tokens_req = self.get_request_from_template_using_global_defaults(:validate_payment_method_tokens, PaymentServiceRequestTemplates.const_get("VALIDATE_PAYMENT_METHOD_TOKENS#{@payment_svc_version}"))
  validate_payment_method_tokens_data = validate_payment_method_tokens_req.find_tag("validate_payment_method_tokens_request").at(0)
  validate_payment_method_tokens_data.client_channel.content = client_channel
  validate_payment_method_tokens_data.payment_method_tokens.string.remove_self

end

def perform_auth_and_settle()
  $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
  $tracer.report("Should #{__method__}.")
  auth_and_settle_req = self.get_request_from_template_using_global_defaults(:auth_and_settle, PaymentServiceRequestTemplates.const_get("AUTH_AND_SETTLE#{@payment_svc_version}"))
  auth_and_settle_data = auth_and_settle_req.find_tag("auth_and_settle_request").at(0)
  auth_and_settle_data.client_channel.content = client_channel
  auth_and_settle_data.reference_number.remove_self

  auth_and_settle_data.credit_card.amount.remove_self
  auth_and_settle_data.credit_card.csc.remove_self
  auth_and_settle_data.credit_card.client_payment_method_id.remove_self
  auth_and_settle_data.credit_card.currency.remove_self
  auth_and_settle_data.credit_card.expiration_month.remove_self
  auth_and_settle_data.credit_card.expiration_year.remove_self
  auth_and_settle_data.credit_card.identifier.remove_self
  auth_and_settle_data.credit_card.name_on_card.remove_self
  auth_and_settle_data.credit_card.at(0).type.remove_self

  auth_and_settle_data.credit_card.billing_address.first_name.remove_self
  auth_and_settle_data.credit_card.billing_address.last_name.remove_self
  auth_and_settle_data.credit_card.billing_address.line1.remove_self
  auth_and_settle_data.credit_card.billing_address.line2.remove_self
  auth_and_settle_data.credit_card.billing_address.city.remove_self
  auth_and_settle_data.credit_card.billing_address.state.remove_self
  auth_and_settle_data.credit_card.billing_address.county.remove_self
  auth_and_settle_data.credit_card.billing_address.postal_code.remove_self
  auth_and_settle_data.credit_card.billing_address.country_code.remove_self
  auth_and_settle_data.credit_card.billing_address.phone_number.remove_self

  auth_and_settle_data.electronic_account_payment.account_email_address.remove_self
  auth_and_settle_data.electronic_account_payment.account_type.content = "Paypal"
  auth_and_settle_data.electronic_account_payment.amount.remove_self
  auth_and_settle_data.electronic_account_payment.client_payment_method_id.remove_self
  auth_and_settle_data.electronic_account_payment.currency.remove_self
  auth_and_settle_data.electronic_account_payment.identifier.remove_self

  auth_and_settle_data.gift_card.amount.remove_self
  auth_and_settle_data.gift_card.client_payment_method_id.remove_self
  auth_and_settle_data.gift_card.currency.remove_self
  auth_and_settle_data.gift_card.identifier.remove_self
  auth_and_settle_data.gift_card.pin.remove_self

end	
module GameStopDigitalWalletServiceDSL

  def perform_get_wallets(verzion, open_id)
    $tracer.trace("GameStopDigitalWalletServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    digital_wallet_req = self.get_request_from_template_using_global_defaults(:get_digital_wallets, DigitalWalletServiceRequestTemplates.const_get("GET_DIGITAL_WALLETS#{verzion}"))
    get_digital_wallets_request_data = digital_wallet_req.find_tag("get_digital_wallets_request").at(0)
    get_digital_wallets_request_data.open_id_claimed_identifiers.string.at(0).content = open_id
    $tracer.trace(digital_wallet_req.formatted_xml)
    return self.get_digital_wallets(digital_wallet_req.xml)
  end

  def verify_operations(digitalwallet_svc)
    $tracer.trace("GameStopDigitalWalletServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace(digitalwallet_svc)
    digitalwallet_svc.include?(:delete_digital_wallet_payment_methods) == true
    digitalwallet_svc.include?(:get_digital_wallets) == true
    return true
  end

end
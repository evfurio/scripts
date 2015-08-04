require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "GameStop SOAP Digital Wallet Services Tests" do

    before(:all) do

        $tracer.mode = :on
        $tracer.echo = :on

        WebSpec.default_timeout 30000
        @account_svc = AccountService.new("http://qa.services.gamestop.com/Ecom/Customers/Account/v1/AccountService.svc?wsdl")

        # This is needed due to a bug (or non-supported feature) where the wsdl containing the actions are not where the wsdl address location is defined
        # We must use the wsdl that contains the Action, but use the endpoint specified. To do this, instantiate a soap agent config, then assign the
        # endpoint, which in this case is secure (https).
        payment_svc_config = SoapAgentConfig.new
        payment_svc_config.set_end_point("https://qa.services.gamestop.com/Ecom/PaymentAndFraud/Payment/v1/PaymentService.svc")
        @payment_svc = PaymentService.new("http://qa.services.gamestop.com/Ecom/PaymentAndFraud/Payment/v1/PaymentService.svc?wsdl=wsdl1", payment_svc_config)

        digital_wallet_svc_config = SoapAgentConfig.new
        digital_wallet_svc_config.set_end_point("https://qa.services.gamestop.com/Ecom/DigitalWallet/v1/DigitalWalletService.svc")
        @digital_wallet_svc = DigitalWalletService.new("http://qa.services.gamestop.com/Ecom/DigitalWallet/v1/DigitalWalletService.svc?wsdl=wsdl1", digital_wallet_svc_config)

    end

    it "should verify save payment methods to wallet response is correct" do

        def auto_generate_username(t = nil)
            t ||= Time.now
            return "test" + t.strftime("%Y%m%d_%H%M%S") + "@gamestop.com"
        end

        session_id = generate_guid
        client_payment_method_id = generate_guid
        password = "T3sting123"
        username = auto_generate_username
        payment_type = "pay:CreditCard"
        credit_card_number = "4716081467305766"
        expiration_month = "12"
        expiration_year = "2020"
        name_on_card = "Test QA"
        card_type = "Visa"

        ###############
        ### ACCOUNT ###
        ###############

        ### REGISTER ###		

        # converting the template into dot notaiton
        register_account_req = @account_svc.get_request_from_template_using_global_defaults("register_account")		

        register_account_req.find_tag("session_id").at(0).content = session_id

        req_input = register_account_req.find_tag("register_account_request").at(0)
        req_input.password.content = password
        req_input.user_id.content = nil
        req_input.username.content = username
        # req_input.username.content = auto_generate_username

        # will dump the entire request into the trace file
        $tracer.trace(register_account_req.formatted_xml)

        # convert dot notation back to XML & calling the request
        register_account_rsp = @account_svc.register_account(register_account_req.xml)

        # will verify HTTP status code of 200
        register_account_rsp.code.should == 200

        # output the response into the trace file
        $tracer.trace(register_account_rsp.http_body.formatted_xml)

        register_result = register_account_rsp.http_body.find_tag("register_account_result")

        register_result.register_account_status.content.should == "Successful"

        # Save User ID
        user_id = register_result.authenticator_user_id.content

        ### AUTHORIZE ###

        # converting the template into dot notaiton
        authorize_req = @account_svc.get_request_from_template_using_global_defaults("authorize")

        authorize_req.find_tag("session_id").at(0).content = session_id

        req_input = authorize_req.find_tag("authorize_request").at(0)
        req_input.password.content = password
        req_input.username.content = username

        # will dump the entire request into the trace file
        $tracer.trace(authorize_req.formatted_xml)

        # convert dot notation back to XML & calling the request
        authorize_rsp = @account_svc.authorize(authorize_req.xml)

        # will verify HTTP status code of 200
        authorize_rsp.code.should == 200

        # output the response into the trace file
        $tracer.trace(authorize_rsp.http_body.formatted_xml)

        auth_result = authorize_rsp.http_body.find_tag("authorization_result")

        auth_result.status.content.should == "Authorized"

        # save off the token for later use
        anonymous_token_id = auth_result.token.content

        auth_result.authenticator_user_id.content.should == user_id

        ###############
        ### PAYMENT ###
        ###############

        ### SAVE_PAYMENT_METHODS_TO_WALLET ###

        save_payment_req = @payment_svc.get_request_from_template_using_global_defaults("save_payment_methods_to_wallet")


        save_payment_input = save_payment_req.find_tag("save_payment_methods_to_wallet_request").at(0)
        save_payment_input.open_id_claimed_identifier.content = user_id

        payment_method_input = save_payment_req.find_tag("payment_method").at(0)
        payment_method_input.client_payment_method_id.content = client_payment_method_id
        payment_method_input.credit_card_number.content = credit_card_number
        payment_method_input.expiration_month.content = expiration_month
        payment_method_input.expiration_year.content = expiration_year
        payment_method_input.name_on_card.content = name_on_card
        payment_method_input.type.content = card_type

        # will dump the entire request into the trace file
        $tracer.trace(save_payment_req.formatted_xml)

        #$tracer.trace(save_payment_req.get_template)

        # convert dot notation back to XML & calling the request
        save_payment_rsp = @payment_svc.save_payment_methods_to_wallet(save_payment_req.xml)

        # will verify HTTP status code of 200
        save_payment_rsp.code.should == 200

        # output the response into the trace file
        $tracer.trace(save_payment_rsp.http_body.formatted_xml)

        save_payment_result = save_payment_rsp.http_body.find_tag("saved_wallet_payment_method")
        save_payment_result.result_code.content.should == "Success"

        save_payment_result.save_payment_method_id.content.should == client_payment_method_id

        #####################
        ### DIGITALWALLET ###
        #####################

        ### GET_DIGITAL_WALLETS ###

        get_digital_wallets_req = @digital_wallet_svc.get_request_from_template_using_global_defaults("get_digital_wallets")

        get_digital_wallets_input = get_digital_wallets_req.find_tag("get_digital_wallets_request").at(0)
        get_digital_wallets_input.open_id_claimed_identifiers.string.content = user_id

        # will dump the entire request into the trace file
        $tracer.trace(get_digital_wallets_req.formatted_xml)

        # convert dot notation back to XML & calling the request
        get_digital_wallets_rsp = @digital_wallet_svc.get_digital_wallets(get_digital_wallets_req.xml)

        # will verify HTTP status code of 200
        get_digital_wallets_rsp.code.should == 200

        # output the response into the trace file
        $tracer.trace(get_digital_wallets_rsp.http_body.formatted_xml)

        save_payment_result = get_digital_wallets_rsp.http_body.find_tag("get_digital_wallet_reply")

        payment_method_list = get_digital_wallets_rsp.http_body.find_tag("payment_method")

        payment_method_list.at(0).p_an_last_four.content.should == "5766"
        payment_method_list.at(0).token.content.strip.length.should == 16
        payment_method_list.at(0).token.content.should == "MOH47CY5DV985766"
        payment_method_list.at(0).expiration_month.content.should == expiration_month
        payment_method_list.at(0).expiration_year.content.should == expiration_year
        payment_method_list.at(0).name_on_card.content.should == name_on_card
        payment_method_list.at(0).type.content.should == card_type

        payment_method_token = payment_method_list.at(0).token.content

        save_payment_result.open_id_claimed_identifier.content.upcase.should == user_id.upcase
        save_payment_result.result.content.should == "Success"


        ### DELETE_DIGITAL_WALLET_PAYMENT_METHODS ###

        delete_digital_wallet_payment_methods_req = @digital_wallet_svc.get_request_from_template_using_global_defaults("delete_digital_wallet_payment_methods")

        delete_digital_wallet_payment_methods_input = delete_digital_wallet_payment_methods_req.find_tag("delete_digital_wallet_payment_methods_request").at(0)
        delete_digital_wallet_payment_methods_input.open_id_claimed_identifier.content = user_id
        delete_digital_wallet_payment_methods_input.payment_method_tokens.string.content = payment_method_token

        # will dump the entire request into the trace file
        $tracer.trace(delete_digital_wallet_payment_methods_req.formatted_xml)

        # convert dot notation back to XML & calling the request
        delete_digital_wallet_payment_methods_rsp = @digital_wallet_svc.delete_digital_wallet_payment_methods(delete_digital_wallet_payment_methods_req.xml)

        # will verify HTTP status code of 200
        delete_digital_wallet_payment_methods_rsp.code.should == 200

        # output the response into the trace file
        $tracer.trace(delete_digital_wallet_payment_methods_rsp.http_body.formatted_xml)	

        delete_payment_method_result = delete_digital_wallet_payment_methods_rsp.http_body.find_tag("delete_payment_method_reply")		
        delete_payment_method_result.result.content.should == "Success"
        delete_payment_method_result.token.content.should == payment_method_token

    end

end	

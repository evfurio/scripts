##USAGE NOTES:
# d-Con %QAAUTOMATION_SCRIPTS%\RTFM\advanced\cybersource_silent_pay.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range TFS44309 --or --no_rdb
# Cybersource API documentation: http://apps.cybersource.com/library/documentation/dev_guides/Secure_Acceptance_SOP/html/wwhelp/wwhimpl/js/html/wwhelp.htm#href=app_SOPfields.html#1076223


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

describe "Cybersource Silent Pay Chain" do

  before(:all) do
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    #@login = 'tstr2@gs.com'
    @password = $global_functions.password
    @common_functions = $global_functions.common_function_link

    @transaction_uuid = generate_guid
    @reference_number = generate_guid
  end

  #document all this crap so i don't forget how it works and can reference others to it in case it breaks

  it "TFS00000 should create a payment token for checkout or digital wallet" do
    cc = @common_functions.generate_credit_card("generate")

    #move credit_card_type_mapping to payment dsl
    cc_enum = credit_card_type_mapping(cc)

    #move hash data function to payment dsl
    data = hash_the_data(@login, cc, @params, date_time = nil)

    #move call_for_signature to payment dsl
    signature, date = call_for_signature(data)


    data2 = hash_the_data(@login, cc, @params, date)

    #move call_to_silent_pay to payment dsl
    $tracer.report("#{signature.inspect} \n#{date.inspect}")
    #the response is returned as a Mechanize Page so iterating on the forms is already setup, just need to tell it what to get by calling the forms name
    token_resp = call_to_silent_pay(signature, date, data2, cc, cc_enum)
    payment_token = token_resp.forms[0]["payment_token"]
    req_card_number = token_resp.forms[0]["req_card_number"]
    req_card_expiry_date = token_resp.forms[0]["req_card_expiry_date"]
    req_card_type = token_resp.forms[0]["req_card_type"]
    transaction_id = token_resp.forms[0]["transaction_id"]
    req_access_key = token_resp.forms[0]["req_access_key"]
    token_resp.forms[0]["reason_code"].should == "100"

    $tracer.report(payment_token)
    #extract the call_to_silent_pay response
      #<form id="custom_redirect" action="https://qa.gamestop.com/Checkout/en/CyberSource" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" />
#     <input type="hidden" name="req_bill_to_address_country" id="req_bill_to_address_country" value="US" />
#     <input type="hidden" name="auth_avs_code" id="auth_avs_code" value="2" />
#     <input type="hidden" name="req_card_number" id="req_card_number" value="xxxxxxxxxxxx1111" />
#     <input type="hidden" name="req_card_expiry_date" id="req_card_expiry_date" value="02-2017" />
#     <input type="hidden" name="decision" id="decision" value="ACCEPT" />
#     <input type="hidden" name="req_bill_to_address_state" id="req_bill_to_address_state" value="TX" />
#     <input type="hidden" name="signed_field_names" id="signed_field_names" value="transaction_id,decision,req_access_key,req_profile_id,req_transaction_uuid,req_transaction_type,req_reference_number,req_amount,req_currency,req_locale,req_payment_method,req_bill_to_forename,req_bill_to_surname,req_bill_to_email,req_bill_to_address_line1,req_bill_to_address_city,req_bill_to_address_state,req_bill_to_address_country,req_bill_to_address_postal_code,req_card_number,req_card_type,req_card_expiry_date,message,reason_code,auth_avs_code,auth_avs_code_raw,auth_response,auth_amount,auth_code,auth_cv_result,auth_cv_result_raw,auth_time,payment_token,signed_field_names,signed_date_time" />
#     <input type="hidden" name="req_payment_method" id="req_payment_method" value="card" />
#     <input type="hidden" name="req_transaction_type" id="req_transaction_type" value="create_payment_token" />
#     <input type="hidden" name="auth_code" id="auth_code" value="PREATH" />
#     <input type="hidden" name="signature" id="signature" value="LZ0QaB3u1UNF++gSmg4Ag40sFyuxWK33do9MIWkEVUo=" />
#     <input type="hidden" name="req_locale" id="req_locale" value="en" />
#     <input type="hidden" name="req_bill_to_address_postal_code" id="req_bill_to_address_postal_code" value="75038" />
#     <input type="hidden" name="reason_code" id="reason_code" value="100" />
#     <input type="hidden" name="req_bill_to_address_line1" id="req_bill_to_address_line1" value="5615 High Point Dr" />
#     <input type="hidden" name="req_card_type" id="req_card_type" value="001" />
#     <input type="hidden" name="auth_amount" id="auth_amount" value="0.00" />
#     <input type="hidden" name="auth_cv_result_raw" id="auth_cv_result_raw" value="M" />
#     <input type="hidden" name="req_bill_to_address_city" id="req_bill_to_address_city" value="Irving" />
#     <input type="hidden" name="signed_date_time" id="signed_date_time" value="2015-06-24T16:09:52Z" />
#     <input type="hidden" name="req_currency" id="req_currency" value="usd" />
#     <input type="hidden" name="req_reference_number" id="req_reference_number" value="9291e2a0-2594-401a-a079-88618d704acc" />
#     <input type="hidden" name="auth_cv_result" id="auth_cv_result" value="M" />
#     <input type="hidden" name="auth_avs_code_raw" id="auth_avs_code_raw" value="0" />
#     <input type="hidden" name="transaction_id" id="transaction_id" value="4351621918645000001520" />
#     <input type="hidden" name="req_amount" id="req_amount" value="0.00" />
#     <input type="hidden" name="auth_time" id="auth_time" value="2015-06-24T160951Z" />
#     <input type="hidden" name="message" id="message" value="Request was processed successfully." />
#     <input type="hidden" name="auth_response" id="auth_response" value="85" />
#     <input type="hidden" name="req_profile_id" id="req_profile_id" value="1979EB50-F7F8-495B-841B-F1C8AC7568B4" />
#     <input type="hidden" name="req_transaction_uuid" id="req_transaction_uuid" value="5f23aafb-b1e5-4782-a128-6e6cebcb5f2a" />
#     <input type="hidden" name="payment_token" id="payment_token" value="0102447082131111" />
#     <input type="hidden" name="req_bill_to_surname" id="req_bill_to_surname" value="Billing" />
#     <input type="hidden" name="req_bill_to_forename" id="req_bill_to_forename" value="Accept" />
#     <input type="hidden" name="req_bill_to_email" id="req_bill_to_email" value="svc_qa_auto@qagsecomprod.oib.com" />
#     <input type="hidden" name="req_access_key" id="req_access_key" value="61852f33714536a98fe3835ac163c7ee" />
#     <noscript>
#     <p>Your browser does not support JavaScript. Click the button below to continue.</p>
#                                                                            <input type="submit" name="commit" value="Continue" />
#     </noscript>
# </form>

    #verify cybersource response code == 100
    #verify address information matches what was sent
    #verify card type matches enumeration
    #verify signed_date_time matches
    #collect the transaction id
    #collect the req_amount value
    #collect the auth_time and verify
    #collect the auth_response
    #collect payment_token <-- needed for completing the transaction
    #verify masked credit card number
    #verify expiry data format & value

  end

  def hash_the_data(login, cc, params, date_time)
    $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

    #INFO: access key expires in 2017
    signed_field_names = 'access_key,profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency,payment_method,bill_to_forename,bill_to_surname,bill_to_email,bill_to_address_line1,bill_to_address_city,bill_to_address_state,bill_to_address_country,bill_to_address_postal_code'.split(',')
    signed_field_name_string = "access_key profile_id transaction_uuid signed_field_names unsigned_field_names signed_date_time locale transaction_type reference_number amount currency payment_method bill_to_forename bill_to_surname bill_to_email bill_to_address_line1 bill_to_address_city bill_to_address_state bill_to_address_country bill_to_address_postal_code"
    field_values = "61852f33714536a98fe3835ac163c7ee,1979EB50-F7F8-495B-841B-F1C8AC7568B4,#{generate_guid},#{signed_field_name_string},card_type card_number card_expiry_date card_cvn,#{date_time},en,create_payment_token,#{generate_guid},0.00,usd,card,#{params['BillFirstName']},#{params['BillLastName']},#{login},#{params['BillLine1']},#{params['BillCity']},#{params['BillState']},#{params['BillCountryCode']},#{params['BillPostalCode']}".split(',')
    field_values.map { |i| i.include?(',') ? (i.split /,/) : i }
    data_to_sign = Hash[signed_field_names.zip(field_values.map { |i| i.include?(',') ? (i.split /,/) : i })]
    data_to_sign['signed_field_names'] = data_to_sign['signed_field_names'].to_s.gsub(' ',',')
    data_to_sign['unsigned_field_names'] = data_to_sign['unsigned_field_names'].to_s.gsub(' ',',')
    return data_to_sign
  end

  def call_for_signature(data)
    config = RestAgentConfig.new
    config.set_option("Content-Type", 'application/json')
    config.set_option("Accept", '*/*')

    uri = "https://qa.gamestop.com/Checkout/en/CyberSource/Sign"
    cybersource_post = CybersourceTokenizationResource.new(uri, config)
    get_signature = <<eos
{"paramsArray": [{"Key":"access_key","Value":"#{data['access_key']}"},
        {"Key":"profile_id","Value":"#{data['profile_id']}"},
        {"Key":"transaction_uuid","Value":"#{@transaction_uuid}"},
        {"Key":"signed_field_names","Value":"#{data['signed_field_names']}"},
        {"Key":"unsigned_field_names","Value":"#{data['unsigned_field_names']}"},
        {"Key":"signed_date_time","Value":""},
        {"Key":"locale","Value":"en"},
        {"Key":"transaction_type","Value":"create_payment_token"},
        {"Key":"reference_number","Value":"#{@reference_number}"},
        {"Key":"amount","Value":"0.00"},
        {"Key":"currency","Value":"usd"},
        {"Key":"payment_method","Value":"card"},
        {"Key":"bill_to_forename","Value":"#{data['bill_to_forename']}"},
        {"Key":"bill_to_surname","Value":"#{data['bill_to_surname']}"},
        {"Key":"bill_to_email","Value":"#{@login}"},
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

  def call_to_silent_pay(signature, date_time, data, cc, cc_enum)
    uri_pay = "https://testsecureacceptance.cybersource.com/silent/pay"
    client2 = Mechanize.new{|a|
    # Uncomment the line below if you need to trace the call through Fiddler, do not keep this proxy setting enabled when pushing to the lab
    a.set_proxy('127.0.0.1',8888,nil,nil)
    a.verify_mode = OpenSSL::SSL::VERIFY_NONE
    }
    #query_params = build_query_string(post_payment.split(','))

    resp2 = client2.post(uri_pay, {"access_key" => "#{data['access_key']}",
                                   "profile_id" => "#{data['profile_id']}",
                                   "transaction_uuid" => "#{@transaction_uuid}",
                                   "signed_field_names" => "#{data['signed_field_names']}",
                                   "unsigned_field_names" => "#{data['unsigned_field_names']}",
                                   "signed_date_time" => "#{date_time}",
                                   "locale" => "en",
                                   "transaction_type" => "create_payment_token",
                                   "reference_number" => "#{@reference_number}",
                                   "amount" => "0.00",
                                   "currency" => "usd",
                                   "payment_method" => "card",
                                   "bill_to_forename" => "#{data['bill_to_forename']}",
                                   "bill_to_surname" => "#{data['bill_to_surname']}",
                                   "bill_to_email" => "#{@login}",
                                   "bill_to_address_line1" => "#{data['bill_to_address_line1']}",
                                   "bill_to_address_city" => "#{data['bill_to_address_city']}",
                                   "bill_to_address_state" => "#{data['bill_to_address_state']}",
                                   "bill_to_address_country" => "#{data['bill_to_address_country']}",
                                   "bill_to_address_postal_code" => "#{data['bill_to_address_postal_code']}",
                                   "signature" => "#{signature}",
                                   "card_type" => "#{cc_enum}",
                                   "card_number" => "#{cc[:cnum]}",
                                   "card_expiry_date" => "#{cc[:expmnth]}-#{cc[:expyr]}",
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
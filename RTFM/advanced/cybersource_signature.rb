##USAGE NOTES: d-Con %QAAUTOMATION_SCRIPTS%\RTFM\advanced\cybersource_signature.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range TFS44309 --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()
$tc_desc = $global_functions.desc
$tc_id = $global_functions.id
$options.http_proxy = '127.0.0.1'
$options.http_proxy_port = '8888'

describe "Make A Sig" do

  before(:all) do
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    #@login = $global_functions.login
    @login = "tester_sig@gamestop.com"
    @password = $global_functions.password
    @common_functions = $global_functions.common_function_link
  end

  it "should pass cybersource some stuff and get a signature back" do
    cc = @common_functions.generate_credit_card("generate")
    cc_type_val = credit_card_type_mapping(cc)
    signature, utc_date_time, data_to_sign = create_data_to_sign(@login, cc, @params)
    token = create_token(signature, data_to_sign, cc, cc_type_val, utc_date_time)
    $tracer.report("#{signature}, #{utc_date_time}, #{data_to_sign}")
    $tracer.report("UTC Date/Time From #{__method__}, Line: #{__LINE__}: #{utc_date_time}")
  end

end

#TODO: Need to encapsulate the Unsigned and Signed Field Names so that they are a part of their own values within the string.  Code below does it already just need to finish it.
#TODO: Bill to email is returning "register", need to actually register or use a real user for now.

def create_data_to_sign(login, cc, params)
  t = Time.now
  utc_date_time = t.strftime("%FT%TZ")
  $tracer.report("UTC Date/Time From #{__method__}, Line: #{__LINE__}: #{utc_date_time}")
  signed_field_names = 'access_key,profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency,payment_method,bill_to_forename,bill_to_surname,bill_to_email,bill_to_phone,bill_to_address_line1,bill_to_address_city,bill_to_address_state,bill_to_address_country,bill_to_address_postal_code'.split(',')
  signed_field_name_string = "access_key profile_id transaction_uuid signed_field_names unsigned_field_names signed_date_time locale transaction_type reference_number amount currency payment_method bill_to_forename bill_to_surname bill_to_email bill_to_phone bill_to_address_line1 bill_to_address_city bill_to_address_state bill_to_address_country bill_to_address_postal_code"
  field_values = "61852f33714536a98fe3835ac163c7ee,1979EB50-F7F8-495B-841B-F1C8AC7568B4,#{generate_guid},#{signed_field_name_string},card_type card_number card_expiry_date card_cvn,#{utc_date_time},en,create_payment_token,#{generate_guid},0.00,usd,card,#{params['BillFirstName']},#{params['BillLastName']},#{login},#{params['BillPhone']},#{params['BillLine1']},#{params['BillCity']},#{params['BillState']},#{params['BillCountryCode']},#{params['BillPostalCode']}".split(',')
  field_values.map { |i| i.include?(',') ? (i.split /,/) : i }
  data_to_sign = Hash[signed_field_names.zip(field_values.map { |i| i.include?(',') ? (i.split /,/) : i })]
  data_to_sign['signed_field_names'] = data_to_sign['signed_field_names'].to_s.gsub(' ',',')
  data_to_sign['unsigned_field_names'] = data_to_sign['unsigned_field_names'].to_s.gsub(' ',',')
  $tracer.report("#{data_to_sign.inspect}")
  #sectok = Security.new
  #signature = sectok.generate_signature(data_to_sign)
  $tracer.report("UTC Date/Time From #{__method__}, Line: #{__LINE__}: #{utc_date_time}")
  return signature = nil, utc_date_time, data_to_sign
end

def create_token(signature, data, cc, cc_type_val, utc_date_time)
  $tracer.trace("GameStopPaymentServiceDSL: #{__method__}, Line: #{__LINE__}")
  $tracer.report("Should #{__method__}.")

  $tracer.report("This is the Data content #{data.inspect}")
  $tracer.report("UTC Date/Time From #{__method__}, Line: #{__LINE__}: #{utc_date_time}")
  #uri = "https://ics2wstest.ic3.com/commerce/1.x/transactionProcessor"
  #uri = "https://testsecureacceptance.cybersource.com/silent/pay"
  uri = "https://qa.gamestop.com/Checkout/en/CyberSource/Sign"
  config = RestAgentConfig.new
  config.set_option("Content-Type:", "application/json")
  config.set_option("Accept-Encoding:", "gzip")
  config.set_option("Accept-Encoding:", "deflate")
  config.set_option("Accept-Language:", "en-US")
  config.set_option("Host:", "qa.gamestop.com")
  config.set_option("Referer:", "https://qa.gamestop.com/Checkout/en/Payments")
  config.set_user_agent("Mechanize")

  json_get_signature = <<eos
{
    "paramsArray": [
        {
            "Key": "access_key",
            "Value": #{data['access_key']}
        },
        {
            "Key": "profile_id",
            "Value": #{data['profile_id']}
        },
        {
            "Key": "transaction_uuid",
            "Value": "#{generate_guid}"
        },
        {
            "Key": "signed_field_names",
            "Value": "access_key,
            profile_id,
            transaction_uuid,
            signed_field_names,
            unsigned_field_names,
            signed_date_time,
            locale,
            transaction_type,
            reference_number,
            amount,
            currency,
            payment_method,
            bill_to_forename,
            bill_to_surname,
            bill_to_email,
            bill_to_address_line1,
            bill_to_address_city,
            bill_to_address_state,
            bill_to_address_country,
            bill_to_address_postal_code"
        },
        {
            "Key": "unsigned_field_names",
            "Value": "card_type,
            card_number,
            card_expiry_date,
            card_cvn"
        },
        {
            "Key": "signed_date_time",
            "Value": "#{utc_date_time}"
        },
        {"Key": "locale",
            "Value": "en"
        },
        {"Key": "transaction_type",
            "Value": "create_payment_token"},
        {"Key": "reference_number",
            "Value": "#{generate_guid}"},
        {"Key": "amount",
            "Value": 0.00},
        {"Key": "currency",
            "Value": "usd"},
        {"Key": "payment_method",
            "Value": "card"},
        {"Key": "bill_to_forename",
            "Value": "#{data['bill_to_forename']}"},
        {"Key": "bill_to_surname",
            "Value": "#{data['bill_to_surname']}"},
        {
            "Key": "bill_to_email",
            "Value": "#{data['bill_to_email']}"
        },
        {
            "Key": "bill_to_address_line1",
            "Value": "#{data['bill_to_address_line1']}"
        },
        {
            "Key": "bill_to_address_city",
            "Value": "#{data['bill_to_address_city']}"
        },
        {
            "Key": "bill_to_address_state",
            "Value": "#{data['bill_to_address_state']}"
        },
        {
            "Key": "bill_to_address_country",
            "Value": "#{data['bill_to_address_country']}"
        },
        {
            "Key": "bill_to_address_postal_code",
            "Value": "#{data['bill_to_address_postal_code']}"
        }
    ]
}"
eos

  #$tracer.report(URI::encode(create_merchant_token))
  $tracer.report("UTC Date/Time From #{__method__}, Line: #{__LINE__}: #{utc_date_time}")
  wc = JsonMessage.new(json_get_signature, HttpBody::REQUEST)
  client = RestAgent.new(config)
  agent = Mechanize.new{|a|
    a.set_proxy('127.0.0.1',8888,nil,nil)
    a.verify_mode = OpenSSL::SSL::VERIFY_NONE
  }

  resp = agent.post(uri, wc, 'Content-Type' => 'application/json')
  #$tracer.report("RESPONSE INFORMATION")
  #$tracer.report(resp.code)
  #$tracer.report(resp.inspect)
  return resp
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


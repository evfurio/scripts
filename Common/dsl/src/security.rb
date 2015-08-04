class Security
  require 'securerandom'
  #require 'hmac-sha2'
  #switch this to use the openssl sha256 solution as it is already implemented in the framework
  require 'base64'

  def generate_signature params
    $tracer.trace("SecurityClass: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    @secret_key = 'd4bc4b09b6c94327bd314c7f89a88a993c07690396044971a85e78c6e52e99bf9cf0c76fe05b4c45906ce5bf4bafc3f445b858121f2a4bde9c182e37acabf034a2eece6094694307a21a1d738d89b5e0ca7bbb5dbca64e18b75291907c8f59d6116c1aea442347d08621b2267faa0e4165e46e87349e4d7689e3529dcf01de60'
    sign(build_data_to_sign(params),@secret_key)
  end

  def valid? params
    $tracer.trace("SecurityClass: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.report(params.inspect)
    signature = generate_signature params
    signature.strip.eql? params['signature'].strip
  end

  def sign data, secret_key
    $tracer.trace("SecurityClass: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    mac = HMAC::SHA256.new secret_key
    mac.update data
    Base64.encode64(mac.digest).gsub "\n", ''
  end

  def build_data_to_sign params
    $tracer.trace("SecurityClass: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    signed_field_names = params['signed_field_names'].gsub(' ',',').split(',')
    data_to_sign = Array.new
    signed_field_names.each { |signed_field_name|
      data_to_sign << signed_field_name + '=' + params[signed_field_name]
    }

    comma_separate data_to_sign
  end

  def comma_separate data_to_sign
    csv = ''
    data_to_sign.length.times do |i|
      csv << data_to_sign[i]
      csv << ',' if i != data_to_sign.length-1
    end
    csv
  end

end

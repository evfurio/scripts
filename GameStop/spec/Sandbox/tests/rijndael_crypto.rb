require 'crypt/rijndael'
require 'digest'
require 'base64'

qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']
require "#{qaautomation_scripts_dir}/GameStop/spec/Sandbox/tests/pbkdf2"


    plain_text = "david@r3nrut.com"
    key_size = "256"
    init_vector = "sv90hfhj451t90v3"
    @rijndael = Crypt::Rijndael.new(key_size)
    pass_phrase = "Git is greater than TFS"

    #@init_vector_bytes = Base64.encode64(Digest::SHA1.digest(@init_vector)[0,20])
    init_vector.force_encoding("UTF-8").unpack('')
    #@plain_text_bytes = Base64.encode64(Digest::SHA1.digest(@plain_text)[0,20])
    plain_text.force_encoding("UTF-8")[1,3].bytes.to_a
    password = PBKDF2.new(:password=> pass_phrase, :salt=> "", :iterations => 10000 )
    puts password.inspect
    puts password.class

    key_bytes = password.bytes(key_size.to_i / 8)
    puts key_bytes
    #PasswordDeriveBytes is based on the OpenSSL implementation of pbkdf1
    #Chilkat has an example of a java based implementation that would substitute for PasswordDeriveBytes
    #http://www.example-code.com/java/crypt2_pbkdf1.asp
    #@password = PasswordDeriveBytes(@pass_phrase, null)

    @encrypted_block = @rijndael.encrypt_block(plain_text)



    @base64_block = Base64.encode64(Digest::SHA1.digest(@encrypted_block)[0,20])
    puts @base64_block



#     @decrypted_block = @rijndael.decrypt_block(@encrypted_block)
# puts @decrypted_block

#@encrypted_block == "EHpRhiFjA/YyyhBzhzjdWmg9xREA9a9pLgVJSuTbwlo="

#vKrfvOhm4FqwDYtYbbbQCco17vI=


#checkout - AuthSecurityKey = GByWGL8jVSlU8CVasyan+YXFkoanzEdSsDPrcHyUNOw=
#SSO.LongTermAuthKey = vFmFfy16BK9kbIMOOce5NwSagWmxK1HERh1ha7/hWWc=
#SSO.LongTermAuthKeyLocation =\\dl1imqweb01.testecom.pvt\certificates\auth_ticket_key_long.txt
#SSO.ShortTermAuthKey = GByWGL8jVSlU8CVasyan+YXFkoanzEdSsDPrcHyUNOw=
#SSO.ShortTermAuthKeyLocation = \\dl1imqweb01.testecom.pvt\certificates\auth_ticket_key.txt

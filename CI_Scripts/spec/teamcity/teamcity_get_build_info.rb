qaautomation_dir = ENV['QAAUTOMATION_FILES']
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Get Team City Build Information For Fun" do
    before(:all) do
        $tracer.mode = :on
        $tracer.echo = :on
    end

    before(:each) do
    end

    it "should make an xml service call and retrieve data" do
        # FIXME: need to decide how password is passed into config.  Password can be passed in unencrypted, or encrypted.
        #        One could pass the password unencrypted directly to set_username_password, or already encrypted.  To pass
        #        encrypted, either use AES.encrypt, or create the hash format containing :content and :iv where :content is
        #        already encrypted password, and :iv is the vector used in crypting it
        # example: encrypted = {:content=>"lkNqFnI2j2qiE2L4IEGaLw==", :iv=>"123456781234567812345678"}
        username = "s_tfstest"
        password = "some_password"
        encrypted = AES.encrypt(password)


        config = RestAgentConfig.new
        config.set_user_agent('Mechanize')
        config.set_option("accept", 'application/json')
        config.set_option("content-type", 'application/xml')
        config.set_username_password(username, encrypted)

        client = TeamCityResource.new("http://cibuilds.gamestop.com:8080/httpAuth/app/rest", config)

        response = client.builds

        response.code.should == "200"
        $tracer.trace(response.http_body.formatted_json)

        #response.http_header.content_type.content.should == "text/xml; charset=utf-8"
        #response.http_body.array_of_profile.profile.nick_name.content.should == "gamestop_rs1"
        #response.http_body.find_tag("impulse_customer_id").at(0).content == "6061536"
    end

end






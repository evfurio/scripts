#####################################################################
###USAGE NOTES
###Run this script using the following command
### Single execution in QA to get available product inventory
### d-Con .\dynamic_digital_wallet.rb --csv catalog_dataset.csv --range "TestCase01" -e "should get inventory level" --sql .\get_products.sql --db .\qa_databases.csv --db_range "catalog" --svc qa_endpoints.csv --svc_env QA --or
###
### Additional sceanrios can be constructed by manipulating the data input.
### Facilitates authenticated and anonymous checkout.  To run as an authenticated session use the following parameters: --login user@test.com --password P@55w0rd!
### 
###Author: dturner

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

describe "GameStop Catalog Get Inventory Scenario Tests" do
csv = QACSV.new(csv_filename_parameter)
@row = csv.find_row_by_name(csv_range_parameter)
@testcasename = @row.find_value_by_name("TestCase")

    before(:all) do
#We will instantiate our connections for the test and take the option parameters passed by the command line 
        $tracer.mode = :on
        $tracer.echo = :on

#get the service endpoints from the --svc cmd parameter using --svc_env for the environment		
        @global_functions = GlobalServiceFunctions.new()
		@account_svc = @global_functions.account_svc
		@idigital_wallet_svc = @global_functions.idigital_wallet_svc
		
		puts "Digital Wallet#{@idigital_wallet_svc}"
		
############################################################################
		
		
#get the --csv parameter and read the file, --range identifies the row of data to use per test case
		csv = QACSV.new(csv_filename_parameter)
		@row = csv.find_row_by_name(csv_range_parameter)
		
#get the --sql filename to use 
		@sql = "sql_queries/#{sql_parameter}"
		#@sql.should == "get_products.sql"
		
#get the server and database from the csv
		#db = QACSV.new("#{db_parameter}")
		#@db_name = db.find_row_by_name(db_env_parameter)
		
		#server = @db_name.find_value_by_name("Server")
		#database = @db_name.find_value_by_name("Database")	
		##create the new instance of dbmanager
		#@db = DbManager.new(server, database)		
    end

    before(:each) do
#user name and password are provided throught the command line parameter
#if no user name or password are provided the script will authorize the user as anonymous

		#generate a new session id guid.  the generate_guid function uses uuidtools to generate guids on the fly.
        @session_id = generate_guid
		
	end

#set instance variables for csv driven data elements

	#standard service data
	client_channel = @row.find_value_by_name("ClientChannel")
	locale = @row.find_value_by_name("Locale")
	authorization_userid = @row.find_value_by_name("AuthorizationUserID")
	payment_token = @row.find_value_by_name("PaymentToken")	
	
		#####################
        ### DIGITALWALLET ###
        #####################

        ### GET_DIGITAL_WALLETS ###

	it "should get digital wallet" do
		
        get_digital_wallets_req = @idigital_wallet_svc.get_request_from_template_using_global_defaults(:get_digital_wallets)
        get_digital_wallets_request_data = get_digital_wallets_req.find_tag("get_digital_wallets_request").at(0)    
        get_digital_wallets_request_data.open_id_claimed_identifiers.string.at(0).content = authorization_userid

        $tracer.trace(get_digital_wallets_req.formatted_xml)

        get_digital_wallets_rsp =@idigital_wallet_svc.get_digital_wallets(get_digital_wallets_req.xml)

        get_digital_wallets_rsp.code.should == 200

        $tracer.trace(get_digital_wallets_rsp.http_body.formatted_xml)

        #catalog_product_inventory = get_inventory_level_rsp.http_body.find_tag("inventory_level").at(0).content
		get_digital_wallet_replies = get_digital_wallets_rsp.http_body.find_tag("replies").at(0)
		get_digital_wallet_data = get_digital_wallet_replies.get_digital_wallet_reply.at(0)
		open_id_claimed_identifier = get_digital_wallet_data.open_id_claimed_identifier.content
		result = get_digital_wallet_data.result.content
		is_default = get_digital_wallet_data.digital_wallet.payment_methods.payment_method.is_default.content
		pan_last_four = get_digital_wallet_data.digital_wallet.payment_methods.payment_method.pan_last_four.content
		token = get_digital_wallet_data.digital_wallet.payment_methods.payment_method.token.content		
	end

		### DELETE DIGITAL WALLET PAYMENT METHODS ###
		
	it "should delete digital wallet payment methods" do
		
        delete_digital_wallet_payment_methods_req = @idigital_wallet_svc.get_request_from_template_using_global_defaults(:delete_digital_wallet_payment_methods)
        delete_digital_wallet_payment_methods_request_data = delete_digital_wallet_payment_methods_req.find_tag("delete_digital_wallet_payment_methods_request").at(0)
        delete_digital_wallet_payment_methods_request_data.payment_method_tokens.payment_token.string.at(0).content = payment_token
        delete_digital_wallet_payment_methods_request_data.open_id_claimed_identifiers.content = authorization_userid

        $tracer.trace(get_products_req.formatted_xml)
		
        delete_digital_wallet_payment_methods_rsp = @idigital_wallet_svc.delete_digital_wallet_payment_methods(delete_digital_wallet_payment_methods_req.xml)

        delete_digital_wallet_payment_methods_rsp.code.should == 200

        $tracer.trace(delete_digital_wallet_payment_methods_rsp.http_body.formatted_xml)

        delete_replies = delete_digital_wallet_payment_methods_rsp.http_body.find_tag("delete_replies").at(0)
		delete_payment_method_reply_data = delete_replies.delete_payment_method_reply.at(0)
		delete_result = delete_payment_method_reply_data.result.content
		delete_token = delete_payment_method_reply_data.token.content
		
	end
	
		##########################
		## Assertion Collection ##
		##########################
		
		#Need to put this function into a DSL
		#Assert for Sku
		#Inventory Level
	
		##########################
  

end



#####################################################################
###USAGE NOTES
###Run this script using the following command
###    
#################################################################################################################################################################################################################################### 
###
##$ **Generate New Unique User, Checkout ALL RUN TIME PARAMETERS IN THE COMMAND LINE
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Sandbox\create_multiple_credit_cards.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Sandbox\create_users_and_wallets.csv --range TFSTEST --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --or
###
#############################################################################################################################################################################################################################################################################
###
### Additional sceanrios can be constructed by manipulating the data input.
### Facilitates authenticated and anonymous checkout.  To run as an authenticated session use the following parameters: --login user@test.com --password P@55w0rd!
### 
###Author: dturner/ebrown
### 

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

describe "GameStop Credit Card Generator - Stand Alone" do

    before(:all) do
#We will initialize our connections and data sets for the test by taking the option parameters passed by the command line 
        $tracer.mode = :on
        $tracer.echo = :on
	end

    before(:each) do	
		#get the --csv parameter and read the file, --range identifies the row of data to use per test case
		#range will now define the TFS ID to use in relation to the MTM test case created.	
		
		csv = QACSV.new(csv_filename_parameter)
		@row = csv.find_row_by_name(csv_range_parameter)
		
		#initialize the services to be used for the test
		@global_functions = GlobalServiceFunctions.new()
		@global_functions.csv = @row
		@global_functions.parameters
		#@global_functions.csv_params
		@sql = @global_functions.sql_file
		@db = @global_functions.db_conn
		@cart_svc, @cart_svc_version = @global_functions.cart_svc
		@account_svc, @account_svc_version  = @global_functions.account_svc
		@profile_svc, @profile_svc_version = @global_functions.profile_svc
		@purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
		@shipping_svc, @shipping_svc_version = @global_functions.shipping_svc
		@tax_svc, @tax_svc_version = @global_functions.tax_svc
		@payment_svc, @payment_svc_version = @global_functions.payment_svc

#user name and password are provided throught the command line parameter
#if no user name or password are provided the script will authorize the user as anonymous

#generate a new session id guid.  the generate_guid function uses uuidtools to generate guids on the fly.
        @session_id = generate_guid
#Owner Id must be generated new per each test method.  It cannot be the userID as it was in previous versions.
		@owner_id = generate_guid
		
		
#get the user name and password provided using the --login and --password parameters if provided.
	#if the parameters were not passed the script will assume you want to authorize anonymously
#TODO - if the parameters are passed and the user is not registered, register the new user and authorize
        user_name, user_password = nil
        begin
            user_name = account_login_parameter
            user_password = account_password_parameter
        rescue Exception => ex
            account_login_parameter = nil
        end
		
#get results from the sql file
		sql = @sql.to_s
		@results_from_file = @db.exec_sql_from_file(sql)
		
		#set instance variables for csv driven data elements
		initialize_csv_params
		#initialize_discount_params
		#initialize_payment_params
		#initialize_shipping_addr_params
		#initialize_billing_addr_params
		@client_payment_method_id = generate_guid
		
    end
	
	
#[TestMethod]
    it "Should Create Some Credit Cards" do
		
		#SET Credit Card Types to be tested
		#SET BIN Ranges for applicable tests, these should all be US only
		cctype = "generate"
		@cc = @purchase_order_svc.generate_credit_card(cctype)
		ctype = @cc[:ctype].to_s
		puts "----------------------------------------------"
		puts "-----------CREDIT CARD DATA-------------------"
		card_type = ctype.slice(0,1).capitalize + ctype.slice(1..-1)
		puts "Credit Card Number: #{@cc[:cnum]}"
		puts "Credit Card Type: #{card_type}" #cc[:ctype]
		puts "Credit Card Exp Month: #{@cc[:expmnth]}"
		puts "Credit Card Exp Year: #{@cc[:expyr]}"
		puts "Credit Card CVV: #{@cc[:cvv]}"
		puts "----------------------------------------------"
	end
	
	
	def initialize_csv_params
	
		@testcaseid = @row.find_value_by_name("ID")
				
		@testdesc = "TEST TEST TEST"
		@brand = "GS"
		@client_channel = "GS_US"
		@local = "en-US"

	end
	
end

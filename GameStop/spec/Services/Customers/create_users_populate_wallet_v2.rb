#####################################################################
###USAGE NOTES
###Run this script using the following command.  jibberish.
###    
#################################################################################################################################################################################################################################### 
###
##$ **Generate New Unique User, Checkout ALL RUN TIME PARAMETERS IN THE COMMAND LINE
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Customers\create_users_populate_wallet_v2.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Customers\create_users_and_wallets.csv --range TFSTEST --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_Paypal1 --or
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

describe "GameStop Account Service Tests" do

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

		
#get results from the sql file
		sql = @sql.to_s
		@results_from_file = @db.exec_sql_from_file(sql)
		
		#set instance variables for csv driven data elements
		initialize_csv_params
	
    end
	
	
#[TestMethod]
    it "Should Create a New User and Populate the Digital Wallet" do
	count = 0
	users = 2
	while count < users do
	    @user_name, @user_password = nil
			begin
				@user_name = account_login_parameter
				@user_password = account_password_parameter
			rescue Exception => ex
				account_login_parameter = nil
			end
		@user_id = generate_guid	
		creds = @account_svc.create_new_user_return_credentials(@user_id, @session_id, @user_name, @user_password, @account_svc_version)
		user_creds = Hash[*creds]
		
		 user_creds.each_with_index do |(username, password), i|
            @username = username.to_s
            @password = password.to_s
        end		
		
		puts @username
		puts @password
		
#########SAVE_PAYMENT_METHODS TO WALLET###################

		puts "THIS IS THE SERVICE OPERATIONS #{@payment_svc.operations}"
		puts "THIS IS THE SERVICE OPERATIONS #{@account_svc.operations}"
		initialize_payment_params
		openid = @account_svc.perform_authorization_and_return_open_id(@session_id, @username, @password, @account_svc_version)
		
		@cc_type.each_with_index do |z, y|
			cctype = z

			if cctype == 'AmericanExpress'
				@cc_number = @card_hash["amex"]
			else
				@cc_number = @card_hash[cctype.downcase]
			end
		
		save_payment_methods_to_wallet_req = @payment_svc.get_request_from_template_using_global_defaults(:save_payment_methods_to_wallet,PaymentServiceRequestTemplates.const_get("SAVE_PAYMENT_METHODS_TO_WALLET#{@payment_svc_version}"))
              save_payment_methods_to_wallet_data = save_payment_methods_to_wallet_req.find_tag("save_payment_methods_to_wallet_request").at(0)
       
              save_payment_methods_to_wallet_req.find_tag("client_channel").content = @client_channel
              save_payment_methods_to_wallet_req.find_tag("open_id_claimed_identifier").content = openid
              
			  credit_card_payment = save_payment_methods_to_wallet_data.credit_card.at(0)

              credit_card_payment.client_payment_method_id.content = generate_guid
              credit_card_payment.credit_card_number.content = @cc_number
              credit_card_payment.expiration_month.content = @cc_exp_month
              credit_card_payment.expiration_year.content = @cc_exp_year
              credit_card_payment.name_on_card.content = "Generic Tester"
              credit_card_payment.type.content = "#{z}"
			  

			  save_payment_methods_to_wallet_data.pay_pal_account.remove_self
			  
              $tracer.trace(save_payment_methods_to_wallet_req.formatted_xml)
              save_payment_methods_to_wallet_rsp = @payment_svc.save_payment_methods_to_wallet(save_payment_methods_to_wallet_req.xml)
              save_payment_methods_to_wallet_rsp.code.should == 200

              $tracer.trace(save_payment_methods_to_wallet_rsp.http_body.formatted_xml)
       
              payment_token = save_payment_methods_to_wallet_rsp.http_body.find_tag("payment_token").at(0).content
              save_payment_methods_to_wallet_rsp.http_body.find_tag("result_code").content.should == "Success"
              save_payment_methods_to_wallet_rsp.http_body.find_tag("result_message").content.should == "Sucess"
			  	
			header = []
			test_info = []
			#dump parameters to a csv for easy import to TFS
			header << "username, password, cc_number, cc_exp_month, cc_exp_year, cctype, userid"
			test_info << "#{@username},#{@password},#{@cc_number}.#{@cc_exp_month},#{@cc_exp_year},#{cctype},#{@user_id}"
			path = "#{ENV['QAAUTOMATION_SCRIPTS']}/users/"
			Dir.mkdir(path) unless File.exists?(path)
			
			test_info.each do |i|
				csv_builder(test_info)
				
				CSV.open("#{path}\\users_and_cards.csv", "a") do |csv|
					csv << @data
				end
			end
			  
		end#end cc_type loop
		users -= 1
		end
	end
	
	def initialize_csv_params
		@testcaseid = @row.find_value_by_name("ID")
		$tracer.trace("TFS Test Case ID: #{@testcaseid}")
		#@testdesc = @row.find_value_by_name("TestDescription")
		#$tracer.trace("Test Description: #{@testdesc}")
		
		#standard service data
		@brand = @row.find_value_by_name("Brand")
		$tracer.trace("brand : #{@brand}")
		@client_channel = @row.find_value_by_name("ClientChannel")
		$tracer.trace("Client Channel : #{@client_channel}")
		@locale = @row.find_value_by_name("Locale")
		$tracer.trace("locale : #{@locale}")
	end
	
	def initialize_payment_params		
		#@cc_type = @row.find_value_by_name("CCType")
		@cc_type = ['Visa', 'MasterCard', 'Discover', 'AmericanExpress']
		# @cc_number = @row.find_value_by_name("cc_number")
		@cc_exp_month = @row.find_value_by_name("cc_exp_month")
		@cc_exp_year = @row.find_value_by_name("cc_exp_year")
		@cvv = @row.find_value_by_name("CVV")
		
		@named = {
			:mastercard => { :prefixes => [ '51', '52', '53', '54', '55' ], :size => 16 },
			:visa => { :prefixes => ['4124','4117','411773'], :size => 16 },
			:amex => { :prefixes => ['377481','372888','3764'], :size => 15 },
			:discover => { :prefixes => ['60', '61'], :size => 16}
			}
		
		card_numbers = []		
		card_types = ['visa', 'mastercard', 'discover', 'amex']
		
		card_types.each_with_index do |i| 
			generated = CreditCard.method_missing("#{i}",@named)
			card_numbers.push(i,generated)
		end	
		@card_hash = Hash[*card_numbers]
		
		return @card_hash
	end
	
	def csv_builder(tst_info)
		test_info = tst_info.join(",")
		csv_data = "#{test_info}"

		# The parser just converts these into an array of CSV cells
		array_of_csv_cells = CSV.parse csv_data
		
		# The first CVS row are the headings
		@data = array_of_csv_cells.shift.map {|rd| rd.to_s}

		# Convert the array of CSV cells into an Array of Hashes
		products_in_structures = array_of_csv_cells.map do |cells|
			hsh = {}
			(cells.map {|cell| cell.to_s}).each_with_index do |cell_str, index|
			hsh[index] = cell_str
			end
		hsh
		end	

		return @data
	end
	
end

#####################################################################
###USAGE NOTES
###Run this script using the following command.  jibberish.
###    
#################################################################################################################################################################################################################################### 
###
##$ **Generate New Unique User, Checkout ALL RUN TIME PARAMETERS IN THE COMMAND LINE
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Customers\authorize_by_open_id_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Sandbox\create_users_and_wallets.csv --range TFSTEST --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --or
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
    it "should authorize openid and return au cookie information" do
	count = 0
	users = 1
	while count < users do
	    @user_name, @user_password = nil
			begin
				@user_name = account_login_parameter
				@user_password = account_password_parameter
			rescue Exception => ex
				account_login_parameter = nil
			end
			
		creds = @account_svc.create_new_user_return_credentials(@session_id, @user_name, @user_password, @account_svc_version)
		user_creds = Hash[*creds]
		
		 user_creds.each_with_index do |(username, password), i|
            @username = username.to_s
            @password = password.to_s
        end		
		
#########SAVE_PAYMENT_METHODS TO WALLET###################

		puts "THIS IS THE SERVICE OPERATIONS #{@payment_svc.operations}"
		puts "THIS IS THE SERVICE OPERATIONS #{@account_svc.operations}"
		initialize_payment_params
		openid = @account_svc.perform_authorization_and_return_open_id(@session_id, @username, @password, @account_svc_version)
		
		auth_email = @account_svc.peform_authorization_with_open_id(@session_id, openid, @account_svc_version)
		
		$tracer.trace("THIS IS THE AUTH EMAIL ADDRESS #{auth_email}")
		auth_email.should == @username
		
		@cc_type.each_with_index do |z, y|
			cctype = z

			if cctype == 'AmericanExpress'
				@cc_number = @card_hash["amex"]
			else
				@cc_number = @card_hash[cctype.downcase]
			end

		@payment_svc.perform_save_payment_methods_to_wallet(@client_channel, openid, @cc_number, @cc_exp_month, @cc_exp_year, name_on_card = "Generic Tester", cctype, @payment_svc_version)
		  	
			# header = []
			# test_info = []
			#dump parameters to a csv for easy import to TFS
			# header << "username, password, cc_number, cc_exp_month, cc_exp_year, cctype"
			# test_info << "#{@username},#{@password},#{@cc_number}.#{@cc_exp_month},#{@cc_exp_year},#{cctype}"
			# path = "#{ENV['QAAUTOMATION_SCRIPTS']}/users/"
			# Dir.mkdir(path) unless File.exists?(path)
			
			# test_info.each do |i|
				# csv_builder(test_info)
				
				# CSV.open("#{path}\\users_and_cards.csv", "a") do |csv|
					# csv << @data
				# end
			# end
			  
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

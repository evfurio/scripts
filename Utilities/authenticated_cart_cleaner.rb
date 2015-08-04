#####################################################################
###USAGE NOTES
###Run this script using the following command
###

###  **Cleans cart for all users defined in the users.csv
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Utilities\authenticated_cart_cleaner.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range TFS47096 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env CERT_Catalog --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env CERT_GS --or

### 
###Author: dturner
### 

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"
#require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/creditcard.rb"

describe "GameStop Checkout Scenario Tests" do

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

#user name and password are provided throught the command line parameter
#if no user name or password are provided the script will authorize the user as anonymous

#generate a new session id guid.  the generate_guid function uses uuidtools to generate guids on the fly.
        @session_id = generate_guid		
		
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
		
    end
	
	it "should clean up the cart for authenticated users" do
		
		clean_all_the_carts
	
	end
	
	def clean_all_the_carts
		csv_path = "#{ENV['QAAUTOMATION_SCRIPTS']}/users/users_and_cards_Cert092013.csv"
		users = {}
		CSV.foreach(csv_path, :headers => true, :header_converters => :symbol, :converters => :all ) do |row|
			users[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
			owner_id = @account_svc.perform_authorization_and_return_owner_id(@session_id, users[row.fields[0]][:user_name], users[row.fields[0]][:user_password], @account_svc_version)
			@cart_svc.perform_empty_cart(@session_id, owner_id, @client_channel, @locale, @cart_svc_version)
		end
		
	end

	
	def initialize_csv_params
		@testcaseid = @row.find_value_by_name("ID")
		$tracer.trace("TFS Test Case ID: #{@testcaseid}")
		
		@testdesc = @row.find_value_by_name("TestDescription")
		$tracer.trace("Test Description: #{@testdesc}")
		
		#standard service data
		@brand = @row.find_value_by_name("Brand")
		$tracer.trace("brand : #{@brand}")
		@client_channel = @row.find_value_by_name("ClientChannel")
		$tracer.trace("Client Channel : #{@client_channel}")
		@locale = @row.find_value_by_name("Locale")
		$tracer.trace("locale : #{@locale}")
		@currency = @row.find_value_by_name("Currency")
		$tracer.trace("currency : #{@currency}")
		@qty_increase = @row.find_value_by_name("QtyIncrease")
	end
	
	def initialize_discount_params
		#discounts
		@loyalty_card_number = @row.find_value_by_name("LoyaltyCardNumber")
		@loyalty_card_id = @row.find_value_by_name("LoyaltyCardId")
		@promo_code = @row.find_value_by_name("PromoCode")
	end
	
	def initialize_payment_params
		
		@credit_card = ""#@row.find_value_by_name("CreditCard")
		@cc_type = @row.find_value_by_name("CCType")
		@exp_month = @row.find_value_by_name("ExpMonth")
		@exp_year = @row.find_value_by_name("ExpYear")
		@svs = @row.find_value_by_name("SVS")
		@pin = @row.find_value_by_name("PIN")
		@cvv = @row.find_value_by_name("CVV")
		@shipment_type = @row.find_value_by_name("ShipmentType")
		@complete_checkout = @row.find_value_by_name("Checkout")
		$tracer.trace("Complete Checkout? : #{@complete_checkout}")
	end
	
	def initialize_shipping_addr_params
		#shipping address information
		@ship_email = @row.find_value_by_name("ShipEmail")
		@ship_phone = @row.find_value_by_name("ShipPhone")
		@ship_city = @row.find_value_by_name("ShipCity")
		@ship_country_code = @row.find_value_by_name("ShipCountryCode")
		@ship_line1 = @row.find_value_by_name("ShipLine1")
		@ship_line2 = @row.find_value_by_name("ShipLine2")
		@ship_postal_code = @row.find_value_by_name("ShipPostalCode")
		@ship_state = @row.find_value_by_name("ShipState")
		@ship_first_name = @row.find_value_by_name("ShipFirstName")
		@ship_last_name = @row.find_value_by_name("ShipLastName")
		@ship_address_id = generate_guid
	end

	def initialize_billing_addr_params
		#billing address information
		@bill_email = @row.find_value_by_name("BillEmail")
		@bill_phone = @row.find_value_by_name("BillPhone")
		@bill_city = @row.find_value_by_name("BillCity")
		@bill_country_code = @row.find_value_by_name("BillCountryCode")
		@bill_line1 = @row.find_value_by_name("BillLine1")
		@bill_line2 = @row.find_value_by_name("BillLine2")
		@bill_postal_code = @row.find_value_by_name("BillPostalCode")
		@bill_state = @row.find_value_by_name("BillState")
		@bill_first_name = @row.find_value_by_name("BillFirstName")
		@bill_last_name = @row.find_value_by_name("BillLastName")	
		@bill_address_id = generate_guid
	end
end



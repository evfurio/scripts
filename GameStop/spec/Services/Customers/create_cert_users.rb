#####################################################################
###USAGE NOTES
###
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Customers\create_cert_users.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Customers\create_users_and_wallets.csv --range TFSCERT --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env CERT_GS --or
###
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Customers\create_cert_users.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Customers\create_users_and_wallets.csv --range TFSCERT --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env PROD_V1 --or
###########################################################################################################################################################################################################

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
    @account_svc, @account_svc_version = @global_functions.account_svc
    @profile_svc, @profile_svc_version = @global_functions.profile_svc
    @purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
    @shipping_svc, @shipping_svc_version = @global_functions.shipping_svc
    @tax_svc, @tax_svc_version = @global_functions.tax_svc
    @payment_svc, @payment_svc_version = @global_functions.payment_svc

#user name and password are provided throught the command line parameter
#if no user name or password are provided the script will authorize the user as anonymous


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
  it "Should Create a New Cert User and Populate the Digital Wallet" do
    count = 0
    users = 15
    i = 1
    target = "Cert"

    while count < users do
      unique = Time.now.utc.strftime('%Y%mT%H%M%S')
      user = "ltcpuser#{unique}@gamestop.com"
      password = "T3sting1"

      puts "#{user} / #{password} \n"

      @user_name, @user_password = nil
      begin
        @user_name = user
        @user_password = password
      rescue Exception => ex
        #account_login_parameter = nil
      end
      @user_id = generate_guid
      #generate a new session id guid.  the generate_guid function uses uuidtools to generate guids on the fly.
      @session_id = generate_guid
      creds = @account_svc.create_new_user_return_credentials(@user_id, @session_id, @user_name, @user_password, @account_svc_version)
      user_creds = Hash[*creds]

      user_creds.each_with_index do |(username, password), i|
        @username = username.to_s
        @password = password.to_s
      end

      puts @username
      puts @password

      openid = @account_svc.perform_authorization_and_return_user_and_open_id(@session_id, @user_name, @user_password, @account_svc_version)

        header = []
        test_info = []
        #dump parameters to a csv for easy import to TFS
        header << "username, password, openid, userid"
        test_info << "#{@username},#{@password},#{openid},#{@user_id}"
        path = "#{ENV['QAAUTOMATION_SCRIPTS']}/users/"
        Dir.mkdir(path) unless File.exists?(path)

        test_info.each do |i|
          csv_builder(test_info)

          CSV.open("#{path}\\users_and_cards.csv", "a") do |csv|
            csv << @data
          end
        end

      end #end cc_type loop
      users -= 1
      i += 1
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


  def csv_builder(tst_info)
    test_info = tst_info.join(",")
    csv_data = "#{test_info}"

    # The parser just converts these into an array of CSV cells
    array_of_csv_cells = CSV.parse csv_data

    # The first CVS row are the headings
    @data = array_of_csv_cells.shift.map { |rd| rd.to_s }

    # Convert the array of CSV cells into an Array of Hashes
    products_in_structures = array_of_csv_cells.map do |cells|
      hsh = {}
      (cells.map { |cell| cell.to_s }).each_with_index do |cell_str, index|
        hsh[index] = cell_str
      end
      hsh
    end

    return @data
  end
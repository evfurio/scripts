# == Overview
# Global Functions is used as a common module which contains the  methods for the handling additional custom command
# arguments, initializing service endpoints, parsing endpoint versions for the Ecommerce Services and the passing of
# service account credentials for CI tests.

# This module is not used for specific functionality pertaining to any individual product or property.  Please use
# your best discretion when adding methods to this this module.  Common Functions should be used for property specific
# but functionally ambiguous methods.

# == USAGE
# the global function methods must be passed in as shown below to take full advantage of the custom cmd arguments.
# be aware that you must first get the parameters from the csv and then return the parameters back to global functions
# using the attr_accessor.  Since we're passing it as an array, it must be initialized first.
####
####global_functions passes the csv row object and return the parameters.
#  @global_functions = GlobalServiceFunctions.new()
####Get the parameters from the csv dataset
#  @params = @global_functions.get_params_from_csv
####Pass the params array to the attribute accessor in global functions
####receives using :csv and is used by calling @csv
#  @global_functions.csv = @params
####Invoke the parameters method to handle any additional command line options we defined or check the CSV for values
#  @global_functions.parameters

module GameStopGlobalServiceFunctionsDSL

  attr_accessor :csv

  def initialize
    @csv = []
  end

  def parameters
    #begin
    #  @login = "#{account_login_parameter}"
    #  $tracer.trace("Login found in command arguments: #{@login}")
    #rescue Exception => ex
    #  $tracer.trace("Login was NOT defined in the command arguments. \nDefaulting to CSV")
    #  @login = @csv["login"]
    #end
    #
    #begin
    #  @password = "#{account_password_parameter}"
    #  $tracer.trace("Password found in command arguments: #{@password}")
    #rescue Exception => ex
    #  $tracer.trace("Password was NOT defined in the command arguments. \nDefaulting to CSV")
    #  @password = @csv["password"]
    #end

    begin
      @svc = QACSV.new(svc_parameter).find_row_by_name(svc_env_parameter)
    rescue Exception => ex
      endpoints = @csv["Endpoints"]
      svc_env = @csv["SVC_ENV"]
      endpoint_csv = "#{ENV['QAAUTOMATION_SCRIPTS']}\\Common\\config\\#{endpoints}"
      @svc = QACSV.new("#{endpoint_csv}").find_row_by_name(svc_env)
      $tracer.trace("\n#{endpoint_csv} was referenced from the CSV Data Set instead of cmd args")
      $tracer.report("\nServices configuration used: \t#{svc_env}")
    end

    #Switched to a hardcoded path for the sql file.  The actual sql_file name is in the checkout_dataset.csv.
    #If there is a sql parameter passed on the command line then it is taken over the CSV.
    begin
      @sql = "#{sql_parameter}"
      $tracer.report("\n#{sql_parameter} was used from the cmd args")
    rescue Exception => ex
      sql_file = @csv['SqlQuery']
      @sql = "#{ENV['QAAUTOMATION_SCRIPTS']}/Common/sql_queries/#{sql_file}"
      $tracer.report("\n#{sql_file} was referenced from the CSV Data Set instead of cmd args")
    end

    #get the database server and database from the csv
    begin
      @db_name = QACSV.new(db_parameter).find_row_by_name(db_env_parameter)
    rescue Exception => ex
      $tracer.trace("\nNo SQL query was defined in the command arguments\nDefaulting to CSV")
      #apply values from checkout dataset to get values from the databases csv
      db_svr = @csv['Databases']
      @db_path = "#{ENV['QAAUTOMATION_SCRIPTS']}/Common/config/#{db_svr}"
      @db_n = @csv['DB_ENV']
      @db_name = QACSV.new(@db_path).find_row_by_name(@db_n)
    end

    #get properties csv and the url required for UI tests
    begin
      @url = QACSV.new(prop_parameter).find_row_by_name(url_parameter)
    rescue Exception => ex
      $tracer.trace("\nNo properties were defined in the command arguments\nDefaulting to CSV")
      begin
        properties = @csv['Property']
        prop_csv = "#{ENV['QAAUTOMATION_SCRIPTS']}\\Common\\config\\#{properties}"
        $tracer.report("This is the properties: #{properties}")
        @url = QACSV.new(prop_csv).find_row_by_name("#{@csv['PROP_URL']}")
        $tracer.report(@url)
      rescue Exception => ex
        $tracer.trace("No properties defined, this is probably not a UI test")
      end
    end

    server = @db_name.find_value_by_name("Server")
    database = @db_name.find_value_by_name("Database")
    #dbuser, dbpass = self.return_db_creds
    #TODO - enable the dbuser and dbpass once the account has been given permissions on the sql servers
    #@db = DbManager.new(server, database, dbuser, dbpass)
    @db = DbManager.new(server, database)
  end

  def login
    return @login
  end

  def password
    return @password
  end

  def sql_file
    return @sql
  end

  def sql_dynamic_constructor(params, filename)
    sql = ''
    if File.file?(filename.gsub!(/\\/, "/"))
      expanded_filename = File.realdirpath(filename)
      begin
        #explode_params #should get the string parameters from the array that we are needing to inject into the SQL query
        #build the dynamic string variables from the exploded array - err... hash.  :)
        sql = File.read(expanded_filename)
      rescue Exception => ex
        raise ToolException.new(ex, "unable to perform sql statement, cannot read '#{expanded_filename}': #{ex.message}")
      end
    else
      raise Exception, "unable to perform sql statement: unable to locate '#{filename}'"
    end
    return @sql
  end

  def db_conn
    return @db
  end

  def prop_url
    return @url
  end

  def catalog_svc
    catalogservice = @svc.find_value_by_name("catalog")
    catalog_svc = CatalogService.new(catalogservice)
    return catalog_svc, get_version(catalogservice)
  end

  def cart_svc
    cartservice = @svc.find_value_by_name("cart")
    cart_svc = CartService.new(cartservice)
    return cart_svc, get_version(cartservice)
  end

  def account_svc
    account_svc_config = SoapAgentConfig.new
    account_svc_config.set_end_point(@svc.find_value_by_name("account"))
    accountendpoint = @svc.find_value_by_name("account_wsdl")
    account_svc = AccountService.new(accountendpoint, account_svc_config)
    return account_svc, get_version(@svc.find_value_by_name("account"))
  end

  def profile_svc
    profileservice = @svc.find_value_by_name("profile")
    profile_svc = ProfileService.new(profileservice)
    return profile_svc, get_version(profileservice)
  end

  def digitalwallet_svc
    digitalwallet_svc_config = SoapAgentConfig.new
    digitalwallet_svc_config.set_end_point(@svc.find_value_by_name("digitalwallet"))
    digitalwalletendpoint = @svc.find_value_by_name("digitalwallet_wsdl")
    digitalwallet_svc = DigitalWalletService.new(digitalwalletendpoint, digitalwallet_svc_config)
    return digitalwallet_svc, get_version(@svc.find_value_by_name("digitalwallet"))
  end

  def digitalcontent_svc
    digitalcontentservice = @svc.find_value_by_name("digitalcontent")
    digitalcontent_svc = DigitalContentService.new(digitalcontentservice)
    return digitalcontent_svc, get_version(digitalcontentservice)
  end

  def shipping_svc
    shippingservice = @svc.find_value_by_name("shipping")
    shipping_svc = ShippingService.new(shippingservice)
    return shipping_svc, get_version(shippingservice)
  end

  def velocity_svc
    velocityservice = @svc.find_value_by_name("velocity")
    velocity_svc = VelocityService.new(velocityservice)
    return velocity_svc, get_version(velocityservice)
  end

  def purchaseorder_svc
    purchaseorderservice = @svc.find_value_by_name("purchaseorder")
    purchaseorder_svc = PurchaseOrderService.new(purchaseorderservice)
    return purchaseorder_svc, get_version(purchaseorderservice)
  end

  def tax_svc
    tax_svc_config = SoapAgentConfig.new
    tax_svc_config.set_end_point(@svc.find_value_by_name("tax"))
    taxendpoint = @svc.find_value_by_name("tax_wsdl")
    tax_svc = TaxService.new(taxendpoint, tax_svc_config)
    return tax_svc, get_version(@svc.find_value_by_name("tax"))
  end

  def payment_svc
    payment_svc_config = SoapAgentConfig.new
    payment_svc_config.set_end_point(@svc.find_value_by_name("payment"))
    paymentendpoint = @svc.find_value_by_name("payment_wsdl")
    payment_svc = PaymentService.new(paymentendpoint, payment_svc_config)
    return payment_svc, get_version(@svc.find_value_by_name("payment"))
  end

  def storesearch_svc
    storesearch = @svc.find_value_by_name("storesearch")
    storesearch_svc = StoreSearchService.new(storesearch)
    return storesearch_svc, get_version(storesearch)
  end

  # TODO : This service is being moved to the Enterprise Services team
  def tradevalue_svc
    tradevalue = @svc.find_value_by_name("tradevalue")
    tradevalue_svc = TradeValueService.new(tradevalue)
    return tradevalue_svc, get_version(tradevalue)
  end

  def multipass_svc
    multipass = @svc.find_value_by_name("multipass")
    multipass_svc = TradeValueService.new(multipass)
    return multipass_svc, get_version(multipass)
  end

  def loyaltymembership_svc
    config = SoapAgentConfig.new
    config.set_soap_version(1)
    loyaltyenrollment = @svc.find_value_by_name("loyaltyenrollment")
    config.set_end_point(loyaltyenrollment)
    loyalty_membership_svc = Savon::Client.new File.expand_path("#{ENV['QAAUTOMATION_SCRIPTS']}\\GameStop\\dsl\\src\\Services\\LoyaltyMembershipService-V1.wsdl", __FILE__)
    #Need to find another way to determine the version
    return loyalty_membership_svc
  end

  def customerprofile_svc
    config = SoapAgentConfig.new
    config.set_soap_version(1)
    customerprofile = @svc.find_value_by_name("customerprofile")
    config.set_end_point(customerprofile)
    customer_profile_svc = Savon::Client.new File.expand_path("#{ENV['QAAUTOMATION_SCRIPTS']}\\GameStop\\dsl\\src\\Services\\CustomerProfileService-V1.wsdl", __FILE__)
    return customer_profile_svc
  end

#Returns method used for retrieving the build information txt file from individual properties after deployment
  def svc_build_info(env, solution)
    url = "http://#{env}.services.gamestop.com/Ecom/#{solution}/buildinfo.txt"
    build_text_file = []
    open(url) do |f|
      no = 1
      f.each do |lines|
        build_text_file << lines
        no += 1
        break if no > 100
      end
    end
    #version = open(url).source.match(/(^Build Number)(.*)(_\d*\.\d*)/)[3]
    return build_text_file
  end

#Returns the Ecommerce Services Assembly version for each service initialized in the script it's executed from
  def svc_assembly_info(services, services_version)
    #these need to be matched one for one
    services.each_with_index { |y, i|
      svc_name = "#{y.class.name}"
      version_req = y.get_request_from_template_using_global_defaults(:get_assembly_info, Module.const_get("#{y.class.name}RequestTemplates").const_get("GET_ASSEMBLY_INFO#{services_version[i]}"))

      begin
        version_rsp = y.get_assembly_info(version_req.xml)
        version_rsp.code.should == 200
        svc_version = version_rsp.http_body.find_tag("get_assembly_info_result").at(0).content
        $tracer.trace("\nAssembly Information for #{y.class.name}\n")
        $tracer.trace("#{svc_name} : #{svc_version}")
      rescue Exception => ex
        $tracer.trace("#{y.class.name} did not return any assembly infomation...")
      end
    }
  end

  #USAGE value = @params["key"]
  #Collect all the parameters for a given row as defined in the --range paramter from the cmd line parameters.
  #@browser.powerup_rewards_number_field.value = @params["power_up_rewards_number"]
  # @return [Object]
  def get_params_from_csv
    csv_file = QACSV.new(csv_filename_parameter)
    csv_file.find_row_by_name(csv_range_parameter)
  end

  #Retruns the database user and password for the automation service account.
  #dbuser, dbpass = @browser.return_db_creds
  protected
  def return_db_creds
    #if the credentials stop working due to permission issues please see your manager.
    dbuser = "s_dbtfstest"
    dbpass = AES.decrypt("kBr++QdEiKlO9Y37n4fsDA==", {iv: "+ehB/UFhGCq7bLbw3hq/mw=="})[:content]
    return dbuser, dbpass
  end

  def return_user_creds
    #TODO - integrate service account information for running tests remotely
    s_user = "s_tfstest"
    #s_pass = AES.decrypt("", {iv: ""})[:content]
  end

  private
  #Returns the Ecommerce Services version based on the endpoint URI received through the endpoints.csv env range
  def get_version(service_url)
    $tracer.trace("GameStopGlobalServiceFunctionsDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    return (service_url.split("/")[-2].eql? "v1") ? nil : "_#{service_url.split("/")[-2].upcase}"
  end

end

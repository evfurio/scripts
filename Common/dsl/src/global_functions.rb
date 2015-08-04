class GlobalFunctions

  attr_reader :csv, :svc, :sql_file, :db_conn, :prop_url, :login, :password, :id, :desc, :env, :browser

  def initialize
    #ascii_logo # because, why not?
    #welcome_think_geek
    if Object.respond_to?(:csv_filename_parameter, true)
      @csv_file = QACSV.new(csv_filename_parameter)
      @csv = get_csv_row
    else
      $tracer.trace('No CSV dataset defined')
      @csv = ''
    end
    @login = get_account_login
    @password = get_account_password
    @sql_file = get_sql_file
    @svc = get_svc
    @db_conn = get_db_conn
    @prop_url = get_prop_url
    @id, @desc = get_tc_id_and_desc
    @env = get_env
    set_email_notifications
    @browser = get_browser_type
  end

  def password_generator(size)
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    psgen = PasswordGenerator.new
    password = psgen.generate_password(size)
    $tracer.trace(password)
    status, pwd_len = psgen.verify_password(password)
    pwd_len.should <= 50
    pwd_len.should >= 8
    status.should == true
    $tracer.report("#{__method__} : #{password}")
    return password
  end

  def sql_dynamic_constructor(params, filename)
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
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

  #This is a stubbed class reference to invoke common functions within the services realm - DTurner
  def common_function_link
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    return common_functions = CommonFunctionLink.new
  end

  def catalog_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    catalogservice = @svc.find_value_by_name("catalog")
    catalog_svc = CatalogService.new(catalogservice)
    return catalog_svc, get_version(catalogservice)
  end

  def cart_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    cartservice = @svc.find_value_by_name("cart")
    cart_svc = CartService.new(cartservice)
    return cart_svc, get_version(cartservice)
  end

  #Corrected the account_svc initialization code
  def account_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    account_svc_config = SoapAgentConfig.new
    account_svc_config.set_end_point(@svc.find_value_by_name("account"))
    accountendpoint = @svc.find_value_by_name("account_wsdl")
    account_svc = AccountService.new(accountendpoint, account_svc_config)
    return account_svc, get_version(@svc.find_value_by_name("account"))
  end

  def profile_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    profileservice = @svc.find_value_by_name("profile")
    profile_svc = ProfileService.new(profileservice)
    return profile_svc, get_version(profileservice)
  end

  def digitalwallet_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    digitalwallet_svc_config = SoapAgentConfig.new
    digitalwallet_svc_config.set_end_point(@svc.find_value_by_name("digitalwallet"))
    digitalwalletendpoint = @svc.find_value_by_name("digitalwallet_wsdl")
    digitalwallet_svc = DigitalWalletService.new(digitalwalletendpoint, digitalwallet_svc_config)
    return digitalwallet_svc, get_version(@svc.find_value_by_name("digitalwallet"))
  end

  def digitalcontent_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    digitalcontentservice = @svc.find_value_by_name("digitalcontent")
    digitalcontent_svc = DigitalContentService.new(digitalcontentservice)
    return digitalcontent_svc, get_version(digitalcontentservice)
  end

  def shipping_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    shippingservice = @svc.find_value_by_name("shipping")
    shipping_svc = ShippingService.new(shippingservice)
    return shipping_svc, get_version(shippingservice)
  end

  def velocity_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    velocityservice = @svc.find_value_by_name("velocity")
    velocity_svc = VelocityService.new(velocityservice)
    return velocity_svc, get_version(velocityservice)
  end

  def purchaseorder_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    purchaseorderservice = @svc.find_value_by_name("purchaseorder")
    purchaseorder_svc = PurchaseOrderService.new(purchaseorderservice)
    return purchaseorder_svc, get_version(purchaseorderservice)
  end

  def tax_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    tax_svc_config = SoapAgentConfig.new
    tax_svc_config.set_end_point(@svc.find_value_by_name("tax"))
    taxendpoint = @svc.find_value_by_name("tax_wsdl")
    tax_svc = TaxService.new(taxendpoint, tax_svc_config)
    return tax_svc, get_version(@svc.find_value_by_name("tax"))
  end

  def payment_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    payment_svc_config = SoapAgentConfig.new
    payment_svc_config.set_end_point(@svc.find_value_by_name("payment"))
    paymentendpoint = @svc.find_value_by_name("payment_wsdl")
    payment_svc = PaymentService.new(paymentendpoint, payment_svc_config)
    return payment_svc, get_version(@svc.find_value_by_name("payment"))
  end

  def storesearch_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    storesearch = @svc.find_value_by_name("storesearch")
    storesearch_svc = StoreSearchService.new(storesearch)
    return storesearch_svc, get_version(storesearch)
  end

  def tradevalue_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    tradevalue = @svc.find_value_by_name("tradevalue")
    tradevalue_svc = TradeValueService.new(tradevalue)
    return tradevalue_svc, get_version(tradevalue)
  end

  def customerprofile_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    customerprofile_svc = nil
    unless @svc.nil?
      customer_profile_svc_config = SoapAgentConfig.new
      customer_profile_svc_config.set_soap_version(1)
      customer_profile_svc_config.set_end_point(@svc.find_value_by_name("customerprofile"))
      # set path to static wsdl
      customer_profile_svc_wsdl = eval(@svc.find_value_by_name("customerprofile_wsdl"))
      customerprofile_svc = CustomerProfileService.new(customer_profile_svc_wsdl, customer_profile_svc_config)
    end
    return customerprofile_svc
  end

  def customerservice_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    config = SoapAgentConfig.new
    config.set_soap_version(1)
    #This is a CSL channel service, not an ecommerce service
    #http://cslcustomerserviceqa.testgs.pvt/RELEASE/CustomerService.svc
    customerservice = @svc.find_value_by_name("customerservice")
    customerservice_svc = CustomerService.new(customerservice, config)
    return customerservice_svc
  end

  def membership_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    config = SoapAgentConfig.new
    config.set_soap_version(1)
    membershipservice = @svc.find_value_by_name("membershipservice")
    membershipservice_svc = MembershipService.new(membershipservice, config)
    return membershipservice_svc
  end

  def loyaltymembership_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    loyalty_membership_svc = nil
    unless @svc.nil?
      loyalty_membership_svc_config = SoapAgentConfig.new
      loyalty_membership_svc_config.set_end_point(@svc.find_value_by_name("loyaltyenrollment"))
      # set path to static wsdl
      loyalty_membership_svc_wsdl = eval(@svc.find_value_by_name("loyaltychannel"))
      loyalty_membership_svc = LoyaltyMembershipService.new(loyalty_membership_svc_wsdl, loyalty_membership_svc_config)
    end
    return loyalty_membership_svc
  end

  def multipass_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    config = SoapAgentConfig.new
    #May need to remove the soap version.  If it fails due to mismatch contract then take out the line below and run again.
    #config.set_soap_version(1)
    config.set_end_point(@svc.find_value_by_name("multipass"))
    multipassendpoint = @svc.find_value_by_name("multipass_wsdl")
    multipass_svc = ChannelMultipassService.new(multipassendpoint, config)

    return multipass_svc
  end

  def config_svc
    # Uses the basic version of the service and not WSA
    config = SoapAgentConfig.new
    config.set_soap_version(1)
    config_wsdl = @svc.find_value_by_name("configuration")
    config_svc = ConfigurationDataService.new(config_wsdl, config)
    return config_svc
  end
	
	def storeinformation_svc
		$tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    config = SoapAgentConfig.new
    config.set_soap_version(1)
    storeinformationservice = @svc.find_value_by_name("storeinformation")
		storeinformation_svc = StoreInformationService.new(storeinformationservice, config)
    return storeinformation_svc
  end

  def svc_build_info(env, solution)
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
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

  def svc_assembly_info(services, services_version)
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
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
    #return svc_version
  end

  def get_env
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    val = nil
    if Object.respond_to?(:env_parameter, true)
      val = env_parameter
      $tracer.trace("Environment to be tested: #{val}")
    end

    return val
  end

  # TODO : This cannot be required as it does not pertain to services tests.  Framework changes are needed to make this capable of being driven by dataset.
  def get_browser_type
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    val = nil
    if Object.respond_to?(:browser_type_parameter)
      val = browser_type_parameter
      $tracer.trace("Browser type found in command arguments: #{val}")
    elsif @csv.headers.include?("browser")
      val = @csv.find_value_by_name("browser")
      $tracer.trace("Browser type NOT defined in command arguments. \nDefaulting to CSV: #{val}")
    else
      $tracer.trace("Browser type was NOT defined in command arguments nor column browser in the CSV, unable to determine browser type.")
      val = nil
    end
    return val
  end

  def GlobalFunctions.get_random_address_from_pool(state_code = nil)
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    addr_all = QACSV.new("#{ENV['QAAUTOMATION_SCRIPTS']}\\Common\\config\\addr.csv")
    address =  addr_all.find_row_at(rand(0..addr_all.max_row))
    unless state_code.nil?
      addr_subset = addr_all.select {|row|  row.find_value_by_name('p_StateCode') == state_code}
      address = addr_subset[rand(0..addr_subset.length-1)] if addr_subset.length > 0
    end
    addr_to_use = {}
    addr_to_use[:address_line1] = address["p_Address"]
    addr_to_use[:address_line2] = address["p_Address2"]
    addr_to_use[:city] = address["p_City"]
    addr_to_use[:state_or_province] = address["p_State"]
    addr_to_use[:postal_code] = address["p_StateCode"]
    addr_to_use[:country] = address["p_CountryCode"]
    return addr_to_use
  end

private

  def get_version(service_url)
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    return (service_url.split("/")[-2].eql? "v1") ? nil : "_#{service_url.split("/")[-2].upcase}"
  end

  def get_tc_id_and_desc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    id = nil
    desc = nil
    if @csv.headers.include?("ID") && @csv.headers.include?("TestDescription")
      id = @csv.find_value_by_name("ID")
      desc = @csv.find_value_by_name("TestDescription")
    end
    return id, desc
  end

  def get_csv_row
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    val = nil
    if Object.respond_to?(:csv_range_parameter, true)
      val = @csv_file.find_row_by_name(csv_range_parameter)
    else
      raise Exception, "range must be defined in the command line arguments"
    end

    return val
  end

  def get_account_login
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    val = nil
    if respond_to?(:account_login_parameter, true) && (account_login_parameter? == true)
      val = account_login_parameter
      $tracer.trace("Login found in command arguments: #{val}")
    elsif @csv.headers.include?("login")
      val = @csv.find_value_by_name("login")
      $tracer.trace("login was NOT defined in command arguments. \nDefaulting to CSV: #{val}")
    else
      $tracer.trace("Login was NOT defined in command arguments nor column login in the CSV, unable to determine login")
    end

    return val
  end

  def get_account_password
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    val = nil
    if respond_to?(:account_password_parameter, true) && (account_password_parameter? == true)
      val = account_password_parameter
      $tracer.trace("Password found in command arguments: #{val}")
    elsif @csv.headers.include?("password")
      val = @csv.find_value_by_name("password")
      $tracer.trace("Password was NOT defined in command arguments. \nDefaulting to CSV: #{val}")
    else
      $tracer.trace("Password was NOT defined in command arguments nor column password in the CSV, unable to determine password")
    end

    return val
  end

  def get_svc
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    val = nil
    if Object.respond_to?(:svc_parameter, true) && Object.respond_to?(:svc_env_parameter, true)
      val = QACSV.new(svc_parameter).find_row_by_name(svc_env_parameter)
      $tracer.trace("svc and svc_env found in command arguments")
    elsif @csv.headers.include?("Endpoints") && @csv.headers.include?("SVC_ENV")
      endpoints = @csv.find_value_by_name("Endpoints")
      svc_env = @csv.find_value_by_name("SVC_ENV")
      endpoint_csv = "#{ENV['QAAUTOMATION_SCRIPTS']}\\Common\\config\\#{endpoints}"
      val = QACSV.new("#{endpoint_csv}").find_row_by_name(svc_env)
      $tracer.trace("svc or svc_env NOT found in command arguments, \nDefaulting to CSV")
    else
      $tracer.trace("svc and svc_env was NOT defined in command arguments nor column Endpoints and SVC_ENV in the CSV, unable to determine svc")
    end

    return val
  end

  def set_email_notifications
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    val = nil
    if Object.respond_to?(:email_parameter, true)
      $options.email_notify = ("eComQualityAssurance@gamestop.com; CORP-IS-Automation@gamestop.com")
      $tracer.trace("Email notifications have been set to send to: #{$options.email_notify.inspect}")
    else
      $tracer.trace("Email notifications are not set for this test")
    end

    return val
  end

  def get_sql_file
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    val = nil
    if Object.respond_to?(:sql_parameter, true)
      val = sql_parameter
      $tracer.trace("sql found in command arguments: #{val}")
    elsif @csv.headers.include?("SqlQuery")
      sql_file = @csv.find_value_by_name("SqlQuery")
      val = "#{ENV['QAAUTOMATION_SCRIPTS']}/Common/sql_queries/#{sql_file}"
      $tracer.trace("sql NOT found in command arguments, \nDefaulting to CSV: #{val}")
    else
      $tracer.trace("sql NOT defined in command arguments nor column SqlQuery in the CSV, unable to determine sql_file")
    end

    return val
  end

  def get_db_conn
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    val, db_name = nil
    if Object.respond_to?(:db_parameter, true) && Object.respond_to?(:db_env_parameter, true)
      db_name = QACSV.new(db_parameter).find_row_by_name(db_env_parameter)
      $tracer.trace("db and db_env found in command arguments: #{db_name}")
    elsif @csv.headers.include?("Databases") && @csv.headers.include?("DB_ENV")
      #apply values from checkout dataset to get values from the databases csv
      db_svr = @csv.find_value_by_name("Databases")
      db_path = "#{ENV['QAAUTOMATION_SCRIPTS']}/Common/config/#{db_svr}"
      db_n = @csv.find_value_by_name("DB_ENV")
      $tracer.trace(db_n)
      db_name = QACSV.new(db_path).find_row_by_name(db_n)
      $tracer.trace("db or db_env was NOT defined in the command arguments\nDefaulting to CSV: #{db_name.inspect}")
    else
      $tracer.trace("db or db_env was NOT defined in the command arguments nor column Databases or DB_ENV in the CSV, unable to determine db_conn")
    end

    unless db_name.nil?
      if db_name.headers.include?("Server") && db_name.headers.include?("Database")
        server = db_name.find_value_by_name("Server")
        database = db_name.find_value_by_name("Database")

        val = DbManager.new(server, database)
      end
    end

    return val
  end

  def get_prop_url
    $tracer.trace("GlobalFunctions: #{__method__}, Line #{__LINE__}")
    val = nil
    if Object.respond_to?(:prop_parameter, true) && Object.respond_to?(:url_parameter, true)
      val = QACSV.new(prop_parameter).find_row_by_name(url_parameter)
      $tracer.trace("prop and url found in command arguments: #{val}")
    elsif @csv.headers.include?("Property") && @csv.headers.include?("PROP_URL")
      prop_csv = "#{ENV['QAAUTOMATION_SCRIPTS']}\\Common\\config\\#{@csv.find_value_by_name("Property")}"
      val = QACSV.new(prop_csv).find_row_by_name(@csv.find_value_by_name("PROP_URL"))
      $tracer.trace("prop or url were NOT defined in the command arguments\nDefaulting to CSV")
    else
      $tracer.trace("prop or url not defined in command arguments nor column Property or PROP_URL in the CSV, unable to determine prop_url")
    end

    return val
  end



  def ascii_logo
    puts "
            dddddddd
            d::::::d                         CCCCCCCCCCCCC
            d::::::d                      CCC::::::::::::C
            d::::::d                    CC:::::::::::::::C
            d:::::d                    C:::::CCCCCCCC::::C
    ddddddddd:::::d                   C:::::C       CCCCCC   ooooooooooo   nnnn  nnnnnnnn
  dd::::::::::::::d                  C:::::C               oo:::::::::::oo n:::nn::::::::nn
 d::::::::::::::::d                  C:::::C              o:::::::::::::::on::::::::::::::nn
d:::::::ddddd:::::d  --------------- C:::::C              o:::::ooooo:::::onn:::::::::::::::n
d::::::d    d:::::d  -:::::::::::::- C:::::C              o::::o     o::::o  n:::::nnnn:::::n
d:::::d     d:::::d  --------------- C:::::C              o::::o     o::::o  n::::n    n::::n
d:::::d     d:::::d                  C:::::C              o::::o     o::::o  n::::n    n::::n
d:::::d     d:::::d                   C:::::C       CCCCCCo::::o     o::::o  n::::n    n::::n
d::::::ddddd::::::dd                   C:::::CCCCCCCC::::Co:::::ooooo:::::o  n::::n    n::::n
 d:::::::::::::::::d                    CC:::::::::::::::Co:::::::::::::::o  n::::n    n::::n
  d:::::::::ddd::::d                      CCC::::::::::::C oo:::::::::::oo   n::::n    n::::n
   ddddddddd   ddddd                         CCCCCCCCCCCCC   ooooooooooo     nnnnnn    nnnnnn

"

  end

  def welcome_think_geek
    puts "
                                    -/oyhmNNMMMMNmdhs+:.
                       -ohNMMMMNNmmdddddmmmNMMMNho-   `.-..
                    -sNMMMNmhyyyyyyyyyyyyyyyyyhdmNMNmNMMMMMNmho-
                  :dMMMmhyyyyyyyyyyyyyyyyyyyyyyyyyhdhyssssyhmNMMm+`
                .hMMNdyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyss+///////sdMMm/
           .--:/NMNhyyyyyyyyyyyyyyyyyyyyyyhhdmmmNNmmdhys+///////oNMMo
      `/sdmNNNNMMdyyyyyyyyyyyyyyhhddmmNNNNdhyso+++osymNmys+//////+NMM:
    :yNMMmhysoosyyyyyyyyyyyyhmNmddhyso++///:::::://://omNhso//////sMMd
  .yNMNy+/////+syyyyyyyyyymNdy+///:::::::::::::+mNh/:///mMhyo/////+MMM
 -mMMy+///////syyyyyyyyyhMd+/////:::/oo/:::::::dMMh+o///+NNyyo////+MMN
.mMMs////////syyyyyyyyyyNM+//////::/mMm/:::::::yMMMNN////oMmyyo///yMMs
sMMd////////+yyyyyyyyyyyNN///////::oMMNyyo:::::/sdmdo/////dMyys+/+NMm`
NMMy////////syyyyyyyyyyyNM////////:/dMMMMo::::::://///////sMdyyoomMd.
MMMy////////yyyyyyyyyyyydMy//////////oyyo::::::///:////////MNyysNMd.
mMMm///////+yyyyyyyyyyyyyNN+//////////::::+oydmmmmh+///////NNyyyNMy
+MMMs//////+yyyyyyyyyyyyyhNm+////////////oNMMMMMMNd+///////dmNdyNMh
`hMMNs//////yyyyyyyyyyyyyyhNNs////////////syhhyso+//////////+sdNMMy
 `hMMMh+////yhhhhyyyyyyyyyyhmNdo////////////////////////////+y+hMMd
  `oNMMNho+/+hhhhhhhhhyyyyyhdNNd+///////////////////////////yMs+NMM`
    .smMMMmdddhhhhhhhhhhhhmNmy+////////////////////////////+mN++dMM.
      `:sdmNMMdhhhhhhhhhhNNy++//++///////////////////////++sMh++NMM`
          `-NMNdhhhhhhhhNMs+++++mmo//////////////////+++++yNd++sMMh
            :NMNdhhhhhhdMm++++++odNy+++/////////++++++++sdNy++oNMN-
             .dMMmhhhhhdMd++++++++smmhso++++++++++++oshmmho++omMM+
              `oNMNmhhhhNMo+++++++++oydmmdhhyyyyhhdmmmhs++++smMN+
                .oNMNmhhdMmo++++++++++++ossyyyyyyyso++++++ohMMd-
                  `+dMMNddNNhsoo++++++++++++++++++++++ooydMMd/
                     .odNMNNMMmhysoooooooo+++oooooosyhmNMNy:
                        `:oymNMMMMMNmmdddhhhdddmmNMMMMds:`
                              .:/oshdmmNMMMMMNNmhyo/-`
"
  end

end

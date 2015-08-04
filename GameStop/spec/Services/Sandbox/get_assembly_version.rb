#Get Assembly Version from All Services
 #d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Sandbox\get_assembly_version.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_dataset.csv --range "TFS44313" --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA2_V1 --or


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

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
		@cart_svc, @cart_svc_version = @global_functions.cart_svc
		@account_svc, @account_svc_version  = @global_functions.account_svc
		@catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
		@purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
		@shipping_svc, @shipping_svc_version = @global_functions.shipping_svc
		@digitalwallet_svc, @digitalwallet_svc_version = @global_functions.digitalwallet_svc
		@tax_svc, @tax_svc_version = @global_functions.tax_svc
		@profile_svc, @profile_svc_version = @global_functions.profile_svc
		@digitalcontent_svc, @digitalcontent_svc_version = @global_functions.digitalcontent_svc
		@velocity_svc, @velocity_svc_version = @global_functions.velocity_svc
		@payment_svc, @payment_svc_version = @global_functions.payment_svc
		@storesearch_svc, @storesearch_svc_version = @global_functions.storesearch_svc
		
    
		#these need to be matched one for one
		@services = [@cart_svc, @account_svc, @catalog_svc, @purchase_order_svc, @shipping_svc, @digitalwallet_svc, @tax_svc, @profile_svc, @digitalcontent_svc, @velocity_svc, @payment_svc, @storesearch_svc]
		
		@services_version = [@cart_svc_version, @account_svc_version, @catalog_svc_version, @purchase_order_svc_version, @shipping_svc_version, @digitalwallet_svc_version, @tax_svc_version, @profile_svc_version, @digitalcontent_svc_version, @velocity_svc_version, @payment_svc_version, @storesearch_svc_version]

    #set instance variables for csv driven data elements
		initialize_csv_params
		
    end
	
	 it "should get the assembly version from all services" do
		@global_functions.svc_assembly_info(@services, @services_version)
	 
	 
      # @services.each_with_index { |y, i|
        # version_req = y.get_request_from_template_using_global_defaults(:get_assembly_info, Module.const_get("#{y.class.name}RequestTemplates").const_get("GET_ASSEMBLY_INFO#{@services_version[i]}") )
		# begin
			# version_rsp = y.get_assembly_info(version_req.xml)
			# version_rsp.code.should == 200
			# svc_version = version_rsp.http_body.find_tag("get_assembly_info_result").at(0).content
			# $tracer.trace(svc_version)
		# rescue Exception => ex
			# $tracer.trace("#{y.class.name} decided it doesn't want to give up it's secret number...")
		# end
        
        #dump each to file for comparison 
		# }
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
	end
	
	def konami_code_it_is_not(size = 6)
		charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
		(0...size).map{ charset.to_a[rand(charset.size)] }.join
	end
	
	
end
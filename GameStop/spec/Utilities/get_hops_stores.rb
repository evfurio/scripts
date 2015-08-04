##USAGE NOTES
##
##d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Utilities\get_hops_stores.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\hops_dataset.csv --range HOPS03 --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv --url QA_GS --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_hops_product.sql --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --browser chrome -e 'get HOPS urls for POS sysint tests' --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Verify HOPS Functionality" do

  before(:all) do
    #@browser = GameStopBrowser.new("chrome")
	$options.default_timeout = 10_000
    $tracer.mode=:on
	$tracer.echo=:on 
  end

  before(:each) do
	#initializes the csv parameters used by the script
	initialize_csv_params
	
	#Get necessary GUID's per test method execution
	@session_id = generate_guid
	
	#global_functions passes the csv row object and return the parameters.
	@global_functions = GlobalServiceFunctions.new()
	@global_functions.parameters
	@global_functions.csv = @row
	@sql = @global_functions.sql_file
	@db = @global_functions.db_conn
	@catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
	@start_page = @global_functions.prop_url.find_value_by_name("url")
	sql = @sql.to_s
	@results_from_file = @db.exec_sql_from_file("#{sql}") 
  end
  
    it "get HOPS urls for POS sysint tests" do
	#SET num_of_urls to produce the number of URL's you need to test with.  if you want 10 HOPS products, set the number to 10
		num_of_urls = 10
		i = 0
		url = @start_page
		surl = url.gsub!(/http/, "https")
		while i < num_of_urls do
			get_sku_and_store_data
			$tracer.trace("HOPS SKUs")
			hold_request = "#{url}/Orders/HoldRequest.aspx"
			hold_url = "#{hold_request}?store=#{@store}&sku=#{@sku}"
			hold_url = hold_url.chomp
			$tracer.trace(hold_url)
			$tracer.trace(@store)
			$tracer.trace(@sku)
			header = []
			test_info = []
			#dump parameters to a csv for easy import to TFS
			header << "hold_url, store, sku"
			test_info << "#{hold_url},#{@store},#{@sku}"
			path = "#{ENV['QAAUTOMATION_SCRIPTS']}/hops/"
			Dir.mkdir(path) unless File.exists?(path)
			
			test_info.each do |i|
				csv_builder(test_info)
				
				CSV.open("#{path}\\hops_skus.csv", "a") do |csv|
					csv << @data
				end
			end
			i += 1
		end
    end
	
	def initialize_csv_params
		csv = QACSV.new(csv_filename_parameter)
		@row = csv.find_row_by_name(csv_range_parameter)
	end

	def get_product_data
		#############################DSL#####################################
		#call to the catalog service to get the entity.url if the service is up
		### GET_PRODUCT URL### THIS NEEEDS TO BE IN A DSL AND CALLED IN BEFORE EACH
		$tracer.trace("VariantID used for test: #{@sku}")
		@sku = @results_from_file.at(0).variantid
	end
	
	def get_sku_and_store_data		
		store_query = "SELECT top 50 a.[StoreID] as storeid, a.[QtyOnHand] as onhand, d.[ProductID] as productid, d.[Sku] as sku, f.[HopsEnabled] as hopsenabled, f.[StoreNumber] as storenumber
FROM [StoreInformation].[dbo].[StoreInventory] a with (NOLOCK) 
INNER JOIN [StoreInformation].[dbo].[Product] d on a.ProductID = d.ProductID 
INNER JOIN [StoreInformation].[dbo].[Store] f on a.StoreID = f.StoreID
WHERE a.QtyOnHand > 10 and  f.HopsEnabled = 1 ORDER BY NEWID()"
		

		server = "GV1HQDDB50SQL03.testgs.pvt\\INST03"
		database = "StoreInformation"
		dbuser = "s_dbtfstest"
		dbpass = "Gamestop.1"
		
		@db = DbManager.new(server, database, dbuser, dbpass)
		#sql2 = store_query
		@results_from_file = @db.exec_sql("#{store_query}") 
		
		#@sku_match needs to be an array from the list of skus we get back from store information
		sku_match = []
		index = 0
		@results_from_file.each_with_index do |variant, i|
			store = @results_from_file.at(index).storenumber
			sku_match.push(variant.sku,store)
			index += 1
		end
		
		#puts *sku_match
		sku_store_hash = Hash[*sku_match]
		puts sku_store_hash
		
		availability = ""
		ind = 0
		ind_len = sku_store_hash.keys.length
		
		
		sku_store_hash.each_with_index do |(sku, store), i|
			$tracer.trace("THIS IS THE INDEX #{i}")
			begin
				#call to the catalog service to find a product that is available, if not, get the next sku in the array
				get_products_req = @catalog_svc.get_request_from_template_using_global_defaults(:get_products, CatalogServiceRequestTemplates.const_get("GET_PRODUCTS#{@catalog_svc_version}"))
				get_products_request_data = get_products_req.find_tag("get_products_request").at(0)
				get_products_request_data.session_id.content = @session_id       
				get_products_request_data.skus.string.at(0).content = sku
				get_products_rsp = @catalog_svc.get_products(get_products_req.xml)
				$tracer.trace(get_products_req.formatted_xml)
				get_products_rsp.code.should == 200
				$tracer.trace("GET PRODUCTS RESPONSE")
				catalog_get_product_data = get_products_rsp.http_body.find_tag("product").at(0)
				availability = catalog_get_product_data.availability.content.to_s
				can_do_hops = catalog_get_product_data.is_in_store_pickup_for_hops.content.to_s
					$tracer.trace("THIS IS THE FLAG FOR CAN DO HOPS: #{can_do_hops} FOR #{sku}")
					$tracer.trace("THIS IS THE AVAILABILITY: #{availability} FOR #{sku}")
					#$tracer.trace(get_products_rsp.formatted_xml)
					$tracer.trace("\tTHIS IS THE INDEX #{ind}\n\n")
				@sku = sku.to_s
				@store = store.to_s
					$tracer.trace("\tTHIS IS THE SKU NUMBER #{@sku}\n\n")
					$tracer.trace("\tTHIS IS THE STORE NUMBER #{@store}\n\n")
				# ind += 1
			rescue Exception => ex
				@sku = sku.to_s
				@store = store.to_s
				# ind += 1
				$tracer.trace("THIS IS THE INDEX #{ind} OF #{ind_len}")
				$tracer.trace("CRITERIA NOT MET, KEEP LOOKING FOR YOUR DROIDS")
				#break if ind_len == ind
			end
			break if (can_do_hops == "true" && availability == "A")
		end
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
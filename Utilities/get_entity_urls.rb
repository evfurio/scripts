##USAGE NOTES
##
##d-Con --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Utilities\get_entity_urls.csv --range GETURL_CERT --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv --url CERT_GS --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_1000_products.sql --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env CERT_GS --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "CERT_Catalog" %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Utilities\get_entity_urls.rb --or


#-csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Utilities\get_entity_urls.csv --range GETURL_CERT
##author: dturner

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Verify CERT Product URLs" do

  before(:all) do
    $options.default_timeout = 10_000
    $tracer.mode=:on
    $tracer.echo=:on
  end

  before(:each) do
	
    #global_functions passes the csv row object and return the parameters.
	
    csv = QACSV.new(csv_filename_parameter)
    @row = csv.find_row_by_name(csv_range_parameter)
	
    @global_functions = GlobalServiceFunctions.new()
    @global_functions.parameters
    @global_functions.csv = @row
    @sql = @global_functions.sql_file
    @db = @global_functions.db_conn
    @catalog_svc, @catalog_svc_version = @global_functions.catalog_svc

  end

  
  it "should get products and confirm they are available in CS and Endeca" do

		product_urls, results_from_file = load_test_skus_from_db(@db, @sql, @catalog_svc, @catalog_svc_version)
		puts product_urls

    product_urls.each do |url|
      header = []
			test_info = []
      path = "http://cert.gamestop.com"
      url_path = path + url
			#dump parameters to a csv for easy import to TFS
			header << "path"
			test_info << "#{url_path}"
			path = "#{ENV['QAAUTOMATION_SCRIPTS']}/cert_urls/"
			Dir.mkdir(path) unless File.exists?(path)

			test_info.each do |i|
				csv_builder(test_info)

				CSV.open("#{path}\\cert_urls.csv", "a") do |csv|
					csv << @data
				end
			end
    end
  end
   
  def load_test_skus_from_db(db, sql, catalog_svc, catalog_svc_version)
    product_urls = Array.new
    matured_product = false
    physical_product = false
    results_from_file = db.exec_sql_from_file("#{sql}")
    number_of_products = results_from_file.length
    while product_urls.length < number_of_products
      #Get necessary GUID's per test method execution
      session_id = generate_guid
      results_from_file.each do |sku|
        begin
          product_urls << catalog_svc.perform_get_product_url(catalog_svc_version, session_id, sku.variantid)
        rescue
          puts "Bad Sku #{sku.variantid}, carry on"
        end
        #matured_product = (sku.esrbrating.eql?("M") ? true : false ) if !matured_product
        # We want this if we have any physical products because we're going to use it to determine whether a shipping address is needed/to be checked
        #physical_product = (sku.condition.eql?("Digital") ? false : true ) if !physical_product
        puts sku.url
      end
      if product_urls.length < number_of_products
        results_from_file = db.exec_sql_from_file("#{sql}")
      end
    end
    return product_urls, results_from_file
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
#This is a base template to construct new UI based scripts from.  
#
# DO NOT SAVE TO THIS FILE.  Make a copy and rename it for whatever test you are constructing.

# Usage Notes
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\PROD\maintenace_page_akamai_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\PROD\prod_dataset.csv --range TFSPRODAKA --browser ie-webspec --prop PROD_EB --or


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Production Maintenance Page Cache Test" do

  before(:all) do
    $options.default_timeout = 1_000
	$tracer.mode=:on
	$tracer.echo=:on 
	@browser = GameStopBrowser.new(browser_type_parameter)
  end

  before(:each) do  
	csv = QACSV.new(csv_filename_parameter)
	@row = csv.find_row_by_name(csv_range_parameter)
	
	@global_functions = GlobalServiceFunctions.new()
	@global_functions.csv = @row
	@global_functions.parameters
	@start_page = @global_functions.prop_url.find_value_by_name("url")
			
  end

  after(:each) do
    @browser.return_current_url
  end
 
  after(:all) do
	@browser.close_all()
  end
  
  it "should open the www and origin page and get ip" do
	i = 1
	while i > 0 do
		get_www_response
		get_origin_response
		@browser.cookie.all.delete
		#i -= 1
	end
	
  end
  
  
  def get_www_response
	@browser.cookie.all.delete
	myst_page = "http://www.ebgames.com/pc/games/myst-masterpiece-edition/92753"
	@browser.open(myst_page)
	@browser.wait_for_landing_page_load
	sleep 5
	url = get_url_data(@browser).full_url
	server_ip = @browser.server_ip_address
	client_ip = get_ip
	time = date_time_to_string
	
	#$tracer.trace("THIS URL: #{get_url_data(@browser).full_url}")
    #$tracer.trace("SERVER IP: #{@browser.server_ip_address}")
	#$tracer.trace("Client IP #{client_ip}")
	#$tracer.trace("AT THIS TIME #{date_time_to_string}")
	
	results_to_csv(url, server_ip, client_ip, time)
  end
  
  def get_origin_response
	@browser.cookie.all.delete
	origin_myst_page = "http://origin-www.ebgames.com/pc/games/myst-masterpiece-edition/92753"
	@browser.open(origin_myst_page)
	@browser.wait_for_landing_page_load
	sleep 5
	url = get_url_data(@browser).full_url
	server_ip = @browser.server_ip_address
	client_ip = get_ip
	time = date_time_to_string
	
	#$tracer.trace("THIS URL: #{get_url_data(@browser).full_url}")
	#$tracer.trace("SERVER IP: #{@browser.server_ip_address}")
	#$tracer.trace("Client IP #{client_ip}")
	#$tracer.trace("AT THIS TIME #{date_time_to_string}")
	
	results_to_csv(url, server_ip, client_ip, time)
  end
  
  def results_to_csv(url, server_ip, client_ip, time)
		dump_to_csv = "true"
		
		if dump_to_csv == "true"
			header = []
			test_info = []
			header << "url, server_ip, client_ip, time"
			test_info << "#{url},#{server_ip},#{client_ip},#{time}"
			path = "#{ENV['QAAUTOMATION_SCRIPTS']}/maintenance_page_report/"
			Dir.mkdir(path) unless File.exists?(path)
			
			test_info.each do |i|
				csv_builder(test_info)
				
				CSV.open("#{path}\\maintenance_page_test.csv", "a") do |csv|
					csv << @data
				end
			end
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
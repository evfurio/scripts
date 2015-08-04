##USAGE NOTES
## For testing queries against dbmanager
## d-Con .\TEST_database_queries.rb --sql .\Get_Distinct_Available_Products.sql --db .\databases.csv --db_env "QA_Catalog" --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

describe "Test various DB Query Types" do

	before(:all)do
		$tracer.mode = :on
        $tracer.echo = :on
		
		db = QACSV.new("#{db_parameter}")
		@db_name = db.find_row_by_name(db_env_parameter)
		
		@server = @db_name.find_value_by_name("Server")
		@database = @db_name.find_value_by_name("Database")	
		#create the new instance of dbmanager
		@sql = "/sql_queries/#{sql_parameter}"
		#@db = DbManager.new(server, database)	
		@browser = GameStopBrowser.new
	end

	it "should connect_to_database" do	
		puts @sql
		sql_data = []
		#will need to create a function that strips all tabs and newlines from the input file.  will help in reducing maintenance on the sql query files
		path_abs = File.expand_path(File.dirname(__FILE__))
		sql_file  = File.open("#{path_abs}#{@sql}") do |f|
			no = 1
			f.each do |lines|
				lines.gsub("\n","")
				lines.gsub("\t","")
				sql_data << lines
				no += 1
				#break if no > 500
			end
			#using .join to get rid of the bracket and double quotes that are printed when using .to_s
			@sql = sql_data.join
		end
		sql_str = @sql
		#sql_str is the stripped sql statmenet required to pass to the sql server to return results.  it cannot have any newlines or tabs.  whitespaces are okay.
		#rows holds the results of the database query
		puts @server
		puts @database
		product =  @browser.get_database_results_svc(@server, @database, "#{sql_str}")
		puts product.inspect
		puts product.class
		
	end

end
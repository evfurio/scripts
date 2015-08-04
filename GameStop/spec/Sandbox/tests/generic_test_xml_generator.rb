#########
##USAGE##
#########

## 
## d-con %QAAUTOMATION_SCRIPTS%\GameStop\spec\Sandbox\generic_test_xml_generator.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv
##

#qaautomation_dir = ENV['QAAUTOMATION_FILES']
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "csv"

class MakeGenTestXMLs

  
	def underscore(str)
        str.gsub(/ /, "_")
    end

    # Capitalizes the first character of every word, leaving spaces untouched.
    # === Parameters:
    # _str_:: user specified string
    def camel_leave_spaces(str)
        str.scan(/[a-zA-Z]| /).join.split(' ').map { |w| "#{w.capitalize} "}.join.rstrip
    end

    # Removes the ending forward or backward slash from a string.
    # === Parameters:
    # _str_:: user specified string
    def chomp_slashes(str)
        str = str.chomp('/').chomp('\\') unless str.nil?
        return str
    end

	def build_xml
	   $tracer.mode = :on
	   csv = QACSV.new(csv_filename_parameter)
	   path = "#{ENV['QAAUTOMATION_SCRIPTS']}/xml/"
	   argument_csv = "%QAAUTOMATION_SCRIPTS%#{csv_filename_parameter.sub(ENV['QAAUTOMATION_SCRIPTS'], '')}"
	   Dir.mkdir(path) unless File.exists?(path)
	   
       csv.each  do |row |
		  tfs_id = row.find_value_by_name("ID")	 
		   test_name = underscore(row.find_value_by_name("TestDescription"))
		   script_name =row.find_value_by_name("ScriptName")
		   test_id = generate_guid
		   project = row.find_value_by_name("Project")
		   agruments =  "#{script_name} --range #{tfs_id} --csv #{argument_csv} --or"
		   	header = []
			test_info = []
			#dump parameters to a csv for easy import to TFS
			header << "tfsid, testname, filename, arguments, testid, project"
			test_info << "#{tfs_id},#{test_name},#{tfs_id}_#{test_name}.generictest,#{agruments},#{test_id},#{project}"
			
			
			test_info.each do |i|
				csv_builder(test_info)
				
				CSV.open("#{path}\\checkout_scenario_test_info.csv", "a") do |csv|
					csv << @data
				end
			end
					#dump the data sets into rows of the csv.
			
			
		   generic_test_template  =  get_template(tfs_id, test_name, agruments, test_id)
			
  	       File.open("#{path}#{tfs_id}_#{test_name}.generictest", "w") do |f|     
               f.write(generic_test_template)   
           end
        end
		$tracer.trace("PLEASE FIND XML FILES IN #{path} ")
		
	end
	
	
	private 
	def get_template tfs_id, test_name, agruments, test_id
	
	return <<eos
<?xml version="1.0" encoding="UTF-8"?>
<GenericTest name="#{tfs_id}_#{test_name}" storage="#{tfs_id}_#{test_name}.generictest" id="#{test_id}" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010">
	<Command filename="%QAAUTOMATION_TOOLS%\\QAAutomation\\bin\\d-Con.bat" arguments="#{agruments} " workingDirectory="%QAAUTOMATION_TOOLS%\\QAAutomation\\bin">
		<EnvironmentVariables>
			<EnvironmentVariable name="qaautomation_tools" value="C:\\dev\\QAAutomationCurrent" />
			<EnvironmentVariable name="path" value="%QAAUTOMATION_TOOLS%\\QAAutomation\\bin;C:\Program Files (x86)\\Sikuli X\\libs;C:\\Program Files (x86)\\Java\\jre6\\bin" />
		</EnvironmentVariables>
	</Command>
<SummaryXmlFile path="%TestOutputDirectory%\\&lt;Enter summary file name here&gt;" />
</GenericTest>
eos
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


m = MakeGenTestXMLs.new
m.build_xml
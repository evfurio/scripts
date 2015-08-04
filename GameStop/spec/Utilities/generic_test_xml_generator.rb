#########
##USAGE##
#########

## 
## d-con %QAAUTOMATION_SCRIPTS%\GameStop\spec\Utilities\generic_test_xml_generator.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\hops_dataset.csv
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
    str.scan(/[a-zA-Z]| /).join.split(' ').map { |w| "#{w.capitalize} " }.join.rstrip
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
    Dir.mkdir("#{path}gen_tests") unless File.exists?("#{path}gen_tests")
    Dir.mkdir("#{path}ps_scripts") unless File.exists?("#{path}ps_scripts")

    csv.each do |row|
      tfs_id = row.find_value_by_name("ID")
      login = row.find_value_by_name("login")
      if login == "" || login == nil
        login = false
      end
      password = row.find_value_by_name("password")
      test_name = underscore(row.find_value_by_name("TestDescription"))
      script_name =row.find_value_by_name("ScriptName")
      test_id = generate_guid
      project = row.find_value_by_name("Project")
      raw_id = tfs_id.gsub(/TFS/,'')

      if login == false
        arguments = "#{script_name} --csv #{argument_csv} --range #{tfs_id} --or"
      else
        arguments = "#{script_name} --csv #{argument_csv} --range #{tfs_id} --login #{login} --password #{password} --or"
      end

      header = []
      test_info = []
      #dump parameters to a csv for easy import to TFS
      header << "tfsid, testname, filename, arguments, script_name, testid, project, login, password"
      test_info << "#{tfs_id.gsub(/TFS/,'')},#{test_name},#{tfs_id}_#{test_name}.generictest,#{arguments},#{script_name},#{test_id},#{project},#{login},#{password}"

      test_info.each do |x|
        File.open("#{path}\\exe_commands.txt", "a") { |f| f.puts("d-con #{arguments}\n")}
      end

      test_info.each do |z|
        File.open("#{path}\\tfs_id.txt", "a") { |tfs| tfs.print("#{raw_id},")}
      end

      test_info.each do |i|
        csv_builder(test_info)

        CSV.open("#{path}\\checkout_scenario_test_info.csv", "a") do |csv|
          csv << @data
        end
      end
      #dump the data sets into rows of the csv.


      generic_test_template = get_template(tfs_id, test_name, arguments, test_id)

      File.open("#{path}gen_tests/#{tfs_id}_#{test_name}.generictest", "w") do |f|
        f.write(generic_test_template)
      end

      ps_template = ps_template(arguments, raw_id, test_name)

      File.open("#{path}ps_scripts/#{raw_id}.ps1", "w") do |ps|
        ps.write(ps_template)
      end

    end
    $tracer.trace("PLEASE FIND XML FILES IN #{path} ")

  end


  private
  def get_template tfs_id, test_name, arguments, test_id

    return <<eos
<?xml version="1.0" encoding="UTF-8"?>
<GenericTest name="#{tfs_id}_#{test_name}" storage="#{tfs_id}_#{test_name}.generictest" id="#{test_id}" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010">
	<Command filename="%QAAUTOMATION_TOOLS%\\QAAutomation\\bin\\d-Con.bat" arguments="#{arguments} " workingDirectory="%QAAUTOMATION_TOOLS%\\QAAutomation\\bin">
		<EnvironmentVariables>
			<EnvironmentVariable name="qaautomation_tools" value="C:\\dev\\QAAutomationCurrent" />
			<EnvironmentVariable name="path" value="%QAAUTOMATION_TOOLS%\\QAAutomation\\bin;C:\Program Files (x86)\\Sikuli X\\libs;C:\\Program Files (x86)\\Java\\jre6\\bin" />
		</EnvironmentVariables>
	</Command>
<SummaryXmlFile path="%TestOutputDirectory%\\&lt;Enter summary file name here&gt;" />
</GenericTest>
eos
  end

  def ps_template(arguments, raw_id, test_name)
    return <<eos
set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\\bin

powershell /c d-Con #{arguments}
if ($LastExitCode -eq 1)
    {Write-Host "Test Case #{raw_id} #{test_name} Failed\n#{arguments}"}
eos
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
end


m = MakeGenTestXMLs.new
m.build_xml
#performance collector

require 'fileutils'
require 'csv'

class CollectPerfMon

	def collector(server_name, directory, counter_name, file_name)
		#this use of Dir doesn't work... whhhhhyyyyyy!!?!?!?!
		this_path = "\\\\#{server_name}\\#{directory}\\#{counter_name}\\"
		my_dir = Dir[this_path]
		file = find_last_modified(my_dir)
		puts file
		this_dir = Dir["\\\\#{server_name}\\#{directory}\\#{counter_name}\\#{file}\\*.blg"]
		#my_dir = Dir["C:/Documents and Settings/user/Desktop/originalfiles/*.doc"]
		this_dir.each do |filename|
		  name = File.basename('Performance Counter', '.blg')[0,4]
		  dest_folder = "#{ENV['QAAUTOMATION_SCRIPTS']}/performance/#{server_name}/#{name}/"
		  FileUtils.cp(filename, dest_folder)
		end
		
	end
		
	def get_servers
		csv_path = "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/spec/Utilities/cert_servers.csv"
		servers = {}
		CSV.foreach(csv_path, :headers => true, :header_converters => :symbol, :converters => :all ) do |row|
			servers[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
			puts servers[row.fields[0]][:server_name]
			collector(servers[row.fields[0]][:server_name], servers[row.fields[0]][:directory], servers[row.fields[0]][:counter_name], servers[row.fields[0]][:file])	
		end
				
	end
	
	def find_last_modified(dir)
		puts dir
		last = Dir.glob("#{dir}\*").max_by{|f| File.mtime(f)}
		return last
	end
	
end

m = CollectPerfMon.new
m.get_servers
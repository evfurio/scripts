#!/usr/bin/env ruby
require 'fileutils'

class ModHost

	#hardcoding the path to HOSTS, probably not going to change often ;)
	HOSTS_FILE = "c:/windows/system32/drivers/etc/hosts"

	#used as a delimeter to evaluate whether or not the entries had already been applied, in situations where the script is aborted before clean up, we can use this check to clean up before running again.
	NEW_HOSTS = "##########TEMPORARY##########\n"
	
	def self.hosts_inject(inject_hosts)
		#my_hosts_file needs to be dynamically driven based on what the analyst is testing.  
		#hosts files are created per property to inject those specific entries into the users HOSTS file
		@injected_file = inject_hosts
	end

	
	#This method is checking for the delimeter that was injected into the HOSTS file
	def self.contains_entry?
	  contains = false
	  file = File.new(HOSTS_FILE, "r")
	  
	  #getting the time of the file, might use this for something useful.  right now it's only printing the file time to the console
	  p File.ctime(HOSTS_FILE)
	  while (line = file.gets)
		if line == NEW_HOSTS
		  contains = true
		end
	  end
	  file.close  
	  contains
	end

	# this method is for reading the file content from the custom HOSTS file that we're going to use to inject into the system HOSTS file.
	def self.add_entry
	  new_content = file_content @injected_file
	  open(HOSTS_FILE, 'a') do |f|
		f << "\n#{new_content}\n"
	  end
	end

	# this method will create the backup file, if a backup file exists already it will increment by 1 and will append the integer to the file name.
	def self.file_content file_name=HOSTS_FILE
	  
	  begin
		filename = File.realpath(file_name)
			bkup = filename + ".backup"
				backup_files = Dir.glob(bkup + "*").sort_by do |f|
					f.match(/\d+$/)
					$&.nil? ? 0 : $&.to_i
				end
			backup_files.reverse.each do |fname|
				if m = fname.match(/\.backup\.(\d+)$/)
					File.rename(fname, "%s.%d" % [bkup, m[1].to_i + 1])
				elsif fname == bkup
					File.rename(bkup, bkup + ".1")
				end
		
			end
	  rescue Exception => ex
		puts "OOPS, the backup wasn't destroyed the last time you ran this script"
	  end  
		#read the file
	  content = ""
	  file = File.open(file_name, "r")
	  while (line = file.gets)
		content += "#{line}"
	  end
	   file.close 
	  content
	end

	# this is main method that will orchestrate the process.  it will detect the delimeter as set above, make a copy of the existing HOSTS file and rename it hosts.backup.1, adds the entries from the custom HOSTS
	def self.main file_name=HOSTS_FILE
	  if contains_entry?
		puts ">>>WARNING: Contents of new hosts is already in the the hosts destination"
		mess_cleaner
		#create a backup of the existing file before applying changes
		FileUtils.cp file_name, file_name + ".backup"
		#Add entry to the hosts file
		add_entry
		puts ">>> NEW HOSTS DELIVERED!\n"
		puts file_content
	  else
		#create a backup of the existing file before applying changes
		FileUtils.cp file_name, file_name + ".backup"
		#Add entry to the hosts file
		add_entry
		puts ">>> NEW HOSTS DELIVERED!\n"
		puts file_content
	  end
	end

	def self.mod_hosts(file) file_expected=HOSTS_FILE
		hosts_inject(file)
		begin
			#This simply verifies that the original file is still there.
			filechk = File.realpath(file_expected)
		rescue Exception => ex
			puts "########################  ERROR  #########################"
			puts "Hosts file not found, I probably screwed your file.  Sorry\n\n"
			puts "GO TO c:/windows/system32/drivers/etc and rename hosts.backup to hosts.\n This should fix your problem.\n"
			puts "########################  ERROR  #########################"
		end
		system "clear"
		main
	end

	def self.mess_cleaner file_name=HOSTS_FILE
		filename = File.realpath(file_name)
		backup = "#{filename}.backup.1"
		puts "BACKUP FILE NAME: #{backup}"
		if File.exist?(backup)
			FileUtils.rm filename, :force => true
			revert = backup.gsub(".backup.1","")
			FileUtils.mv(backup,revert)
			puts "Replaced #{backup} with #{revert}"
		end
	end
end

	#ModHost.mod_hosts("hosts.ebgames")
	#ModHost.mess_cleaner
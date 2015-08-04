#!/usr/bin/env ruby
require 'fileutils'

HOSTS_FILE = "c:/windows/system32/drivers/etc/hosts"
MY_HOSTS_FILE = "hosts.ebgames"
NEW_HOSTS = "##########TEMPORARY##########\n"


def contains_entry?
  contains = false
  file = File.new(HOSTS_FILE, "r")
  p File.ctime(HOSTS_FILE)
  while (line = file.gets)
    if line == NEW_HOSTS
      contains = true
    end
  end
  file.close  
  contains
end


def add_entry
  new_content = file_content MY_HOSTS_FILE
  open(HOSTS_FILE, 'a') do |f|
    f << "\n#{new_content}\n"
  end
end


def file_content file_name=HOSTS_FILE
  #create a backup of the existing file
  
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
	File.rename(filename, bkup)

  
  rescue Exception => ex
	puts "OOPS, the backup wasn't destroyed the last time you ran this script"
  end  
    #read the file
  content = ""
  file = File.open(file_name, "r")# {|handle| yield handle}
  while (line = file.gets)
    content += "#{line}"
  end
   file.close 
  content
end

def main
  if contains_entry?
	#contents of new hosts is already in the the hosts destination
  else

    add_entry
    
    puts ">>> NEW HOSTS DELIVERED!\n"
    puts file_content
  end
end

def mod_hosts file_expected=HOSTS_FILE
	
	begin
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

mod_hosts
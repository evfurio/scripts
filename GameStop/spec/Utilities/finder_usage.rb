require 'json'

funcHash = Hash.new
scriptHash = Hash.new
usedFindersHash = Hash.new
notUsedFindersHash = Hash.new

puts "Searching for finders in #{ENV['QAAUTOMATION_SCRIPTS']}.."
Dir["#{ENV['QAAUTOMATION_FINDERS']}/**/*finder*rb"].each { |file|
  functions = File.readlines(file).select {|line| line =~ /^\s*def/}
  functions.map! {|line| line.chomp.strip.sub(/def\s*/,'').delete "()"}
  funcHash[file] = functions if functions.length > 0
}
puts "#{funcHash.values.flatten.count} finders located in #{funcHash.count} files named *finder*rb under #{ENV['QAAUTOMATION_FINDERS']}\n"

puts "Reading all ruby files in #{ENV['QAAUTOMATION_SCRIPTS']} ..."
Dir["#{ENV['QAAUTOMATION_SCRIPTS']}/**/*rb"].each {|file|
  scriptHash[file] = File.open(file, "r").read
}
puts "#{scriptHash.length} *rb files found in under #{ENV['QAAUTOMATION_SCRIPTS']}"

# for each finder file
funcHash.each {|finder_file, finders|
  # for each finder
  finders.each {|finder_name|
    usage_count = 0
    # search through every script source file summing up occurrences of the finder
	# the value part of the hash is the content for each file
    scriptHash.each {|script_name, script_content|
	  usage_count += script_content.scan(/#{finder_name}/).length
	}
	findersHash = (usage_count == 0) ? notUsedFindersHash : usedFindersHash
    finders_arr = findersHash[finder_file]
    finders_arr = Array.new if finders_arr.nil?
	finder_rep = (usage_count == 0) ? finder_name : finder_name + ' ==> ' + usage_count.to_s
    finders_arr << finder_rep
    findersHash[finder_file] = finders_arr
  }
}

puts "#{notUsedFindersHash.values.flatten.count} finders have not been used"
puts "#{usedFindersHash.values.flatten.count} finders have been used\n"
puts "See files generated - not_used_finders.txt and used_finders.txt"

File.open('not_used_finders.txt', "w") do |file|
  file.puts JSON.pretty_generate(notUsedFindersHash)
end
File.open('used_finders.txt', "w") do |file|
  file.puts JSON.pretty_generate(usedFindersHash)
end




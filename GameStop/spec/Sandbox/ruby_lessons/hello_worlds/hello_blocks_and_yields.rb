def yo(& block)
	print "\t\tShould be an object location #{block.inspect}\n"
	puts "\t\t\tShould be Proc: #{block.class}\n"
	yield
end

3.times do |i|
	yo do
		puts 'hello world'
	end
end
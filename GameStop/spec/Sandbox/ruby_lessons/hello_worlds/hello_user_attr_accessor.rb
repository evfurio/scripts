user = ENV['USERNAME']
salutations = "Hello"

class GetHello
	
	attr_accessor :salutations

	def initialize(salutations)
		@salutations = salutations
	end

end

greeting = GetHello.new(salutations)
puts "#{greeting.salutations} #{user}"
class EnumTestAndStuff
  include Enumerable

  attr_accessor :array, :name

  def initialize(name)
    @name = name
    @array = []
  end

  def each(&block)
    @array.each do |i|
      yield(i)
    end
  end
  
end

beings = []
rainbows = EnumTestAndStuff.new("rainbows")
beings << rainbows.array = ["unicorns","nyancats","leprechauns"]
n = 1
add_one = lambda { |n| n + 1 }; 

rainbows.each do |p|
  if beings == "nyancats"
	beings = beings.map &add_one
  end
  puts p + "\n add #{n.to_s}"
end

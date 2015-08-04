require 'benchmark'

def bubble_sort(a)
  i = 0

  while i < a.size
    j = a.size - 1
    while (i < j)
      if a[j] < a[j - 1]
        temp = a[j]
        a[j] = a[j - 1]
        a[j - 1] = temp
      end
      j-=1
    end
    i+=1
  end

  return a

end

big_array = Array.new
big_array_sorted = Array.new

IO.foreach("1000RanNum.txt", $\ = ' '){|num| big_array.push num.to_i }
puts Benchmark.measure {big_array_sorted = bubble_sort(big_array)}

File.open("output_bubble_sort.txt", "w") do |out|
  out.puts big_array_sorted
  puts big_array_sorted
end

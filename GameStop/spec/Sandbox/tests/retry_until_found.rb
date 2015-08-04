### retry logic
#put this in the common_functions.rb
#replace all instances of the sleep function with this logic where the script is waiting on a specific element to be evaluated.  only use in places where elements are typically problematic.  Default timeout will be set to 15 seconds.

# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Sandbox\retry_until_found.rb --or

require 'timeout'

class Retry

#method receives a value to wait for and when it is found it continues with the script, if not it gracefully fails with an exception message
	def retry_until_found(value1 = nil)

	i = 0
		begin
			status = Timeout::timeout(10) {
				while(value1).nil?
				  sleep 1
				  if i == 5
					value1 = true
				  end
				  puts "sleep #{i}"
				  @count = i += 1
				end
			break; 
			}
			puts "Script retried #{@count} attempts before the content was found"
		rescue Timeout::Error
			puts "Cannot retrieve the order confirmation number"
		end
	end
end


check_for_element = Retry.new()
check_for_element.retry_until_found()
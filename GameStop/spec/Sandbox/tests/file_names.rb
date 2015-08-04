require 'ostruct'

module FileName
	def create_file
		time = Time.new
		day = time.day
		month = time.month
		year = time.year
		hour = time.hour
		min = time.min
		append = "_cart.php"
		filename_const = year.to_s + month.to_s + day.to_s + hour.to_s + min.to_s + append
		
		$namefile = OpenStruct.new({:filename=> filename_const})
		
	end
end
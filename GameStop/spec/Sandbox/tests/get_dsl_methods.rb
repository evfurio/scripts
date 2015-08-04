require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"


class GetMethods

	def get_dsl_methods
		browser = GameStopBrowser.new("chrome")
		#puts browser.methods
		
	end
	
end

m = GetMethods.new
m.get_dsl_methods
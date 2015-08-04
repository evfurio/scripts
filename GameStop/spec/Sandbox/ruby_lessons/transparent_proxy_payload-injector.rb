require 'webrick'
require 'webrick/httpproxy'
#require 'webrick-patches'

include WEBrick

class WEBrick::HTTPRequest

	def update_uri(uri)
		@unparsed_uri = uri
		@request_uri = parse_uri(uri)
	end

end


def run_sinus(config ={})
	config.update(:Port => 8080)
	config.update(:RequestCallback => Proc.new{|req,res| puts req.request_line, req.raw_header, res.body})
	sinus = WEBrick::HTTPProxyServer.new(config)
	
	yield server if block_given?
		['INT', 'TERM'].each {|signal| trap(signal) {sinus.shutdown}}

	sinus.start
end

run_sinus()
puts "Sinus is running...\n"
#require 'webrick-patches'
require 'webrick/httpproxy' 

include WEBrick

def start_webrick(config ={})
	config.update(:Port => 8080)
	config.update(:RequestCallback => Proc.new{|req,res| puts req.request_line, req.raw_header, res.body})
	sinus = HTTPProxyServer.new(config)
	
	yield server if block_given?
		['INT', 'TERM'].each {|signal| trap(signal) {sinus.shutdown}}

	sinus.start
end

#server_logger = Log.new(’/log/webrick/server.log’)
#access_log_stream = File.open(’/log/webrick/access.log’, ’w’)
#access_log = [ [ access_log_stream, AccessLog::COMBINED_LOG_FORMAT ] 

start_webrick(
#:Logger => server_logger,
#:AccessLog => access_log
)


# ####
# notes: moving directories around is fun.
# qaautomation_scripts/lib/gslib/core/auxiliary/fuzzer.rb
#
# module Gslib
#
#   module Auxilliary::Fuzzer
#
#   end
#
# end
#
#
# target
# environment
# virt_internal
# virt_external
#
# disperse_to_cloud
#
# sequence
# chain
# seed_pattern
#
#
# :vhost => vhost,
# :host => rhost,
# :port => port,
# :query => query,
# :seed => ""
#
#
# opts['Port'].to_s 	=~ /^(6553[0-5]|655[0-2]\d|65[0-4]\d\d|6[0-4]\d{3}|[1-5]\d{4}|[1-9]\d{0,3}|0)$/ ? port = Integer(opts['Port']) : port = @DefaultPort
# opts['Uri'].to_s  	=~ /^\/?([a-zA-Z0-9\-\._\?\,\'\/\\\+&amp;%\$#\=~])+$/ ? uri = opts['Uri'].to_s : uri = @DefaultUri
#
#
# opts = {}
# opts[:user_agent]      = datastore['UserAgent']
# opts[:verbose]         = false
# opts[:threads]         = max_crawl_threads
# opts[:obey_robots_txt] = false
# opts[:redirect_limit]  = datastore['RedirectLimit']
# opts[:retry_limit]     = datastore['RetryLimit']
# opts[:accept_cookies]  = true
# opts[:depth_limit]     = false
# opts[:skip_query_strings]  = false
# opts[:discard_page_bodies] = true
# opts[:framework]           = framework
# opts[:module]              = self
# opts[:timeout]             = get_connection_timeout
# opts[:dirbust]             = dirbust?
#
# opts[:inject_headers] = t[:headers]
#
# opts[:cookies] = t[:cookies]
#
# opts[:username] = t[:username] || ''
# opts[:password] = t[:password] || ''
# opts[:domain]   = t[:domain]   || 'WORKSTATION'
#
# path,query = datastore['URI'].split('?', 2)
#
#
# def link_filter
#   /\.(js|png|jpe?g|bmp|gif|swf|jar|zip|gz|bz2|rar|pdf|docx?|pptx?)$/i
# end
# Copyright (C) 2008 Brian Candler, released under Ruby Licence.
#
# A collection of small monkey-patches to webrick.

require 'webrick'

module WEBrick

  class HTTPRequest
    # Generate HTTP/1.1 100 continue response. See
    # http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/18459
    def continue
      if self['expect'] == '100-continue' && @config[:HTTPVersion] >= "1.1"
        @socket.write "HTTP/#{@config[:HTTPVersion]} 100 continue\r\n\r\n"
        @header.delete('expect')
      end
    end
  end

  class HTTPResponse
    alias :orig_setup_header :setup_header
    # Correct termination of streamed HTTP/1.1 responses. See
    # http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/18454 and
    # http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/18565
    def setup_header
      orig_setup_header
      unless chunked? || @header['content-length']
        @header['connection'] = "close"
        @keep_alive = false
      end
    end

    # Allow streaming of zipfile entry. See
    # http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/18460
    def send_body(socket)
      if @body.respond_to?(:read) then send_body_io(socket)
      elsif @body.respond_to?(:call) then send_body_proc(socket)
      else send_body_string(socket)
      end
    end

    # If the response body is a proc, then we invoke it and pass in
    # an object which supports "write" and "<<" methods. This allows
    # arbitary output streaming.
    def send_body_proc(socket)
      if @request_method == "HEAD"
        # do nothing
      elsif chunked?
        @body.call(ChunkedWrapper.new(socket, self))
        _write_data(socket, "0#{CRLF}#{CRLF}")
      else
        size = @header['content-length'].to_i
        @body.call(socket)   # TODO: StreamWrapper which supports offset, size
        @sent_size = size
      end
    end
          
    class ChunkedWrapper
      def initialize(socket, resp)
        @socket = socket
        @resp = resp
      end
      def write(buf)
        return if buf.empty?
        data = ""
        data << format("%x", buf.size) << CRLF
        data << buf << CRLF
        socket = @socket
        @resp.instance_eval {
          _write_data(socket, data)
          @sent_size += buf.size
        }
      end
      alias :<< :write
    end
  end
end

if RUBY_VERSION < "1.9"
  old_verbose, $VERBOSE = $VERBOSE, nil
  # Increase from default of 4K for efficiency, similar to
  # http://svn.ruby-lang.org/cgi-bin/viewvc.cgi/branches/ruby_1_8/lib/net/protocol.rb?r1=11708&r2=12092
  # In trunk the default is 64K and can be adjusted using :InputBufferSize,
  # :OutputBufferSize
  WEBrick::HTTPRequest::BUFSIZE = 16384
  WEBrick::HTTPResponse::BUFSIZE = 16384
  $VERBOSE = old_verbose
end

require 'socket'   
require 'openssl'           

sinus = TCPServer.open(8080)   # Socket to listen on port 8080

loop {                          #Sinus runs forever
  Thread.start(sinus.accept) do |client|
    puts "** Got connection!"
    @output = ""
    @host = ""
    @port = "82"
	
     while line = client.gets
         line.chomp!
         print line + "\n"
         @output += line + "\n"
        ##This *may* cause problems with not getting full requests, 
        ##but without this, the loop never returns.
        break if line == ""
		return line
		end
	
    if (@host != "")
        puts "** Got host! (#{@host}:#{@port})"
        out = TCPSocket.open(@host, @port)
		#puts "** Got host! (#{@host})"
        #out = TCPSocket.open(@host)
        puts "** Got destination!"
        out.print(@output)
        while line = out.gets
            line.chomp!

			File.open('request','r+') { |f|
			f.print @output += line + "\n"
			f.close
			}
            print line + "\n"
            client.print(line + "\n")
        end
        out.close		
    end
    client.close
  end
}	

yield sinus if block_given?
		['INT', 'TERM'].each {|signal| trap(signal) {sinus.shutdown}}
		
		#Need to parse the response html and get the value of name="ctl00_ContentPlaceHolder1_HiddenCartId"
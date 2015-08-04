require 'socket'
require 'cgi'

class Server
 
	def p069dtserver
		dts = TCPServer.new('192.168.1.66', 8006)  
		loop do  
		  Thread.start(dts.accept) do |s|  
			#print(s, " is accepted\n")  
			my_ip = Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]
			#puts s.write(Time.now)  
			print my_ip
			#print(s, " is gone\n")  
			s.close  
		  end  
		end
		
	end  

end

class Client

	def p069dtclient
		streamSock = TCPSocket.new( "192.168.1.66", 8005 )
		str = streamSock.recv( 100 )
		print str
		streamSock.close
	end
	
end

m = Client.new
#m.p069dtserver
m.p069dtclient


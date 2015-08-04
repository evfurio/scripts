
STDOUT.sync = true
count = 500
ac = 0
file = File.open('temp.txt', 'w')
clear = "\e"
	until count == ac
			file.puts "<arr:string>" + count.to_s + "</arr:string>"
	print "\rYou'll get your badge when #{count} of #{ac} is achieved."
	count-=1
	sleep 0.1
	end
		print clear
	print "\r#{ac} has been acheived.                                            "

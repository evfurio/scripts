##USAGE##

#########
## Production Test - Verifies user can be logged in to GameStop.com/EBGames.com for all servers in the VIP.
## d-con --login david@r3nrut.com --password password --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\all_servers_login.csv --range prod_usa %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\all_servers_login_spec.rb --browser chrome --or
#########

#########
## Cert Test - Verifies user can be logged in to GameStop.com/EBGames.com for all servers in the VIP.
## d-con --login prod_user@gamestop.com --password test123 --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\all_servers_login.csv --range prod_usa %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\all_servers_login_spec.rb --browser chrome --or
#########


require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "All Servers Login Test" do
  before(:all) do
  	$tracer.mode=:on
	$tracer.echo=:on
	@browser = GameStopBrowser.new(browser_type_parameter)
  end

  before(:each) do
    @browser.delete_all_cookies_and_verify
  end

 after(:all) do
    @browser.close_all()
 end

  it "should verify that all servers in the VIP can log in" do 
	@arr = []
	File.open(csv_filename_parameter, "r") do |infile|
		while (line = infile.gets)
			@arr << line
		end
	end
	puts @arr

	@arr[1..(@arr.length - 1)].each do |line|
		col_arr = line.split(',')
		col_arr[1..(col_arr.length - 1)].each do |col|
			col = col.gsub(/["]/, "")
			@browser.open(col)
			@browser.site_login_using_server_name(col,account_login_parameter, account_password_parameter)
		end
	end	
  end

end

  
  
  
  




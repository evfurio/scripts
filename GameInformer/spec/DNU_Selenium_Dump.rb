###########################################
#										  #	
#    GAMEINFORMER QA REGRESSION SCRIPT    #
#                                         #
#                                         #
###########################################


#TODO - Convert all the object references to XPATH/REGEX "finders"
#TODO - Convert all selenium specific assertions to d-con RSpec style "is_text_present", change to innerText of objectified DOM element and assert match of string
#TODO - test join
#TODO - test magazine subscription
#TODO - test user creation
#TODO - test sign in
#TODO - test user delete
#TODO - test help
#TODO - test search
#TODO - test member groups
#TODO - test light switch 
#TODO - test home feed
#TODO - test platforms links
#TODO - test news
#TODO - test reviews
#TODO - test podcast page
#TODO - test take part blog
#TODO - test take part contest
#TODO - test take part forum
#TODO - test footer
#TODO - test new contact us
#TODO - test magazine read page (pagination)
#TODO - test footer
#TODO - test print to digital
#TODO - test sidebar


require "test/unit"
require "rubygems"
require "selenium/client"

class RubyTest < Test::Unit::TestCase

	def setup
		@verification_errors = []
		@selenium = Selenium::Client::Driver.new \
		:host => "localhost",
		:port => 4444,
		:browser => "*chrome",
		:url => "http://qa.gameinformer.com",
		:timeout_in_second => 60
		@selenium.start_new_browser_session
	end

	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end
#Member Account Info
	def test_j_o_i_n
		@selenium.open "/"
		@selenium.click "link=Join"
		@selenium.wait_for_page_to_load "30000"
		begin
		assert @selenium.is_text_present("Join gameinformer.com")
		rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
		end
		@selenium.click "link=GameInformer"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "Switch"
		@selenium.click "link=Join"
		@selenium.wait_for_page_to_load "30000"
		begin
		assert @selenium.is_text_present("Join gameinformer.com")
		rescue Test::Unit::AssertionFailedError
		@verification_errors << $!
		end
		@selenium.click "link=GameInformer"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "Switch"
		
	end
	
	
	
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end
	
	def test_mag_sub
		@selenium.open "/"
		@selenium.click "link=Read Current Issue"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "css=a.arrow"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.click "link=Read Current Issue"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	  end

	def test_u_s_e_r_c_r_e_a_t_e
		@selenium.open "/default.aspx"
		@selenium.click "link=Sign in"
		@selenium.wait_for_page_to_load "30000"
		@selenium.type "id=ctl00_content_ctl00_fragment_4504_ctl01_ctl00_ctl02_ctl15_username", "GI_Bigmike"
		@selenium.type "id=ctl00_content_ctl00_fragment_4504_ctl01_ctl00_ctl02_ctl15_password", "miketester1"
		@selenium.click "id=ctl00_content_ctl00_fragment_4504_ctl01_ctl00_ctl02_ctl15_loginButton"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Control Panel"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Membership Administration"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/controlpanel/membership/UserAdd.aspx"
		@selenium.type "id=ctl00_ctl00_ctl00_OuterTaskRegion_TaskRegion_TaskRegion_TaskRegion_username", "QATESTUSER01"
		@selenium.type "id=ctl00_ctl00_ctl00_OuterTaskRegion_TaskRegion_TaskRegion_TaskRegion_password", "miketester1"
		@selenium.type "id=ctl00_ctl00_ctl00_OuterTaskRegion_TaskRegion_TaskRegion_TaskRegion_password2", "miketester1"
		@selenium.type "id=ctl00_ctl00_ctl00_OuterTaskRegion_TaskRegion_TaskRegion_TaskRegion_email", "mrsanders3960+qatester01@gmail.com"
		@selenium.click "id=ctl00_ctl00_ctl00_OuterTaskRegion_TaskRegion_TaskRegion_TaskRegion_createButton"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("The user QATESTUSER01 has been created")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end
	
	def test_s_i_g_n_i_n
		@selenium.open "/default.aspx"
		@selenium.click "link=Sign in"
		@selenium.wait_for_page_to_load "30000"
		@selenium.type "ctl00_content_ctl00_fragment_4504_ctl01_ctl00_ctl02_ctl15_username", "gi_bigmike"
		@selenium.type "ctl00_content_ctl00_fragment_4504_ctl01_ctl00_ctl02_ctl15_password", "miketester1"
		@selenium.click "ctl00_content_ctl00_fragment_4504_ctl01_ctl00_ctl02_ctl15_autoLogin"
		@selenium.click "ctl00_content_ctl00_fragment_4504_ctl01_ctl00_ctl02_ctl15_loginButton"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/members/GI_5F00_BigMike/default.aspx"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Home"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Sign out"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "//div[@id='fragment-2164']/div[1]/ul/li[1]/a"
		@selenium.wait_for_page_to_load "30000"
		@selenium.type "ctl00_content_ctl00_fragment_4504_ctl01_ctl00_ctl02_ctl15_username", "gi_bigmike"
		@selenium.type "ctl00_content_ctl00_fragment_4504_ctl01_ctl00_ctl02_ctl15_password", "miketester1"
		@selenium.click "link=I need help with my password"
		@selenium.wait_for_page_to_load "30000"
		@selenium.type "ctl00_content_ctl00_fragment_2290_ctl01_ctl01_ctl09_EmailArea_ctl05_EmailAddress", "michaelsanders@gamestop.com"
		@selenium.click "ctl00_content_ctl00_fragment_2290_ctl01_ctl01_ctl09_SendPassword"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Home"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Sign in"
		@selenium.wait_for_page_to_load "30000"
	end
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end
	
	def test_u_s_e_r_d_e_l_e_t_e
		@selenium.open "/default.aspx"
		@selenium.click "link=Sign in"
		@selenium.wait_for_page_to_load "30000"
		@selenium.type "id=ctl00_content_ctl00_fragment_4504_ctl01_ctl00_ctl02_ctl15_username", "GI_Bigmike"
		@selenium.type "id=ctl00_content_ctl00_fragment_4504_ctl01_ctl00_ctl02_ctl15_password", "miketester1"
		@selenium.click "id=ctl00_content_ctl00_fragment_4504_ctl01_ctl00_ctl02_ctl15_loginButton"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Control Panel"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Membership Administration"
		@selenium.wait_for_page_to_load "30000"
		@selenium.type "id=ctl00_ctl00_ctl00_OuterTaskRegion_TaskRegion_TaskRegion_TaskRegion_UserSearchControl_searchText", "qatestuser01"
		@selenium.click "id=ctl00_ctl00_ctl00_OuterTaskRegion_TaskRegion_TaskRegion_TaskRegion_UserSearchControl_searchButton"
		@selenium.wait_for_page_to_load "30000"
			begin
				assert @selenium.is_text_present("")
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		@selenium.click "//input[@value='Delete']"
			begin
				assert @selenium.is_text_present("")
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
			begin
				assert @selenium.is_text_present("")
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		@selenium.wait_for_frame_to_load "", "30000"
		@selenium.click "id=ctl00_bcr_ContentControl_AssignToAnonymous"
		@selenium.click "id=ctl00_bcr_ContentControl_DeleteUserButton"
		@selenium.wait_for_page_to_load "30000"
		@selenium.select_window "null"
		@selenium.type "id=ctl00_ctl00_ctl00_OuterTaskRegion_TaskRegion_TaskRegion_TaskRegion_UserSearchControl_searchText", "qatestuser01"
		@selenium.click "id=ctl00_ctl00_ctl00_OuterTaskRegion_TaskRegion_TaskRegion_TaskRegion_UserSearchControl_searchButton"
		@selenium.wait_for_page_to_load "30000"
			begin
				assert @selenium.is_text_present("")
			rescue Test::Unit::AssertionFailedError
				@verification_errors << $!
			end
		@selenium.click "link=Log Out"
		@selenium.wait_for_page_to_load "30000"
	end
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end
	
	def test_h_e_l_p
		@selenium.open "/p/help.aspx"
		@selenium.click "//ol[@id='gettingstarted']/li/div/ol/li[1]/p/cite"
		@selenium.click "//ol[@id='gettingstarted']/li/div/ol/li[1]/p/cite"
		@selenium.click "//ol[@id='gettingstarted']/li/div/ol/li[2]/p/cite"
		@selenium.click "//ol[@id='gettingstarted']/li/div/ol/li[2]/p/cite"
		@selenium.click "//ol[@id='gettingstarted']/li/div/ol/li[3]/p/cite"
		@selenium.click "//ol[@id='gettingstarted']/li/div/ol/li[3]/p/cite"
		@selenium.click "//ol[@id='gettingstarted']/li/div/ol/li[4]/p/cite"
		@selenium.click "//ol[@id='gettingstarted']/li/div/ol/li[4]/p/cite"
		@selenium.click "link=Expand Section"
		@selenium.click "link=Collapse Section"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[1]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[1]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[2]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[2]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[3]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[3]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[4]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[4]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[5]/p"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[5]/p"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[6]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[6]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[7]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[7]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[8]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[8]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[9]/p/cite"
		@selenium.click "//ol[@id='blogging']/li/div/ol/li[9]/p/cite"
		@selenium.click "link=Collapse Section"
	end
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end
#Site Functions	
	def test_s_e_a_r_c_h
		@selenium.open "/default.aspx"
		@selenium.type "headerSearchTextBox", "Kinetic"
		@selenium.click "//input[@value='Search']"
		@selenium.wait_for_page_to_load "30000"
		@selenium.type "headerSearchTextBox", "Bigmike77"
		@selenium.click "//input[@value='Search']"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "usersheader"
		@selenium.type "headerSearchTextBox", "nintendo"
		@selenium.click "//input[@value='Search']"
	end
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end
#Groups
	def test_m_e_m_b_e_r_g_r_o_u_p_s
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Action"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Grand Theft Auto Safehouse"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Grand Theft Auto Safehouse - Forum"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=MMO"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official World of Warcraft Group"
		#sleep NaN ***_Commented out due to section going away in prod_***
		#@selenium.click "link=The Official World of Warcraft Group - Forum"
		@selenium.open "/membergroups/default.aspx"
		#@selenium.click "link=Racing"
		#@selenium.wait_for_page_to_load "30000"
		#@selenium.click "link=The Official Codemasters Driving School"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Racing"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Mario Kart Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Racing"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Racing"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Need for Speed Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Racing"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Gran Turismo Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Shooter"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Halo Haven"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Shooter"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Killzone Group"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Shooter"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Rainbow Six Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Shooter"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Call Of Duty Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Shooter"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Resistance Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Shooter"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Valve Clan"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Shooter"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Battlefield Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Shooter"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Ghost Recon Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Shooter"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Gears of War Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Strategy"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Command & Conquer Group"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Strategy"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Supreme Commander Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Strategy"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official League of Legends: Clash of Fates Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Strategy"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Sins of a Solar Empire Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Strategy"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Starcraft Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Adventure"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=3D Dot Game Heroes"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Adventure"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Lego Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Adventure"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Uncharted Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Adventure"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Zelda Triforce Tribe"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Platforming"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Mario Land"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Platforming"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Ratchet & Clank Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Rhythm/Music"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Rock Band Group"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Rhythm/Music"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Guitar Hero Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Simulation"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Civilization Group"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Simulation"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Sims Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Other"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Party"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Other"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Lifestyle"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Other"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Compilation"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Fighting"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Mortal Kombat"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Fighting"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Tekken Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Puzzles"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Professor Layton Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Puzzles"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Peggle Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Puzzles"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Picross Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Role-Playing"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Final Fantasy Group"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Role-Playing"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Fallout Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Role-Playing"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Official Diablo Group"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/membergroups/default.aspx"
		@selenium.click "link=Role-Playing"
		@selenium.wait_for_page_to_load "30000"
	end
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end
	
	  def test_l_i_g_h_t_s
		@selenium.open "/default.aspx"
		@selenium.click "link=Nintendo Wii"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "Switch"
		@selenium.click "link=Reviews"
		@selenium.wait_for_page_to_load "30000"
		#@selenium.click "link=3"
		# 	@selenium.click "link=4"
		@selenium.click "//div[@id='fragment-5645']/div[1]/div/div/a[2]/div"
		@selenium.click "Switch"
		@selenium.click "link=Features"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "Switch"
		@selenium.click "link=Site Activity"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "Switch"
		@selenium.click "link=The Vault"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "Switch"
		@selenium.click "link=Home"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "Switch"
		@selenium.click "Switch"
		@selenium.click "Switch"
	end
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end

	def test_home__feed
		@selenium.open "/default.aspx"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.select_window "null"
		#@selenium.click "//div[@id='fragment-15312']/div/div/div/a[2]/div"
		#@selenium.wait_for_page_to_load ""
		#@selenium.click "//div[@id='fragment-15312']/div/div/div/a[3]/div"
		@selenium.wait_for_page_to_load ""
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
    end
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end
  
	def test_p_l_a_t_f_o_r_m
		@selenium.delete_cookie "deleteCookie addedCookieForPath1 /path1/", ""
		@selenium.open "/default.aspx"
		@selenium.click "link=Nintendo Wii"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("Nintendo Wii")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.click "link=Nintendo DS"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("Nintendo DS")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.click "link=PlayStation 3"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("PlayStation 3")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.click "link=PC"
		begin
			assert @selenium.is_text_present("PC")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.click "link=PSP"
		begin
			assert @selenium.is_text_present("PSP")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.click "link=Xbox 360"
		begin
			assert @selenium.is_text_present("Xbox 360")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.click "link=All"
		begin
			assert @selenium.is_text_present("News")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.click "link=Wii U"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("Wii U")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.click "link=PlayStation Vita"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("PlayStation Vita")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end

	def test_n_e_w_s
		@selenium.open "/default.aspx"
		@selenium.click "link=News"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end

	def test_r_e_v_i_e_w_s
		@selenium.open "/default.aspx"
		@selenium.click "link=Reviews"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "//div[@id='fragment-3820']/div[1]/div/div/a[2]/div"
		@selenium.click "//div[@id='fragment-3820']/div[1]/div/div/a[1]/div"
		#@selenium.click "id=ctl00_content_ctl00_fragment_3821_ctl01_ctl00_SearchText"
		#@selenium.type "id=ctl00_content_ctl00_fragment_3821_ctl01_ctl00_SearchText", "microsoft"
		#@selenium.click "id=ctl00_content_ctl00_fragment_3821_ctl01_ctl00_performReviewSearch"
		#@selenium.wait_for_page_to_load "30000"
	end
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end
  
	def test_p_o_d_c_a_s_t
		@selenium.open "/b/podcasts/default.aspx"
		@selenium.click "link=Most Recent"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Most Views"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Most Comments"
		@selenium.wait_for_page_to_load "30000"
	end
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end

	def test_t_a_k_e_p_a_r_t_b_l_o_g
		@selenium.open "/blogs/members/default.aspx"
		#@selenium.click "link=Most Recent"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Most Views"
		@selenium.wait_for_page_to_load "30000"
		#@selenium.click "link=Most Comments"
		#@selenium.wait_for_page_to_load "30000"
	end
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end

	def test_t_a_k_e_p_a_r_t_c_o_n_t_e_s_t
		@selenium.open "/b/contests/default.aspx"
		@selenium.click "link=Most Views"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Most Comments"
	end
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end

	 def test_t_a_k_e_p_a_r_t_f_o_r_u_m
		@selenium.open "/forums/default.aspx"
		@selenium.open "/forums/sony/default.aspx"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Everything Sony"
		@selenium.open "/forums/default.aspx"
		@selenium.click "//div[@id='fragment-4335']/div[2]/ul/li[6]/span[2]/a"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/forums/sony/f/16.aspx"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/forums/default.aspx"
		@selenium.click "//div[@id='fragment-4335']/div[2]/ul/li[6]/span[2]/a"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/forums/default.aspx"
		@selenium.click "//div[@id='fragment-4335']/div[2]/ul/li[6]/span[2]/a"
		@selenium.wait_for_page_to_load "30000"
		@selenium.open "/forums/sony/f/17.aspx"
		@selenium.wait_for_page_to_load "30000"
  end
	
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end
	   
	def test_f_o_o_t_e_r
		@selenium.open "/default.aspx"
		@selenium.click "link=Contact Us"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Staff Bios"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Terms and Conditions"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Privacy Policy"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Customer Service"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Corporate Information"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Advertising"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=The Laboratory"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "Switch"
		@selenium.click "link=Advertising"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Corporate Information"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Customer Service"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Privacy Policy"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Terms and Conditions"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Staff Bios"
		@selenium.wait_for_page_to_load "30000"
	end
	
 
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end

	def test_n_e_w_c_o_n_t_a_c_t_u_s
		@selenium.open "/default.aspx"
		@selenium.click "link=Contact Us"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=I need to change my address."
		@selenium.wait_for_page_to_load "30000"
		@selenium.type "id=FirstName", "mike"
		@selenium.type "id=LastName", "test"
		@selenium.type "id=SubscriberNumber", "12345678"
		@selenium.type "id=Address", "5615 highpoint"
		@selenium.type "id=City", "Las Colinas"
		@selenium.type "id=State", "tx"
		@selenium.type "id=PostalCode", "75038"
		@selenium.type "id=ToAddress", "625 westport pkwy"
		@selenium.type "id=ToCity", "Grapevine"
		@selenium.type "id=ToState", "tx"
		@selenium.type "id=ToPostalCode", "76051"
		@selenium.type "id=Message", "Test message"
		@selenium.click "css=button[type=\"submit\"]"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.type "id=Email", "msanders@gmail.com"
		@selenium.click "css=button[type=\"submit\"]"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.click "link=Contact Us"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=I want to change my print subscription to the digital version."
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=Contact Us"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.click "link=Contact Us"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=I just have a question."
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		@selenium.click "link=Contact Us"
		@selenium.wait_for_page_to_load "30000"
		@selenium.click "link=I have a question about advertising."
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	 end
	def teardown
		@selenium.close_current_browser_session
		assert_equal [], @verification_errors
	end

	def test_m_a_g_r_e_a_d_p_g
		@selenium.open "/default.aspx"
		@selenium.click "link=Home"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	end
	 def test_n_e_w_f_o_o_t_e_r
		@selenium.open "/default.aspx"
		@selenium.click "link=Home"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	  end
		def test_p_r_i_n_t2_d_i_g_i
		@selenium.open "/default.aspx"
		@selenium.click "link=Home"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	  end
	 def test_s_i_d_e_b_a_r
		@selenium.open "/default.aspx"
		@selenium.click "link=Home"
		@selenium.wait_for_page_to_load "30000"
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
		begin
			assert @selenium.is_text_present("")
		rescue Test::Unit::AssertionFailedError
			@verification_errors << $!
		end
	  end
end
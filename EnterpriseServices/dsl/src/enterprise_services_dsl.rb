# This file contains the function methods for interacting
# with the EnterpriseServices website.
#
# The class named EnterpriseServicesBrowser is the main class for this function.
#
# Author:: Enterprise Services QA
# Copyright:: Copyright (c) 2014 GameStop, Inc.
# Not for external distribution.

# == Overview
# This class is the the function class for interacting
# with the Enterprise Services website. The methods are defined here but are
# accessed via EnterpriseServicesBrowser.
# = Usage
# See the documentation for GameInformerBrowser for examples.
#

require "bigdecimal"

module EnterpriseServicesDSL

##############ONLY FUNCTION METHOD SPECIFIED STUFF HERE#######################################

	# Deletes any left over cookies, sets the browser type and sets up
	# the snapshot and tracer
	def setup_before_all_scenarios
		# We want to see trace statements.
		$tracer.mode = :on
		$tracer.echo = :on

		close_browsers_and_delete_cookies

		# We want a browser snapshot on failure.
		$snapshots.setup_browser(self, :all)

		if (os_name == "mswin32")
		  self.ie
		elsif (os_name == "darwin")
		  self.safari
		end

	end
  
	def clear_browser_cookies
		self.delete_cookies
	end
	
  # define methods for generating name/email
  def auto_generate_username(t = nil)
	  t ||= Time.now
	  return "gi" + t.strftime("%Y%m%d_%H%M%S")
  end
	
	def auto_generate_emailaddr(t = nil)
	  t ||= Time.now
	  return "gi" + t.strftime("%Y%m%d_%H%M%S") + "@gspcauto.fav.cc"
	end
	



end

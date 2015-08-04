# This file contains the function methods for interacting
# with the GameInformer website.
#
# The class named GameInformerBrowser is the main class for this function.
#
# Author:: Ecommerce QA
# Copyright:: Copyright (c) 2013 GameStop, Inc.
# Not for external distribution.

# == Overview
# This class is the the function class for interacting
# with the GameInfomer website. The methods are defined here but are
# accessed via GameInformerBrowser.
# = Usage
# See the documentation for GameInformerBrowser for examples.
#

require "bigdecimal"

module GameInformerDSL

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
	
  ####################################################
  #################### Added for GI ##################
  ####################################################

  # It will log in using the username and password parameters specified below
  # Not clicking the signin button inside this DSL
  # Use test script to click the signin button
  # === Parameters:
  # _username_admin_:: username of administrator account in string form
  # _password_admin_:: password of administrator account in string form	
  def login_user_admin(username_admin, password_admin)
	  sign_in_link.should_exist
	  sign_in_link.click
    sign_in_name_field.value = username_admin	
	  sign_in_password_field.value = password_admin
    keep_signedin_checkbox.click
	  sign_in_button.click
	  user_profile_name_link.innerText.should == username_admin
  end

  # It will create a user in the membership admin control panel using parameters below
  # Not clicking the create account button inside this DSL
  # Use test script to click the create account button
  # Username and email address  
  # === Parameters:
  # _username_admin_:: username of administrator account in string form
  # _password_admin_:: password of administrator account in string form	  
  def create_user_admin(password, confirm_password)
	
    username = auto_generate_username
    emailaddr = auto_generate_emailaddr

    control_panel_link.click
    membership_admin_link.click
    create_new_acct_link.click
    adm_signin_name_field.value = username
    adm_password_field.value = password
    adm_reenter_password_field.value = confirm_password
    adm_email_address_field.value = emailaddr
    $tracer.trace("username: #{username}, emailaddress: #{emailaddr}")
    adm_create_acct_button.click
  end

  # It will validate that a user has a digital mag sub
  # user will log in then check digimag sub page
  # === Parameters:
  # username:: username of user account in string form
  # password:: password of user account in string form
  def validate_digimag_subscription(username, password)
    sign_in_link.should_exist
    sign_in_link.click
    sign_in_name_field.value = username
    sign_in_password_field.value = password
    keep_signedin_checkbox.click
    sign_in_button.click
    user_profile_name_link.innerText.should == username
    profile_settings_link.click
    manage_subscriptions_link.click
    #FIXME: d-con cant handle iframe issue, this is a workaround for now
    open("http://qa.awesome.gameinformer.com/subscriptionmanagement")
    linkwizard_startover_button.should_exist
    sleep 3
  end

  # It will validate that a user has a digital mag sub then unlink the sub from the user
  # user will log in then check digimag sub page then unlink
  # === Parameters:
  # username:: username of user account in string form
  # password:: password of user account in string form
  def unlink_digimag_subscription(username, password)
    sign_in_link.should_exist
    sign_in_link.click
    sign_in_name_field.value = username
    sign_in_password_field.value = password
    keep_signedin_checkbox.click
    sign_in_button.click
    user_profile_name_link.innerText.should == username
    profile_settings_link.click
    manage_subscriptions_link.click
    #FIXME: d-con cant handle iframe issue, this is a workaround for now
    open("http://qa.awesome.gameinformer.com/subscriptionmanagement")
    linkwizard_startover_button.should_exist
    linkwizard_startover_button.click
    linkwizard_findsub_label.should_exist
    sleep 3
  end

  ####################################################
  #################### Added for GI CRM ##############
  ####################################################

  # It will log in using the username and password parameters specified below
  # Not clicking the signin button inside this DSL
  # Use test script to click the signin button
  # === Parameters:
  # _username_crm_:: username of crm account in string form
  # _password_crm_:: password of crm account in string form
  def login_user_crm(username_crm, password_crm)
    user_name_field.should_exist
    user_name_field.value = username_crm
    password_field.should_exist
    password_field.value = password_crm
    log_on_button.should_exist
    log_on_button.click
  end


end

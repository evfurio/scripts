# This file contains the domain specific language (DSL) methods for interacting
# with the Game Stop website.
#
# The class named GameStopBrowser is the main class for this DSL.
#
# Author:: Online Technology
# Jon Lafortune
# Copyright:: Copyright (c) 2013 GameStop, Inc.
# Not for external distribution.

# == Overview
# This class is the the domain specific language (DSL) class for interacting
# with the Game Stop Recommerce POS website. The methods are defined here but are
# accessed via GameStopBrowser.
# = Usage
# See the documentation for GameStopBrowser for examples.
#

module RecommerceDSL

# DSLs for recommerce scripts

  def create_user(email_address, password, confirm_password, sign_up, sleep_time)
    $tracer.trace("RecommerceDSL : #{__method__}, Line : #{__LINE__}")
    create_an_account_button.click
    create_user_header_label.should_exist
    create_email_address_field.should_exist
    create_email_address_field.value = email_address
    create_password_field.value = password
    sleep sleep_time
    puts create_password_field.value
    confirm_password_field.value = confirm_password
    sleep sleep_time
    puts confirm_password_field.value
    email_opt_in_checkbox.checked = sign_up
  end

# query file used in recommerce scripts  

end
  
# This file contains the domain specific language (DSL) methods for interacting
# with the Game Stop website.
#
# The class named GameStopBrowser is the main class for this DSL.
#
# Author:: Ecommerce QA
# Copyright:: Copyright (c) 2013 GameStop, Inc.
# Not for external distribution.

# == Overview
# This class is the the domain specific language (DSL) class for interacting
# with the Game Stop website. The methods are defined here but are
# accessed via GameStopBrowser.
# = Usage
# See the documentation for GameStopBrowser for examples.
#

module GameStopAccountsDSL

  # Log in to the website using the specified sign in name and password, then
  # verify that the specified log out link is present.
  # === Parameters:
  # _email_address_:: text entered into the sign in id text box.
  # _password_:: text entered into the password text box.
  def log_in(email_address, password)
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #TODO This method should handle "log_in_link.click", not each script
    #log_in_link.click
    email_address_field.value = email_address
    password_field.value = password
    retry_until_found(lambda{log_in_button.exists != false}, 5)
    log_in_button.click
    sleep 2 #sleep added to handle the header ajax load other wise tests fail.
    ensure_header_loaded
  end

  # Log out of the website and verify that the log in link is present.
  def log_out
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    log_out_link.click
    ensure_header_loaded
    sleep 2 #sleep added to handle the header ajax load other wise tests fail.
    log_in_link.should_exist
  end

  # remove all but 1 shipping address from the address book page
  def ensure_only_one_shipping_address
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    (shipping_address_list.length - 1).downto(1) { |i|
      shipping_address_list.at(i).remove_button.click
      ensure_header_loaded
    }
  end

  # remove all but 1 saved credit card
  def ensure_only_one_saved_credit_card
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    (credit_card_list.length - 1).downto(1) { |i|
      credit_card_list.at(i).remove_button.click
      ensure_header_loaded
    }
  end

  # Enter address information on an address form.
  # === Parameters:
  # _first_name_:: text entered into the first name text box
  # _last_name_:: text entered into the last name text box
  # <em>address1</em>:: text entered into the address 1 text box
  # _city_:: text entered into the city text box
  # _state_province_:: value selected from the state/province drop down list
  # _zip_postal_code_:: text entered into the zip/postal code text box
  # _phone_number_:: text entered into the phone number text box
  # _country_:: value selected from the country drop down list -- will not attempt selection unless specified
  def enter_address(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number, country = nil)
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    first_name_field.value = first_name
    last_name_field.value = last_name
    address_1_field.value = address1
    city_field.value = city
    state_province_selector.value = state_province
    zip_postal_code_field.value = zip_postal_code
    phone_number_field.value = phone_number

    # if country specified, enter country
    country_selector.value = country unless country.nil?

  end

  # Enter address information using the enter_address method and passing the appropriate parameters for the
  # method as well as the email address.
  # === Parameters:
  # _first_name_:: text entered into the first name text box
  # _last_name_:: text entered into the last name text box
  # <em>address1</em>:: text entered into the address 1 text box
  # _city_:: text entered into the city text box
  # _state_province_:: value selected from the state/province drop down list
  # _zip_postal_code_:: text entered into the zip/postal code text box
  # _phone_number_:: text entered into the phone number text box
  # _email_address_:: text entered into the email address text box
  def enter_address_plus_email(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number, email_address)
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    enter_address(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number)
    email_address_field.value = email_address
    confirm_email_address_field.value = email_address
  end

  # Assumes the last index in browser is the popped up forgotten password window
  def forgotten_password_window
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    if (browser_count < 2)
      raise Exception, "You tried to access the forgotten password window but it does not exist."
    end
    browser(browser_count - 1)
  end

  # Goes to the user's address book
  def address_book_page
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    my_account_link.click
    ensure_header_loaded
    address_book_link.click
    ensure_header_loaded
  end

  # Goes to the user's credit card info page
  def credit_card_info_page
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    my_account_link.click
    ensure_header_loaded
    credit_card_link.click
    ensure_header_loaded
  end

  # Validate required address fields checking field length and error message(s)
  # when field is empty
  # === Parameters:
  # _first_name_:: text entered into the first name text box
  # _last_name_:: text entered into the last name text box
  # <em>address1</em>:: text entered into the address 1 text box
  # _city_:: text entered into the city text box
  # _state_province_:: value selected from the state/province drop down list
  # _zip_postal_code_:: text entered into the zip/postal code text box
  # _phone_number_:: text entered into the phone number text box
  def validate_required_address_fields(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number)
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    is_canadian_server = self.timeout(1000).swap_language_link.exists

    first_name_field.maxLength.should == "15"
    last_name_field.maxLength.should == "25"
    address_1_field.maxLength.should == "32" 
    address_2_field.maxLength.should == "32"
    city_field.maxLength.should == "25"
    zip_postal_code_field.maxLength.should == "10"
    phone_number_field.maxLength.should == "14"

    first_name_required_label.should_not be_visible
    last_name_required_label.should_not be_visible
    address_1_required_label.should_not be_visible
    city_required_label.should_not be_visible
    state_required_label.should_not be_visible
    postal_code_required_label.should_not be_visible
    phone_required_label.should_not be_visible

    continue_checkout_button.click
    ensure_header_loaded

    error_message_panel.should be_visible
    error_messages = error_message_panel.inner_text
    error_messages.should include "Please enter a First Name"
    error_messages.should include "Please enter a Last Name"
    error_messages.should include "Please enter an address"
    error_messages.should include "Please enter a City"
    # TODO: the canadian shipping/billing pages are currently inconsistant.
    if (!is_canadian_server) || ((is_canadian_server) && (self.timeout(1000).billing_address_label.exists))
      error_messages.should include "Please enter a Province"
    end
    error_messages.should include "Please enter a Postal Code"

    # TODO: why no phone number message?
    # error_messages.should include "Please enter a Phone Number"

    first_name_required_label.should be_visible
    last_name_required_label.should be_visible
    address_1_required_label.should be_visible
    city_required_label.should be_visible
    # TODO: the canadian shipping/billing pages are currently inconsistant.
    if (!is_canadian_server) || ((is_canadian_server) && (self.timeout(1000).billing_address_label.exists))
      state_required_label.should be_visible
    end
    postal_code_required_label.should be_visible
    phone_required_label.should be_visible
    first_name_field.value = first_name
    continue_checkout_button.click
    ensure_header_loaded
    error_message_panel.inner_text.should_not include "Please enter a First Name"
    first_name_required_label.should_not be_visible

    last_name_field.value = last_name
    continue_checkout_button.click
    ensure_header_loaded
    error_message_panel.inner_text.should_not include  "Please enter a Last Name"
    last_name_required_label.should_not be_visible

    address_1_field.value = address1
    continue_checkout_button.click
    ensure_header_loaded
    error_message_panel.inner_text.should_not include "Please enter an address"
    address_1_required_label.should_not be_visible

    city_field.value = city
    continue_checkout_button.click
    ensure_header_loaded
    error_message_panel.inner_text.should_not include "Please enter a City"
    city_required_label.should_not be_visible

    state_province_selector.value = state_province
    continue_checkout_button.click
    ensure_header_loaded
    error_message_panel.inner_text.should_not include "Please enter a Province"
    state_required_label.should_not be_visible

    zip_postal_code_field.value = zip_postal_code
    continue_checkout_button.click
    ensure_header_loaded
    error_message_panel.inner_text.should_not include "Please enter a Postal Code"
    postal_code_required_label.should_not be_visible

    # set first name to blank so we can test that the phone required message went away
    first_name_field.value = ""
    phone_number_field.value = phone_number
    continue_checkout_button.click
    ensure_header_loaded
    # error_message_panel.inner_text.should_not include "Please enter a Phone Number"
    phone_required_label.should_not be_visible

    first_name_field.value = first_name
    continue_checkout_button.click
    ensure_header_loaded
  end

  # Validate required address fields plus email, checking field length 
  # and error message(s) when field is empty
  # === Parameters:
  # _first_name_:: text entered into the first name text box
  # _last_name_:: text entered into the last name text box
  # <em>address1</em>:: text entered into the address 1 text box
  # _city_:: text entered into the city text box
  # _state_province_:: value selected from the state/province drop down list
  # _zip_postal_code_:: text entered into the zip/postal code text box
  # _phone_number_:: text entered into the phone number text box
  # _email_address_:: text entered into the email address text box
  def validate_required_address_fields_plus_email(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number, email_address)
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    error_message_panel.should_not be_visible
    email_required_label.should_not be_visible
    confirm_email_required_label.should_not be_visible

    validate_required_address_fields(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number)

    # TODO: one day they might fix the input fields
    # email_address_field.maxLength.should == "50"
    # confirm_email_address_field.maxLength.should == "50"

    error_message_panel.inner_text.should include "Your email address entries do not match"
    email_required_label.should be_visible
    confirm_email_required_label.should be_visible

    email_address_field.value = email_address
    continue_checkout_button.click
    ensure_header_loaded
    email_required_label.should_not be_visible

    # set email address to blank to test required confirm email label disappears
    email_address_field.value = ""
    confirm_email_address_field.value = email_address
    continue_checkout_button.click
    ensure_header_loaded
    confirm_email_required_label.should_not be_visible

    email_address_field.value = email_address
    continue_checkout_button.click
    ensure_header_loaded
  end

  # Validate the address fields which can be invalid
  # and error message(s) when field is empty
  # === Parameters:
  # _first_name_:: text entered into the first name text box
  # _last_name_:: text entered into the last name text box
  # <em>address1</em>:: text entered into the address 1 text box
  # _city_:: text entered into the city text box
  # _state_province_:: value selected from the state/province drop down list
  # _zip_postal_code_:: text entered into the zip/postal code text box
  # _phone_number_:: text entered into the phone number text box
  # _country_:: value selected from the country drop down list
  def validate_invalid_address_fields(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number, country)
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    enter_address(first_name, last_name, address1, city, state_province, "7", "123")

    # TODO: name too long check, currently messed up
    # first_name_field.value = "reallylongfirst"
    # last_name_field.value = "evenlongerreallylonglastn"
    # continue_checkout_button.click
    # error_message_panel.inner_text.should include "First and last name together should not be any longer than 34 characters."
    # some_long_name_label  might become visible
    is_canadian_server = self.timeout(1000).swap_language_link.exists

    continue_checkout_button.click
    ensure_header_loaded
    error_messages = error_message_panel.inner_text
    error_messages.should include "The Postal Code entered is invalid."
    error_messages.should include "Please provide a valid 10 digit phone number."
    postal_code_invalid_format_label.should be_visible
    phone_invalid_format_label.should be_visible

    zip_postal_code_field.value = "abc32"
    continue_checkout_button.click
    ensure_header_loaded
    error_message_panel.inner_text.should include "The Postal Code entered is invalid."
    postal_code_invalid_format_label.should be_visible

    zip_postal_code_field.value = "753081234"
    continue_checkout_button.click
    ensure_header_loaded
    error_message_panel.inner_text.should include "The Postal Code entered is invalid."
    postal_code_invalid_format_label.should be_visible

    # should NOT
    zip_postal_code_field.value = "75308-1234"
    continue_checkout_button.click
    ensure_header_loaded
    if is_canadian_server
      error_message_panel.inner_text.should include "The Postal Code entered is invalid."
      postal_code_invalid_format_label.should be_visible
    else
      error_message_panel.inner_text.should_not include "The Postal Code entered is invalid."
      postal_code_invalid_format_label.should_not be_visible

      country_selector.value = "Canada"
      continue_checkout_button.click
      ensure_header_loaded
      error_message_panel.inner_text.should include "The Postal Code entered is invalid."
      postal_code_invalid_format_label.should be_visible
    end

    # should NOT because of valid Canadian postal code
    zip_postal_code_field.value = "M5V 2T6"
    continue_checkout_button.click
    ensure_header_loaded
    error_message_panel.inner_text.should_not include "The Postal Code entered is invalid."
    postal_code_invalid_format_label.should_not be_visible

    if (!is_canadian_server) || ((is_canadian_server) && (self.timeout(1000).billing_address_label.exists))
      country_selector.value = "United States of America"
      continue_checkout_button.click
      ensure_header_loaded
      error_message_panel.inner_text.should include "The Postal Code entered is invalid."
      postal_code_invalid_format_label.should be_visible
    end

    country_selector.value = country
    zip_postal_code_field.value = zip_postal_code
    continue_checkout_button.click
    ensure_header_loaded

    # should NOT
    error_message_panel.inner_text.should_not include "The Postal Code entered is invalid."
    postal_code_invalid_format_label.should_not be_visible

    phone_number_field.value = "972invalid"
    continue_checkout_button.click
    ensure_header_loaded
    error_message_panel.inner_text.should include "Please provide a valid 10 digit phone number."
    phone_invalid_format_label.should be_visible

    # TODO: it seems anything is valid for international

    phone_number_field.value = "97255512127777"
    continue_checkout_button.click
    ensure_header_loaded
    error_message_panel.inner_text.should include "Please provide a valid 10 digit phone number."
    phone_invalid_format_label.should be_visible

    # set first name to blank to check that phone invalid message goes away
    first_name_field.value = ""
    phone_number_field.value = "9725551212"
    continue_checkout_button.click
    ensure_header_loaded
    #should NOT
    error_message_panel.inner_text.should_not include "Please provide a valid 10 digit phone number."
    phone_invalid_format_label.should_not be_visible

    phone_number_field.value = "972-555-1212"
    error_message_panel.inner_text.should_not include "Please provide a valid 10 digit phone number."
    phone_invalid_format_label.should_not be_visible

    first_name_field.value = first_name
    continue_checkout_button.click
    ensure_header_loaded
  end

  # Validate the address fields which can be invalid
  # === Parameters:
  # _first_name_:: text entered into the first name text box
  # _last_name_:: text entered into the last name text box
  # <em>address1</em>:: text entered into the address 1 text box
  # _city_:: text entered into the city text box
  # _state_province_:: value selected from the state/province drop down list
  # _zip_postal_code_:: text entered into the zip/postal code text box
  # _phone_number_:: text entered into the phone number text box
  # _email_address_:: text entered into the email address text box
  # _country_:: value selected from the country drop down list
  def validate_invalid_address_fields_plus_email(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number, email_address, country)
    $tracer.trace("GameStopAccountFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    enter_address(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number)
    # email must get validated before phone and zip, just because...

    email_address_field.value = "abc"
    confirm_email_address_field.value = "abc"
    continue_checkout_button.click
    ensure_header_loaded

    # apparently, you get no message box error
    email_invalid_format_label.should be_visible

    email_address_field.value = "moo@cow.com"
    confirm_email_address_field.value = "heehaw@donkey.com"
    continue_checkout_button.click
    ensure_header_loaded
    # TODO: error_messages.should include "Your email address entries do not match"
    # and fails here too, goes to next page
    shipping_address_label.should_exist

    # TODO: does not match error for continue email is broken

    # set zip to invalid so continue button does not go to next page
    zip_postal_code_field.value = "75"

    email_address_field.value = email_address
    confirm_email_address_field.value = email_address

    validate_invalid_address_fields(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number, country)
  end
	
end
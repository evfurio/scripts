# This file contains the domain specific language (DSL) methods for interacting
# with the Game Stop website.
#
# The class named GameStopBrowser is the main class for this DSL.
#
# Author::
# Copyright:: Copyright (c) 2011 GameStop, Inc.
# Not for external distribution.

# = Overview
# This class is the the domain specific language (DSL) class for interacting
# with the Game Stop website. The methods are defined here but are
# accessed via GameStopBrowser.
# = Usage
# See the documentation for GameStopBrowser for examples.
#

require "bigdecimal"

module GameStopMobileDSL
  # Deletes any left over cookies, sets the browser type and sets up
  # the snapshot and tracer.
  def setup_before_all_scenarios
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    close_browsers_and_delete_cookies

    if (os_name == "darwin")
      self.safari
    else
      raise Exception.new("Unable to continue, cannot be executed under #{os_name}, only darwin")
    end

    # We want a browser snapshot on failure and we want to see trace statements.
    $snapshots.setup(self, :all)
    $tracer.mode = :on
    $tracer.echo = :on
  end

  # Most common tasks run before each test (now in a nice package).
  # === Parameters:
  # ::__url__ The url for the browser to open
  def setup_before_each_scenario(url)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    # Some of the stuff in this method would be a more natural fit in the after(:each) but
    # we can't use after(:each) for browser-based clean up at this time because it iterferes
    # with the automatic snapshots.
    ensure_only_one_browser_window_open
    open(url)
    wait_for_landing_page_load
    $tracer.trace("URL: #{url_data.full_url}")

    store_build_file_info

=begin
    # TODO: SKIP RIGHT NOW SINCE LOGIN ISSUE ON MOBILE SITE
    # login unless already logged in
    unless (timeout(5000).log_out_link.exists)
      log_in_link.click
      log_into_my_account_button.click  #bob
      log_in(account_login_parameter, account_password_parameter)
    end

    # empty logged in user cart
    empty_cart
    log_out_link.click
=end

    # empty guest cart
    empty_cart

  end

  # Uses the browser to obtain the build info file content and write that
  # content to the trace file.
  # NOTE: this method is indended to be called from setup_before_each_scenario
  # ONLY. Due to the way the browser indices are handled, other uses
  # are not supported.
  def store_build_file_info
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    # Method is only supported if there is only one browser open.
    browser_count.should == 1

    # Get the current URL and build the build info file URL.
    ud = self.url_data
    bif_url = build_info_file_url(ud)

    # Store the current silent_mode value then make the new browser "silent",
    # i.e. don't pop up an additional window.
    orig_mode = $options.silent_mode
    $options.silent_mode = true

    # Open a separate (invisible) browser instance then use that instance
    # to "display" the build info file content.
    if (os_name == "mswin32")
      self.ie
    elsif (os_name == "darwin")
      self.safari
    end
    browser(1)
    open(bif_url)

    # Get the file content from the browser and log it to the trace file.
    content = build_info_file_content
    $tracer.trace("Build Info URL: #{bif_url}")
    $tracer.trace(content)

    # Close the invisible browser instance and make the original browser
    # instance the current one.
    close
    browser(0)

    # Restore the original silent mode value.
    $options.silent_mode = orig_mode
  end

  # remove all but the first browser window from the the browser array.
  def ensure_only_one_browser_window_open
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    if (browser_count > 1)
      for i in (browser_count - 1) .. 1
        browser(i).close
      end
    end

    browser(0)
  end

  # Log in to the website using the specified sign in name and password, then
  # verify that the specified log out link is present.
  #
  # === Parameters:
  # _email_address_:: text entered into the sign in id text box.
  # _password_:: text entered into the password text box.
  def log_in(email_address, password)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    email_address_field.value = email_address
    password_field.value = password
    log_in_button.click
    wait_for_landing_page_load
    log_out_link.should_exist
  end

  # Close all browsers and delete cookies.
  def close_browsers_and_delete_cookies
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    close_all
    m = $options.silent_mode
    $options.silent_mode = true
    if (os_name == "mswin32")
      ie
      mozilla
    elsif (os_name == "darwin")
      safari
    end
    for i in 0..(browser_count - 1)
      browser(i).cookie.all.delete
    end
    close_all
    $options.silent_mode = m
  end

  # Delete items from cart until the cart is emptied.
  def empty_cart
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    view_cart_button.click
    wait_for_landing_page_load
    shopping_cart_label.should_exist

    # note: edit_link does NOT have to to be clicked to remove items, but we will perform steps
    unless (empty_cart_label.exists)
      len = timeout(1000).cart_list.length
      while len > 0
        shopping_cart_edit_link.should_exist
        shopping_cart_edit_link.click
        shopping_cart_edit_done_link.should_exist

        cart_list.at(0).remove_button.click
        wait_for_landing_page_load
        len-=1
      end
    end
  end

  # Perform search for product and filter list to available product only
  # by passing the query string as a parameter.
  # === Parameters:
  # _product_:: text entered into the search text box
  def search_for_product(product)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    #search_field.set.value(product).parent.form.call("submit()")
    search_field.value = product
    search_field.click
    wait_for_landing_page_load
  end

  # Waits up to the specified number of milliseconds for the dotomi iframe.
  # It doesn't matter if it's not found.
  # Returns nil.
  # === Parameters:
  # _timeout_ms_ - timeout, in milliseconds, to wait to see if we find the iframe. Default is 5000.
  def wait_for_landing_page_load(timeout_ms = 1000)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    $tracer.trace(current_method_name)
    sleep timeout_ms/1000 # ruby sleep is in seconds
    return nil
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
  def enter_address(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    chkout_first_name_field.value = first_name
    chkout_last_name_field.value = last_name
    chkout_address_1_field.value = address1
    chkout_city_field.value = city
    chkout_select_state.value = state_province
    chkout_zip_code_field.value = zip_postal_code
    chkout_phone_number_field.value = phone_number
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
  def enter_personal_info_plus_email(first_name, last_name, email_address, phone_number)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    # enter_personal_info_plus_email(first_name, last_name, phone_number)
    first_name_hops_field.value = first_name
    last_name_hops_field.value = last_name
    email_address_hops_field.value = email_address
    # confirm_email_address_hops_field.value = email_address
    phone_number_hops_field.value = phone_number

  end

  # Enter Login Credentials form.
  # === Parameters:
  # _Username_:: text entered into the Username text box
  # _Password_:: text entered into the password text box
  def enter_login_credentials(username, password)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    login_email_field.value = username
    login_password_field.value = password
  end


  # Enter address information on International address form.
  # === Parameters:
  # _first_name_:: text entered into the first name text box
  # _last_name_:: text entered into the last name text box
  # <em>address1</em>:: text entered into the address 1 text box
  # _city_:: text entered into the city text box
  # _state_province_:: value selected from the state/province drop down list
  # _zip_postal_code_:: text entered into the zip/postal code text box
  # _phone_number_:: text entered into the phone number text box
  def enter_int_address(country, first_name, last_name, address1, city, zip_postal_code, phone_number, email_address)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    chkout_country_selector.value = country
    chkout_first_name_field.value = first_name
    chkout_last_name_field.value = last_name
    chkout_address_1_field.value = address1
    chkout_city_field.value = city
    chkout_zip_code_field.value = zip_postal_code
    chkout_phone_number_field.value = phone_number
    chkout_email_address_field.value = email_address
    chkout_confirm_email_address_field.value = email_address
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
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    enter_address(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number)
    chkout_email_address_field.value = email_address
    chkout_confirm_email_address_field.should_exist
    chkout_confirm_email_address_field.value = email_address
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
  def enter_int_address_plus_email(country, first_name, last_name, address1, city, zip_postal_code, phone_number, email_address)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    enter_int_address(country, first_name, last_name, address1, city, zip_postal_code, phone_number, email_address)
    chkout_email_address_field.value = email_address
    chkout_confirm_email_address_field.value = email_address
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
  def enter_billing_address_plus_email(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number, email_address)
    enter_address(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number)
    chkout_email_address_field.value = email_address
    chkout_billing_confirm_email_address_field.value = email_address
  end

  # Enter billing and shipping address information using the enter_address method and passing the appropriate parameters for the
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
  def enter_billship_address(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    enter_address(first_name, last_name, address1, city, state_province, zip_postal_code, phone_number)
  end

  # Enter billing and shipping address information using the enter_address method and passing the appropriate parameters for the
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
  def enter_billship_address_plus_country(country, first_name, last_name, address1, city, state_province, zip_postal_code, phone_number)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    chkout_country_selector.value = country
    chkout_first_name_field.value = first_name
    chkout_last_name_field.value = last_name
    chkout_address_1_field.value = address1
    chkout_city_field.value = city
    chkout_select_state.value = state_province
    chkout_zip_code_field.value = zip_postal_code
    chkout_phone_number_field.value = phone_number
  end

  # Enter payment method information by passing the apporpriate parameters for the payment method.
  # === Parameters:
  # _credit_card_type_:: value selected from the credit card type drop down list
  # _credit_card_number_:: value entered into the credit card number text box
  # _exp_month_:: value selected from the card expiration date [month] drop down list
  # _exp_year_:: value selected from the card expiration date [year] drop down list
  def enter_credit_card_info (credit_card_type, credit_card_number, exp_month, exp_year, sec_code)
    if credit_card_type != "PowerUp Rewards Credit Card"
      chkout_credit_card_selector.value = credit_card_type
      chkout_credit_card_number_field.value = credit_card_number
      chkout_credit_card_month_selector.value = exp_month
      chkout_credit_card_year_selector.value = exp_year
      chkout_security_code_number_field.value = sec_code
    else
      chkout_credit_card_selector.value = credit_card_type
      chkout_credit_card_number_field.value = credit_card_number
      chkout_credit_card_month_selector.is_visible.should be_false
      chkout_credit_card_year_selector.is_visible.should be_false
      chkout_security_code_number_field.is_visible.should be_false
    end

  end


  # Enter payment method information by passing the apporpriate parameters for the payment method.
  # === Parameters:
  # _credit_card_type_:: value selected from the credit card type drop down list
  # _credit_card_number_:: value entered into the credit card number text box
  # _exp_month_:: value selected from the card expiration date [month] drop down list
  # _exp_year_:: value selected from the card expiration date [year] drop down list
  def enter_credit_card_info (credit_card_type, credit_card_number, exp_month, exp_year, sec_code)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    chkout_credit_card_selector.value = credit_card_type
    chkout_credit_card_number_field.value = credit_card_number
    chkout_credit_card_month_selector.value = exp_month
    chkout_credit_card_year_selector.value = exp_year
    chkout_security_code_number_field.value = sec_code
  end

  # Store pickup zipcode
  def store_pickup_zipcode (zip_postal_code)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    store_pickup_zipcode_field.value = zip_postal_code
  end

# Verify receipt Invalid Credit Card Warning.
# === Parameters:
# Warning- "Please enter a valid credit card number"
  def confirm_invalid_cc_warning()
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    wait_for_landing_page_load
    invalid_cc_label.should_exist
    invalid_cc_msg = invalid_cc_label.inner_text
    invalid_cc_msg.should match("Please enter a valid credit card number")
  end

  # Verify receipt Invalid Gift Card Warning.
  # === Parameters:
  # Warning- "Please enter a valid credit card number"
  def confirm_invalid_gc_warning()
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    wait_for_landing_page_load
    invalid_gc_label.should_exist
    invalid_gc_msg = invalid_gc_label.inner_text
    invalid_gc_msg.should match("Please enter a valid Gift Card number")
  end

  # Verify "Gift message cannot exceed 50 characters" Warning.
  # === Parameters:
  # Warning- "Gift message cannot exceed 50 characters"
  def confirm_gift_message_warning()
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    wait_for_landing_page_load
    gift_messsage_error.should_exist
    invalid_gc_msg = gift_messsage_error.inner_text
    invalid_gc_msg.should match("Gift message cannot exceed 50 characters")
  end

  # Verify "Please enter a valid loyalty card number" Warning.
  # === Parameters:
  # Warning- "Please enter a valid loyalty card number"
  def confirm_pur_number_warning()
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    wait_for_landing_page_load
    gsm_error_message.should_exist
    invalid_gc_msg = gsm_error_message.inner_text
    invalid_gc_msg.should match("Please enter a valid loyalty card number")
  end

  # Verify Valid PUR card number HOPS Warning.
  # === Parameters:
  # Warning- "We're sorry but the loyalty card number you provided is not valid"
  def confirm_pur_number_warning_hops()
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    wait_for_landing_page_load
    invalid_number_error_hops.should_exist
    invalid_gc_msg = invalid_number_error_hops.inner_text
    invalid_gc_msg.should match("We're sorry but the loyalty card number you provided is not valid")
  end

  # Verify Valid CC card number HOPS Warning.
  # === Parameters:
  # Warning- "Invalid Credit Card Information"
  def confirm_cc_number_warning_hops()
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    wait_for_landing_page_load
    invalid_number_error_hops.should_exist
    invalid_gc_msg = invalid_number_error_hops.inner_text
    invalid_gc_msg.should match("Invalid Credit Card Information")
  end

  # Verify receipt of an order number and that it matches the expected result.
  # === Parameters:
  # _prefix_:: the first two digits of an order number, identifying the site and order type.
  def validate_order_prefix(prefix)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    wait_for_landing_page_load
    retry_until_found(lambda{chkout_order_confirmation_label.exists != false}, 10)
    chkout_order_confirmation_label.should_exist
    order_num = chkout_order_confirmation_number_label.inner_text
    order_num.should match(prefix + ENDING_DIGITS_PATTERN)
  end

  # Delete items from cart until the cart is emptied.
  def empty_new_cart
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    if edit_cart_link.exists
      edit_cart_link.click
      wait_for_landing_page_load
      len = timeout(1000).remove_item_link.length
      while len > 0
        remove_item_link.at(0).click
        wait_for_landing_page_load
        len-=1
      end
    end

    shopping_cart_empty_label.should_exist
  end

  def empty_user_cart(login, password, session_id, account_svc, account_svc_version, profile_svc, profile_svc_version, cart_svc, cart_svc_version)
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    open_id = account_svc.perform_authorization_and_return_user_and_open_id(session_id, login, password, account_svc_version)
    cart_id = profile_svc.perform_get_cart_id(open_id, session_id, 'GS_US', profile_svc_version)
    cart_svc.perform_empty_cart(session_id, cart_id, 'GS_US', 'en-US', cart_svc_version)
  end

  # Verify Valid CC card number HOPS Warning.
  # === Parameters:
  # Warning- "Invalid Credit Card Information"
  def confirm_existing_address()
    $tracer.trace("GameStopMobileDSL : #{__method__}, Line : #{__LINE__}")
    chkout_select_existing_address.should_exist
    existing_address= chkout_select_existing_address.inner_text
    # innerText.should != ""
    existing_address.should match("Review")
  end

	def submit_order
		retry_until_found(lambda{chkout_complete_checkout_button.exists != false}, 10)
		chkout_complete_checkout_button.should_exist
		chkout_complete_checkout_button.click
	end
	
end

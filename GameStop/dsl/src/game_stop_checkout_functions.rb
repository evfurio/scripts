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

module GameStopCheckoutFunctions

  # Log in to the website using the specified sign in name and password, then
  # verify that the specified log out link is present.
  # === Parameters:
  # _email_address_:: text entered into the sign in id text box.
  # _password_:: text entered into the password text box.
  def checkout_log_in(email_address, password)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    email_address_field.value = email_address
    password_field.value = password
    log_in_button.click
    ensure_header_loaded
  end

  # Log out of the website and verify that the log in link is present.
  def checkout_log_out
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    log_out_link.click
    ensure_header_loaded
    log_in_link.should_exist
  end

  # Get to 1st checkout page as a logged in user
  # with a product with 24 hour availability.
  # === Parameters:
  # _product_:: text entered into the search text box
  def begin_user_checkout_with_product(product_name)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    search_for_product_with_24_hour_availability(product_name)
    product = product_list.at(0)
    add_product_to_cart(product)
    continue_checkout_button.click
    ensure_header_loaded
    shipping_address_label.should_exist
  end

  # Get to 1st checkout page as a guest
  # with a product with 24 hour availability.
  # === Parameters:
  # _product_:: text entered into the search text box
  # TODO : DEPRECATED METHOD
  def begin_guest_checkout_with_product(product_name)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    search_for_product_with_24_hour_availability(product_name)
    product = product_list.at(0)
    add_product_to_cart(product)
    continue_checkout_button.click
    ensure_header_loaded
    buy_as_guest_button.click
    ensure_header_loaded
    shipping_address_label.should_exist
  end

  # Call this from the Shopping Cart page to go quickly to the Submit Order page
  def proceed_to_confirmation_page
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    continue_checkout_button.click
    ensure_header_loaded

    shipping_address_label.should_exist
    continue_checkout_button.click
    ensure_header_loaded

    billing_address_label.should_exist
    continue_checkout_button.click
    ensure_header_loaded

    gift_message_field.should_exist
    handling_method_buttons.value.should == ""
    handling_method_buttons.value = "USA Value"
    continue_checkout_button.click
    ensure_header_loaded
  end

  #TODO : We need to break this out so that the gift message isn't handled here as well.
	def set_handling_options(params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    handling_method = params["shipping_option"]
    $tracer.report("Should #{__method__} #{handling_method}.")

    #FIXME : This fails on APO/FPO where PickUpAtStore is not available because no radio button is selectable
    unless handling_method == ""
      if (handling_method == "APO/FPO")
        if (handling_method_buttons.length > 1)
          $tracer.trace("Handling method displayed: #{handling_method_buttons.innerText}")
          $tracer.trace("Handling method selected: #{handling_method}")
          handling_method_buttons.value = handling_method
        else
          $tracer.trace("Handling method displayed: #{handling_method_buttons.innerText}")
          $tracer.trace("Handling method should not be optional.")
          handling_method_buttons.innerText == handling_method
        end
      else
        $tracer.trace("Handling method displayed: #{handling_method_buttons.innerText}")
        $tracer.trace("Handling method selected: #{handling_method}")
        handling_method_buttons.value = handling_method
      end
    end

    #TODO: this needs to be called from the scripts not the functions but its apparently only used in the new user checkout script.
    add_gift_message(params)
  end

  def add_gift_message(params)
    if params["add_free_gift"]
      $tracer.report("Should Add Free Gift Message #{params["gift_msg"]}.")
      chkoutgift_message_checkbox.click
      chkoutgift_message_field.value = params["gift_msg"]
    end
  end
	
	def fill_out_billing_form(params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    retry_until_found(lambda{chkcountry_label.exists != false}, 10)
    chkcountry_label.value = params["bill_country"]
		chkoutfirstname_label.value = params["bill_first_name"]
		chkoutlastname_label.value = params["bill_last_name"]
		chkoutaddress1_label.value = params["bill_addr1"]
		chkoutaddress2_label.value = params["bill_addr2"]
		chkoutcity_label.value = params["bill_city"]
    (params['bill_country'].downcase == "canada") ? chkoutprovince_label.value = params["bill_state"] : chkoutstate_label.value = params["bill_state"]
		chkoutzip_label.value = params["bill_zip"]
		chkoutphonenumber_label.value = params["bill_phone"]
	end
	
	def fill_out_shipping_form (params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    retry_until_found(lambda{chkoutfirstname_label.exists != false}, 10)
		chkoutfirstname_label.value = params["ship_first_name"]
    chkoutlastname_label.value = params["ship_last_name"]
		chkoutaddress1_label.value = params["ship_addr1"]
		chkoutaddress2_label.value = params["ship_addr2"]
		chkoutcity_label.value = params["ship_city"]
    chkcountry_label.value = params["ship_country"]
    state = params["ship_state"]
		(params["ship_country"].downcase == "canada") ? chkoutprovince_label.value = state.strip : chkoutstate_label.value = state.strip unless state == ""
		chkoutzip_label.value = params["ship_zip"]
		chkoutphonenumber_label.value = params["ship_phone"]
		chkoutpurchaseemail_label.value = params["ship_email"]
    chkoutconfirmemail_label.value = params["ship_email"] if params["confirm_email"].blank? if chkoutconfirmemail_label.exists
	end

  def enter_handling_options(params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
	  chkoutgift_message_field.should_exist
		unless params["renew_pur"]
			set_handling_options(params) if params["ship_country"] == 'United States of America'
		end
	  validate_cookies_and_tags(params)
	  continue_checkout_button.click
  end

  def enter_store_handling_options(params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    i = 0
    while i < handling_options_page_panel.length
      $tracer.trace("Choose Store For ISPU product")
      panel = handling_options_page_panel.at(i)
      panel.choose_store_link.click
      # FIXME: typo in finder search_store_adress
      search_store_adress.should_exist
      search_store_adress.value = params["ship_zip"]
      search_store_adress_button.should_exist
      search_store_adress_button.click
      # IMPORTANT: sleep is needed here to allow store search result to load before clicking on "choose store" link
      sleep 5
      choose_store_button.should_exist
      choose_store_button.click
      i = i +1
    end
  end
	
  def paypal_sandbox_login
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # FIXME : This needs to be pulled from the dataset
		retry_until_found(lambda{paypal_test_acct_login_field.exists != false}, 10)
	  paypal_test_acct_login_field.value = "davidturner@gamestop.com"
    paypal_test_acct_password_field.value = "4baV239056"
	  paypal_test_acct_login_button.click
	  sleep 3
  end
  
  def enter_paypal_info
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    paypal_payment_selector.click
    wait_for_landing_page_load
    paypal_chkout_button.click
    wait_for_landing_page_load
    # Log into PayPal sandbox
    $tracer.trace("Log Into PayPal")
    paypal_sandbox_login
	
    $tracer.trace("Continue through PayPal")
    retry_until_found(lambda{paypal_test_acct_continue_button.exists != false}, 10)
    paypal_test_acct_continue_button.click
    #Should be back on the gamestop.com handling options page now
    sleep 3
  end

  def enter_digital_wallet_info(digital_wallet_svc, digital_wallet_version, open_id, params)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    digital_wallet_rsp = digital_wallet_svc.perform_get_wallets(digital_wallet_version, open_id)

    digital_wallet_rsp.http_body.find_tag("payment_method").each do |payment_method|
      @payment_method = payment_method if payment_method.is_default.content.eql? ("true")
    end
    @payment_type = @payment_method.type[1].content
    if @payment_method.type[1].content == "AmericanExpress"
      @payment_type = "American Express"
    end
    wallet_to_select = "#{@payment_type} - #{@payment_method.pan_last_four.content} - Expires #{@payment_method.expiration_month.content}/#{@payment_method.expiration_year.content}"
    wallet_label.should_exist
    wallet_label.value.should == wallet_to_select
		chkoutcredit_card_security_field.value = params["cvv"]
  end
  
  def submit_and_confirm_order(params, condition)
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    submit_order
    sleep 1
    ensure_header_loaded
    validate_create_account_modal(params) if params['Role'].downcase == 'gu'
    sleep 1
    #Get the order number and confirm the prefix for appropriate order type
    order_number = validate_order_confirmation(params, condition)

    #Validate the cookies and tags associated with the order confirmation page
    validate_cookies_and_tags(params)
	  validate_tags_from_order_confirmation(params)
    return order_number
  end
  
  def submit_order
    $tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
		retry_until_found(lambda{submit_order_button.exists != false}, 10)
    submit_order_button.click
    wait_for_landing_page_load
    ensure_header_loaded
  end
	
	def change_payment_method(params)
		$tracer.trace("GameStopCheckoutFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
		change_payment_method_link.click
		wait_for_landing_page_load
		if params["use_paypal_at_payment"]
			$tracer.trace("Use PAYPAL from Cart then change PAYPAL at Payment")
      retry_until_found(lambda{paypal_payment_selector.exists != false}, 10)
			paypal_payment_selector.click
			wait_for_landing_page_load
			paypal_chkout_button.click
			wait_for_landing_page_load
			paypal_sandbox_login unless params["use_paypal_at_cart"]
      retry_until_found(lambda{paypal_test_acct_continue_button.exists != false}, 10)
			paypal_test_acct_continue_button.click
			sleep 3
		else
			$tracer.trace("Change Payment from PAYPAL to CreditCart")
			unless params['Role'].downcase == 'gu'
				wallet_label.value = "-- Select a Card--" if wallet_label.exists
			end
			enter_chkcredit_card_info(params["cc_type"], params["cc_number"], params["cc_month"], params["cc_year"], params["cvv"])
		end
	end

end
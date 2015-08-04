# This file contains the domain specific language (DSL) methods for interacting
# with the Game Stop website.
#
# The class named GameStopBrowser is the main class for this DSL.
#
# Author:: Paul Grizzaffi
# Copyright:: Copyright (c) 2011 GameStop, Inc.
# Not for external distribution.

# == Overview
# This class is the the domain specific language (DSL) class for interacting
# with the Impulse website. The methods are defined here but are
# accessed via ImpulseBrowser.
# = Usage
# See the documentation for ImpulseBrowser for examples.


module ImpulseDSL
    # Logs in to the client with the specified email and password, if
    # not already logged in as that email.
    # === Parameters:
    # _email_: email address to log in with.
    # _password_: password to log in with
    def log_in_as_user(email, password)
        raise Exception.new("The #{__method__} DSL is only supported for ImpulseClient, not for #{self.class}") unless self.is_a? ImpulseClient

        settings_menu.change_log_in_link.click
        window = login_window
        window.wait_for_open

        # if we're already logged in with the specifed email, just close the
        # window and move on.
        # Otherwise, log in using the specified email/password combo and wait
        # for the login window to go away.
        if window.account_name_field.value == email
            window.close
        else
            window.account_name_field.value = email
            window.password_field.value = password
            window.login_button.click
            window.wait_for_close
        end
    end

    # Determines which login method is available, and updates fields appropriately.
    # Usage:
    # login_account("gs@gs.com", "testing")
    # === Parameters:
    # _email_: email address used to log in
    # _password_: password used to log in
    def log_in(email, password)
        panel = login_account_panel

        panel.email_address_field.value = email
        panel.password_field.value = password

        panel.login_button.click
    end

    # Determines which create account method is available, and updates fields appropriately.
    # Usage:
    # create_account("gs@gs.com", "testing")
    # === Parameters:
    # _email_: email address used to log in
    # _password_: password used to log in
    def create_account(email, password)
        panel = create_account_panel

        panel.email_address_field.value = email
        panel.confirm_email_address_field.value = email
        panel.password_field.value = password
        panel.confirm_password_field.value = password

        panel.promotions_and_special_offers_opt_in_checkbox.checked = false

        panel.create_button.click
    end

    # Logs out of cart if logged in, otherwise does nothing. NOTE: logout functionality does not always
    # appear to work, but seems unrelated to this finder.  A optional solution is to access the service /logout.
    def log_out_cart
        if login_link.inner_text.strip.eql?("Logout")
            login_link.click
        end
    end

    # Removes all items from the cart. If the cart is empty or not present,
    # no action is taken.
    def empty_cart
        while (timeout(1000).cart_list.length) > 0
            cart_list.at(0).remove_link.click
        end
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
        first_name_field.value = first_name
        last_name_field.value = last_name
        street_address_field.value = address1
        city_field.value = city
        state_selector.value = state_province
        zip_code_field.value = zip_postal_code
        phone_number_field.value = phone_number
    end

    # Enter payment method information by passing the apporpriate parameters for the payment method.
    # === Parameters:
    # _credit_card_type_:: value selected from the credit card type drop down list
    # _credit_card_number_:: value entered into the credit card number text box
    # _exp_month_:: value selected from the card expiration date [month] drop down list
    # _exp_year_:: value selected from the card expiration date [year] drop down list
    def enter_credit_card_info (credit_card_type, credit_card_number, credit_card_holder_name,  exp_month, exp_year, credit_card_security_code)
        credit_card_selector.value = credit_card_type
        credit_card_number_field.value = credit_card_number
        credit_card_holder_name_field.value = credit_card_holder_name
        credit_card_month_selector.value = exp_month
        credit_card_year_selector.value = exp_year
        credit_card_security_code_field.value = credit_card_security_code
    end

end



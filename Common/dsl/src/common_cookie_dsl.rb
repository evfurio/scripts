# This file contains the domain specific language (DSL) methods for interacting
# with the GameStop website, Services and related products
# Author:: DTurner / SPurewal
# Copyright:: Copyright (c) 2013 GameStop, Inc.
# Not for external distribution.
require 'digest/sha2'
require 'openssl'

module CommonCookieDSL
  # validates the presence or absence of cookies
  # Usage: validate_cookies(:secure_auth_user), validate_cookies(:authenticated_cart) etc.
  def validate_cookies(val_name)
    $tracer.trace("CommonCookieFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # cookies that can be validated
    gs_cookies = {
        cart: "GS.Cart",
        au: "GS.AU",
        ticket: "GS.Ticket",
        ticket_long: "GS.TicketLong",
        cache: "GS.Cache",
        cache_long: "GS.CacheLong"
    }
    # In this hash of hashes the key represents the validation to be performed. Add or remove cookies to be tested in the cookies_should_exist and
    # cookies_should_not_exist hashes. For example :au_cart_no_tickets validates that the AU and Cart should exist but Ticket and TicketLong should not
    cookie_validation = {
        secure_auth_user: {
            cookies_should_exist: [ gs_cookies[:au], gs_cookies[:ticket_long] ],
            cookies_should_not_exist: []
        },
        authenticated_cart: {
            cookies_should_exist: [ gs_cookies[:au], gs_cookies[:cart], gs_cookies[:ticket], gs_cookies[:ticket_long] ],
            cookies_should_not_exist: []
        },
        unsecure_auth_user: {
            cookies_should_exist: [ gs_cookies[:au], gs_cookies[:cart], gs_cookies[:ticket_long]],
            cookies_should_not_exist: [ gs_cookies[:ticket]  ]
        },
        au_cart_no_tickets: {
            cookies_should_exist: [ gs_cookies[:au], gs_cookies[:cart]],
            cookies_should_not_exist: [ gs_cookies[:ticket], gs_cookies[:ticket_long] ]
        },
        after_login_from_pur: {
            cookies_should_exist: [ gs_cookies[:au], gs_cookies[:ticket], gs_cookies[:ticket_long] ],
            cookies_should_not_exist: []
        },
        after_login_from_pur_non_secure: {
            cookies_should_exist: [ gs_cookies[:au], gs_cookies[:ticket], gs_cookies[:ticket_long] ],
            cookies_should_not_exist: [ gs_cookies[:ticket] ]
        },
        after_logout_from_pur: {
            cookies_should_exist: [ gs_cookies[:au] ],
            cookies_should_not_exist: [ gs_cookies[:ticket], gs_cookies[:ticket_long] ]
        },
    }
    # Check that the cookies that should be present do exist
    cookie_validation[val_name][:cookies_should_exist].each do |cookie_name|
      begin
        cookie = cookies.get(cookie_name)[0]
        $tracer.trace("#{cookie_name} Cookie Found? true")
        cookie.value.should_not == ""
      rescue # got an exception - cookie not found
        $tracer.trace("#{cookie_name} Cookie Found? false")
      end
    end

    # Check that the cookies that should be absent do not exist
    cookie_validation[val_name][:cookies_should_not_exist].each do |cookie_name|
      begin
        cookies.get(cookie_name)
        #if an exception was NOT raised, cookie exists - report as error
        raise ArgumentError, "#{cookie_name} should not exist!!!"
      rescue Exception => e #exception was expected, so ignore it
      end
    end
  end

  #deletes all the cookies for the current browser and verifies cookie length is equal to zero
  def delete_all_cookies_and_verify
    $tracer.trace("CommonCookieFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    cookies.delete_all
    cookies.get_all.length.should == 0
  end

  # Dump all cookies
  def dump_all_cookies
    $tracer.trace("CommonCookieFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    cookies.get_all.each do |c|
      $tracer.trace("COOKIE NAME #{c.name} COOKIE_VALUE #{c.value} COOKIE DOMAIN #{c.domain}")
    end
  end

end
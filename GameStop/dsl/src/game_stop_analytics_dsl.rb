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

module GameStopAnalyticsDSL

  # Given a capture data dot object (returned from a proxy) and a URL, an array is returned containing a list of omniture
  # request query strings for each page found for this specified URL.  The return type is a Ruby array containing a Ruby
  # Struct of "page", "url" and "query_string_hash".
  # === Paramaters:
  # _capture_data_:: capture data from a ProxyServerManager get_capture call.  (dot object)
  # _url_:: URL string in which to return request omniture query strings for.
  #         NOTE: the match uses include? so the string may be a partial URL.
  # _page_:: the capture data page to be returned, in the form of "Page #".  NOTE: The capture data returned from the
  #          get_capture call may have multiple pages.  Default: all pages returned if page is not specified.
  # _requested_query_sring_array_:: an array of query string names in which to be returned:  Default: all query strings returned.
  def get_omniture_request_query_strings_for_url(capture_data, url, page = nil, requested_query_string_array = nil)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    list = []

    entries_list = capture_data.log.entries

    unless entries_list.length > 0
      raise Exception, "no 'entries' found to test"
    end

    entries_list.each do |e|
      if e.request.exists && e.request.url.content.include?("metrics.gamestop.com") && (page.nil? || e.pageref.content.downcase == page.downcase)
        Struct.new("OmnitureQueryStringData", :page, :url, :query_string_hash)
        record = Struct::OmnitureQueryStringData.new(nil, nil, {})

        record.page = e.pageref.content
        record.url = e.request.url.content

        query_string_list = e.request.query_string
        query_string_list.each do |item|
          if requested_query_string_array.nil? || requested_query_string_array.include?(item.name.content)
            record.query_string_hash[item.name.content] = item.value.content
          end
        end

        list << record
      end
    end

    return list
  end

  # Given a omniture query string array from a call to get_omniture_request_query_strings_for_url(), trace statementes will be output
  # to the trace file in a standarized way, displaying each of the query strings as well as the page number from the capture, plus the
  # full url.
  # === Parameters:
  # _omniture_query_string_array_:: Ruby Array of Struct::OmnitureQueryStringData, generated from the call to get_omniture_request_query_strings_for_url
  def trace_omniture_request_query_strings(omniture_query_string_array)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    omniture_query_string_array.each do |rec|
      if rec.class.eql?(Struct::OmnitureQueryStringData)
        $tracer.trace("#{rec.page} => url: #{rec.url}")
        rec.query_string_hash.each do |k, v|
          $tracer.trace("\t#{k}: #{v}")
        end
      else
        raise Exception, "omniture query string array data must be from get_omniture_request_query_strings_for_url() call"
      end
    end
  end


  def validate_omniture_tags (event)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    ###################################################################################
    # Validate the Omniture tags
    # === Parameters:passed based on event(s):
    #	EVENT_ACCOUNT_CREATED		--		event14
    #	EVENT_ACCOUNT_CREATED2		--		event39
    #	EVENT_ACCOUNT_CREATED_FROMGUEST		--		event23
    #	EVENT_ACCOUNT_LOGIN_SUCCESSFUL		--		event31
    #	EVENT_ACCOUNT_LOGIN_UNSUCCESSFUL		--		event32
    #	EVENT_ACCOUNT_LOGIN_VIEWED		--		event12
    #	EVENT_ACCOUNT_MERGESUCCESSFUL		--		event28
    #	EVENT_ACCOUNT_MERGEUNSUCCESSFUL		--		event29

    #Cart & Checkout events
    #	EVENT_CART_LINEITEMADDED		--		scAdd
    #	EVENT_CART_FIRSTLINEITEMADDED		--		scOpen
    #	EVENT_CART_PREORDERADDED		--		event36
    #	EVENT_CART_LINEITEMREMOVED		--		scRemove
    #	EVENT_CART_PROMOCODEADDED		--		event9
    #	EVENT_CART_PROMOCODENOTADDED		--		event10
    #	EVENT_CHECKOUT_AGEGATE		--		event11
    #	EVENT_CHECKOUT_BEGINS		--		scCheckout
    #	EVENT_CHECKOUT_BILLINGADDRESS		--		event17
    #	EVENT_CHECKOUT_BILLINGANDSHIPPINGSAME		--		event16
    #	EVENT_CHECKOUT_DISCOUNT		--		event7
    #	EVENT_CHECKOUT_FAILED		--		event22
    #	EVENT_CHECKOUT_GIFTCARDTOTAL		--		event27
    #	EVENT_CHECKOUT_GIFTMESSAGEADDED		--		event19
    #	EVENT_CHECKOUT_ISPUREVENUE		--		event37
    #	EVENT_CHECKOUT_NEWSLETTERSIGNUP		--		event13
    #	EVENT_CHECKOUT_ORDERCONF		--		purchase
    #	EVENT_CHECKOUT_PAYMENTANDREVIEW		--		event20
    #	EVENT_CHECKOUT_SHIPPINGADDRESS		--		event15
    #	EVENT_CHECKOUT_SHIPPINGCOST		--		event8
    #	EVENT_CHECKOUT_SHIPPINGOPTIONS		--		event18
    #	EVENT_CHECKOUT_ORDERPREVIEW		--		event21
    #	EVENT_CHECKOUT_ORDERFAILED		--		event22
    #	EVENT_CHECKOUT_TAX		--		event6
    #	EVENT_NEWSLETTER_SIGNUP		--		event38

    ###################################################################################

    # Get Page Source
    pagesrc = source

    @csvfile = "C:/D-CON/QATestProjects/QAAutomationScripts-DEV/GameStop/spec/UI/GS/omniture_expected_values.csv"
    csv_data = CSV.read @csvfile
    headers = csv_data.shift.map { |i| i.to_s }
    string_data = csv_data.map { |row| row.map { |cell| cell.to_s } }
    array_of_hashes = string_data.map { |row| Hash[*headers.zip(row).flatten] }
    ierrorcount = 0

    File.open (@csvfile) do |f|
      columns = f.readline.chop.split (',')
      table = []
      until f.eof?
        row = f.readline.chop.split (',')
        row = columns.zip(row).flatten
        table << Hash[*row]
      end

      table.each do |rows|
        if rows["sitecatalyst_event"] == event

          puts rows

          # Pagename
          begin
            omnistr = rows["pagename"]
            omnivalue = rows["pagevalue"]
            omniture_page_validation(omnistr, omnivalue, pagesrc)
          rescue
            puts "*** Error:  Omniture tag #{omnistr}: value: #{omnivalue} does not exist on page ***"
            ierrorcount = ierrorcount +1
          end
          # channel
          begin
            omnistr = rows["channel"]
            omnivalue = rows["channelvalue"]
            omniture_page_validation(omnistr, omnivalue, pagesrc)
          rescue
            puts "*** Error:  Omniture tag #{omnistr}: value: #{omnivalue} does not exist on page ***"
            ierrorcount = ierrorcount +1
          end
          # prop1
          begin
            omnistr = rows["prop1"]
            omnivalue = rows["prop1value"]
            omniture_page_validation(omnistr, omnivalue, pagesrc)
          rescue
            puts "*** Error:  Omniture tag #{omnistr}: value: #{omnivalue} does not exist on page ***"
            ierrorcount = ierrorcount +1
          end
          # prop14
          begin
            omnistr = rows["prop14"]
            omnivalue = rows["prop14value"]
            omniture_page_validation(omnistr, omnivalue, pagesrc)
          rescue
            puts "*** Error:  Omniture tag #{omnistr}: value: #{omnivalue} does not exist on page ***"
            ierrorcount = ierrorcount +1
          end
          # prop21
          begin
            omnistr = rows["prop21"]
            omnivalue = rows["prop21value"]
            omniture_page_validation(omnistr, omnivalue, pagesrc)
          rescue
            puts "*** Error:  Omniture tag #{omnistr}: value: #{omnivalue} does not exist on page ***"
            ierrorcount = ierrorcount +1
          end
          # Events
          begin
            omnistr = rows["events"]
            omnivalue = rows["eventsvalue"]
            omniture_page_validation(omnistr, omnivalue, pagesrc)
          rescue
            puts "*** Error:  Omniture tag #{omnistr}: value: #{omnivalue} does not exist on page ***"
            ierrorcount = ierrorcount +1
          end
        end
      end
    end

    if ierrorcount > 0
      raise #"*** Error in validate_omniture_tags***"
    end
  end

  def omniture_page_validation (omnistr, omnivalue, pagesrc)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    omniture_str = /(#{omnistr}\s*=\s*')(.*)'/.match(pagesrc)[2].strip
    omniture_var_str = /(#{omnistr}\s)(.*)'/.match(pagesrc)[1].strip
    omniture_actual_var = omniture_str.split(';')[0].strip

    $tracer.trace("Omniture String Variable = #{omniture_var_str}")

    #Expected parameter should be dynamically loaded
    omniture_expected_var = omnivalue
    $tracer.trace("Expected Omniture Variable = #{omniture_expected_var}")

    #Assert the values scraped from the page source are what we defined as expected values
    omniture_actual_var.should == omniture_expected_var
  end

  #Validates if adroll tag exists
  def validate_adroll_tag
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    adroll_function = "
    adroll_adv_id = \"HGAM45IRB5GXVJPUZ3AIJV\";
    adroll_pix_id = \"CWCJVNECPVH55FDDSNFWB4\";
    (function () {
        var oldonload = window.onload;
        window.onload = function () {
            __adroll_loaded = true;
            var scr = document.createElement(\"script\");
            var host = ((\"https:\" == document.location.protocol) ? \"https://s.adroll.com\" : \"http://a.adroll.com\");
            scr.setAttribute('async', 'true');
            scr.type = \"text/javascript\";
            scr.src = host + \"/j/roundtrip.js\";
            ((document.getElementsByTagName('head') || [null])[0] ||
                document.getElementsByTagName('script')[0].parentNode).appendChild(scr);
            if (oldonload) { oldonload() }
        };
    }());

"
    adroll_script.should include adroll_function
  end

  #Validates the cookies and/or tags if set to true in csv
  def validate_cookies_and_tags(params)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    case true
      when params["do_optimizely"]
        optimizely_script.should_exist
      when params["do_adroll"]
        validate_adroll_tag
      when params["do_linkshare"]
        aff_tracking_cookie = cookies.get("AffiliateTracking")[0].value
        affiliated_tracking(aff_tracking_cookie)
      when params["do_google_analytics"]
        google_analytics_script.should_exist
    end
  end

  #Gets the EF Id from URL
  def get_ef_id(ef)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    id = ef.split("ef_id=")
		ef_id = id[1].split(":")
		$tracer.report("EF ID from URL: #{ef_id[0]}")
		return ef_id[0]
  end

  #Validates the cookies and/or tags if set to true in csv
  def validate_tags_from_order_confirmation(params)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    case true
      when params["do_optimizely"]
        check_for_optimizely_function
      when params["do_adroll"]
        check_for_adroll_function
      when params["do_ci"]
        channel_intelligence_script.should_exist
    end
  end
	
	def get_ef_cookies(ef)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
		capture_data = $proxy.get_capture
		$tracer.trace(capture_data.formatted_json)
		
		url = return_current_url
    ef_cookies = get_request_from_url((capture_data), url)
		trace_request_cookies(ef_cookies, ef)
	end

  #Gets the Affiliate ID, Tracking ID and Source ID from AffiliateTracking cookie
  def affiliated_tracking(aff_tracking_cookie)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    @aff_tracking_cookie_split = aff_tracking_cookie.split("&")
    @aff_tracking_cookie_split.each do |type|
      if type.include?("affID")
        @id = type.split("=")
        @affID = @id[1]
      end
      if type.include?("trackingID")
        @id = type.split("=")
        @trackingID = @id[1]
      end
      if type.include?("sourceID")
        @id = type.split("=")
        @sourceID = @id[1]
      end
    end

    #Assert: affID is always 77777 | trackingID and sourceID should not be null
    @affID.should == "77777"
    @trackingID.should_not == ""
    @sourceID.should_not == ""
  end

  #Validates the optimizely function
  def check_for_optimizely_function
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    optimizely_adroll_function.should include "window['optimizely'] = window['optimizely'] || [];"
    optimizely_adroll_function.should include "window['optimizely'].push([\"trackEvent\", \"purchase\", { \"revenue\": totalSaleInCents }]);"
  end

  #Validates the adroll function
  def check_for_adroll_function
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    $tracer.trace("#{optimizely_adroll_function}")
    #If product has NO discount the finder used is confirm_subtotal_value else it will use the confirm_prediscount_subtotal finder
		order_confirm_subtotal = confirm_prediscount_subtotal.exists ? confirm_prediscount_subtotal.innerText.gsub(/[$]/, '') : confirm_subtotal_value.innerText.gsub(/[$]/, '')
    $tracer.trace("adroll_conversion_value_in_dollars = '#{order_confirm_subtotal}'")
    $tracer.trace("adroll_custom_data = { \"ORDER_ID\": \"#{order_confirmation_number}\"")
    optimizely_adroll_function.should include "adroll_conversion_value_in_dollars = '#{order_confirm_subtotal}'"
    optimizely_adroll_function.should include "adroll_custom_data = { \"ORDER_ID\": \"#{order_confirmation_number}\""
  end

  #Checks for adroll on pages like Search, Account Details, Order History and Platform PS3
  #TODO : This should really be an independent test or baked in as validation on other scripts testing this functionality
  def check_adroll_on_other_pages(params, start_page)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    if params["login"] == "" and params["password"] == ""
      open("#{start_page}/Profiles/OrderTrackingLogin.aspx")
      order_lookup_email.value = "robertsantos@gamestop.com"
      order_lookup_confirmation_number.value = "4131015095782760"
      order_lookup_button.click
      wait_for_landing_page_load
      validate_cookies_and_tags(params)
    else
      open("#{start_page}/Profiles/MyAccount.aspx")
      wait_for_landing_page_load
      validate_cookies_and_tags(params)

      open("#{start_page}/Orders/OrderHistory.aspx")
      wait_for_landing_page_load
      validate_cookies_and_tags(params)

      open("#{start_page}/ps3")
      wait_for_landing_page_load
      validate_cookies_and_tags(params)

      search_button.click
      wait_for_landing_page_load
      validate_cookies_and_tags(params)
    end
  end

	def get_request_from_url(capture_data, url, page = nil, requested_cookie_array = nil)
		$tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    list = []
		entries_list = capture_data.log.entries
    $tracer.trace(entries_list)
    unless entries_list.length > 0
      raise Exception, "no 'entries' found to test"
    end

    entries_list.each do |e|
			if e.request.exists && (e.request.url.content.include?("pixel.everesttech.net") && e.request.url.content.include?("qa.gamestop.com")) && (page.nil? || e.pageref.content.downcase == page.downcase)
        Struct.new("CookieData", :page, :url, :cookie_hash)
        record = Struct::CookieData.new(nil, nil, {})
				$tracer.report("PageRef :: #{e.pageref.content}")
				$tracer.report("URL :: #{e.request.url.content}")
				cookies_list = e.response.cookies
        cookies_list.each do |item|
          if requested_cookie_array.nil? || requested_cookie_array.include?(item.name.content)
            record.cookie_hash[item.name.content] = item.value.content
          end
        end
        list << record
			end
    end
		
		return list
  end
	
	def trace_request_cookies(ef_cookies, ef_id_from_url)
		$tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    ef_cookies.each do |rec|
      if rec.class.eql?(Struct::CookieData)
        rec.cookie_hash.each do |k, v|
          $tracer.trace("\t ------ #{k}: #{v}")
					v.should include ef_id_from_url
					$tracer.report("EF cookie (should contain EF ID from URL) ::   #{v}")
        end
      else
        raise Exception, "ef cookies must be from get_request_from_url() call"
      end
    end
  end
	
	#Gets the Store Number from URL
  def get_store_number_from_url(url)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    store = url.split("store=")
		store_number = store[1].split("&")
		$tracer.report("Store Number from URL ::::   #{store_number[0]}")
		return store_number[0]
  end
	
	#Gets the store number and events from omniture query strings
  def get_store_and_event_from_query_strings(omniture_query_string_array)
    $tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    omniture_query_string_array.each do |rec|
      if rec.query_string_hash["g"].include?("StoreSearch")
        $tracer.trace("#{rec.page} => url: #{rec.url}")
        rec.query_string_hash.each do |k, v|
          $tracer.trace("\t#{k}: #{v}")
					events1 = rec.query_string_hash["events"].split(",")
					@store_search_event = events1[0]
					# @store_search_event.should == 'event33'
				end
      end
			if rec.query_string_hash["g"].include?("HoldRequest")
        $tracer.trace("#{rec.page} => url: #{rec.url}")
        rec.query_string_hash.each do |k, v|
          $tracer.trace("\t#{k}: #{v}")
					events2 = rec.query_string_hash["events"].split(",")
					@hold_request_event = events2[0]
					# @hold_request_event.should == 'event34'
					@c15_value = rec.query_string_hash["c15"]
				end
      end
    end
		
		return @store_search_event, @hold_request_event, @c15_value
  end

	#Gets eVar23 - should be equal to paypal if params["use_paypal_at_cart"] is true
	def get_payment_mode_from_query_strings(omniture_query_string_array)
		$tracer.trace("GameStopAnalyticsFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    omniture_query_string_array.each do |rec|
      if rec.query_string_hash["g"].include?("Payments") and rec.query_string_hash["oid"].include?("InitiatePayPalOrderProcess")
        $tracer.trace("#{rec.page} => url: #{rec.url}")
        rec.query_string_hash.each do |k, v|
          $tracer.trace("\t#{k}: #{v}")
					@v23 = rec.query_string_hash["v23"] 
				end
      end	
    end
		$tracer.trace("eVar23: #{@v23}")
		@v23.should == "paypal"
	end
	
end
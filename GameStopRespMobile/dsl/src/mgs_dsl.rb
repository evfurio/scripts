require "bigdecimal"

module MGSDSL

  def get_user_agent_and_device_size(params)
    if params.headers.include?("devices") && params.headers.include?("device_name")
      devices_csv = "#{ENV['QAAUTOMATION_SCRIPTS']}\\GameStopRespMobile\\spec\\UI\\#{params["devices"]}"
      val = QACSV.new(devices_csv).find_row_by_name(params["device_name"])
      user_agent = val.find_value_by_name("User_Agent")
      device_view = val.find_value_by_name("View")
      device_width = val.find_value_by_name("Width")
      device_ht = val.find_value_by_name("Height")
    else
      $tracer.trace("devices and device_name not defined in the CSV")
    end

    return device_view, device_width.to_i, device_ht.to_i, user_agent
  end


  # Deletes any left over cookies, sets the browser type and sets up
  # the snapshot and tracer
  def setup_before_all_scenarios
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
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

  # Most common tasks run before each test (now in a nice package)
  # === Parameters:
  # _url_:: The url for the browser to open
  # _perform_empty_cart_:: defaulted parameter, true meaning the user requested empty_cart to be performed.
  def setup_before_each_scenario(url, perform_empty_cart = true)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    # Some of the stuff in this method would be a more natural fit in the after(:each) but
    # we can't use after(:each) for browser-based clean up at this time because it iterferes
    # with the automatic snapshots.
    ensure_only_one_browser_window_open
    open(url)
    wait_for_landing_page_load
    ensure_header_loaded
    #$tracer.trace("URL: #{url_data.full_url}")
    #$tracer.trace("IP: #{server_ip_address}")

    store_build_file_info

    # The lines below are a work around for the "logout link isn't there when
    # explicitly returning to the home page" bug. Clicking the GameStop
    # logo, however, does show the home page with the correct link.
    if (isIE)
      search_button.click
      wait_for_landing_page_load
      ensure_header_loaded
    end

    if (perform_empty_cart == true)
      # login unless already logged in
      unless (timeout(5000).log_out_link.exists)
        log_in_link.click
        ensure_header_loaded
        log_in(account_login_parameter, account_password_parameter)
      end

      # empty logged in user cart
      empty_new_cart
      log_out_link.click
      ensure_header_loaded

      # empty guest cart
      empty_new_cart
    else
      # logout if logged in
      log_out_link.click if timeout(5000).log_out_link.exists
      ensure_header_loaded
    end
  end

  # remove all but the first browser window from the the browser array
  def ensure_only_one_browser_window_open
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    if (browser_count > 1)
      for i in (browser_count - 1) .. 1
        browser(i).close
      end
    end

    browser(0)
  end

  # Uses the browser to obtain the build info file content and write that
  # content to the trace file.
  # NOTE: this method is indended to be called from setup_before_each_scenario
  # ONLY. Due to the way the browser indices are handled, other uses
  # are not supported.
  def store_build_file_info
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
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

#Converts currency to float type so that it can be used with comparison operators	
  def convert_currency_to_float(currency_inner_text)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #do some unit tests to cover the regex
    puts currency_inner_text
    return currency_inner_text.gsub(/[a-zA-Z()$-]/, "").to_f
  end

# Log in to a given server with the given server url (name), username, and password
  def site_login_using_server_name(server, username, password)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    cookie.all.delete
    open(server)
    wait_for_landing_page_load
    #ip = server_ip_address
    #$tracer.trace("Server: " + server)
    #$tracer.trace("IP: " + ip)

    log_in_link.click
    ensure_header_loaded
    log_in(username, password)
    log_out
  end

  #Log in using an email address and password for responsive mobile
  def mgs_log_in(email_address, password)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    mgs_email_addr_field.should_exist
    mgs_password_field.should_exist
    mgs_email_addr_field.value=email_address
    mgs_password_field.value=password
    user_login_button.should_exist
    user_login_button.click
    wait_for_landing_page_load
  end

  #Log in using an email address and password for responsive mobile with sign-in link
  def mgs_log_in_standard(email_address, password)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    mgs_hdr_mobmnu_signin_lnk.should_exist
    mgs_hdr_mobmnu_signin_lnk.click
    mgs_email_addr_field.value=email_address
    mgs_password_field.value=password
    user_login_button.should_exist
    user_login_button.click
    wait_for_landing_page_load
  end

  #Search products in responsive mobile
  def mgs_search_product(search_value)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    mgs_hdr_mobnav_search_lnk.should_exist
    mgs_hdr_mobnav_search_lnk.click
    sleep 1
    mgs_hdr_mobnav_search_input.should_exist
    mgs_hdr_mobnav_search_input.value=search_value
    sleep 2
    send_keys(KeyCodes::KEY_ENTER)
  end

# This really needs to be refactored.  ### REFACTOR ###	
  def get_txt
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    build_info_file = []
    ["qa.gamestop.com", "dl1gsqweb03.testecom.pvt", "dl1gsqweb04.testecom.pvt", "dl1gsqweb05.testecom.pvt", "dl1gsqweb06.testecom.pvt", "dl1gsqweb07.testecom.pvt", "dl1gsqweb08.testecom.pvt"].each { |pg| build_info_file << find_build_info_file_from_server(pg);
    }
    return build_info_file
  end

# Need to get rid of these methods if not used any longer... 
# Check HOPS script to see if it's using it
  def get_database_results(server, database, sql)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    dbh = dbi_handle(server, database)
    sth = dbh.execute(sql)
    rows = []
    sth.fetch_hash { |h| rows << h }
    sth.finish
    dbh.disconnect if dbh
    return rows
  end

  #Getting an element from a finder and an attribute value
  #Very useful in cases when finding an element through an array that has a particular attribute value of interest
  def get_element_from_attrib_value(element_finder,attrib_name,attrib_value)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    total_input=element_finder.length-1
    element_to_return=nil
    attrib_value_to_detect=nil
    for i in 0..total_input
      attrib_value_to_detect=element_finder.at(i).get(attrib_name)
      if attrib_value_to_detect!=nil
        if attrib_value_to_detect.strip.downcase.include?attrib_value
          element_to_return=element_finder.at(i)
          break
        end
      end
    end

    return element_to_return
  end

  #Getting an array of element from a finder and an attribute value
  #Very useful in cases when finding an element through an array that has a particular attribute value of interest
  def get_element_arr_from_attrib_value(element_finder,attrib_name,attrib_value)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    total_input=element_finder.length-1
    element_to_return=[]
    attrib_value_to_detect=nil
    for i in 0..total_input
      attrib_value_to_detect=element_finder.at(i).get(attrib_name)
      if attrib_value_to_detect!=nil
        if attrib_value_to_detect.strip.downcase.include?attrib_value
          element_to_return<<element_finder.at(i)
          break
        end
      end
    end

    return element_to_return
  end

  #Getting an element from a finder and an inner text
  #Very useful in cases when finding an element through an array that has a particular inner text of interest
  def get_element_from_inner_text_match(element_finder,inner_text_value)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    total_input=element_finder.length-1
    element_to_return=nil
    inner_text_value_to_detect=nil
    inner_text_value=inner_text_value.downcase
    for i in 0..total_input
      inner_text_value_to_detect=element_finder.at(i).innerText
      if inner_text_value_to_detect!=nil

        if inner_text_value_to_detect.strip.downcase.include?inner_text_value
          $tracer.trace("Found: #{inner_text_value}")
          element_to_return=element_finder.at(i)
          break
        end
      end
    end

    if element_to_return==nil
      $tracer.trace("Not Found: #{inner_text_value}")
    end

    return element_to_return
  end

  #Finding an element from its array using an index then trigger click if found
  def select_and_click(element_finder,index)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    if element_finder.length>0
       element_finder.at(index).should_exist
       element_finder.at(index).click
    else
       element_finder.should_exist
       element_finder.click
    end
  end

  #Setting the value of an element (usually input) and send an enter key event: mimics user input
  def set_value_and_enter(element_finder,value)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
     if element_finder!=nil
        element_finder.value=value
        sleep 2
        send_keys(KeyCodes::KEY_ENTER)
     end
  end

  def click_and_validate_redirect(element_finder,prev_url,present_url_source)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
     total_count=10
     while(total_count>0)
        element_finder.click
        sleep 1
        $tracer.trace("prev_url: #{prev_url}")
        $tracer.trace("present_url_source: #{present_url_source.url_data.full_url}")

        if prev_url!=present_url_source.url_data.full_url
           return true
        else
          $tracer.trace("Retry #{10-total_count+1}")
        end
        total_count-=1
     end
    return false
  end
  def get_database_results_svc(server, database, sql)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    dbh = dbi_handle(server, database)
    sth = dbh.execute(sql)
    #rows = []
    #sth.fetch_hash { |h| rows << h['variantid'] }
    hash = sth.fetch_hash
    sth.finish
    dbh.disconnect if dbh
    return hash
  end

# Another chunk of methods that need to be refactored 
########## REFACTOR ################
  def find_build_info_from_server(server)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    url = "http:\/\/#{server}/Old/9u35t0n1y/0fn1dl1ub.txt"
    version = open(url).source.match(/(^Server Path)(.*)(_\d*\.\d*)/)[3]
    version = "" if version.nil?
    return version
  end

  def parse_server_build_info_txt
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    build_info = []
    ["qa.gamestop.com", "dl1gsqweb03.testecom.pvt", "dl1gsqweb04.testecom.pvt", "dl1gsqweb05.testecom.pvt", "dl1gsqweb06.testecom.pvt", "dl1gsqweb07.testecom.pvt", "dl1gsqweb08.testecom.pvt"].each { |p| build_info << find_build_info_from_server(p);
    }
    return build_info
  end

  def parse_server_build_info_txt_prod
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    build_info = []
    ["www.gamestop.com", "dl1gspweb03.gamestop.com", "dl1gspweb04.gamestop.com", "dl1gspweb05.gamestop.com", "dl1gspweb06.gamestop.com", "dl1gspweb07.gamestop.com", "dl1gspweb08.gamestop.com"].each { |p| build_info << find_build_info_from_server(p);
    }
    return build_info
  end

  def find_build_info_file_from_server (server)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    url = "http:\/\/#{server}/Old/9u35t0n1y/0fn1dl1ub.txt"
    build_text_file = []
    open(url) do |f|
      no = 1
      f.each do |lines|
        build_text_file << lines
        no += 1
        break if no > 100
      end
      return build_text_file
    end
  end

########## REFACTOR END ################

#handles opening multiple urls passed to this method.  not sure it's really necessary...
  def prod_isalive_by_server_name(server)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    open(server)
    wait_for_landing_page_load
  end

  # Close all browsers and delete cookies.
  def close_browsers_and_delete_cookies
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
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

  # Sets the browser array index to 0
  def main_window
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    browser(0)
  end

  # Automates the browser back button
  def browser_back
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    execute("window.history.back()")
  end

  # What is this being used for?
  def state_abbriviation (state_name)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    state_hash =
        {"Armed Forces - Pacific" => "AP",
         "Armed Forces - Europe" => "AE",
         "Armed Forces - Americas" => "AA",
         "Alabama" => "AL",
         "Alaska" => "AK",
         "Arizona" => "AZ",
         "Arkansas" => "AR",
         "California" => "CA",
         "Colorado" => "CO",
         "Connecticut" => "CT",
         "Delaware" => "DE",
         "District of Columbia" => "DC",
         "Florida" => "FL",
         "Georgia" => "GA",
         "Hawaii" => "HI",
         "Idaho" => "ID",
         "Illinois" => "IL",
         "Indiana" => "IN",
         "Iowa" => "IA",
         "Kansas" => "KS",
         "Kentucky" => "KY",
         "Louisiana" => "LA",
         "Maine" => "ME",
         "Maryland" => "MD",
         "Massachusetts" => "MA",
         "Michigan" => "MI",
         "Minnesota" => "MN",
         "Mississippi" => "MS",
         "Missouri" => "MO",
         "Montana" => "MT",
         "Nebraska" => "NE",
         "Nevada" => "NV",
         "New Hampshire" => "NH",
         "New Jersey" => "NJ",
         "New Mexico" => "NM",
         "New York" => "NY",
         "North Carolina" => "NC",
         "North Dakota" => "ND",
         "Ohio" => "OH",
         "Oklahoma" => "OK",
         "Oregon" => "OR",
         "Pennsylvania" => "PA",
         "Puerto Rico" => "PR",
         "Rhode Island" => "RI",
         "South Carolina" => "SC",
         "South Dakota" => "SD",
         "Tennessee" => "TN",
         "Texas" => "TX",
         "Utah" => "UT",
         "Vermont" => "VT",
         "Virginia" => "VA",
         "Washington" => "WA",
         "West Virginia" => "WV",
         "Wisconsin" => "WI",
         "Wyoming" => "WY",				 
				 "Alberta" => "AB",
				 "British Columbia" => "BC",
				 "Manitoba" => "MB",
				 "New Brunswick" => "NB ",
				 "Newfoundland and Labrador" => "NL",
				 "Northwest Territories" => "NT",
				 "Nova Scotia" => "NS",	
				 "Nunavut" => "NU",
				 "Ontario" => "ON",
				 "Prince Edward Island" => "PE",
				 "Quebec" => "QC",
				 "Saskatchewan" => "SK",
				 "Yukon" => "YT"}

    return state_hash[state_name]
  end

  def country_code(country_name)
    $tracer.trace("GameStopRespMobileDSL: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    country_hash =
        {"United States of America" => "US",
         "Canada" => "CA",
         "Mexico" => "MX",
         "United Kingdom" => "GB",
         "Brazil" => "BR",
         "Albania" => "AL",
         "Algeria" => "DZ",
         "American Samoa" => "AS",
         "Andorra" => "AD",
         "Anguilla" => "AI",
         "Antigua and Barbuda" => "AG",
         "Argentina" => "AR",
         "Armenia" => "AM",
         "Aruba" => "AW",
         "Australia" => "AU",
         "Austria" => "AT",
         "Azerbaijan" => "AZ",
         "Bahamas" => "BS",
         "Bahrain" => "BH",
         "Bangladesh" => "BD",
         "Barbados" => "BB",
         "Belarus" => "BY",
         "Belgium" => "BE",
         "Belize" => "BZ",
         "Benin" => "BJ",
         "Bermuda" => "BM",
         "Bolivia" => "BO",
         "Bosnia and Herzegovina" => "BA",
         "Botswana" => "BW",
         "British Virgin Islands" => "VG",
         "Brunei" => "BN",
         "Burkina Faso" => "BF",
         "Burundi" => "BI",
         "Cambodia" => "KH",
         "Cameroon" => "CM",
         "Cape Verde" => "CV",
         "Cayman Islands" => "KY",
         "Central African Republic" => "CF",
         "Chad" => "TD",
         "Chile" => "CL",
         "China" => "CN",
         "Colombia" => "CO",
         "Congo" => "CG",
         "Cook Islands" => "CK",
         "Costa Rica" => "CR",
         "Croatia" => "HR",
         "Cyprus" => "CY",
         "Czech Republic" => "CZ",
         "Democratic Republic of the Congo" => "CD",
         "Denmark" => "DK",
         "Djibouti" => "DJ",
         "Dominica" => "DM",
         "Dominican Republic" => "DO",
         "Ecuador" => "EC",
         "Egypt" => "EG",
         "El Salvador" => "SV",
         "Equatorial Guinea" => "GQ",
         "Eritrea" => "ER",
         "Estonia" => "EE",
         "Ethiopia" => "ET",
         "Falkland Islands" => "FK",
         "Faroe Islands" => "FO",
         "Federated States of Micronesia" => "FM",
         "Fiji" => "FJ",
         "Finland" => "FI",
         "France" => "FR",
         "French Guiana" => "GF",
         "French Polynesia" => "PF",
         "Gabon" => "GA",
         "Gambia" => "GM",
         "Georgia" => "GE",
         "Germany" => "DE",
         "Ghana" => "GH",
         "Gibraltar" => "GI",
         "Greece" => "GR",
         "Greenland" => "GL",
         "Grenada" => "GD",
         "Guadeloupe" => "GP",
         "Guam" => "GU",
         "Guatemala" => "GT",
         "Guinea" => "GN",
         "Guinea-Bissau" => "GW",
         "Guyana" => "GY",
         "Haiti" => "HT",
         "Honduras" => "HN",
         "Hong Kong" => "HK",
         "Hungary" => "HU",
         "Iceland" => "IS",
         "India" => "IN",
         "Ireland" => "IE",
         "Israel" => "IL",
         "Italy" => "IT",
         "Jamaica" => "JM",
         "Japan" => "JP",
         "Jordan" => "JO",
         "Kazakhstan" => "KZ",
         "Kenya" => "KE",
         "Kiribati" => "KI",
         "Kuwait" => "KW",
         "Kyrgyzstan" => "KG",
         "Latvia" => "LV",
         "Lesotho" => "LS",
         "Liberia" => "LR",
         "Liechtenstein" => "LI",
         "Luxembourg" => "LU",
         "Macau" => "MO",
         "Macedonia" => "MK",
         "Madagascar" => "MG",
         "Malawi" => "MW",
         "Maldive Islands" => "MV",
         "Mali" => "ML",
         "Malta" => "MT",
         "Marshall Islands" => "MH",
         "Martinique" => "MQ",
         "Mauritania" => "MR",
         "Mauritius" => "MU",
         "Moldova" => "MD",
         "Monaco" => "MC",
         "Montserrat" => "MS",
         "Morocco" => "MA",
         "Mozambique" => "MZ",
         "Namibia" => "NA",
         "Nepal" => "NP",
         "Netherlands" => "NL",
         "New Caledonia" => "NC",
         "New Zealand" => "NZ",
         "Nicaragua" => "NI",
         "Niger" => "NE",
         "Nigeria" => "NG",
         "Norfolk Island" => "NF",
         "Northern Mariana Islands" => "MP",
         "Norway" => "NO",
         "Oman" => "OM",
         "Palau" => "PW",
         "Panama" => "PA",
         "Papua New Guinea" => "PG",
         "Paraguay" => "PY",
         "Peru" => "PE",
         "Poland" => "PL",
         "Portugal" => "PT",
         "Qatar" => "QA",
         "Rwanda" => "RW",
         "Saint Lucia" => "LC",
         "Saint Vincent and the Grenadines" => "VC",
         "San Marino" => "SM",
         "Saudi Arabia" => "SA",
         "Senegal" => "SN",
         "Seychelles" => "SC",
         "Sierra Leone" => "SL",
         "Singapore" => "SG",
         "Slovakia" => "SK",
         "Slovenia" => "SI",
         "Solomon Islands" => "SB",
         "Somalia" => "SO",
         "South Africa" => "ZA",
         "South Korea" => "KR",
         "Spain" => "ES",
         "Sri Lanka" => "LK",
         "St Kitts and Nevis" => "KN",
         "Suriname" => "SR",
         "Sweden" => "SE",
         "Switzerland" => "CH",
         "Syria" => "SY",
         "Taiwan" => "TW",
         "Tajikistan" => "TJ",
         "Tanzania" => "TZ",
         "Togo" => "TG",
         "Tonga" => "TO",
         "Trinidad and Tobago" => "TT",
         "Tunisia" => "TN",
         "Turkey" => "TR",
         "Turks and Caicos Islands" => "TC",
         "U.S. Virgin Islands" => "VI",
         "Uganda" => "UG",
         "United Arab Emirates" => "AE",
         "Uruguay" => "UY",
         "Uzbekistan" => "UZ",
         "Vanuatu" => "VU",
         "Venezuela" => "VE",
         "Wallis and Futuna Islands" => "WF",
         "Yemen" => "YE",
         "Zambia" => "ZM",
         "Zimbabwe" => "ZW"}
    return country_hash[country_name]
  end

end
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

module GameStopStoreDSL
  def find_trade_values
    store_trade_values.inner_text == 'Find Trade Values'
    store_trade_values.click
    wait_for_landing_page_load
    @store_trade_in = url_data.full_url
    $tracer.report("Validate Trade-In URL ::::: #{@store_trade_in}")
    go_back_to_store_page(@store_url)
  end

  def upcoming_events
    store_events_header.inner_text == 'Upcoming Events'
    $tracer.trace("Upcoming Events Count: #{store_event.length}")
    i=1
    while i < store_event.length
      store_event[i].should_exist
      event_url = store_event[i].call('href')
      store_event[i].click
      wait_for_landing_page_load
      @store_events = url_data.full_url
      $tracer.report("Validate Store Events URL ::::: #{@store_events}")
      url_data.full_url.should == event_url
      go_back_to_store_page(@store_url)
      i+=1
    end
  end

  def special_offers
    store_special_offers_header.inner_text == 'Special Offers'
    $tracer.trace("Special Offers Count: #{store_special_offer.length}")
    i=0
    # TODO: Only one element is found
    while i < store_special_offer.length
      store_special_offer.at(i).store_offer_name.should_exist
      $tracer.trace("Special Offer: #{store_special_offer.at(i).store_offer_name.innerText}")
      store_special_offer.at(i).store_offer_details.should_exist
      $tracer.trace("Special Offer Detail: #{store_special_offer.at(i).store_offer_details.innerText}")
      store_special_offer.at(i).store_offer_more_details.should_exist
      $tracer.trace("Special Offer Legal: #{store_special_offer.at(i).store_offer_more_details.innerText}")
      store_special_offer.at(i).store_offer_link.should_exist
      store_special_offer.at(i).store_offer_link.click
      wait_for_landing_page_load
      @store_offers = url_data.full_url
      $tracer.report("Validate Special Offers URL ::::: #{@store_offers}")
      go_back_to_store_page(@store_url)
      i+=1
    end

  end

  def get_directions
    # Get store directions
    $tracer.trace("Showing Store Directions")
    store_trade_values.inner_text == 'Get Directions'
    store_get_directions.click
    wait_for_landing_page_load
    validate_bing_map
  end

  def validate_bing_map
    # validate something on this browser's page
    $tracer.trace("Validate the word 'near' does not appear before the destination point A and B")
    browser(1).point_a_input.value.include?('near').should == false
    $tracer.trace("Point A input: #{browser(1).point_a_input.value}")
    browser(1).point_b_input.value.include?('near').should == false
    $tracer.trace("Point B input: #{browser(1).point_b_input.value}")

    $tracer.trace("Validate point A input == Your Location")
    browser(1).point_a_input.value.should == 'Your Location'

    browser(1).point_a_label.innerText.include?('near').should == false
    $tracer.trace("Point A label: #{browser(1).point_a_label.innerText}")
    browser(1).point_b_label.innerText.include?('near').should == false
    $tracer.trace("Point B label: #{browser(1).point_b_label.innerText}")

    $tracer.trace("Store Directions: #{browser(1).store_directions.innerText}")
    browser(1).close()
    browser(0)
  end

  def start_find_store(params)
    # $proxy.start_capture(true)
    find_a_store_link.click
    wait_for_landing_page_load
    store_locator_zip_code_search_field.value = ''
    store_locator_zip_code_search_field.value = params
    send_keys(KeyCodes::KEY_ENTER)
    # store_locator_zip_code_search_button.click
    sleep 3
  end

  def go_back_to_store_search
    $tracer.trace("Store functions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    wait_for_landing_page_load
    back_to_store_search.should_exist
    back_to_store_search.click
    wait_for_landing_page_load

  end

  def validate_store_details
    $tracer.trace("Store functions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    store_mall_name.should_exist
    back_to_store_search.should_exist
    store_search.should_exist
    store_details.should_exist
    store_address.should_exist
    store_phone.should_exist
    store_hours.should_exist
    store_map_locator.should_exist
    store_home_store_img.should_exist
    store_home_store.should_exist
    store_get_directions.should_exist
    store_trade_values.should_exist
    if store_events_header.exists
      store_events_header.should_exist
      store_event.should_exist
    end
    store_special_offers_header.should_exist
    store_special_offer.should_exist
  end

  def set_as_home_store
    $tracer.trace("Store functions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    store_home_store.innerText.should == 'Set as Home Store'
    $tracer.trace("Icon image: #{store_home_store_img.call('src')}")
    store_home_store_img.call("src").should include ("map-point.png")
    store_home_store.click
    sleep 2
    store_home_store.innerText.should == 'This is Your Home Store'
    store_home_store_img.call("src").should include ("puas_on.png")
    $tracer.trace("Icon image: #{store_home_store_img.call('src')}")
  end

  def remove_home_store
    $tracer.trace("Store functions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    store_home_store.innerText.should == 'This is Your Home Store'
    store_home_store_img.call("src").should include ("puas_on.png")
    $tracer.trace("Icon image: #{store_home_store_img.call('src')}")
    store_home_store.click
    sleep 2
    store_home_store.innerText.should == 'Set as Home Store'
    $tracer.trace("Icon image: #{store_home_store_img.call('src')}")
    store_home_store_img.call("src").should include ("map-point.png")
  end

  def go_back_to_store_page(store_url)
    $tracer.trace("Store functions: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    back
    wait_for_landing_page_load
    $tracer.trace("URL after hitting Back button ::::: #{url_data.full_url}")
    url_data.full_url == store_url
  end

  def list_store
    store_locator_store_list.length.should > 0
    $tracer.trace("Number of stores found: #{store_locator_store_list.length}")
    i=0
    while i < store_locator_store_list.length
      $tracer.trace("Store name: #{store_locator_store_list.at(i).store_name_link.innerText}")
      $tracer.trace("Store distance: #{store_locator_store_list.at(i).store_miles_distance.innerText}")
      i+=1
    end
  end

  def compare_previous_search
    i=0
    # @store_list = @browser.store_locator_store_list
    @store_list = []
    while i < store_locator_store_list.length
      @store_list[i] = store_locator_store_list.at(i).store_name_link.innerText
      # $tracer.trace("Search result: #{@store_list[i]}")
      i+=1
    end
    store_locator_store_list.at(0).store_name_link.click
    wait_for_landing_page_load
    back_to_store_search.click
    wait_for_landing_page_load
    i = 0
    while i < store_locator_store_list.length
      $tracer.trace("Search list after hitting back button: #{store_locator_store_list.at(i).store_name_link.innerText}")
      $tracer.trace("Search result: #{@store_list[i]}")
      store_locator_store_list.at(i).store_name_link.innerText.should == @store_list[i]
      i+=1
    end
  end

  #Desktop Automation Scripts
  def CleanScripts(script_)
    script_w=script_
    script_w=script_w.gsub("\t","")
    script_w=script_w.gsub(" ","")
    script_w=script_w.gsub("\n","")
    script_w=script_w.gsub("\r","")
    return script_w
  end

  def VisitPixelScripts()
    script_a=[]
    script_p1="var ca = document.createElement(\"script\");"
    script_p1+="ca.type =\"text/javascript\";"
    script_p1+="ca.async = true;"
    script_p1+="ca.id "
    script_p1=CleanScripts(script_p1)

    script_p2="var ca_script = document.getElementsByTagName(\"script\")[0];"
    script_p2+="ca_script.parentNode.insertBefore(ca, ca_script);"
    script_p2=CleanScripts(script_p2)
    script_a<<script_p1
    script_a<<script_p2
    return script_a
  end

  def VerifyScripts(script_container,script_source)
    total_scripts=script_container.length
    include_flg=false
    script_arr=script_source

    for i in 0..total_scripts-1
      result_flg=true
      if script_container.at(i).exists
        script_raw=script_container.at(i).innerText
        script_content=CleanScripts(script_raw)

        script_arr.each do |script_s|
          result_flg &&=script_content.include? script_s
        end

        if result_flg
          #$tracer.trace("Script: #{script_raw}")
          $tracer.trace("Script to verify exists")
          include_flg=true
          break
        end

      end
    end

    if !include_flg
      $tracer.trace("Scripts not detected")
      include_flg.should==true
    end

  end


  def store_upcoming_events
    store_locator_offers_header.inner_text == 'Upcoming Halo Launch'
    $tracer.trace("Upcoming Events Count: #{store_event.length}")
    i=0
    while i < store_event.length
      store_event[i].should_exist
      event_url = store_event[i].call('href')
      store_event[i].click
      wait_for_landing_page_load
      @store_events = url_data.full_url
      $tracer.report("Validate Store Events URL ::::: #{@store_events}")
      url_data.full_url.should == event_url
      go_back_to_store_page(@store_url)
      i+=1
    end

  end

end



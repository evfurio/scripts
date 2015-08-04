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

module GameStopSearchDSL

  # Perform search for product and filter list to available product only
  # by passing the query string as a parameter
  # === Parameters:
  # _product_:: text entered into the search text box
  def search_for_product(product)
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    search_field.value = product
    dice = self.random_value(1000)
    $tracer.trace("Chances of click vs key entry #{dice}")
    (dice > 0) ? search_button.click : self.send_keys(KeyCodes::KEY_ENTER)
    ensure_header_loaded
  end

  # Perform search for product and filter list to available product only
  # by passing the query string as a parameter and by clicking the
  # 'Pickup @ Store' link.
  # === Parameters:
  # _product_:: text entered into the search text box
  def search_for_product_with_pickup_at_store(product)
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    search_field.value = product
    search_button.click
    ensure_header_loaded
    pickup_at_store_new_link.click
    ensure_header_loaded
    breadcrumbs_label("/PickUp@Store/").should_exist
  end

  # Perform search for product and filter list to available product only
  # by passing the query string as a parameter and by clicking the
  # 'Usually Ships in 24 Hours' link.
  # === Parameters:
  # _product_:: text entered into the search text box
  def search_for_product_with_24_hour_availability(product)
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    search_field.value = product
    search_button.click
    wait_for_landing_page_load
    ensure_header_loaded
    product_availability_ships_in_24_hours_link.click
    wait_for_landing_page_load
    ensure_header_loaded
    breadcrumbs_label("/Usually ships in 24 hours/").should_exist
  end

  # Perform a targeted search for a product with specific attributes set by a SQL Query
  # === Parameters:
  # _product_:: text entered into the search box
  def search_for_product_by_title_query(product)
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    search_field.value = product
    search_button.click
    wait_for_landing_page_load
    ensure_header_loaded
    #product_availability_ships_in_24_hours_link.should_exist
    #wait_for_landing_page_load
    #ensure_header_loaded
    #breadcrumbs_label("/Usually ships in 24 hours/").should_exist
  end


  # Perform search for product and filter list to pre-release items.
  # === Parameters:
  # _product_:: text entered into the search text box
  def search_for_product_with_pre_release(product)
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    search_field.value = product
    search_button.click
    ensure_header_loaded
    pre_release_link.click
    wait_for_landing_page_load
    ensure_header_loaded
    breadcrumbs_label("/Pre-Release/").should_exist
    wait_for_landing_page_load
  end

  # Perform search for product and filter list to Download Now
  # === Parameters:
  # _product_:: text entered into the search text box
  def search_for_product_available_for_download(product)
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    search_field.value = product
    search_button.click
    ensure_header_loaded
    available_for_download_link.click
    wait_for_landing_page_load
    ensure_header_loaded
    breadcrumbs_label("/Available for Download/").should_exist
  end

  # Verifies header tags exists.
  # === Parameters:
  # _is_canadian_server_:: boolean true if server is canadian, defaulted to false
  def verify_all_headers(is_canadian_server = false)
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    find_a_store_link.should_exist
    events_link.should_exist
    weekly_ad_link.should_exist
    gift_cards_link.should_exist
    welcome_label.should_exist
    my_account_link.should_exist
    order_history_link.should_exist
    wish_list_link.should_exist
    gamestop_logo_link.should_exist
    kongregate_logo_link.should_exist
    gameinformer_logo_link.should_exist
    powerup_rewards_join_today_link.should_exist
    xbox_360_menu.should_exist
    ps3_menu.should_exist
    pc_menu.should_exist
    wii_menu.should_exist
    _3ds_menu.should_exist
    psp_menu.should_exist
    other_systems_menu.should_exist
    my_cart_button.should_exist
    search_field.should_exist
    search_button.should_exist
    # verify swap language link if server is canadian
    swap_language_link.should_exist if is_canadian_server
  end

  # Verifies header has loaded.  Currently, verification is on the "My Cart" button exists.
  def ensure_header_loaded
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    my_cart_button.should_exist
  end

  #  This needs to change as the log_in_log_out link has been depreciated with the new header. 
  #   Need to check other elements.
  def ensure_new_header_loaded
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    gamestop_logo_link.should_exist
    xbox_360_menu.exists
    ps3_menu.exists
    pc_menu.exists
    wii_menu.exists
    _3ds_menu.exists
    #psvita_menu.exists
    find_a_store_link.should_exist
    weekly_ad_link.should_exist
    gift_cards_link.should_exist
    my_cart_button.should_exist
    search_field.should_exist
    search_button.should_exist
  end

  def verify_all_header_tags_xbox360
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    xbox_360_header_list.at(0).exists
    xbox_360_header_list.at(1).exists
    xbox_360_header_list.at(2).exists
    xbox_360_header_list.at(3).exists
    xbox_360_header_list.at(4).exists
    xbox_360_header_list.at(5).exists
  end

  def verify_all_header_tags_ps3
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    ps3_header_list.at(0).exists
    ps3_header_list.at(1).exists
    ps3_header_list.at(2).exists
    ps3_header_list.at(3).exists
    ps3_header_list.at(4).exists
    ps3_header_list.at(5).exists
  end

  def verify_all_header_tags_pc
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    pc_header_list.at(0).exists
    pc_header_list.at(1).exists
    pc_header_list.at(2).exists
    pc_header_list.at(3).exists
    pc_header_list.at(4).exists
    pc_header_list.at(5).exists
  end

  def verify_all_header_tags_wii
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    wii_header_list.at(0).exists
    wii_header_list.at(1).exists
    wii_header_list.at(2).exists
    wii_header_list.at(3).exists
    wii_header_list.at(4).exists
    wii_header_list.at(5).exists
  end

  def verify_all_header_tags_3ds
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    _3ds_header_list.at(0).exists
    _3ds_header_list.at(1).exists
    _3ds_header_list.at(2).exists
    _3ds_header_list.at(3).exists
    _3ds_header_list.at(4).exists
    _3ds_header_list.at(5).exists
  end

  def verify_all_header_tags_psvita
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    psvita_header_list.at(0).exists
    psvita_header_list.at(1).exists
    psvita_header_list.at(2).exists
    psvita_header_list.at(3).exists
    psvita_header_list.at(4).exists
    psvita_header_list.at(5).exists
  end

  def verify_all_header_tags_ps4
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

  def verify_all_header_tags_xboxone
    $tracer.trace("GameStopSearchFunctions: #{__method__}, Line: #{__LINE__}")
    $tracer.report("Should #{__method__}.")

  end

end
#USAGE NOTES#
# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_store_page_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range Store01 --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require "bigdecimal"

$tracer.mode=:on
$tracer.echo=:on
#global_functions passes the csv row object and return the parameters.
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Store Page Locator" do

  before(:all) do
    #Set proxy for the web driver
    $options.http_proxy = "localhost"
    $options.http_proxy_port = "9091"

    $proxy = ProxyServerManager.new(9091)
    @browser = WebBrowser.new(browser_type_parameter)

    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 10_000
    $snapshots.setup(@browser, :all)

    #Get the parameters from the csv dataset
    @params = $global_functions.csv
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
  end

  before(:each) do
    $proxy.inspect
    $proxy.start
    sleep 5

    @browser.delete_all_cookies_and_verify
    @browser.open("#{@start_page}")

    if @login.length > 0
      @browser.log_in_link.click
      @browser.log_in(@login, @password)
    end
  end

  after(:each) do
    $proxy.stop
    @browser.return_current_url
  end

  after(:all) do
    @browser.close
  end

  it "87785-GS Desktop: Store Pages SEO Friendly URL" do
    # This will check if Store page is redirected to SEO friendly URL
    @browser.start_find_store(@params['ship_zip'])
    $tracer.trace("Store Count:      #{@browser.store_locator_store_list.length}")
    actual_url = @browser.store_locator_store_list.at(0).store_name_link.call("href")
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    $tracer.trace("Expected URL: #{actual_url}")
    $tracer.trace("Current URL:  #{@browser.url_data.full_url}")
    @browser.url_data.full_url.should == actual_url
  end

  it "87786-GS Desktop: Store Pages SEO Friendly URL Directs to Correct Store Page" do
    # This will redirect you to Store page when passing a valid SEO friendly URL
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_locator_store_list.at(0).store_name_link.click
    store_url = @browser.url_data.full_url
    @browser.close()
    $tracer.trace("Closing browser and open with a SEO friendly URL")
    @browser = WebBrowser.new(browser_type_parameter)
    $tracer.trace("Open browser with URL: #{store_url}")
    @browser.open(store_url)
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
  end

  it "87788-GS Desktop: Store Pages Missing Value Returns to Store Search Page" do
    # This will redirect to Store Finder page if one of the value of SEO friendly URL is removed
    @browser.start_find_store(@params['ship_zip'])
    actual_url = @browser.store_locator_store_list.at(0).store_name_link.call("href")
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    omitted_url = actual_url
    city = actual_url.split("/")
    omitted_url = omitted_url.gsub("#{city[6]}/","")
    $tracer.trace("Omitting city:#{city[6]}")
    omitted_url = omitted_url.gsub("#{city[7]}/","")
    $tracer.trace("Omitting store number:#{city[7]}")
    $tracer.trace("URL:          #{omitted_url}")
    omitted_url.should_not == actual_url
    @browser.open(omitted_url)
    @browser.find_a_store_link.should_exist
    @browser.store_locator_zip_code_search_field.should_exist
    @browser.store_locator_zip_code_search_button.should_exist
  end

  it "87760-GS Desktop: Store Pages implement Endeca store page cartridges and actions in chrome" do
    # This implement Endeca store page cartridges & actions - Guest user
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_locator_store_list.at(0).store_name_link.click
    @store_url = @browser.url_data.full_url
    @browser.validate_store_details

    # Validate Map Direction
    @browser.get_directions

    # Validate Trade-in
    @browser.find_trade_values

    # Validate upcoming events
    @browser.upcoming_events

    # Validate Special Offers
    @browser.special_offers
  end

  it "88451-GS Desktop: Store Pages implement Endeca store page cartridges and actions in chrome" do
    # This implement Endeca store page cartridges & actions - Authenticated user
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_locator_store_list.at(0).store_name_link.click
    @store_url = @browser.url_data.full_url
    @browser.validate_store_details

    # Validate Map Direction
    @browser.get_directions

    # Validate Trade-in
    @browser.find_trade_values

    # Validate upcoming events
    @browser.upcoming_events

    # Validate Special Offers
    @browser.special_offers

  end

  it "88452-GS Desktop: Store Pages implement Endeca store page cartridges and actions in chrome" do
    # This implement Endeca store page cartridges & actions - Authenticated user
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_locator_store_list.at(0).store_name_link.click
    @store_url = @browser.url_data.full_url
    @browser.validate_store_details

    # Validate Map Direction
    @browser.get_directions

    # Validate Trade-in
    @browser.find_trade_values

    # Validate upcoming events
    @browser.upcoming_events

    # Validate Special Offers
    @browser.special_offers

  end

  it "87790-GS Desktop: Store Pages Store Details Displayed" do
    @browser.start_find_store(@params['ship_zip'])
    actual_url = @browser.store_locator_store_list.at(0).store_name_link.call("href")
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    $tracer.trace("Expected URL: #{actual_url}")
    $tracer.trace("Current URL:  #{@browser.url_data.full_url}")
    @browser.url_data.full_url.should == actual_url
    @browser.validate_store_details
  end

  it "91315-Store Pages : Store Locator Page : URL structure in lowercase" do
    @browser.find_a_store_link.click
    @browser.wait_for_landing_page_load
    url_in_lower_case = @browser.url_data.full_url
    $tracer.trace("Url lower case: #{url_in_lower_case.downcase}")
    $tracer.trace("Url default case: #{@browser.url_data.full_url}")
    @browser.url_data.full_url.should == url_in_lower_case.downcase
    $tracer.trace("Validating URL is in lower case: #{@browser.url_data.full_url}")

  end

  it "91316-Store Pages : URL structure to be in lower case for store detail page" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    url_in_lower_case = @browser.url_data.full_url
    $tracer.trace("Store detail page Url lower case: #{url_in_lower_case.downcase}")
    $tracer.trace("Store detail page Url default case: #{@browser.url_data.full_url}")
    @browser.url_data.full_url.should == url_in_lower_case.downcase
    $tracer.trace("Validating Store detail page URL is in lower case: #{@browser.url_data.full_url}")

  end

  it "91627-GS.com-Desktop-StorePages-Verify that searchmerch is removed from SEO-friendly URL" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    contain_searchmerch = @browser.url_data.full_url.downcase.include? 'searchmerch'
    contain_searchmerch.should == false
    $tracer.trace("Store detail page Url contain 'searchmerch': #{contain_searchmerch}")
    $tracer.trace("Validating Store detail page URL does not containe 'searchmerch' : #{@browser.url_data.full_url}")
  end

  it "91628-GS.com-Dekstop-StorePages-Verify that all links no longer use searchmerch" do
    @browser.start_find_store(@params['ship_zip'])
    i=0
    while i < @browser.store_locator_store_list.length
      # Link 1
      link_url = @browser.store_locator_store_list.at(i).store_name_link.call("href")
      $tracer.trace("Link to store locator: #{link_url}")
      contain_searchmerch = link_url.include? 'searchmerch'
      contain_searchmerch.should == false
      $tracer.trace("Store Name at index(#{i}) link Url contain 'searchmerch': #{contain_searchmerch}")
      $tracer.trace("Validating Store Locator page - Store Name at index(#{i}) does not contain 'searchmerch' : #{link_url}")
      # Link 2
      link_url = @browser.store_locator_store_list.at(i).store_details_link.call("href")
      $tracer.trace("Link to store locator: #{link_url}")
      contain_searchmerch = link_url.include? 'searchmerch'
      contain_searchmerch.should == false
      $tracer.trace("Store Details at index(#{i}) link Url contain 'searchmerch': #{contain_searchmerch}")
      $tracer.trace("Validating Store Locator page - Store Details at index(#{i}) does not contain 'searchmerch' : #{link_url}")
      i+=1
    end
  end

  it "91629-GS.com-Desktop-StoreLocator-Verify that searchmerch is removed from URL" do
    @browser.find_a_store_link.click
    @browser.wait_for_landing_page_load
    contain_searchmerch = @browser.url_data.full_url.downcase.include? 'searchmerch'
    contain_searchmerch.should == false
    $tracer.trace("Store Locator page Url contain 'searchmerch': #{contain_searchmerch}")
    $tracer.trace("Validating Store Locator page URL does not containe 'searchmerch' : #{@browser.url_data.full_url}")
  end

  it "91630-GS.com-Desktop-StoreLocator-Verify that all links no longer use searchmerch" do
    @browser.find_a_store_link.should_exist
    @browser.store_locator_url_script.should_exist
    $tracer.trace("#{@browser.store_locator_url_script.innerText}")
    contain_searchmerch = @browser.store_locator_url_script.innerText.include? 'searchmerch'
    contain_searchmerch.should == false
    $tracer.trace("Url links for Store Locator page contain 'searchmerch': #{contain_searchmerch}")

  end

  it "91644-GS.com-Desktop-StorePages-Verify that title tag is updated in head" do
    @browser.start_find_store(@params['ship_zip'])
    $tracer.trace("Store Count:      #{@browser.store_locator_store_list.length}")
    actual_url = @browser.store_locator_store_list.at(0).store_name_link.call("href")
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    $tracer.trace("Expected URL: #{actual_url}")
    $tracer.trace("Current URL:  #{@browser.url_data.full_url}")
    @browser.url_data.full_url.should == actual_url

    @browser.title_page.should_exist
    $tracer.trace("Page Title: #{@browser.title_page.innerText}")
    @browser.store_mall_name.should_exist
    $tracer.trace("Store Name: #{@browser.store_mall_name.innerText}")
    brand_name = @browser.store_brand.innerText.gsub!(/[ -]/,'')
    $tracer.trace("Brand Name: #{brand_name}")
  end

  it "94971-GS.com-Desktop-StorePages-Verify that title tag is updated in a store with special characters" do
    @browser.start_find_store(@params['ship_zip'])
    $tracer.trace("Store Count:      #{@browser.store_locator_store_list.length}")
    actual_url = @browser.store_locator_store_list.at(0).store_name_link.call("href")
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    $tracer.trace("Expected URL: #{actual_url}")
    $tracer.trace("Current URL:  #{@browser.url_data.full_url}")
    @browser.url_data.full_url.should == actual_url

    url_str = actual_url.split('/')
    $tracer.trace("Store Name URL: #{url_str[-1]}")
    @browser.title_page.should_exist
    @browser.store_mall_name.should_exist
    $tracer.trace("Page Title: #{@browser.title_page.innerText}")
    store_name = @browser.store_mall_name.innerText.split("-")
    $tracer.trace("Store Name: #{store_name[0].strip}")
    brand_name = @browser.store_brand.innerText.gsub!(/[ -]/,'')
    $tracer.trace("Brand Name: #{brand_name}")
    special = "?<>'?[]}{=)(*&^%$#`~{}"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    $tracer.trace("Validate no special character (#{special}) in Page Title and URL")
    is_contain_spc = false
    if @browser.title_page.innerText =~ regex || url_str[-1] =~ regex
      is_contain_spc = true
    end
    is_contain_spc.should == false

  end

  it "94972-GS.com-Desktop-StorePages-Title tag in toolbar should follow new naming convention" do
    @browser.start_find_store(@params['ship_zip'])
    $tracer.trace("Store Count:      #{@browser.store_locator_store_list.length}")
    actual_url = @browser.store_locator_store_list.at(0).store_name_link.call("href")
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    $tracer.trace("Expected URL: #{actual_url}")
    $tracer.trace("Current URL:  #{@browser.url_data.full_url}")
    @browser.url_data.full_url.should == actual_url

    @browser.title_page.should_exist
    @browser.store_mall_name.should_exist
    $tracer.trace("Page Title: #{@browser.title_page.innerText}")
    store_name = @browser.store_mall_name.innerText.split("-")
    $tracer.trace("Store Name: #{store_name[0].strip}")
    brand_name = @browser.store_brand.innerText.gsub!(/[ -]/,'')
    $tracer.trace("Brand Name: #{brand_name}")
    $tracer.trace("Title should be equal to {Store Name} {Brand Name} Store in {City}, {ST}")
    url_data = @browser.url_data.full_url.split("/")
    $tracer.trace("City: #{url_data[6].capitalize}")
    $tracer.trace("State: #{url_data[5].upcase}")
    @browser.title_page.innerText.should == "#{store_name[0].strip}  - #{brand_name} Store in #{url_data[6].capitalize}, #{url_data[5].upcase}"

  end

  it "95992-GS.com-Desktop-StorePages-Verify that title tag is updated in head BuyMyTronics" do
    @browser.start_find_store(@params['ship_city'])
    $tracer.trace("Store Count:      #{@browser.store_locator_store_list.length}")
    i=0
    search_for_buymytronics = true
    while search_for_buymytronics
      actual_url = @browser.store_locator_store_list.at(i).store_name_link.call("href")
      $tracer.trace(@browser.store_locator_store_list.at(i).store_name_link.innerText)
      if @browser.store_locator_store_list.at(i).store_name_link.innerText.include? 'BuyMyTronics'
        search_for_buymytronics = false
        @browser.store_locator_store_list.at(i).store_name_link.click
      end
      i+=1
    end

    @browser.wait_for_landing_page_load
    $tracer.trace("Expected URL: #{actual_url}")
    $tracer.trace("Current URL:  #{@browser.url_data.full_url}")
    @browser.url_data.full_url.should == actual_url

    @browser.title_page.should_exist
    $tracer.trace("Page Title: #{@browser.title_page.innerText}")
    @browser.store_mall_name.should_exist
    $tracer.trace("Store Name: #{@browser.store_mall_name.innerText}")
    brand_name = @browser.store_brand.innerText.gsub!(/[ -]/,'')
    $tracer.trace("Brand Name: #{brand_name}")
  end

  it "94935-GS.com: Store Pages:  Verify the Addition of Schema mark up- to HTML store page" do
    @browser.start_find_store(@params['ship_zip'])
    $tracer.trace("Store Count:      #{@browser.store_locator_store_list.length}")
    actual_url = @browser.store_locator_store_list.at(0).store_name_link.call("href")
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    $tracer.trace("Expected URL: #{actual_url}")
    $tracer.trace("Current URL:  #{@browser.url_data.full_url}")
    @browser.url_data.full_url.should == actual_url
    $tracer.trace("#{@browser.store_address.get('itemprop')}")
    @browser.store_address.get('itemprop').should == 'address'
    $tracer.trace("Item type schema: #{@browser.store_address.get('itemtype')}")
    @browser.store_phone.get('itemprop').should == 'telephone'
    @browser.store_hours.get('itemprop').should == 'openingHours'
  end

  it "91645-GS.com-Desktop-StorePages-Verify a canonical tag is added to HTML of Page Details" do
    @browser.start_find_store(@params['ship_zip'])
    $tracer.trace("Store Count:      #{@browser.store_locator_store_list.length}")
    actual_url = @browser.store_locator_store_list.at(0).store_name_link.call("href")
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    $tracer.trace("Expected URL: #{actual_url}")
    $tracer.trace("Current URL:  #{@browser.url_data.full_url}")
    @browser.url_data.full_url.should == actual_url

    @browser.link_rel.should_exist
    $tracer.trace("Canonical href: #{@browser.link_rel.call("href")}")

  end

  it "94968-GS.com-Desktop-StorePages-Verify that new canonical tag does not affect other pages" do
    @browser.start_find_store(@params['ship_zip'])
    $tracer.trace("Store Count:      #{@browser.store_locator_store_list.length}")
    actual_url = @browser.store_locator_store_list.at(0).store_name_link.call("href")
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    $tracer.trace("Expected URL: #{actual_url}")
    $tracer.trace("Current URL:  #{@browser.url_data.full_url}")
    @browser.url_data.full_url.should == actual_url

    @browser.link_rel.should_exist
    $tracer.trace("Store Page Canonical tag: #{@browser.link_rel.call("href")}")

    @browser.store_trade_values.should_exist
    @browser.store_trade_values.click
    @browser.wait_for_landing_page_load
    if @browser.link_rel.exists
      $tracer.trace("Canonical tag: #{@browser.link_rel.call("href")}")
      @browser.link_rel.call("href").should_not include 'store'
    else
      $tracer.trace("No Canonical tag found")
      @browser.link_rel.should_not_exist
    end

  end

  it "94969-GS.com-Desktop-StorePages-URL should be in all lower case in canonical tag" do
    @browser.start_find_store(@params['ship_zip'])
    $tracer.trace("Store Count:      #{@browser.store_locator_store_list.length}")
    actual_url = @browser.store_locator_store_list.at(0).store_name_link.call("href")
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    $tracer.trace("Expected URL: #{actual_url}")
    $tracer.trace("Current URL:  #{@browser.url_data.full_url}")
    @browser.url_data.full_url.should == actual_url

    @browser.link_rel.should_exist
    $tracer.trace("Canonical href: #{@browser.link_rel.call("href")}")
    lower_case_url = @browser.link_rel.call("href")
    @browser.link_rel.call("href").should == lower_case_url.downcase

  end

  it "94771-GS.ocm: DeskTop: Store locator: Verify the accurate destination point when directed to bing map direction link" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.bing_map_pin[0].should_exist
    @browser.bing_map_pin[0].click
    @browser.bing_map_get_direction[1].should_exist
    @browser.bing_map_get_direction[1].click
    @browser.wait_for_landing_page_load
    # Validate Map Direction
    @browser.validate_bing_map
  end

  it "94773-GS.ocm: DeskTop: Store Pages: Verify the accurate destination point when directed to bing map direction link" do
    # This implement Endeca store page cartridges & actions - Authenticated user
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_locator_store_list.at(0).store_name_link.click
    @store_url = @browser.url_data.full_url
    @browser.validate_store_details

    # Validate Map Direction
    @browser.get_directions
  end

  it "94986-GS.ocm: DeskTop: Store Pages: Verify the accurate destination point when directed to get direction link" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_locator_store_list.at(0).store_name_link.click
    @store_url = @browser.url_data.full_url
    @browser.validate_store_details

    # Validate Map Direction
    @browser.get_directions
  end

  it "94784-GS.com: Finding store: Verify that Street address with comma should work as search criteria" do
    @browser.start_find_store("#{@params['ship_addr1']} #{@params['ship_addr1']}, #{@params['ship_city']}")
    @browser.list_store
  end

  it "94785-GS.com: Finding store : Verify that  no comma should not break the search address criteria" do
    @browser.start_find_store("#{@params['ship_addr1']} #{@params['ship_addr1']} #{@params['ship_city']}")
    @browser.list_store
  end

  it "94786-GS.com : Finding store: Verify that Lower case state tx should work as search criteria" do
    @browser.start_find_store(@params['ship_state'].downcase)
    @browser.list_store
  end

  it "94799-GS.com : Finding store: Verify that Upper case state TX should work as search criteria" do
    @browser.start_find_store(@params['ship_state'].upcase)
    @browser.list_store
  end

  it "95374-GS.com-Desktop-StorePages-UI-Back arrow on store details directs to previous search results Zip Code" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.compare_previous_search
  end

  it "95380-GS.com-Desktop-StorePages-UI-Back arrow on store details directs to previous search results City" do
    @browser.start_find_store(@params['ship_city'])
    @browser.compare_previous_search
  end

  it "95384-GS.com-Desktop-StorePages-UI-Back arrow on store details directs to previous search results State" do
    @browser.start_find_store(@params['ship_state'])
    @browser.compare_previous_search
  end

  it "95935-GS.com : Store Pages: Store Locator Lock down routing for Store Pages" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.url_data.full_url.should == "#{@start_page}/stores"
    @browser.store_locator_store_list.should_exist

  end

  it "95936-GS.com : Store Detail page : Store Locator Lock down routing for Store Pages" do
    @browser.start_find_store(@params['ship_city'])
    @browser.store_locator_store_list.should_exist
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    @browser.url_data.full_url.include? "#{@start_page}/stores/us"

  end

  it "95895-GS.com-Desktop-StorePages-Verify that URL does not change after search" do
    @browser.start_find_store(@params['ship_city'])
    @browser.url_data.full_url.should == "#{@start_page}/stores"
    @browser.store_locator_store_list.should_exist
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    @browser.store_zip_code_search_field.value = @params['ship_city']
    # @browser.store_zip_code_search_button.click
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.wait_for_landing_page_load
    # TODO - will the URL be default to store locator or to store detail page
    @browser.url_data.full_url.should == "#{@start_page}/stores"

  end

  it "95897-GS.com-Desktop-StoreLocator-Verify that URL does not change after search" do
    @browser.start_find_store(@params['ship_city'])
    @browser.url_data.full_url.should == "#{@start_page}/stores"
  end

  it "95989-GS.com-Desktop-StorePages-Verify search URL does not change after special character is inserted in search bar" do
    @browser.start_find_store("#{@params['ship_city']}&^$@")
    @browser.url_data.full_url.should == "#{@start_page}/stores"
    @browser.store_locator_store_list.should_exist
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    @browser.store_zip_code_search_field.value = @params['ship_city']
    # @browser.store_zip_code_search_button.click
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.wait_for_landing_page_load
    # TODO - will the URL be default to store locator or to store detail page
    @browser.url_data.full_url.should == "#{@start_page}/stores"

  end

  it "95990-GS.com-Desktop-StoreLocator-Verify that URL does not change when special character is inserted in search bar" do
    @browser.start_find_store("#{@params['ship_city']}&^$@")
    @browser.url_data.full_url.should == "#{@start_page}/stores"
  end

  it "96043-GS.com: Store Detail Page: Verify Set As HomeStore Functionality" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_locator_store_list.should_exist
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.validate_store_details
    @browser.set_as_home_store
    @browser.back_to_store_search.click
    @browser.wait_for_landing_page_load
    actual_result = false
    i=0
    while actual_result == false
      actual_result = (@browser.store_locator_store_list.at(i).store_locator_icon.call("style.display").eql?("inline") ? true : false )
      i+=1
    end
    actual_result.should == true
    @browser.store_locator_store_list.at(i-1).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.remove_home_store

  end

  it "96993 GS Desktop-SEO Meta tag is removed from page code Trade Center" do
    @browser.open("#{@start_page}/trade")
    @browser.meta_tag_keyword.should_not_exist

  end

  it "96994 GS Desktop-SEO Meta tag is removed from page code Store Locator" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.meta_tag_keyword.should_not_exist

  end

  it "96995 GS Desktop-SEO Meta tag is removed from page code Store Detail page" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_locator_store_list.should_exist
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.meta_tag_keyword.should_not_exist

  end

  it "96996 GS Desktop-SEO Meta tag is removed from page code Credit Application" do
    @browser.open("#{@start_page}/searchmerch/creditapplication")
    @browser.meta_tag_keyword.should_not_exist

  end

  it "96988 GS Desktop StorePageDetail-Verify the Added alternate Tags on Desktop" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_locator_store_list.should_exist
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.alternate_link.should_exist
    $tracer.trace("Mobile Link: #{@browser.alternate_link.call("href")}")
    @browser.alternate_link.call("href").should include 'm.gamestop.com'
    @browser.alternate_link.call("media").should == "only screen and (max-width: 768px)"

  end

  it "96991 GS Desktop StoreLocator-Verify the Added alternate Tags on Desktop" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.alternate_link.should_exist
    $tracer.trace("Mobile Link: #{@browser.alternate_link.call("href")}")
    @browser.alternate_link.call("href").should include 'm.gamestop.com'
    @browser.alternate_link.call("media").should == "only screen and (max-width: 768px)"

  end

  it "97159 GS Desktop StoreLocator-Span tag is replaced with H1 tag" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_search_header.should_exist
    $tracer.trace("Store Search Header: #{@browser.store_search_header.inner_text}")

  end

  it "97171 GS Desktop StoreDetailPage-SEO Verify the Updated Meta Description" do
    @browser.start_find_store(@params['ship_zip'])
    @browser.store_locator_store_list.should_exist
    @browser.store_locator_store_list.at(0).store_name_link.click
    @browser.wait_for_landing_page_load
    @browser.meta_tag_description.should_exist
    content = @browser.meta_tag_description.call("content")
    $tracer.trace("Meta Tag Content: #{content}")
    store_name = @browser.store_mall_name.inner_text.split("-")
    $tracer.trace("Store Name: #{store_name[0].rstrip} #{store_name[1].lstrip}")
    $tracer.trace("City: #{@browser.store_address_detail[1].innerText}")
    $tracer.trace("State: #{@browser.store_address_detail[2].innerText}")
    content.should == "Pre-order, buy and sell video games and electronics at #{store_name[0].rstrip} #{store_name[1].lstrip}. Check store hours & get directions to GameStop in #{@browser.store_address_detail[1].innerText} #{@browser.store_address_detail[2].innerText}."

  end

  #require 'open-uri'

  it "98297-GS.com-Desktop-StoreLocator-Verify the space between search bar and map" do
    @browser.find_a_store_link.click
    @browser.store_search_panel.should_exist

  end

  it "98344-GS.com-Desktop-StoreLocator-Special offers link is properly cased" do
    @browser.find_a_store_link.click
    $tracer.trace("Validating format: #{@browser.terms_and_condition.innerText}")
    @browser.terms_and_condition.innerText.strip.should=="Terms & Conditions"
  end

  it "98350-GS.com-Desktop-StoreLocator-Brand name wraps on second line under Store Name" do
    @browser.find_a_store_link.click
    $tracer.trace("Store Title: #{@browser.store_title_brand.innerText}")
    store_title_arr=@browser.store_title_brand.innerText.split("-")
    $tracer.trace("Store Title: #{store_title_arr[0].strip}")
    $tracer.trace("Brand Name: #{store_title_arr[1].strip}")
  end

  it "98359-GS.com-FullSiteOnMobile-StoreDetails-Location content adjusted to current view" do
    @browser.footer_full_site_link.click
    @browser.wait_for_landing_page_load
    @browser.find_a_store_link.click
    @browser.store_title_brand.click
    @browser.store_map.should_exist
    @browser.store_detail.should_exist
  end

  it "98366-GS.com-FullSiteOnMobile-StoreLocator-Verify placement of cartridges" do
    @browser.footer_full_site_link.click
    @browser.wait_for_landing_page_load
    @browser.find_a_store_link.click
    @browser.store_title_brand.click
    @browser.store_map.should_exist
    @browser.store_detail.should_exist
    @browser.store_address.should_exist
    @browser.store_phone.should_exist
  end

  it "98374-GS.com-FullSiteOnMobile-StoreDetails-Red back arrow is on details" do
    @browser.footer_full_site_link.click
    @browser.wait_for_landing_page_load
    @browser.find_a_store_link.click
    @browser.store_title_brand.click
    @browser.back_to_store_search.click

  end





  it "99224 GS.com-Verify Order Tracking Pixel on Confirmation Page-CC" do
    @browser.gs_search_field.value="Mortal Kombat"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.gs_results_header.should_exist
    @browser.gs_add_to_cart.click
    @browser.continue_checkout_anchor_button_handling.click
    catch :for_loop_end do
      for i in 1..5
        if @browser.gs_checkout_title.exists
          if (@browser.gs_checkout_title.innerText.downcase.include? "payment options")&&(@browser.gs_ats_submitorder.exists)
            $tracer.trace("Payment Option page.")
            throw :for_loop_end
          end
        end
        @browser.gs_cart_checkout_btn.should_exist
        @browser.gs_cart_checkout_btn.click
      end
    end

    @browser.VerifyScripts(@browser.gs_html,@browser.VisitPixelScripts())


  end

  it "99225 GS.com-Verify Order Tracking Pixel on HOPS Confirmation page" do

    @browser.gs_search_field.value="Destiny for Xbox One"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.gs_results_header.should_exist


    #@browser.gs_purchase_info.should_exist

    #total_links=@browser.gs_purchase_info.length
    #$tracer.trace("Purchase info link total count: #{@browser.gs_purchase_info.length}")

    @browser.pickup_at_store_link_a.should_exist
    total_a=@browser.pickup_at_store_link_a.length

    catch :for_loop_end do
      for i in 0..total_a-1

        next if @browser.pickup_at_store_link_a.at(i).p==nil

        for j in 0..@browser.pickup_at_store_link_a.at(i).p.length-1
          next if !@browser.pickup_at_store_link_a.at(i).p.at(j).exists

          if @browser.pickup_at_store_link_a.at(i).p.at(j).innerText.downcase.include? "pick up at store"
            $tracer.trace("Inner text: #{@browser.pickup_at_store_link_a.at(i).p.at(j).innerText}")
            @browser.pickup_at_store_link_a.at(i).p.at(j).click
            throw :for_loop_end
          end
        end

      end
    end

    @browser.gs_pickup_at_store_search.should_exist
    @browser.gs_pickup_at_store_search.value="New Jersey"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.gs_hops_pickup_submit_btn.should_exist
    @browser.gs_hops_pickup_submit_btn.click

    total_lnk=@browser.gs_panel_submit_no_pur.length
    for i in 0..total_lnk-1
      if @browser.gs_panel_submit_no_pur.at(i).innerText.downcase.include? "finish"

        @browser.gs_panel_submit_no_pur.at(i).click
        break
      end
    end


    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99226 GS.com Verify Order Tracking Pixel on Confirmation Page-PayPal" do
    @browser.gs_search_field.value="Mortal Kombat X"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.gs_results_header.should_exist

    @browser.gs_add_to_cart.should_exist
    @browser.gs_add_to_cart.click

    @browser.gs_cart_checkout_btn.should_exist
    @browser.gs_cart_checkout_btn.click

    catch :for_loop_end do
      for i in 1..5
        if @browser.gs_checkout_title.exists
          if (@browser.gs_checkout_title.innerText.downcase.include? "payment options")&&(@browser.gs_ats_submitorder.exists)
            $tracer.trace("Payment Option page.")
            throw :for_loop_end
          end
        end
        @browser.gs_cart_checkout_btn.should_exist
        @browser.gs_cart_checkout_btn.click
      end
    end
    @browser.gs_paypal_radio_btn.should_exist
    @browser.gs_paypal_radio_btn.click

    @browser.gs_paypal_btn.should_exist
    @browser.gs_paypal_btn.click

    @browser.VerifyScripts(@browser.gs_wrap,@browser.VisitPixelScripts())
  end


  it "99227 GS.com Verify Order Tracking Pixel on Confirmation Page-GC" do
    @browser.gs_search_field.value="Mortal Kombat X"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.gs_results_header.should_exist

    @browser.gs_add_to_cart.should_exist
    @browser.gs_add_to_cart.click

    @browser.gs_cart_checkout_btn.should_exist
    @browser.gs_cart_checkout_btn.click

    catch :for_loop_end do
      for i in 1..5
        if @browser.gs_checkout_title.exists
          if (@browser.gs_checkout_title.innerText.downcase.include? "payment options")&&(@browser.gs_ats_submitorder.exists)
            $tracer.trace("Payment Option page.")
            throw :for_loop_end
          end
        end
        @browser.gs_cart_checkout_btn.should_exist
        @browser.gs_cart_checkout_btn.click
      end
    end



  end



  it "99146 GS.com-Desktop-VisitPixel-Pixel on homepage" do
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())

  end

  it "99147 GS.com-Desktop-VisitPixel-Pixel on products details page" do
    #present_url="http://qa3.gamestop.com/xbox-one/games/battlefield-hardline/120798"
    #@browser.cookie.all.delete
    #@session_id = generate_guid
    #@browser.open("#{present_url}")

    @browser.gs_search_field.value="battlefield-hardline"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.gs_results_header.should_exist

    if @browser.gs_product_info.at(0)!=nil
      @browser.gs_product_info.at(0).click
    end

    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99148 GS.com-Desktop-VisitPixel-Pixel on search results" do
    present_url="http://qa3.gamestop.com/browse?nav=16k-3-battlefield,28zu0"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99149 GS.com-Desktop-VisitPixel-Pixel on storefronts" do
    # present_url="http://qa3.gamestop.com/xbox-one"
    @browser.gs_xbox360.should_exist
    @browser.gs_xbox360.click
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99150 GS.com-Desktop-VisitPixel-Pixel on guided search results" do
    present_url="http://qa3.gamestop.com/browse/xbox?nav=1389"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99151 GS.com-Desktop-VisitPixel-Pixel on collection pages" do
    present_url="http://qa3.gamestop.com/collection/bundles"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99152 GS.com-Desktop-VisitPixel-Pixel on store search product" do
    present_url="http://qa3.gamestop.com/Browse/StoreSearch.aspx?sku=112208&return=%2fdefault.aspx%3fnav%3d28-xu0%2c1317f"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99153 GS.com-Desktop-VisitPixel-Pixel on login" do
    @browser.gs_ats_login.should_exist
    @browser.gs_ats_login.click
    @browser.VerifyScripts(@browser.gs_header,@browser.VisitPixelScripts())
  end

  it "99154 GS.com-Desktop-VisitPixel-Pixel on trade details page" do
    present_url="http://qa3.gamestop.com/trade"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.gs_trade_value_spotlight.should_exist
    @browser.gs_trade_value_spotlight.click

    @browser.VerifyScripts(@browser.gs_header,@browser.VisitPixelScripts())
  end

  it "99155 GS.com-Desktop-VisitPixel-Pixel on landing page" do
    present_url="http://qa3.gamestop.com/mrkt/landing/ps4-first-to-know/"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99156 GS.com-Desktop-VisitPixel-Pixel on store search" do
    present_url="http://qa3.gamestop.com/stores"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header,@browser.VisitPixelScripts())
  end

  it "99158 GS.com-Desktop-VisitPixel-Pixel on cart" do
    @browser.gs_search_field.value="Mario Kart 8"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.gs_results_header.should_exist

    @browser.gs_new_product.should_exist
    @browser.gs_new_product.click
    @browser.gs_add_to_cart_a.should_exist
    @browser.gs_add_to_cart_a.click

    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99159 GS.com-Desktop-VisitPixel-Pixel on store details page" do
    present_url="http://qa3.gamestop.com/store/us/tx/euless/1782/glade-road-town-center-gamestop"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header,@browser.VisitPixelScripts())
  end

  it "99160 GS.com-Desktop-VisitPixel-Pixel on customer info" do
    present_url="https://loginqa3.gamestop.com/Profile"
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header,@browser.VisitPixelScripts())
  end

  it "99161 GS.com-Desktop-VisitPixel-Pixel on customer loyalty" do
    present_url="https://qa3.gamestop.com/PowerUpRewards/Home/Index"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header_container_d,@browser.VisitPixelScripts())
  end

  it "99162 GS.com-Desktop-VisitPixel-Pixel on my account" do
    @browser.VerifyScripts(@browser.gs_html,@browser.VisitPixelScripts())
  end

  it "99163 GS.com-Desktop-VisitPixel-Pixel on hops hold request" do
    @browser.gs_search_field.value="Mario Kart 8"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    #@browser.gs_results_header.should_exist

    @browser.pickup_at_store_link_a.should_exist
    total_a=@browser.pickup_at_store_link_a.length

    catch :for_loop_end do
      for i in 0..total_a-1

        next if @browser.pickup_at_store_link_a.at(i).p==nil

        for j in 0..@browser.pickup_at_store_link_a.at(i).p.length-1
          next if !@browser.pickup_at_store_link_a.at(i).p.at(j).exists

          if @browser.pickup_at_store_link_a.at(i).p.at(j).innerText.downcase.include? "pick up at store"
            $tracer.trace("Inner text: #{@browser.pickup_at_store_link_a.at(i).p.at(j).innerText}")
            @browser.pickup_at_store_link_a.at(i).p.at(j).click
            throw :for_loop_end
          end
        end

      end
    end

    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())


  end

  it "99164 GS.com-Desktop-VisitPixel-Pixel on checkout-login" do
    @browser.gs_search_field.value="Mario Kart 8"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.gs_results_header.should_exist

    @browser.gs_add_to_cart.should_exist
    @browser.gs_add_to_cart.click

    @browser.gs_cart_checkout_btn.should_exist
    @browser.gs_cart_checkout_btn.click

    @browser.VerifyScripts(@browser.gs_wrap,@browser.VisitPixelScripts())
  end
  it "99165 GS.com-Desktop-VisitPixel-Pixel on checkout-payment" do
    @browser.gs_search_field.value="Hyrule Warriors"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.gs_results_header.should_exist

    @browser.gs_add_to_cart.should_exist
    @browser.gs_add_to_cart.click

    @browser.gs_cart_checkout_btn.should_exist
    @browser.gs_cart_checkout_btn.click

    catch :for_loop_end do
      for i in 1..5
        if @browser.gs_checkout_title.exists
          if (@browser.gs_checkout_title.innerText.downcase.include? "payment options")&&(@browser.gs_ats_submitorder.exists)
            $tracer.trace("Payment Option page.")
            throw :for_loop_end
          end
        end
        @browser.gs_cart_checkout_btn.should_exist
        @browser.gs_cart_checkout_btn.click
      end
    end

    @browser.VerifyScripts(@browser.gs_wrap,@browser.VisitPixelScripts())
  end

  it "99167 GS.com-Desktop-VisitPixel-Pixel on checkout: handling options" do
    @browser.gs_search_field.value="Hyrule Warriors"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.gs_results_header.should_exist

    @browser.gs_add_to_cart.should_exist
    @browser.gs_add_to_cart.click

    @browser.gs_cart_checkout_btn.should_exist
    @browser.gs_cart_checkout_btn.click

    catch :for_loop_end do
      for i in 1..5
        if @browser.gs_checkout_title.exists
          if (@browser.gs_checkout_title.innerText.downcase.include? "handling options")
            $tracer.trace("Handling Options page.")
            throw :for_loop_end
          end
        end
        @browser.gs_cart_checkout_btn.should_exist
        @browser.gs_cart_checkout_btn.click
      end
    end

    @browser.VerifyScripts(@browser.gs_wrap,@browser.VisitPixelScripts())
  end

  it "99168 GS.com-Desktop-VisitPixel-Pixel on checkout-shipping address" do
    @browser.gs_search_field.value="Mario Kart 8"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.gs_results_header.should_exist

    @browser.gs_add_to_cart.should_exist
    @browser.gs_add_to_cart.click

    @browser.gs_cart_checkout_btn.should_exist
    @browser.gs_cart_checkout_btn.click

    catch :for_loop_end do
      for i in 1..5
        if @browser.gs_checkout_title.exists
          if (@browser.gs_checkout_title.innerText.downcase.include? "shipping address")
            $tracer.trace("Shipping Address page.")
            throw :for_loop_end
          end
        end
        @browser.gs_cart_checkout_btn.should_exist
        @browser.gs_cart_checkout_btn.click
      end
    end

    @browser.VerifyScripts(@browser.gs_wrap,@browser.VisitPixelScripts())
  end

  it "99169 GS.com-Desktop-VisitPixel-Pixel on order detail" do
    present_url="https://qa3.gamestop.com/Orders/OrderDetail.aspx?&on=V8ywu%2b3a0wsYccQUltM%2fLaIhlRNqTYepkqSrNcZChCVj6JJ6KG2DpqoePSagf5ZO&oid=p5mdgnteQJrJXbgF533wlvvZU9ttxVLawsngp8Z21fQ%3d"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_html,@browser.VisitPixelScripts())
  end

  it "99170 GS.com-Desktop-VisitPixel-Pixel on gift cards" do
    present_url="http://qa3.gamestop.com/gift-cards"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99172 GS.com-Desktop-VisitPixel-Pixel on checkout-billing address" do
    @browser.gs_search_field.value="Hyrule Warriors"
    @browser.send_keys(KeyCodes::KEY_ENTER)
    @browser.gs_results_header.should_exist

    @browser.gs_add_to_cart.should_exist
    @browser.gs_add_to_cart.click

    @browser.gs_cart_checkout_btn.should_exist
    @browser.gs_cart_checkout_btn.click

    catch :for_loop_end do
      for i in 1..5
        if @browser.gs_checkout_title.exists
          if (@browser.gs_checkout_title.innerText.downcase.include? "billing address")
            $tracer.trace("Billing Address page.")
            throw :for_loop_end
          end
        end
        @browser.gs_cart_checkout_btn.should_exist
        @browser.gs_cart_checkout_btn.click
      end
    end

    @browser.VerifyScripts(@browser.gs_wrap,@browser.VisitPixelScripts())
  end

  it "99175 GS.com-Desktop-VisitPixel-Pixel on order info" do
    present_url="https://qa3.gamestop.com/Orders/OrderDetail.aspx?&on=V8ywu%2b3a0wsYccQUltM%2fLaIhlRNqTYepkqSrNcZChCVj6JJ6KG2DpqoePSagf5ZO&oid=p5mdgnteQJrJXbgF533wlvvZU9ttxVLawsngp8Z21fQ%3d"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99176 GS.com-Desktop-VisitPixel-Pixel on loyalty activation" do

    present_url="https://loginqa3.gamestop.com/Profile#activatepur"
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header,@browser.VisitPixelScripts())

  end

  it "99177 GS.com-Desktop-VisitPixel-Pixel on wish list" do
    @browser.gs_ats_wish_list.should_exist
    @browser.gs_ats_wish_list.click

    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99179 GS.com-Desktop-VisitPixel-Pixel on PURCC-how to apply" do
    present_url="https://qa3.gamestop.com/searchmerch/creditapplication?"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99180 GS.com-Desktop-VisitPixel-Pixel on trade cart" do

    present_url="http://qa3.gamestop.com/trade"
    @browser.open("#{present_url}")

    @browser.gs_trade_search_menu.should_exist
    @browser.gs_trade_search_menu.click

    @browser.gs_game_search.should_exist
    @browser.gs_game_search.value="Mario Kart 8"
    @browser.send_keys(KeyCodes::KEY_ENTER)

    @browser.gs_select_trade.at(0).should_exist
    @browser.gs_select_trade.at(0).click

    @browser.gs_save_estimate.should_exist
    @browser.gs_save_estimate.click

    @browser.gs_save_trade_link.should_exist
    @browser.gs_save_trade_link.click

    #If the trade link exist, another step is needed to get there
    if @browser.gs_save_trade_link.exists
      @browser.gs_save_trade_link.click
    end
    @browser.VerifyScripts(@browser.gs_header,@browser.VisitPixelScripts())
  end
  it "99181 GS.com-Desktop-VisitPixel-Pixel on trade saved page" do
    present_url="http://qa3.gamestop.com/trade"

    @browser.open("#{present_url}")

    @browser.gs_trade_search_menu.should_exist
    @browser.gs_trade_search_menu.click

    @browser.gs_game_search.should_exist
    @browser.gs_game_search.value="Mario Kart 8"
    @browser.send_keys(KeyCodes::KEY_ENTER)

    @browser.gs_select_trade.at(0).should_exist
    @browser.gs_select_trade.at(0).click

    @browser.gs_save_estimate.should_exist
    @browser.gs_save_estimate.click


    @browser.gs_save_trade_link.should_exist
    @browser.gs_save_trade_link.click

    #If the trade link exist, another step is needed to get there
    if @browser.gs_save_trade_link.exists
      @browser.gs_save_trade_link.click
    end
    @browser.VerifyScripts(@browser.gs_header,@browser.VisitPixelScripts())
  end

  it "99182 GS.com-Desktop-VisitPixel-Pixel on PURCC-form" do
    present_url="https://qa3.gamestop.com/searchmerch/creditapplication/apply"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")

    @browser.login_email_field.should_exist
    @browser.login_password_field.should_exist
    @browser.login_email_field.value=@login
    @browser.login_password_field.value=@password
    @browser.send_keys(KeyCodes::KEY_ENTER)

    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99184 GS.com-Desktop-VisitPixel-Pixel on newsletter" do
    present_url="http://qa3.gamestop.com/Marketing/NewsletterSignUp.aspx"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())

  end

  it "99185 GS.com-Desktop-VisitPixel-Pixel on rave code" do
    present_url="http://qa3.gamestop.com/gs/ravecode/"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_html,@browser.VisitPixelScripts())
  end

  it "99186 GS.com-Desktop-VisitPixel-Pixel on reservation credit" do
    present_url="https://qa3.gamestop.com/Orders/ReservationCredit.aspx"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_form,@browser.VisitPixelScripts())
  end

  it "99187 GS.com-Desktop-VisitPixel-Pixel on weekly ad" do
    present_url="http://qa3.gamestop.com/weeklyad"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end

  it "99188 GS.com-Desktop-VisitPixel-Pixel on check store availability" do
    present_url="http://qa3.gamestop.com/Browse/StoreSearch.aspx?store=1782&fromHold=true&sku=112208"
    @browser.cookie.all.delete
    @session_id = generate_guid
    @browser.open("#{present_url}")
    @browser.VerifyScripts(@browser.gs_header_container,@browser.VisitPixelScripts())
  end



end
#Search Tests

# Usage Notes
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Search\game_stop_search_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Search\search_dataset.csv --range SearchTest --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
KEYWORDS_LIST = "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/Spec/UI/Search/keywords.csv"

describe "GS Desktop Search Scenarios" do
  $tracer.mode=:on
  $tracer.echo=:on
  $global_functions = GlobalFunctions.new()
  $tc_desc = $global_functions.desc
  $tc_id = $global_functions.id

  before(:all) do
    $options.default_timeout = 30_000
    @browser = WebBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
  end

  before(:each) do
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all()
  end

  it "#{$tc_id} #{$tc_desc}" do
    #Use the PDP implementation for getting products from the database
    (@params['search_term_override'] != "") ?
        search_term = @params['search_term_override'] :
        search_term = get_static_search_string

    #doesn't handle negative cases that doesn't return catalog information
    product_title_to_search, num_of_items_in_list = @catalog_svc.get_product_title_list_by_search(search_term, @params, @catalog_svc_version)

    @browser.open(@start_page)
    @browser.search_for_product(product_title_to_search) #<-- Need to refine the number of products returned again...

    num_of_products = @catalog_svc.get_length_for_search_term(search_term, @params, @catalog_svc_version)
    $tracer.trace(product_title_to_search)
    $tracer.trace("Number of products in search list #{num_of_products}")

    if num_of_products == 0
      @browser.search_no_result_header.exists == true
      @browser.search_no_result_header.innerText.strip == "Searched Item Not Found, Try Something Else."
      $tracer.trace("Recommended products page, no items returned for search critiera")
    elsif num_of_products == 1
      product_title = @browser.product_title
      $tracer.trace("#{product_title} == #{product_title_to_search}")
      product_title.should include(product_title_to_search)
    else
      @browser.search_result_section.exists == true
      product_list = @browser.product_list
      prod_list_length = product_list.length
      $tracer.report("How many products were returned in the list? #{prod_list_length}")
      $tracer.report("Should return less than 25 results per page")
      (prod_list_length < 25) ? length_chk = true : length_chk = false
      length_chk.should == true
      search_list_title = @browser.product_list.at(0).name_link.innerText
      $tracer.trace("#{search_list_title} == #{product_title_to_search}")
      search_list_title.should include(product_title_to_search)
    end

  end

  def get_static_search_string
    keywords = QACSV.new(KEYWORDS_LIST)
    $tracer.trace("Total number of keywords from csv #{keywords.max_row}")

    arr_keys = []
    keywords.each_with_index do |r|
      arr_keys << r.find_value_at(1)
    end
    i = 0
    product = arr_keys.sample

    return product
  end

end
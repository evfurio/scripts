### *** Recommerce ***
### d-Con %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\RCM\rcm_validate_url_query_str_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\RCM\tradevalue_dataset.csv --range RCM01 --browser chrome --or

#require "#{ENV['QAAUTOMATION_SCRIPTS']}/Recommerce/dsl/src/dsl"
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"


describe "Querystring Parameter Validation" do
  before(:all) do
    $options.default_timeout = 90_000
    $tracer.mode = :on
    $tracer.echo = :on
  end

  before(:each) do
    csv = QACSV.new(csv_filename_parameter)
    @row = csv.find_row_by_name(csv_range_parameter)
    @browser = GameStopBrowser.new(browser_type_parameter)
    @global_functions = GlobalServiceFunctions.new()
    @global_functions.csv = @row
    @global_functions.parameters
    @sql = @global_functions.sql_file
    @db = @global_functions.db_conn
    @store_search_svc, @store_search_svc_version = @global_functions.storesearch_svc
    @start_page = @global_functions.prop_url.find_value_by_name("url")
    initialize_csv_params
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    $tracer.trace("after all")
  end

  it "should be able to validate url query string" do
    url = "#{@start_page}/Recommerce/web/PrintQuote.aspx?#{@param}"
    $tracer.trace("URL ::::::::::::::::::::: #{url}")
    # @browser.open(url)

    str_uri = URI(url)
    uri_params = CGI.parse(str_uri.query)
    altered_title = CGI.escape(uri_params['title'].join)
    # altered_title = CGI.escape(altered_title.join)

    case uri_params['condition'].join
      when "1"
        altered_condition = "Working"
      when "2"
        altered_condition = "Damaged"
      when "3"
        altered_condition = "Dead"
      else
        altered_condition = ""
    end

    altered_credit_price = uri_params['credit'].join
    altered_cash_price = uri_params['cash'].join
    $tracer.trace("============================ Title        :::::    #{altered_title}")
    $tracer.trace("============================ Condition    :::::    #{altered_condition}")
    $tracer.trace("============================ credit_price :::::    #{altered_credit_price}")
    $tracer.trace("============================ cash_price   :::::    #{altered_cash_price}")

    # Get valid value from ProductCondition.aspx
    url = "#{@start_page}/Recommerce/web/ProductCondition.aspx?producttitle=#{altered_title}"
    $tracer.trace("URL ::::::::::::::::::::: #{url}")
    @browser.open(url)

    @browser.like_new_tab.should_exist
    @browser.good_tab.should_exist
    @browser.poor_tab.should_exist
    @browser.rcm_tab1_section.should_exist
    @browser.rcm_tab2_section.should_exist
    @browser.rcm_tab3_section.should_exist

    #ASSERT: By default Like New tab should be selected
    @expected_result = true
    # $tracer.trace("============================  #{@browser.rcm_tab1_section.call("style.display")}")
    actual_result = (@browser.rcm_tab1_section.call("style.display").eql?("block") ? true : false )
    actual_result.should == @expected_result

    case altered_condition
      when "Working"

      when "Damaged"
        @browser.good_tab.click
      when "Dead"
        @browser.poor_tab.click
      else

    end

    credit_price = @browser.credit_price_label.inner_text
    cash_price = @browser.cash_price_label.innerText
    $tracer.trace("============================ credit_price :::::    #{credit_price}")
    $tracer.trace("============================ cash_price   :::::    #{cash_price}")

    # #ASSERT: Query string parameters should be equal.
    @expected_result = true
    actual_credit = (credit_price == altered_credit_price ? true : false)
    actual_cash = (cash_price == altered_cash_price	? true : false)
    $tracer.trace("============================ validating parameters...")
    actual_credit.should == @expected_result
    actual_cash.should == @expected_result

  end

  def initialize_csv_params
    @param = @row.find_value_by_name("KeyWord")
  end

end

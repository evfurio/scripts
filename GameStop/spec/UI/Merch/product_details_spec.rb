# USAGE NOTES

# d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Merch\product_details_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\Merch\product_details_dataset.csv --range TFSPDPTEST --browser chrome --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "Product Details Page Test" do
  before(:all) do
    @browser = WebBrowser.new(browser_type_parameter)
    @browser.delete_internet_files(browser_type_parameter)
    $options.default_timeout = 30_000
    $snapshots.setup(@browser, :all)

    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @login = $global_functions.login
    @password = $global_functions.password
    @start_page = $global_functions.prop_url.find_value_by_name("url")
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @account_svc, @account_svc_version = $global_functions.account_svc
    @profile_svc, @profile_svc_version = $global_functions.profile_svc
  end

  before(:each) do
    @browser.delete_all_cookies_and_verify
    @session_id = generate_guid
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    $tracer.report("Last URL at EOT: #{get_url_data(@browser).full_url}")
    @browser.close_all
  end

  it "should test getting various conditions of the product details page" do
    $tracer.trace("Get products")

    # TODO:  I thought this chunk was refactored to handle direct from data set.
    @esrb_ratings = @params['esrb_rating'].split(",").join("','") if @params['esrb_rating'].length > 1
    @excluded_skus = @params['excluded_skus'].split(",").join("','") if @params['esrb_rating'].length > 1
    @conditions = @params['condition'].split(",").join("','") if @params['condition'].length > 1

    if @params['product_limit'] == "NULL"
      @product_limit = "AND D.ProductLimit = NULL"
    elsif @params['product_limit'] != ""
      @product_limit = "AND D.ProductLimit = #{@params['product_limit']}"
    else
      @product_limit = ""
    end

    sql_query = create_sql(@params['return_product_num'], @esrb_ratings, @params['on_hand_quantity'], @params['availability'], @conditions, @params['is_available'], @params['is_searchable'], @product_limit, @excluded_skus, @sql)
    # TODO: End chunk of kinda nasty code to handle multiple inputs from data set

    @results_from_file = @db.exec_sql("#{sql_query}")
    #@product_urls, product_attributes, @physical_product = @browser.get_product_from_query(@results_from_file, @catalog_svc, @catalog_svc_version, @params, @session_id)
    sku_id, *prod_attr, @product = @browser.get_product_from_query(@results_from_file, @catalog_svc, @catalog_svc_version, @params, @session_id)

    products_to_test = @product['product_urls']

    products_to_test.each_with_index do |tests, i|
      $tracer.trace(@product['product_urls'][i])
      url = @product['product_urls'][i].to_s.strip
      title = @product['display_name'][i].to_s.strip
      condition = @product['condition'][i]
      price = @product['list_price'][i].to_s.strip
      hops_enabled = @product['is_in_store_pickup_for_hops'].join.to_s.strip

      @browser.open("#{@start_page}" "#{url}")
      pur_pro = true if condition.include? "Used"

      #general_product_information
      $tracer.trace(title)
      @browser.product_title_label.innerText.should include "#{title}"

      #product_title isn't wrapped with ToolTag so we can't use the methods available for it.
      product_title = @browser.product_title
      product_title.should include "#{title}"
      @browser.we_also_recommend_label.should_exist
      @browser.product_recommendation_list_next_arrow.should_exist
      @browser.product_recommendation_list_next_arrow.click
      @browser.product_recommendation_list_previous_arrow.should_exist
      @browser.product_recommendation_list_previous_arrow.click

      @browser.buy_first_panel.should_exist
      @browser.buy_first_panel.add_to_cart_button.should_exist if @params['availability'] != "NFS"
      list_price = money_string_to_decimal(price)
      $tracer.trace("List Price #{list_price}")
      view_price = money_string_to_decimal(@browser.buy_first_panel.price)
      $tracer.trace("View Price #{view_price}")
      view_price.should == list_price
      pro_price = list_price - (list_price * 0.10)
      $tracer.trace("Pro Price #{pro_price}")

      if pur_pro == true
        pur_pro_price = money_string_to_decimal(@browser.buy_first_panel.pur_pro_price)
        pur_pro_price.should == pro_price
      end

      if condition.include? "Used"
        #@browser.buy_preowned_panel (used product required A,BO,NFS)
        @browser.buy_preowned_panel.should_exist
        @browser.buy_preowned_panel.add_to_cart_button.should_exist if @params['availability'] != "NFS"

        used_pro_price = money_string_to_decimal(@browser.buy_preowned_panel.pur_pro_price)
        used_price = money_string_to_decimal(@browser.buy_preowned_panel.price)
        used_price.should == list_price
        pur_pro_price = money_string_to_decimal(@browser.buy_first_panel.pur_pro_price)
        pur_pro_price.should == used_pro_price
      end

      if condition.include? "New"
        #@browser.buy_new_panel (new product required (A,PR,BO,NFS))
        @browser.buy_new_panel.should_exist
        @browser.buy_new_panel.add_to_cart_button.should_exist if @params['availability'] != "NFS"
        new_price = money_string_to_decimal(@browser.buy_new_panel.price)
        new_price.should == list_price
      end

      if hops_enabled == "true"
        #hops enabled product (condition agnostic, availability agnostic)
        @browser.hops_pickup_at_store_link.should_exist
        @browser.hops_pickup_at_store_tooltip.should_exist
      end
    end
  end

  # TODO : This method needs to go to the DSL
  def create_sql(return_product_num, esrb_rating, on_hand_quantity, availability, condition, is_available, searchable, product_limit, excluded_skus, sql)
    template = explode_sql_from_file(sql)
    sql = ERB.new(template).result(binding)
    $tracer.trace(sql)
    return sql
  end

  # TODO : This method needs to go to the DSL (technically this is in the framework but I only need the sql file contents returned, not executed)
  def explode_sql_from_file(filename)
    sql = ''
    filename = filename.gsub(/\\/, "/")
    if File.file?(filename)
      expanded_filename = File.realdirpath(filename)
      begin
        sql = File.read(expanded_filename)
      rescue Exception => ex
        raise ToolException.new(ex, "unable to perform sql statement, cannot read '#{expanded_filename}': #{ex.message}")
      end
    else
      raise Exception, "unable to perform sql statement: unable to locate '#{filename}'"
    end

    return sql
  end

end
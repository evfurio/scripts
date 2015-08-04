#USAGE NOTES
# # d-con %QAAUTOMATION_SCRIPTS%\GameStop\spec\Profile\forced_password_change_spec.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48600 --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require 'timeout'

$tracer.mode = :on
$tracer.echo = :on
$global_functions = GlobalFunctions.new()

describe "Forced Password Change" do

  before(:all) do
    @browser = WebBrowser.new
    @client = PasswordGenerator.new
    @params = $global_functions.csv
    @sql = $global_functions.sql_file
    @db = $global_functions.db_conn
    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    @cart_svc, @cart_svc_version = $global_functions.cart_svc
    @purchase_order_svc, @purchase_order_svc_version = $global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = $global_functions.velocity_svc
  end

  before(:each) do
    @browser.delete_all_cookies_and_verify
  end

  after(:each) do
    @browser.return_current_url
  end

  after(:all) do
    @browser.close_all
  end

  it "should get forced password change prompt" do
    @session_id = generate_guid
    path = "#{ENV['QAAUTOMATION_SCRIPTS']}/force_password_results/"
    Dir.mkdir(path) unless File.exists?(path)
    test_info = []
    csv = QACSV.new("#{ENV['QAAUTOMATION_SCRIPTS']}\\GameStop\\spec\\Profile\\force_password_change_dataset.csv")
    csv.each do |row|
      login = row.find_value_by_name("user")
      password = row.find_value_by_name("password")
      @product_urls, @matured_product, @physical_product, @condition, @db_result = @browser.load_test_skus_from_db(@db, @sql.to_s, @velocity_svc, @velocity_svc_version, @catalog_svc, @catalog_svc_version, @params, @session_id) unless @params["renew_pur"]

      gen_pwd = @client.generate_password(10)
      $tracer.trace(gen_pwd)
      status, pwd_len = @client.verify_password(gen_pwd)
      pwd_len.should be <= 50
      pwd_len.should be >= 8
      status.should == true

      header = []
      test_info = []
      #dump parameters to a csv for easy import to TFS
      header << "login, password, new_password"
      test_info << "#{login},#{password},#{gen_pwd}"

      test_info.each do |i|
        csv_builder(test_info)

        CSV.open("#{path}\\new_account_passwords_cart.csv", "a") do |csv|
          csv << @data
        end
      end
      @browser.open("http://qa.gamestop.com")
      @browser.add_products_to_cart_by_url(@product_urls, "http://qa.gamestop.com", @condition, @params, @db_result, @session_id, '', @cart_svc, @cart_svc_version, @catalog_svc, @catalog_svc_version)
      @browser.continue_checkout_button.click
      @browser.log_in(login, password)
      sleep 1

      @browser.current_password_field.value = password
      @browser.new_password_field.value = gen_pwd
      @browser.confirm_password_field.value = gen_pwd
      @browser.submit_button.click
      sleep 3

      @browser.button.className("large").click
      sleep 1
      # The user is not logged in after updating?
      @browser.log_out_link.should_exist
      @browser.log_out
      #

    end
    csv_builder(test_info)

  end

  def csv_builder(tst_info)
    test_info = tst_info.join(",")
    csv_data = "#{test_info}"

    # The parser just converts these into an array of CSV cells
    array_of_csv_cells = CSV.parse csv_data

    # The first CVS row are the headings
    @data = array_of_csv_cells.shift.map { |rd| rd.to_s }

    # Convert the array of CSV cells into an Array of Hashes
    products_in_structures = array_of_csv_cells.map do |cells|
      hsh = {}
      (cells.map { |cell| cell.to_s }).each_with_index do |cell_str, index|
        hsh[index] = cell_str
      end
      hsh
    end

    return @data
  end

end
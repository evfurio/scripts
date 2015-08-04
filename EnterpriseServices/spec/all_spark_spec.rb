#USAGE NOTES#
# this script is for the AllSparks
# all methods are associated with a manual test case in MTM
# GameInformer project/Regression Tests plan

#d-con %QAAUTOMATION_SCRIPTS%\EnterpriseServices\spec\all_spark_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\EnterpriseServices\spec\enterprise_services_dataset.csv --range TFSTCCW1
# --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --url QA_AllSpark --browser chrome --or -e "method name"

require "#{ENV['QAAUTOMATION_SCRIPTS']}/EnterpriseServices/dsl/src/dsl"

#New global functions for datasets
#$tracer.mode = :on
#$tracer.echo = :on
#$global_functions = GlobalFunctions.new()

# NOTE
# If you are using test id and test description to run specific tests, you can use the below to load.
# If you have several test methods this is not ideal.
#$tc_desc = $global_functions.desc
#$tc_id = $global_functions.id


describe "AllSparks" do

  before(:all) do
    $options.default_timeout = 30_000

    $browser = WebBrowser.new(browser_type_parameter)
    $snapshots.setup($browser, :all)
    WebBrowser.delete_temporary_internet_files(browser_type_parameter)
    @start_page = "https://globaldlcadministrationqa.testecom.pvt/DLCPlus/"

    #$browser = WebBrowser.new(browser_type_parameter)
    #$snapshots.setup($browser, :all)

    #Get the parameters from the csv dataset
    #@params = $global_functions.csv
    #@login = $global_functions.login
    #@password = $global_functions.password
    #@start_page = $global_functions.prop_url.find_value_by_name("url")
  end

  before(:each) do
    $browser.open(@start_page)
    $browser.cookie.all.delete
    #$username = @params['login']
    #$password = @params['password']
  end

  after(:all) do
    $browser.close_all()
  end

  it "should verify allspark portal home" do
    $browser.home_button.should_exist
    $browser.produt_catalog_button.should_exist
    $browser.platform_instructions_button.should_exist
  end



end
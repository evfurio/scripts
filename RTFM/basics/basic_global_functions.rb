#NOTES
# Global functions is not necessarily required by all scripts but is required for scripts that need to use the data driven
# automation model.
## Global Functions currently handles the following command line arguments:

#d-Con.bat starts the automation framework but requires a script to be executed.  Use d-Con --help for native command arguments.
# example: d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb

#--csv provides the location of the the CSV file, --range is the row to be used.  This arg is handled by d-Con.
# example: --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627

#--login - handled natively by d-con but can be pulled from the dataset.csv instead of a cmd arg.  If no cmd arg is provided
# the code will check the CSV for the value, if none exists it will ignore the value.
# example: --login qa_ui_testing1@qagsecomprod.oib.com

#--password - handled natively by d-con but can be pulled from the dataset.csv instead of a cmd arg.  If no cmd arg is provided
# the code will check the CSV for the value, if none exists it will ignore the value.
# example: --password T3sting

#--sql - Custom argument to handle providing a SQL query in a file format.  If arg not provided in the command line the code will
# check in the CSV for the value, if none exists it will be ignored.
# example: --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql

#--db - Custom argument to handle providing a database configuration for a given environment.  The environment is set by the
# --db_env range parameter.  Both arguments are provided in the command line but can be pulled from the CSV is not provided.
# If no cmd arg or CSV value is provided, this argument is ignored.
# example: --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog"

#--prop - Custom argument to handle changing properties (web sites) by providing the CSV file and the --url range value in the
# cmd arguments.  If not provided in the cmd args the code will default to the CSV for the values.  If none exists, this arg
# is ignored.
# example: --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv --url QA_GS

#--browser - This is handled by d-Con natively and not in the global functions today.  Future plans will allow this value to
# be handled through other mechanisms included the global functions.
# example: --browser chrome

#--svc - This is a custom argument to handle service endpoint configurations by designating the CSV which contains the endpoint
# addresses and the --svc_env parameter to determine which configuration to use.  This is typically used more so for the services
# specific tests or in cases where specific test setup is required through services.  The webconfig of the application will handle
# services being used by the UI, not the test script.
# example: --svc %QAAUTOMATION_SCRIPTS%\Common\config\endpoints.csv --svc_env QA_V1

#Full USAGE example:
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627 --login qa_ui_testing1@qagsecomprod.oib.com --password T3sting --sql %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\sql_queries\get_single_product.sql --db %QAAUTOMATION_SCRIPTS%\GameStop\Spec\databases.csv --db_env "QA_Catalog" --prop %QAAUTOMATION_SCRIPTS%\GameStop\Spec\properties.csv --url QA_GS --svc %QAAUTOMATION_SCRIPTS%\GameStop\Spec\endpoints.csv --svc_env QA_V1 --browser chrome --or

#Run this script
#d-Con %QAAUTOMATION_SCRIPTS%\RTFM\basics\basic_global_functions.rb --or
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"


describe "Tutorial - Global Functions" do

  before(:all) do
    #global_functions handles multiple things...
    ## Custom arguments that are passed in the command line
    ## Initializing dataset parameters for data population in scripts
    ## Initializing service endpoints
    ## Identifying build information and service assembly versions
    ## Identifying the service endpoint version (Ecomm Services only)
    @global_functions = GlobalServiceFunctions.new()
    #Get the parameters from the csv dataset
    @params = @global_functions.get_params_from_csv
    $tracer.report(@params['Property'])
    #Pass the params array to the attribute accessor in global functions
    #receives using :csv and is used by calling @csv
    @global_functions.csv = @params
    #Invoke the parameters method to handle any additional command line options we defined or check the CSV for values
    @global_functions.parameters

    @sql = @global_functions.sql_file
    @db = @global_functions.db_conn
    @login = @global_functions.login
    @password = @global_functions.password

    @catalog_svc, @catalog_svc_version = @global_functions.catalog_svc
    @start_page = @global_functions.prop_url.find_value_by_name("url")

    @cart_svc, @cart_svc_version = @global_functions.cart_svc
    @account_svc, @account_svc_version = @global_functions.account_svc
    @profile_svc, @profile_svc_version = @global_functions.profile_svc
    @digital_wallet_svc, @digital_wallet_version = @global_functions.digitalwallet_svc
    @purchase_order_svc, @purchase_order_svc_version = @global_functions.purchaseorder_svc
    @velocity_svc, @velocity_svc_version = @global_functions.velocity_svc
  end

  it "should use global functions for setup" do

  end

end


qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']

require "#{qaautomation_scripts_dir}/Common/Services/dsl_multi_services"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_account"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_cart"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_shipping"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_services_functions"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_purchase_order"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_profile"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_digital_wallet"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_catalog"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_tax"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_store_search"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_digital_content"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_payment"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_velocity"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_trade_value"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_pur_enrollment"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_fraud"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_customer_profile"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_multipass"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_store_information"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_pur_enrollment"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_configuration"
require "#{qaautomation_scripts_dir}/Common/Services/dsl_cybersource_tokenization"

require "#{qaautomation_scripts_dir}/Common/dsl/src/security"

require "#{qaautomation_scripts_dir}/Common/dsl/src/common_functions"

### TODO: convert CommonFunctions to CommonFunctionsLink and make it a class not a module
class CommonFunctionLink
  include CommonFunctions
end
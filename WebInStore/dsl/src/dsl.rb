qaautomation_dir = ENV['QAAUTOMATION_FILES']
qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']
qaautomation_finders_dir = ENV['QAAUTOMATION_FINDERS']

require "#{qaautomation_dir}/dsl/Browser/src/browser_requires"
require "#{qaautomation_finders_dir}/Common/Profile/src/profile_requires"
require "#{qaautomation_finders_dir}/WebInStore/src/web_in_store_requires"
require "#{qaautomation_scripts_dir}/WebInStore/dsl/src/web_in_store_common_dsl"

#Service Requires
require "#{qaautomation_scripts_dir}/Common/Services/game_stop_service_dsl_requires"
require "#{qaautomation_scripts_dir}/Common/Services/game_stop_service_templates_requires"

#Common Requires
require "#{qaautomation_scripts_dir}/Common/dsl/src/creditcard"
require "#{qaautomation_scripts_dir}/Common/dsl/src/common_cookie_dsl"
require "#{qaautomation_scripts_dir}/Common/dsl/src/global_functions"
require "#{qaautomation_scripts_dir}/Common/dsl/src/common_functions"
require "#{qaautomation_scripts_dir}/Common/dsl/src/hosts_dsl"
require "#{qaautomation_scripts_dir}/Common/dsl/src/password_generator"
require "#{qaautomation_scripts_dir}/Common/dsl/src/test_harness"

#Monitor Requires
require "#{qaautomation_scripts_dir}/Monitoring/dsl/src/monitoring_dsl"

#Continuous Integration Requires
require "#{qaautomation_scripts_dir}/CI_Scripts/dsl/src/ci_script_dsl"

# Method called during Browser instantiation.  Includes modules defined in QAAUTOMATION_SCRIPTS.
def include_dsl_modules
  WebBrowser.include_module(:WebInStoreCommonDSL)
  WebBrowser.include_module(:CommonFunctions)
  WebBrowser.include_module(:CommonCookieDSL)
  WebBrowser.include_module(:TestHarnessDSL)
  WebBrowser.include_module(:MonitoringDSL)
	WebBrowser.include_module(:ContinuousIntegrationDSL)
end

class SoapService
  include GameStopSoapServicesDSL
end

class GlobalServiceFunctions
  include GameStopGlobalServiceFunctionsDSL
end

class StoreSearchService
  include GameStopStoreSearchServiceDSL
end

class CatalogService
  include GameStopCatalogServiceDSL
end

class PurchaseOrderService
  include GameStopPurchaseOrderServiceDSL
end
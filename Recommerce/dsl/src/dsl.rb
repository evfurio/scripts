qaautomation_dir = ENV['QAAUTOMATION_FILES']
qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']
qaautomation_finders_dir = ENV['QAAUTOMATION_FINDERS']

require "#{qaautomation_dir}/dsl/Browser/src/browser_requires"
require "#{qaautomation_finders_dir}/Common/Profile/src/profile_requires"
require "#{qaautomation_scripts_dir}/Recommerce/dsl/src/recommerce_dsl"

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

# Method called during Browser instantiation.  Includes modules defined in QAAUTOMATION_SCRIPTS.
def include_dsl_modules
    WebBrowser.include_module(:RecommerceDSL)
    WebBrowser.include_module(:CommonFunctions)
    WebBrowser.include_module(:CommonCookieDSL)
    WebBrowser.include_module(:TestHarnessDSL)
    WebBrowser.include_module(:MonitoringDSL)
end

# GameStopSoapServicesDSL is mixed into SoapServices.  The reason we can monkey patch SoapServices
# instead of using include_modules as above, is due to the fact that SoapServices does
# not dynamically include modules at instantiation.
class SoapService
    include GameStopSoapServicesDSL
end

class GlobalServiceFunctions
	include GameStopGlobalServiceFunctionsDSL
end

class TradeValueService
	include GameStopTradeValueServiceDSL
end
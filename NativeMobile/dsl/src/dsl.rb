qaautomation_dir = ENV['QAAUTOMATION_FILES']
qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']
qaautomation_finders_dir = ENV['QAAUTOMATION_FINDERS']

#GameStop Requires
#TODO: require the "finders" for native app
require "#{qaautomation_dir}/dsl/NativeApp/src/native_app_requires"

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
require "#{qaautomation_scripts_dir}/Common/dsl/src/sqlite_db_manager"
require "#{qaautomation_scripts_dir}/Common/dsl/src/test_harness"

#Monitor Requires
require "#{qaautomation_scripts_dir}/Monitoring/dsl/src/monitoring_dsl"

#Continuous Integration Requires
require "#{qaautomation_scripts_dir}/CI_Scripts/dsl/src/ci_script_dsl"

# Method called during Browser instantiation.  Includes modules defined in QAAUTOMATION_SCRIPTS.
def include_dsl_modules
  WebBrowser.include_module(:CommonFunctions)
  WebBrowser.include_module(:CommonCookieDSL)
  WebBrowser.include_module(:TestHarnessDSL)
  WebBrowser.include_module(:MonitoringDSL)
  WebBrowser.include_module(:ContinuousIntegrationDSL)
end

# GameStopSoapServicesDSL is mixed into SoapServices.  The reason we can monkey patch SoapServices
# instead of using include_modules as above, is due to the fact that SoapServices does
# not dynamically include modules at instantiation.
class SoapService
  include GameStopSoapServicesDSL
end

class AccountService
  include GameStopAccountServiceDSL
end

class CartService
  include GameStopCartServiceDSL
end

class PurchaseOrderService
  include GameStopPurchaseOrderServiceDSL
end

class ProfileService
  include GameStopProfileServiceDSL
end

class DigitalWalletService
  include GameStopDigitalWalletServiceDSL
end

class CatalogService
  include GameStopCatalogServiceDSL
end

class TaxService
  include GameStopTaxServiceDSL
end

class ShippingService
  include GameStopShippingServiceDSL
end

class StoreSearchService
  include GameStopStoreSearchServiceDSL
end

class DigitalContentService
  include GameStopDigitalContentServiceDSL
end

class PaymentService
  include GameStopPaymentServiceDSL
end

class VelocityService
  include GameStopVelocityServiceDSL
end

class TradeValueService
  include GameStopTradeValueServiceDSL
end

class LoyaltyMembershipService
  include LoyaltyEnrollmentServiceDSL
end

class CustomerProfileService
  include CustomerProfileServiceDSL
end

class GlobalServiceFunctions
  include GameStopGlobalServiceFunctionsDSL
end

class ConfigurationDataService
  include ConfigurationDataServiceDSL
end
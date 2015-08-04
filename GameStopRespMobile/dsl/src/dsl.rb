qaautomation_dir = ENV['QAAUTOMATION_FILES']
qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']
qaautomation_finders_dir = ENV['QAAUTOMATION_FINDERS']

# MGS Responsive Requires
require "#{qaautomation_finders_dir}/GameStopRespMobile/src/mgs_responsive_requires"
require "#{qaautomation_finders_dir}/Common/Profile/src/profile_requires"

require "#{qaautomation_dir}/dsl/Browser/src/browser_requires"
require "#{qaautomation_scripts_dir}/GameStopRespMobile/dsl/src/mgs_dsl"
require "#{qaautomation_scripts_dir}/GameStopRespMobile/dsl/src/mgs_pdp_functions_dsl"
require "#{qaautomation_scripts_dir}/GameStopRespMobile/dsl/src/mgs_pdp_validations_dsl"

# Services Requires
require "#{qaautomation_scripts_dir}/Common/Services/game_stop_service_dsl_requires"
require "#{qaautomation_scripts_dir}/Common/Services/game_stop_service_templates_requires"

# Common Requires
require "#{qaautomation_scripts_dir}/Common/dsl/src/creditcard"
require "#{qaautomation_scripts_dir}/Common/dsl/src/common_cookie_dsl"
require "#{qaautomation_scripts_dir}/Common/dsl/src/global_functions"
require "#{qaautomation_scripts_dir}/Common/dsl/src/common_functions"
require "#{qaautomation_scripts_dir}/Common/dsl/src/hosts_dsl"
require "#{qaautomation_scripts_dir}/Common/dsl/src/password_generator"
require "#{qaautomation_scripts_dir}/Common/dsl/src/test_harness"
require "#{qaautomation_scripts_dir}/Common/dsl/src/data_fuzzer"
require "#{qaautomation_scripts_dir}/Common/dsl/src/proxy_functions"

# Monitor Requires
require "#{qaautomation_scripts_dir}/Monitoring/dsl/src/monitoring_dsl"

#Continuous Integration Requires
require "#{qaautomation_scripts_dir}/CI_Scripts/dsl/src/ci_script_dsl"

# Method called during Browser instantiation.  Includes modules defined in QAAUTOMATION_SCRIPTS.
def include_dsl_modules
	WebBrowser.include_module(:MGSDSL)
	WebBrowser.include_module(:MGSProductDetailsFunctionsDSL)
	WebBrowser.include_module(:MGSProductDetailsValidationsDSL)
	WebBrowser.include_module(:CommonFunctions)
	WebBrowser.include_module(:CommonCookieDSL)
	WebBrowser.include_module(:TestHarnessDSL)
	WebBrowser.include_module(:MonitoringDSL)
	WebBrowser.include_module(:DataFuzzer)
	WebBrowser.include_module(:ProxyFunctions)
	WebBrowser.include_module(:ContinuousIntegrationDSL)
end

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

class StoreInformationService
  include GameStopStoreInformationServiceDSL
end
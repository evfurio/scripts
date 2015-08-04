qaautomation_dir = ENV['QAAUTOMATION_FILES']
qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']
qaautomation_finders_dir = ENV['QAAUTOMATION_FINDERS']

# Mobile GS Requires
require "#{qaautomation_finders_dir}/GameStopMobile/src/game_stop_mobile_requires"
require "#{qaautomation_finders_dir}/Common/Profile/src/profile_requires"
require "#{qaautomation_dir}/dsl/Browser/src/browser_requires"
require "#{qaautomation_scripts_dir}/GameStopMobile/dsl/src/game_stop_mobile_dsl"
require "#{qaautomation_scripts_dir}/GameStopMobile/dsl/src/game_stop_mobile_common_dsl"

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

# Method called during Browser instantiation.  Includes modules defined in QAAUTOMATION_SCRIPTS.
def include_dsl_modules
    WebBrowser.include_module(:GameStopMobileDSL)
	  WebBrowser.include_module(:GameStopMobileCommonDSL)
    WebBrowser.include_module(:CommonFunctions)
    WebBrowser.include_module(:CommonCookieDSL)
    WebBrowser.include_module(:TestHarnessDSL)
    WebBrowser.include_module(:MonitoringDSL)
    WebBrowser.include_module(:DataFuzzer)
    WebBrowser.include_module(:ProxyFunctions)
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

class GlobalServiceFunctions
	include GameStopGlobalServiceFunctionsDSL
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
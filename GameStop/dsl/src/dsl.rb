qaautomation_dir = ENV['QAAUTOMATION_FILES']
qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']
qaautomation_finders_dir = ENV['QAAUTOMATION_FINDERS']

#GameStop Requires
require "#{qaautomation_finders_dir}/GameStop/src/game_stop_requires"
require "#{qaautomation_finders_dir}/Common/Profile/src/profile_requires"
require "#{qaautomation_dir}/dsl/Browser/src/browser_requires"
require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_dsl"

require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_cart_functions"
require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_cart_validations"

require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_product_details_functions"
require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_product_details_validations"

require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_accounts_dsl"
require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_analytics_dsl"

require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_checkout_functions"
require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_checkout_validations"

require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_search_dsl"
require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_wallet_dsl"
require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_recommerce_dsl"
require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_gift_cards_dsl"
require "#{qaautomation_scripts_dir}/GameStop/dsl/src/game_stop_store_dsl"

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
require "#{qaautomation_scripts_dir}/Common/dsl/src/data_fuzzer"
require "#{qaautomation_scripts_dir}/Common/dsl/src/proxy_functions"
require "#{qaautomation_scripts_dir}/Common/dsl/src/security"

#Monitor Requires
require "#{qaautomation_scripts_dir}/Monitoring/dsl/src/monitoring_dsl"

#Continuous Integration Requires
require "#{qaautomation_scripts_dir}/CI_Scripts/dsl/src/ci_script_dsl"

#Cybersource Tokenization Requires
require "#{qaautomation_scripts_dir}/Common/Services/dsl_cybersource_tokenization"

# Method called during Browser instantiation.  Includes modules defined in QAAUTOMATION_SCRIPTS.
def include_dsl_modules
  WebBrowser.include_module(:GameStopDSL)
  WebBrowser.include_module(:GameStopAccountsDSL)
  WebBrowser.include_module(:GameStopAnalyticsDSL)
  WebBrowser.include_module(:GameStopCartFunctions)
  WebBrowser.include_module(:GameStopCartValidations)
  WebBrowser.include_module(:GameStopCheckoutFunctions)
  WebBrowser.include_module(:GameStopCheckoutValidations)
  WebBrowser.include_module(:GameStopProductDetailsFunctions)
  WebBrowser.include_module(:GameStopProductDetailsValidations)
  WebBrowser.include_module(:GameStopSearchDSL)
  WebBrowser.include_module(:GameStopWalletDSL)
  WebBrowser.include_module(:CommonFunctions)
  WebBrowser.include_module(:CommonCookieDSL)
  WebBrowser.include_module(:TestHarnessDSL)
  WebBrowser.include_module(:MonitoringDSL)
  WebBrowser.include_module(:ContinuousIntegrationDSL)
  WebBrowser.include_module(:GameStopRecommerceDSL)
  WebBrowser.include_module(:DataFuzzer)
  WebBrowser.include_module(:ProxyFunctions)
	WebBrowser.include_module(:GameStopGiftCardsDSL)
  WebBrowser.include_module(:GameStopStoreDSL)
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

class ChannelMultipassService
  include MultipassServiceDSL
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

class CybersourceFuntctions
  include CybersourceTokenizationResourceDSL
end
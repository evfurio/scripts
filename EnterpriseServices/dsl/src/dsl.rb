qaautomation_dir = ENV['QAAUTOMATION_FILES']
qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']
qaautomation_finders_dir = ENV['QAAUTOMATION_FINDERS']

require "#{qaautomation_finders_dir}/EnterpriseServices/src/enterprise_services_requires"
require "#{qaautomation_dir}/dsl/Browser/src/browser_requires"
require "#{qaautomation_scripts_dir}/EnterpriseServices/dsl/src/enterprise_services_dsl"
require "#{qaautomation_scripts_dir}/Common/dsl/src/global_functions"
require "#{qaautomation_scripts_dir}/Common/Services/game_stop_service_dsl_requires"
require "#{qaautomation_scripts_dir}/Common/Services/game_stop_service_templates_requires"

# Method called during Browser instantiation.  Includes modules defined in QAAUTOMATION_SCRIPTS.
def include_dsl_modules
    WebBrowser.include_module(:EnterpriseServicesDSL)
end




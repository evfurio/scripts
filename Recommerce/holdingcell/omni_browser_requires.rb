qaautomation_dir = ENV['QAAUTOMATION_FILES']
qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']

require "#{qaautomation_dir}/common/src/base_requires"
require "#{qaautomation_dir}/dsl/CommonBrowserUtilities/src/common_browser_utilities_requires"
require "#{qaautomation_dir}/dsl/CommonComponent/src/common_component"
require "finders/finders"
require "omniBrowser"
require "c:/Dev/QATestProjects/ReCommerce/lib/finders/RecommerceComponents"
require "c:/Dev/QATestProjects/ReCommerce/lib/finders/Recommerce_dsl"

OmniBrowser.include_module(:ReCommerceFinders)




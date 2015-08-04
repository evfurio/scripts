qaautomation_dir = ENV['QAAUTOMATION_FILES']
qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']
qaautomation_finders_dir = ENV['QAAUTOMATION_FINDERS']

require "#{qaautomation_finders_dir}/GameInformer/src/game_informer_requires"
require "#{qaautomation_dir}/dsl/Browser/src/browser_requires"
require "#{qaautomation_scripts_dir}/GameInformer/dsl/src/game_informer_dsl"
require "#{qaautomation_scripts_dir}/Common/dsl/src/global_functions"

# Method called during Browser instantiation.  Includes modules defined in QAAUTOMATION_SCRIPTS.
def include_dsl_modules
    GameInformerBrowser.include_module(:GameInformerDSL)
end




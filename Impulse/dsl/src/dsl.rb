qaautomation_dir = ENV['QAAUTOMATION_FILES']
qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']

require "#{qaautomation_dir}/dsl/Impulse/src/impulse_requires"
require "#{qaautomation_dir}/dsl/ImpulseClient/src/impulse_client_requires"
require "#{qaautomation_scripts_dir}/Impulse/dsl/src/impulse_dsl"
require "#{qaautomation_scripts_dir}/Common/dsl/src/global_functions"

# Method called during Browser instantiation.  Includes modules defined in QAAUTOMATION_SCRIPTS.
def include_dsl_modules
    ImpulseBrowser.include_module(:ImpulseDSL)
    ImpulseClient.include_module(:ImpulseDSL)
end


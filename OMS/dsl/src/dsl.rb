# Require in Services and Sterling
qaautomation_dir = "#{ENV['QAAUTOMATION_TOOLS']}/QAAutomation"
qaautomation_scripts_dir = ENV['QAAUTOMATION_SCRIPTS']

require "#{qaautomation_dir}/dsl/Services/src/services_requires"
require "#{qaautomation_dir}/dsl/Sterling/src/sterling_requires"
require "#{qaautomation_scripts_dir}/Common/OMS/templates"
require "#{qaautomation_scripts_dir}/OMS/dsl/src/oms_dsl"


class Sterling
  include OMSDsl
end


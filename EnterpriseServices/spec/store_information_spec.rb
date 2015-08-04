# USAGE NOTES
# d-Con %QAAUTOMATION_SCRIPTS%\EnterpriseServices\spec\store_information_spec.rb  --csv %QAAUTOMATION_SCRIPTS%\EnterpriseServices\spec\enterprise_services_dataset.csv --range TFS86995 --or

require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

$tracer.mode=:on
$tracer.echo=:on

$global_functions = GlobalFunctions.new()
$tc_desc = $global_functions.desc
$tc_id = $global_functions.id

describe "ES Store Information Service" do
  before(:all) do
		@params = $global_functions.csv
		@storeinformation_svc = $global_functions.storeinformation_svc
  end

  it "#{$tc_id} #{$tc_desc}" do
		@storeinformation_svc.perform_is_service_alive()
		@storeinformation_svc.perform_get_store_information(@params['StoreId'],@params['StoreNumber'])
		@storeinformation_svc.perform_get_stores_by_zip_code(@params['ZipCode'])
  end
	
end
#d-con %QAAUTOMATION_SCRIPTS%\GameStop\spec\Sandbox\tests\sqlite3_test.rb --data CHECKOUT_UI --data_range TFS48627 --env QA --or
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"
require 'rubygems'
require 'dm-core'
require 'ostruct'

$tracer.mode=:on
$tracer.echo=:on
$global_functions = GlobalFunctions.new()

describe "Test SQLite3" do

  it "should test datamapper implementation" do
    @path = "#{ENV['QAAUTOMATION_SCRIPTS']}".gsub("\\","\/")
    params = $global_functions.data
    #$tracer.trace(params.inspect)
    endpoints = $global_functions.svc
    #$tracer.trace(endpoints)
    #puts endpoints['catalog']

    @catalog_svc, @catalog_svc_version = $global_functions.catalog_svc
    #@cart_svc, @cart_svc_version = $global_functions.cart_svc
    #@profile_svc, @profile_svc_version = $global_functions.profile_svc

    $tracer.trace(params['id'])
  end

end

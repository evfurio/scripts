# d-con %QAAUTOMATION_SCRIPTS%\CI_Scripts\spec\octopus\get_latest_build_info.rb --or

#http://cibuilds.gamestop.com:8888/api/deployments/deployments-1177

qaautomation_dir = ENV['QAAUTOMATION_FILES']
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/dsl/src/dsl"

describe "Get Octopus Build Information" do
  before(:all) do
    $tracer.mode = :on
    $tracer.echo = :on
    @browser = WebBrowser.new('phantomjs')
  end

  before(:each) do
  end

  #before all - get the build information for the environment in test
  #after all - get the build information for the environment in test

  #compare them to make sure they're still right
  it "should get deployment information from octopus" do
    name, release_id = @browser.get_octopus_release
    $tracer.report("Environment: #{name}")
    $tracer.report("Release ID: #{release_id}")
  end

end
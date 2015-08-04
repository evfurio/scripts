qaautomation_dir = ENV['QAAUTOMATION_FILES']
require "#{qaautomation_dir}/dsl/ImpulseClient/src/impulse_client_requires"
require "#{qaautomation_dir}/common/src/base_requires"

# must exist, so we'll stub one
def include_dsl_modules
end

describe "Impulse Client Discover Reload" do

  before(:all) do
    @default_timeout = ImpulseClient.default_timeout
    $tracer.echo = :on

    @location = "C:/gs_client_chromium/GamestopClient/cefhost/Development"
    @client = ImpulseClient.new(@location)
    
    $snapshots.setup_app(@client)

    @client.open
  end

  before(:each) do
    ImpulseClient.default_timeout = @default_timeout
    @client.nav_bar.gamestop_logo.link.click
  end

  after(:all) do
    @client.close
  end

  it "should repeatedly reload the discover tab" do
    @client.nav_bar.discover.link.click
    50.times do
      sleep 5
      @client.reload_button.click
    end
  end
end
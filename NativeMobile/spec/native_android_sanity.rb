# USAGE NOTES
# TEMP --CSV dataset...
#d-con %QAAUTOMATION_SCRIPTS%/NativeMobile/spec/native_android_sanity.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\checkout_dataset.csv --range TFS48627

require "#{ENV['QAAUTOMATION_SCRIPTS']}/NativeMobile/dsl/src/dsl"
require "bigdecimal"

APP_PATH = "C:/dev/QAAutomationScripts/NativeMobile/spec/gamestop_android_qa.apk"

$tracer.mode=:on
$tracer.echo=:on

def include_dsl_modules
end

describe "Native App Sanity" do
  before(:all) do
    $options.default_timeout = 60_000
    #@iosAppg.instance_variable_get(:@driver).manage.timeouts.implicitlyWait(240, TimeUnit::SECONDS)
    apk = NativeAppConfig.new(APP_PATH, false)
    @app = NativeApp.new(apk)

  end


  it "should do some android magic" do
    @app.id("tutorial_ximageview").click
    @app.name("Open your dashboard").click
    @app.name("SHOP").inner_text.should == "SHOP"
    @app.name("HOME").inner_text.should == "HOME"
    @app.name("TRADE").inner_text.should == "TRADE"
    @app.name("TRADE").click

    sleep 10
  end


end
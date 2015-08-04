#Usage Notes#
#Tutorial example of how to clear the temp internet files and browsers cookies/cache before running a test.
#Note that you will get different behavior depending on when you delete the temp files and the cookies.  You may get unexpected results if you're not considering what happens when running multiple tests.
#d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Sandbox\tutorials\basics\basic_spec.rb --or
#C:\dev\QAAutomationCurrent\GameStopDoc\CommonBrowserBaseClass.html

describe "Advanced - Cleaning Junk" do

  before(:all) do
    $browser = GameStopBrowser.new(browser_type_parameter)

    #Clears the temporary internet files
		$browser.delete_internet_files(browser_type_parameter)
    $tracer.trace("Deleting ALL THE Internet Files!")
  end

  before(:each) do
    $browser.cookie.all.delete
    $tracer.trace("Clearing cookies and browser related cache")
  end

  it "should clear the cache and temp int files" do
    $tracer.trace("Good Job! All done!")
  end

end
set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57859 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 57859 Verify_Channel_Intelligence_tagging_on_Order_Confirmation_page_as_guest Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS57859 --or"}

set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48607 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 48607 Should_checkout_and_create_new_user_and_populate_profile_with_bill_addr_only Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48607 --or"}

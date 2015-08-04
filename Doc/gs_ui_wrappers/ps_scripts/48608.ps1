set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48608 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 48608 Should_checkout_create_new_account_without_updating_profile_save_digital_wallet Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\new_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48608 --or"}

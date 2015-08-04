set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_regular.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv --range TFS47120 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 47120 Should_checkout_guest_user_with_cc_same_bill_ship_Jackson_MS Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_regular.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv --range TFS47120 --or"}

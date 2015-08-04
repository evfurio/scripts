set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22781 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 22781 Fulfillment_Checkout_Guest_Shipping_Address_Domestic_Address_Hawaii_Alaska_Puerto_Rico Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22781 --or"}

set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_regular.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv --range TFS47205 --login svc_20140606_134338_942@qagsecomprod.oib.com --password T3sting1 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 47205 Should_add_billing_and_shipping_address_outside_of_checkout_to_an_existing_user_with_cc Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_regular.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv --range TFS47205 --login svc_20140606_134338_942@qagsecomprod.oib.com --password T3sting1 --or"}

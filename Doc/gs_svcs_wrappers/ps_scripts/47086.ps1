set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_regular.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv --range TFS47086 --login svc_20140606_134324_619@qagsecomprod.oib.com --password T3sting1 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 47086 Should_checkout_as_an_existing_user_with_a_domestic_address_same_billing_as_shipping Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_regular.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv --range TFS47086 --login svc_20140606_134324_619@qagsecomprod.oib.com --password T3sting1 --or"}

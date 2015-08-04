set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_regular.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv --range TFS44309 --login svc_20140606_134217_543@qagsecomprod.oib.com --password T3sting1 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 44309 Should_checkout_as_an_authenticated_user_using_a_credit_card Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_regular.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv --range TFS44309 --login svc_20140606_134217_543@qagsecomprod.oib.com --password T3sting1 --or"}

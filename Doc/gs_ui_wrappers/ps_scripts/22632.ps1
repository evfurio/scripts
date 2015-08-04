set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22632 --login gsui_20140606_140920_280@qagsecomprod.oib.com --password T3sting1 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 22632 Fulfillment_Checkout_Authenticated_New_Shipping_Address_Domestic_Address_Continental_48_States Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22632 --login gsui_20140606_140920_280@qagsecomprod.oib.com --password T3sting1 --or"}

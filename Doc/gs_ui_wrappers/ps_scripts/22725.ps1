set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22725 --login gsui_20140606_140849_613@qagsecomprod.oib.com --password T3sting1 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 22725 Fulfillment_Cart_Handling_Options_Authenticated_International_Great_Britain_GB Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS22725 --login gsui_20140606_140849_613@qagsecomprod.oib.com --password T3sting1 --or"}
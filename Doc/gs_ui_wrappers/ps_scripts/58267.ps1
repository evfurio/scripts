set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58267 --login gsui_20140606_140809_244@qagsecomprod.oib.com --password T3sting1 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 58267 Should_validate_ADROLL_in_Search_Results_as_authenticated_user Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS58267 --login gsui_20140606_140809_244@qagsecomprod.oib.com --password T3sting1 --or"}

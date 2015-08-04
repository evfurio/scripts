set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\subscribe_unsubscribe_to_mailing_list_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS71335 --login gsui_20140606_140841_936@qagsecomprod.oib.com --password T3sting1 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 71335 Should_checkout_as_authenticated_user_utilizing_profile_service_version_2 Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\subscribe_unsubscribe_to_mailing_list_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS71335 --login gsui_20140606_140841_936@qagsecomprod.oib.com --password T3sting1 --or"}

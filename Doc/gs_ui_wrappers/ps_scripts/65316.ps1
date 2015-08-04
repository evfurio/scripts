set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS65316 --login bf_gsdc85@qagsecomprod.oib.com --password T3sting --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 65316 PoweUp_Rewards_Member_text_section_for_authenticated_PUR_Free_account_should_not_exist Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb  --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS65316 --login bf_gsdc85@qagsecomprod.oib.com --password T3sting --or"}

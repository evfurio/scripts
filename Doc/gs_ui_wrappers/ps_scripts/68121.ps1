set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb --browser chrome -e 'Locked Account after five attempts' --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS68121 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 68121 Account_locked_after_five_attempts Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb --browser chrome -e 'Locked Account after five attempts' --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS68121 --or"}

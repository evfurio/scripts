set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb --browser chrome -e 'Attempt to login less than 30 minutes' --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS68142 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 68142 OBSOLETE_-Attempt_to_login_less_than_30_minutes_after_locking_account Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb --browser chrome -e 'Attempt to login less than 30 minutes' --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS68142 --or"}

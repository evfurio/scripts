set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb --browser chrome -e 'Attempt to login after 30 minutes' --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS68134 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 68134 Attempt_to_login_after_30_minutes_of_being_locked_out Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\account_locked_five_attempts_spec.rb --browser chrome -e 'Attempt to login after 30 minutes' --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS68134 --or"}

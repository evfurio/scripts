set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_DLC_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48603 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 48603 Should_checkout_guest_digital_product Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_DLC_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48603 --or"}

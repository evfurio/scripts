set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48613 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 48613 Should_checkout_guest_gift_card_25 Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48613 --or"}

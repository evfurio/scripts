set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48784 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 48784 Checkout_multiple_CERTIFICATES_and_GIFT_CARDS_with_different_other_amounts_to_guest Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\guest_checkout_GIFT_CARD_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48784 --or"}

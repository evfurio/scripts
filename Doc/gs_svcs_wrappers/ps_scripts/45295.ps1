set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\Checkout_with_DigitalWalletCard.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv --range TFS45295 --login shahzebkhan@gamestop.com --password khan321 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case 45295 Should_checkout_as_an_authenticated_user_using_a_credit_card_from_digital_wallet Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\Checkout_with_DigitalWalletCard.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv --range TFS45295 --login shahzebkhan@gamestop.com --password khan321 --or"}

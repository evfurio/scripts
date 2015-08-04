set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin

powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_ISPU.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv --range ProdSMK03 --or
if ($LastExitCode -eq 1)
    {Write-Host "Test Case ProdSMK03 Checkout_PreOrder_Item_for_ISPU_using_Test_CC Failed
%QAAUTOMATION_SCRIPTS%\GameStop\Spec\Services\Checkout\checkout_ISPU.rb --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\Services\Checkout\checkout_dataset.csv --range ProdSMK03 --or"}

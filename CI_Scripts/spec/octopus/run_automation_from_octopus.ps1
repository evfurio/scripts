set QAAUTOMATION_FILES=$env:QAAUTOMATION_TOOLS\QAAutomation
set QAAUTOMATION_BIN=$env:QAAUTOMATION_FILES\bin
$EnvName = Write-Output($OctopusParameters['Octopus.Environment.Name'] + "_GS")
$SvcName = Write-Output($OctopusParameters['Octopus.Environment.Name'] + "_V1")
$ReleaseNumber = $OctopusParameters['Octopus.Release.Number']

#powershell /c d-Con %QAAUTOMATION_SCRIPTS%\GameStop\Spec\UI\GS\authenticated_user_checkout_spec.rb --browser chrome --csv %QAAUTOMATION_SCRIPTS%\GameStop\spec\UI\GS\checkout_dataset.csv --range TFS48627 --prop %QAAUTOMATION_SCRIPTS%\Common\config\properties.csv --prop_url $EnvName --svc %QAAUTOMATION_SCRIPTS%\Common\config\endpoints.csv --svc_env $SvcName --or
powershell /c d-Con %QAAUTOMATION_SCRIPTS%\Monitoring\spec\monitor_gamestop_spec.rb --csv %QAAUTOMATION_SCRIPTS%\Monitoring\spec\monitor_dataset.csv --range $OctopusParameters['Octopus.Environment.Name'] --or

Write-Host ($EnvName, $SvcName, $ReleaseNumber)
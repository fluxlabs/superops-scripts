Import-Module $SuperOpsModule

<#
This script uninstalls Datto agent
#>

##### Script Logic #####

$UninstallString = (Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\CentraStage*).UninstallString

if($UninstallString -eq $null) {
    $UninstallString = (Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\CentraStage*).UninstallString
}

if($UninstallString -eq $null) {
    Write-Output "ERROR: Datto agent not found"
}

else {
    $UninstallProcess = Start-Process -FilePath "$UninstallString" -PassThru
    $UninstallProcess.WaitForExit()
}
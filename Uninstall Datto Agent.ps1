Import-Module $SuperOpsModule

<#
This script uninstalls Datto agent
#>

##### Script Logic #####

# Define paths and variables
$UninstallerRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
$UninstallerDisplayName = "*Datto*"
$UninstallCommand = "UninstallString"
$ErrorActionPreference = "Stop"

# Find Datto agent uninstaller in the registry
$UninstallerKey = Get-ChildItem -Path $UninstallerRegistryPath | 
                    Where-Object { $_.GetValue("DisplayName") -like $UninstallerDisplayName } | 
                    Select-Object -First 1

if ($UninstallerKey) {
    # Extract the uninstall command
    $UninstallString = $UninstallerKey.GetValue($UninstallCommand)
    
    # Remove Datto agent
    Write-Host "Removing Datto agent..."
    Start-Process -FilePath $UninstallString -ArgumentList "/quiet" -Wait
    
    # Verify if Datto agent has been successfully uninstalled
    if (Test-Path $UninstallerKey) {
        Write-Host "Datto agent removal failed. Please try uninstalling manually."
    } else {
        Write-Host "Datto agent has been successfully removed."
    }
} else {
    Write-Host "Datto agent is not installed on this system."
}
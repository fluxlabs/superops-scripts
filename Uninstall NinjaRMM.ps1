Import-Module $SuperOpsModule

<#
This script Detects & Uninstalls Ninja RMM if found
#>

##### Script Logic #####

# Define paths and variables
$UninstallerRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
$UninstallerDisplayName = "*Ninja*"
$UninstallCommand = "UninstallString"
$ErrorActionPreference = "Stop"

# Find NinjaRMM uninstaller in the registry
$UninstallerKey = Get-ChildItem -Path $UninstallerRegistryPath | 
                    Where-Object { $_.GetValue("DisplayName") -like $UninstallerDisplayName } | 
                    Select-Object -First 1

if ($UninstallerKey) {
    # Extract the uninstall command
    $UninstallString = $UninstallerKey.GetValue($UninstallCommand)
    
    # Remove NinjaRMM
    Write-Host "Removing NinjaRMM..."
    Start-Process -FilePath $UninstallString -ArgumentList "/quiet" -Wait
    
    # Verify if NinjaRMM has been successfully uninstalled
    if (Test-Path $UninstallerKey) {
        Write-Host "NinjaRMM removal failed. Please try uninstalling manually."
    } else {
        Write-Host "NinjaRMM has been successfully removed."
    }
} else {
    Write-Host "NinjaRMM is not installed on this system."
}

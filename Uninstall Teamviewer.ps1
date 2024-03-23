Import-Module $SuperOpsModule

<#
This script Detects and Uninstalls TeamViewer
#>

##### Script Logic #####

# Define paths and variables
$UninstallerRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
$UninstallerDisplayName = "TeamViewer*"
$UninstallCommand = "UninstallString"
$ErrorActionPreference = "Stop"

# Find TeamViewer uninstaller in the registry
$UninstallerKey = Get-ChildItem -Path $UninstallerRegistryPath | 
                    Where-Object { $_.GetValue("DisplayName") -like $UninstallerDisplayName } | 
                    Select-Object -First 1

if ($UninstallerKey) {
    # Extract the uninstall command
    $UninstallString = $UninstallerKey.GetValue($UninstallCommand)
    
    # Remove TeamViewer
    Write-Host "Removing TeamViewer..."
    Start-Process -FilePath $UninstallString -ArgumentList "/S" -Wait
    
    # Verify if TeamViewer has been successfully uninstalled
    if (Test-Path $UninstallerKey) {
        Write-Host "TeamViewer removal failed. Please try uninstalling manually."
    } else {
        Write-Host "TeamViewer has been successfully removed."
    }
} else {
    Write-Host "TeamViewer is not installed on this system."
}

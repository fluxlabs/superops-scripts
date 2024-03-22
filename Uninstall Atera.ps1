Import-Module $SuperOpsModule

<#
This script uninstalls Atera agent and cleans up
#>

##### Script Logic #####
# Stop Atera services
Write-Host "Stopping Atera Services"
Stop-Service -Name "AteraAgent" -Force
Remove-Service -Name "AteraAgent" -Force

# Stop Atera processes
Stop-Process -Name "TicketingTray.exe", "AteraAgent.exe", `
    "AgentPackageMonitoring.exe", "AgentPackageInformation.exe", `
    "AgentPackageRunCommande.exe", "AgentPackageEventViewer.exe", `
    "AgentPackageSTRemote.exe", "AgentPackageInternalPoller.exe", `
    "AgentPackageWindowsUpdate.exe" -Force

# Introduce a delay
Start-Sleep -Seconds 10

# Remove Atera registry entries
Write-Host "Removing Atera Registry"
Remove-Item -Path "HKCU:\Software\ATERA Networks" -Force
Remove-Item -Path "HKLM:\SOFTWARE\ATERA Networks" -Force
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{EFB51F01-9805-4293-BB16-6F17EF4CEDF2}" -Force
Remove-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\{C6F34E57-AC44-4A26-8B0A-58CEA5E6725F}" -Force

# Remove Atera folders
Write-Host "Removing Atera Folders"
Remove-Item -Path "C:\Program Files\ATERA Networks\AteraAgent" -Force
Remove-Item -Path "C:\Program Files (x86)\ATERA Networks" -Force

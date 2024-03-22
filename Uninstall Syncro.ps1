Import-Module $SuperOpsModule

<#
This script uninstalls Syncro agent and cleans up
#>

##### Script Logic #####
# Stop and remove Kabuto services
Stop-Service -Name "Kabuto", "KabutoLive" -Force
Remove-Service -Name "Kabuto", "KabutoLive" -Force

# Stop Kabuto processes
Get-Process -Name "Kabuto.App.Runner.exe", "Kabuto.Service.Runner.exe", `
    "KabutoLive.Agent.Runner.exe", "KabutoLive.Agent.Service.exe" | `
    Stop-Process -Force

# Remove Kabuto folders
Remove-Item -Path "C:\Program Files\Kabuto", "C:\Program Files (x86)\Kabuto", `
    "C:\Program Files\RepairTech\Kabuto", "C:\Program Files\RepairTech\LiveAgent" -Force

# Delete Kabuto and RepairTech registry entries
Remove-Item -Path "HKLM:\Software\WOW6432Node\RepairTech\Kabuto", `
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Kabuto", `
    "HKLM:\Software\RepairTech\Kabuto", "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Kabuto", `
    "HKLM:\System\CurrentControlSet\Services\Kabuto", "HKLM:\System\CurrentControlSet\Services\KabutoLive" -Force

# Stop and remove Syncro services
Stop-Service -Name "Syncro", "SyncroLive", "SyncroOvermind" -Force
Remove-Service -Name "Syncro", "SyncroLive", "SyncroOvermind" -Force

# Stop Syncro processes
Get-Process -Name "Syncro.App.Runner.exe", "Syncro.Service.Runner.exe", `
    "SyncroLive.Agent.Runner.exe", "SyncroLive.Agent.Service.exe" | `
    Stop-Process -Force

# Remove Syncro folders
Remove-Item -Path "C:\Program Files\Syncro", "C:\Program Files (x86)\Syncro", `
    "C:\Program Files\RepairTech\Syncro", "C:\Program Files\RepairTech\LiveAgent" -Force

# Delete Syncro registry entries
Remove-Item -Path "HKLM:\Software\WOW6432Node\RepairTech\Syncro", `
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Syncro", `
    "HKLM:\Software\RepairTech\Syncro", "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Syncro", `
    "HKLM:\System\CurrentControlSet\Services\Syncro", "HKLM:\System\CurrentControlSet\Services\SyncroLive" -Force

# Remove Software registry entry
Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{B7F56D3D-2AD3-4021-9D36-3B9E9C9FBE33}" -Force

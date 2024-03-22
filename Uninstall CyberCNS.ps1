Import-Module $SuperOpsModule

<#
This script uninstalls CyberCNS and cleans up
#>

##### Script Logic #####

# Ping localhost to introduce a delay
Start-Sleep -Seconds 6

# Change directory to Program Files (x86)
Set-Location -Path "C:\Program Files (x86)"

# Stop and delete CyberCNSAgentMonitor service
Stop-Service -Name "CyberCNSAgentMonitor"
Start-Sleep -Seconds 5
Remove-Service -Name "CyberCNSAgentMonitor"

# Stop and delete CyberCNSAgentV2 service
Stop-Service -Name "CyberCNSAgentV2"
Start-Sleep -Seconds 5
Remove-Service -Name "CyberCNSAgentV2"

# Ping localhost to introduce a delay
Start-Sleep -Seconds 6

# Terminate specific processes
Get-Process -Name "osqueryi" -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process -Name "nmap" -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process -Name "cybercnsagentv2" -ErrorAction SilentlyContinue | Stop-Process -Force

# Uninstall CyberCNSAgentV2 service
& "C:\Program Files (x86)\CyberCNSAgentV2\cybercnsagentv2.exe" --internalAssetArgument uninstallservice

# Remove CyberCNSAgentV2 directory
Remove-Item -Path "C:\Program Files (x86)\CyberCNSAgentV2" -Recurse -Force

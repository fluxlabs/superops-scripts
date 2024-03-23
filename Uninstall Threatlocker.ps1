Import-Module $SuperOpsModule

<#
This script uninstalls Threatlocker
Disable tamper protection on portal before running - https://threatlocker.kb.help/disable-tamper-protection/
#>

##### Required Variables #####

# Determine download URL and installer name based on OS architecture
if ([Environment]::Is64BitOperatingSystem) {
    $DownloadURL = "https://api.threatlocker.com/installers/threatlockerstubx64.exe"
    $InstallerName = "uninstallthreatlockerstubx64.exe"
} else {
    $DownloadURL = "https://api.threatlocker.com/installers/threatlockerstubx86.exe"
    $InstallerName = "uninstallthreatlockerstubx86.exe"
}

# Construct installer path
$InstallerPath = Join-Path $Env:TMP $InstallerName

# Set security protocol for downloading
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Download the uninstaller executable
Invoke-WebRequest -Uri $DownloadURL -OutFile $InstallerPath

# Start the uninstallation process
Start-Process -FilePath $InstallerPath -ArgumentList "uninstall" -Wait

Import-Module $SuperOpsModule

<#
This script uninstalls AutoElevate
#>

# Define variables
$softwareDisplayName = "AutoElevate"
$serviceName = "AutoElevateAgent"
$logFilePath = "C:\AutoElevateUninstallLog.txt"
$registryKeyPath = "HKLM:\Software\autoelevate"
$folderPath = "C:\Program Files*\AutoElevate"

# Function to get timestamp
function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

# Function to print debug messages
function Debug-Print ($msg) {
    if ($DebugPrintEnabled -eq 1) {
        Write-Host "$(Get-TimeStamp) [DEBUG] $msg"
    }
}

# Function to kill service
function Kill-Service {
    if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "Please run this script as an administrator."
        exit
    }
    taskkill /F /FI "SERVICES eq AutoElevateAgent"
}

# Function to delete registry key
function Del-Registry-Key {
    if (Test-Path -Path $registryKeyPath) {
        Remove-Item -Path $registryKeyPath -Recurse -Force
        Write-Host "Registry key $registryKeyPath deleted successfully."
    } else {
        Write-Host "Registry key $registryKeyPath not found."
    }
}

# Function to delete folder
function Del-AEFolder {
    if (Test-Path -Path $folderPath -PathType Container) {
        Remove-Item -Path $folderPath -Recurse -Force
        Write-Host "Folder '$folderPath' deleted successfully."
    } else {
        Write-Host "Folder '$folderPath' does not exist."
    }
}

# Function to log messages to the log file
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    $logMessage | Out-File -Append -FilePath $logFilePath
}

# Function to uninstall AutoElevate
function UninstallAE {
    if (-not (Test-Path -Path $logFilePath)) {
        New-Item -Path $logFilePath -ItemType File
    }
    Write-Host "Uninstallation process started for '$softwareDisplayName'."
    $uninstallKey = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq $softwareDisplayName }
    if ($uninstallKey) {
        Write-Host "Uninstalling '$softwareDisplayName'..."
        $uninstallResult = $uninstallKey.Uninstall()
        if ($uninstallResult.ReturnValue -eq 0) {
            Write-Host "'$softwareDisplayName' was successfully uninstalled."
        } else {
            Write-Host "Failed to uninstall '$softwareDisplayName'. Return code: $($uninstallResult.ReturnValue)"
        }
    } else {
        Write-Host "Software '$softwareDisplayName' not found in the list of installed programs."
    }
}

# Main function
function main {
    Debug-Print("Checking for Beginning uninstall...")
    Write-Host "$(Get-TimeStamp) SofwareName: $softwareDisplayName"
    Write-Host "$(Get-TimeStamp) ServiceName: $serviceName"
    Write-Host "$(Get-TimeStamp) RegistryName: $registryKeyPath"
    Write-Host "$(Get-TimeStamp) DirectoryName: $folderPath"
    Write-Host "$(Get-TimeStamp) RegistryName: $registryKeyPath"
    Write-Host "$(Get-TimeStamp) LogFilePath: $logFilePath"
    
    Kill-Service
    Del-Registry-Key
    Del-AEFolder
    UninstallAE
    
    Write-Log "AutoElevate Agent successfully uninstalled!"
}

# Execution starts here
try {
    main
} catch {
    $ErrorMessage = $_.Exception.Message
    Write-Host "$(Get-TimeStamp) $ErrorMessage"
    exit 1
}

Write-Host "Uninstallation process completed. Log file: $logFilePath"

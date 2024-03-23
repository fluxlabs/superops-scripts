Import-Module $SuperOpsModule

<#
This script uninstalls Blackpoint Cyber
#>

# Check architecture and execute appropriate uninstallation logic
if ($env:PROCESSOR_ARCHITECTURE -eq "x86") {
    Uninstall_x86
} else {
    Uninstall_x64
}

# Function to uninstall for x86 architecture
function Uninstall_x86 {
    KillProcesses
    UninstallWMIC "SnapAgent"
    UninstallWMIC "ZTAC"
    RemoveBlackpointFolder "$env:ProgramFiles(x86)"
    exit 0
}

# Function to uninstall for x64 architecture
function Uninstall_x64 {
    KillProcesses
    UninstallWMIC "SnapAgent"
    UninstallWMIC "ZTAC"
    RemoveBlackpointFolder $env:ProgramFiles
    exit 0
}

# Function to kill processes
function KillProcesses {
    Stop-Process -Name "snapw" -Force -ErrorAction SilentlyContinue
    Stop-Process -Name "SnapAgent" -Force -ErrorAction SilentlyContinue
    Stop-Process -Name "ztac" -Force -ErrorAction SilentlyContinue
}

# Function to uninstall using WMIC
function UninstallWMIC ($productName) {
    $uninstallCommand = "wmic product where `"description='$productName'`" uninstall"
    Invoke-Expression $uninstallCommand
}

# Function to remove Blackpoint folder
function RemoveBlackpointFolder ($programFilesPath) {
    $blackpointFolder = Join-Path $programFilesPath "Blackpoint"
    if (Test-Path $blackpointFolder) {
        Remove-Item -Path $blackpointFolder -Recurse -Force
    }
}

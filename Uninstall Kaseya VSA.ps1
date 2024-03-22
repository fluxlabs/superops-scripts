Import-Module $SuperOpsModule

<#
The uninstall script requires a Kaseya VSA agent group ID.
You must provide secure variables to this script as seen in the Required Variables section. 
#>

##### Required Variables #####
# Could be variable

$GroupId = "GROUP-ID-HERE"

# Define paths and variables
$LogPath = Join-Path $Env:TMP "kasetup.log"
$UninstallerName = "KASetup.exe"
$Path32 = "C:\Program Files (x86)\Kaseya"
$Path64 = "C:\Program Files\Kaseya"

# Check if Kaseya exists in Program Files (x86) directory
if (Test-Path $Path32) {
    $ExecutablePath = Join-Path $Path32 -ChildPath "$GroupId\$UninstallerName"
}
# If not, check if it exists in Program Files directory
elseif (Test-Path $Path64) {
    $ExecutablePath = Join-Path $Path64 -ChildPath "$GroupId\$UninstallerName"
}
# If not found in either directory, display an error message
else {
    Write-Output "ERROR: $UninstallerName not found"
    return
}

# Start the uninstall process and wait for it to finish
$ExitCode = (Start-Process -FilePath $ExecutablePath -ArgumentList "/s", "/r", "/g", $GroupId, "/l", $LogPath -Wait -PassThru).ExitCode

# Check the exit code and provide appropriate output
if ($ExitCode -eq 0) {
    Write-Output "Uninstalled successfully"
} else {
    Write-Output "Uninstall completed with exit code $ExitCode."
}

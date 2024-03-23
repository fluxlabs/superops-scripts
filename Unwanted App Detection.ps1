Import-Module $SuperOpsModule

<#
This script detects the applications and notes them in the custom field.
Create custom field
#>

$AppListField = "Potential Unwanted Software"

# Define list of applications to check
$ApplicationList = @(
    "*Kaseya*"
    "*Datto*"
    "*Syncro*"
    "*Solarwinds*"
    "*Ninja*"
    "*GFI*"
    "*ATERA*"
    "*Connectwise*"
    "*Continuum*"
    "*MESH*"
    "*TeamViewer*"
    "*LogMeIn*"
    "*Norton*"
)

# Search for competitor RMM applications
$CompetitorRMM = foreach ($Application in $ApplicationList) {
    Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | ForEach-Object { 
        Get-ItemProperty $_.PSPath 
    } | Select-Object DisplayVersion, InstallDate, ModifyPath, Publisher, UninstallString, Language, DisplayName | Where-Object { 
        $_.DisplayName -like $Application 
    }

    Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\" | ForEach-Object { 
        Get-ItemProperty $_.PSPath 
    } | Select-Object DisplayVersion, InstallDate, ModifyPath, Publisher, UninstallString, Language, DisplayName | Where-Object { 
        $_.DisplayName -like $Application 
    }
}

# If competitor RMM applications are found, report them
if ($CompetitorRMM) {
    $CompetitorRMMNames = $CompetitorRMM | ForEach-Object { $_.DisplayName }
    Write-Host "Possible Unwanted Software Found: $($CompetitorRMMNames -join ', ')"
    Send-CustomField -CustomFieldName "$AppListField" -Value "$($CompetitorRMMNames -join ', ')"
} 
# If no competitor RMM applications are found, report accordingly
else {
    Write-Host "No Unwanted Software Found"
    Send-CustomField -CustomFieldName "$AppListField" -Value "NA"
}

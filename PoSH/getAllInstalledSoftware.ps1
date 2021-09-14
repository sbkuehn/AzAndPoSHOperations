$computerName = Get-WMIObject Win32_ComputerSystem | Select-Object -ExpandProperty name;
 
$outputFile = "C:\$computerName.csv";
if (Test-Path $outputFile) { Remove-Item $outputFile; }
Add-Content $outputFile "DisplayName, DisplayVersion, Publisher, InstallDate"

$applications = Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*";
 
foreach ($application in $applications)
{
    $displayName = $application.DisplayName;
    $displayVersion = $application.DisplayVersion;
    $publisher = $application.Publisher;
    $installDate = $application.InstallDate;
 
    if ($displayName -ne $null -or $displayVersion -ne $null -or $publisher -ne $null -or $installDate -ne $null)
    {
        Add-Content $outputFile "$displayName, $displayVersion, $publisher, $installDate";
    }
}

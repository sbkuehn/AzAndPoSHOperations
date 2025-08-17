<#
.SYNOPSIS
    Exports all A records from a DNS zone to a CSV file.

.DESCRIPTION
    This script connects to a specified DNS zone, retrieves all A records,
    and exports them (with HostName and IP Address) to a CSV file.

.PARAMETER ZoneName
    The name of the DNS zone to query.

.PARAMETER ExportFile
    The full file path where the CSV output should be saved.

.EXAMPLE
    .\Export-DnsARecords.ps1 -ZoneName "yourdomainname.com" -ExportFile "C:\Temp\dns_export.csv"

.NOTES
    Author: Shannon Eldridge-Kuehn
    Date:   2025-08-16
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ZoneName,

    [Parameter(Mandatory=$true)]
    [string]$ExportFile
)

Write-Host "Exporting A records from DNS zone: $ZoneName" -ForegroundColor Cyan

try {
    Get-DnsServerResourceRecord -ZoneName $ZoneName -ErrorAction Stop |
        Where-Object { $_.RecordType -eq "A" } |
        Select-Object HostName,
            @{Name="IPAddress";Expression={$_.RecordData.IPv4Address.IPAddressToString}} |
        Export-Csv -Path $ExportFile -NoTypeInformation

    Write-Host "Export complete. File saved to $ExportFile" -ForegroundColor Green
}
catch {
    Write-Error "Failed to export DNS records. Error: $_"
}

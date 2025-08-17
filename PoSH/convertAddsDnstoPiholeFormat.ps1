<#
.SYNOPSIS
    Exports all A records from a DNS zone to a CSV file, and
    converts the results into a Pi-hole-compatible hosts file.

.DESCRIPTION
    This script connects to a specified DNS zone, retrieves all A records,
    and exports them (with HostName and IP Address) to a CSV file.
    It then converts those entries to "IP Hostname" format for Pi-hole
    and saves them to a flat text file.

.PARAMETER ZoneName
    The name of the DNS zone to query.

.PARAMETER ExportFile
    The full file path where the CSV output should be saved.

.PARAMETER PiHoleHostFile
    The full file path where the Pi-hole hosts-style output should be saved.

.EXAMPLE
    .\Export-DnsARecords.ps1 -ZoneName "yourdomainname.com" `
                             -ExportFile "C:\Temp\dns_export.csv" `
                             -PiHoleHostFile "C:\Temp\pihole_hosts.txt"

.NOTES
    Author: Shannon Eldridge-Kuehn
    Date:   2025-08-16
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$ZoneName,

    [Parameter(Mandatory = $true)]
    [string]$ExportFile,

    [Parameter(Mandatory = $true)]
    [string]$PiHoleHostFile
)

Write-Host "Exporting A records from zone: $ZoneName"

# Export DNS A records to CSV
$records = Get-DnsServerResourceRecord -ZoneName $ZoneName |
    Where-Object { $_.RecordType -eq "A" } |
    Select-Object HostName, @{Name = "IPAddress"; Expression = { $_.RecordData.IPv4Address.IPAddressToString }}

$records | Export-Csv -Path $ExportFile -NoTypeInformation

Write-Host "DNS records exported to $ExportFile"

# Convert to Pi-hole compatible format
Write-Host "Generating Pi-hole hosts file..."

$records | ForEach-Object {
    if ($_.IPAddress) {
        "$($_.IPAddress) $($_.HostName)"
    }
} | Out-File -FilePath $PiHoleHostFile -Encoding ascii

Write-Host "Pi-hole hosts file saved to $PiHoleHostFile"

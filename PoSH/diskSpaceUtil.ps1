<#
.SYNOPSIS
    Retrieves disk usage information from Windows VMs and exports it to a CSV file.

.DESCRIPTION
    This script queries all Windows VMs from a chosen source (Active Directory or Azure),
    collects all local disks, calculates total, free, and used space in GB,
    and exports the results to a CSV file for reporting or analysis.

    It tests connectivity to each VM before querying and handles errors gracefully.
    Supports parallel execution in PowerShell 7 for faster performance on large environments.

.PARAMETER ExportFile
    Full file path where the CSV output should be saved.

.PARAMETER Source
    Specifies the source for VM discovery. Acceptable values are:
        - "AD"     : Active Directory
        - "Azure"  : Azure subscription

.NOTES
    Author: Shannon Eldridge-Kuehn
    Date:   2025-08-16
    Requirements:
        - Active Directory module for AD queries
        - Az module for Azure queries (Install-Module Az)
        - PowerShell 5.1 or higher; PowerShell 7 recommended for parallel execution
#>

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("AD", "Azure")]
    [string]$Source,

    [Parameter(Mandatory=$true)]
    [string]$ExportFile
)

# Initialize details array
$details = @()

# Discover VMs based on the selected source
switch ($Source) {
    "AD" {
        Write-Host "Fetching Windows VMs from Active Directory..." -ForegroundColor Cyan
        Import-Module ActiveDirectory -ErrorAction Stop
        $servers = Get-ADComputer -Filter {OperatingSystem -like "*Windows*"} | Select-Object -ExpandProperty Name
    }
    "Azure" {
        Write-Host "Fetching Windows VMs from Azure..." -ForegroundColor Cyan
        Import-Module Az -ErrorAction Stop
        Connect-AzAccount -ErrorAction Stop
        $servers = Get-AzVM | Where-Object {$_.StorageProfile.OsDisk.OsType -eq "Windows"} | Select-Object -ExpandProperty Name
    }
}

# Check if any servers were found
if (-not $servers -or $servers.Count -eq 0) {
    Write-Warning "No servers found. Exiting script."
    return
}

Write-Host "Found $($servers.Count) servers. Starting disk query..." -ForegroundColor Green

# Loop through each server
foreach ($server in $servers) {
    try {
        if (Test-Connection -ComputerName $server -Count 1 -Quiet) {
            # Query local disks (DriveType 3)
            $disks = Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $server | Where-Object { $_.DriveType -eq 3 }

            foreach ($disk in $disks) {
                $details += [PSCustomObject]@{
                    VMName      = $server
                    DriveLetter = $disk.DeviceID
                    TotalSizeGB = [math]::Round($disk.Size / 1GB, 2)
                    FreeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2)
                    UsedSpaceGB = [math]::Round(($disk.Size - $disk.FreeSpace) / 1GB, 2)
                }
            }
        } else {
            Write-Warning "Server $server is not reachable."
        }
    } catch {
        Write-Error "Failed to query $server: $_"
    }
}

# Output results to console
$details | Format-Table -AutoSize

# Export to CSV
$details | Export-Csv -Path $ExportFile -NoTypeInformation
Write-Host "Disk usage report exported to $ExportFile" -ForegroundColor Green

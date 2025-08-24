<#
.SYNOPSIS
    Retrieves the Resource ID of an Azure Storage Account.

.DESCRIPTION
    This script connects to Azure (if not already connected), validates the existence of the specified 
    storage account, and returns its Resource ID. This is particularly useful when you need to supply 
    the Resource ID as a parameter to Azure Policy (e.g., DeployIfNotExists) or other automation workflows.

.PARAMETER rGroupName
    The name of the Azure Resource Group that contains the storage account.

.PARAMETER saName
    The name of the Azure Storage Account.

.EXAMPLE
    PS C:\> .\Get-StorageAccountResourceId.ps1 -rGroupName "rg-diagnostics" -saName "bootdiagstorage01"

    /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-diagnostics/providers/Microsoft.Storage/storageAccounts/bootdiagstorage01

.NOTES
    Author: Shannon Eldridge-Kuehn
    Version: 1.0
    Requirements:
        - Az PowerShell module
        - Appropriate RBAC permissions (Reader or higher on the storage account)
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, HelpMessage = "Name of the Resource Group containing the storage account.")]
    [string]$rGroupName,

    [Parameter(Mandatory = $true, HelpMessage = "Name of the Storage Account.")]
    [string]$saName
)

# Ensure Az module is available
if (-not (Get-Module -ListAvailable -Name Az.Accounts)) {
    Write-Error "Az PowerShell modules are required. Run: Install-Module Az -Scope CurrentUser"
    exit 1
}

try {
    # Ensure authenticated session
    if (-not (Get-AzContext)) {
        Write-Host "Connecting to Azure..." -ForegroundColor Cyan
        Connect-AzAccount -ErrorAction Stop
    }

    # Retrieve the storage account
    $storageAccount = Get-AzStorageAccount -ResourceGroupName $rGroupName -Name $saName -ErrorAction Stop

    if ($null -eq $storageAccount) {
        Write-Error "Storage account '$saName' not found in resource group '$rGroupName'."
        exit 1
    }

    # Output the Resource ID
    $storageAccount.Id
}
catch {
    Write-Error "Failed to retrieve storage account Resource ID. Error details: $_"
    exit 1
}

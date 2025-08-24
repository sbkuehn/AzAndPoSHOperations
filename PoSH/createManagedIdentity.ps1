<#
.SYNOPSIS
    Creates a User-Assigned Managed Identity in Azure.

.DESCRIPTION
    This script creates a User-Assigned Managed Identity (UAMI) within a specified
    resource group. The identity can then be assigned to Azure Policy Assignments,
    Virtual Machines, or other resources that require a managed identity.

.PARAMETER IdentityName
    The name of the User-Assigned Managed Identity to create.

.PARAMETER ResourceGroupName
    The name of the Azure Resource Group where the managed identity will be deployed.

.PARAMETER Location
    The Azure region (location) in which to deploy the managed identity.

.EXAMPLE
    PS C:\> .\New-ManagedIdentity.ps1 -IdentityName "policyIdentity01" `
                                      -ResourceGroupName "rg-identities" `
                                      -Location "eastus"

    Creates a user-assigned managed identity named "policyIdentity01" in the "rg-identities"
    resource group in the East US region.

.NOTES
    Author: Shannon Eldridge-Kuehn
    Version: 1.0
    Requirements:
        - Az PowerShell module
        - Contributor or Owner rights on the target subscription/resource group
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, HelpMessage = "Name of the User-Assigned Managed Identity.")]
    [string]$IdentityName,

    [Parameter(Mandatory = $true, HelpMessage = "Name of the Resource Group.")]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true, HelpMessage = "Azure region where the identity will be created.")]
    [string]$Location
)

# Ensure Az module is loaded
if (-not (Get-Module -ListAvailable -Name Az.ManagedServiceIdentity)) {
    Write-Error "Az.ManagedServiceIdentity module is required. Install it with: Install-Module Az -Scope CurrentUser"
    exit 1
}

try {
    # Authenticate if not already logged in
    if (-not (Get-AzContext)) {
        Write-Host "Connecting to Azure..." -ForegroundColor Cyan
        Connect-AzAccount -ErrorAction Stop
    }

    # Verify Resource Group exists
    $rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
    if (-not $rg) {
        Write-Host "Resource group '$ResourceGroupName' does not exist. Creating it..." -ForegroundColor Yellow
        $rg = New-AzResourceGroup -Name $ResourceGroupName -Location $Location
    }

    # Create the User-Assigned Managed Identity
    Write-Host "Creating User-Assigned Managed Identity '$IdentityName' in resource group '$ResourceGroupName'..." -ForegroundColor Cyan
    $identity = New-AzUserAssignedIdentity -ResourceGroupName $ResourceGroupName -Name $IdentityName -Location $Location -ErrorAction Stop

    Write-Host "Managed Identity created successfully!" -ForegroundColor Green
    Write-Host "Resource ID: $($identity.Id)"
    Write-Host "Principal ID: $($identity.PrincipalId)"
    Write-Host "Client ID:    $($identity.ClientId)"
}
catch {
    Write-Error "Failed to create managed identity. Error: $_"
    exit 1
}

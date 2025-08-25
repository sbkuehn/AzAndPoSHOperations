<#
.SYNOPSIS
Removes the Microsoft Sentinel (SecurityInsights) solution from a Log Analytics workspace.

.DESCRIPTION
This script detaches Microsoft Sentinel by removing the SecurityInsights solution.
The Log Analytics workspace remains intact along with other solutions and data.

.PARAMETER ResourceGroupName
The name of the resource group containing the Log Analytics workspace.

.PARAMETER WorkspaceName
The name of the Log Analytics workspace where Sentinel is enabled.

.EXAMPLE
.\Remove-Sentinel.ps1 -ResourceGroupName "RG-Security" -WorkspaceName "LA-Workspace"

.NOTES
Author: Your Name
Date:   2025-08-24
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$WorkspaceName
)

# Construct the solution name format
$solutionName = "SecurityInsights($WorkspaceName)"

Write-Output "Removing SecurityInsights solution [$solutionName] from workspace [$WorkspaceName] in resource group [$ResourceGroupName]..."

try {
    Remove-AzResource -ResourceGroupName $ResourceGroupName `
                      -ResourceType "Microsoft.OperationsManagement/solutions" `
                      -ResourceName $solutionName `
                      -Force -ErrorAction Stop

    Write-Output "Successfully removed SecurityInsights from the workspace."
}
catch {
    Write-Error "Failed to remove SecurityInsights. Details: $_"
}

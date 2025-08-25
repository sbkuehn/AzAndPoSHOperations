<#
.SYNOPSIS
Checks for solutions attached to a Log Analytics workspace.

.DESCRIPTION
This snippet lists all Microsoft.OperationsManagement/solutions resources in a given resource group. Useful for verifying whether the SecurityInsights (Sentinel) solution is still attached (or other legacy solutions).

.PARAMETER ResourceGroupName
The resource group that contains the Log Analytics workspace.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName
)

Get-AzResource -ResourceGroupName $ResourceGroupName | Where-Object { 
    $_.ResourceType -eq "Microsoft.OperationsManagement/solutions" 
}

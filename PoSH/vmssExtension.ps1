<#
© 2019 Microsoft Corporation. 
All rights reserved. Sample scripts/code provided herein are not supported under any Microsoft standard support program 
or service. The sample scripts/code are provided AS IS without warranty of any kind. Microsoft disclaims all implied 
warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. 
The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event 
shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for 
any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of 
business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or 
documentation, even if Microsoft has been advised of the possibility of such damages.

.SYNOPSIS
  Stores a number of variables, grabs the VM Scale Set, and adds the Network Watcher extension.

.DESCRIPTION
  This script adds the Network Watcher VM Scale Set extension.

.PARAMETER 
  Required: VM Scale Set Resource Group, Extension Name, VM Scale Set Name, Publisher, Type

.INPUTS
  None

.OUTPUTS
  None

.NOTES
  Version:        1.0
  Author:         Shannon Kuehn
  Creation Date:  2019.10.25
  Purpose/Change: Initial script development
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [striong]$vmScaleSetResourceGroup,
    [Parameter(Mandatory=$true)]
    [string]$extensionName,
    [Parameter(Mandatory=$true)]
    [string]$vmScaleSetName,
    [Parameter(Mandatory=$true)]
    [string]$publisher,
    [Parameter(Mandatory=$true)]
    [string]$type
)

# Get the scale set object
$vmScaleSet = Get-AzVmss `
  -ResourceGroupName $vmScaleSetResourceGroup `
  -VMScaleSetName $vmScaleSetName

# Add the Application Health extension to the scale set model
Add-AzVmssExtension -VirtualMachineScaleSet $vmScaleSet `
  -Name $extensionName `
  -Publisher $publisher `
  -Type $type `
  -TypeHandlerVersion "1.4" `
  -AutoUpgradeMinorVersion $True
  
# Update the scale set
Update-AzVmss -ResourceGroupName $vmScaleSetResourceGroup `
  -Name $vmScaleSetName `
  -VirtualMachineScaleSet $vmScaleSet

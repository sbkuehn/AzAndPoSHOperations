<#
© 2021 Microsoft Corporation. 
All rights reserved. Sample scripts/code provided herein are not supported under any Microsoft standard support program 
or service. The sample scripts/code are provided AS IS without warranty of any kind. Microsoft disclaims all implied 
warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. 
The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event 
shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for 
any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of 
business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or 
documentation, even if Microsoft has been advised of the possibility of such damages.
.SYNOPSIS
  Stores a number of variables, locates the existing VM, powers it off, and adjusts the VM size.
.DESCRIPTION
  This script removes an extension for a single VM.
.PARAMETER 
  Required: Resource Group Name, VM name, extension name
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Shannon Kuehn
  Creation Date:  2021.11.05
  Purpose/Change: Initial script development
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$rg,
    [Parameter(Mandatory=$true)]
    [string]$vmName,
    [Parameter(Mandatory=$true)]
    [string]$extName
)

Remove-AzVMExtension -ResourceGroupName $rg -VMName $vmName -Name $extName

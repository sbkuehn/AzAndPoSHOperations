<#
© 2020 Microsoft Corporation. 
All rights reserved. Sample scripts/code provided herein are not supported under any Microsoft standard support program 
or service. The sample scripts/code are provided AS IS without warranty of any kind. Microsoft disclaims all implied 
warranties including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. 
The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event 
shall Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for 
any damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of 
business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or 
documentation, even if Microsoft has been advised of the possibility of such damages.
.SYNOPSIS
  Discovers all Recovery Services vaults in any target subscription, identifies the Vault ID, stores the Vault ID as a variable, removes soft delete on the Recovery Services
  Vault, identifies the backup items still stored in the target Recovery Services Vault, and forcibly removes the items stored after the soft delete is removed.
.DESCRIPTION
  Forcibly removes backup items that were in a soft delete state.
.PARAMETER 
  Built upon outputs of script.
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Shannon Kuehn
  Creation Date:  2020.08.27
  Purpose/Change: Initial script development
#>

$vault = Get-AzRecoveryServicesVault
$vaultId = $vault[0]
$vaultId.ID

Set-AzRecoveryServicesVaultProperty -VaultId $vaultId.ID -SoftDeleteFeatureState Disable

Get-AzRecoveryServicesBackupItem -BackupManagementType AzureVM -WorkloadType AzureVM -VaultId $vaultId.ID
$BackupItem = Get-AzRecoveryServicesBackupItem -BackupManagementType AzureVM -WorkloadType AzureVM -VaultId $vaultId.ID

$Backup1 = $BackupItem[0]
$Backup2 = $BackupItem[1]

Disable-AzRecoveryServicesBackupProtection -Item $Backup1 -RemoveRecoveryPoints -VaultId $vaultId -Force
Disable-AzRecoveryServicesBackupProtection -Item $Backup2 -RemoveRecoveryPoints -VaultId $vaultId -Force

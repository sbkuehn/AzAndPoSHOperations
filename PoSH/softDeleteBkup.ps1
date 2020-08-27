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

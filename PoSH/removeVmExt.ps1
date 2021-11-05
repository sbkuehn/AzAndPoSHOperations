param(
    [Parameter(Mandatory=$true)]
    [string]$rg,
    [Parameter(Mandatory=$true)]
    [string]$vmName,
    [Parameter(Mandatory=$true)]
    [string]$extName
)

Remove-AzVMExtension -ResourceGroupName $rg -VMName $vmName -Name $extName

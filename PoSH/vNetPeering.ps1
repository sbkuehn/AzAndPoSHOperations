param(
    [Parameter(Mandatory=$true)]
    [string]$rg1,
    [Parameter(Mandatory=$true)]
    [string]$rg2,
    [Parameter(Mandatory=$true)]
    [string]$virtualNetwork1,
    [Parameter(Mandatory=$true)]
    [string]$virtualNetwork2,
    [Parameter(Mandatory=$true)]
    [string]$peerName1,
    [Parameter(Mandatory=$true)]
    [string]$peerName2
)

# Establishes vNet Peering (global or regional)
$vnet1 = Get-AzVirtualNetwork -ResourceGroupName $rg1 -Name $virtualNetwork1 
$vnet2 = Get-AzVirtualNetwork -ResourceGroupName $rg2 -Name $virtualNetwork2
Add-AzVirtualNetworkPeering -Name $peerName1 -VirtualNetwork $vnet1 -RemoteVirtualNetworkId $vnet2.Id -AllowGatewayTransit -AllowForwardedTraffic
Add-AzVirtualNetworkPeering -Name $peerName2 -VirtualNetwork $vnet2 -RemoteVirtualNetworkId $vnet1.Id -AllowGatewayTransit -AllowForwardedTraffic -UseRemoteGateways

# Removes vNet Peering (global or regional)
Remove-AzVirtualNetworkPeering -ResourceGroupName $rg1 -VirtualNetworkName $virtualNetwork1 -Name $peerName1 
Remove-AzVirtualNetworkPeering -ResourceGroupName $rg2 -VirtualNetworkName $virtualNetwork2 -Name $peerName2

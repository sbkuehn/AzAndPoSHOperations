$vms = Get-AzVM -VMName * -ResourceGroupName *
$extensions = $vms.Extensions
$workspaceId = "Log Analytics Workspace ID"
$workspaceKey = "Log Analytics Workspace Key"
$PublicSettings = @{"workspaceId" = $workspaceId;"stopOnMultipleConnections" = $false}
$ProtectedSettings = @{"workspaceKey" = $workspaceKey}

ForEach($vm in $vms){
    Remove-AzVMExtension -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name -Name MicrosoftMonitoringAgent -Force
    Remove-AzVMExtension -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name -Name AzureMonitorWindowsAgent -Force
    Remove-AzVMExtension -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name -Name DependencyAgentWindows -Force
    Remove-AzVMExtension -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name -Name GuestHealthWindowsAgent -Force
    Set-AzVMExtension -ExtensionName "MicrosoftMonitoringAgent" -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name `
    -Publisher "Microsoft.EnterpriseCloud.Monitoring" `
    -ExtensionType "MicrosoftMonitoringAgent" `
    -TypeHandlerVersion 1.0 `
    -Settings $PublicSettings `
    -ProtectedSettings $ProtectedSettings `
    -Location $vm.Location
    Set-AzVMExtension -ExtensionName "AzureMonitorWindowsAgent" -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name `
    -Publisher "Microsoft.Azure.Monitor" `
    -ExtensionType "AzureMonitorWindowsAgent" `
    -TypeHandlerVersion 1.0 `
    -Settings $PublicSettings `
    -ProtectedSettings $ProtectedSettings `
    -Location $vm.Location
    Set-AzVMExtension -ExtensionName "DependencyAgentWindows" -ResourceGroupName $vm.resourcegroupname -VMName $vm.Name `
    -Publisher "Microsoft.Azure.Monitoring.DependencyAgent" `
    -ExtensionType "DependencyAgentWindows" `
    -TypeHandlerVersion 9.5 `
    -Settings $PublicSettings `
    -ProtectedSettings $ProtectedSettings `
    -Location $vm.Location
    Set-AzVMExtension -ExtensionName "GuestHealthWindowsAgent" -ResourceGroupName $vm.resourcegroupname -VMName $vm.name `
    -Publisher "Microsoft.Azure.Monitor.VirtualMachines.GuestHealth" `
    -ExtensionType "GuestHealthWindowsAgent" `
    -TypeHandlerVersion 1.0 `
    -Settings $PublicSettings `
    -ProtectedSettings $ProtectedSettings `
    -Location $vm.Location
}

# Connect to Azure
Connect-AzAccount

# Define the path for the CSV file
$path = Read-Host -Prompt "Please provide a file path."

# Initialize an array to store combined VM, disk, and snapshot details
$details = @()

# Get all subscriptions in the Azure tenant
$subscriptions = Get-AzSubscription

# Loop through each subscription
foreach ($subscription in $subscriptions) {
    # Select the subscription
    Select-AzSubscription -SubscriptionId $subscription.Id

    # Get all VMs in the subscription
    $vms = Get-AzVM

    # Loop through each VM
    foreach ($vm in $vms) {
        $vmName = $vm.Name
        $resourceGroup = $vm.ResourceGroupName

        # Get all managed disks attached to the VM
        $disks = Get-AzDisk -ResourceGroupName $resourceGroup | Where-Object {$_.ManagedBy -eq $vm.Id}

        foreach ($disk in $disks) {
            # Add disk details to the array
            $details += [PSCustomObject]@{
                Type = "Disk"
                VMName = $vmName
                Name = $disk.Name
                ManagedBy = $disk.ManagedBy
                SKU = $disk.Sku.Name
                Size = $disk.DiskSizeGB
                Id = $disk.UniqueId
                ResourceGroup = $disk.ResourceGroupName
                SubscriptionName = $subscription.Name
                SubscriptionId = $subscription.Id
                CreationDate = $null
                SourceId = $null
            }
        }

        # Get all snapshots in the subscription
        $snapshots = Get-AzSnapshot -ResourceGroupName $resourceGroup

        # Loop through each snapshot
        foreach ($snapshot in $snapshots) {
            # Add snapshot details to the array
            $details += [PSCustomObject]@{
                Type = "Snapshot"
                VMName = $vmName
                Name = $snapshot.Name
                ManagedBy = $null
                SKU = $null
                Size = $null
                Id = $snapshot.Id
                ResourceGroup = $snapshot.ResourceGroupName
                SubscriptionName = $subscription.Name
                SubscriptionId = $subscription.Id
                CreationDate = $snapshot.TimeCreated
                SourceId = $snapshot.CreationData.SourceResourceId
            }
        }
    }
}

# Output combined details to CSV file
$details | Export-Csv -Path $path -NoTypeInformation
Write-Output "CSV file with combined VM, disk, and snapshot details has been created at $path."

$path = "C:\Your\Path\Here\Disk_Details.csv"

# Connect to Azure
Connect-AzAccount

# Get all subscriptions in the Azure tenant
$subscriptions = Get-AzSubscription

# Initialize an array to store VM details
$diskDetails = @()

# Loop through each subscription
foreach ($subscription in $subscriptions) {

    # Select the subscription
    Select-AzSubscription -SubscriptionId $subscription.Id
    
    # Get all disks in the subscription
    $disks = Get-AzDisk
    
    # Loop through each disk
    foreach ($disk in $disks) {
    
            # Add disk details to the array
            $diskDetails += [PSCustomObject]@{
                DiskName = $disk.Name
                DiskManagedBy = $disk.ManagedBy
                DiskSKU = $disk.Sku.Name
                DiskSize = $disk.DiskSizeGB
                DiskId = $disk.UniqueId
                ResourceGroup = $disk.ResourceGroupName
                SubscriptionName = $subscription.Name
                SubscriptionId = $subscription.Id
        }
    }
}

# Output disk details to CSV file
$diskDetails | Export-Csv -Path $path -NoTypeInformation

Write-Host "CSV file with disk details has been created."

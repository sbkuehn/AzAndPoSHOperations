$path = "c:\Your\Path\Here\snapshotInfo.csv"

# Initialize an empty array to store snapshot information
$snapshotInfo = @()

# Get all subscriptions
$subscriptions = Get-AzSubscription

# Loop through each subscription
foreach ($subscription in $subscriptions) {
    # Select the subscription
    Select-AzSubscription -SubscriptionId $subscription.Id

    # Get all snapshots in the subscription
    $snapshots = Get-AzSnapshot

    # Loop through each snapshot
    foreach ($snapshot in $snapshots) {

        # Add snapshot details to the array
        $snapshotInfo += [PSCustomObject]@{
            SnapshotName = $snapshot.Name
            ResourceGroup = $snapshot.ResourceGroupName
            CreationDate = $snapshot.TimeCreated
            SubscriptionName = $subscription.Name
            SubscriptionId = $subscription.Id
            
        }
    }
}

# Export snapshot information to a CSV file
$snapshotInfo | Export-Csv -Path $path -NoTypeInformation

# Print a success message
Write-Host "CSV file with snapshot information has been created."

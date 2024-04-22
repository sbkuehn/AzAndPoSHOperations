$path = "c:\Your\Path\Here\snapshotInfo.csv"

# Initialize an empty array to store snapshot information
$snapshotInfo = @()

# Get all subscriptions
$subscriptions = Get-AzSubscription

# Loop through each subscription
foreach ($subscription in $subscriptions) {
    # Select the subscription
    Set-AzContext -Subscription $subscription.Id

    # Get all snapshots in the subscription
    $snapshots = Get-AzSnapshot

    # Extract relevant information from snapshots
    foreach ($snapshot in $snapshots) {
        $snapshotName = $snapshot.Name
        $resourceGroup = $snapshot.ResourceGroupName
        $creationDate = $snapshot.TimeCreated

        # Create a custom object with snapshot information
        $snapshotObject = New-Object PSObject -Property @{
            SnapshotName = $snapshotName
            ResourceGroup = $resourceGroup
            CreationDate = $creationDate
        }

        # Add the snapshot object to the array
        $snapshotInfo += $snapshotObject
    }
}

# Export snapshot information to a CSV file
$snapshotInfo | Export-Csv -Path $path -NoTypeInformation

# Print a success message
Write-Host "CSV file with snapshot information has been created."

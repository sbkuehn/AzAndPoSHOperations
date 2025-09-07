# Requires Az.ResourceGraph, Az.Monitor, Az.Accounts modules

# Step 1: Query ARG for all Blob-capable storage accounts
$storageAccounts = Search-AzGraph -Query @"
Resources
| where type == 'microsoft.storage/storageaccounts'
| where kind in~ ('StorageV2','BlobStorage')
| project id, name, resourceGroup, subscriptionId, location, skuName = tostring(sku.name), skuTier = tostring(sku.tier), accessTier = tostring(properties.accessTier), blobEndpoint = tostring(properties.primaryEndpoints.blob)
"@

# Step 2: Loop through accounts and pull UsedCapacity from Azure Monitor
$results = foreach ($acct in $storageAccounts) {
    try {
        $metric = Get-AzMetric -ResourceId $acct.id -MetricName "UsedCapacity" -TimeGrain 01:00:00 -ErrorAction Stop
        $latest = $metric.Data | Where-Object { $_.Average -ne $null } | Select-Object -Last 1

        [PSCustomObject]@{
            SubscriptionId  = $acct.subscriptionId
            ResourceGroup   = $acct.resourceGroup
            Name            = $acct.name
            Location        = $acct.location
            SkuName         = $acct.skuName
            SkuTier         = $acct.skuTier
            AccessTier      = $acct.accessTier
            BlobEndpoint    = $acct.blobEndpoint
            UsedCapacityGB  = if ($latest) { [math]::Round(($latest.Average / 1GB), 2) } else { 0 }
        }
    }
    catch {
        Write-Warning "Failed to get metrics for $($acct.name) in $($acct.resourceGroup)."
    }
}

# Step 3: Display results
$results | Format-Table -AutoSize

# Step 4: Export to CSV if needed
$results | Export-Csv -Path "BlobStorageAccountInventory.csv" -NoTypeInformation

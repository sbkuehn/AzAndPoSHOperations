# Exploratory queries
# Search Azure Resource Graph for all workspaces
Search-AzGraph -Query "where type =~ 'Microsoft.OperationalInsights/workspaces'"

# Store a variable array of all workspaces and run the variable to see all fields contained within the object.
$workspaces = Search-AzGraph -Query "where type =~ 'Microsoft.OperationalInsights/workspaces'"
$workspaces

# Run these queries to ensure you gather all the right fields to form the inventory report.
$workspaces.name
$workspaces.location
$workspaces.resourceGroup
$workspaces.properties.sku
$workspaces.properties.features

# This script creates an inventory report of all Log Analytics workspaces. I
$results = @()
$workspaces = Search-AzGraph -Query "where type =~ 'Microsoft.OperationalInsights/workspaces'"
ForEach($workspace in $workspaces){ 
    $obj = New-Object -TypeName PSObject
    $obj | Add-Member -MemberType NoteProperty -Name name -Value $workspace.name 
    $obj | Add-Member -MemberType NoteProperty -Name location -Value $workspace.location 
    $obj | Add-Member -MemberType NoteProperty -Name resourceGroup -Value $workspace.resourceGroup
    $obj | Add-Member -MemberType NoteProperty -Name sku -Value $workspace.properties.sku
    $obj | Add-Member -MemberType NoteProperty -Name features -Value $workspace.properties.features
    $results += $obj
}
$results | Sort name | Export-Csv C:\results.csv -NoTypeInformation

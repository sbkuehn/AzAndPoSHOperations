<#
Created 
2021.03.14
Shannon Kuehn
Last Updated
© 2021 Microsoft Corporation. 
All rights reserved. Sample scripts/code provided herein are not supported under any Microsoft standard support program or 
service. The sample scripts/code are provided AS IS without warranty of any kind. Microsoft disclaims all implied warranties 
including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire 
risk arising out of the use or performance of the sample scripts and documentation remains with you. In no event shall 
Microsoft, its authors, or anyone else involved in the creation, production, or delivery of the scripts be liable for any 
damages whatsoever (including, without limitation, damages for loss of business profits, business interruption, loss of 
business information, or other pecuniary loss) arising out of the use of or inability to use the sample scripts or 
documentation, even if Microsoft has been advised of the possibility of such damages.
#>

# Exploratory queries
# Search Azure Resource Graph for all workspaces
Search-AzGraph -Query "where type =~ 'Microsoft.OperationalInsights/workspaces'"

# Store a variable array of all workspaces and run the variable to see all fields contained within the object.
$workspaces = Search-AzGraph -Query "where type =~ 'Microsoft.OperationalInsights/workspaces'"
$workspaces

# Run these cmdlets to ensure you gather all the right fields to form the inventory report. 
# You will want the name, location, resource group, SKU, and features to ensure your Log Analytics workspace is designed correctly to meet the needs of the enterprise.
$workspaces.name
$workspaces.location
$workspaces.resourceGroup

# Run the next cmdlet to see the SKU and permissions model information:
$workspaces.properties

# From there, you should be able to extract the right information by running the next two cmdlets:
$workspaces.properties.sku
$workspaces.properties.features

# This script creates an inventory report of all Log Analytics workspaces and extracts the name, location, resource group, SKU, and permissions model into a CSV file.
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

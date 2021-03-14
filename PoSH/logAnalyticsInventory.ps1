$results = @()
$workspaces = Search-AzGraph -Query "where type =~ 'Microsoft.OperationalInsights/workspaces'"
ForEach($workspace in $workspaces){ 
    $obj = New-Object -TypeName PSObject
    $obj | Add-Member -MemberType NoteProperty -Name name -Value $workspace.name 
    $obj | Add-Member -MemberType NoteProperty -Name location -Value $workspace.location 
    $obj | Add-Member -MemberType NoteProperty -Name resourceGroup -Value $workspace.resourceGroup
    $obj | Add-Member -MemberType NoteProperty -Name sku -Value $workspace.properties.sku 
    $results += $obj
}
$results | Export-Csv C:\results.csv -NoTypeInformation

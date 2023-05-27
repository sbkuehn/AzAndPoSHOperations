Connect-AzAccount
$subs = @(Shannon Pay-As-You-Go - Subscription','Shannon - Microsoft Partner Network Subscription')
ForEach ($sub in $subs) {
    Get-AzAdvisorRecommendation | Select-Object ResourceMetaDataResourceId, ImpactedValue, ImpactedField, Impact, Category, ShortDescriptionSolution `
    | Export-Csv c:\users\ShannonKuehn\export.csv -NoTypeInformation 
}

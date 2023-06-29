$subs = Get-AzSubscription
ForEach ($sub in $subs){
    Get-AzResourceProvider -ListAvailable | ForEach-Object{Register-AzResourceProvider -ProviderNamespace $_.ProviderNamespace}
}

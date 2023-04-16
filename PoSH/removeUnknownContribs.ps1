$unknownContributors = Get-AzRoleAssignment | Where-Object -Property ObjectType -eq "Unknown"
ForEach ($unknownContributor in $unknownContributors){
    Remove-AzRoleAssignment -ObjectId $unknownContributor.ObjectId -RoleDefinitionName "Contributor"
}

# Connect to Azure account
Login-AzAccount

# Set Azure context
Set-AzContext -Subscription "ca-shkuehn-demo-test"

# Lists all regions to be queried for API versions
Get-AzLocation | more

# Lists out all Resource Providers in a given region
Get-AzResourceProvider -Location eastus -ListAvailable | Format-Table ProviderNamespace

# Lists out all resource type names
(Get-AzResourceProvider -ProviderNamespace Microsoft.Compute).ResourceTypes | Format-Table ResourceTypeName

# Obtains all relevant APIs that can be used for a resource during deployment
((Get-AzResourceProvider -ProviderNamespace Microsoft.Compute).ResourceTypes | Where-Object ResourceTypeName -eq virtualmachines).ApiVersions 

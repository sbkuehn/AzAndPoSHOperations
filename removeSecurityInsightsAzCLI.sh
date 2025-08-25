# Assign values to variables
ResourceGroupName=nameOfResourceGroup
LogAnalyticsWorkspace=nameOfLogAnalyticsWorkspace

az monitor log-analytics solution delete \
  --resource-group $ResourceGroupName \
  --workspace-name $LogAnalyticsWorkspace \
  --name SecurityInsights

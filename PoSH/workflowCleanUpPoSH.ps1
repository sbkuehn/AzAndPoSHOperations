workflow Uninstall-AzureModules
{
    $Modules = (Get-Module -ListAvailable Az*).Name |Get-Unique
    ForEach -parallel ($Module in $Modules)
    { 
        Write-Output ("Uninstalling: $Module")
        Uninstall-Module $Module -Force
    }
}
Uninstall-AzureModules
Uninstall-AzureModules   #second invocation to truly remove everything

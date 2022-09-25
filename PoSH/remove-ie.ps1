Get-WindowsOptionalFeature -Online -FeatureName *explorer*
Import-Module ActiveDirectory
$servers = Get-ADComputer -Filter {OperatingSystem -like "*Windows*"}
ForEach ($server in $servers){
        Invoke-Command -ComputerName $server.Name -ScriptBlock {
        Disable-WindowsOptionalFeature -Online -FeatureName Internet-Explorer-Optional-amd64 -ErrorAction SilentlyContinue
    }
    Write-Host -ForegroundColor Green Removed Internet Explorer on $server.DNSHostName
}

Import-Module ActiveDirectory
$servers = Get-ADComputer -Filter {OperatingSystem -like "*Windows*"}
ForEach ($server in $servers){
    $session = New-PSSession -ComputerName $server.Name
        Invoke-Command -Session $session -ScriptBlock {
            choco install powershell-core -y             
    }
    Enter-PSSession -Session $session 
    Exit-PSSession
    Write-Host -ForegroundColor Green Installed PowerShell Core on $server.DNSHostName
}

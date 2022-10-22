Import-Module ActiveDirectory
$servers = Get-ADComputer -Filter {OperatingSystem -like "*Windows*"}
ForEach($server in $servers){
    $session = (New-PSSession -ComputerName $server.DNSHostName)
        Invoke-Command -Session $session -ScriptBlock {
            $updateSession = New-Object -com "Microsoft.Update.Session"; $updates=$updateSession.CreateupdateSearcher().Search($criteria).Updates
            wuauclt.exe /reportnow
    }
    Write-Host -ForegroundColor Green Forced WSUS report-in on $server.DNSHostName
}

Import-Module ActiveDirectory
$servers = Get-ADComputer -Filter {OperatingSystem -like "*Windows*"}
$sourcePath = "\\shanutils\Utils\Software\Edge-Chromium\MicrosoftEdgeEnterpriseX64.msi"
ForEach ($server in $servers){
    Copy-Item -Path $sourcePath -Destination \\$($server.Name)\c$\ -Verbose -WarningAction Ignore -ErrorAction Ignore
    $session = New-PSSession -ComputerName $server.Name
        Invoke-Command -Session $session -ScriptBlock {
            $process = New-Object System.Diagnostics.Process  
            $process.StartInfo.FileName = "C:\MicrosoftEdgeEnterpriseX64.msi"
            $process.StartInfo.Arguments = " /qn"
            $process.Start()             
    }
    Enter-PSSession -Session $session 
    Exit-PSSession
    Write-Host -ForegroundColor Green Installed Microsoft Edge on $server.DNSHostName
}

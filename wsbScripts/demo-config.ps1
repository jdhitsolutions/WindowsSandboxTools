#this script runs IN the Windows Sandbox

$logParams = @{
    Filepath = "C:\log\setup.txt"
    Append   = $True
}

"[$(Get-Date)] Starting $($myinvocation.mycommand)" | Out-File @logParams

"[$(Get-Date)] Enabling PSRemoting" | Out-File @logParams
Enable-PSRemoting -Force -SkipNetworkProfileCheck

"[$(Get-Date)] Set DNS Server to 1.1.1.1" | Out-File @logParams
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses 1.1.1.1

"[$(Get-Date)] Install latest nuget package provider" | Out-File @logParams
Install-PackageProvider -name nuget -force -forcebootstrap -scope allusers

"[$(Get-Date)] Update PackageManagement and PowerShellGet modules" | Out-File @logParams
Install-Module PackageManagement, PowerShellGet -Force

#run remaining commands in parallel background jobs
"[$(Get-Date)] Update help" | Out-File @logParams
Start-Job -Name "Help-Update" -ScriptBlock { Update-Help -Force }

"[$(Get-Date)] Installing default modules" | Out-File @logParams
Start-Job -Name "Module-Install" -ScriptBlock { Install-Module PSScriptTools, BurntToast -Force }

"[$(Get-Date)] Install Windows Terminal" | Out-File @logParams
Start-Job -Name "Windows-Terminal" -ScriptBlock { Install-Module WTToolbox -Force ; Install-WTRelease }

#wait for everything to finish
"[$(Get-Date)] Waiting for jobs to finish" | Out-File @logParams
Get-Job | Wait-Job

foreach ($job in (Get-Job)) {
    $result = "Job {0} {1} [{2}]" -f $job.name, $job.state, (New-TimeSpan -Start $job.PSBeginTime -End $job.PSEndTime)
    "[$(Get-Date)] $result" | Out-File @logParams
}

"[$(Get-Date)] Starting Windows Terminal" | Out-File @logParams
Start-Process wt.exe "-M new-tab -d C:\ -p Windows PowerShell"

"[$(Get-Date)] Setting the host notification flag" | Out-File @logParams
Get-Date | Out-File -FilePath c:\scripts\sandbox.flag

"[$(Get-Date)] Sending toast notification in the Windows Sandbox" | Out-File @logParams

$params = @{
    Text   = "Windows Sandbox configuration is complete."
    Header = $(New-BTHeader -Id 1 -Title "Your Sandbox")
    Silent = $True
}

New-BurntToastNotification @params

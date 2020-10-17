#this script runs IN the Windows Sandbox

$SetupPath = "C:\scripts\WindowsSandboxTools"

#create a log file of the configuration process.
Function log {
    Param(
        [string]$msg,
        [string]$log = "C:\work\wsblog.txt"
    )

    "[{0}] {1}" -f (Get-Date), $msg | Out-File -FilePath $log -Encoding ascii -Append
}

log "Enabling PowerShell remoting"
Enable-PSRemoting -force -SkipNetworkProfileCheck

log "Install package provider"
Install-PackageProvider -name nuget -force -forcebootstrap -scope allusers

log "Updating package management"
Update-Module PackageManagement, PowerShellGet -force

#run updates and installs in the background
log "Updating Windows PowerShell Help"
Start-Job { powershell -command { Update-Help -force } }
log "Installing default modules: PSScriptTools, PSTeachingTools, BurntToast"
Start-Job { Install-Module PSScriptTools, PSTeachingTools, BurntToast -force }
log "Installing PSReleaseTools and PowerShell 7 + Preview"
Start-Job {
    Install-Module PSReleaseTools -force;
    Install-PowerShell -mode quiet -enableremoting -EnableContextMenu;
    Install-PSPreview -mode quiet -enableremoting -EnableContextMenu;
    #update help
    C:\Program` Files\PowerShell\7\pwsh.exe -command { Update-Help -force }
}
log "Installing Windows Terminal"
Start-Job { Install-Module WTToolbox -force ; Install-WTRelease }
log "Installing VSCode"
Start-Job -FilePath (Join-Path -path $SetupPath -childpath install-vscodesandbox.ps1)
log "Configuring desktop settings"
Start-Job -FilePath (Join-Path -path $SetupPath -childpath Set-SandboxDesktop.ps1)

#set DNS
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses 1.1.1.1

#wait for everything to finish
log "Waiting for background jobs to complete"
Get-Job | Wait-Job

Start-Sleep -Seconds 30
log "Starting Windows Terminal"
Start-Process wt.exe "-M new-tab -p PowerShell -d C:\ ; split-pane -V -p Windows PowerShell ; focus-tab --target 0"

log "Sending toast notification in the Windows Sandbox"
&(Join-Path -path $SetupPath -childpath sandbox-toast.ps1)

#set the flag on the host
Get-Date | Out-File -FilePath c:\scripts\sandbox.flag

log "Ending configuration script"

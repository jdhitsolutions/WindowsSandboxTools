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

log "Installing PowerPoint Mobile"
Start-Job { Add-AppxPackage -Path c:\presentations\PowerpointViewer.appx }
#set DNS
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses 1.1.1.1

log "Hiding tray icons"
Start-Job {
    if (-not (Test-Path -path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer)) {
        [void](New-Item -path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer)
    }
    Set-ItemProperty -path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ -Name HideClock -Value 1
    Set-ItemProperty -path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ -Name HideSCAVolume -Value 1
    Set-ItemProperty -path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ -Name HideSCANetwork -Value 1
    if (-not (Test-Path -path hkcu:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced)) {
        [void](New-Item -path hkcu:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced)
    }

    Set-ItemProperty -path hkcu:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideIcons -Value 1
}
#wait for everything to finish
log "Waiting for background jobs to complete"
Get-Job | Wait-Job

#reset Explorer so that registry changes take
log "Resetting Explorer"
Get-Process Explorer | Stop-Process

log "Sending toast notification in the Windows Sandbox"
&(Join-Path -path $SetupPath -childpath sandbox-toast.ps1)

#set the flag on the host
Get-Date | Out-File -FilePath c:\scripts\sandbox.flag

log "Ending configuration script"

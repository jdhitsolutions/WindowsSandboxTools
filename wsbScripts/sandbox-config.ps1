#this script runs IN the Windows Sandbox

$SetupPath = "C:\scripts\wsbScripts"

#create a log file of the configuration process.
Function log {
    Param(
        [string]$msg,
        [string]$log = "C:\work\wsblog.txt"
    )

    "[{0}] {1}" -f (Get-Date), $msg | Out-File -FilePath $log -Encoding ascii -Append
}

#add the logging function to each background job
$init = {
    Function log {
        Param(
            [string]$msg,
            [string]$log = "C:\work\wsblog.txt"
        )

        "[{0}] {1}" -f (Get-Date), $msg | Out-File -FilePath $log -Encoding ascii -Append
    }
}

#using splatting to pass this parameter. Using PSDefaultParameterValues failed for some reason.
$jobparams = @{InitializationScript = $init}

$begin = Get-Date
log "Starting Windows Sandbox configuration $($myinvocation.MyCommand)"
log "Enabling PowerShell remoting"
Enable-PSRemoting -Force -SkipNetworkProfileCheck

log "Install package provider"
Install-PackageProvider -name nuget -force -forcebootstrap -scope allusers

log "Updating package management"
Install-Module PackageManagement, PowerShellGet,PSReadline -Force

#run updates and installs in the background
log "Setting DNS server to 1.1.1.1"
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses 1.1.1.1

log "Installing VSCode"
Start-Job -name VSCode -FilePath (Join-Path -Path $SetupPath -ChildPath Install-vscodesandbox.ps1) @jobparams

log "Updating Windows PowerShell Help"
#Start-Job -ScriptBlock { powershell -command { Update-Help -Force } ; log "Help updated" } @jobparams
Start-Job -name "Help-Update" -ScriptBlock { Update-Help -Force  ; log "Help updated" } @jobparams

log "Installing default modules: PSScriptTools, PSTeachingTools, BurntToast"
Start-Job -name "Module-Install" -ScriptBlock {
    Install-Module PSScriptTools, PSTeachingTools, BurntToast -Force ;
     log "PowerShell modules installed" } @jobparams

log "Installing PSReleaseTools and PowerShell 7 + Preview"
Start-Job -name "PS7-Install" -ScriptBlock {
    Install-Module PSReleaseTools -Force
    $msi = (Get-Item C:\shared\Powershell-7.1*.msi).fullname
    Start-Process -FilePath $msi -ArgumentList "/quiet REGISTER_MANIFEST=1 ADD_PATH=1 ENABLE_PSREMOTING=1 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1"
    $msi = (Get-Item C:\shared\Powershell-7*preview*.msi).fullname
    Start-Process -FilePath $msi -ArgumentList "/quiet REGISTER_MANIFEST=1 ADD_PATH=1 ENABLE_PSREMOTING=1 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1"

    #Install-PowerShell -Mode quiet -EnableRemoting -EnableContextMenu
    #Install-PSPreview -Mode quiet -EnableRemoting -EnableContextMenu
    #update help
    C:\Program` Files\PowerShell\7\pwsh.exe -command { Update-Help -Force }
    log "PowerShell 7 installed"
} @jobparams

log "Installing Windows Terminal"
Start-Job -name "Windows-Terminal" -ScriptBlock { Install-Module WTToolbox -Force ; Install-WTRelease ; log "Windows Terminal installed" } @jobparams

log "Configuring desktop settings"
Start-Job -Name "Desktop-Config" -FilePath (Join-Path -Path $SetupPath -ChildPath Set-SandboxDesktop.ps1) @jobparams

log "Installing Winget and additional apps"
Start-Job -name "Winget" -ScriptBlock {
    C:\scripts\Download-Winget.ps1 -install -AddPrequisites
    winget install git
    winget install microsoft.edge
    log "Winget and other apps installed"
} @jobparams

#wait for everything to finish
log "Waiting for background jobs to complete"
Get-Job | Wait-Job

#add jobs to the log
Get-Job | Foreach-object {
    $msg = "Job: {0} {1} [{2}]" -f $_.name, $_.state, ( New-TimeSpan -Start $_.PSBeginTime -End $_.PSEndTime)
    log $msg
}

log "Starting Windows Terminal"
Start-Process wt.exe "-M new-tab -p PowerShell -d C:\ ; split-pane -V -p Windows PowerShell ; focus-tab --target 0"

Log "Setting the host notification flag"
Get-Date | Out-File -FilePath c:\scripts\sandbox.flag

log "Sending toast notification in the Windows Sandbox"
&(Join-Path -Path $SetupPath -ChildPath sandbox-toast.ps1)

log "Ending configuration script $($myinvocation.MyCommand)"
log "Configuration completed in $(New-Timespan -start $begin)"
log "Have a nice day!"

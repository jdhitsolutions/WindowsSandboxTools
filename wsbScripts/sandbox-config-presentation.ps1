#this script runs IN the Windows Sandbox

$SetupPath = "C:\scripts\wsbScripts"

#create a log file of the configuration process.
Function log {
    Param(
        [String]$msg,
        [String]$log = "C:\work\wsblog.txt"
    )

    "[{0}] {1}" -f (Get-Date), $msg | Out-File -FilePath $log -Encoding ascii -Append
}

log "Updating package management"
Install-Module PackageManagement, PowerShellGet -Force

#run updates and installs in the background
log "Updating Windows PowerShell Help"
Start-Job { PowerShell -command { Update-Help -Force } }
log "Installing default modules: PSScriptTools, PSTypeExtensionTools,PSTeachingTools, BurntToast"
Start-Job { Install-Module PSScriptTools, PSTeachingTools, PSTypeExtensionTools, BurntToast -Force }
log "Installing PSReleaseTools and PowerShell 7 + Preview"
Start-Job {
    Install-Module PSReleaseTools -Force
    Install-PowerShell -Mode quiet -EnableRemoting -EnableContextMenu
    Install-PSPreview -Mode quiet -EnableRemoting -EnableContextMenu
    #update help
    C:\Program` Files\PowerShell\7\pwsh.exe -command { Update-Help -Force }
}
log "Installing Windows Terminal"
start-job {
    Install-module WTToolbox -force
    Install-WindowsTerminal
}

log "Installing PowerPoint Mobile"
Start-Job { Add-AppxPackage -Path c:\shared\PowerpointViewer.appx }

log "Installing Applications"
Start-Job {
    Function log {
        Param(
            [String]$msg,
            [String]$log = "C:\work\wsblog.txt"
        )

        "[{0}] {1}" -f (Get-Date), $msg | Out-File -FilePath $log -Encoding ascii -Append
    }
    Add-AppxPackage -Path c:\pluralsight\PowerpointViewer.appx
    C:\scripts\Download-Winget.ps1 -install -AddPrequisites
    if (Get-Command winget) {
        log "Installing Git"
        winget install git.git
        log "Installing VSCode"
        winget install Microsoft.visualStudioCode
        log "Configuring VSCode"
        &'C:\Users\WDAGUtilityAccount\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd' --install-extension ms-vscode.PowerShell
        &'C:\Users\WDAGUtilityAccount\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd' --install-extension CoenraadS.bracket-pair-colorizer-2
        &'C:\Users\WDAGUtilityAccount\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd' --install-extension TylerLeonhardt.vscode-inline-values-PowerShell
        Copy-item -path C:\shared\vscode-settings.json -Destination "c:\Users\WDAGUtilityAccount\AppData\Roaming\Code\User\settings.json"

        Log "Installing Edge"
        winget install microsoft.edge
        # 8/16/2021 Winget is failing to install this
        #Log "Installing Windows Terminal"
        3winget install Microsoft.WindowsTerminal
    }

    else {
        log "winget not found"
    }
}

#set DNS
log "Configure DNS to 1.1.1.1"
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses 1.1.1.1

#these settings appear to be different for Windows 11
log "Hiding tray icons"
Start-Job {
    if (-not (Test-Path -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer)) {
        [void](New-Item -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer)
    }
    Set-ItemProperty -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ -Name HideClock -Value 1
    Set-ItemProperty -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ -Name HideSCAVolume -Value 1
    Set-ItemProperty -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ -Name HideSCANetwork -Value 1
    if (-not (Test-Path -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced)) {
        [void](New-Item -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced)
    }

    Set-ItemProperty -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideIcons -Value 1
}
#wait for everything to finish
log "Waiting for background jobs to complete"
Get-Job | Wait-Job

#reset Explorer so that registry changes take
log "Resetting Explorer"
Get-Process Explorer | Stop-Process

log "Sending toast notification in the Windows Sandbox"
&(Join-Path -Path $SetupPath -ChildPath sandbox-toast.ps1)

#set the flag on the host
Get-Date | Out-File -FilePath c:\scripts\sandbox.flag

log "Ending configuration script"

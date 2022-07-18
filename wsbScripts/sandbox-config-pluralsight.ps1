#this script runs IN the Windows Sandbox under Windows PowerShell 5.1

$SetupPath = "C:\scripts\wsbScripts"

#create a log file of the configuration process.
Function log {
    Param(
        [string]$msg,
        [string]$log = "C:\work\wsblog.txt"
    )

    "[{0}] {1}" -f (Get-Date), $msg | Out-File -FilePath $log -Encoding ascii -Append
}

log "Install package provider"
Install-PackageProvider -name nuget -force -forcebootstrap -scope allusers

log "Updating package management"
Install-Module PackageManagement, PowerShellGet, PSReadline, WTToolbox -Force

#run updates and installs in the background
log "Updating Windows PowerShell Help"
Start-Job { powershell -command { Update-Help -Force } }
log "Installing default modules: PSScriptTools, PSTeachingTools, BurntToast"
Start-Job { Install-Module PSScriptTools, PSTeachingTools, BurntToast -Force }
log "Installing PSReleaseTools and PowerShell 7.x"
Start-Job {
    $msi = (Get-Item C:\shared\Powershell-7.1*msi).fullname
    Start-Process -FilePath $msi -ArgumentList "/quiet REGISTER_MANIFEST=1 ADD_PATH=1 ENABLE_PSREMOTING=1 ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1" -Wait

    #update help
    C:\Program` Files\PowerShell\7\pwsh.exe -command { Update-Help -Force }

    #copy profile
    $myprofile = "C:\Pluralsight\Pluralsight-psprofile.ps1"

    Copy-Item -Path $myprofile -Destination 'C:\Program Files\PowerShell\7\profile.ps1'
    Install-Module Microsoft.PowerShell.ConsoleGuiTools -force
}

log "Installing Applications"
Start-Job {
    Add-AppxPackage -Path c:\pluralsight\PowerpointViewer.appx
    C:\scripts\Download-Winget.ps1 -install -AddPrequisites
    # winget install git
    winget install microsoft.edge
    winget install Microsoft.WindowsTerminal
}

#set DNS
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses 1.1.1.1

<# log "Hiding tray icons"
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


} #>

log "Installing fonts"
Start-Job {
    $FontSource = "C:\Pluralsight\1 INSTALL FONTS"
    $shell = New-Object -ComObject Shell.Application -ErrorAction stop
    $fontFolder = $shell.Namespace(0x14)
    #find already installed font files from the registry
    $installedfiles = @()
    $regLocation = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

    if (Test-Path $reglocation) {
        $props = (Get-Item $regLocation).property
        if ($props) {
            $installedfiles += Get-ItemPropertyValue -Path $reglocation -Name $props
        }
    }
    else {
        Write-Warning "$reglocation not found. This is OK."
    }
    $reguser = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
    $props = (Get-Item $reguser).property
    if ($props) {
        Write-Host "Adding $($props.count) user installed fonts"
        $installedfiles += Get-ItemPropertyValue -Path $reguser -Name $props | Split-Path -Leaf
    }

    Get-ChildItem -Path $Fontsource -File | ForEach-Object {
        #Write-Host "Testing $($_.name)"
        if ($installedFiles -notcontains $_.name) {
            Write-Host "installing $($_.name) from $($_.fullname)" -ForegroundColor green
            $fontFolder.copyHere($_.fullname)
        }
        else {
            Write-Host "$($_.name) already installed" -ForegroundColor yellow
        }
    } #foreach
}

log "Configure desktop"
Start-Job {
    Write-Host "Copy a default profile for all users all hosts" -ForegroundColor cyan
    $myprofile = "C:\Pluralsight\Pluralsight-psprofile.ps1"
    #Windows PowerShell
    Copy-Item -Path $myprofile -Destination 'C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1'

    Write-Host "Configure Trusted Hosts" -ForegroundColor Cyan
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value "prospero" -Force -PassThru

    Write-Host "add cmdkey entry for host" -ForegroundColor Cyan
    cmdkey /add:Prospero /user:Jeff /pass:Beth2005

    #run configure desktop script
    C:\scripts\wsbscripts\Set-SandboxDesktop.ps1

    #hide the search box
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchBoxTaskbarMode -Value 0 -Type DWord -Force

    Write-Host "auto-hide the Taskbar" -ForegroundColor cyan
    . C:\scripts\TaskbarTools.ps1
    #this will force a restart of Explorer
    Enable-AutoHideTaskBar

}

#wait for everything to finish
log "Waiting for background jobs to complete"
Get-Job | Out-String | Out-File "C:\work\wsblog.txt" -Encoding ascii -Append
Get-Job | Wait-Job
#Get-Job | Receive-Job | Out-File "C:\work\wsblog.txt" -Encoding ascii -append

#reset Explorer so that registry changes take
#log "Resetting Explorer"
#Get-Process Explorer | Stop-Process

log "Start Windows Terminal"
wt.exe
Start-Sleep -Seconds 5
log "Copy Windows Terminal settings"
Copy-Item -Path c:\shared\settings.json -Destination C:\Users\WDAGUtilityAccount\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Force

#log "Set the flag on the host"
#Get-Date | Out-File -FilePath c:\scripts\sandbox.flag

log "Ending configuration script"
log "Sending toast notification in the Windows Sandbox"
&(Join-Path -Path $SetupPath -ChildPath sandbox-toast.ps1)

#Start-Sleep -Seconds 30
#Remove-Item c:\scripts\sandbox.flag

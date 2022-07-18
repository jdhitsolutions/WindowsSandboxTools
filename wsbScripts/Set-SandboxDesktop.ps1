# Set-SandboxDesktop.ps1
# my Pluralsight-related configuration

function Update-Wallpaper {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(Position = 0, HelpMessage = "The path to the wallpaper file.")]
        [alias("wallpaper")]
        [ValidateScript( { Test-Path $_ })]
        [string]$Path = $(Get-ItemPropertyValue -Path 'hkcu:\Control Panel\Desktop\' -Name Wallpaper)
    )

    Add-Type @"

    using System;
    using System.Runtime.InteropServices;
    using Microsoft.Win32;

    namespace Wallpaper
    {
        public class UpdateImage
        {
            [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]

            private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);

            public static void Refresh(string path)
            {
                SystemParametersInfo( 20, 0, path, 0x01 | 0x02 );
            }
        }
    }
"@

    if ($PSCmdlet.shouldProcess($path)) {
        [Wallpaper.UpdateImage]::Refresh($Path)
    }
}

Function Restart-Explorer {
    <#
    .Synopsis
    Restart the Windows Explorer process.
    #>
    [cmdletbinding(SupportsShouldProcess)]
    [Outputtype("None")]
    Param()

    Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Stopping Explorer.exe process"
    Get-Process -Name Explorer | Stop-Process -Force
    #give the process time to start
    Start-Sleep -Seconds 2
    Try {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Verifying Explorer restarted"
        $p = Get-Process -Name Explorer -ErrorAction stop
    }
    Catch {
        Write-Warning "Manually restarting Explorer"
        Try {
            Start-Process explorer.exe
        }
        Catch {
            #this should never be called
            Throw $_
        }
    }
    Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
}

#configure the taskbar and hide icons

<# if (-not (Test-Path -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer)) {
    [void](New-Item -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer)
} #>

Set-ItemProperty -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ -Name HideClock -Value 1 -force
Set-ItemProperty -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ -Name HideSCAVolume -Value 1 -force
Set-ItemProperty -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ -Name HideSCANetwork -Value 1 -force

#hide news feed
Set-ItemProperty -path hkcu:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds\ -name ShellFeedsTaskBarViewMode -Value 2 -force

<# if (-not (Test-Path -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced)) {
    [void](New-Item -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced)
} #>

Set-ItemProperty -Path hkcu:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideIcons -Value 1 -force

Write-Host "set wallpaper" -ForegroundColor cyan
#configure wallpaper
Set-ItemProperty -Path 'hkcu:\Control Panel\Desktop\' -Name Wallpaper -Value C:\Pluralsight\Wallpaper\Pluralsight_Wallpaper_Fall_2015_Black.jpg
Set-ItemProperty -Path 'hkcu:\Control Panel\Desktop\' -Name WallpaperOriginX -Value 0
Set-ItemProperty -Path 'hkcu:\Control Panel\Desktop\' -Name WallpaperOriginY -Value 0
Set-ItemProperty -Path 'hkcu:\Control Panel\Desktop\' -Name WallpaperStyle -Value 10

Update-WallPaper

<#
This doesn't work completely in newer versions of Windows 10
Invoke-Command {c:\windows\System32\RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1,True}
#this is a bit harsh but it works
#>

Restart-Explorer

if (Test-Path function:\log) {
    log "Desktop configuration complete"
}

Function Set-WindowSize {
    #from https://gist.github.com/coldnebo/1148334

    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = "What is the MainWindowHandle?",
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullorEmpty()]
        [Alias("handle")]
        [System.IntPtr]$MainWindowHandle = (Get-Process -id $pid).MainWindowHandle,
        [Alias("x")]
        [int]$Width = 1280,
        [Alias("y")]
        [int]$Height = 720
    )

    Begin {
        Write-Verbose "Starting $($MyInvocation.Mycommand)"
        Write-Verbose "Adding type code"

        Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
  [DllImport("user32.dll")]
  [return: MarshalAs(UnmanagedType.Bool)]
  public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

  [DllImport("user32.dll")]
  [return: MarshalAs(UnmanagedType.Bool)]
  public static extern bool GetClientRect(IntPtr hWnd, out RECT lpRect);

  [DllImport("user32.dll")]
  [return: MarshalAs(UnmanagedType.Bool)]
  public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
}

public struct RECT
{
  public int Left;        // x position of upper-left corner
  public int Top;         // y position of upper-left corner
  public int Right;       // x position of lower-right corner
  public int Bottom;      // y position of lower-right corner
}

"@

    } #begin

    Process {

        #verify handle and get process
        Write-Verbose "Verifying process with MainWindowHandle of $MainWindowhandle"

        $proc = (Get-Process).where( { $_.mainwindowhandle -eq $MainWindowhandle })

        if (-NOT $proc.mainwindowhandle) {
            Write-Warning "Failed to find a process with a MainWindowHandle of $MainWndowhandle"
            #bail out
            Return
        }

        Write-Verbose "Creating rectangle objects"
        $rcWindow = New-Object RECT
        $rcClient = New-Object RECT

        Write-Verbose "Getting current settings"
        [Win32]::GetWindowRect($MainWindowHandle, [ref]$rcWindow) | Out-Null
        [Win32]::GetClientRect($MainWindowHandle, [ref]$rcClient) | Out-Null
        Write-Verbose "rcWindow = $($rcWindow | Out-String)"
        Write-Verbose "rcClient = $($rcClient | Out-String)"
        Write-Verbose "Setting new coordinates"

        #WhatIf
        if ($PSCmdlet.ShouldProcess("$($proc.MainWindowTitle) to $width by $height")) {
            $dx = ($rcWindow.Right - $rcWindow.Left) - $rcClient.Right
            $dy = ($rcWindow.Bottom - $rcWindow.Top) - $rcClient.Bottom

            Write-Verbose "Moving window using dx = $dx and dy = $dy"

            [void]([Win32]::MoveWindow($MainWindowHandle, 0, 0, $width + $dx, $height + $dy, $true ))

        } #close Whatif

    } #process

    End {
        Write-Verbose "Ending $($MyInvocation.Mycommand)"
    } #end

} #end Set-WindowSize function

function Set-WindowState {
    <#
	.LINK
	https://gist.github.com/Nora-Ballard/11240204
	#>

    [CmdletBinding(DefaultParameterSetName = 'InputObject')]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [Object[]] $InputObject,

        [Parameter(Position = 1)]
        [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE',
            'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED',
            'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
        [string] $State = 'SHOW'
    )

    Begin {
        $WindowStates = @{
            'FORCEMINIMIZE'   = 11
            'HIDE'            = 0
            'MAXIMIZE'        = 3
            'MINIMIZE'        = 6
            'RESTORE'         = 9
            'SHOW'            = 5
            'SHOWDEFAULT'     = 10
            'SHOWMAXIMIZED'   = 3
            'SHOWMINIMIZED'   = 2
            'SHOWMINNOACTIVE'	= 7
            'SHOWNA'          = 8
            'SHOWNOACTIVATE'  = 4
            'SHOWNORMAL'      = 1
        }

        $Win32ShowWindowAsync = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
'@ -Name "Win32ShowWindowAsync" -Namespace Win32Functions -PassThru

        if (!$global:MainWindowHandles) {
            $global:MainWindowHandles = @{ }
        }
    }

    Process {
        foreach ($process in $InputObject) {
            if ($process.MainWindowHandle -eq 0) {
                if ($global:MainWindowHandles.ContainsKey($process.Id)) {
                    $handle = $global:MainWindowHandles[$process.Id]
                }
                else {
                    Write-Error "Main Window handle is '0'"
                    continue
                }
            }
            else {
                $handle = $process.MainWindowHandle
                $global:MainWindowHandles[$process.Id] = $handle
            }

            $Win32ShowWindowAsync::ShowWindowAsync($handle, $WindowStates[$State]) | Out-Null
            Write-Verbose ("Set Window State '{1} on '{0}'" -f $MainWindowHandle, $State)
        }
    }
}

Function Register-Watcher {

    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(HelpMessage = "Enter the full filename and path to the flag file. The file will be created in the sandbox in a shared folder.")]
        [ValidateNotNullorEmpty()]
        [string]$Flag = "C:\scripts\sandbox.flag",
        [Parameter(HelpMessage = "Enter the title for the toast notification.")]
        [string]$Title = "Windows Sandbox",
        [Parameter(HelpMessage = "Enter the path to an image file for the toast notification.")]
        [ValidateScript( { Test-Path $_ })]
        [string]$Logo = "$PSScriptRoot\..\images\sandbox.jpg",
        [Parameter(HelpMessage = "Specify the sound to play for the toast notification.")]
        [ValidateSet('Default', 'IM', 'Mail', 'Reminder', 'SMS', 'Alarm', 'Alarm2', 'Alarm3',
            'Alarm4', 'Alarm5', 'Alarm6', 'Alarm7', 'Alarm8', 'Alarm9', 'Alarm10', 'Call',
            'Call2', 'Call3', 'Call4', 'Call5', 'Call6', 'Call7', 'Call8', 'Call9', 'Call10',
            'None'
        )]
        [string]$Sound = "Call10"
    )

    if (Test-Path -Path $flag) {
        Remove-Item $flag
    }

    $rFlag = $flag.replace("\", "\\")
    $query = "Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'CIM_DATAFILE' AND TargetInstance.Name='$rflag'"

    #define the action scriptblock text
    $sb = @"
`$params = @{
    Text    = "Your Windows Sandbox is ready."
    Header  = `$(New-BTHeader -Id 1 -Title "$Title")
    Applogo = "$logo"
    Sound   = "$sound"
}

New-BurntToastNotification @params
Start-Sleep -Seconds 10
Try {
    Unregister-Event WatchWSB -erroraction stop
}
Catch {
    #don't do anything
}
if (Test-Path $flag) {
    Remove-Item $Flag
}
"@

    $action = [scriptblock]::Create($sb)

    if ($pscmdlet.ShouldProcess($query, "Register Event")) {
        Register-CimIndicationEvent -query $query -source "WatchWSB" -Action $action
    } #WhatIf
}
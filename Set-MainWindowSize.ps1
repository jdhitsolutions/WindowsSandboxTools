#requires -version 3.0

#from https://gist.github.com/coldnebo/1148334

# look at https://devblogs.microsoft.com/scripting/weekend-scripter-manage-window-placement-by-using-pinvoke/

Function Set-WindowSize {
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

    $proc = (Get-Process).where({$_.mainwindowhandle -eq $MainWindowhandle})

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
    write-Verbose "rcClient = $($rcClient | Out-String)"
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
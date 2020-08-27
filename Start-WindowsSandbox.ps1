#dot source a function that will resize the window
# this function doesn't work the way I expect it to.
# . C:\scripts\Set-MainWindowSize.ps1

Function Start-WindowsSandbox {
    [cmdletbinding(DefaultParameterSetName = "config")]
    [alias("wsb")]
    Param(
        [Parameter(Position = 0,ParameterSetName = "config",HelpMessage="Specify the path to a wsb file.")]
        [ValidateScript({Test-Path $_})]
        [string]$Configuration = "c:\scripts\WindowsSandboxTools\WinSandBx.wsb",
        [Parameter(ParameterSetName = "normal",HelpMessage="Start with no customizations.")]
        [switch]$NoSetup
        #Setting the desktop resolution doesn't work as expected
        #[Parameter(HelpMessage = "Specify desktop resolutions as an array like 1280,1024. The default is 1280,720.")]
        #[int[]]$WindowSize = @(1280,720)
    )

    Write-Verbose "Starting $($myinvocation.mycommand)"

    if ($NoSetup) {
        Write-Verbose "Launching default WindowsSandbox.exe"
        c:\windows\system32\WindowsSandbox.exe
    }
    else {
        Write-Verbose "Launching WindowsSandbox using configuration file $Configuration"

        #create a file watcher if calling a configuration that uses it
        if ($Configuration -match "WinSandBx") {
            write-Verbose "Registering a temporary file system watcher"
            &$PSScriptroot\RegisterWatcher.ps1 | Out-Null
        }
        Invoke-Item $Configuration
    }

    #This code does not work as expected
    <#
    resize the sandbox window
    Start-Sleep -seconds 10
    Write-Verbose "Setting Windows Size to $($windowsize[0]) by $($windowsize[1])"
    Get-Process -name WindowsSandboxClient | Set-WindowSize -width $windowsize[0] -height $windowsize[1]
    #>
    Write-Verbose "Ending $($myinvocation.mycommand)"
}


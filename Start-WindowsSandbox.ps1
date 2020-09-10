Function Start-WindowsSandbox {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "config")]
    [alias("wsb")]
    Param(
        [Parameter(Position = 0, ParameterSetName = "config", HelpMessage = "Specify the path to a wsb file.")]
        [ValidateScript( { Test-Path $_ })]
        #this is my default configuration
        [string]$Configuration = "c:\scripts\WindowsSandboxTools\WinSandBx.wsb",
        [Parameter(ParameterSetName = "normal", HelpMessage = "Start with no customizations.")]
        [switch]$NoSetup,
        [Parameter(HelpMessage = "Specify desktop resolutions as an array like 1280,720. The default is 1920,1080.")]
        [int[]]$WindowSize = @(1920, 1080)
    )

    Write-Verbose "Starting $($myinvocation.mycommand)"

    #dot source functions to change the window state and size
    . C:\scripts\WindowsSandboxTools\Set-WindowState.ps1
    . C:\scripts\WindowsSandboxTools\Set-MainWindowSize.ps1

    if ($NoSetup) {
        Write-Verbose "Launching default WindowsSandbox.exe"
        if ($PSCmdlet.shouldProcess("default configuration", "Launch Windows Sandbox")) {
            c:\windows\system32\WindowsSandbox.exe
        }
    }
    else {
        Write-Verbose "Launching WindowsSandbox using configuration file $Configuration"

        #create a file watcher if calling a configuration that uses it
        if ($Configuration -match "WinSandBx|presentation") {
            Write-Verbose "Registering a temporary file system watcher"
            #you can specify parameters for RegisterWatcher.ps1 or modify the
            #file to use your own defaults.
            &$PSScriptroot\RegisterWatcher.ps1 | Out-Null
        }

        if ($PSCmdlet.shouldProcess($Configuration, "Launch Windows Sandbox")) {
            Start-Process -filepath $Configuration
        }
    }

    #WindowsSandbox.exe launches a child process, WindowsSandboxClient.
    #That is the process that needs to be minimized
    if ($pscmdlet.shouldProcess("WindowsSandboxClient", "Waiting for process")) {

        Write-Verbose "Waiting for child process WindowsSandboxClient"
        do {
            Start-Sleep -Seconds 1
        } Until (Get-Process -Name WindowsSandboxClient -ErrorAction SilentlyContinue)

        #give the process a chance to complete
        Start-Sleep -Seconds 5
    }

    Write-Verbose "Setting Window size to $($WindowSize -join 'x')"
    if ($pscmdlet.shouldProcess("WindowsSandboxClient", "Modifying Window size and state")) {
        $clientProc = Get-Process -Name WindowsSandboxClient
        #values to pass to the function are a percentage of the desired size
        [int]$width = $WindowSize[0]*.6667
        [int]$Height = $WindowSize[1]*.6667

        Set-WindowSize -handle $clientproc.MainWindowHandle -width $width -height $height

        #Configure the Windows Sandbox to run minimized (Issue #2)
        Write-Verbose "Minimizing child process WindowsSandboxClient"
        $clientProc | Set-WindowState -State minimize
    }
    Write-Verbose "Ending $($myinvocation.mycommand). Any script configurations will continue in the Windows Sandbox."
}


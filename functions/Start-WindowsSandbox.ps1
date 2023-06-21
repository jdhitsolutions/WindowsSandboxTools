Function Start-WindowsSandbox {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "config")]
    [alias("wsb")]
    [OutputType("none")]

    Param(
        [Parameter(Position = 0, Mandatory, ParameterSetName = "config", HelpMessage = "Specify the path to a wsb file.")]
        [ValidateScript( { Test-Path $_ })]
        [ArgumentCompleter( { if (Test-Path $global:wsbConfigPath) { (Get-ChildItem $Global:wsbConfigPath).FullName } })]
        [String]$Configuration,

        [Parameter(ParameterSetName = "normal", HelpMessage = "Start with no customizations.")]
        [Switch]$NoSetup,

        [Parameter(HelpMessage = "Specify desktop resolutions as an array like 1280,720. The default is 1920,1080.")]
        [int[]]$WindowSize = @(1920, 1080)
    )

    Write-Verbose "[$((Get-Date).TimeOfDay)] Starting $($MyInvocation.MyCommand)"

    #test if Windows Sandbox is already running
    $test = Get-Process -ErrorAction SilentlyContinue -Name WindowsSandbox*
    if ($test) {
        Write-Warning "An instance of Windows Sandbox is already running."
        #bail out
        return
    }
    if ($NoSetup) {
        Write-Verbose "[$((Get-Date).TimeOfDay)] Launching default WindowsSandbox.exe"
        if ($PSCmdlet.ShouldProcess("default configuration", "Launch Windows Sandbox")) {
            Start-Process -FilePath $env:windir\system32\WindowsSandbox.exe
        }
    }
    else {
        Write-Verbose "[$((Get-Date).TimeOfDay)] Launching WindowsSandbox using configuration file $Configuration"

        #TODO - Parameterize this behavior
        #create a file watcher if calling a configuration that uses it
        if ($Configuration -match "WinSandBx|presentation") {
            Write-Verbose "[$((Get-Date).TimeOfDay)] Registering a temporary file system watcher"
            <#
            Some configurations will create "flag" file in a shared folder to indicate
             the setup and configuration is complete.

            RegisterWatcher is a private function in this module
            #>
            # TODO : pass arguments to RegisterWatcher from this function ?
            [void](Register-Watcher)
        }

        if ($PSCmdlet.ShouldProcess($Configuration, "Launch Windows Sandbox")) {
            Start-Process -FilePath $Configuration
        }
    }

    #WindowsSandbox.exe launches a child process, WindowsSandboxClient.
    #That is the process that needs to be minimized
    if ($PSCmdlet.ShouldProcess("WindowsSandboxClient", "Waiting for process")) {

        Write-Verbose "[$((Get-Date).TimeOfDay)] Waiting for child process WindowsSandboxClient"
        do {
            Start-Sleep -Seconds 1
        } Until (Get-Process -Name WindowsSandboxClient -ErrorAction SilentlyContinue)

        #give the process a chance to complete
        Start-Sleep -Seconds 5
    }

    Write-Verbose "[$((Get-Date).TimeOfDay)] Setting Window size to $($WindowSize -join 'x')"
    if ($PSCmdlet.ShouldProcess("WindowsSandboxClient", "Modifying Window size and state")) {
        $clientProc = Get-Process -Name WindowsSandboxClient
        #values to pass to the function are a percentage of the desired size
        #TODO: figure out scaling in display resolution set to scale
        [Int]$width = $WindowSize[0]  #* .6667
        [Int]$Height = $WindowSize[1] # * .6667
        Write-Verbose "[$((Get-Date).TimeOfDay)] Modifying handle $($clientproc.mainwindowhandle) with a width of $($WindowSize[0]) and height of $($WindowSize[1])"

        Set-WindowSize -handle $clientproc.MainWindowHandle -width $width -height $height

        #Configure the Windows Sandbox to run minimized (Issue #2)
        Write-Verbose "[$((Get-Date).TimeOfDay)] Minimizing child process WindowsSandboxClient"
        $clientProc | Set-WindowState -State minimize
    }

    if ($Configuration) {
        $wsb = Get-WsbConfiguration -Path $Configuration
        if ($wsb.LogonCommand) {
            Write-Verbose "[$((Get-Date).TimeOfDay)] Running logon command $($wsb.LogonCommand) in the Windows Sandbox."
        }

        if ($wsb.MappedFolder) {
            Write-Verbose "[$((Get-Date).TimeOfDay)] Mapping these folders"
            $wsb.MappedFolder | Out-String | Write-Verbose
        }
    }
    Write-Verbose "[$((Get-Date).TimeOfDay)] Ending $($MyInvocation.MyCommand)."

    Write-Host "[$((Get-Date).TimeOfDay)] Windows Sandbox has been launched. You may need to wait for any configurations to complete." -ForegroundColor green
}


Class wsbMetadata {
    [string]$Author = $env:USERNAME
    [string]$Name
    [string]$Description
    [datetime]$Updated

    wsbMetadata([string]$Name) {
        $this.Name = $Name
    }
    wsbMetadata([string]$Name, [string]$Description) {
        $this.Name = $Name
        $this.Description = $Description
    }
}

Class wsbMappedFolder {
    [string]$HostFolder
    [string]$SandboxFolder
    [bool]$ReadOnly = $True

    wsbMappedFolder([string]$HostFolder, [string]$SandboxFolder, [bool]$ReadOnly) {
        $this.HostFolder = $HostFolder
        $this.SandboxFolder = $SandboxFolder
        $this.ReadOnly = $ReadOnly
    }
}

Class wsbConfiguration {
    [ValidateSet("Default", "Enable", "Disable")]
    [string]$vGPU = "Default"
    [string]$MemoryInMB = 4096
    [ValidateSet("Default", "Enable", "Disable")]
    [string]$AudioInput = "Default"
    [ValidateSet("Default", "Enable", "Disable")]
    [string]$VideoInput = "Default"
    [ValidateSet("Default", "Disable")]
    [string]$ClipboardRedirection = "Default"
    [ValidateSet("Default", "Enable", "Disable")]
    [string]$PrinterRedirection = "Default"
    [ValidateSet("Default", "Disable")]
    [string]$Networking = "Default"
    [ValidateSet("Default", "Enable", "Disable")]
    [string]$ProtectedClient = "Default"
    [string]$LogonCommand
    [wsbMappedFolder[]]$MappedFolder
    [wsbMetadata]$Metadata
}

Function New-WsbMappedFolder {
    [cmdletbinding()]
    [OutputType("wsbMappedFolder")]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipelineByPropertyName, HelpMessage = "Specify the path to the local folder you want to map.")]
        [ValidateScript( { Test-Path $_ })]
        [string]$HostFolder,

        [Parameter(Position = 1, Mandatory, ValueFromPipelineByPropertyName, HelpMessage = "Specify the mapped folder for the Windows Sandbox. It must start with C:\")]
        [ValidateNotNullorEmpty()]
        [ValidatePattern('^C:\\')]
        [string]$SandboxFolder,

        [Parameter(ValueFromPipelineByPropertyName, HelpMessage = "Specify if you want the mapping to be Read-Only.")]
        [ValidateSet("True", "False")]
        [string]$ReadOnly = "True"
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN] Starting $($myinvocation.mycommand)"
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing"

        #turn the strings into booleans
        if ($ReadOnly -eq 'true') {
            $read = $True
        }
        else {
            $read = $False
        }
        [wsbMappedFolder]::New($HostFolder, $SandboxFolder, $Read)
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end
}

Function New-WsbConfiguration {
    [cmdletbinding(DefaultParameterSetName = "name")]
    [outputType("wsbConfiguration")]
    Param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Enable", "Disable")]
        [string]$vGPU = "Default",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateScript( { $_ -ge 1024 })]
        [string]$MemoryInMB = 4096,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Enable", "Disable")]
        [string]$AudioInput = "Default",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Enable", "Disable")]
        [string]$VideoInput = "Default",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Disable")]
        [string]$ClipboardRedirection = "Default",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Enable", "Disable")]
        [string]$PrinterRedirection = "Default",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Disable")]
        [string]$Networking = "Default",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Enable", "Disable")]
        [string]$ProtectedClient = "Default",

        [Parameter(ValueFromPipelineByPropertyName, HelpMessage = "The path and file are relative to the Windows Sandbox")]
        [object]$LogonCommand,

        [Parameter(ValueFromPipelineByPropertyName)]
        [wsbMappedFolder[]]$MappedFolder,

        [Parameter(ParameterSetName = "meta")]
        [wsbMetadata]$Metadata,

        [parameter(Mandatory, ParameterSetName = "name", HelpMessage = "Give the configuration a name")]
        [string]$Name,

        [parameter(ParameterSetName = "name", HelpMessage = "Provide a description")]
        [string]$Description,

        [parameter(ParameterSetName = "name", HelpMessage = "Who is the author?")]
        [string]$Author = $env:USERNAME
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN] Starting $($myinvocation.mycommand)"
        $new = [wsbConfiguration]::new()

    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating a configuration"
        Write-Verbose ($psboundparameters | Out-String)

        if ($logonCommand -is [string]) {
            $cmd = $LogonCommand
        }
        elseif ($logonCommand.Command) {
            $cmd = $logonCommand.Command
        }
        else {
            Write-Warning "No value detected for LogonCommand. This may be intentional on your part."
            $cmd = $Null
        }

        $new.vGPU = $vGPU
        $new.MemoryInMB = $MemoryInMB
        $new.AudioInput = $AudioInput
        $new.VideoInput = $VideoInput
        $new.ClipboardRedirection = $ClipboardRedirection
        $new.PrinterRedirection = $PrinterRedirection
        $new.Networking = $Networking
        $new.ProtectedClient = $ProtectedClient
        $new.LogonCommand = $cmd
        $new.MappedFolder = $MappedFolder

        if (-Not $metadata) {
            $metadata = [wsbMetadata]::new($Name, $Description)
            $metadata.author = $author
            $metadata.updated = Get-Date
        }

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Setting metadata"
        $new.metadata = $metadata
        $new

    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end
}
Function Get-WsbConfiguration {
    [cmdletbinding()]
    [outputType("wsbConfiguration")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the path to the .wsb file.")]
        [ValidatePattern('\.wsb$')]
        [ValidateScript({Test-Path $_ })]
        [ArgumentCompleter({if (Test-Path $global:wsbConfigPath) {(Get-Childitem $Global:wsbConfigPath).fullname}})]
        [string]$Path,
        [Parameter(HelpMessage = "Only display metadata information.")]
        [switch]$MetadataOnly
    )

    $cPath = Convert-Path $Path
    Write-Verbose "Getting configuration from $cPath"

    [xml]$wsb = Get-Content -path $cPath

    Write-Verbose "Building property list"
    $properties = [System.Collections.Generic.List[object]]::new()
    $properties.AddRange($wsb.configuration.psadapted.psobject.properties.name)
    if ($properties.Contains("LogonCommand")) {
        [void]($properties.Remove("LogonCommand"))
        $properties.Add(@{Name = "LogonCommand"; Expression = { $_.logonCommand.Command } })
    }
    if ($properties.Contains("MappedFolders")) {
        [void]($properties.Remove("MappedFolders"))
        $properties.Add(@{Name = "MappedFolder"; Expression = { $_.MappedFolders.MappedFolder | New-WsbMappedFolder } })
    }

    Write-Verbose "Get metadata information"
    if ($wsb.configuration.metadata) {
        Write-Verbose "Existing metadata found"
        $meta = [wsbMetadata]::new($wsb.Configuration.metadata.Name, $wsb.configuration.metadata.Description)
        $meta.updated = $wsb.configuration.metadata.updated
        $meta.author = $wsb.configuration.metadata.author
    }
    else {
        Write-Verbose "Defining new metadata"
        $meta = [wsbMetadata]::new($cPath)
        $meta.updated = Get-Date
    }

    if ($MetadataOnly) {
        Write-Verbose "Displaying metadata only"
        $meta
    }
    else {
        Write-Verbose "Sending configuration to New-WsbConfiguration"
        $wsb.configuration | Select-Object -property $properties | New-WsbConfiguration -metadata $meta
        Write-Verbose "Ending $($myinvocation.mycommand)"
    }
}

function Export-WsbConfiguration {
    [cmdletbinding(SupportsShouldProcess)]
    [outputType([System.io.fileInfo])]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = "Specify a wsbConfiguration object.")]
        [ValidateNotNullorEmpty()]
        [wsbConfiguration]$Configuration,
        [Parameter(Mandatory, HelpMessage = "Specify the path and filename. It must end in .wsb")]
        [ValidatePattern("\.wsb$")]
        #verify the parent path exists
        [ValidateScript( { Test-Path $(Split-Path $_ -parent) })]
        [string]$Path,
        [Parameter(HelpMessage = "Don't overwrite an existing file")]
        [switch]$NoClobber
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN] Starting $($myinvocation.mycommand)"
        <#
        Convert the path to a valid FileSystem path. Normally, I would use Convert-Path
        but it will fail if the file doesn't exist. Instead, I'll split the path, convert
        the root and recreate it.
        #>
        $parent = Convert-Path (Split-Path -path $Path -Parent)
        $leaf = Split-Path -Path $Path -leaf
        $cPath = Join-Path -Path $parent -ChildPath $leaf
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating an XML document"
        $xml = New-Object System.Xml.XmlDocument
        $config = $xml.CreateElement("element", "Configuration", "")

        #add my custom metadata
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Inserting metadata"
        $meta = $xml.CreateElement("element", "Metadata", "")
        $metaprops = "Name", "Author", "Description", "Updated"
        foreach ($prop in $metaprops) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] ..$prop = $($configuration.Metadata.$prop)"
            $item = $xml.CreateElement($prop)
            $item.set_innertext($configuration.Metadata.$prop)
            [void]$meta.AppendChild($item)
        }
        [void]$config.AppendChild($meta)

        #add primary properties
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding primary data"
        $mainprops = "vGPU", "MemoryInMB", "AudioInput", "VideoInput", "ClipboardRedirection", "PrinterRedirection",
        "Networking", "ProtectedClient"
        foreach ($prop in $mainprops) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] ..$prop = $($configuration.$prop)"
            $item = $xml.CreateElement($prop)
            $item.set_innertext($configuration.$prop)
            [void]$config.AppendChild($item)
        }
        if ($Configuration.LogonCommand) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding a logon command"
            $logon = $xml.CreateElement("element", "LogonCommand", "")
            $cmd = $xml.CreateElement("Command")
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] ..$($configuration.LogonCommand)"
            $cmd.set_innerText($configuration.LogonCommand)
            [void]$logon.AppendChild($cmd)
            [void]$config.AppendChild($logon)
        }
        if ($Configuration.MappedFolder) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding mapped folders"
            $mapped = $xml.CreateElement("element", "MappedFolders", "")
            foreach ($f in $Configuration.MappedFolder) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($f.HostFolder) -> $($f.SandboxFolder) [RO:$($f.ReadOnly)]"
                $mf = $xml.CreateElement("element", "MappedFolder", "")
                "HostFolder", "SandboxFolder", "ReadOnly" |
                    ForEach-Object {
                        $item = $xml.CreateElement($_)
                        $item.set_innertext($f.$_)
                        [void]$mf.AppendChild($item)
                    }
                [void]$mapped.appendChild($mf)
            }
            [void]$config.AppendChild($mapped)
        }

        [void]$xml.AppendChild($config)

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Exporting configuration to $cPath"
        if ($PSCmdlet.ShouldProcess($cpath)) {
            if ((Test-Path -path $cPath) -AND $NoClobber) {
                Write-Warning "A file exists at $cPath and NoClobber was specified."
            }
            else {
                $xml.Save($cPath)
            }
        } #whatif

    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end
}

Function Start-WindowsSandbox {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "config")]
    [alias("wsb")]
    [OutputType("none")]

    Param(
        [Parameter(Position = 0, Mandatory,ParameterSetName = "config", HelpMessage = "Specify the path to a wsb file.")]
        [ValidateScript({ Test-Path $_ })]
        [ArgumentCompleter({if (Test-Path $global:wsbConfigPath) {(Get-Childitem $Global:wsbConfigPath).fullname}})]
        [string]$Configuration,

        [Parameter(ParameterSetName = "normal", HelpMessage = "Start with no customizations.")]
        [switch]$NoSetup,
        
        [Parameter(HelpMessage = "Specify desktop resolutions as an array like 1280,720. The default is 1920,1080.")]
        [int[]]$WindowSize = @(1920, 1080)
    )

    Write-Verbose "[$((Get-Date).TimeOfDay)] Starting $($myinvocation.mycommand)"

    #test if Windows Sandbox is already running
    $test = Get-Process -ErrorAction SilentlyContinue -Name WindowsSandbox*
    if ($test) {
        Write-Warning "An instance of Windows Sandbox is already running."
        #bail out
        return
    }
    if ($NoSetup) {
        Write-Verbose "[$((Get-Date).TimeOfDay)] Launching default WindowsSandbox.exe"
        if ($PSCmdlet.shouldProcess("default configuration", "Launch Windows Sandbox")) {
            Start-Process -filepath $env:windir\system32\WindowsSandbox.exe
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

        if ($PSCmdlet.shouldProcess($Configuration, "Launch Windows Sandbox")) {
            Start-Process -filepath $Configuration
        }
    }

    #WindowsSandbox.exe launches a child process, WindowsSandboxClient.
    #That is the process that needs to be minimized
    if ($pscmdlet.shouldProcess("WindowsSandboxClient", "Waiting for process")) {

        Write-Verbose "[$((Get-Date).TimeOfDay)] Waiting for child process WindowsSandboxClient"
        do {
            Start-Sleep -Seconds 1
        } Until (Get-Process -Name WindowsSandboxClient -ErrorAction SilentlyContinue)

        #give the process a chance to complete
        Start-Sleep -Seconds 5
    }

    Write-Verbose "[$((Get-Date).TimeOfDay)] Setting Window size to $($WindowSize -join 'x')"
    if ($pscmdlet.shouldProcess("WindowsSandboxClient", "Modifying Window size and state")) {
        $clientProc = Get-Process -Name WindowsSandboxClient
        #values to pass to the function are a percentage of the desired size
        [int]$width = $WindowSize[0] * .6667
        [int]$Height = $WindowSize[1] * .6667
        Write-Verbose "[$((Get-Date).TimeOfDay)] Modifying handle $($clientproc.mainwindowhandle) with a width of $($WindowSize[0]) and height of $($WindowSize[1])"

        Set-WindowSize -handle $clientproc.MainWindowHandle -width $width -height $height

        #Configure the Windows Sandbox to run minimized (Issue #2)
        Write-Verbose "[$((Get-Date).TimeOfDay)] Minimizing child process WindowsSandboxClient"
        $clientProc | Set-WindowState -State minimize
    }

    $wsb = Get-WsbConfiguration -Path $Configuration
    if ($wsb.LogonCommand) {
        Write-Verbose "[$((Get-Date).TimeOfDay)] Running logon command $($wsb.LogonCommand) in the Windows Sandbox."
    }

    if ($wsb.MappedFolder) {
        Write-Verbose "[$((Get-Date).TimeOfDay)] Mapping these folders"
        $wsb.MappedFolder | Out-String | Write-Verbose
    }
    Write-Verbose "[$((Get-Date).TimeOfDay)] Ending $($myinvocation.mycommand)."

    Write-Host "[$((Get-Date).TimeOfDay)] Windows Sandbox has been launched. You may need to wait for any configurations to complete." -foregroundColor green
}

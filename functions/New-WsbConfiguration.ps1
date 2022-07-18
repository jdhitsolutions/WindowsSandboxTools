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

Function New-WsbConfiguration {
    [CmdletBinding(DefaultParameterSetName = "name")]
    [OutputType("wsbConfiguration")]
    Param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Enable", "Disable")]
        [String]$vGPU = "Default",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateScript( { $_ -ge 1024 })]
        [String]$MemoryInMB = 4096,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Enable", "Disable")]
        [String]$AudioInput = "Default",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Enable", "Disable")]
        [String]$VideoInput = "Default",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Disable")]
        [String]$ClipboardRedirection = "Default",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Enable", "Disable")]
        [String]$PrinterRedirection = "Default",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Disable")]
        [String]$Networking = "Default",

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Default", "Enable", "Disable")]
        [String]$ProtectedClient = "Default",

        [Parameter(ValueFromPipelineByPropertyName, HelpMessage = "The path and file are relative to the Windows Sandbox")]
        [object]$LogonCommand,

        [Parameter(ValueFromPipelineByPropertyName)]
        [wsbMappedFolder[]]$MappedFolder,

        [Parameter(ParameterSetName = "meta")]
        [wsbMetadata]$Metadata,

        [parameter(Mandatory, ParameterSetName = "name", HelpMessage = "Give the configuration a name")]
        [String]$Name,

        [parameter(ParameterSetName = "name", HelpMessage = "Provide a description")]
        [String]$Description,

        [parameter(ParameterSetName = "name", HelpMessage = "Who is the author?")]
        [String]$Author = $env:USERNAME
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN] Starting $($MyInvocation.MyCommand)"
        $new = [wsbConfiguration]::new()
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Creating a configuration"
        Write-Verbose ($PSBoundParameters | Out-String)

        if ($logonCommand -is [String]) {
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

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Setting metadata"
        $new.metadata = $metadata
        $new

    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}

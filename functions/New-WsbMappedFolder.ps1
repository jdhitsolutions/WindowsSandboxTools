Function New-WsbMappedFolder {
    [CmdletBinding()]
    [OutputType("wsbMappedFolder")]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipelineByPropertyName, HelpMessage = "Specify the path to the local folder you want to map.")]
        [ValidateScript( { Test-Path $_ })]
        [String]$HostFolder,

        [Parameter(Position = 1, Mandatory, ValueFromPipelineByPropertyName, HelpMessage = "Specify the mapped folder for the Windows Sandbox. It must start with C:\")]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^C:\\')]
        [String]$SandboxFolder,

        [Parameter(ValueFromPipelineByPropertyName, HelpMessage = "Specify if you want the mapping to be Read-Only.")]
        #[ValidateSet("True", "False")]
        [Switch]$ReadOnly
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN] Starting $($MyInvocation.MyCommand)"
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing"

        [wsbMappedFolder]::New($HostFolder, $SandboxFolder, $ReadOnly)
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}

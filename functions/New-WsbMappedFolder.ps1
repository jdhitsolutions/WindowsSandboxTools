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
        #[ValidateSet("True", "False")]
        [switch]$ReadOnly
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN] Starting $($myinvocation.mycommand)"
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing"

        [wsbMappedFolder]::New($HostFolder, $SandboxFolder, $ReadOnly)
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end
}

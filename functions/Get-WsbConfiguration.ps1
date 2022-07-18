Function Get-WsbConfiguration {
    [cmdletbinding()]
    [outputType("wsbConfiguration")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Specify the path to the .wsb file.")]
        [ValidatePattern('\.wsb$')]
        [ValidateScript( { Test-Path $_ })]
        [ArgumentCompleter( { if (Test-Path $global:wsbConfigPath) { (Get-ChildItem $Global:wsbConfigPath).fullname } })]
        [string]$Path,
        [Parameter(HelpMessage = "Only display metadata information.")]
        [switch]$MetadataOnly
    )

    $cPath = Convert-Path $Path
    Write-Verbose "Getting configuration from $cPath"

    [xml]$wsb = Get-Content -Path $cPath

    Write-Verbose "Building property list"
    $properties = [System.Collections.Generic.List[object]]::new()
    $properties.AddRange($wsb.configuration.psadapted.psobject.properties.name)
    if ($properties.Contains("LogonCommand")) {
        [void]($properties.Remove("LogonCommand"))
        $properties.Add(@{Name = "LogonCommand"; Expression = { $wsb.configuration.logonCommand.Command } })
    }
    if ($properties.Contains("MappedFolders")) {
        [void]($properties.Remove("MappedFolders"))
        $properties.Add(@{Name = "MappedFolder"; Expression = {
            $wsb.Configuration.MappedFolders.MappedFolder |
            Select-Object *folder,@{Name="ReadOnly";Expression = { if ($_.ReadOnly -eq 'True') { $True } else {$False}}} |
            New-WsbMappedFolder | New-WsbMappedFolder } })
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
        $wsb.configuration | Select-Object -Property $properties | New-WsbConfiguration -metadata $meta
        Write-Verbose "Ending $($myinvocation.mycommand)"
    }
}

function Export-WsbConfiguration {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([System.io.fileInfo])]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, HelpMessage = "Specify a wsbConfiguration object.")]
        [ValidateNotNullOrEmpty()]
        [wsbConfiguration]$Configuration,
        [Parameter(Mandatory, HelpMessage = "Specify the path and filename. It must end in .wsb")]
        [ValidatePattern("\.wsb$")]
        #verify the parent path exists
        [ValidateScript( { Test-Path $(Split-Path $_ -Parent) })]
        [String]$Path,
        [Parameter(HelpMessage = "Don't overwrite an existing file")]
        [Switch]$NoClobber
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN] Starting $($MyInvocation.MyCommand)"
        <#
        Convert the path to a valid FileSystem path. Normally, I would use Convert-Path
        but it will fail if the file doesn't exist. Instead, I'll split the path, convert
        the root and recreate it.
        #>
        $parent = Convert-Path (Split-Path -Path $Path -Parent)
        $leaf = Split-Path -Path $Path -Leaf
        $cPath = Join-Path -Path $parent -ChildPath $leaf
    } #begin
    Process {
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Creating an XML document"
        $xml = New-Object System.Xml.XmlDocument
        $config = $xml.CreateElement("element", "Configuration", "")

        #add my custom metadata
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Inserting metadata"
        $meta = $xml.CreateElement("element", "Metadata", "")
        $metaprops = "Name", "Author", "Description", "Updated"
        foreach ($prop in $metaprops) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] ..$prop = $($configuration.Metadata.$prop)"
            $item = $xml.CreateElement($prop)
            $item.set_innertext($configuration.Metadata.$prop)
            [void]$meta.AppendChild($item)
        }
        [void]$config.AppendChild($meta)

        #add primary properties
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Adding primary data"
        $mainprops = "vGPU", "MemoryInMB", "AudioInput", "VideoInput", "ClipboardRedirection", "PrinterRedirection",
        "Networking", "ProtectedClient"
        foreach ($prop in $mainprops) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] ..$prop = $($configuration.$prop)"
            $item = $xml.CreateElement($prop)
            $item.set_innertext($configuration.$prop)
            [void]$config.AppendChild($item)
        }
        if ($Configuration.LogonCommand) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Adding a logon command"
            $logon = $xml.CreateElement("element", "LogonCommand", "")
            $cmd = $xml.CreateElement("Command")
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] ..$($configuration.LogonCommand)"
            $cmd.set_innerText($configuration.LogonCommand)
            [void]$logon.AppendChild($cmd)
            [void]$config.AppendChild($logon)
        }
        if ($Configuration.MappedFolder) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Adding mapped folders"
            $mapped = $xml.CreateElement("element", "MappedFolders", "")
            foreach ($f in $Configuration.MappedFolder) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($f.HostFolder) -> $($f.SandboxFolder) [RO:$($f.ReadOnly)]"
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

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Exporting configuration to $cPath"
        if ($PSCmdlet.ShouldProcess($cpath)) {
            if ((Test-Path -Path $cPath) -AND $NoClobber) {
                Write-Warning "A file exists at $cPath and NoClobber was specified."
            }
            else {
                $xml.Save($cPath)
            }
        } #WhatIf

    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}

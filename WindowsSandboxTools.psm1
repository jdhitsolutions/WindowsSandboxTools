#turn on verbose output
if ($MyInvocation.line -match "Verbose") {
    $VerbosePreference = "Continue"
}

#region class definitions

Write-Verbose "Defining classes"
#these need to be in the module file
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
#endregion

#dot source the module functions
Get-ChildItem -Path $psscriptroot\functions\*.ps1 |
ForEach-Object {
    Write-Verbose "Dot source $($_.fullname)"
    . $_.fullname
}

#only define variables if they don't already exist.
Write-Verbose "Configuring global variables"
#define a global variable for the configuration directory
Try {
    [void](Get-Variable -Name wsbConfigPath -Scope global -ErrorAction Stop)
}
Catch {
    $global:wsbConfigPath = "$psscriptroot\wsbconfig"
}

#define a global variable for configuration scripts
Try {
    [void](Get-Variable -Name wsbScripts -Scope global -ErrorAction Stop)
}
Catch {
    $global:wsbScripts = "$psscriptroot\wsbScripts"
}

$msg = @"
Using these global variables

    Windows Sandbox Tools
    ---------------------

    `$wsbConfigPath = $wsbConfigPath
    `$wsbScripts    = $wsbScripts

    You may want to change these values.

"@

Write-Verbose $msg

#Turn off module scoped Verbose output
if ($VerbosePreference = "Continue") {
    $VerbosePreference = "SilentyContinue"
}
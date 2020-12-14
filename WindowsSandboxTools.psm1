
#dot source the module functions
Get-ChildItem -path $psscriptroot\functions\*.ps1 |
Foreach-Object { . $_.fullname }

#only define variables if they don't already exist.

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

Windows Sandbox Tools
---------------------

`$wsbConfigPath = $wsbConfigPath
`$wsbScripts    = $wsbScripts

You may want to change these values.
"@

Write-Host $msg -ForegroundColor Green
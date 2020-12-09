
#dot source the module functions
Get-ChildItem -path $psscriptroot\functions\*.ps1 |
Foreach-Object { . $_.fullname }

#define a global variable for the configuration directory
$global:wsbConfigPath = "$psscriptroot\wsbconfig"

#define a global variable for configuration scripts
$global:wsbScripts = "$psscriptroot\wsbScripts"

$msg = @"
Windows Sandbox Tools Imported
------------------------------

`$wsbConfigPath = $wsbConfigPath
`$wsbScripts    = $wsbScripts

You may want to change these values.
"@

Write-Host $msg -ForegroundColor Green

#dot source the module functions
Get-ChildItem -path $psscriptroot\functions\*.ps1 |
Foreach-Object { . $_.fullname }
REM sandbox-setup.cmd
REM This code runs in the context of the Windows Sandbox
REM Create my standard Work folder
mkdir c:\work

REM set execution policy first so that a setup script can be run
REM and then run the configuration script
powershell.exe -command "&{Set-ExecutionPolicy RemoteSigned -force ; Enable-PSRemoting -force -SkipNetworkProfileCheck; Install-PackageProvider -name nuget -force -forcebootstrap -scope allusers;c:\scripts\WindowsSandboxTools\sandbox-config-presentation.ps1}"


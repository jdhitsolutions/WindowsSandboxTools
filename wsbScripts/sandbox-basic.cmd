REM sandbox-basic.cmd
REM This code runs in the context of the Windows Sandbox

REM set execution policy first so that a setup script can be run
powershell.exe -command "&{Set-ExecutionPolicy RemoteSigned -force}"

REM Add an all users all hosts profile script
powershell.exe -command "&{'[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12' | out-file C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1 }"

REM Now run the true configuration script
REM C:\Scripts has been mapped to the local C:\Scripts in the WSB file
powershell.exe -file c:\scripts\wsbScripts\basic.ps1
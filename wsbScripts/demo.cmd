REM demo.cmd
REM This code runs in the context of the Windows Sandbox

REM set execution policy first so that a setup script can be run
powershell.exe -command "&{Set-ExecutionPolicy RemoteSigned -force}"

REM Now run the true configuration script
REM C:\Scripts has been mapped to the local C:\Scripts in the WSB file
powershell.exe -file c:\scripts\demo-config.ps1
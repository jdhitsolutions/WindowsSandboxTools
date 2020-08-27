 return "$([char]0x1b)[1;91mThis won't run in the Windows Sandbox$([char]0x1b)[0m"

 . C:\scripts\winget-tools.ps1
 Install-Winget
 winget install git.git

 #
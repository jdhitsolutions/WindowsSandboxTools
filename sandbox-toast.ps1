#sandbox-toast.ps1
$params = @{
    Text = "Windows Sandbox configuration is complete. See C:\Work\wsblog.txt."
    Header = $(New-BTHeader -Id 1 -Title "Jeff's Sandbox")
    Applogo = "c:\scripts\gazoo.bmp"
}

New-BurntToastNotification @params
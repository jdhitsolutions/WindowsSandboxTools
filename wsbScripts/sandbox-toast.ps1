#sandbox-toast.ps1

#Send a toast notification in the sandbox when the configuration is complete.
#This will require the BurntToast module to be installed in the Windows Sandbox.

$params = @{
    Text = "Windows Sandbox configuration is complete. See C:\Work\wsblog.txt."
    Header = $(New-BTHeader -Id 1 -Title "Windows Sandbox")
    Applogo = "c:\scripts\gazoo.bmp"
    Silent = $False
}

New-BurntToastNotification @params
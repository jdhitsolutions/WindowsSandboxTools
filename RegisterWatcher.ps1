#requires -module BurntToast

if (Test-Path c:\scripts\sandbox.flag) {
    Remove-Item c:\scripts\sandbox.flag
}

$query = "Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'CIM_DATAFILE' AND TargetInstance.Name='c:\\scripts\\sandbox.flag'"
Register-CimIndicationEvent -query $query -source "WatchWSB" -Action {
    $params = @{
        Text    = "Your Windows Sandbox is ready."
        Header  = $(New-BTHeader -Id 1 -Title "Jeff's Sandbox")
        Applogo = "C:\scripts\WindowsSandboxTools\images\sandbox.jpg"
    }

    New-BurntToastNotification @params
    Start-Sleep -Seconds 10
    Unregister-Event WatchWSB
    Remove-item C:\scripts\sandbox.flag

}


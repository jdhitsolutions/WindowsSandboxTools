#requires -module BurntToast

[cmdletbinding(SupportsShouldProcess)]
Param()

if (Test-Path c:\scripts\sandbox.flag) {
    Remove-Item c:\scripts\sandbox.flag
}

$query = "Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'CIM_DATAFILE' AND TargetInstance.Name='c:\\scripts\\sandbox.flag'"

if ($pscmdlet.ShouldProcess($query, "Register Event")) {
    Register-CimIndicationEvent -query $query -source "WatchWSB" -Action {
        $params = @{
            Text    = "Your Windows Sandbox is ready."
            Header  = $(New-BTHeader -Id 1 -Title "Jeff's Sandbox")
            Applogo = "C:\scripts\WindowsSandboxTools\images\sandbox.jpg"
            Sound   = "Call10"
        }

        New-BurntToastNotification @params
        Start-Sleep -Seconds 10
        Unregister-Event WatchWSB
        Remove-Item C:\scripts\sandbox.flag

    }
} #WhatIf

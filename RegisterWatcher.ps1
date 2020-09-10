#requires -version 5.1
#requires -module BurntToast

[cmdletbinding(SupportsShouldProcess)]
Param(
    [Parameter(HelpMessage = "Enter the full filename and path to the flag file.")]
    [ValidateNotNullorEmpty()]
    [string]$Flag = "c:\scripts\sandbox.flag",
    [Parameter(HelpMessage = "Enter the title for the toast notification.")]
    [string]$Title = "Jeff's Sandbox",
    [Parameter(HelpMessage = "Enter the path to an image file for the toast notification.")]
    [ValidateScript({Test-Path $_})]
    [string]$Logo = "C:\scripts\WindowsSandboxTools\images\sandbox.jpg",
    [Parameter(HelpMessage = "Specify the sound to play for the toast notification.")]
     [ValidateSet('Default','IM','Mail','Reminder','SMS','Alarm','Alarm2','Alarm3',
         'Alarm4','Alarm5','Alarm6','Alarm7','Alarm8','Alarm9','Alarm10','Call',
         'Call2','Call3','Call4','Call5','Call6','Call7','Call8','Call9','Call10',
         'None'
      )]
    [string]$Sound = "Call10"
)

if (Test-Path $flag) {
    Remove-Item $flag
}

$rFlag = $flag.replace("\","\\")
$query = "Select * from __InstanceCreationEvent Within 10 where TargetInstance ISA 'CIM_DATAFILE' AND TargetInstance.Name='$rflag'"

#define the action scriptblock text
$sb = @"
`$params = @{
    Text    = "Your Windows Sandbox is ready."
    Header  = `$(New-BTHeader -Id 1 -Title "$Title")
    Applogo = "$logo"
    Sound   = "$sound"
}

New-BurntToastNotification @params
Start-Sleep -Seconds 10
Try {
    Unregister-Event WatchWSB -erroraction stop
}
Catch {
    #don't do anything
}
if (Test-Path $flag) {
    Remove-Item $Flag
}
"@

$action = [scriptblock]::Create($sb)

if ($pscmdlet.ShouldProcess($query, "Register Event")) {
    Register-CimIndicationEvent -query $query -source "WatchWSB" -Action $action
} #WhatIf

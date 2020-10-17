# Change Log for Windows SandBox Tools

## _placeholder_

+ Code cleanup for the sake of clarity.
+ Migrated commands to a module, `WindowsSandboxTools`.
+ Made `Configuration` parameter mandatory in `Start-WindowsSandbox`.
+ Fixed default logo path in `RegisterWatcher`.
+ Added timestamp to verbose messages in `Start-WindowsSandbox`.

## September 10, 2020

+ Changed default screen size in `Start-WindowsSandbox` to 1920x1080.
+ Created commands, `Get-WsbConfiguration`, `New-WsbConfiguration`, `New-WsbMappedFolder`, and `Export-WsbConfiguration` for creating and managing `wsb` files. The enhanced files can include metadata information. These functions are defined in a module file, `wsbFunctions.psm1`.
+ Created `wsbConfiguration.format.ps1xml` to display the `wsbConfiguration` object as a formatted list by default.
+ Fixed `Start-Process` parameter bug in `Start-WindowsSandbox`.
+ Modified `RegisterWatcher.ps1` to let the user define the flag file. The default is `C:\scripts\sandbox.flag`.
+ Modified `RegisterWatcher.ps1` to let the user define settings for the toast notifications. Defaults are mine.
+ Updated `Start-WindowsSandbox` to better handle `-Whatif` support.
+ Updated `README.md`

## August 31, 2020

+ Added code to minimize Windows Sandbox window when running a configuration. (Issue #2)
+ Minor tweaks to the WSB configuration files.
+ Added `-WhatIf` support to `Start-WindowsSandbox` and `RegisterWatcher.ps1`.
+ Added `Set-WindowState` function.
+ Modified `Sandbox-toast.ps1` to make the toast announcement silent.
+ Added Sound to local toast notification.
+ Added code to adjust the window size. This the closest I can get to setting a desktop resolution. (Issue #1)
+ Added presentation configurations and setup scripts.

## August 27, 2020

+ initial commit
+ Added `README.md`
+ Updated scripts to reflect the new path.
+ Added a file system watcher to send a toast notification when my configuration is complete.

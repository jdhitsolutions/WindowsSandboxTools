# Change Log for Windows SandBox Tools

## August 31, 2020

+ Added code to minimize Windows Sandbox window when running a configuration. (Issue #2)
+ Minor tweaks to the WSB configuration files.
+ Added `-WhatIf` support to `Start-WindowsSandbox` and `RegisterWatcher.ps1`.
+ Added `Set-WindowState` function.
+ Modified `Sandbox-toast.ps1` to make the toast announcement silent.
+ Added Sound to local toast notification.
+ Added code to adjust the window size. This the closest I can get to setting a desktop resolution. (Issue #1)
+ Added presentation configurations and setup scripts.
+ Added `sandbox-winget` to download the latest build from GitHub with an option to install it. (Issue #3)

## August 27, 2020

+ initial commit
+ Added `README.md`
+ Updated scripts to reflect the new path
+ Added a file system watcher to send a toast notification when my configuration is complete.

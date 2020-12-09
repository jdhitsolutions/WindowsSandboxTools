# wsbScripts

The files in this folder can be called from the WSB files. These files are offered as samples of what you might do. This location is referenced by default with the `wsbScripts` variable when you import the module. It is recommended that you create a location outside of this module and copy any of these files to that location. In your PowerShell profile, you can import the module and then update the global variable.

```powershell
Import-Module WindowsSandboxTools
$global:wsbScripts = "d:\scripts\wsb\code"
```

Most of these scripts are intended to be run *IN* the Windows Sandbox, so any paths must be relative to the sandbox.

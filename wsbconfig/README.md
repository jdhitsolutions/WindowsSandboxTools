# wsbConfig

The files in the folder are sample and reference WSB files. This location is referenced by default with the `wsbConfigPath` variable when you import the module. It is recommended that you create a location outside of this module and copy any of these files to that location. In your PowerShell profile, you can import the module and then update the global variable.

```powershell
Import-Module WindowsSandboxTools
$global:wsbConfigPath = "d:\wsb\configs
```

You can create new configurations with `New-WsbConfiguration` and then save them to a file with `Export-WsbConfiguration`. File references in the file must use FileSystem paths.

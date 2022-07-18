---
external help file: WindowsSandboxTools-help.xml
Module Name: WindowsSandboxTools
online version:
schema: 2.0.0
---

# Get-WsbConfiguration

## SYNOPSIS

Get a Windows Sandbox configuratoin.

## SYNTAX

```yaml
Get-WsbConfiguration [-Path] <String> [-MetadataOnly] [<CommonParameters>]
```

## DESCRIPTION

This command will give you information about a sandbox configuration.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-WsbConfiguration C:\Scripts\WindowsSandboxTools\wsbConfig\dev.wsb

   Name: C:\scripts\wsbconfig\dev.wsb

vGPU                 : Enable
MemoryInMB           : 8192
AudioInput           : Disable
VideoInput           : Default
ClipboardRedirection : Default
PrinterRedirection   : Default
Networking           : Default
ProtectedClient      : Disable
LogonCommand         : C:\scripts\wsbScripts\sandbox-setup.cmd
MappedFolders        : C:\scripts -> C:\scripts [RO:False]
                       C:\Pluralsight -> C:\Pluralsight [RO:True]
```

### Example 2

```powershell
PS C:\> Get-WsbConfiguration C:\Scripts\WindowsSandboxTools\wsbConfig\dev.wsb -MetadataOnly

Author Name                         Description     Updated
------ ----                         -----------     -------
Jeff   C:\scripts\wsbconfig\dev.wsb A test wsb file 12/10/2020 8:50:03 AM
```

## PARAMETERS

### -MetadataOnly

Only display metadata information.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Specify the path to the .wsb file. The command will autocomplete to the $wsbConfigPath variable.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### wsbConfiguration

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-WsbConfiguration](New-WsbConfiguration.md)

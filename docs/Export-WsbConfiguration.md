---
external help file: WindowsSandboxTools-help.xml
Module Name: WindowsSandboxTools
online version:
schema: 2.0.0
---

# Export-WsbConfiguration

## SYNOPSIS

Export a WSB configuration to an XML file.

## SYNTAX

```yaml
Export-WsbConfiguration [-Configuration] <wsbConfiguration> -Path <String> [-NoClobber] [-WhatIf] [-Confirm][<CommonParameters>]
```

## DESCRIPTION

This command will take an existing Windows Sandbox Configuration object and export it to an XML file.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-WsbConfiguration -Name demo -LogonCommand C:\scripts\wsbscripts\sandbox-basic.cmd -MemoryInMB (4096*2) -MappedFolder (New-WsbMappedFolder -HostFolder c:\scratch -SandboxFolder c:\junk) -Description "My test WSB configuration" | Export-WsbConfiguration -Path c:\scratch\scratch.wsb
```

## PARAMETERS

### -Configuration

Specify a wsbConfiguration object.

```yaml
Type: wsbConfiguration
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoClobber

Don't overwrite an existing file.

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

Specify the path and filename.
It must end in .wsb

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### wsbConfiguration

## OUTPUTS

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-WsbConfiguration](New-WsbConfiguration.md)

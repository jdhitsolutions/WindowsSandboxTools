---
external help file: WindowsSandboxTools-help.xml
Module Name: WindowsSandboxTools
online version: https://bit.ly/42Wde4i
schema: 2.0.0
---

# Start-WindowsSandbox

## SYNOPSIS

Start a Windows sandbox configuration.

## SYNTAX

### config (Default)

```yaml
Start-WindowsSandbox [-Configuration] <String> [-WindowSize <Int32[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### normal

```yaml
Start-WindowsSandbox [-NoSetup] [-WindowSize <Int32[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command, or its alias wsb, to launch Windows Sandbox. You can specify a configuration or use -NoSetup to run the default sandbox.

## EXAMPLES

### Example 1

```powershell
PS C:\> Start-WindowsSandbox -noSetup -windowsize 1024,768
```

This will launch the default Windows sandobx and attempt to configure the screen resolution to 1024x768.

### Example 2

```powershell
PS C:\> Start-WindowsSandbox $wsbconfigPath\presentation.wsb
```

## PARAMETERS

### -Configuration

Specify the path to a wsb file. The command will autocomplete using the $wsbConfigPath variable.

```yaml
Type: String
Parameter Sets: config
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
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

### -NoSetup

Start with no customizations.

```yaml
Type: SwitchParameter
Parameter Sets: normal
Aliases:

Required: False
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

### -WindowSize

Specify desktop resolutions as an array like 1280,720.
The default is 1920,1080. This feature may not be 100% correct and should be considered an experimental feature.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1920,1080
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### none

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-WsbConfiguration](Get-WsbConfiguration.md)

---
external help file: WindowsSandboxTools-help.xml
Module Name: WindowsSandboxTools
online version: https://bit.ly/3PkPqUH
schema: 2.0.0
---

# New-WsbMappedFolder

## SYNOPSIS

Create a mapped folder object.

## SYNTAX

```yaml
New-WsbMappedFolder [-HostFolder] <String> [-SandboxFolder] <String> [-ReadOnly] [<CommonParameters>]
```

## DESCRIPTION

You this folder to create a new mapped folder object. You can use this when creating a new Windows sandbox configuration. The sandbox will only have a C: drive.

## EXAMPLES

### Example 1

```powershell
PS C:\> $map = New-WsbMappedFolder -HostFolder c:\work -SandboxFolder c:\work
PS C:\> New-WsbConfiguration -Name work -MappedFolder $map -Description "Work sandbox"
```

Create a shared folder with write access and then use that object in a new configuration.

## PARAMETERS

### -HostFolder

Specify the path to the local folder you want to map. This folder must already exist.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReadOnly

Specify if you want the mapping to be Read-Only.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SandboxFolder

Specify the mapped folder for the Windows Sandbox.
It must start with C:\

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### wsbMappedFolder

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-WsbConfiguration](New-WsbConfiguration.md)

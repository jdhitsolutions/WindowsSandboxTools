---
external help file: WindowsSandboxTools-help.xml
Module Name: WindowsSandboxTools
online version:
schema: 2.0.0
---

# New-WsbConfiguration

## SYNOPSIS

Create a new Windows Sandbox configuration.

## SYNTAX

### name (Default)

```yaml
New-WsbConfiguration [-vGPU <String>] [-MemoryInMB <String>] [-AudioInput <String>] [-VideoInput <String>] [-ClipboardRedirection <String>] [-PrinterRedirection <String>] [-Networking <String>] [-ProtectedClient <String>] [-LogonCommand <Object>] [-MappedFolder <wsbMappedFolder[]>] -Name <String> [-Description <String>] [-Author <String>] [<CommonParameters>]
```

### meta

```yaml
New-WsbConfiguration [-vGPU <String>] [-MemoryInMB <String>] [-AudioInput <String>] [-VideoInput <String>] [-ClipboardRedirection <String>] [-PrinterRedirection <String>] [-Networking <String>] [-ProtectedClient <String>] [-LogonCommand <Object>] [-MappedFolder <wsbMappedFolder[]>]
 [-Metadata <wsbMetadata>] [<CommonParameters>]
```

## DESCRIPTION

This command will create a new Wsbconfiguration object. Use Export-Wsbconfiguration to save it to disk.

## EXAMPLES

### Example 1

```powershell
PS C:\> $new = New-WsbConfiguration  -Name demo -LogonCommand C:\scripts\wsbscripts\sandbox-basic.cmd -MemoryInMB (4096*2) -MappedFolder (New-WsbMappedFolder -HostFolder c:\scratch -SandboxFolder c:\junk) -description "My scratch configuration"
```

## PARAMETERS

### -AudioInput

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Enable, Disable

Required: False
Position: Named
Default value: Default
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Author

Who is the author?

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: False
Position: Named
Default value: current user
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClipboardRedirection

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Disable

Required: False
Position: Named
Default value: Default
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description

Provide a description for this configuration.

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogonCommand

The path and file are relative to the Windows Sandbox configuration.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -MappedFolder

Specify a mapped folder object.

```yaml
Type: wsbMappedFolder[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -MemoryInMB

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 4096
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Metadata

A set of metadata values. This will typically be configured by default.

```yaml
Type: wsbMetadata
Parameter Sets: meta
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Give the configuration a name

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Networking

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Disable

Required: False
Position: Named
Default value: Default
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PrinterRedirection

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Enable, Disable

Required: False
Position: Named
Default value: Default
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProtectedClient

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Enable, Disable

Required: False
Position: Named
Default value: Default
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VideoInput

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Enable, Disable

Required: False
Position: Named
Default value: Default
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -vGPU

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Enable, Disable

Required: False
Position: Named
Default value: Default
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.Object

### wsbMappedFolder[]

## OUTPUTS

### wsbConfiguration

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[New-WsbMappedFolder](New-WsbMappedFolder.md)

[Export-WsbConfiguration](Export-WsbConfiguration.md)
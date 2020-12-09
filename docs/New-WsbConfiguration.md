---
external help file: WindowsSandboxTools-help.xml
Module Name: WindowsSandboxTools
online version:
schema: 2.0.0
---

# New-WsbConfiguration

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### name (Default)
```
New-WsbConfiguration [-vGPU <String>] [-MemoryInMB <String>] [-AudioInput <String>] [-VideoInput <String>]
 [-ClipboardRedirection <String>] [-PrinterRedirection <String>] [-Networking <String>]
 [-ProtectedClient <String>] [-LogonCommand <Object>] [-MappedFolder <wsbMappedFolder[]>] -Name <String>
 [-Description <String>] [-Author <String>] [<CommonParameters>]
```

### meta
```
New-WsbConfiguration [-vGPU <String>] [-MemoryInMB <String>] [-AudioInput <String>] [-VideoInput <String>]
 [-ClipboardRedirection <String>] [-PrinterRedirection <String>] [-Networking <String>]
 [-ProtectedClient <String>] [-LogonCommand <Object>] [-MappedFolder <wsbMappedFolder[]>]
 [-Metadata <wsbMetadata>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AudioInput
{{ Fill AudioInput Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Enable, Disable

Required: False
Position: Named
Default value: None
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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClipboardRedirection
{{ Fill ClipboardRedirection Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Disable

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Description
Provide a description

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
The path and file are relative to the Windows Sandbox

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
{{ Fill MappedFolder Description }}

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
{{ Fill MemoryInMB Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Metadata
{{ Fill Metadata Description }}

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
{{ Fill Networking Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Disable

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PrinterRedirection
{{ Fill PrinterRedirection Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Enable, Disable

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ProtectedClient
{{ Fill ProtectedClient Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Enable, Disable

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -VideoInput
{{ Fill VideoInput Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Enable, Disable

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -vGPU
{{ Fill vGPU Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Default, Enable, Disable

Required: False
Position: Named
Default value: None
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

## RELATED LINKS

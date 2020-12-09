---
external help file: WindowsSandboxTools-help.xml
Module Name: WindowsSandboxTools
online version:
schema: 2.0.0
---

# New-WsbMappedFolder

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
New-WsbMappedFolder [-HostFolder] <String> [-SandboxFolder] <String> [-ReadOnly <String>] [<CommonParameters>]
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

### -HostFolder
Specify the path to the local folder you want to map.

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
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: True, False

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

## RELATED LINKS

# Windows Sandbox Tools

![sandbox](images/sandbox.jpg)

This repository is a collection of PowerShell tools and scripts that I use to run and configure the Windows Sandbox feature that is part of Windows 10 2004. Many of the commands in this repository were first demonstrated on my [blog](https://jdhitsolutions.com/blog/powershell/7621/doing-more-with-windows-sandbox/). I strongly recommend you read the blog post before trying any of the code. As I mention in the blog post, most of the code here will __reduce the security__ of the Windows Sandbox application. This is a trade-off I am willing to make for the sake of functionality that meets *my* requirements. You have to decide how much of the code you would like to use.

__*All code is offered as-is with no guarantees. Nothing in this repository should be considered production-ready or used in critical environments.*__

## Installing the Windows Sandbox

You need to have the 2004 version of Windows 10. I don't know off-hand if it is supported on Windows 10 Home. Otherwise, you should then be able to run these PowerShell commands:

```powershell
Get-WindowsOptionalFeature -online -FeatureName Containers-DisposableClientVM
Enable-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM
```

## The WindowsSandBoxTools Module

I have created a PowerShell module called `WindowsSandBoxTools` that packages up the core functionality.

### Start-WindowsSandbox

The `Start-WindowsSandbox` function is my primary tool. It has an alias of `wsb`. You can specify the path to the wsb file.

![Start-WindowsSandbox](images/start-windowssandbox.png)

If you use the `NoSetup` parameter, it will launch the default Windows Sandbox. In either usage, you can specify display dimensions for the sandbox. The `WindowSize` parameter expects an array of width and height, like 1024,768. My default is 1920,1080. You may have to drag the window slightly to force the sandbox to redraw the screen and remove the horizontal scrollbar. Setting the display is tricky and I don't know if what I am using will work for everyone so if you don't get the results you expect, post an issue.

### Get-WsbConfiguration

I have created a simple module called `wsbFunctions.psm1`. In this module are functions designed to make it easier to view a wsb configuration, create a new configuration, and export a configuration to a file. The functions use several PowerShell class definitions.

```text
PS C:\> Get-WsbConfiguration d:\wsb\simple.wsb
WARNING: No value detected for LogonCommand. This may be intentional on your part.


   Name: Simple

vGPU                 : Enable
MemoryInMB           : 8192
AudioInput           : Default
VideoInput           : Default
ClipboardRedirection : Default
PrinterRedirection   : Default
Networking           : Default
ProtectedClient      : Default
LogonCommand         :
MappedFolders        : C:\scripts -> C:\scripts [RO:False]
```

The command uses a custom format file to display the configuration. I have also found a way to insert metadata into the wsb file which (so far) doesn't  appear to interfere with the Windows Sandbox application.

```text
PS C:\> Get-WsbConfiguration d:\wsb\simple.wsb -MetadataOnly

Author     Name   Description                                       Updated
------     ----   -----------                                       -------
Jeff Hicks Simple a simple configuration with mapping to C:\Scripts 9/10/2020 4:47:10 AM
```

### New-WsbConfiguration

If you wanted, you could create a new configuration.

```powershell
$params = @{
 Networking = "Default"
 LogonCommand = "c:\data\demo.cmd"
 MemoryInMB = 2048
 PrinterRedirection = "Disable"
 MappedFolder = (New-WsbMappedFolder -HostFolder d:\data -SandboxFolder c:\data -ReadOnly True)
 Name = "MyDemo"
 Description = "A demo WSB configuration"
}
$new = New-WsbConfiguration  @params
```

The `LogonCommand` value is relative to the WindowsSandbox. This code will create a `wsbConfiguration` object.

```text

   Name: MyDemo

vGPU                 : Default
MemoryInMB           : 2048
AudioInput           : Default
VideoInput           : Default
ClipboardRedirection : Default
PrinterRedirection   : Disable
Networking           : Default
ProtectedClient      : Default
LogonCommand         : c:\data\demo.cmd
MappedFolders        : d:\data -> c:\data [RO:True]
```

You could modify this object as necessary.

```powershell
$new.vGPU = "Enable"
$new.Metadata.Updated = Get-Date
```

The last step is to export the configuration to a `wsb` file.

```powershell
$new | Export-WsbConfiguration -Path d:\wsb\demo.wsb
```

Which will create this file:

```xml
<Configuration>
  <Metadata>
    <Name>MyDemo</Name>
    <Author>Jeff</Author>
    <Description>A demo WSB configuration</Description>
    <Updated>09/10/2020 15:40:54</Updated>
  </Metadata>
  <vGPU>Enable</vGPU>
  <MemoryInMB>2048</MemoryInMB>
  <AudioInput>Default</AudioInput>
  <VideoInput>Default</VideoInput>
  <ClipboardRedirection>Default</ClipboardRedirection>
  <PrinterRedirection>Disable</PrinterRedirection>
  <Networking>Default</Networking>
  <ProtectedClient>Default</ProtectedClient>
  <LogonCommand>
    <Command>c:\data\demo.cmd</Command>
  </LogonCommand>
  <MappedFolders>
    <MappedFolder>
      <HostFolder>d:\data</HostFolder>
      <SandboxFolder>c:\data</SandboxFolder>
      <ReadOnly>True</ReadOnly>
    </MappedFolder>
  </MappedFolders>
</Configuration>
```

I can easily launch this configuration.

```powershell
Start-WindowsSandbox -Configuration D:\wsb\demo.wsb
```

### New-WsbMappedFolder

 TO-DO

### Export-WSBConfiguration

  TO-DO

## My Configuration Scripts

My default [configuration script](sandbox-config.ps1) takes about 4 minutes to complete. I use the [BurntToast](https://github.com/Windos/BurntToast) module to show a Windows Action Center notification when it is complete. This project is not a PowerShell module or set of files you can run as-is. You are welcome to clone, download or copy as needed.

## RoadMap

This is a list of items I'd like to address or handle more efficiently:

+ Look for a way to organize script components used for LogonCommand settings.
+ I need a better solution for organizing `wsb` files.
+ Use a default shared folder that can be a bit more generic.

Last updated *16 October, 2020*.

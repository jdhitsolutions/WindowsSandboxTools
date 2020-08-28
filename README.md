# Windows Sandbox Tools

![sandbox](images/sandbox.jpg)

This repository is a collection of PowerShell tools and scripts that I use to run and configure the Windows Sandbox feature that is part of Windows 10 2004. Many of the commands in this repository were first demonstrated on my [blog](https://jdhitsolutions.com/blog/powershell/7621/doing-more-with-windows-sandbox/). I strong recommend you read the blog post before trying any of the code. As I mention in the blog post, most of the code here will __reduce the security__ of the sandbox application. This is a trade-off I am willing to make for the sake of functionality that meets *my* requirements. You have to decide how much of my code you would like to use.

__*All code is offered as-is with no guarantees. Nothing in this repository should be considered production-ready or used in critical environments.*__

## Installing the Windows Sandbox

You need to have the 2004 version of Windows 10. You should then be able to run these PowerShell commands.

```powershell
Get-WindowsOptionalFeature -online -FeatureName Containers-DisposableClientVM
Enable-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM
```

## My Tools

My default [configuration script](sandbox-config.ps1) takes about 4 minutes to complete. I use the [BurntToast](https://github.com/Windos/BurntToast) module to show a notification when it is complete. This project is not a PowerShell module or set of files you can run as-is. You are welcome to clone, download or copy as needed.

Last updated 27 August, 2020.

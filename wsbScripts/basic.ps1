Enable-PSRemoting -Force -SkipNetworkProfileCheck
Set-DnsClientServerAddress -ServerAddresses 1.1.1.1 -InterfaceAlias Ethernet
Install-PackageProvider -Name nuget -force -ForceBootstrap -MinimumVersion '2.8.5.201' -Scope AllUsers
Install-Module PSScriptTools,BurntToast -force
New-BurntToastNotification -Text "Basic sandbox setup complete."
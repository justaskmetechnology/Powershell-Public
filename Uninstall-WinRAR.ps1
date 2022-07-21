#SEARCH REGISTRY FOR 32BIT UNINSTALL STRING
$x86App  = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' | ? { $_ -match "WinRAR"}
#SEARCH REGISTRY FOR 64BIT UNINSTALL STRING
$x64App = Get-ChildItem 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | ? { $_ -match "WinRAR" }

#Check if 32bit is true then uninstall otherwise try 64bit uninstall
if ($x86App)
{
$UninstallPath = ($x86App |Get-ItemProperty).UninstallString
Start-Process -NoNewWindow -FilePath $UninstallPath -ArgumentList " /s"
}
#Try 64bit and if true uninstall otherwise exit
elseif($x64App)
{
$UninstallPath = ($x64App |Get-ItemProperty).UninstallString
Start-Process -NoNewWindow -FilePath $UninstallPath -ArgumentList " /s"
}

#Exit if not everything above 
else
{
exit
}
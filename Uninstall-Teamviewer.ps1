$path64bit = "C:\Program Files\TeamViewer\uninstall.exe"
$path32bit = "C:\Program Files (x86)\TeamViewer\uninstall.exe"


# Check for 64BIT and uninstall if True
If (Test-Path -Path $path64bit)
{
Start-Process -Wait -FilePath "C:\Program Files\TeamViewer\uninstall.exe" -ArgumentList '/S','/v','/qn' -passthru -ErrorAction SilentlyContinue
}

ElseIf (Test-Path -Path $path32bit)
{
Start-Process -Wait -FilePath "C:\Program Files (x86)\TeamViewer\uninstall.exe" -ArgumentList '/S','/v','/qn' -passthru -ErrorAction SilentlyContinue
}

Else
{
Exit
}



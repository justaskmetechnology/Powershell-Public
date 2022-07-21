#################
#7-ZIP UPDATER  #
#################


If
((Get-Package -Name '*7-zip*').version -eq '22.01.00.0')

{exit}

else
{
#Close 7zip if its running or zipping
$Exit7Zip = Get-Process "7zFM"
Stop-Process $Exit7Zip.Id -ErrorAction SilentlyContinue

$Exit7Zip = Get-Process "7zG"
Stop-Process $Exit7Zip.Id -ErrorAction SilentlyContinue


########Uninstall WINRAR & OLD 7ZIP IN EVERY WHICH WAY##########
$getappname1 = Get-Package -Provider Programs -IncludeWindowsInstaller -Name "*winrar*"
$appname = $getappname1.name
Uninstall-Package $appname -ErrorAction Continue 
Sleep 15
Start-Process "C:\Program Files\WinRAR\Uninstall.exe" -ArgumentList "/S" -ErrorAction Continue -Wait
Sleep10
Start-Process "C:\Program Files (x86)\WinRAR\Uninstall.exe" -ArgumentList "/S" -ErrorAction Continue -wait
Sleep 5
Start-Process "C:\Program Files\7-Zip\Uninstall.exe" -ArgumentList "/S" -ErrorAction Continue -Wait
Start-Process "C:\Program Files (x86)\7-Zip\Uninstall.exe" -ArgumentList "/S" -ErrorAction Continue -wait

$getappname = Get-Package -Provider Programs -IncludeWindowsInstaller -Name "*7-Zip*"
$appname = $getappname.name
Uninstall-Package $appname -ErrorAction Continue
########END UNINSTALL EVERY WHICH WAY LIKE CRAZY##########
                                
                                #Start install phase
                                sleep 10
                                #Create Temp Directory to store installer
                                New-Item -Path "c:\" -Name "temp7zipinstall" -ItemType "directory"

                                # Source URL -> The URL will need to be updated each time a new version of 7zip is released
                                $url = "https://www.7-zip.org/a/7z2201-x64.msi"

                                # Destation file
                                $dest = "C:\temp7zipinstall\7zip.msi"

                                # Download the file
                                Invoke-WebRequest -Uri $url -OutFile $dest

                                #Install Newest version of 7zip
                                Start-Process $dest -argumentlist  "/quiet /passive" -Wait -ErrorAction Continue
                                sleep 20

                                #Delete Temp Working Directory
                                $tempfolder = "C:\temp7zipinstall\"
                                Remove-Item -path $tempfolder -Recurse
                                Exit

                                
}

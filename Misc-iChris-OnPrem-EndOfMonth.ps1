# This script has been written to assist with missing functionality within the Frontier iChris aka Chris21 software.
# The on-premsis software has multiple different application install entries within the applications inventory within windows
# Each one of these entries is a separate environment used to process pay roll files
# Instead of manually stopping the services and copying the files between environments this script can be used.
# This script does the end of month transfer
# At end of month the data in "AUS_PROD\Dat" gets copied to "AUS_PREVMTH\dat"
# Before this can happen the frontier (chris21) services need to get stopped to avoid lock files and other issues
# After this happens the services need to get started again
# This script needs to be run directly on the production service and cannot be run over the network
# This script also needs to be run as admin and will not function without admin rights


# Source is the current weeks dat location
$Source = "C:\FrontierInstallFolder\"CurrentWeekEnvironmentName"\dat"
# Destination is the previous week or previous months dat location
$Destintation = "C:\FrontierInstallFolder\"PreviousmonthEnvironmentName"\dat"
# As of 2024 on the most current version of iChris these are the 3 services that need stopped
# After they are stoppped the "dat" locations become unlocked and can be copied freely without lock files
$Services = "BRELauncher","FTRnetd","FTRsched"

# 1: Stop the chris21 services
foreach
($Service in $Services)
{
Get-Service $Service | Stop-Service
$ServiceDetails = Get-Service -Name $Service
$ServiceStatus = $ServiceDetails.Status 
    if
    ($ServiceStatus -eq "Stopped")
    {
    Write-Host -ForegroundColor Green "The" $ServiceDetails.Name "is now" $ServiceDetails.Status
    }
    
    else
    {
    Write-Host  -ForegroundColor Red "The" $ServiceDetails.Name "is" $ServiceDetails.Status ", script stopped."
    Write-Host -ForegroundColor Red "Powershell will now exit as the services did not stop."
    Read-Host -Prompt "Press any key to continue"
    Exit
    }
}

# 2: Robocopy the files from prod to prvmnt
Write-Host "Files will now be copied from $Source to $Destination"
Read-Host -Prompt "Press any key to continue"
Robocopy $Source $Destintation /mir
Write-Host -ForegroundColor Green "Files transfer complete from $Source to $Destination"
Write-Host -ForegroundColor Green "Review the Robocopy output"
Read-Host -Prompt "Press any key to continue"

# 3: Start the chris21 services
foreach
($Service in $Services)
{
Get-Service $Service | Start-Service
$ServiceDetails = Get-Service -Name $Service
$ServiceStatus = $ServiceDetails.Status 
    if
    ($ServiceStatus -eq "Running")
    {
    Get-Service $Service | Start-Service
    Write-Host -ForegroundColor Green "The" $ServiceDetails.Name "is now" $ServiceDetails.Status
    }
    else
    {
    Write-Host -ForegroundColor Red "The" $ServiceDetails.Name " did not start in time. Status is" $ServiceDetails.Status "."
    Write-Host -ForegroundColor Red "Try manually starting the iChris services. Powershell will now exit."
    Read-Host -Prompt "Press any key to continue"
    Exit
    }


}
Write-Host -ForegroundColor Green "All of the services are running. Powershell will now exit."
Read-Host -Prompt "Press any key to continue"
Exit
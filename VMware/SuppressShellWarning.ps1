#### Variables ####
$ESXHost = "Your ESXi Host Name or IP Address Here" #Put your ESXi host name or IP address

#Connect to your ESX Host
Connect-viserver $ESXHost
#Get the current setting
Get-VMhost $ESXHost | Get-AdvancedSetting -Name UserVars.SuppressShellWarning 
#Set the value to 1 and suppress confirmation of running this command
Get-VMhost $ESXHost | Get-AdvancedSetting -Name UserVars.SuppressShellWarning | Set-AdvancedSetting -Value 1 -Confirm:$False
#Show the setting
Get-VMhost $ESXHost | Get-AdvancedSetting -Name UserVars.SuppressShellWarning 

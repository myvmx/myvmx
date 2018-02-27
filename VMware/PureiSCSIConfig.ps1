<#
Script to use the ESXi host hba iqn name to create or amend connection
in Pure Storage so that we can automate presenting the LUNS to 
the ESXi host

KY V0.1 27/02/18
#>

## variables
# Pure Array Management IP Address
$PureArrayIP = "Pure Storage Managment IP or FQDN"
# Pure Storage Group Name
$PureHostGroup = "Host Group Name"
# ESXi Host Name
$ESXHost = "ESXi Host Display Name"
# ESXi IQN Name
$ESXHostIQN = "IQN String"



#Check if Pure Storage Module is installed before carrying on
If (!(Get-Module | Where {$_.Name -eq "PureStoragePowerShellSDK"})) 
{Write-host "You need to install the PURE Storage PowerShell before carrying on" 
Exit
}

#
#Pure Array Connection String
$PureArray = New-PfaArray -EndPoint $PureArrayIP -Credentials (Get-Credential) -IgnoreCertificateError

#Get Pure Array ESXi Host Details
$PureVMHost = Get-pfahosts -Array $PureArray| where {$_.name -eq $ESXHost}

#Check if host already exist if yes then amend the iqn else create the host and add iqn and to the blade group
If (!$PureVMhost) 
{
#Create New host in Pure Array 
New-PfaHost -Array $PureArray -Name $ESXHost -IqnList $ESXHostIQN 
#Add new host host group defined above
Add-PfaHosts -Array $PureArray -Name $PureHostGroup -HostsToAdd $ESXHost
}
Else
{
Set-PfaHostIqns -Array $PureArray -Name $PureVMHost.Name -IqnList $ESXHostIQN
}



<#
This script is to create an new vSwitch
Create all the vmkernel enable iSCSI
create port binding

KY 28/01/18 v0.1
#>

### Variables for creating the iSCSI Switch
## The following three should change for each host you deploy
$ESXHostName = "You ESXi Host IP or FQDN"
$iSCSIIP1 = "IP Address for iSCSI VMKernel adapter 1" #iSCSI 1 IP address for vmkernel
$iSCSIIP2 =  "IP Address for iSCSI VMKernel adapter 2" #iSCSI 2 IP address for vmkernel
##  The remaining variables should be the same across your host/cluster/datacentre
$iSCSISubnet = "Subnet for iSCSI VMKernel adapter" #iSCSI Adapter Subnet
$iSCSISwName = "Name you want to give for vSwitch" #iSCSI switch name
$iSCSIMTU = "MTU Size for iSCSI" #iSCSI MTU Size
$iSCSIPg1Name = "Port Group 1 name" #iSCSI 1 Portgroup Name
$iSCSIPg2Name = "Port Group 2 name" #iSCSI 2 Portgroup Name
$iSCSIPhyNic1 = "Your physical Adapter Nic 1 Name" #iSCSI 1 Physical Adapter Nic Name
$iSCSIPhyNic2 = "Your physical Adapter Nic 2 Name" #iSCSI 2 Physical Adapter Nic Name
$iSCSItargetIP = "IP address of your iSCSI Array" #iSCSI Server Target IP

##################################################################

## Connect to Host
Connect-VIServer $ESXHostName
## Put host into maintenance
Set-VMHost -State "Maintenance"
## Create iSCSI Switch
New-VirtualSwitch -Name $iSCSISwName -Mtu $iSCSIMTU -confirm:$false
## Add physical nic 1 to the Switch
$VMHostPhysicalNic1 = Get-vmhost | Get-VMHostNetworkAdapter -Physical -Name $iSCSIPhyNic1
get-virtualSwitch -name $iSCSISwName | Add-VirtualSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $VMHostPhysicalNic1 -Confirm:$false
## Add physical nic 2 to the Switch
$VMHostPhysicalNic2 = Get-vmhost | Get-VMHostNetworkAdapter -Physical -Name $iSCSIPhyNic2
get-virtualSwitch -name $iSCSISwName | Add-VirtualSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $VMHostPhysicalNic2 -Confirm:$false
## Modify vSwitch Policies
Get-VirtualSwitch -Name $iSCSISwName | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuous $false -MacChanges $true -ForgedTransmits $true -confirm:$false
Get-VirtualSwitch -Name $iSCSISwName | Get-NicTeamingPolicy | Set-NicTeamingPolicy -MakeNicActive $iSCSIPhyNic1,$iSCSIPhyNic2
Get-VirtualSwitch -Name $iSCSISwName | Get-NicTeamingPolicy | Set-NicTeamingPolicy -LoadBalancingPolicy LoadBalanceSrcId
Get-VirtualSwitch -Name $iSCSISwName | Get-NicTeamingPolicy | Set-NicTeamingPolicy -NetworkFailoverDetectionPolicy LinkStatus
Get-VirtualSwitch -Name $iSCSISwName | Get-NicTeamingPolicy | Set-NicTeamingPolicy -FailbackEnabled:$true -NotifySwitches:$true 
## Create the two VMKernel iSCSI 
New-VMHostNetworkAdapter -VirtualSwitch $iSCSISwName -Portgroup $iSCSIPg1Name -IP $iSCSIIP1 -SubnetMask $iSCSISubnet -mtu $iSCSIMTU
New-VMHostNetworkAdapter -VirtualSwitch $iSCSISwName -Portgroup $iSCSIPg2Name -IP $iSCSIIP2 -SubnetMask $iSCSISubnet -mtu $iSCSIMTU
## Modify 1st Port Group for iSCSI
get-virtualportgroup -Name $iSCSIPg1Name | get-nicteamingpolicy | Set-NicTeamingPolicy -MakeNicActive $iSCSIPhyNic1 -MakeNicUnused $iSCSIPhyNic2
Get-Virtualportgroup -Name $iSCSIPg1Name | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuousInherited $true -ForgedTransmitsInherited $true -MacChangesInherited $true -confirm:$false 
get-virtualportgroup -Name $iSCSIPg1Name | get-nicteamingpolicy | Set-NicTeamingPolicy -InheritLoadBalancingPolicy:$true -InheritNetworkFailoverDetectionPolicy:$true
get-virtualportgroup -Name $iSCSIPg1Name | get-nicteamingpolicy | Set-NicTeamingPolicy -InheritNotifySwitches:$true -InheritFailback:$true -InheritFailoverOrder:$false
## Modify 2nd Port Group for iSCSI
get-virtualportgroup -Name $iSCSIPg2Name | get-nicteamingpolicy | Set-NicTeamingPolicy -MakeNicActive $iSCSIPhyNic2 -MakeNicUnused $iSCSIPhyNic1
Get-Virtualportgroup -Name $iSCSIPg2Name | Get-SecurityPolicy | Set-SecurityPolicy -AllowPromiscuousInherited $true -ForgedTransmitsInherited $true -MacChangesInherited $true -confirm:$false 
get-virtualportgroup -Name $iSCSIPg2Name | get-nicteamingpolicy | Set-NicTeamingPolicy -InheritLoadBalancingPolicy:$true -InheritNetworkFailoverDetectionPolicy:$true
get-virtualportgroup -Name $iSCSIPg2Name | get-nicteamingpolicy | Set-NicTeamingPolicy -InheritNotifySwitches:$true -InheritFailback:$true -InheritFailoverOrder:$false
## Set iSCSI software adapter to be enabled
Get-vmhoststorage | set-vmhoststorage -SoftwareIScsiEnabled $true
#Let the script sleep for 30 seconds so that the host can enable the iSCSI adapter before moving on
Write-Host "Sleeping for 30 Seconds..." -ForegroundColor Green
Start-Sleep -Seconds 30
## Get all adapters where the name has VMK
$vmks = Get-VMHostNetworkAdapter | where {$_.name -like "vmk*"} #Get all vmks
## Get the iSCSI hba details to be used later
$hba = Get-vmhost | Get-VMHostHba -Type iScsi | Where {$_.Model -eq "iSCSI Software Adapter"}
## Create the target ie the connection to your array
New-IScsiHbaTarget -IScsiHba $hba -Address $iSCSItargetIP
## We need to get the vmk name that are attached to the iSCSI portgroup
## so that we can do the iSCSI binding. Store them in vmkscsi variable to use
ForEach ($vmk in $vmks){If ($vmk.PortGroupName -eq $iSCSIPg1Name) {$vmkscsi01 = $vmk.DeviceName}}
ForEach ($vmk in $vmks){If ($vmk.PortGroupName -eq $iSCSIPg2Name) {$vmkscsi02 = $vmk.DeviceName}}
## iSCSI port binding we need to use esxcli
$esxcli = Get-EsxCli -VMHost $ESXHost -v2
## Binds VMKernel ports created earlier to the iSCSI Software Adapter HBA
$esxcli.iscsi.networkportal.add.invoke(@{adapter = $hba.device;nic = $vmkscsi01})
$esxcli.iscsi.networkportal.add.invoke(@{adapter = $hba.device;nic = $vmkscsi02})
## Use this information to pass on to your san/array to carry on 
$hba.iscsiname 
## Scan the host so that it picks up the new LUNS that has already been assigned to it
Get-VMHostStorage -VMHost $ESXHost -RescanAllHba
Write-Host "Sleeping for 30 Seconds to let the host scan and pick up all the luns ..." -ForegroundColor Green
Start-Sleep -Seconds 30
## Disconnect from ESXi Server
Disconnect-VIServer $ESXHostName -Force -Confirm:$false

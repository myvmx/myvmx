### This script is to create an new vSwitch
### Create all the vmkernel 
### enable iSCSI
### create port binding



### Variables for creating the iSCSI Switch
$ESXHostName = "IP or host name of ESXi"
$iSCSISwName = "Name you would like for vSwitch ie vSwitch1" #iSCSI switch name
$iSCSIMTU = "MTU size you will use for iSCSI" #iSCSI MTU Size
$iSCSIPg1Name = "Portgroup Name for iSCSI 1 connection" #iSCSI 1 Portgroup Name
$iSCSIPg2Name = "Portgroup Name for iSCSI 2 connection" #iSCSI 2 Portgroup Name
$iSCSIPhyNic1 = "Physical Adapter Nic Name for iSCSI 1" #iSCSI 1 Physical Adapter Nic Name
$iSCSIPhyNic2 = "Physical Adapter Nic Name for iSCSI 1" #iSCSI 2 Physical Adapter Nic Name
$iSCSIIP1 = "IP Address for iSCSI 1 VMKernel" #iSCSI 1 IP address for vmkernel
$iSCSIIP2 =  "IP Address for iSCSI 2 VMKernel" #iSCSI 2 IP address for vmkernel
$iSCSISubnet = "Subnet IP for both iSCSI VMKernel" #iSCSI Adapter Subnet
$iSCSItargetIP = "iSCSI Server Target IP Address" #iSCSI Server Target IP
##################################################################

#Connect to Host
Connect-VIServer $ESXHostName

#Store Host detail as a variable to use through the script
$ESXHost = Get-VMhost 

#Put host into maintenance
$ESXHost | Set-VMHost -State "Maintenance"

#Create iSCSI Switch
New-VirtualSwitch -VMHost $ESXHost -Name $iSCSISwName -Mtu $iSCSIMTU -confirm:$false

#Create the two VMKernel iSCSI 
New-VMHostNetworkAdapter -vmhost $ESXHost -VirtualSwitch $iSCSISwName -Portgroup $iSCSIPg1Name -IP $iSCSIIP1 -SubnetMask $iSCSISubnet -mtu $iSCSIMTU
New-VMHostNetworkAdapter -vmhost $ESXHost -VirtualSwitch $iSCSISwName -Portgroup $iSCSIPg2Name -IP $iSCSIIP2 -SubnetMask $iSCSISubnet -mtu $iSCSIMTU

#Add Physical Nic to iSCSI Switch
$VMHostPhysicalNic1 = Get-vmhost $ESXHost | Get-VMHostNetworkAdapter -Physical -Name $iSCSIPhyNic1
get-virtualSwitch -vmhost $ESXHost -name $iSCSISwName | Add-VirtualSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $VMHostPhysicalNic1 -Confirm:$false
$VMHostPhysicalNic2 = Get-vmhost $ESXHost | Get-VMHostNetworkAdapter -Physical -Name $iSCSIPhyNic2
get-virtualSwitch -vmhost $ESXHost -name $iSCSISwName | Add-VirtualSwitchPhysicalNetworkAdapter -VMHostPhysicalNic $VMHostPhysicalNic2 -Confirm:$false
get-virtualportgroup -VMHost $ESXHost -Name $iSCSIPg1Name | get-nicteamingpolicy | Set-NicTeamingPolicy -MakeNicActive $iSCSIPhyNic1 -MakeNicUnused $iSCSIPhyNic2
get-virtualportgroup -VMHost $ESXHost -Name $iSCSIPg2Name | get-nicteamingpolicy | Set-NicTeamingPolicy -MakeNicActive $iSCSIPhyNic2 -MakeNicUnused $iSCSIPhyNic1

#Get all adapters with VMK
$vmks = Get-VMHostNetworkAdapter | where {$_.name -like "vmk*"} #Get all vmks

#Set iSCSI software adapter to be enabled
Get-vmhoststorage $ESXHost | set-vmhoststorage -SoftwareIScsiEnabled $true

#Let the script sleep for 30 seconds so that the host can enable the iSCSI adapter before moving on
Write-Host "Sleeping for 30 Seconds..." -ForegroundColor Green
Start-Sleep -Seconds 30

#Get the iSCSI hba details to be used later
$hba = $ESXHost | Get-VMHostHba -Type iScsi | Where {$_.Model -eq "iSCSI Software Adapter"}

#Create the target
New-IScsiHbaTarget -IScsiHba $hba -Address $iSCSItargetIP

# To get the vmk name so that we can use it to do iSCSI binding
ForEach ($vmk in $vmks){If ($vmk.PortGroupName -eq $iSCSIPg1Name) {$vmkscsi01 = $vmk.DeviceName}}
ForEach ($vmk in $vmks){If ($vmk.PortGroupName -eq $iSCSIPg2Name) {$vmkscsi02 = $vmk.DeviceName}}

#iSCSI port binding we need to use esxcli
$esxcli = Get-EsxCli -VMHost $ESXHost -v2
 
#Binds VMKernel ports created earlier to the iSCSI Software Adapter HBA
$esxcli.iscsi.networkportal.add.invoke(@{adapter = $hba.device;nic = $vmkscsi01})
$esxcli.iscsi.networkportal.add.invoke(@{adapter = $hba.device;nic = $vmkscsi02})

#Use this information to pass on to your san to carry on
$hba.iscsiname 

#Scan the host so that it picks up the new LUNS that has already been assigned to it
Get-VMHostStorage -VMHost $ESXHost -RescanAllHba
Write-Host "Sleeping for 30 Seconds to let the host scan and pick up all the luns ..." -ForegroundColor Green
Start-Sleep -Seconds 30

Disconnect-VIServer $ESXhostNameFQDN -Force -Confirm:$false



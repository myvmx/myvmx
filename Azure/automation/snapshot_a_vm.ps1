<#
    .DESCRIPTION
        An example runbook which gets all the ARM resources using the Run As Account (Service Principal)

    .NOTES
        AUTHOR: Azure Automation Team
        LASTEDIT: Mar 14, 2016
#>


<#

Snapshot a vm and its datadisk and store it back in the same resource group as the current VM, also adds some extra tags like the LUN number etc, will ask for 
VM name as mandatory

<#
To do
catch if disk not premium or standard
Catch display if success for the disk snapshot
email, logic app ?


#>
Param
(
  [Parameter (Mandatory= $true)]
  [string] $vmname = "nosuchvm"
)

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}


Write-Output "Locating VM details of : $vmName" 

## Get Info About The VM
$vm = get-azurermvm | Where-Object {$_.Name -eq $vmName}
$Snapdate = get-date -UFormat %Y-%m-%d-T-%H-%M-%S
$tagdate = get-date -UFormat %Y-%m-%d
#$vm = get-azurermvm -ResourceGroupName $resourceGroupName -Name $vmName

if ($vm -eq $null)
    {
    Write-Output " VM does not exist"
    return
    }
Else
    {
    Write-Output "Going through to take snapshot of server : $($vm.name)"
        # Check what disk it is and snap it as the same format or maybe just do it in tags?
        If ($vm.StorageProfile.OsDisk.ManagedDisk.StorageAccountType -like "*ssd*")
            {$StorAccType = "Premium_LRS"}
        Else
            {$StorAccType = "Standard_LRS"}
        
        $cachingtag = $vm.StorageProfile.OsDisk.caching
        $OSDiskTag = @{"snapservername"=($vm.name); "created_on"="$tagdate"; "caching"="$cachingtag"}

        # Snapshot config for OS    
        $snapshot = New-AzureRmSnapshotConfig -SourceUri $vm.StorageProfile.OsDisk.ManagedDisk.Id -Location $vm.location -CreateOption copy -Account $StorAccType -Tag $OSDiskTag
        
        Write-output "Creating OS Disk snapshot of : $($vm.StorageProfile.OsDisk.name)"
        
        # Snapshot name of OS Disk
        $SnapshotName = $vm.StorageProfile.OsDisk.name + "-snapshot-" + $snapdate
        
        Write-Output "OS Disk Snapshot Name : $snapshotName"
        
        New-AzureRmSnapshot -Snapshot $snapshot -SnapshotName $SnapshotName -ResourceGroupName $vm.ResourceGroupName
        
        # Work on data disk    
        foreach ($storage in $vm.StorageProfile.DataDisks)  
            {   
                #Write-Output $Storage.Name
                $disk = Get-AzureRmDisk -ResourceGroupName $vm.ResourceGroupName -DiskName $storage.Name 
            
                # Check what disk it is and snap it as the same format or maybe just do it in tags?        
                If ($disk.sku.name -like "*ssd*")
                    {$DataStorAccType = "Premium_LRS"}
                Else
                    {$DataStorAccType = "Standard_LRS"}
                # Write-output "Disk Type : $DataStorAccType " 
                
                $cachingtag = $storage.caching
                $luntag = $storage.lun
                $DataDiskTag = @{"snapservername"=($vm.name); "created_on"="$tagdate"; "lun" = "$luntag";"caching"="$cachingtag"}

                $snapshot =  New-AzureRmSnapshotConfig -SourceUri $disk.Id -Location $vm.location -CreateOption copy -Account $DataStorAccType -Tag $DataDiskTag
                Write-output "Creating data Disk snapshot of $($disk.name)" 
                $SnapshotName = $disk.name + "-snapshot-" + $snapdate
        
                Write-Output "Data Disk Snapshot Name : $snapshotName"
        
                New-AzureRmSnapshot -Snapshot $snapshot -SnapshotName $snapshotName -ResourceGroupName $vm.ResourceGroupName
            }

    }








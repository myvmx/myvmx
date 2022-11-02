#createddate tag

$DisksData = Get-AzDisk -ResourceGroupName "" -DiskName "*os*" | Select TimeCreated, ManagedBy, @{N="VMname"; e = {($_.managedby -split "/")[8]} }

foreach ($item in $DisksData)
{
if ($item.VMname){
$itemAZTimeCreated = $item.TimeCreated
$vmIDunt7 = $item.ManagedBy
$item.VMname
$crdate = Get-Date $itemAZTimeCreated -UFormat "%d/%m/%Y"

$AzureVMUNT7 = Get-AzResource -ResourceId $vmIDunt7 #-Name $vmIDunt7 -ResourceType Microsoft.Compute/virtualMachines
$AzureVMUNT7.Tags

$AzureVMtagsUNT7 = $AzureVMUNT7.Tags
$AzureVMtagsUNT7.createddate = $crdate 


Update-AzTag -ResourceId $vmIDunt7 -Tag $AzureVMtagsUNT7 -Operation Replace
#$itemAZTimeCreated.Split(":")
}
}

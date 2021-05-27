## Get all VMSS in subscription and only shutdown VMs that are powered on

# get all the VMSS in the subscription
$vmssset = Get-AzVmss

# loop through each Scale Set
foreach ($vmss in $vmssset)
{
  # Get all the VMs in the VM Scale Set
  $vms = Get-azvmssvm -ResourceGroupName $vmss.ResourceGroupName -VMScaleSetName $vmss.Name -InstanceView
    foreach ($vm in $vms)
      {    
        Write-host "VM $($vm.name) is in Cluster $($vmss.name)"
        $statuses = Get-azvmssvm -ResourceGroupName $vm.ResourceGroupName -VMScaleSetName $vmss.Name -instanceid $vm.InstanceId -InstanceView
          foreach ($status in $Statuses.Statuses)
            {
              # If the vm is running then we shut it down else we leave it
              If ($status.DisplayStatus -eq "VM running")
                {
                  Write-Host $vm.name $status.DisplayStatus
                  Stop-AzVmss -ResourceGroupName $vm.ResourceGroupName -VMScaleSetName $vmss.Name -instanceid $vm.InstanceId -Force -Verbose
                }
            } 
      }
}


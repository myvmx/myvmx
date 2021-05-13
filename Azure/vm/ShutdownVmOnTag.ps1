<#
To shutdown VMs based on a tag name and its value.
Example here is to shutdown VM if its tag name is "shutdown" and value is set to "yes"
If the VM is already in deallocated state then we just skip the command to shutdown 
and move to the next VM

#>

$vms = Get-AzVM -Status
$tagkeyname = "shutdown"
$tagkeyvalue = "yes"

foreach ($vm in $vms)
{
    if($vm.tags.ContainsKey($tagkeyname))
        {
            write-host "$($vm.Name) has tag name $($tagkeyname)"
                if($vm.Tags.$($tagkeyname) -eq $tagkeyvalue)
                    {
                        write-host "$($vm.name) has tag value set to $($tagkeyvalue)"
                            if ($vm.powerstate -ne "VM deallocated")
                                {
                                    Write-host "$($vm.name) has power state of $($vm.powerstate)"
                                    Write-host "Running command to power off server $($vm.name)"
                                    Stop-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Force
                                }
                    }
        }
}

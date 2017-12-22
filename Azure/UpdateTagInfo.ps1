############
# Script to get all the VM in a subscription and update a tag with new information
#
############

##Variable
#define the tag you would like to amend the values
$tagname = "Your tag names"

Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionId "Your Subscription ID"

$vms = get-azurermvm
foreach ($vm in $vms)
{
    ## If that VM never had any tags assigned to it then we do this
    If ($vm.tags.count -eq 0)
    {
    #$tags = Get-AzureRmResource -ResourceId $vm.Id
    Set-AzureRmResource -tag @{$tagname = $vm.name} -ResourceId $vm.id -force 
    }
    ## Tags exist for VMs so we will just update tags 
    Else
    {
    $tags = Get-AzureRmResource -ResourceId $vm.Id
    $tags.tags += @{$tagname = $vm.name}
    Set-AzureRmResource -tag $tags.tags -ResourceId $vm.id -force 
    }
}


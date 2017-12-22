############
# Script to get all the VM in a subscription and to see if specific tag are missing
# then write to screen the missing VM name
############

##Variable
#define the tag you would like to find
$tag = "Your Tag"

Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionId "Your Subscription ID"

#get all the vms
$vms = get-azurermvm 
Write-Host "The following machines does not have the tag $tag"
foreach ($vm in $vms)
{
##If it does not contain the value write the machine name out
If ($vm.tags.ContainsKey($tag) -eq $false) {Write-Host $vm.name} 
}

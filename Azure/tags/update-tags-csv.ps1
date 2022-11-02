#add maintenance tags, data imported from CSV

Clear-Variable -Name csv1
Clear-Variable -Name item


$csv1 = Import-Csv -path "C:\csv\brdev.csv" #UPDATE PATH AND SOURCE CSV



foreach ($item in $csv1)
{

$AzureVM = Get-AzResource -Name $item.VM -ResourceType Microsoft.Compute/virtualMachines

$AzureVMtags = $AzureVM.Tags
$AzureVMtags."maintenance day" = $item.Day.ToLower()
$AzureVMtags."maintenance time" = $item.start
$AzureVMtags."maintenance duration" = $item.dur
Update-AzTag -ResourceId $AzureVM.ResourceId -Tag $AzureVMtags -Operation Replace

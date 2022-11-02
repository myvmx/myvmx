$resources = Get-AzResource -ResourceType Microsoft.Compute/virtualMachines #-ResourceGroup rg-uks-barclays-test-srs-001 #
foreach ($resource in $resources)
{ 

$rcID1 = $resource.ResourceId
$tags1 = $resource.Tags
$maintenance_window = $tags1.maintenance_window

if ($maintenance_window)
{
$maintenance_window_arr = $maintenance_window.Split("_")

if ($maintenance_window_arr[0] -like "sun"){
Write-Host "sunday"
$tags1."maintenance day" = "sunday"
$tags1."maintenance time" = $maintenance_window_arr[1].Insert(2,':')
$tags1."maintenance duration" = $maintenance_window_arr[2].substring(0, 2)+":00"
Update-AzTag -ResourceId $rcID1 -Tag $tags1 -Operation Replace
}
elseif ($maintenance_window_arr[0] -like "sat"){
Write-Host "saturday"
$tags1."maintenance day" = "saturday"
$tags1."maintenance time" = $maintenance_window_arr[1].Insert(2,':')
$tags1."maintenance duration" = $maintenance_window_arr[2].substring(0, 2)+":00"
Update-AzTag -ResourceId $rcID1 -Tag $tags1 -Operation Replace
}
elseif ($maintenance_window_arr[0] -like "fri"){
Write-Host "friday"
$tags1."maintenance day" = "friday"
$tags1."maintenance time" = $maintenance_window_arr[1].Insert(2,':')
$tags1."maintenance duration" = $maintenance_window_arr[2].substring(0, 2)+":00"
Update-AzTag -ResourceId $rcID1 -Tag $tags1 -Operation Replace
}

}
}

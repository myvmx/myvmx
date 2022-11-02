#get missing tags

#all tags
$tttag = ("client", "service", "role", "environment", "createddate", "maintenance day", "maintenance time", "maintenance duration", "owner", "test type", "auto_start_stop")

#without owner and test type
$tttag = ("client", "service", "role", "environment", "createddate", "maintenance day", "maintenance time", "maintenance duration", "auto_start_stop")


$VMsUNTL8 = Get-AzResource -ResourceType Microsoft.Compute/virtualMachines

foreach ($VMUNTL8 in $VMsUNTL8)
{
#$VMUNTL8.Name.ToLower()
$VMUNTL8TAGS = $VMUNTL8.Tags.Keys
$tttag | ForEach-Object {
    if ($_ -notin $VMUNTL8TAGS) {
        Write-Host "Azure VM " $VMUNTL8.Name "is missing [$_] tags"
    }
}

}

#delete 'created date' tag

$VMsUNTL8 = Get-AzResource -ResourceType Microsoft.Compute/virtualMachines

foreach ($VMUNTL8 in $VMsUNTL8)
{
$VMUNTL8TAGS = $VMUNTL8.Tags
if ($VMUNTL8TAGS.'created date')
{
$VMUNTL8TAGS.Remove('created date')
Update-AzTag -ResourceId $VMUNTL8.Id -Tag $VMUNTL8TAGS -Operation Replace
}

}

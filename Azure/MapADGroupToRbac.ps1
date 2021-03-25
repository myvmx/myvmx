<# To read from csv which has the columns at minimum Name of Role in Azure, ADGroup DisplayName, Scope

If scope is at subcription then the format in the csv for scope is "/subscriptions/<subscriptionId>"
If scope is at subcription then the format in the csv for scope is "/providers/Microsoft.Management/managementGroups/<groupName>"

For others refer to https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-powershell
#>

# Path to all the mapping
$csv = import-csv -Path "csv file path"

foreach ($role in $csv)
{
    $adgroupid = (Get-AzADGroup -DisplayName $role.ADGroup).id
    New-azroleassignment -objectid $adgroupid -roledefinitionName $role.role -scope $role.Scope
}

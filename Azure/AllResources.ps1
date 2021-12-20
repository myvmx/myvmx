<#
To get all resources in all the azure subscriptions that you have permissions with and specific fields

Edit the export csv to the path you want
#>

# Create array for report
$Report = @()
# Get all the subscriptions
$subs = Get-AzSubscription
# Loop through each subscription
foreach ($sub in $subs)
{
Set-AzContext $sub.Id
# Get all the resources in the subscription
$Resources = Get-AzResource
# Loop through all the resources and write the fields that you need to array
    foreach ($resource in $Resources)
        {
        $PSObject = New-Object PSObject -Property @{
        SubscriptionName = $sub.name
        Name = $resource.Name
        ResourceGroupName = $resource.ResourceGroupName
        ResourceType = $resource.ResourceType
            }
        $Report += $PSObject
        } 
}

# Export to csv
$report | export-csv -path c:\powershell\allresources.csv -NoClobber -NoTypeInformation

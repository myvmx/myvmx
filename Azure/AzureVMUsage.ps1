<#
Get VM usage in Azure to make sure we have not hit our limits

KY 0.1 21/02/18

#>

# Variables
$SubName = "Your Subscription Name"
# The file will be written in current directory that you have ran this script from
$FileName = "Your text file name.txt"


# Login to Azure Account
Login-AzureRmAccount
# Select Subscription to be used
Select-AzureRmSubscription -SubscriptionName $SubName
# Get all available locations in Azure
$locations = Get-azureRmLocation

# Loop through each of the locations and gather information
# about the VM usage
Foreach ($location in $Locations)
{
# Print to screen which location we are looping through
Write-Host $Location.Location
# Write the location to the file
$Location.Location | Out-File $FileName -Append
# Write the usage to the file
Get-AzureRMVMUsage -Location $location.Location | Out-File $FileName -Append
}

<#
Other usage commands that maybe useful
Get-AzureRmNetworkUsage, Get-AzureRMStorageUsage
#>

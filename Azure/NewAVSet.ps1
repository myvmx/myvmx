<#

Script to create a AV Set

KY v0.1 01/03/18

#>

# Variables
$SubName = "Your Subscription Name"
$ResourceGroupName = "Your Resource Group Name"
$Location = "Location to deploy AV set to"
$AvSetName ="AV Set name"

# Login
Login-AzureRmAccount
# Set Subscription
Select-AzureRmSubscription -SubscriptionName $SubName

# Check if a resource with the name exist already
# If it does print info out then exit
$AvSet = Find-AzureRmResource -ResourceNameEquals $AvSetName
If ($AvSet)
{
Write-host "Resource Exists so do not carry on"
Write-host "Name: " $AvSet.Name
Write-host "Resource ID: " $AvSet.ResourceId
Write-Host "Resource Name: " $AvSet.ResourceName
Write-Host "Resource Type: " $AvSet.ResourceType
Write-Host "Resource Group Name: " $AvSet.ResourceGroupName
Write-Host "Location: " $AvSet.Location
Write-Host "Subscription: " $AvSet.SubscriptionId
Exit
}
Else
{
# Create AV Set
Write-Host "Creating Availability Set " $AvSetName " in Resource Group " $ResourceGroupName
New-AzureRmAvailabilitySet -Location $Location -Name $AvSetName -ResourceGroupName $ResourceGroupName
}
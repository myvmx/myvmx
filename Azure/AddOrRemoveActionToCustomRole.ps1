<####
# Script to get add/remove actions to a custom role
# 
# KY 27/12/17 v0.1
####>

### Variable
## define the tag you would like to find
$SubId = "You SubSciption ID"
## Custom Role Name in Azure
$CustomRoleName = "Your Custom Role" 
###

## Login to Azure
Login-AzureRmAccount
## Select the Azure account
Select-AzureRmSubscription -SubscriptionId $SubId

## Get the role information and store as variable
$role = Get-AzureRmRoleDefinition $CustomRoleName
## Add the action/s you would like to the role
$Role.Actions.Add("Microsoft.Compute/virtualMachines/performMaintenance/action")
## To remove an action
#$Role.Actions.Remove("Microsoft.Compute/virtualMachines/Redeploy/action")
## Commit the change
Set-AzureRmRoleDefinition -Role $role
## Display the role permissions
(Get-AzureRMRoleDefinition -Name $CustomRoleName).Actions


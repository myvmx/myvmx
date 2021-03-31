########################
## To edit/modify the location of Azure VM boot diagnostic location
## https://docs.microsoft.com/en-us/powershell/module/azurerm.compute/set-azurermvmbootdiagnostics?view=azurermps-6.13.0
## Author : Kin Yung
## 08/10/2019
#######################

## Subscription ID
$SubId = "replace with your subscription ID"

## Store the Storage Account Name resource group in variables
$StorAccName = "Replace with Storage Account Name where the boot diagnostics logs go to"
$StorAccRg = "Replace with Storage Account resource group name"

# Login to Azure
Connect-AzureRMAccount
# Select the subscription to focus on
Select-AzureRmSubscription -Subscriptionid $SubId

# Gets all the VMs
$vms = Get-AzureRmVm

# Loop through all the VMs and then print out the current status
# of the boot diagnostics, value will return either true or false
# and will print out location the info is written to if enabled
foreach ($vm in $vms)
  {
    Write-host $vm.Name
    Write-host $vm.DiagnosticsProfile.BootDiagnostics.Enabled
    Write-Host $vm.DiagnosticsProfile.BootDiagnostics.StorageUri
  }

#############################
# Script below hashed out but can be used to make the changes and enable
# diagnostics account
<#
foreach ($vm in $vms)
  {
    Write-host $vm.Name
    Write-host $vm.DiagnosticsProfile.BootDiagnostics.Enabled
    Write-Host $vm.DiagnosticsProfile.BootDiagnostics.StorageUri
    Set-AzureRmVMBootDiagnostics -VM $vm -ResourceGroupName $StorAccRg -Enable -StorageAccountName $StorAccName | Update-AzureRmVm 
  }
#>


############################

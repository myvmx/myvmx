<####
# Script to remove Public IP from all network interface in a resource group which may
# have more than one profile
# https://docs.microsoft.com/en-us/powershell/module/azurerm.network/set-azurermnetworkinterface?view=azurermps-6.13.0
# KY 19/11/19 v0.1
####>

### Variable
## 
$SubId = "Your Subscription ID"
$ResourceGroupName = "Your Resource Group Name"
###

## Login to Azure
Login-AzureRmAccount
## Select the Azure account
Select-AzureRmSubscription -SubscriptionId $SubId

## Get all the nics in the resourcegroup
$nics = Get-AzureRmNetworkInterface -resourcegroupname $ResourceGroupName

## Loop through each nic remove public IP where needed
foreach ($nic in $nics)
{
    ## Set the array to start at 0
    $num = 0 
    ## Loop through each IP config
    foreach ($ip in $nic.IpConfigurations)
    {
    Write-Host $nic.IpConfigurations[$num].Name
    ## Check if there is a value in IP ID field
        If ($nic.IpConfigurations[$num].PublicIpAddress.id -ne "")
            ## If there is a value then clear the value and update the configs for the nic
            {
            Write-Host $nic.IpConfigurations[$num].PublicIpAddress.id
            $nic.IpConfigurations[$num].PublicIpAddress = $null
            Set-AzureRmNetworkInterface -NetworkInterface $nic
            }
    ## Increase the num count
    $num++
    }
}

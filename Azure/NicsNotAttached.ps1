#########################
#This script is to find all network cards which are not attached to anything
#
#V0.1
##########################

###Variables
#Store Sub ID details
$SubId = "Enter Your Sub ID"


###Script Starts

#Login to your Azure Subscription
Login-AzurRmAccount

#Select your subscription ID
Select-AzureRmSubscription -SubscriptionId $SubId

#Get all nics details and store in variable 
$nics = get-azurermnetworkinterface

#Print on screen all the nics which has a null value to Virtual Machine and select the 
#Nic Name, Location and resource group it belows to
$nics | where-object {$_VirtualMachine -eq $null} | select Name,Location,ResourceGroupName

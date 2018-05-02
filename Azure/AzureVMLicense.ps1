################
## To get VM and licence type around hybrid benefits
## https://docs.microsoft.com/en-us/azure/virtual-machines/windows/hybrid-use-benefit-licensing
## Author : Kin Yung
## 02/05/2017
################

## Variables
$SubID = "Replace Your Subscription id"
$CSVlocation = "Replace with your path and file name of csv"

##

Login-AzureRMAccount
Select-AzureRmSubscription -Subscriptionid $subid
## Returns value of server name, VM size and licence type
## If there is a value for licence then it means we are using hybrid
$vm = Get-AzureRmVM | select name, @{Name="VMSize";Expression={$_.hardwareprofile.vmsize}},licensetype

## Export to CSV
$vm | Export-Csv -NoTypeInformation $CSVlocation

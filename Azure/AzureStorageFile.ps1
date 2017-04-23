################
## To write to azure file storage
## https://docs.microsoft.com/en-us/azure/storage/storage-dotnet-how-to-use-files
## Author : Kin Yung
## 23/04/2017
################

## Store the Storage Account Name and Key in Variable
$StorName = "Replace Storage Account Name"
$StorKey = "Replace Storage Account Key"
$FileShareName = "Replace File Share Name"

Login-AzureRMAccount

############################

## Use this section of script
## if you are going to set a default storage account
##

## Set a default Storage Account
Set-AzureRmCurrentStorageAccount -Name $StorName -ResourceGroupName "Name of Resource Group"

## Set the Storage account context you wish to use
New-AzureStorageContext -StorageAccountName $StorName -StorageAccountKey $StorKey

## TO upload file
Set-AzureStorageFileContent -ShareName $FileShareName -Source "Path to file to upload" 

## To view the files
Get-AzureStorageFile -ShareName $FileShareName

## To create directory
New-AzureStorageDirectory -ShareName $FileShareName -Path "Name of Directory"

##############################

##############################
## Use this section of script
## if you will store the Storage Context
## as a variable to be used

## Set the Storage account context you wish to use and store in variable
$StorageContext=New-AzureStorageContext -StorageAccountName $StorName -StorageAccountKey $StorKey

## TO upload file
Set-AzureStorageFileContent -Context $StorageContext -ShareName $FileShareName -Source "Path to file to upload" 

## To view the files
Get-AzureStorageFile -Context $StorageContext -ShareName $FileShareName

## To create directory
New-AzureStorageDirectory -Context $StorageContext -ShareName $FileShareName -Path "Name of Directory"


##############################

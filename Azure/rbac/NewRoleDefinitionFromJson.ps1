## Create new role definition from json files from a specific path

# Path to all the roles of json files
$JsonFilePath = "Your path where all the role jsons are held"

# Get all files from path and make sure they are jsons
$JsonFiles = Get-ChildItem -Path $JsonFilePath | where-object {$_.Extension -eq ".json"}

# Loop through each file and create the new role definitions
foreach ($JSonfile in $JsonFiles)
{
Write-host $JSonfile.fullname
New-AzRoleDefinition -InputFile $jsonfile.FullName
}

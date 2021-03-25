<# Get all role assignments for the tenant in their subscriptions as long as you have permissions
and export to CSV location you define
#>
# Store tenant id
$tenantid = "Your Tenant ID"
# Get all the subscriptions
$azsubs = Get-AzSubscription -TenantId $tenantid
# Blank array
$Report = @()
# Location of report and added date and time to make it unique in case you run it again and again
$ReportLoc = "Location and starting name of your file" + $(Get-Date -Format "yyyyMMdd-hh-mm-ss") + ".csv"
# Loop through each subscription
foreach ($azsub in $azsubs)
{
# Set context
Set-AzContext -Subscription $azsub.Name
# Store the Role Assignment details
$azroles = Get-AzRoleAssignment -Scope "/subscriptions/$azsub"
# Loop through each role assignment and create PS objet
Foreach ($azrole in $azroles)
                {
                    $PSObject = New-Object PSObject -Property @{
                    Subscription = $azsub.Name
                    DisplayName = $azrole.DisplayName
                    SignInName = $azrole.SignInName
                    Role = $azrole.RoleDefinitionName
                    RoleID = $azrole.RoleDefinitionId
                    RoleAssignmentID = $azrole.RoleAssignmentId
                    Type = $azrole.ObjectType
                    ObjectID = $azrole.ObjectId
                    Scope = $azrole.Scope
                    }
                    $Report += $PSObject
                }
}

$Report | Export-Csv $ReportLoc -NoTypeInformation

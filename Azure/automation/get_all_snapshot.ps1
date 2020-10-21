<#
    .DESCRIPTION
        An example runbook which gets all the ARM resources using the Run As Account (Service Principal)

    .NOTES
        AUTHOR: Azure Automation Team
        LASTEDIT: Mar 14, 2016
#>

<#
Get all snapshot in a subscription and list out with all the tag information on those snapshots


#>
<#
To do
catch if disk not premium or standard
Catch display if success for the disk snapshot
email, logic app ?


#>


$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}



Write-Output "Getting all the snapshots" 

## Get Info About The VM
$Snapshots = Get-AzureRmResource -ResourceType "microsoft.compute/snapshots"

Write-output "The number of $($snapshots.count)"
foreach ($snapshot in $snapshots)
{
    Write-output "Snapshot Name : $($snapshot.Name)"
    Write-output "Resource Group : $($snapshot.resourcegroupname)"
    Write-output "Location : $($snapshot.location)"
# Go through each tag
    $tags = $snapshot.tags
    foreach ($tag in $tags.GetEnumerator())
        {
            Write-output "$($tag.key) : $($tag.value)"
        }

# Have line breaks
Write-Output ""
Write-Output "================================="
Write-Output ""

}

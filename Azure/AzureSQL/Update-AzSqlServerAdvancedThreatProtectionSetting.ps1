<#
Script to update Azure SQL Server Threat Protection email address setting 
#>

# Get All Subscription
$AzSubs = Get-AzSubscription
# Email address to be changed to
$emailaddress = "Your Email Address"
# Loop through all subs
foreach ($AzSub in $AzSubs)
    {
    # Set subscription context
    Set-AzContext $azsub.id
    # Get all Azure SQL Servers
    $AzSQLServers = Get-AzSqlServer
        foreach ($AzSQLServer in $AzSQLServers)
            {
                # Update with new email address for Threat Protection
                Update-AzSqlServerAdvancedThreatProtectionSetting -ResourceGroupName $AzSQLServer.ResourceGroupName -ServerName $AzSQLServer.ServerName -NotificationRecipientsEmails $emailaddress
            }
    }

<#
Script to get Azure SQL Server Threat Protection email address setting to store in custom object 
which can output to csv file for later use
#>

# Get All Subscription
$AzSubs = Get-AzSubscription
# Variable to sort results
$SQLCSV = @()
# Loop through all subs
foreach ($AzSub in $AzSubs)
{
    # Set subscription context
    Set-AzContext $azsub.id
    # Get all Azure SQL Servers
    $AzSQLServers = Get-AzSqlServer
        # Loop through all servers
        foreach ($AzSQLServer in $AzSQLServers)
        {
            # Get SQL Server Threat Settings
            $AzServerThreat = Get-AzSqlServerAdvancedThreatProtectionSetting -ResourceGroupName $AzSQLServer.ResourceGroupName -ServerName $AzSQLServer.ServerName
            # Store objects needed
            $PSCustom = [PSCustomObject]@{
                ServerName        = $AzServerThreat.ServerName
                ResourceGroup     = $AzServerThreat.ResourceGroupName 
                NotificationEmail = $AzServerThreat.NotificationRecipientsEmails
                }
    # Add to object
    $SQLCSV += $PSCustom
        }
}

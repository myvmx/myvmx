<# 
Get threat protection settings for databases
#>

# Get All Subscription
$AzSubs = Get-AzSubscription
# Variable to sort results
$SQLCSV = @()
# Loop through all subscriptions
foreach ($AzSub in $AzSubs)
    {
    # Set Scope for subscription
    Set-AzContext $azsub.id
    #Get all SQL Servers
    $AzSQLServers = Get-AzSqlServer
    # Loop through all SQL Servers    
    foreach ($AzSQLServer in $AzSQLServers)
        {
        # Get Vulnerability Settings for each database 
        foreach ($dbs in (Get-AzSqlDatabase -ResourceGroupName $AzSQLServer.ResourceGroupName -ServerName $AzSQLServer.ServerName))
            {
            # Get database settings
            $dbsvul = Get-AzSqlDatabaseAdvancedThreatProtectionSetting -ServerName $dbs.ServerName -ResourceGroupName $dbs.ResourceGroupName -DatabaseName $dbs.databasename 
            # Store in custom object
            $PSCustom = [PSCustomObject]@{
                ServerName        = $dbsvul.ServerName
                DatabaseName      = $dbsvul.DatabaseName
                ResourceGroup     = $dbsvul.ResourceGroupName 
                NotificationEmail = $dbsvul.NotificationRecipientsEmails
                }
            # Add to variable the results
            $SQLCSV += $PSCustom
            }
        }
    }

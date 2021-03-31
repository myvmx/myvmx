<#
To create new Action group in a specific location you decide and add emails to the action group
Below example shows adding two email addresses
#>

$Sub = "Subscription ID"
$ActionGroupName = "Name of Action Group"
# Max character is 12 so we take a short from main Action Group Name
$ActionGroupShortName = $ActionGroupName.Substring(0,12) 
$ActionGroupRG = "Location "

# Email addresses variables
$email1 = New-AzActionGroupReceiver -EmailAddress "user1@abc.com" -Name "user1"
$email2 = New-AzActionGroupReceiver -EmailAddress "user2@abc.com" -Name "user2"

# Switch to context of subscription to create Action Group
Set-AzContext -Subscription $sub
Set-AzActionGroup -Name $ActionGroupName -ShortName $ActionGroupShortName -Receiver $email1, $email2 -ResourceGroupName $ActionGroupRG

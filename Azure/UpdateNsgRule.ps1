### Update Existing NSG where we are changing the IP range

## Variables to change
$nsgName = "NSG Names"
$nsgRGName = "NSG Resource Group"
$nsgRuleName = "NSG Rule Name to change"
$ips = @("1.1.1.0/24","192.168.1.0/24")

## Get the NSG and the rule itself
$nsg = Get-AzNetworkSecurityGroup -Name $nsgName -ResourceGroupName $nsgRGName
$rule= $nsg | Get-AzNetworkSecurityRuleConfig -Name $nsgRuleName  

## Update the rule to whatever you want this example we doing IP address
Set-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg `
     -Name $NsgRuleName `
     -Access $rule.Access `
     -Protocol $rule.Protocol `
     -Direction $rule.Direction `
     -Priority $rule.Priority `
     -SourceAddressPrefix $ips `
     -SourcePortRange $rule.SourcePortRange `
     -DestinationAddressPrefix $rule.DestinationAddressPrefix `
     -DestinationPortRange $rule.DestinationPortRange

## Update the NSG
$nsg | Set-AzNetworkSecurityGroup

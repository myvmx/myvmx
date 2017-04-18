######################################
## Get Group Membership 
## Author : Kin Yung
## 18/04/2017

## Store Group Name
$groupname = "Group Name"
## Get the group and store the value
$group = get-adgroup -Filter {name -eq $groupname}
## Get the members within the group and just select name column
Get-ADGroupMember -Identity $group | select Name

## Single line code
Get-ADGroupMember -Identity $(get-adgroup -Filter {name -eq "Group Name"}) | select Name

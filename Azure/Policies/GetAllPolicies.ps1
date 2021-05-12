<#
Gets all the built-in policies and outputs to a csv
Includes the category, default value of policy if applicable and valid values
#>

$policycsv = @()
$policies = Get-AzPolicyDefinition -Builtin
foreach ($policy in $policies) {
    write-host $policy.Properties.DisplayName
    $category = $policy.properties.metadata.category
    If($policy.Properties.Parameters.effect -ne $null)
    {
        $effect = $policy.Properties.Parameters | Select-Object -ExpandProperty effect
        $defaultvalue = $effect.defaultValue
        $allowedvalues = [string]$effect.allowedValues
    }
    $tempObj = New-Object PSObject -Property @{
            ResourceId = $policy.ResourceId;
            DisplayName = $policy.properties.displayName;
            description = $policy.properties.description;
            Category = $category;
            Version = $policy.properties.Metadata.version
            #parameters = $policy.Properties.Parameters
            defaultvalue=$defaultvalue;
            allowedvalues = $allowedValues
            }
    $policycsv += $tempObj | Select-Object ResourceId, DisplayName, description, Category, defaultvalue, allowedvalues, Version
    # reset the values to be null
    $defaultvalue = $null
    $allowedvalues = $null
}
# Export to csv at the current directory of where the script is running with the current date and time of when the script was running
$policycsv | Sort-Object DisplayName | Export-Csv ".\policies-$(get-date -UFormat('%d%m%y-%H%M')).csv" -NoTypeInformation

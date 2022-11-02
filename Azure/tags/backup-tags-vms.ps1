# Initialise output array
$Output = @()

# Collect all VMs from the current subscription
$VMs = Get-AzResource -ResourceType Microsoft.Compute/virtualMachines

# Obtain a unique list of tags for these groups collectively
# Use Sort-Object as per - https://github.com/PowerShell/PowerShell/issues/12059
$UniqueTags = $VMs.Tags.GetEnumerator().Keys | Sort-Object -Unique

# Loop through the VMs
foreach ($VM in $VMs) {
    # Create a new ordered hashtable and add the normal properties first.
    $VMHashtable = [ordered] @{}
    $VMHashtable.Add("Name",$VM.Name)
    $VMHashtable.Add("Location",$VM.Location)
    $VMHashtable.Add("Id",$VM.ResourceId)

    # Loop through possible tags adding the property if there is one, adding it with a hyphen as it's value if it doesn't.
    if ($VM.Tags.Count -ne 0) {
        $UniqueTags | Foreach-Object {
            if ($VM.Tags[$_]) {
                $VMHashtable.Add("$_ (Tag)",$VM.Tags[$_])
            }
            else {
                $VMHashtable.Add("$_ (Tag)","-")
            }
        }
    }
    else {
        $UniqueTags | Foreach-Object { $VMHashtable.Add("$_ (Tag)","-") }
    }

    # Update the output array, adding the ordered hashtable we have created for the VM details.
    $Output += New-Object psobject -Property $VMHashtable
}

# Sent the final output to CSV
$Output | Export-Csv -Path C:\csv\ipsldev.csv -NoClobber -NoTypeInformation -Encoding UTF8

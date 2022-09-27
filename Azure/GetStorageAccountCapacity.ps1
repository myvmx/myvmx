# To get storage account capacity average usage over a period of time, very rough output

$subs = Get-AzSubscription
 foreach ($sub in $subs)
 {
    Set-AzContext -Subscription $sub.Name
    $StorageAccounts = Get-AzResource -ResourceType "Microsoft.Storage/storageAccounts"
        foreach ($StorageAccount in $StorageAccounts)
            {

                #Start-Sleep -Milliseconds 300
                $StorInfo = Get-AzStorageAccount -ResourceGroupName $StorageAccount.ResourceGroupName -Name $StorageAccount.Name
                $usedCapacity = (Get-AzMetric -ResourceId $StorInfo.Id -MetricName "UsedCapacity" -StartTime (get-date).adddays(-1) -EndTime (Get-Date)).Data
                $usedCapacityInMB = $usedCapacity.Average | select -first 1 
                $usedCapacityInMB = $usedCapacityInMB / 1024 / 1024
                
                $StorageAccountName = $StorageAccount.resourceName
                $StorageRGName = $StorageAccount.ResourceGroupName
                $SubName = $sub.Name
                $Storkind = $StorInfo.kind
                $Stortier = $storinfo.AccessTier
                $storskuname = $StorInfo.Sku.name
                $storskuperformance = $storinfo.sku.tier
                "$StorageAccountName,$usedCapacityInMB,$StorageRGName,$SubName,$storkind, $stortier, $storskuname, $storskuperformance" >> ".\UsedCapacity.csv"
                $StorageAccountName
                $usedCapacityInMB
                $subname
                $storkind
                $stortier
                $storskuname
                $storskuperformance

            }
}

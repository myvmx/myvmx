##########################################
## To list all the failed jobs in Azure Recovery Backup within a time frame
## Author : KY
## Date : 18/04/2017
##########################################

## Get all the vaults
$vaults = Get-AzureRmRecoveryServicesVault 

## Loop through each of the vaults
foreach ($vault in $vaults)
{
  ## Write the name of the current vault
  write-host $vault.Name
  ## Set the vault context
  Set-AzureRmRecoveryServicesVaultContext -Vault $vault
  ## Get all jobs with the status failed within a time frame
  $failedJobs = Get-AzureRmRecoveryServicesBackupJob -Status Failed -From (Get-date).AddHours(-24).ToUniversalTime()
    ## Loop through each failed job
    Foreach ($failedjob in $failedjobs)
    {
      ## Write the name of the failed job to screen
      write-host $failedjob.WorkloadName
    }
}

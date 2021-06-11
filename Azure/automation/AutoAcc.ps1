## To get information of the automation account that initiated the runbook

## Get all automation account information that it has permissions to
$AutomationResource = Get-AzResource -ResourceType Microsoft.Automation/AutomationAccounts

## Go through each account and find the job id that matches the one that is running
foreach ($Automation in $AutomationResource)
{
    $Job = Get-AzAutomationJob -ResourceGroupName $Automation.ResourceGroupName -AutomationAccountName $Automation.Name -Id $PSPrivateMetadata.JobId.Guid -ErrorAction SilentlyContinue
    if (!([string]::IsNullOrEmpty($Job)))
    {
        $ResourceGroup = $Job.ResourceGroupName
        $AutomationAccount = $Job.AutomationAccountName
        break;
    }
}

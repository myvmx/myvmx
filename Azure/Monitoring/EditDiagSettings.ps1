#To change the log analytics workspace path for all resources that have diagnostics settings enabled


$WorkspaceId = "Full resource ID path of log analytics workspace
$resources = Get-AzResource

foreach ($resource in $resources)
{
  $diag = Get-AzDiagnosticSetting -ResourceId $resource.resourceid -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    if ($diag.name -ne $null)
      {
      write-host $diag.Name
      write-host $diag.id
      Get-AzDiagnosticSetting -ResourceId $resource.resourceid |Set-AzDiagnosticSetting -ResourceId $resource.resourceid -WorkspaceId $WorkspaceId
      }
}

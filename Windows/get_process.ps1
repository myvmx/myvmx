get-process
<#
$ScriptFromGitHub = Invoke-WebRequest https://raw.githubusercontent.com/myvmx/myvmx/master/Windows/get_process.ps1
Invoke-Expression $($ScriptFromGitHub.Content)#>


<#
Invoke-WebRequest https://raw.githubusercontent.com/myvmx/myvmx/master/Windows/get_process.ps1  -OutFile c:\stuff\get_process.ps1#>

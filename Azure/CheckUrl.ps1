<#
Function to check website where it just returns the IP address of your machine as a page content. 
Default is to return the IP address

Checks if the site is return code 200, 
- If it does then the function returns the content from the function
- If it doesn't then it keeps trying until your $maxRetries limit is hit

Example usage:
chkurl
chkurl -contentReturn $false
chkurl -url http://www.google.com
chkurl -url http://www.google.com -contentReturn $false
#>
function chkurl {
    param (
        [string]$url = "http://ifconfig.me/ip",
        [bool]$contentReturn = $true
    )

    # Variables
    $attempt = 1
    $maxRetries = 20
    $delaySeconds = 10

    # Print URL testing
    Write-Host "URL to check: $url"

    while ($attempt -le $maxRetries) {
        Write-Host "Attempt Number: $attempt"
        try {
            $response = Invoke-WebRequest -Uri $url -ErrorAction Stop

            if ($response.StatusCode -eq 200) {
                Write-Host "Site is reachable and returning status 200"
                # Check whether to return content based on boolean value $contentReturn
                if ($contentReturn) {
                    Write-Host "Returning content from page"
                    return $response.Content
                } else {
                    Write-Host "Not returning content from page"
                    return
                }
            } else {             
            }

        } catch {
            Write-Warning "Attempt $attempt failed: $($_.Exception.Message)"
        }

        $attempt++
        Write-Host "Sleeping for $delaySeconds seconds..."
        Start-Sleep -Seconds $delaySeconds
    }

    Write-Host "Max attempts reached. URL did not return status 200."
}

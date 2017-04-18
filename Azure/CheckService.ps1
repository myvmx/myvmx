##########################################
## Must run powershell using your admin account and have permissions to the server
## Used to get service and then restart the server 
##
## Author Kin Yung 18/04/2017
###########################################

## Import csv file where all the computer names are
## CSV file just has heading of name
$ComputerCSV = Import-Csv "path of your csv file"

## Gets the azure services and restarts the agent
foreach ($computer in $ComputerCSV)
  {
    Write host $computer.name
    ## Gets the service Azure Guest Agent and restarts the service
    get-service -ComputerName $Computer.name -DisplayName "Windows Azure Guest Agent" | Restart-Service
  }

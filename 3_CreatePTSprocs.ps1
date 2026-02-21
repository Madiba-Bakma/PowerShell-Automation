#Import-Module dbatools

$servers        = Get-Content '\\JUMPBOX\Servers\ListOfServers.txt'
$BackupLocation = 'I:\MSSQL\Backup'
$dbName         = "DBA"


foreach($server in $servers){

# Connect to each server
$ConnectSvr     = Connect-DbaInstance -SqlInstance $server -TrustServerCertificate

# Create a new database named DBA
New-DbaDatabase -SqlInstance $ConnectSvr -Name $dbName #-WhatIf 

# Create the DBA MultiTool sprocs in the DBA database
Install-DbaMultiTool -SqlInstance $ConnectSvr -Database $dbName #-WhatIf

# Create the Ola Hallengren Maintenance Solution sprocs and jobs in the DBA database
Install-DbaMaintenanceSolution -SqlInstance $ConnectSvr -Database $dbName -InstallJobs -BackupLocation $BackupLocation -CleanupTime 72 #-WhatIf

# Create the First Responder Kit sprocs by Brent Ozar in the DBA database
Install-DbaFirstResponderKit -SqlInstance $ConnectSvr -Database $dbName #-WhatIf

# Create sp_WhoIsActive sproc by Adam Machanic in the DBA database
Install-DbaWhoIsActive -SqlInstance $ConnectSvr -Database DBA #-WhatIf

}
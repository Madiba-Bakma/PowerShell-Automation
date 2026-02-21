#Import-Module dbatools

$userAcc       = "VM\adeisadba"
$password      = Get-Content 'C:\mysecurestring.txt' | ConvertTo-SecureString
$user_cred     = new-object -typename System.Management.Automation.PSCredential `
                -argumentlist $userAcc, $password
$BackupPath    = "\\JUMPBOX\SqlBackup"
$userScript    = "\\JUMPBOX\DBUsers\DBUsers.sql"
$dbName        = "DBA"
$prod          = Connect-DbaInstance -SqlInstance 'VM01' -TrustServerCertificate
$dev           = Connect-DbaInstance -SqlInstance 'VM02' -TrustServerCertificate

# Script out database users in the destination
Export-DbaUser -SqlInstance $dev -Database $dbName -FilePath $userScript -Verbose 

# Copy the database from source to destination using backup-restore method and replace the existing database
Copy-DbaDatabase -Source $prod -Destination $dev -Database $dbName -BackupRestore -SharedPath $BackupPath -WithReplace -Verbose #-WhatIf 

# Set database owner to "sa"
Set-DbaDbOwner -SqlInstance $dev -Database $dbName -TargetLogin sa -Verbose #-WhatIf

# Execute the users script to return destination database users
Invoke-DbaQuery -SqlInstance $dev -Database $dbName -File $userScript -Verbose 






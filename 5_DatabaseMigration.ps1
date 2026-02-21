#Import-Module dbatools

$userAcc       = "VM\adeisadba"
$password      = Get-Content 'C:\mysecurestring.txt' | ConvertTo-SecureString
$user_cred     = new-object -typename System.Management.Automation.PSCredential `
                -argumentlist $userAcc, $password

$Source        = Connect-DbaInstance -SqlInstance 'VM01' -TrustServerCertificate
$Destination   = Connect-DbaInstance -SqlInstance 'VM03' -TrustServerCertificate

$params = @{
 SourceSqlCredential         = $user_cred
 DestinationSqlCredential    = $user_cred
 SharedPath                  = "\\JUMPBOX\SqlBackup"
 BackupRestore               = $true
 IncludeSupportDbs           = $true
 DisableJobsOnDestination    = $true
 Force                       = $true
 }

Start-DbaMigration @params -Source $Source -Destination $Destination -Verbose #-WhatIf 

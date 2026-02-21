#Import-Module dbatools

#
# Run this to save your password in a secure encrypted file
#
#read-host -assecurestring | convertfrom-securestring | out-file C:\mysecurestring.txt


$userAcc                      = "VM\adeisadba"
$svcAcc                       = "VM\svc_sqlserver"
$saAcc                        = "sa"
$password                     = Get-Content 'C:\mysecurestring.txt' | ConvertTo-SecureString
$user_cred                    = new-object -typename System.Management.Automation.PSCredential `
                                -argumentlist $userAcc, $password
$svc_cred                     = new-object -typename System.Management.Automation.PSCredential `
                                -argumentlist $svcAcc, $password
$sa_cred                      = new-object -typename System.Management.Automation.PSCredential `
                                -argumentlist $saAcc, $password

$servers                      = Get-Content '\\JUMPBOX\Servers\ListOfServers.txt'

$config                       = @{
SqlInstance                   = $servers 
Version                       = "2017"
SaCredential                  = $sa_cred
Credential                    = $user_cred
Feature                       = "Default"    
AuthenticationMode            = "Mixed"
InstancePath                  = "D:\MSSQL\Root"
DataPath                      = "D:\MSSQL\Data"
LogPath                       = "L:\MSSQL\Log"
TempPath                      = "T:\MSSQL\TempDB"
BackupPath                    = "I:\MSSQL\Backup"
EngineCredential              = $svc_cred
AgentCredential               = $svc_cred
SaveConfiguration             = $true
PerformVolumeMaintenanceTasks = $true
Restart                       = $true
}



Set-DbatoolsConfig -Name Path.SQLServerSetup -Value '\\JUMPBOX\SqlServerSetup' 
Install-DbaInstance @config  -Verbose #-WhatIf

# Confirm SQL Server services are running
#Get-DbaService -ComputerName $servers
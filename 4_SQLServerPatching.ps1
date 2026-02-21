#Import-Module dbatools

$servers      = Get-Content '\\JUMPBOX\Servers\ListOfServers.txt'
$KBPath       = '\\Jumpbox\kb'
$userAcc      = "VM\adeisadba"
$password     = Get-Content 'C:\mysecurestring.txt' | ConvertTo-SecureString
$user_cred    = new-object -typename System.Management.Automation.PSCredential `
                -argumentlist $userAcc, $password

# Get updated information about the current build of the instance
#Get-DbaBuildReference -Update

# Download and install latest cumulative updates
Update-DbaInstance -ComputerName $servers -Credential $user_cred -Download -Path $KBPath -Restart #-WhatIf


# Install already downloaded cumulative updates
#Update-DbaInstance -ComputerName $servers -Credential $user_cred -KB 5016884 -Path $KBPath -Restart -WhatIf






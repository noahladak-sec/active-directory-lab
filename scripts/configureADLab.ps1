
# configureADLab.ps1
# Sets up Active Directory Domain Services and promotes the server to a Domain Controller

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment

Install-ADDSForest `
    -DomainName "adproject.local" `
    -DomainNetbiosName "ADPROJECT" `
    -SafeModeAdministratorPassword (ConvertTo-SecureString "YourSafeModePassword123!" -AsPlainText -Force) `
    -InstallDNS `
    -Force:$true

** Replace "YourSafeModePassword123!" with your actual Directory Services Restore Mode (DSRM) password.

# create-users.ps1
# Bulk creates 500 users each in "HR" and "IT" Organizational Units

# Define domain and OU paths
$domain = "adproject.local"  # Replace with your domain name
$domainDN = "DC=adproject,DC=local"  # Replace with your domain's DN

# Create HR and IT OUs if they don't already exist
If (-Not (Get-ADOrganizationalUnit -Filter "Name -eq 'HR'")) {
    New-ADOrganizationalUnit -Name "HR" -Path $domainDN -ProtectedFromAccidentalDeletion $false
}
If (-Not (Get-ADOrganizationalUnit -Filter "Name -eq 'IT'")) {
    New-ADOrganizationalUnit -Name "IT" -Path $domainDN -ProtectedFromAccidentalDeletion $false
}

# Function to create users in bulk
function Create-Users {
    param(
        [string]$OUName,
        [int]$UserCount
    )

    $OUPath = "OU=$OUName,$domainDN"
    
    1..$UserCount | ForEach-Object {
        $username = "$($OUName)User$_"  # e.g., HRUser1, ITUser2
        $password = ConvertTo-SecureString "XXXXXXX" -AsPlainText -Force
        
        New-ADUser -Name $username `
                   -SamAccountName $username `
                   -UserPrincipalName "$username@$domain" `
                   -AccountPassword $password `
                   -Enabled $true `
                   -Path $OUPath `
                   -ChangePasswordAtLogon $false
    }
}

# Create 500 users in HR OU
Create-Users -OUName "HR" -UserCount 500

# Create 500 users in IT OU
Create-Users -OUName "IT" -UserCount 500

Write-Output "HR and IT OUs and users created successfully!"

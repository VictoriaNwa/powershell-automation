$users = Import-Csv "C:\LearnPs\AccountCreation\new-hires.csv"

$password = Read-Host "Enter temporary password" -AsSecureString

#Go through each new hire and create their account in Active Directory
foreach ($user in $users) {
	$firstName = $user.FirstName
	$lastName = $user.LastName
    $department = $user.Department

	$fullName = "$firstName $lastName"
	$firstInitial = $firstName[0]
	$username = "$firstInitial$lastName".ToLower()
 
    $ouPath = "OU=$department,OU=Users,OU=NWATech,DC=lab,DC=com"

	$existing = Get-ADUser -Filter "SamAccountName -eq '$username'"
	if ($existing) {
        Write-Host "$username = account already exists, skipping..."

	} else {

		New-ADUser `
		-Name $fullName `
		-GivenName $firstName `
		-Surname $lastName `
		-SamAccountName $username `
		-UserPrincipalName "$username@lab.com" `
		-Path $ouPath `
		-AccountPassword $password `
		-Enabled $true `
        -ChangePasswordAtLogon $true
	}
}

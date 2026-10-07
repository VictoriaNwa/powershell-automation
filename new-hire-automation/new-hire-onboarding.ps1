# Import CSV file and save it under the variable "users"
$users = Import-Csv ".\new-hires.csv"

# Prompt the administrator for a temporary password. New hires must change it at first logon.
$password = Read-Host "Enter temporary password" -AsSecureString

# Go through each new hire and create their account in Active Directory
foreach ($user in $users) {
	$firstName = $user.FirstName
	$lastName = $user.LastName
    $department = $user.Department

	$fullName = "$firstName $lastName"
	$firstInitial = $firstName[0]
	$username = "$firstInitial$lastName".ToLower()

 	# Build the OU path based on the new hire's department
    $ouPath = "OU=$department,OU=Users,OU=NWATech,DC=lab,DC=com"

	# Check whether the account already exists and skip account creation if found
	$existing = Get-ADUser -Filter "SamAccountName -eq '$username'"
	if ($existing) {
        Write-Host "$username = account already exists, skipping..."

	#If user does not exist, create their account with these parameters
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

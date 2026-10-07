AD New Hire Automation

This project automates the creation of new Active Directory user accounts from a CSV file using PowerShell.

The script:
- Imports new hire information from a CSV file
- Generates usernames using first initial + last name
- Places users into department-specific OUs
- Checks whether an account already exists
- Creates new accounts with a temporary password
- Enables the account
- Forces users to change their password at first logon

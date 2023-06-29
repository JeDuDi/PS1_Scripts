# Output will be added to C:\temp folder. Open the Add-SMTP-Address.log with a text editor. For example, Notepad.
Start-Transcript -Path C:\temp\Add-SMTP-Address.log -Append

# Get all mailboxes
$Mailboxes = Get-Mailbox -ResultSize Unlimited | Where-Object { $_.MailboxPlan -like "" }

# Loop through each mailbox
foreach ($Mailbox in $Mailboxes) {

    # Search for specified SMTP address in every mailbox
    $SMTPAddress = $Mailbox.EmailAddresses | Where-Object { $_ -like "*@cbtwoarch.com" }
      
    # Do nothing when there is already an SMTP address configured
    If (($SMTPAddress | Measure-Object).Count -eq 0) {
	
        # Change @contoso.com to the domain that you want to add
        $Address = "$($Mailbox.Alias)@cbtwoarch.com"

        # Remove the -WhatIf parameter after you tested and are sure to add the secondary email addresses
        Set-Mailbox $Mailbox.DistinguishedName -EmailAddresses @{add = $Address } -WhatIf

        # Write output
        Write-Host "Adding $($Address) to $($Mailbox.Alias) Mailbox" -ForegroundColor Green
    }
}

Stop-Transcript
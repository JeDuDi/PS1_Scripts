#Connect to Exchange Online
Connect-ExchangeOnline

Get-TransportRule -Identity "Microsoft Purview Message Encryption" | Format-List

New-TransportRule       -Name "Microsoft Purview Message Encryption" `
                        -Mode Enforce `
                        -SentToScope NotInOrganization `
                        -Priority 0 `
                        -MessageContainsDataClassifications @(@{Name =”ABA Routing Number”; minCount = “1”},@{Name =”Credit Card Number”;minCount=”1" },@{Name =”U.S. / U.K. Passport Number”;minCount=”1" },@{Name =”U.S. Bank Account Number”;minCount=”1" },@{Name =”U.S. Driver's License Number”;minCount=”1" },@{Name =”U.S. Individual Taxpayer Identification Number (ITIN)”;minCount=”1" },@{Name =”U.S. Social Security Number (SSN)”;minCount=”1" }) `
                        -SetAuditSeverity Low `
                        -ApplyRightsProtectionTemplate Encrypt 
<#

    .PURPOSE
        The purpose of the script is to view the current Transport Rules and the ExternalInOutlook property in Exchange Online per tenant.
        After viewing the current status, you can run the lines of code to create a new Transport Rule and set the ExternalInOutlook property which will begin flagging external emails within 48 hours of setup.
        Look for properties that should be customized such as -AllowList and the $SisterDomains variable as they should contain trusted domains that should not be flagged as external.
        You only need to set this for sister domains OUTSIDE of the current tenant you're working on. A single tenant with multiple domains does not need an allow list.
    
    .NOTES
        Created: 1/2/23 by JD

#>


###### Connect to Exchange Online #####
Connect-ExchangeOnline


##### Get Outlook external sender warning status #####
Get-ExternalInOutlook


###### Turn on the feature and list the exceptions for any sister domains NV #####
Set-ExternalInOutlook -Enabled $true -AllowList @{Add="domain1.com","domain2.com","etc"}

Set-ExternalInOutlook -Enabled $true
Get-ExternalInOutlook

##### View current transport rules - Make sure other rules aren't set to stop processing! #####
Get-TransportRule


##### Use this line to view detail on a specific rule #####
Get-TransportRule -Identity "Stop Unwanted Teams e-mails" | Format-List


##### BEGIN - Transport Rule Creation #####

#Set variable for the HTML required for the disclaimer itself
$HTMLDisclaimer = '<!-- Yellow Banner -->
					 <table border=0 cellspacing=0 cellpadding=0 align="left" width="100%">
						<tr>
							<td style="background:#fcca03;padding:5pt 2pt 5pt 2pt"></td>             
								<td width="100%" cellpadding="7px 6px 7px 15px" style="background:#f7f7f7;padding:5pt 4pt 5pt 12pt;word-wrap:break-word">
								<div style="color:#545453;">
									<span style="color:#545453; font-weight:bold;">Caution:</span>
									This is an external email and may be malicious.
								</div>
							</td>
						</tr>
					   </table>
					   <br /><br />'

#Set variable for sister domains not to be flagged - Remove from New-TransportRule if no sister domains exist
$SisterDomains = @('domain1.com','domain2.com','etc')

# Create new Transport Rule
New-TransportRule -Name "External Sender Disclaimer" `
                  -FromScope NotInOrganization `
                  -ExceptIfSenderDomainIs $SisterDomains `
                  -ApplyHtmlDisclaimerLocation Append `
                  -ApplyHtmlDisclaimerText $HTMLDisclaimer `
                  -ApplyHtmlDisclaimerFallbackAction Wrap `
                  -Comments "This rule appends a disclaimer on each external email." `
                  -SetAuditSeverity Low `
                  -Mode Enforce `
                  -Priority 1 `
                  -Enabled $true












#Set variable for the HTML required for the disclaimer itself
$HTMLDisclaimer = '<!-- Yellow Banner -->
					 <table border=0 cellspacing=0 cellpadding=0 align="left" width="100%">
						<tr>
							<td style="background:#fcca03;padding:5pt 2pt 5pt 2pt"></td>             
								<td width="100%" cellpadding="7px 6px 7px 15px" style="background:#f7f7f7;padding:5pt 4pt 5pt 12pt;word-wrap:break-word">
								<div style="color:#545453;">
									<span style="color:#545453; font-weight:bold;">Caution:</span>
									This is an external email and may be malicious.
								</div>
							</td>
						</tr>
					   </table>
					   <br /><br />'

# Create new Transport Rule no sister domains
New-TransportRule -Name "External Sender Disclaimer" `
                  -FromScope NotInOrganization `
                  -ApplyHtmlDisclaimerLocation Append `
                  -ApplyHtmlDisclaimerText $HTMLDisclaimer `
                  -ApplyHtmlDisclaimerFallbackAction Wrap `
                  -Comments "This rule appends a disclaimer on each external email." `
                  -SetAuditSeverity Low `
                  -Mode Enforce `
                  -Priority 1 `
                  -Enabled $true


##### END - Transport Rule Creation #####

Get-TransportRule


##### Disconnect from Exchange Online #####
Disconnect-ExchangeOnline


##### That's it. Log onto the client domain and test if possible. #####
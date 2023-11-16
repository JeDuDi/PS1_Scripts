<#

    .PURPOSE
        Deploys a standard DLP policy to an M365 tenant. 
    .NOTES
        Created by JeDuDi

#>

#Connect to O365 Security and Compliance Center
Connect-IPPSSession

#Read all properties of the DLP policy
Get-DlpCompliancePolicy

#Get DLP types for policy variables
#Get-DlpSensitiveInformationType | Where { $_.Name -Like "*credit*"}

#Define policy variables
$dlp_PolicyName = "Standard DLP Policy"
$dlp_Comment = "This standard DLP policy is set to warn the sender if sensitive data being sent to an outside party. "

###### UPDATE THIS!!!!!!!!!!
$admin_target = "name@domain.com"

#Create TLIT standard DLP policy
New-DlpCompliancePolicy -Name $dlp_PolicyName `
                        -Comment $dlp_Comment `
                        -Mode Enable `
                        -ExchangeLocation All `
                        -TeamsLocation All `
                        -Priority 0

#Create rules for policy to notify on sensitive data types
New-DlpComplianceRule -Name "Standard Sensitive Data Types" `
                        -Policy $dlp_PolicyName `
                        -ContentContainsSensitiveInformation @(@{Name =”ABA Routing Number”; minCount = “1”},@{Name =”Credit Card Number”;minCount=”1" },@{Name =”U.S. / U.K. Passport Number”;minCount=”1" },@{Name =”U.S. Bank Account Number”;minCount=”1" },@{Name =”U.S. Driver's License Number”;minCount=”1" },@{Name =”U.S. Individual Taxpayer Identification Number (ITIN)”;minCount=”1" },@{Name =”U.S. Social Security Number (SSN)”;minCount=”1" }) `
                        -AccessScope NotInOrganization `
                        -BlockAccess $False `
                        -ReportSeverityLevel High `
                        -GenerateAlert $admin_target `
                        -GenerateIncidentReport SiteAdmin `
                        -NotifyUser LastModifier `
                        -NotifyEmailCustomText "This is a warning to let you know that your recent email sent to an external party contained sensitive information. If this was done in error, please contact management to report this incident. Otherwise, if your email required the sending of sensitive information to an external party, the outbound email was encrypted by default. " `
                        -NotifyEmailCustomSubject "Warning: Your recent email contained sensitive information" `
                        -NotifyPolicyTipCustomText "Your email contains sensitive information that will be sent to an external party. Please remove any unnecessary sensitive information from your email. Otherwise, your email can still be sent but will be encrypted by default. " `
                        -IncidentReportContent Title, DocumentAuthor, DocumentLastModifier, Service, MatchedItem, RulesMatched, Detections, Severity, DetectionDetails, OriginalContent, RetentionLabel, SensitivityLabel `
          
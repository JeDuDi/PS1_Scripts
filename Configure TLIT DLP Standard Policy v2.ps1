#Define policy variables
$params = @{
‘Name’ = ‘Australian Privacy Act’;
‘ExchangeLocation’ =’All’;
‘OneDriveLocation’ = ‘All’;
‘SharePointLocation’ = ‘All’;
‘Mode’ = ‘Enable’
}

#Create policy
new-dlpcompliancepolicy @params

#Establish sensitive info targets
$senstiveinfo = @(@{Name =”Australia Driver’s License Number”; minCount = “1”},@{Name =”Australia Passport Number”;minCount=”1" })

#Establish rule variables
$Rulevalue = @{
‘Name’ = ‘Low volume of content detected Australia Privacy Act’;
‘Comment’ = “Helps detect the presence of information commonly considered to be subject to the privacy act in Australia, like driver’s license and passport number.”;
‘Policy’ = ‘Australian Privacy Act’;
‘ContentContainsSensitiveInformation’=$senstiveinfo;
‘BlockAccess’ = $true;
‘AccessScope’=’NotInOrganization’;
‘BlockAccessScope’=’All’;
‘Disabled’=$false;
‘GenerateAlert’=’SiteAdmin’;
‘GenerateIncidentReport’=’SiteAdmin’;
‘IncidentReportContent’=’All’;
‘NotifyAllowOverride’=’FalsePositive,WithJustification’;
‘NotifyUser’=’Owner’,’SiteAdmin’,’LastModifer’
}

#Create rule and assign to policy
New-dlpcompliancerule @rulevalue
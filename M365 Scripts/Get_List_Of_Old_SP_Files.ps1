#Config Variables
$SiteURL = "https://nwrestorationcom.sharepoint.com/sites/NorthwestRestoration"
$LibraryName = "Documents"
   
#Connect to PnP Online
Connect-PnPOnline -Url $SiteURL -Interactive
 
#Define Query to Filter Files that were 'Created' 30 days ago (or More!)
$Query= "<View Scope='RecursiveAll'>
            <Query>
                <Where>
                    <And>
                        <Lt>
                            <FieldRef Name='Created' Type='DateTime'/>
                            <Value Type='DateTime' IncludeTimeValue='TRUE'>
                                <Today OffsetDays='-1825'/>
                            </Value>
                        </Lt>
                        <Eq>
                            <FieldRef Name='FSObjType' /><Value Type='Integer'>0</Value>
                        </Eq>
                    </And>
                </Where>
            </Query>
        </View>"
 
#Get All Files matching the query
$Files = Get-PnPListItem -List $LibraryName -Query $Query 
   
#Loop through each File
Write-host -f Green "Total Number of Files Found:"$Files.Count


#Read more: https://www.sharepointdiary.com/2019/04/sharepoint-online-delete-files-older-than-30-days-using-powershell.html#ixzz8C6aEfBDy
# This script only returns folders that have permissions inheritance turned off. A true result means inheritence is off.
# You will need to set your directory under the dir field below. The script may take a long time to complete if you're assessing an entire drive.
dir "C:\Users" -Directory -recurse | get-acl |
Where {$_.AreAccessRulesProtected} |
Select @{Name="Path";Expression={Convert-Path $_.Path}},AreAccessRulesProtected |
format-table -AutoSize
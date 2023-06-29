##### Author: Jesse Dickens #####
##### Created: 6/2/23 #####
##### Modified: 6/2/23 #####
##### Purpose: Install Accuterm 8 and uninstall Accuterm 7 silently #####

#Start log entry
$logoutput = "Starting Accuterm 8 upgrade"
$SB = New-Object -TypeName System.Text.StringBuilder
New-EventLog –LogName Application –Source 'AccutermUpgrade'

#Download necessary Accuterm setup files
$logoutput = $SB.Append("`n Starting file download")
wget "https://appriver3651000028-my.sharepoint.com/:u:/g/personal/jdickens_teamlogicit_com/EaTYhQfsVaZCsNAnbJPpx7MB6Njr4X5fRf8G2_TlJfgSsA?download=1" -OutFile "C:\temp\accuterm8.exe"
wget "https://appriver3651000028-my.sharepoint.com/:u:/g/personal/jdickens_teamlogicit_com/EWUj0I6euhdNmyMo6enAHO0BOBJh1Wq1n_LPWkTOLb7l3w?download=1" -OutFile "C:\temp\setup.ini"

#Verify files downloaded correctly and then proceed with install
if ((Test-Path -Path "C:\temp\accuterm8.exe" -PathType Leaf) -and (Test-Path -Path "C:\temp\setup.ini" -PathType Leaf)) {
    
    Try {
        #Run the Accuterm 8 installer
        $logoutput = $SB.Append("`n File download verified, attempting to install")
        C:\temp\accuterm8.exe /verysilent

        #Uninstall Accuterm 7
        $logoutput = $SB.Append("`n Install succeeded, uninstalling Accuterm 7")
        $at7 = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Accuterm 7"}
        $at7.Uninstall()

        #Output exiting log to Application Logs
        $logoutput = $SB.Append("`n Uninstalled Accuterm 7, exiting")
        Write-EventLog -LogName "Application" -Source "AccutermUpgrade" -EventID 123 -EntryType Information -Message $logoutput -Category 1 -RawData 10,20
    }
    Catch {
        #Output exiting log to Application Logs
        $logoutput = $SB.Append("`n Install/uninstall failed")
        Write-EventLog -LogName "Application" -Source "AccutermUpgrade" -EventID 666 -EntryType Error -Message $logoutput -Category 1 -RawData 10,20
    }

}
else {
    #Output exiting log to Application Logs
    $logoutput = $SB.Append("`n Files were not downloaded properly, exiting")
    Write-EventLog -LogName "Application" -Source "AccutermUpgrade" -EventID 666 -EntryType Error -Message $logoutput -Category 1 -RawData 10,20
}
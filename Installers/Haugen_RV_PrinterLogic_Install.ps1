##### Author: Jesse Dickens #####
##### Created: 6/5/23 #####
##### Modified: 6/5/23 #####
##### Purpose: Install PrinterLogic client silently #####

#Start log entry
$logoutput = "Starting PrinterLogic install"
$SB = New-Object -TypeName System.Text.StringBuilder
New-EventLog –LogName Application –Source 'PrinterLogicInstall'

#Download necessary Accuterm setup files
$logoutput = $SB.Append("`n Starting file download")
wget "https://appriver3651000028-my.sharepoint.com/:u:/g/personal/jdickens_teamlogicit_com/ERVYGjhK7NdAurQk5027tpYBf-35caJG2N8MqWWpJ6B1Hg?download=1" -OutFile "C:\temp\PLIC.msi"

#Verify files downloaded correctly and then proceed with install
if (Test-Path -Path "C:\temp\PLIC.msi" -PathType Leaf) {
    
    Try {
        #Run the PrinterLogic installer
        $logoutput = $SB.Append("`n File download verified, attempting to install")
        msiexec.exe /i C:\temp\PLIC.msi /qn HOMEURL=https://haugenrv.printercloud.com/ AUTHORIZATION_CODE=d40sssm4

        #Output exiting log to Application Logs
        $logoutput = $SB.Append("`n PrinterLogic installed successfully, exiting")
        Write-EventLog -LogName "Application" -Source "PrinterLogicInstall" -EventID 123 -EntryType Information -Message $logoutput -Category 1 -RawData 10,20
    }
    Catch {
        #Output exiting log to Application Logs
        $logoutput = $SB.Append("`n Install failed")
        Write-EventLog -LogName "Application" -Source "PrinterLogicInstall" -EventID 666 -EntryType Error -Message $logoutput -Category 1 -RawData 10,20
    }

}
else {
    #Output exiting log to Application Logs
    $logoutput = $SB.Append("`n Files were not downloaded properly, exiting")
    Write-EventLog -LogName "Application" -Source "PrinterLogicInstall" -EventID 666 -EntryType Error -Message $logoutput -Category 1 -RawData 10,20
}
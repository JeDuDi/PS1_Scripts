﻿<#

    .PURPOSE
        This is a quick prompt to the logged in user asking to reboot. Logs results to event log. 
    
    .NOTES
        Created by JeDuDi

#>

$title    = 'Reboot for Patching'
$question = 'Your machine needs to reboot for Windows updates to complete. Would you like to reboot now?'
$choices  = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
    Write-EventLog -LogName "System" -Source "User32" -EventID 123 -EntryType Information -Message "User initiated Reboot Prompt"
    Restart-Computer
} else {
    Write-EventLog -LogName "System" -Source "User32" -EventID 123 -EntryType Warning -Message "User declined Reboot Prompt"
}
<#

    .PURPOSE
        This script will expand the send and receive size limit for all mailboxes on Exchange ONline.
    .NOTES
        Created by JeDuDi

#>

Connect-ExchangeOnline

$mbxs = Get-Mailbox

foreach ($mbx in $mbxs) {

    Set-Mailbox -Identity "$($mbx.UserPrincipalName)" -MaxSendSize 150mb -MaxReceiveSize 150mb

}


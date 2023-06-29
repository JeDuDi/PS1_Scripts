Connect-ExchangeOnline

$mbxs = Get-Mailbox

foreach ($mbx in $mbxs) {

    Set-Mailbox -Identity "$($mbx.UserPrincipalName)" -MaxSendSize 150mb -MaxReceiveSize 150mb

}


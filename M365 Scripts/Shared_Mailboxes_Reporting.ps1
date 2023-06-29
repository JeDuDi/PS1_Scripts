Connect-ExchangeOnline

Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited | Get-MailboxPermission | Select-Object Identity,User,AccessRights | Where-Object {($_.user -like '*@*')} 

Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited | select * |  export-csv c:\temp\SharedMailboxUsers.csv

Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited | Get-MailboxAutoReplyConfiguration | select Identity, AutoReplyState | export-csv c:\temp\SharedAutoReply.csv

ATourtellotte@sglaw.com

Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited | Select Identity, ForwardingAddress
function Export-MailboxPermissions
{
param($mailboxname)
$exportlocation = 'D:\temp\'
$mailboxfolders = Get-MailboxFolderStatistics -Identity $mailboxname 
$mailboxpermissions=@()
foreach($mailboxfolder in $mailboxfolders)
{
Write-Host 'Trying to get permissions for '($mailboxfolder.identity) -ForegroundColor DarkGray
try
{
 $permission = Get-MailboxFolderPermission -Identity ($mailboxfolder.identity).replace($mailboxname,($mailboxname+':')) -ErrorAction stop
 Write-Host 'Successfull got permissions for '($mailboxfolder.identity) -ForegroundColor Green
 $mailboxpermissions += $permission
 }
 catch
 {
 Write-Host 'Unable to get permissions for '($mailboxfolder.identity) -ForegroundColor Magenta
 }
 }
 $mailboxpermissions | ConvertTo-Csv | Out-File -FilePath ($exportlocation+$mailboxname+'permissions.csv')
}

#How to Use
#Run the function and add primarysmtpaddress of mailbox which folderpermissions your want to export.
#Export-MailboxPermissions -mailboxname email@address.org 

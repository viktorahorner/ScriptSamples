function Export-MailboxPermissions
{
param($mailboxname)
$exportlocation = 'C:\temp\'
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
 Write-Host 'Trying to export permissions to '($exportlocation+$mailboxname+'permissions.csv') -ForegroundColor DarkGray
 try
 {
 $mailboxpermissions | ConvertTo-Csv | Out-File -FilePath ($exportlocation+$mailboxname+'permissions.csv') -ErrorAction stop
  Write-Host 'Successfull exported permissions to '($exportlocation+$mailboxname+'permissions.csv') -ForegroundColor Green
 }
 catch
 {
  Write-Host 'Unable to export permissions to '($exportlocation+$mailboxname+'permissions.csv') -ForegroundColor Magenta
 }
}

#How to Use
#Adopt the filepath $exportlocation = 'D:\temp\' to your desired location
#Run the function and add primarysmtpaddress of mailbox which folderpermissions your want to export.
#Export-MailboxPermissions -mailboxname email@address.org 

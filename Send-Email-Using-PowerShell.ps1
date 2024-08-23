# This is by no means the best example of an email sending script
# Cheap and nasty way to send an email via Powershell with attachment
# This setups up the credentials for the mail account
# The username is the username of the mailbox sending the email.
$Username = 'accountwithemail@email.com'
# The password to the mailbox or credentials with authority to use the SMTP relay server.
$Pass = Get-Content ".\SecureStringCreatedPriorAndStoredInTXTFile.txt" | ConvertTo-SecureString
# SMTP Cred gets the username and password then turns them into a string powershell can use to authenticate against stuff.
$SMTPCRED = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $Pass
 
# This sets up the other details requried to send the email.
$ToAddress = 'whereeverthisissending@to.com'
$FromAddress = 'accountwithemail@email.com'
# SMTP Server can be IP or Hostname
$SmtpServer = 'ensureunecryptedsmtprelayisturnedon@ifsentunencrypted'
# SMTP Servers can vary with what ports and methods of sending are allowed.
# The old rule goes "Use port 587 if you can, 465 if you cant, and 25 if you must."
$SmtpPort = '587' #port25 for unencrypted with smtp relay, some SMTP Relay servers don't like this.
# Multiple attachments can be sent if required. Generally instead of sending multiple its easier to compress into zip then attach 1 file.
$Attachments = '.\filebeingattached.file'
 
# Mail parameters
$mailparam = @{
    To = $ToAddress
    From = $FromAddress
    Subject = 'Test report'
    Body = 'Test Report'
    SmtpServer = $SmtpServer
    Port = $SmtpPort
    Credential = $SMTPCRED
    Attachments = $Attachments
}

#BENEATH COMMAND PULLS ALL OF THE STRING CREATE AN EMAIL + ADD ATTACHMENT
Send-MailMessage @mailparam -UseSsl
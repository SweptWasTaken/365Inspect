$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Get-MailboxForwarding{
Try {

    $mailboxes = Get-Mailbox -ResultSize Unlimited
    
    $rulesEnabled = @()

    foreach ($mailbox in $mailboxes){
        $rulesEnabled += Get-InboxRule -Mailbox $mailbox.UserPrincipalName | Where-Object {($null -ne $_.ForwardTo) -or ($null -ne $_.ForwardAsAttachmentTo) -or ($null -ne $_.RedirectTo)} | Select-Object MailboxOwnerId, RuleIdentity, Name, ForwardTo, RedirectTo
    }
    if ($rulesEnabled.Count -gt 0) {
        $rulesEnabled | Out-File -FilePath "$($path)\ExchangeMailboxeswithForwardingRules.txt" -Append
        Return $rulesenabled.MailboxOwnerID
    }
    Return $null

}
Catch {
Write-Warning "Error message: $_"
$message = $_.ToString()
$exception = $_.Exception
$strace = $_.ScriptStackTrace
$failingline = $_.InvocationInfo.Line
$positionmsg = $_.InvocationInfo.PositionMessage
$pscommandpath = $_.InvocationInfo.PSCommandPath
$failinglinenumber = $_.InvocationInfo.ScriptLineNumber
$scriptname = $_.InvocationInfo.ScriptName
Write-Verbose "Write to log"
Write-ErrorLog -message $message -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $strace
Write-Verbose "Errors written to log"
}

}

Get-MailboxForwarding



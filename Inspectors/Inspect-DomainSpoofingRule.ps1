$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-DomainSpoofingRule {
Try {

	$rules = Get-TransportRule
	$flag = $False
    $domains = (Get-AcceptedDomain).DomainName

	ForEach ($domain in $domains) {
        ForEach ($rule in $rules) {    
            if (($rule.FromScope -eq "NotInOrganization") -AND ($rule.SenderDomainIs -contains $domain) -AND (($rule.DeleteMessage -ne $false) -OR ($null -ne $rule.RejectMessageReasonText))) {
                $flag = $True
            }
        }
    }
	
	If (-NOT $flag) {
		return @($org_name)
	}
	
	return $null

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

return Inspect-DomainSpoofingRule



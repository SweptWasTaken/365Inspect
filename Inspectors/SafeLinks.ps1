$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


function Inspect-ATPSafeLinks {
Try {

	# This will throw an error if the environment under test does not have an ATP license,
	# but should still work.
	Try {
		$safe_links_policies = Get-SafeLinksPolicy
		If (!($safe_links_policies)) {
			return @($org_name)
		}
	} Catch [System.Management.Automation.CommandNotFoundException] {
		return $null
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

return Inspect-ATPSafeLinks



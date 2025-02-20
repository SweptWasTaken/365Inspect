$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


<#
.Synopsis
    Gather Environment Information and Determine if Azure Secure Defaults are Enabled.
.Description
    Gather Environment Information and Determine if Azure Secure Defaults are Enabled.
.Inputs
    None
.Component
    PowerShell
.Role
    Secuirty Reader Rights Required
.Functionality
    Gather Environment Information and Determine if Azure Secure Defaults are Enabled.
#>


function Inspect-DangerousDefaults {
Try {

    #Define Dangerous Defaults
    $permissions = Get-MsolCompanyInformation
    $authPolicy = Get-AzureADMSAuthorizationPolicy

    If (($permissions.UsersPermissionToReadOtherUsersEnabled -eq $true) -or ($permissions.UsersPermissionToCreateGroupsEnabled -eq $true) -or ($authPolicy.AllowEmailVerifiedUsersToJoinOrganization -eq $true)){
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

return Inspect-DangerousDefaults



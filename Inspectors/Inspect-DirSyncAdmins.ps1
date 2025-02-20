$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


Function Inspect-DirSyncAdmins{
Try {

	$path = New-Item -ItemType Directory -Force -Path "$($path)\DirSync"

	$Users = Get-AzureADUser -All $true | where-Object {$_.DirSyncEnabled -eq $true}

	$adminRoles = Get-AzureADDirectoryRole | Where-Object {$_.DisplayName -like "*Administrator"}

	$dirsyncAdmins = @()

	ForEach ($role in $adminRoles) {
		$roleMembers = Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId

		Foreach ($user in $users) {
			If ($roleMembers -contains $User) {
				$dirsyncAdmins += $user.UserPrincipalName
				$user | Export-Csv "$path\$($role.DisplayName).csv" -Append -NoTypeInformation
			}
		}
	}
	
	If ($dirsyncAdmins.count -ne 0){
		return $dirsyncAdmins
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

Return Inspect-DirSyncAdmins



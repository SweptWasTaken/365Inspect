$ErrorActionPreference = "Stop"

$errorHandling = "$((Get-Item $PSScriptRoot).Parent.FullName)\Write-ErrorLog.ps1"

. $errorHandling


$path = @($out_path)

Function Inspect-AADRoles{
Try {

    $path = New-Item -ItemType Directory -Force -Path "$($path)\AzureAD-Roles"
    $roles =  Get-AzureADDirectoryRole
    $messages = @()
    foreach ($role in $roles) {
        $members = Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | Select-Object CompanyName, Department, DisplayName, JobTitle, Mail 
        $members | Export-CSV "$($path)\$($role.DisplayName)_AzureDirectoryRoleMembers.csv" -Force -NoTypeInformation
        $message = Write-Output "$($role.DisplayName) - $(@($members).count) members found"
        $messages += $message
        Get-ChildItem $path | Where-Object {($_.Length -eq 0) -and ($_.Name -like "$($role.DisplayName)*.csv")} | Remove-Item
    }
    Return $messages

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

Return Inspect-AADRoles



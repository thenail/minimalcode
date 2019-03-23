. "$((Get-Location).Path)\_Setup.ps1"
Set-Log -FileName $MyInvocation.MyCommand.Name

$site = Get-SPOSite -Identity https://yourtenant.sharepoint.com
Set-SPOSite -Identity $site -SocialBarOnSitePagesDisabled $true
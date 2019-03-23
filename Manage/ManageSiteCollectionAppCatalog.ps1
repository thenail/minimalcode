. "$((Get-Location).Path)\..\Base\_Setup.ps1"
Set-Log -FileName $MyInvocation.MyCommand.Name

$site = Get-SPOSite https://yourtenant.sharepoint.com

Add-SPOSiteCollectionAppCatalog -Site $site
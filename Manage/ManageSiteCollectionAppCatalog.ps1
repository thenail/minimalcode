. "$((Get-Location).Path)\..\Base\_Setup.ps1"
Set-Log -FileName $MyInvocation.MyCommand.Name

# $site = Get-SPOSite https://acandolab01.sharepoint.com/sites/cookbook2

$site = Get-SPOSite https://inmotioncloud.sharepoint.com

Add-SPOSiteCollectionAppCatalog -Site $site
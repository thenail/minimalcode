. "$((Get-Location).Path)\..\Base\_Setup.ps1"
Set-Log -FileName $MyInvocation.MyCommand.Name

$pageName = "Step-1.aspx"
$page = Get-PnPListItem -Connection $global:pnpSCCon -List "Site Pages" -Query "<View><Query><Where><Eq><FieldRef Name='FileLeafRef'/><Value Type='Text'>$pageName</Value></Eq></Where></Query></View>"
# $page["PageLayoutType"] = "SingleWebPartAppPage"
# $page["PageLayoutType"] = "Article"
$page["PageLayoutType"] = "Home"
$page.Update()
Invoke-PnPQuery
param([bool]$SkipAuth=$false)

function Set-Log {
    param( [string]$FileName )

    $logFile = "$((Get-Location).Path)\Log\$($FileName.Replace("ps1", ""txt""))"
    Write-Host "Log file ""$logFile""" -ForegroundColor Yellow
    Set-PnPTraceLog -On -Level Debug -LogFile $logFile
}
function Get-PnpTenantCon {
    return $global:pnpTCon
}

function Get-TenantCredentials {
    return $global:tenantAdminCredentials
}

function Get-PnpSiteCon {
    return $global:pnpSCCon
}

function Get-SiteCollectionUrl {
    return $global:siteCollectionUrl;
}

# Install-Module PowershellGet -Force

# SharePoint Online CSOM
$minimumCsomVersion = New-Object System.Version("16.1.8523.1200")
if (-not (Get-InstalledModule -Name Microsoft.SharePointOnline.CSOM -MinimumVersion $minimumCsomVersion -ErrorAction Ignore)) 
{
    Write-Host "Installing Microsoft.SharePointOnline.CSOM"
    Install-Module Microsoft.SharePointOnline.CSOM -Force -Repository PSGallery -AllowPrerelease
}
Import-Module Microsoft.SharePointOnline.CSOM -DisableNameChecking -MinimumVersion $minimumCsomVersion

# SharePoint Online Management Shell
if (-not (Get-InstalledModule -Name Microsoft.Online.SharePoint.PowerShell -ErrorAction Ignore)) 
{
    Write-Host "Installing Microsoft.Online.SharePoint.PowerShell"
    Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser -Force
}
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

# SharePointPnPPowerShellOnline
$minimumPnpVersion = New-Object System.Version("3.6.1902.2")
if (-not (Get-InstalledModule -Name SharePointPnPPowerShellOnline -MinimumVersion $minimumPnpVersion -ErrorAction Ignore)) 
{
    Write-Host "Installing SharePointPnPPowerShellOnline"
    Install-Module SharePointPnPPowerShellOnline -MinimumVersion $minimumPnpVersion -Scope CurrentUser -Force
}
Import-Module SharePointPnPPowerShellOnline -DisableNameChecking -MinimumVersion $minimumPnpVersion

# Teams
if (-not (Get-InstalledModule -Name MicrosoftTeams -ErrorAction Ignore)) 
{
    Write-Host "Installing MicrosoftTeams"
    Install-Module MicrosoftTeams -Scope CurrentUser -Force
}

# Azure AD Preview
if (-not (Get-InstalledModule -Name AzureADPreview -ErrorAction Ignore)) 
{
    Write-Host "Installing AzureADPreview"
    Install-Module AzureADPreview -Scope CurrentUser -Force
}

Import-Module AzureADPreview
Import-Module MicrosoftTeams

if($true -eq $SkipAuth) {
    return
}

Do {
    if ($null -eq $global:siteCollectionUrl) {
        $global:siteCollectionUrl = Read-Host -Prompt "Connect to Site collection url ie. https://contoso.sharepoint.com/"
    }
    else {
        $siteCollectionUrlTmp = Read-Host -Prompt "Connect to Site collection url, press enter for ""$global:siteCollectionUrl"""
        if ($null -ne $siteCollectionUrlTmp) {
            $global:siteCollectionUrl = $siteCollectionUrlTmp
            $global:tenantAdminCredentials = $null
        }
    }

    $isCorrectFormat = $global:siteCollectionUrl -match "https://(.*?).sharepoint.com"
    if ($False -eq $isCorrectFormat) {
        Write-Host "Incorrect format of url" -ForegroundColor Yellow
    }
} While ($False -eq $isCorrectFormat)

if ($null -eq $global:tenantAdminCredentials) {
    $global:tenantAdminCredentials = Get-Credential -Message "Tenant admin credentials"
}

$tenantAdminUrl = "https://$($Matches[1])-admin.sharepoint.com"
Connect-SPOService -Credential $global:tenantAdminCredentials -Url $tenantAdminUrl
$global:pnpTCon = Connect-PnPOnline -Credential $global:tenantAdminCredentials -Url $tenantAdminUrl
$global:pnpSCCon = Connect-PnPOnline -Credential $global:tenantAdminCredentials -Url $global:siteCollectionUrl
# Connect-PnPOnline -Graph
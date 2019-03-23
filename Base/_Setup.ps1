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

Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking

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
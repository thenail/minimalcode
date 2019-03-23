# Install-Module PowershellGet -Force

# SharePoint Online CSOM
$minimumCsomVersion = New-Object System.Version("16.1.8613.1200")
if (-not (Get-InstalledModule -Name Microsoft.SharePointOnline.CSOM -MinimumVersion $minimumCsomVersion -ErrorAction Ignore)) 
{
    Write-Host "Installing Microsoft.SharePointOnline.CSOM"
    .\NuGet.exe install Microsoft.SharePointOnline.CSOM
    Install-Package -Name 'Microsoft.SharePointOnline.CSOM' -Source .\Microsoft.SharePointOnline.CSOM.16.1.8613.1200
}
Write-Host "Loading Microsoft.SharePointOnline.CSOM"
Import-Module '.\Microsoft.SharePointOnline.CSOM.16.1.8613.1200\lib\net45\Microsoft.SharePoint.Client.dll'

# SharePoint Online Management Shell
$minimumPowershellVersion = New-Object System.Version("16.0.8615.1200")
if (-not (Get-InstalledModule -Name Microsoft.Online.SharePoint.PowerShell -MinimumVersion $minimumPowershellVersion -ErrorAction Ignore)) 
{
    Write-Host "Installing Microsoft.Online.SharePoint.PowerShell"
    Install-Module -Name Microsoft.Online.SharePoint.PowerShell -MinimumVersion $minimumPowershellVersion -Scope CurrentUser -Force
}
Write-Host "Loading Microsoft.Online.SharePoint.PowerShell"
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking -Force

# SharePointPnPPowerShellOnline
$minimumPnpVersion = New-Object System.Version("3.6.1902.2")
if (-not (Get-InstalledModule -Name SharePointPnPPowerShellOnline -MinimumVersion $minimumPnpVersion -ErrorAction Ignore)) 
{
    Write-Host "Installing SharePointPnPPowerShellOnline"
    Install-Module SharePointPnPPowerShellOnline -MinimumVersion $minimumPnpVersion -Scope CurrentUser -Force
}
Write-Host "Loading SharePointPnPPowerShellOnline"
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
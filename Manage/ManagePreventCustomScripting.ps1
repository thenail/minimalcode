. "$((Get-Location).Path)\_Setup.ps1"
Set-Log -FileName $MyInvocation.MyCommand.Name

$site = Get-SPOSite https://yourtenant.sharepoint.com

# Prevent
# Set-SPOsite $site -DenyAddAndCustomizePages 1

Get-SPOSite $site -Detailed | Select-Object DenyAddAndCustomizePages


# Allow
# Set-SPOsite $site -DenyAddAndCustomizePages 0
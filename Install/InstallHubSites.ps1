. "$((Get-Location).Path)\..\Base\_Setup.ps1"
. "$((Get-Location).Path)\..\Base\_Functions.ps1"
Set-Log -FileName $MyInvocation.MyCommand.Name

Write-Host "Create hub sites"
$collaborationSiteUrl = New-PnPSite -Connection (Get-PnpTenantCon) -Type TeamSite -Title "Collaborations" -Alias "collaborations" -Description "Collaboration hub site" -IsPublic
$smallProjectSiteUrl = New-PnPSite -Connection (Get-PnpTenantCon) -Type TeamSite -Title "Small Projects" -Alias "smallprojects" -Description "Small Projects hub site, less than 2 MSEK" -IsPublic
$largeProjectSiteUrl = New-PnPSite -Connection (Get-PnpTenantCon) -Type TeamSite -Title "Large Projects" -Alias "largeprojects" -Description "Large Projects hub site, more than 2 MSEK" -IsPublic

function Add-HubSite {
    param( [string]$LogoFileName, [string]$Url, [string]$ThemeName, [Guid]$SiteDesignId, [bool]$RequiresJoinApproval )

    Write-Host "Site Url: $Url"

    $hubSite = Get-SPOHubSite | Where-Object { $_.SiteUrl -eq $Url } | Select-Object -First 1
    $allHubSites | ForEach-Object { $_.Url }

    if($null -eq $hubSite) {
        Write-Host "Register hub site"
        Register-PnPHubSite -Connection (Get-PnpTenantCon) -Site $Url
    }

    $hubSite = Get-SPOHubSite | Where-Object { $_.SiteUrl -eq $Url } | Select-Object -First 1

    if($null -ne $ThemeName) {
        Write-Host "Set theme"
        Get-PnPTenantTheme -Connection (Get-PnpTenantCon) -Name $ThemeName | Set-PnPWebTheme -Connection (Get-PnpTenantCon) -WebUrl $Url
    }

    if($null -ne $LogoFileName) {
        Write-Host "Set logo"
        Set-PnPTenantSite -Url $Url -NoScriptSite:$false -Connection (Get-PnpTenantCon)
        Write-Host "Upload file: $((Get-Location).Path)\..\Assets\$LogoFileName"
        Add-PnPFile -Path "$((Get-Location).Path)\..\Assets\$LogoFileName" -Folder "Style%20Library" -Connection (Connect-PnPOnline -Credential (Get-TenantCredentials) -Url $Url -ReturnConnection) | Out-Null
        Set-PnPTenantSite -Url $Url -NoScriptSite:$true -Connection (Get-PnpTenantCon)

        Write-Host "Logo Url: $($hubSite.SiteUrl)/Style%20Library/$LogoFileName"
        Set-SPOHubSite -Identity $hubSite.Id -LogoUrl "$($hubSite.SiteUrl)/Style%20Library/$LogoFileName"
    }

    if($null -ne $SiteDesignId) {
        Write-Host "Set Site Design"
        Set-SPOHubSite -Identity $hubSite.Id -SiteDesignId $SiteDesignId
    }

    if($null -ne $RequiresJoinApproval) {
        Write-Host "Set Requires Join Approval"
        Set-SPOHubSite -Identity $hubSite.Id -RequiresJoinApproval $RequiresJoinApproval
    }
}

Add-HubSite -ThemeName "Collaboration" -LogoFileName "Collaboration.png" -Url $collaborationSiteUrl
Add-HubSite -ThemeName "Project" -LogoFileName "Project.png" -Url $smallProjectSiteUrl
Add-HubSite -ThemeName "Project" -LogoFileName "Project.png" -Url $largeProjectSiteUrl -RequiresJoinApproval:$true -SiteDesignId (Get-SiteDesign -Title "Project Large Team site Hub").Id
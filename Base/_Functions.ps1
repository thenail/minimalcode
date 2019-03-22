function Set-SiteScript {
    param( [string]$Title, [string]$Description, $Script )

    $json = ConvertTo-Json -InputObject $Script -Depth 10
    $json = $json.Replace("\u003c", "<").Replace("\u003e", ">").Replace("\u0027", "'").Replace("_schema", "`$schema")
    $json = $json -replace ">[\\r\\n]+[ \t]+<", "><"

    $json | Out-File "$((Get-Location).Path)\\..\\Tmp\\SiteScripts\\SiteScript_$((Get-Date).ToString(""yyyyMMddThhmmssZ"")).json"
    
    Write-Host "Site Script: $Title"
    $existingScript = Get-PnPSiteScript -Connection (Get-PnpTenantCon) | Where-Object { $_.Title -eq $Title }
    if ($null -eq $existingScript) {
        Add-PnPSiteScript -Connection (Get-PnpTenantCon) -Title $Title -Description $Description -Content $json
    }
    else {
        Set-PnPSiteScript -Connection (Get-PnpTenantCon) -Identity $existingScript.Id -Description $Description -Content $json | Out-Null
        Get-PnPSiteScript -Connection (Get-PnpTenantCon) | Where-Object { $_.Title -eq $Title }
    }
}

function Get-SiteDesign {
    param( [string]$Title )
    $byTitle = Get-PnPSiteDesign -Connection (Get-PnpTenantCon) | Where-Object { $_.Title -eq $Title }
    if($null -ne ($byTitle | Select-Object -First 1)) {
        return $byTitle | Select-Object -First 1
    }

    if($null -ne ($byTitle | Select-Object -First 2)) {
        return $byTitle | Select-Object -First 2
    }

    $byTitle
}

function Get-SiteScript {
    param( [string]$Title )
    $byTitle = Get-PnPSiteScript -Connection (Get-PnpTenantCon) | Where-Object { $_.Title -eq $Title }
    if($null -ne ($byTitle | Select-Object -First 1)) {
        return $byTitle | Select-Object -First 1
    }

    if($null -ne ($byTitle | Select-Object -First 2)) {
        return $byTitle | Select-Object -First 2
    }

    $byTitle
}

function Get-HubSiteId {
    param( [string]$Title )

    $hubSite = Get-PnPHubSite -Connection (Get-PnpTenantCon) | Where-Object { $_.Title -eq $Title }

    return $hubSite.SiteId
}
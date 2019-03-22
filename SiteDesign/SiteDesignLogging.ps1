. "$((Get-Location).Path)\..\Base\_Setup.ps1"

Function Invoke-Menu {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $True, HelpMessage = "Enter your menu text")]
        [ValidateNotNullOrEmpty()]
        [string]$Menu,
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]$Title = "My Menu",
        [Alias("cls")]
        [switch]$ClearScreen
    )
	
    if ($ClearScreen) { 
        Clear-Host 
    }
	
    $menuPrompt = $title
    $menuprompt += "`n"
    $menuprompt += "-" * $title.Length
    $menuprompt += "`n"
    $menuPrompt += $menu
	
    Read-Host -Prompt $menuprompt
}

$menuOptions = "Show actions with ERRORS from LAST applied SITE DESIGN on site",
"Show ALL actions from LAST applied SITE DESIGN on site",
"Show actions with ERRORS from LAST applied SITE DESIGN of EACH TYPE on site",
"Show ALL actions from LAST applied SITE DESIGN of EACH TYPE on site",
"Show actions with ERRORS from ALL SITE DESIGN(S) execution(s) on site",
"Show ALL actions from ALL SITE DESIGN(S) execution(s) on site"

$selectionText = "";
$counter = 1;
$menuOptions | ForEach-Object { $selectionText += ($counter++).ToString() + " " + $_ + "`r`n" }

$menu = $selectionText + @"
Q Quit
 
Select a task by number or Q to quit
"@

$siteScriptTable =
@{Expression = {$_.OrdinalIndex}; Label = "Index"; Width = 5},
@{Expression = {$_.ActionTitle}; Label = "Title"; Width = 50}, 
@{Expression = {$_.OutcomeCode}; Label = "Status"; Width = 10}, 
@{Expression = {$_.SiteScriptTitle}; Label = "Site Script"; Width = 30}, 
@{Expression = {$_.OutcomeText}; Label = "Outcome"; Width = 30}

Do {
    Switch (Invoke-Menu -menu $menu -title "Select Report" -clear) {
        "1" {
            Write-Host $menuOptions[0] -ForegroundColor Green
			 
            $url = Read-Host -Prompt 'Url of the site'

            $allAppliedSiteDesigns = Get-SPOSiteDesignRun -WebUrl $url

            $allAppliedSiteDesignsGroups = $allAppliedSiteDesigns | Group-Object -Property "SiteDesignTitle"

            $allAppliedSiteDesigns | Select-Object -First 1 |
                ForEach-Object {
                $allAppliedSiteDesignsGroup = $allAppliedSiteDesignsGroups | Where-Object { $_Name -eq $_.SiteDesignTitle } | Select-Object -First 1
                Write-Host "Site Design ""$($allAppliedSiteDesignsGroup.Name)"", applied total ""$($allAppliedSiteDesignsGroup.Count)"" time(s) to site, last time caused the following Errors:";
                $status = Get-SPOSiteDesignRunStatus -Run $_ |
                    Where-Object { $_.OutcomeCode -eq "Failure" } |
                    Format-Table -Wrap -Property $siteScriptTable;
                if (($status | Measure-Object).Count -eq 0) {
                    Write-Host "Applied with No error(s)!" -ForegroundColor Yellow
                }
                else {
                    $status | Out-String | ForEach-Object { Write-Host $_ }
                }
            }

            Return
        } 
        "2" {
            Write-Host $menuOptions[1] -ForegroundColor Green
				
            $url = Read-Host -Prompt 'Url of the site'

            $allAppliedSiteDesigns = Get-SPOSiteDesignRun -WebUrl $url

            $allAppliedSiteDesignsGroups = $allAppliedSiteDesigns | Group-Object -Property "SiteDesignTitle"

            $allAppliedSiteDesigns | Select-Object -First 1 |
                ForEach-Object { 
                $allAppliedSiteDesignsGroup = $allAppliedSiteDesignsGroups | Where-Object { $_Name -eq $_.SiteDesignTitle } | Select-Object -First 1
                Write-Host "Site Design ""$($allAppliedSiteDesignsGroup.Name)"", applied total ""$($allAppliedSiteDesignsGroup.Count)"" time(s) to site, last time executed the following actions:";
                $status = Get-SPOSiteDesignRunStatus -Run $_ | 
                    Format-Table -Wrap -Property $siteScriptTable;
                if (($status | Measure-Object).Count -eq 0) {
                    Write-Host "Applied with no actions(s)!" -ForegroundColor Yellow
                }
                else {
                    $status | Out-String | ForEach-Object { Write-Host $_ }
                }
            }

            Return
        }
        "3" {
            Write-Host $menuOptions[2] -ForegroundColor Green
				
            $url = Read-Host -Prompt 'Url of the site'

            $allAppliedSiteDesigns = Get-SPOSiteDesignRun -WebUrl $url

            $allAppliedSiteDesignsGroups = $allAppliedSiteDesigns | Group-Object -Property "SiteDesignTitle"

            $allAppliedSiteDesignsGroups |
                ForEach-Object { 
                Write-Host "Site Design ""$($_.Name)"", applied total ""$($_.Count)"" time(s) to site, last time caused the following Errors:";
                $status = Get-SPOSiteDesignRunStatus -Run $_.Group[0] |
                    Where-Object { $_.OutcomeCode -eq "Failure" } |
                    Format-Table -Wrap -Property $siteScriptTable;
                if (($status | Measure-Object).Count -eq 0) {
                    Write-Host "Applied with No error(s)!" -ForegroundColor Yellow
                }
                else {
                    $status | Out-String | ForEach-Object { Write-Host $_ }
                }
            }

            Return
        }
        "4" {
            Write-Host $menuOptions[3] -ForegroundColor Green
					
            $url = Read-Host -Prompt 'Url of the site'

            $allAppliedSiteDesigns = Get-SPOSiteDesignRun -WebUrl $url

            $allAppliedSiteDesignsGroups = $allAppliedSiteDesigns | Group-Object -Property "SiteDesignTitle"

            $allAppliedSiteDesignsGroups |
                ForEach-Object { 
                Write-Host "Site Design ""$($_.Name)"", applied total ""$($_.Count)"" time(s) to site, last time executed the following actions:";
                $status = Get-SPOSiteDesignRunStatus -Run $_.Group[0] | 
                    Format-Table -Wrap -Property $siteScriptTable;
                if (($status | Measure-Object).Count -eq 0) {
                    Write-Host "Applied with no actions(s)!" -ForegroundColor Yellow
                }
                else {
                    $status | Out-String | ForEach-Object { Write-Host $_ }
                }
            }

            Return
        }
        "5" {
            Write-Host $menuOptions[4] -ForegroundColor Green
					
            $url = Read-Host -Prompt 'Url of the site'

            $allAppliedSiteDesigns = Get-SPOSiteDesignRun -WebUrl $url

            [array]::Reverse($allAppliedSiteDesigns)
            $allAppliedSiteDesigns |
                ForEach-Object { 
                $status = Get-SPOSiteDesignRunStatus -Run $_ |
                    Where-Object { $_.OutcomeCode -eq "Failure" } |
                    Format-Table -Wrap -Property $siteScriptTable;
                if (($allAppliedSiteDesigns | Measure-Object).Count -eq 1 -and ($status | Measure-Object).Count -eq 0) {
                    Write-Host "Site design didn't cause any errors!" -ForegroundColor Yellow
                }
                if (($status | Measure-Object).Count -gt 0) {
                    Write-Host "Site Design ""$($_.SiteDesignTitle)"", applied with the following Errors:";
                    $status | Out-String | ForEach-Object { Write-Host $_ }
                }
            }

            if (($allAppliedSiteDesigns | Measure-Object).Count -eq 0) {
                Write-Host "No site design(s) applied to site!" -ForegroundColor Yellow
            }

            Return
        }
        "6" {
            Write-Host $menuOptions[5] -ForegroundColor Green
						
            $url = Read-Host -Prompt 'Url of the site'

            $allAppliedSiteDesigns = Get-SPOSiteDesignRun -WebUrl $url

            $allAppliedSiteDesignsGroups = $allAppliedSiteDesigns | Group-Object -Property "SiteDesignTitle"

            [array]::Reverse($allAppliedSiteDesigns)
            $allAppliedSiteDesigns |
                ForEach-Object { 
                $status = Get-SPOSiteDesignRunStatus -Run $_ |
                    Format-Table -Wrap -Property $siteScriptTable;
                if (($allAppliedSiteDesigns | Measure-Object).Count -eq 1 -and ($status | Measure-Object).Count -eq 0) {
                    Write-Host "Site design didn't execute any actions!" -ForegroundColor Yellow
                }
                if (($status | Measure-Object).Count -gt 0) {
                    Write-Host "Site Design ""$($_.SiteDesignTitle)"", executed the following actions:";
                    $status | Out-String | ForEach-Object { Write-Host $_ }
                }
            }

            if (($allAppliedSiteDesigns | Measure-Object).Count -eq 0) {
                Write-Host "No site design(s) applied to site!" -ForegroundColor Yellow
            }

            Return
        }
        "Q" {
            Write-Host "Goodbye" -ForegroundColor Cyan
            Return
        }
        Default {
            Write-Warning "Invalid Choice. Try again."
        }
    }
} While ($True)
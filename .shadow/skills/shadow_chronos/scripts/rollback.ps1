<#
.SYNOPSIS
    Shadow Chronos - Rollback (Git Evolution)
    Path: .shadow/skills/shadow_chronos/scripts/rollback.ps1
#>

param (
    [string]$TargetVersion # e.g. "0.1.0" or "v0.1.0"
)

$MotherRoot = Resolve-Path "$PSScriptRoot\..\..\..\.."
Set-Location $MotherRoot

if (-not $TargetVersion) {
    Write-Error "TargetVersion is required."
    exit 1
}

# Normalize tag name
if (-not $TargetVersion.StartsWith("v")) {
    $TagName = "v$TargetVersion"
}
else {
    $TagName = $TargetVersion
}

Write-Host "⏳ Initiating Time Travel to: $TagName..." -ForegroundColor Yellow

# Check if tag exists
$TagExists = git tag -l $TagName
if (-not $TagExists) {
    Write-Error "Timeline '$TagName' does not exist."
    exit 1
}

# Executing Rollback (Hard Reset to the Tag)
# WARNING: This destroys uncommitted changes.
git reset --hard $TagName

Write-Host "✅ Timeline Shifted. Welcome back to $TagName." -ForegroundColor Green

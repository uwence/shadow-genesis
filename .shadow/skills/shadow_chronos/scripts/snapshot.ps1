<#
.SYNOPSIS
    Shadow Chronos - Snapshot (Git Evolution)
    Path: .shadow/skills/shadow_chronos/scripts/snapshot.ps1
#>

param (
    [string]$Version,
    [string]$Codename,
    [string]$Description,
    [string[]]$Features = @(),
    [string[]]$Changes = @()
)

$MotherRoot = Resolve-Path "$PSScriptRoot\..\..\..\.."
$HistoryFile = Join-Path $MotherRoot ".shadow\memory\life\resources\system\version_history.json"
$VersionFile = Join-Path $MotherRoot "VERSION"

# 1. Validation
if (-not $Version) {
    if (Test-Path $VersionFile) {
        $Version = (Get-Content $VersionFile -Raw).Trim()
    }
    else {
        $Version = "0.0.0"
    }
}
if (-not $Codename) { $Codename = "Unnamed" }
if (-not $Description) { $Description = "Snapshot" }

Set-Location $MotherRoot

# 2. Update Metadata First (So it's included in the commit)
Write-Host "📝 Updating History..." -ForegroundColor Cyan

# Update VERSION file
Set-Content -Path $VersionFile -Value $Version

# Update History JSON
$HistoryEntry = [PSCustomObject]@{
    version     = $Version
    codename    = $Codename
    description = $Description
    features    = $Features
    changes     = $Changes
    timestamp   = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")
    git_tag     = "v$Version"
}

$History = @()
if (Test-Path $HistoryFile) {
    try {
        $History = Get-Content $HistoryFile -Raw | ConvertFrom-Json
    }
    catch {
        Write-Warning "Could not parse existing history."
    }
}
# Prepend or Append? Append usually maps to chronological order in arrays.
$History += $HistoryEntry
$History | ConvertTo-Json -Depth 4 | Set-Content -Path $HistoryFile

# 3. Git Operations
Write-Host "⚔️  Engaging Git Protocol..." -ForegroundColor Cyan

# Add all changes
git add .

# Commit
$CommitMsg = "Build v${Version}: $Codename"
if ($Features.Count -gt 0) {
    $CommitMsg += "`n`nFeatures:`n" + ($Features -join "`n- ")
}
if ($Changes.Count -gt 0) {
    $CommitMsg += "`n`nChanges:`n" + ($Changes -join "`n- ")
}

git commit -m $CommitMsg

# Tag
git tag -a "v$Version" -m "$Codename - $Description"

Write-Host "✅ Snapshot Secured: v$Version ($Codename)" -ForegroundColor Green

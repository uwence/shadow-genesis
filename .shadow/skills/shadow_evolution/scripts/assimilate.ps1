<#
.SYNOPSIS
    Shadow Evolution - Assimilation Script (Skill Version)
    Skill Path: .shadow/skills/shadow_evolution/scripts/assimilate.ps1

.DESCRIPTION
    Advanced version of the evolution protocol.
    1. Backs up the current Mother Hive.
    2. Scans Child Node for genetic improvements.
    3. Assimilates selected traits.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ChildPath
)

$MotherPath = $PWD.Path
$BackupDir = Join-Path $MotherPath "backups"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# --- 1. Backup Protocol ---
Write-Host "🛡️ Initiating Backup Protocol..." -ForegroundColor Cyan
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

$BackupFile = Join-Path $BackupDir "genesis_backup_$Timestamp.zip"

# Use Compress-Archive to backup relevant files (excluding existing backups and hidden git folders)
# Note: In a simple template env, we just zip everything except backups.
$ExcludeList = @("backups", ".git")
$FilesToBackup = Get-ChildItem -Path $MotherPath | Where-Object { $ExcludeList -notcontains $_.Name }

Compress-Archive -Path $FilesToBackup.FullName -DestinationPath $BackupFile -Force
Write-Host "✅ Backup secured: $BackupFile" -ForegroundColor Green

# --- 2. Evolution Protocol (Delegate to root evolve.ps1 for now) ---
# We reuse the logic we established in the root evolve.ps1 but invoke it here as part of the skill
# Or we can inline the logic. incorporating the root script logic here for self-containment.

Write-Host "🧬 Commencing Genetic Scan on: $ChildPath" -ForegroundColor Cyan

# Reuse the Evolve Logic
$CoreEvolver = Join-Path $PSScriptRoot "evolve_core.ps1"

if (Test-Path $CoreEvolver) {
    & $CoreEvolver -SourcePath $ChildPath
}
else {
    Write-Error "CRITICAL: Core evolution mechanism (evolve_core.ps1) missing."
}

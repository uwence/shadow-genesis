<#
.SYNOPSIS
    Shadow Spawn Core (Replaces root genesis.ps1)
    Path: .shadow/skills/shadow_spawn/scripts/spawn.ps1

.DESCRIPTION
    Creates a new Shadow instance and registers it.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$TargetDirectory,
    [Parameter(Mandatory = $true)]
    [string]$ProjectName
)

# 1. Resolve Paths
# Script is in .shadow/skills/shadow_spawn/scripts/
# Mother Root is 4 levels up
$MotherRoot = Resolve-Path "$PSScriptRoot\..\..\..\.."
$ShadowTemplatePath = Join-Path $MotherRoot ".shadow"
$RegistryPath = Join-Path $ShadowTemplatePath "memory\life\resources\system\child_registry.json"

Write-Host "🐣 Initiating Shadow Spawn Sequence..." -ForegroundColor Cyan
Write-Host "   Mother Hive: $MotherRoot"
Write-Host "   Target Node: $TargetDirectory"

# 2. Directory Checks
if (-not (Test-Path $TargetDirectory)) {
    New-Item -ItemType Directory -Force -Path $TargetDirectory | Out-Null
}

$ChildShadowDir = Join-Path $TargetDirectory ".shadow"
if (-not (Test-Path $ChildShadowDir)) {
    New-Item -ItemType Directory -Force -Path $ChildShadowDir | Out-Null
    (Get-Item $ChildShadowDir).Attributes = "Hidden"
}

# 3. Cloning Process (The Replication)
Write-Host "🧬 Replicating DNA (Files)..." -ForegroundColor Gray
# Exclude the 'child_registry.json' itself from the child (Children shouldn't know about siblings initially)
# And maybe exclude backups
# Exclude Mother-specific files from child nodes
$ExcludeFiles = @("child_registry.json", "nurture_history.json", "assimilation_history.json")
# Exclude Mother's own development memory (shadow-genesis project)
$ExcludeDirectories = @("projects\\shadow-genesis")

Get-ChildItem -Path $ShadowTemplatePath -Recurse | ForEach-Object {
    if ($ExcludeFiles -contains $_.Name) { return }
    if ($_.FullName -match "backups\\") { return }
    # Skip Mother's development memory
    foreach ($excludeDir in $ExcludeDirectories) {
        if ($_.FullName -match $excludeDir) { return }
    }
    
    $relativePath = $_.FullName.Substring($ShadowTemplatePath.Length).TrimStart("\")
    $targetPath = Join-Path $ChildShadowDir $relativePath

    if ($_.PSIsContainer) {
        if (-not (Test-Path $targetPath)) {
            New-Item -ItemType Directory -Path $targetPath | Out-Null
        }
    }
    else {
        $parentDir = Split-Path $targetPath -Parent
        if (-not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }
        Copy-Item -Path $_.FullName -Destination $targetPath -Force

        # Template Replacement
        if ($_.Name -in @("USER.md", "IDENTITY.md", "template_summary.md")) {
            $content = Get-Content $targetPath -Raw
            $content = $content.Replace("[Project Name]", $ProjectName)
            $content = $content.Replace("[Today]", (Get-Date).ToString("yyyy-MM-dd"))
            Set-Content -Path $targetPath -Value $content
        }
    }
}

# 4. Copy Root Files (ACTIVATE_SHADOW.md) with Legion Context Injection
$ActivateSrc = Join-Path $MotherRoot "ACTIVATE_SHADOW.md"
$ActivateDest = Join-Path $TargetDirectory "ACTIVATE_SHADOW.md"
if (Test-Path $ActivateSrc) {
    $content = Get-Content $ActivateSrc -Raw
    $content = $content.Replace("[Project Name]", $ProjectName)
    
    # Inject Legion Context Block
    $spawnTimestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:sszzz")
    $legionContext = @"
## ⚔️ 子节点身份 (Legion Identity)
| 属性 | 值 |
| :--- | :--- |
| **节点名称** | $ProjectName |
| **项目路径** | $TargetDirectory |
| **孵化时间** | $spawnTimestamp |
| **母巢位置** | $MotherRoot |

> *此节点为 Shadow Genesis 的子嗣，专注于 $ProjectName 项目的开发。*
"@
    
    # Replace the empty Legion Context Block with filled content
    $content = $content -replace '(?s)<!-- LEGION_CONTEXT_START -->.*?<!-- LEGION_CONTEXT_END -->', "<!-- LEGION_CONTEXT_START -->`n$legionContext`n<!-- LEGION_CONTEXT_END -->"
    
    Set-Content -Path $ActivateDest -Value $content -Encoding UTF8
    Write-Host "   ⚔️ Legion Context Injected" -ForegroundColor DarkYellow
}

# 5. Handle Project Summary Rename
$templateSummary = Join-Path $ChildShadowDir "memory\life\projects\template_summary.md"
$projectSummaryDir = Join-Path $ChildShadowDir "memory\life\projects\$ProjectName"
$projectSummary = Join-Path $projectSummaryDir "summary.md"

if (Test-Path $templateSummary) {
    if (-not (Test-Path $projectSummaryDir)) {
        New-Item -ItemType Directory -Path $projectSummaryDir | Out-Null
    }
    Move-Item -Path $templateSummary -Destination $projectSummary -Force
}

# 6. Registration (The Connection)
Write-Host "🔗 Registering to Hive Mind..." -ForegroundColor Gray

if (-not (Test-Path $RegistryPath)) {
    Set-Content -Path $RegistryPath -Value "[]"
}

$registry = Get-Content $RegistryPath -Raw | ConvertFrom-Json
$spawnDate = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ss")

# Check if exists
$existing = $registry | Where-Object { $_.path -eq $TargetDirectory }
if ($existing) {
    $existing.name = $ProjectName
    $existing.last_updated = $spawnDate
}
else {
    $newItem = [PSCustomObject]@{
        name         = $ProjectName
        path         = $TargetDirectory
        created      = $spawnDate
        last_updated = $spawnDate
        version      = "1.0.0" 
    }
    $registry += $newItem
}

$registry | ConvertTo-Json -Depth 4 | Set-Content -Path $RegistryPath

Write-Host "✅ Spawn Complete: $ProjectName" -ForegroundColor Green
Write-Host "   Identity: Established"
Write-Host "   Registry: Updated"

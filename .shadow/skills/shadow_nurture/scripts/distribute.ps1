<#
.SYNOPSIS
    Shadow Nurture Core (v2.0)
    Path: .shadow/skills/shadow_nurture/scripts/distribute.ps1
    Description: Bidirectional logging enabled.
#>

param (
    [Parameter(Mandatory = $false)]
    [string]$Target = "All", 
    [Parameter(Mandatory = $true)]
    [string]$Component # Relative path in .shadow/ or "All", "Skills", "Identity", "Workflows"
)

$MotherRoot = Resolve-Path "$PSScriptRoot\..\..\..\.."
$ShadowTemplatePath = Join-Path $MotherRoot ".shadow"
$WorkflowTemplatePath = Join-Path $MotherRoot ".agent\workflows"
$RegistryPath = Join-Path $ShadowTemplatePath "memory\life\resources\system\child_registry.json"
$VersionFile = Join-Path $MotherRoot "VERSION"
$HistoryFile = Join-Path $ShadowTemplatePath "memory\life\resources\system\nurture_history.json"

Write-Host "🍼 Initiating Shadow Nurture Protocol (v2.0)..." -ForegroundColor Cyan

# 0. Check Registry
if (-not (Test-Path $RegistryPath)) { Write-Error "Registry not found."; exit }
$registry = Get-Content $RegistryPath -Raw | ConvertFrom-Json
if ($registry.Count -eq 0) { Write-Warning "No children registered."; exit }

# 1. Get Mother Version
$MotherVersion = "0.0.0"
if (Test-Path $VersionFile) { $MotherVersion = (Get-Content $VersionFile -Raw).Trim() }

# 2. Define Files to Copy
$FilesToCopy = @()
$CopyWorkflows = $false

if ($Component -eq "All") {
    # .shadow files (excluding project specific)
    $FilesToCopy = Get-ChildItem -Path $ShadowTemplatePath -Recurse | Where-Object { 
        $_.FullName -notmatch "memory\\life\\projects\\" -and 
        $_.FullName -notmatch "child_registry.json" -and
        $_.FullName -notmatch "assimilation_history.json" -and
        $_.FullName -notmatch "nurture_history.json" -and
        $_.FullName -notmatch "backups"
    }
    # Also include Workflows for "All"
    $CopyWorkflows = $true
}
elseif ($Component -eq "Identity") {
    $FilesToCopy = Get-ChildItem -Path $ShadowTemplatePath | Where-Object { $_.Name -match "IDENTITY|USER|tacit_knowledge|README_MEMORY" }
}
elseif ($Component -eq "Skills") {
    $FilesToCopy = Get-ChildItem -Path (Join-Path $ShadowTemplatePath "skills") -Recurse
}
elseif ($Component -eq "Workflows") {
    $CopyWorkflows = $true
}
else {
    # Specific component path
    $SpecificPath = Join-Path $ShadowTemplatePath $Component
    if (Test-Path $SpecificPath) {
        $item = Get-Item $SpecificPath
        if ($item.PSIsContainer) { $FilesToCopy = Get-ChildItem -Path $SpecificPath -Recurse }
        else { $FilesToCopy = @($item) }
    }
    else { Write-Error "Component '$Component' not found."; exit }
}

# Add Workflows if requested
if ($CopyWorkflows -and (Test-Path $WorkflowTemplatePath)) {
    $WfFiles = Get-ChildItem -Path $WorkflowTemplatePath -Recurse
    $FilesToCopy += $WfFiles
}

# 2b. Handle ACTIVATE_SHADOW.md Inheritance (Root-level file)
$MotherActivatePath = Join-Path $MotherRoot "ACTIVATE_SHADOW.md"
$SyncActivateShadow = ($Component -eq "All" -or $Component -eq "Identity") -and (Test-Path $MotherActivatePath)

function Merge-ActivateShadow {
    param (
        [string]$MotherContent,
        [string]$ChildContent
    )
    
    # Extract child's Legion Context Block if exists
    $ChildContextBlock = ""
    $contextPattern = '(?s)(<!-- LEGION_CONTEXT_START -->.*?<!-- LEGION_CONTEXT_END -->)'
    if ($ChildContent -match $contextPattern) {
        $ChildContextBlock = $Matches[1]
    }
    
    # If child has a context block, preserve it in mother's template
    if ($ChildContextBlock -ne "") {
        # Replace mother's empty context block with child's preserved block
        $emptyBlockPattern = '<!-- LEGION_CONTEXT_START -->\s*<!-- LEGION_CONTEXT_END -->'
        if ($MotherContent -match $emptyBlockPattern) {
            return $MotherContent -replace $emptyBlockPattern, $ChildContextBlock
        }
        else {
            # Mother doesn't have the block structure - inject after Node Context section
            return $MotherContent
        }
    }
    
    # No child context to preserve, use mother's template as-is
    return $MotherContent
}

# 3. Execution Loop
$ItemsPushedList = @()

foreach ($child in $registry) {
    if ($Target -ne "All" -and $child.name -ne $Target -and $child.path -ne $Target) { continue }
    if (-not (Test-Path $child.path)) { Write-Warning "Unreachable: $($child.name)"; continue }

    Write-Host "   >> Nurturing: $($child.name)" -ForegroundColor Gray
    
    # A. Copy Files
    foreach ($file in $FilesToCopy) {
        if ($file.PSIsContainer) { continue }
        
        # Determine relative path
        $relativePath = ""
        $sourceType = "" # shadow or agent
        
        if ($file.FullName.StartsWith($ShadowTemplatePath)) {
            $relativePath = $file.FullName.Substring($ShadowTemplatePath.Length).TrimStart("\")
            $destPath = Join-Path $child.path ".shadow\$relativePath"
            $sourceType = ".shadow"
        }
        elseif ($file.FullName.StartsWith($WorkflowTemplatePath)) {
            $relativePath = $file.FullName.Substring($WorkflowTemplatePath.Length).TrimStart("\")
            $destPath = Join-Path $child.path ".agent\workflows\$relativePath"
            $sourceType = ".agent/workflows"
        }
        else { continue }

        $parentDir = Split-Path $destPath -Parent
        if (-not (Test-Path $parentDir)) { New-Item -ItemType Directory -Path $parentDir -Force | Out-Null }
        
        # Prevent overwriting protected files in Child
        if ($file.Name -eq "mutation_log.json" -and (Test-Path $destPath)) { continue } # Don't overwrite their logs
        if ($file.Name -eq "nurture_log.json" -and (Test-Path $destPath)) { continue } 

        Copy-Item -Path $file.FullName -Destination $destPath -Force
        
        if ($ItemsPushedList -notcontains "$sourceType/$relativePath") {
            $ItemsPushedList += "$sourceType/$relativePath"
        }
    }

    # A2. Sync ACTIVATE_SHADOW.md with Inheritance Merge
    if ($SyncActivateShadow) {
        $ChildActivatePath = Join-Path $child.path "ACTIVATE_SHADOW.md"
        $MotherContent = Get-Content $MotherActivatePath -Raw -Encoding UTF8
        
        if (Test-Path $ChildActivatePath) {
            $ChildContent = Get-Content $ChildActivatePath -Raw -Encoding UTF8
            $MergedContent = Merge-ActivateShadow -MotherContent $MotherContent -ChildContent $ChildContent
        }
        else {
            $MergedContent = $MotherContent
        }
        
        Set-Content -Path $ChildActivatePath -Value $MergedContent -Encoding UTF8 -Force
        Write-Host "      ✓ ACTIVATE_SHADOW.md synced (inherited)" -ForegroundColor DarkGreen
        
        if ($ItemsPushedList -notcontains "ACTIVATE_SHADOW.md") {
            $ItemsPushedList += "ACTIVATE_SHADOW.md"
        }
    }

    # B. Update Child's nurture_log.json
    $ChildLogPath = Join-Path $child.path ".shadow\memory\life\resources\system\nurture_log.json"
    $ChildLogEntry = [PSCustomObject]@{
        id          = "nur-" + (Get-Date -Format "yyyyMMdd-HHmmss")
        timestamp   = (Get-Date).ToString("yyyy-MM-ddTHH:mm:sszzz")
        source      = "shadow-genesis@$MotherVersion"
        items       = $ItemsPushedList
        description = "Nurture Component: $Component"
    }
    
    $CLog = @()
    if (Test-Path $ChildLogPath) {
        try { $CLog = Get-Content $ChildLogPath -Raw | ConvertFrom-Json } catch {}
    }
    $CLog += $ChildLogEntry
    $CLog | ConvertTo-Json -Depth 4 | Set-Content -Path $ChildLogPath -Force
}

# 4. Update Mother's nurture_history.json
$HistoryEntry = [PSCustomObject]@{
    timestamp      = (Get-Date).ToString("yyyy-MM-ddTHH:mm:sszzz")
    target_node    = $Target
    version_pushed = $MotherVersion
    component      = $Component
    items_count    = $ItemsPushedList.Count
}

$HLog = @()
if (Test-Path $HistoryFile) {
    try { $HLog = Get-Content $HistoryFile -Raw | ConvertFrom-Json } catch {}
}
$HLog += $HistoryEntry
$HLog | ConvertTo-Json -Depth 4 | Set-Content -Path $HistoryFile

Write-Host "✅ Nurture Sequence Complete. Logs synchronized." -ForegroundColor Green

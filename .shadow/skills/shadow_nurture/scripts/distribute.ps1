<#
.SYNOPSIS
    Shadow Nurture Core
    Path: .shadow/skills/shadow_nurture/scripts/distribute.ps1
#>

param (
    [Parameter(Mandatory = $false)]
    [string]$Target = "All", 
    [Parameter(Mandatory = $true)]
    [string]$Component # Relative path in .shadow/ or "All", "Skills", "Identity"
)

$MotherRoot = Resolve-Path "$PSScriptRoot\..\..\..\.."
$ShadowTemplatePath = Join-Path $MotherRoot ".shadow"
$RegistryPath = Join-Path $ShadowTemplatePath "memory\life\resources\system\child_registry.json"

Write-Host "🍼 Initiating Shadow Nurture Protocol..." -ForegroundColor Cyan

if (-not (Test-Path $RegistryPath)) {
    Write-Error "Registry not found at $RegistryPath"
    exit
}

$registry = Get-Content $RegistryPath -Raw | ConvertFrom-Json
if ($registry.Count -eq 0) {
    Write-Warning "No children registered to nurture."
    exit
}

# Define what to copy based on Component
$FilesToCopy = @()
if ($Component -eq "All") {
    # Dangerous, strict exclusions needed
    $FilesToCopy = Get-ChildItem -Path $ShadowTemplatePath -Recurse | Where-Object { 
        $_.FullName -notmatch "memory\\life\\projects\\" -and 
        $_.FullName -notmatch "child_registry.json" 
    }
}
elseif ($Component -eq "Identity") {
    $FilesToCopy = Get-ChildItem -Path $ShadowTemplatePath | Where-Object { $_.Name -match "IDENTITY|USER|tacit_knowledge" }
}
elseif ($Component -eq "Skills") {
    $FilesToCopy = Get-ChildItem -Path (Join-Path $ShadowTemplatePath "skills") -Recurse
}
else {
    # Specific component path
    $SpecificPath = Join-Path $ShadowTemplatePath $Component
    if (Test-Path $SpecificPath) {
        $item = Get-Item $SpecificPath
        if ($item.PSIsContainer) {
            $FilesToCopy = Get-ChildItem -Path $SpecificPath -Recurse
        }
        else {
            $FilesToCopy = @($item)
        }
    }
    else {
        Write-Error "Component '$Component' not found in Mother Hive."
        exit
    }
}

foreach ($child in $registry) {
    if ($Target -ne "All" -and $child.name -ne $Target -and $child.path -ne $Target) {
        continue
    }

    if (-not (Test-Path $child.path)) {
        Write-Warning "Child node not reachable: $($child.name)"
        continue
    }

    Write-Host "   >> Nurturing: $($child.name)" -ForegroundColor Gray
    
    foreach ($file in $FilesToCopy) {
        if ($file.PSIsContainer) { continue }
        
        $relativePath = $file.FullName.Substring($ShadowTemplatePath.Length).TrimStart("\")
        $destPath = Join-Path $child.path ".shadow\$relativePath"
        
        $parentDir = Split-Path $destPath -Parent
        if (-not (Test-Path $parentDir)) { New-Item -ItemType Directory -Path $parentDir -Force | Out-Null }
        
        Copy-Item -Path $file.FullName -Destination $destPath -Force
    }
}

Write-Host "✅ Nurture Sequence Complete." -ForegroundColor Green

param (
    [Parameter(Mandatory=$true)]
    [string]$TargetDirectory,
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

$SourceDirectory = "$PSScriptRoot"
$ShadowDir = Join-Path $TargetDirectory ".shadow"

if (-not (Test-Path $TargetDirectory)) {
    New-Item -ItemType Directory -Force -Path $TargetDirectory | Out-Null
    Write-Host "Created directory: $TargetDirectory"
}

# 1. Create .shadow structure first to ensure it's hidden but accessible
# Note: we don't need to explicitly hide it in PS, but we put files there.
if (-not (Test-Path $ShadowDir)) {
    New-Item -ItemType Directory -Force -Path $ShadowDir | Out-Null
    $item = Get-Item -Path $ShadowDir
    $item.Attributes = "Hidden"
}

# 2. Copy the .shadow content
$TemplateShadow = Join-Path $SourceDirectory ".shadow"
Get-ChildItem -Path $TemplateShadow -Recurse | ForEach-Object {
    $relativePath = $_.FullName.Substring($TemplateShadow.Length).TrimStart("\")
    $targetPath = Join-Path $ShadowDir $relativePath

    if ($_.PSIsContainer) {
        if (-not (Test-Path $targetPath)) {
            New-Item -ItemType Directory -Path $targetPath | Out-Null
        }
    } else {
        $parentDir = Split-Path $targetPath -Parent
        if (-not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }
        Copy-Item -Path $_.FullName -Destination $targetPath -Force

        # Replace placeholders
        if ($_.Name -in @("USER.md", "IDENTITY.md", "template_summary.md")) {
            $content = Get-Content $targetPath -Raw
            $content = $content.Replace("[Project Name]", $ProjectName)
            $content = $content.Replace("[Today]", (Get-Date).ToString("yyyy-MM-dd"))
            Set-Content -Path $targetPath -Value $content
        }
    }
}

# 3. Copy the ACTIVATE_SHADOW.md to root
$ActivateSrc = Join-Path $SourceDirectory "ACTIVATE_SHADOW.md"
$ActivateDest = Join-Path $TargetDirectory "ACTIVATE_SHADOW.md"
if (Test-Path $ActivateSrc) {
    Copy-Item -Path $ActivateSrc -Destination $ActivateDest -Force
    $content = Get-Content $ActivateDest -Raw
    $content = $content.Replace("[Project Name]", $ProjectName)
    Set-Content -Path $ActivateDest -Value $content
}

# 4. Handle project summary renaming within .shadow
$templateSummary = Join-Path $ShadowDir "memory\life\projects\template_summary.md"
$projectSummaryDir = Join-Path $ShadowDir "memory\life\projects\$ProjectName"
$projectSummary = Join-Path $projectSummaryDir "summary.md"

if (Test-Path $templateSummary) {
    if (-not (Test-Path $projectSummaryDir)) {
        New-Item -ItemType Directory -Path $projectSummaryDir | Out-Null
    }
    Move-Item -Path $templateSummary -Destination $projectSummary -Force
}

Write-Host "Shadow Genesis complete. Project '$ProjectName' initialized at '$TargetDirectory'."
Write-Host "Hidden structure '.shadow/' created."
Write-Host "Prompt for Agent: Please read 'ACTIVATE_SHADOW.md' to start."
Write-Host "The Shadow awaits your command."
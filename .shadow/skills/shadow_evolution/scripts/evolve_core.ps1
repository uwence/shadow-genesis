<#
.SYNOPSIS
    Shadow Evolution Protocol (Assimilate)
    母巢进化协议：从优秀的子节点中提取“基因”（通用结构与技能），反哺母巢。

.DESCRIPTION
    此脚本对比“当前母巢模版”与“指定子节点”的差异。
    它会自动过滤掉项目特定的数据（记忆、日志、摘要），
    只关注通用的结构文件（技能、系统设定、脚本本身）。

.PARAMETER SourcePath
    目标子节点的根目录路径。
    
.EXAMPLE
    .\evolve.ps1 -SourcePath "C:\Users\uwenc\clawd\memory\life\projects\shadow-avatar"
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$SourcePath
)

$MotherPath = $PSScriptRoot
$ShadowDir = ".shadow"

# --- 基因过滤器 (Gene Filters) ---
# 定义哪些文件代表“通用能力”，哪些代表“具体记忆”
# Exclude: 忽略的文件/目录 (Regex)
$Exclusions = @(
    "memory\\life\\projects\\.*",    # 具体项目内容
    "memory\\life\\archives\\.*",    # 归档内容
    "memory\\2.*\.md",               # 日志文件 (e.g. 2026-02-06.md)
    "USER.md",                       # 用户在特定项目下的偏好微调 (可视情况决定是否同步，通常忽略)
    "\.git.*",                       # Git 目录
    "node_modules",                  # 依赖
    "dist", "build",                 # 构建产物
    "items.json"                     # 原子记忆
)

# Include: 重点关注的进化点
# 实际上我们扫描 .shadow 下的所有文件，应用排除列表即可。
# 另外还要显式检查根目录的几个关键脚本
$RootFiles = @("genesis.ps1", "genesis.bat", "ACTIVATE_SHADOW.md", "USAGE.md")

function Test-IsExcluded {
    param($Path)
    foreach ($pattern in $Exclusions) {
        if ($Path -match $pattern) { return $true }
    }
    return $false
}

Write-Host "🧬 Shadow Evolution Protocol Initiated..." -ForegroundColor Cyan
Write-Host "Target Source (Child Node): $SourcePath" -ForegroundColor Gray
Write-Host "Mother Hive (Template):     $MotherPath" -ForegroundColor Gray
Write-Host "---------------------------------------------------"

if (-not (Test-Path $SourcePath)) {
    Write-Error "Child node path not found!"
    exit
}

# 1. 扫描根目录关键文件
foreach ($file in $RootFiles) {
    $srcFile = Join-Path $SourcePath $file
    $destFile = Join-Path $MotherPath $file

    if (Test-Path $srcFile) {
        # 比较哈希或内容
        if (Test-Path $destFile) {
            $hashSrc = Get-FileHash $srcFile | Select-Object -ExpandProperty Hash
            $hashDest = Get-FileHash $destFile | Select-Object -ExpandProperty Hash
            if ($hashSrc -ne $hashDest) {
                Write-Host "[MODIFIED] $file" -ForegroundColor Yellow
                # 实际应用中这里可以增加交互询问，但为了脚本简洁，我们先列出
            }
        }
        else {
            Write-Host "[NEW]      $file (In Child but not Mother? Unusual for root files)" -ForegroundColor Magenta
        }
    }
}

# 2. 扫描 .shadow 目录
$SourceShadow = Join-Path $SourcePath $ShadowDir
$MotherShadow = Join-Path $MotherPath $ShadowDir

if (-not (Test-Path $SourceShadow)) {
    Write-Error "Child node has no .shadow directory! Is this a valid Shadow project?"
    exit
}

$files = Get-ChildItem -Path $SourceShadow -Recurse -File

foreach ($file in $files) {
    # 计算相对路径
    $relativePath = $file.FullName.Substring($SourceShadow.Length).TrimStart("\")
    
    # 检查过滤器
    if (Test-IsExcluded -Path $relativePath) {
        continue
    }

    $destPath = Join-Path $MotherShadow $relativePath
    
    if (-not (Test-Path $destPath)) {
        Write-Host "[NEW GENE ] .shadow\$relativePath" -ForegroundColor Green
        # 这是一个新技能或新资源！
        $choice = Read-Host "  >> Assimilate this new capability? (y/n)"
        if ($choice -eq 'y') {
            $parentDir = Split-Path $destPath -Parent
            if (-not (Test-Path $parentDir)) { New-Item -ItemType Directory -Path $parentDir | Out-Null }
            Copy-Item $file.FullName -Destination $destPath
            Write-Host "  >> Assimilated." -ForegroundColor Cyan
        }
    }
    else {
        # 文件存在，对比内容
        $hashSrc = Get-FileHash $file.FullName | Select-Object -ExpandProperty Hash
        $hashDest = Get-FileHash $destPath | Select-Object -ExpandProperty Hash
        
        if ($hashSrc -ne $hashDest) {
            # 有变化
            Write-Host "[EVOLVED  ] .shadow\$relativePath" -ForegroundColor Yellow
            $choice = Read-Host "  >> Absorb evolution? (y/n)"
            if ($choice -eq 'y') {
                Copy-Item $file.FullName -Destination $destPath -Force
                Write-Host "  >> Evolved." -ForegroundColor Cyan
            }
        }
    }
}

Write-Host "---------------------------------------------------"
Write-Host "🧬 Evolution Sequence Complete. Mother Hive updated." -ForegroundColor Cyan

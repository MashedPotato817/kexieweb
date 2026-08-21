<#
校验 PR 改动是否触及约定边界外文件。供 CI 使用，也可本地运行。

用法：
  powershell -ExecutionPolicy Bypass -File scripts/check-pr-boundaries.ps1 -BaseSha <sha> -PrBody <描述文本>

参数：
  -BaseSha   PR 的基础提交（与 HEAD 比较改动文件）。
  -PrBody    PR 描述文本；从中解析整行「放行文件：<路径>」作为显式放行。

放行规则：PR 描述中以整行形式写「放行文件：<路径>」，则该路径（前缀匹配）不受边界检查拦截。
#>

param(
  [Parameter(Mandatory = $true)]
  [string]$BaseSha,

  [Parameter(Mandatory = $true)]
  [string]$PrBody
)

$ErrorActionPreference = 'Stop'

$protectedPaths = Get-Content -Path (Join-Path $PSScriptRoot 'protected-paths.txt') -Encoding UTF8 |
  Where-Object { $_ -and -not $_.TrimStart().StartsWith('#') } |
  ForEach-Object { $_.Trim() }

# 从 PR 描述解析放行行：「放行文件：<路径>」
$allowed = @()
foreach ($line in ($PrBody -split "`r?`n")) {
  $trimmed = $line.Trim()
  if ($trimmed -match '^放行文件[:：]\s*(.+)$') {
    $allowed += $Matches[1].Trim()
  }
}

$mergeBase = (git merge-base $BaseSha HEAD 2>$null | Select-Object -First 1)
if (-not $mergeBase) { throw "无法确定 $BaseSha 与 HEAD 的 merge-base。" }
$changed = git diff --name-only "$mergeBase..HEAD" 2>$null
$violations = @()
foreach ($file in ($changed | Sort-Object -Unique)) {
  if (-not $file) { continue }
  $isAllowed = $false
  foreach ($a in $allowed) {
    if ($file.StartsWith($a, [System.StringComparison]::OrdinalIgnoreCase)) { $isAllowed = $true; break }
  }
  if ($isAllowed) { continue }
  foreach ($pat in $protectedPaths) {
    if ($file -match $pat) {
      $violations += $file
      break
    }
  }
}

if ($violations.Count -gt 0) {
  Write-Host ''
  Write-Host '改动触及约定边界外文件，需负责人确认并在 PR 描述中写明放行文件：' -ForegroundColor Red
  foreach ($v in ($violations | Sort-Object -Unique)) {
    Write-Host "  - $v" -ForegroundColor Red
  }
  Write-Host '在 PR 描述中添加整行「放行文件：<路径>」可显式放行。'
  Write-Host ''
  exit 1
}

Write-Host '边界检查通过：未改动约定边界外文件。' -ForegroundColor Green
exit 0
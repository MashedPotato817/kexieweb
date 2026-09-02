<#
验证当前分支是否满足 PR 前置要求。在创建或合并 PR 前运行。

用法：
  powershell -ExecutionPolicy Bypass -File scripts/verify-pr-ready.ps1
  powershell -ExecutionPolicy Bypass -File scripts/verify-pr-ready.ps1 -AllowProtected '^CONTRIBUTING\.md$'

参数：
  -AllowProtected 本次有意修改的流程文档路径（正则，可多次传入），显式放行越界文件检测。

检查项：
  1. 分支名符合 <type>/<english-kebab-case>。
  2. 相对 origin/main 的提交信息全部符合规范并含中文主体。
  3. 工作区无未提交或未跟踪的意外改动。
  4. 未改动约定边界外的文件（如部署工作流、全局文档），除非通过 -AllowProtected 显式放行。
  5. 已存在对应 PR 时，本地 HEAD 与远端分支 head SHA 一致。
#>

param(
  [Parameter(Mandatory = $false)]
  [string[]]$AllowProtected = @(),

  [Parameter(Mandatory = $false)]
  [string]$MergeSubject,

  [Parameter(Mandatory = $false)]
  [string]$MergeBodyFile
)

$ErrorActionPreference = 'Stop'

$allowedTypes = 'feat|fix|docs|chore|style|refactor|test|perf'
$branchPattern = '^(?:' + $allowedTypes + ')/[a-z0-9]+(?:-[a-z0-9]+)*$'
$commitPattern = '^(?:' + $allowedTypes + ')(?:\([a-z0-9]+(?:-[a-z0-9]+)*\))?:\s\S.*$'

# 约定边界外的文件：未获明确授权不得改动。清单来自共享文件 protected-paths.txt。
$protectedPaths = Get-Content -Path (Join-Path $PSScriptRoot 'protected-paths.txt') -Encoding UTF8 |
  Where-Object { $_ -and -not $_.TrimStart().StartsWith('#') } |
  ForEach-Object { $_.Trim() }

$errors = [System.Collections.Generic.List[string]]::new()

# 1. 分支名
$branch = git branch --show-current
if (-not $branch) {
  $errors.Add('无法确定当前分支，请确认不在 detached HEAD 状态。')
} elseif ($branch -eq 'main') {
  $errors.Add('当前在 main 分支，不得直接在此开发或提交。')
} elseif ($branch -notmatch $branchPattern) {
  $errors.Add("分支名 '$branch' 不符合 <type>/<english-kebab-case> 规范。")
}

# 2. 工作区状态（忽略脚本自身）
$short = (git status --short | Where-Object { $_ -notmatch '^\?\?\s+scripts/verify-pr-ready\.ps1$' })
if ($short) {
  $errors.Add("工作区存在未提交改动或未跟踪文件：`n$short")
}

# 3. 相对 origin/main 的提交信息
if ($branch -and $branch -ne 'main') {
  $base = git merge-base origin/main HEAD 2>$null
  if ($LASTEXITCODE -ne 0 -or -not $base) {
    $errors.Add('无法确定 origin/main 与 HEAD 的合并基点。')
  } else {
    $messages = git log --format=%s "$base..HEAD"
    if ($messages) {
      foreach ($m in $messages) {
        if ($m -notmatch $commitPattern) {
          $errors.Add("提交信息不符合规范：$m")
        } elseif ($m -notmatch '\p{IsCJKUnifiedIdeographs}') {
          $errors.Add("提交主体缺少中文：$m")
        }
      }
    }
  }
}

# 4. 越界文件（基于已暂存 + 未暂存的改动，与 main 比较）
if ($branch -and $branch -ne 'main') {
  $changed = git diff --name-only origin/main...HEAD 2>$null
  $changed += git diff --name-only 2>$null
  $changed += git ls-files --others --exclude-standard 2>$null
  foreach ($file in ($changed | Sort-Object -Unique)) {
    if (-not $file) { continue }
    $allowed = $false
    foreach ($pat in $AllowProtected) {
      if ($file -match $pat) { $allowed = $true; break }
    }
    if ($allowed) { continue }
    foreach ($pat in $protectedPaths) {
      if ($file -match $pat) {
        $errors.Add("改动到约定边界外文件（需负责人确认）：$file")
        break
      }
    }
  }
}

# 5. 已存在 PR 时核对 head SHA
$headSha = git rev-parse HEAD 2>$null
if ($branch -and $headSha -and $branch -ne 'main') {
  $pr = gh pr list --head "$branch" --state open --json number,headRefOid 2>$null | ConvertFrom-Json
  if ($pr -and $pr.Count -gt 0) {
    foreach ($p in $pr) {
      if ($p.headRefOid -ne $headSha) {
        $errors.Add("PR #$($p.number) 的远端 head SHA 与本地不一致，需先推送同步。")
      }
    }
  }
}

# 6. 合并消息校验：提供 -MergeSubject 时才执行，供合并前校验拟填写的 merge 消息。
if ($MergeSubject) {
  $CheckMergeScript = Join-Path $PSScriptRoot 'check-merge-message.ps1'
  $checkArgs = @{ Subject = $MergeSubject }
  if ($MergeBodyFile) { $checkArgs['BodyFile'] = $MergeBodyFile }
  & $CheckMergeScript @checkArgs
  if ($LASTEXITCODE -ne 0) {
    $errors.Add("merge 消息不符合标准模板（请运行 scripts/check-merge-message.ps1 查看详情）。")
  }
}

if ($errors.Count -gt 0) {
  Write-Host ''
  Write-Host 'PR 前置校验未通过：' -ForegroundColor Red
  foreach ($e in $errors) {
    Write-Host "  - $e" -ForegroundColor Red
  }
  Write-Host ''
  exit 1
}

Write-Host 'PR 前置校验通过：分支、提交信息、工作区、改动范围均符合约定。' -ForegroundColor Green
exit 0
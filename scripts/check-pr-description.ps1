<#
校验 PR 描述是否包含模板三要素。供 CI 使用。

用法：
  powershell -ExecutionPolicy Bypass -File scripts/check-pr-description.ps1 -PrBody <描述文本>

要求 PR 描述包含以下小节（缺则失败，并提示缺哪项）：
  - 改动内容
  - 信息来源
  - 检查
#>

param(
  [Parameter(Mandatory = $true)]
  [string]$PrBody
)

$ErrorActionPreference = 'Stop'

$required = @('改动内容', '信息来源', '检查')
$missing = @()
foreach ($key in $required) {
  if ($PrBody -notmatch $key) { $missing += $key }
}

if ($missing.Count -gt 0) {
  Write-Host ''
  Write-Host 'PR 描述缺少以下模板要素，请按 .github/pull_request_template.md 补充：' -ForegroundColor Red
  foreach ($m in $missing) {
    Write-Host "  - $m" -ForegroundColor Red
  }
  Write-Host ''
  exit 1
}

Write-Host 'PR 描述包含模板三要素。' -ForegroundColor Green
exit 0
<#
校验 merge commit 消息是否符合标准模板。用于合并前确认拟填写的 subject + body，供 `gh pr merge` 前调用。

用法：
  powershell -ExecutionPolicy Bypass -File scripts/check-merge-message.ps1 -Subject 'chore(x): <中文主体>' -BodyFile <正文文件>
  powershell -ExecutionPolicy Bypass -File scripts/check-merge-message.ps1 -Subject 'chore(x): <中文主体>' -BodyText '<多行正文>'

参数：
  -Subject     merge commit 标题（第 1 行），须符合 <type>(<scope>): <中文主体>。
  -BodyFile    正文文件路径（UTF-8 无 BOM），与 -BodyText 二选一。
  -BodyText    正文字符串，与 -BodyFile 二选一。

标准模板：
  <type>(<scope>): <中文主体>

  - 改动点 1
  - 改动点 2

  验证：...均通过。

检查项：
  1. subject 符合 MAA 提交格式且主体含中文。
  2. subject 后为空白行（标题与正文分隔）。
  3. 正文每行以 `- ` 分点。
  4. 正文含「验证：」行。
  5. 全文 UTF-8 合法且不含 0x3F（问号乱码）。
#>

param(
  [Parameter(Mandatory = $true)]
  [string]$Subject,

  [Parameter(Mandatory = $false)]
  [string]$BodyFile,

  [Parameter(Mandatory = $false)]
  [string]$BodyText
)

$ErrorActionPreference = 'Stop'

if (-not $BodyFile -and -not $BodyText) {
  Write-Error '必须提供 -BodyFile 或 -BodyText 之一。'
  exit 2
}

$allowedTypes = 'feat|fix|docs|chore|style|refactor|test|perf'
$subjectPattern = '^(?:' + $allowedTypes + ')(?:\([a-z0-9]+(?:-[a-z0-9]+)*\))?:\s\S.*$'

if ($BodyFile) {
  $body = [System.IO.File]::ReadAllText($BodyFile, [System.Text.Encoding]::UTF8)
} else {
  $body = $BodyText
}

$errors = [System.Collections.Generic.List[string]]::new()

$utf8 = New-Object System.Text.UTF8Encoding($false, $true)
try {
  if ($BodyFile) {
    [void]$utf8.GetString([System.IO.File]::ReadAllBytes($BodyFile))
  } else {
    [void]$utf8.GetString([System.Text.Encoding]::UTF8.GetBytes($BodyText))
  }
} catch {
  $errors.Add('消息包含非法 UTF-8 字节。')
}

if ($Subject -notmatch $subjectPattern) {
  $errors.Add("subject 不符合 <type>(<scope>): <中文主体> 格式：$Subject")
}
if ($Subject -notmatch '\p{IsCJKUnifiedIdeographs}') {
  $errors.Add('subject 主体缺少中文。')
}

if ($Subject -match '^#|^-') {
  $errors.Add('subject 不应以注释符或分点开头。')
}

$content = "$Subject`n$body"
if (-not [regex]::IsMatch($content, '(?m)^验证[:：]')) {
  $errors.Add('正文缺少「验证：...」行。')
}

if ($body) {
  $lines = $body -split "`r?`n" | Where-Object { $_ -ne '' }
  foreach ($line in $lines) {
    if ($line -match '^#') { continue }
    if ($line -match '^验证[:：]') { continue }
    if ($line -notmatch '^- ') {
      $errors.Add("正文应使用 `- ` 分点：$line")
      break
    }
  }
}

if (@($content.ToCharArray() | Where-Object { $_ -eq [char]0x3F }).Count -gt 0) {
  $errors.Add('消息含问号乱码（0x3F），可能为编码损坏。')
}

if ($errors.Count -gt 0) {
  Write-Host ''
  Write-Host 'merge 消息不符合标准模板：' -ForegroundColor Red
  foreach ($e in $errors) {
    Write-Host "  - $e" -ForegroundColor Red
  }
  Write-Host ''
  exit 1
}

Write-Host 'merge 消息符合标准模板。' -ForegroundColor Green
exit 0

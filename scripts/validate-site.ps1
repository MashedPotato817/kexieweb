$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$indexPath = Join-Path $root 'index.html'
$scriptPath = Join-Path $root 'script.js'
$factsPath = Join-Path $root 'docs/kexie-mes/README.md'
$html = Get-Content -Raw -Encoding UTF8 $indexPath
$errors = [System.Collections.Generic.List[string]]::new()

foreach ($required in @('<!doctype html>', 'id="about"', 'id="join"', 'id="resources"', 'id="contact"', 'href="styles.css"', 'src="script.js"')) {
  if (-not $html.Contains($required)) {
    $errors.Add("index.html is missing required content: $required")
  }
}

$matches = [regex]::Matches($html, '(?:href|src)="([^"]+)"')
foreach ($match in $matches) {
  $target = $match.Groups[1].Value
  if ($target -match '^(#|https?:|mailto:|tel:|data:)') { continue }
  $pathOnly = $target.Split('?')[0].Split('#')[0]
  if ([string]::IsNullOrWhiteSpace($pathOnly)) { continue }
  $resolved = Join-Path $root ($pathOnly -replace '/', [IO.Path]::DirectorySeparatorChar)
  if (-not (Test-Path -LiteralPath $resolved)) {
    $errors.Add("Referenced local file does not exist: $target")
  }
}

# 外链出处核对：index.html 中的 https:// 外链 URL 必须作为字符串出现在事实登记处。
if (-not (Test-Path -LiteralPath $factsPath)) {
  $errors.Add("事实登记处缺失：docs/kexie-mes/README.md")
} else {
  $facts = Get-Content -Raw -Encoding UTF8 $factsPath
  foreach ($match in [regex]::Matches($html, 'https?://[^"''<> ]+')) {
    $url = $match.Value.TrimEnd(')', '>')
    if (-not $facts.Contains($url)) {
      $errors.Add("外部链接未在事实登记处登记出处：$url")
    }
  }
}

if (Get-Command node -ErrorAction SilentlyContinue) {
  & node --check $scriptPath
  if ($LASTEXITCODE -ne 0) { $errors.Add('script.js syntax check failed.') }
}

if ($errors.Count -gt 0) {
  $errors | ForEach-Object { Write-Error $_ }
  exit 1
}

Write-Host 'Static site validation passed.'

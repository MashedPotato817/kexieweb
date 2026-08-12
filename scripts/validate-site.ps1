$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$indexPath = Join-Path $root 'index.html'
$scriptPath = Join-Path $root 'script.js'
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

if (Get-Command node -ErrorAction SilentlyContinue) {
  & node --check $scriptPath
  if ($LASTEXITCODE -ne 0) { $errors.Add('script.js syntax check failed.') }
}

if ($errors.Count -gt 0) {
  $errors | ForEach-Object { Write-Error $_ }
  exit 1
}

Write-Host 'Static site validation passed.'

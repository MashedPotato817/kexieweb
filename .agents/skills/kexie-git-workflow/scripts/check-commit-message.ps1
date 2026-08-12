param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$CommitMessage
)

$allowedTypes = 'feat|fix|docs|chore|style|refactor|test|perf'
$pattern = '^(?:' + $allowedTypes + ')(?:\([a-z0-9]+(?:-[a-z0-9]+)*\))?:\s\S.*$'

if ($CommitMessage -notmatch $pattern) {
  Write-Error "Invalid commit message. Expected: <type>(<optional-scope>): <Chinese subject>"
  Write-Host 'Example: feat(about): update organization information'
  exit 1
}

Write-Host 'Commit message format passed.'

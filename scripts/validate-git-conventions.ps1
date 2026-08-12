param(
  [Parameter(Mandatory = $true)]
  [string]$BranchName,

  [Parameter(Mandatory = $true)]
  [string]$PullRequestTitle,

  [Parameter(Mandatory = $true)]
  [string]$BaseSha
)

$ErrorActionPreference = 'Stop'
$allowedTypes = 'feat|fix|docs|chore|style|refactor|test|perf'
$branchPattern = '^(?:' + $allowedTypes + ')/[a-z0-9]+(?:-[a-z0-9]+)*$'
$commitPattern = '^(?:' + $allowedTypes + ')(?:\([a-z0-9]+(?:-[a-z0-9]+)*\))?:\s\S.*$'

function Test-ConventionMessage {
  param([string]$Message, [string]$Label)

  if ($Message -notmatch $commitPattern) {
    throw "$Label must use <type>(<optional-scope>): <Chinese subject>."
  }
  if ($Message -notmatch '\p{IsCJKUnifiedIdeographs}') {
    throw "$Label must include Chinese text in the subject."
  }
}

if ($BranchName -notmatch $branchPattern) {
  throw "Branch name '$BranchName' must use <type>/<english-kebab-case>."
}

Test-ConventionMessage -Message $PullRequestTitle -Label 'Pull request title'

$commitMessages = git log --format=%s "$BaseSha..HEAD"
if ($LASTEXITCODE -ne 0) {
  throw "Could not read commits between $BaseSha and HEAD."
}
if (-not $commitMessages) {
  throw 'Pull request contains no commits.'
}

foreach ($commitMessage in $commitMessages) {
  Test-ConventionMessage -Message $commitMessage -Label "Commit message '$commitMessage'"
}

Write-Host 'Git branch, pull request title, and commit messages passed.'


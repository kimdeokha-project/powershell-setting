$ErrorActionPreference = 'Stop'

Write-Host 'Installing eza tree viewer ...' -ForegroundColor Cyan
winget install --id eza-community.eza --exact --accept-package-agreements --accept-source-agreements --silent
if ($LASTEXITCODE -notin 0, -1978335189) {
    throw "winget failed for eza-community.eza (exit $LASTEXITCODE)"
}

$profilePath = $PROFILE.CurrentUserCurrentHost
$profileDirectory = Split-Path -Parent $profilePath
New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
$profileText = if (Test-Path -LiteralPath $profilePath) { Get-Content -LiteralPath $profilePath -Raw } else { '' }

$start = '# >>> git-tree-tools >>>'
$end = '# <<< git-tree-tools <<<'
$block = @'
# >>> git-tree-tools >>>
# Directory tree with file icons and Git working-tree status.
function tree {
    param(
        [Parameter(Position = 0)][string]$Path = '.',
        [Parameter(Position = 1)][ValidateRange(1, 20)][int]$Depth = 3
    )

    if (Get-Command eza -ErrorAction SilentlyContinue) {
        eza --tree --git --icons=auto --group-directories-first "--level=$Depth" -- $Path
    } else {
        tree.com /F $Path
    }
}

# Git branch and commit history graph.
function gtree {
    git log --graph --decorate --oneline --all @args
}

# Compact changed-file list.
function gfiles {
    git status --short @args
}
# <<< git-tree-tools <<<
'@

$pattern = '(?s)' + [regex]::Escape($start) + '.*?' + [regex]::Escape($end)
if ($profileText -match $pattern) {
    $profileText = [regex]::Replace($profileText, $pattern, $block.Trim())
} else {
    $profileText = $profileText.TrimEnd() + "`r`n`r`n" + $block.Trim() + "`r`n"
}

if (Test-Path -LiteralPath $profilePath) {
    Copy-Item -LiteralPath $profilePath -Destination "$profilePath.$(Get-Date -Format 'yyyyMMdd-HHmmss').bak"
}
Set-Content -LiteralPath $profilePath -Value $profileText -Encoding utf8NoBOM

Write-Host 'Git-aware tree commands installed. Restart Windows Terminal.' -ForegroundColor Green

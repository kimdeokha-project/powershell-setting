$ErrorActionPreference = 'Stop'

$profilePath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell\Microsoft.PowerShell_profile.ps1'
$profileDirectory = Split-Path -Parent $profilePath
New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null

if (Test-Path -LiteralPath $profilePath) {
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    Copy-Item -LiteralPath $profilePath -Destination "$profilePath.$stamp.bak"
}

$profileContent = @'
# PowerShell 7 profile
$OutputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new()

# Prompt
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config 'sonicboom_dark' | Invoke-Expression
}

# Line editing and history suggestions
if (Get-Module PSReadLine -ListAvailable) {
    Import-Module PSReadLine
    Set-PSReadLineOption -EditMode Emacs
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory
    Set-PSReadLineKeyHandler -Key RightArrow -Function ForwardChar

    # Prediction UI requires an interactive terminal with VT output.
    if ($Host.UI.SupportsVirtualTerminal -and -not [Console]::IsOutputRedirected) {
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle ListView
    }
}

# Unix-like helpers
function ll { Get-ChildItem -Force @args }
function la { Get-ChildItem -Force @args }
function which {
    param([Parameter(Mandatory)][string]$Command)
    Get-Command $Command
}
function touch {
    param([Parameter(Mandatory)][string]$Path)
    if (Test-Path -LiteralPath $Path) {
        (Get-Item -LiteralPath $Path).LastWriteTime = Get-Date
    } else {
        New-Item -ItemType File -Path $Path | Out-Null
    }
}
function mkcd {
    param([Parameter(Mandatory)][string]$Path)
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location -LiteralPath $Path
}
function grep {
    param(
        [Parameter(Mandatory, Position = 0)][string]$Pattern,
        [Parameter(Position = 1)][string]$Path = '*'
    )
    Select-String -Pattern $Pattern -Path $Path
}

# Git shortcuts
function gst { git status @args }
function gaa { git add --all @args }
function gcm { git commit -m @args }
function gco { git checkout @args }
function gcb { git checkout -b @args }
function gp { git push @args }
function gl { git log --oneline --graph --decorate --all @args }

# Utilities
function reload { . $PROFILE }
function profile { code $PROFILE }
function clsall { Clear-Host }
'@

Set-Content -LiteralPath $profilePath -Value $profileContent -Encoding utf8NoBOM
Write-Output "Configured: $profilePath"

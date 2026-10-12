$ErrorActionPreference = 'Stop'

function Install-WingetPackage([string]$Id) {
    Write-Host "Installing $Id ..." -ForegroundColor Cyan
    winget install --id $Id --exact --accept-package-agreements --accept-source-agreements --silent
    if ($LASTEXITCODE -notin 0, -1978335189) {
        throw "winget failed for $Id (exit $LASTEXITCODE)"
    }
}

# Terminal file manager and lightweight helpers used by it.
Install-WingetPackage 'sxyazi.yazi'
Install-WingetPackage 'sharkdp.fd'
Install-WingetPackage 'BurntSushi.ripgrep.MSVC'
Install-WingetPackage 'junegunn.fzf'
Install-WingetPackage 'ajeetdsouza.zoxide'
Install-WingetPackage '7zip.7zip'
Install-WingetPackage 'jqlang.jq'

# Yazi uses Git for Windows' Unicode-safe file type detector.
$fileExe = 'C:\Program Files\Git\usr\bin\file.exe'
if (Test-Path -LiteralPath $fileExe) {
    [Environment]::SetEnvironmentVariable('YAZI_FILE_ONE', $fileExe, 'User')
    $env:YAZI_FILE_ONE = $fileExe
}

# Add shell integration idempotently.
$profilePath = $PROFILE.CurrentUserCurrentHost
$profileText = if (Test-Path -LiteralPath $profilePath) { Get-Content -LiteralPath $profilePath -Raw } else { '' }
$start = '# >>> terminal-workspace >>>'
$end = '# <<< terminal-workspace <<<'
$block = @'
# >>> terminal-workspace >>>
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    zoxide init powershell | Out-String | Invoke-Expression
}

# Open Yazi with `y`; quitting with q changes PowerShell to Yazi's directory.
function y {
    $tmp = (New-TemporaryFile).FullName
    try {
        yazi.exe @args --cwd-file="$tmp"
        $cwd = Get-Content -LiteralPath $tmp -Encoding UTF8 -ErrorAction SilentlyContinue
        if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
            Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
        }
    } finally {
        Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
    }
}
# <<< terminal-workspace <<<
'@

$pattern = '(?s)' + [regex]::Escape($start) + '.*?' + [regex]::Escape($end)
if ($profileText -match $pattern) {
    $profileText = [regex]::Replace($profileText, $pattern, $block.Trim())
} else {
    $profileText = $profileText.TrimEnd() + "`r`n`r`n" + $block.Trim() + "`r`n"
}
$profileBackup = "$profilePath.$(Get-Date -Format 'yyyyMMdd-HHmmss').bak"
Copy-Item -LiteralPath $profilePath -Destination $profileBackup -ErrorAction SilentlyContinue
Set-Content -LiteralPath $profilePath -Value $profileText -Encoding utf8NoBOM

# Apply the tracked high-contrast Yazi configuration.
& (Join-Path $PSScriptRoot 'apply-yazi-appearance.ps1')

# Windows Terminal: tabs plus convenient Ghostty-like pane controls.
$settingsPath = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'
if (-not (Test-Path -LiteralPath $settingsPath)) { throw "Windows Terminal settings not found: $settingsPath" }
Copy-Item -LiteralPath $settingsPath -Destination "$settingsPath.$(Get-Date -Format 'yyyyMMdd-HHmmss').bak"
$settings = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json
$settings | Add-Member -NotePropertyName alwaysShowTabs -NotePropertyValue $true -Force

$ids = @(
    'User.NewTab','User.SplitAuto','User.SplitVertical','User.SplitHorizontal',
    'User.FocusLeft','User.FocusRight','User.FocusUp','User.FocusDown',
    'User.ResizeLeft','User.ResizeRight','User.ResizeUp','User.ResizeDown','User.ToggleZoom','User.ClosePane'
)
$newActions = @(
    [pscustomobject]@{ id='User.NewTab'; name='New tab'; command='newTab' },
    [pscustomobject]@{ id='User.SplitAuto'; name='Split pane automatically'; command=[pscustomobject]@{ action='splitPane'; split='auto'; splitMode='duplicate' } },
    [pscustomobject]@{ id='User.SplitVertical'; name='Split pane right'; command=[pscustomobject]@{ action='splitPane'; split='right'; splitMode='duplicate' } },
    [pscustomobject]@{ id='User.SplitHorizontal'; name='Split pane down'; command=[pscustomobject]@{ action='splitPane'; split='down'; splitMode='duplicate' } },
    [pscustomobject]@{ id='User.FocusLeft'; command=[pscustomobject]@{ action='moveFocus'; direction='left' } },
    [pscustomobject]@{ id='User.FocusRight'; command=[pscustomobject]@{ action='moveFocus'; direction='right' } },
    [pscustomobject]@{ id='User.FocusUp'; command=[pscustomobject]@{ action='moveFocus'; direction='up' } },
    [pscustomobject]@{ id='User.FocusDown'; command=[pscustomobject]@{ action='moveFocus'; direction='down' } },
    [pscustomobject]@{ id='User.ResizeLeft'; command=[pscustomobject]@{ action='resizePane'; direction='left' } },
    [pscustomobject]@{ id='User.ResizeRight'; command=[pscustomobject]@{ action='resizePane'; direction='right' } },
    [pscustomobject]@{ id='User.ResizeUp'; command=[pscustomobject]@{ action='resizePane'; direction='up' } },
    [pscustomobject]@{ id='User.ResizeDown'; command=[pscustomobject]@{ action='resizePane'; direction='down' } },
    [pscustomobject]@{ id='User.ToggleZoom'; command='togglePaneZoom' },
    [pscustomobject]@{ id='User.ClosePane'; name='Close focused pane'; command='closePane' }
)
$newKeys = @(
    [pscustomobject]@{ id='User.NewTab'; keys='ctrl+t' },
    [pscustomobject]@{ id='User.SplitAuto'; keys='alt+shift+d' },
    [pscustomobject]@{ id='User.SplitVertical'; keys='ctrl+shift+\' },
    [pscustomobject]@{ id='User.SplitHorizontal'; keys='ctrl+shift+-' },
    [pscustomobject]@{ id='User.FocusLeft'; keys='ctrl+shift+h' },
    [pscustomobject]@{ id='User.FocusDown'; keys='ctrl+shift+j' },
    [pscustomobject]@{ id='User.FocusUp'; keys='ctrl+shift+k' },
    [pscustomobject]@{ id='User.FocusRight'; keys='ctrl+shift+l' },
    [pscustomobject]@{ id='User.ResizeLeft'; keys='alt+shift+h' },
    [pscustomobject]@{ id='User.ResizeDown'; keys='alt+shift+j' },
    [pscustomobject]@{ id='User.ResizeUp'; keys='alt+shift+k' },
    [pscustomobject]@{ id='User.ResizeRight'; keys='alt+shift+l' },
    [pscustomobject]@{ id='User.ToggleZoom'; keys='ctrl+shift+enter' },
    [pscustomobject]@{ id='User.ClosePane'; keys='ctrl+w' }
)
$settings.actions = @($settings.actions | Where-Object { $_.id -notin $ids }) + $newActions
$reservedKeys = @($newKeys.keys)
$settings.keybindings = @($settings.keybindings | Where-Object { $_.id -notin $ids -and $_.keys -notin $reservedKeys }) + $newKeys
$settings | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $settingsPath -Encoding utf8NoBOM

Write-Host ''
Write-Host 'Terminal workspace configured. Close and reopen Windows Terminal.' -ForegroundColor Green
Write-Host 'Run y for the file manager. Run z <part-of-path> for fast directory jumps.'

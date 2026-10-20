$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'install-winget-package.ps1')

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

# Apply Windows Terminal shortcuts using shared path detection.
& (Join-Path $PSScriptRoot 'update-terminal-keybindings.ps1')

Write-Host 'Terminal workspace configured. Reopen Windows Terminal.' -ForegroundColor Green

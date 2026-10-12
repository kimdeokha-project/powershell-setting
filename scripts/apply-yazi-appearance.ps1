$ErrorActionPreference = 'Stop'

$source = Join-Path (Split-Path -Parent $PSScriptRoot) 'config\yazi'
$target = Join-Path $env:APPDATA 'yazi\config'

if (-not (Test-Path -LiteralPath $source)) {
    throw "Yazi configuration source not found: $source"
}

New-Item -ItemType Directory -Path $target -Force | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

foreach ($name in 'yazi.toml','theme.toml') {
    $destination = Join-Path $target $name
    if (Test-Path -LiteralPath $destination) {
        Copy-Item -LiteralPath $destination -Destination "$destination.$stamp.bak"
    }
    Copy-Item -LiteralPath (Join-Path $source $name) -Destination $destination -Force
}

Write-Host 'High-contrast Yazi appearance applied.' -ForegroundColor Green
Write-Host 'Close any running Yazi instance and run y again.'

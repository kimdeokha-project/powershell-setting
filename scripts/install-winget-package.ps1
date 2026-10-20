$ErrorActionPreference = 'Stop'
function Install-WingetPackage {
    param([Parameter(Mandatory)][string]$Id)
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw 'winget not found. Install or repair App Installer first.'
    }
    Write-Host "Ensuring $Id is installed (winget source) ..." -ForegroundColor Cyan
    & winget install --id $Id --exact --source winget --accept-package-agreements --accept-source-agreements --silent --disable-interactivity
    $exitCode = $LASTEXITCODE
    # winget may return a nonzero code for an already installed package.
    if ($exitCode -ne 0) {
        $found = & winget list --id $Id --exact --source winget --accept-source-agreements 2>&1
        if ($LASTEXITCODE -ne 0 -or -not (($found | Out-String) -match [regex]::Escape($Id))) {
            throw "winget failed for $Id (exit $exitCode). See output above."
        }
        Write-Host "Already installed: $Id" -ForegroundColor Yellow
    }
}

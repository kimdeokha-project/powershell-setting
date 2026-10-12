$ErrorActionPreference = 'Stop'

$scripts = Join-Path $PSScriptRoot 'scripts'

& (Join-Path $scripts 'setup-powershell.ps1')
& (Join-Path $scripts 'setup-terminal-workspace.ps1')
& (Join-Path $scripts 'setup-neovim.ps1')

Write-Host ''
Write-Host 'Integrated terminal workspace installation is complete.' -ForegroundColor Green
Write-Host 'Close all Windows Terminal windows and open a new one.'
Write-Host 'Then run nvim once to install LazyVim plugins.'

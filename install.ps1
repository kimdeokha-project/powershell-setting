$ErrorActionPreference = 'Stop'

$scripts = Join-Path $PSScriptRoot 'scripts'
if ($PSVersionTable.PSVersion.Major -lt 7) { throw 'Run this installer with PowerShell 7 (pwsh).' }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw 'Git is required. Install Git for Windows first.' }


& (Join-Path $scripts 'setup-powershell.ps1')
. (Join-Path $scripts 'install-winget-package.ps1')
Install-WingetPackage 'JanDeDobbeleer.OhMyPosh'
& (Join-Path $scripts 'setup-git-tree.ps1')
& (Join-Path $scripts 'setup-terminal-workspace.ps1')
& (Join-Path $scripts 'setup-neovim.ps1')

Write-Host ''
Write-Host 'Integrated terminal workspace installation is complete.' -ForegroundColor Green
Write-Host 'Close all Windows Terminal windows and open a new one.'
Write-Host 'Then run nvim once to install LazyVim plugins.'

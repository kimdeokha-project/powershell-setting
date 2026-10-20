$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'install-winget-package.ps1')

Install-WingetPackage 'Neovim.Neovim'
Install-WingetPackage 'JesseDuffield.lazygit'
Install-WingetPackage 'zig.zig'

$source = Join-Path (Split-Path -Parent $PSScriptRoot) 'config\nvim'
$target = Join-Path $env:LOCALAPPDATA 'nvim'

if (-not (Test-Path -LiteralPath $source)) {
    throw "Neovim configuration source not found: $source"
}

if (Test-Path -LiteralPath $target) {
    $backup = "$target.$(Get-Date -Format 'yyyyMMdd-HHmmss').bak"
    Copy-Item -LiteralPath $target -Destination $backup -Recurse
    Write-Host "Backed up existing Neovim configuration to $backup"
}

New-Item -ItemType Directory -Path $target -Force | Out-Null
Copy-Item -Path (Join-Path $source '*') -Destination $target -Recurse -Force

[Environment]::SetEnvironmentVariable('EDITOR', 'nvim', 'User')
[Environment]::SetEnvironmentVariable('VISUAL', 'nvim', 'User')
$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'

Write-Host ''
Write-Host 'Neovim configuration installed.' -ForegroundColor Green
Write-Host 'Restart Windows Terminal, then run: nvim'
Write-Host 'LazyVim will install its plugins on the first launch.'

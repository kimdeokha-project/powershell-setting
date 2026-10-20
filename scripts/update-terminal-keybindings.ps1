$ErrorActionPreference = 'Stop'

$candidates = @(
    (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'),
    (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json'),
    (Join-Path $env:LOCALAPPDATA 'Microsoft\Windows Terminal\settings.json')
)
$settingsPath = $candidates | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
if (-not $settingsPath) { throw "Windows Terminal settings.json not found. Start Windows Terminal once, then retry." }

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
Copy-Item -LiteralPath $settingsPath -Destination "$settingsPath.$stamp.bak"
$settings = Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json

$ids = @(
    'User.NewTab','User.SplitAuto','User.SplitVertical','User.SplitHorizontal',
    'User.FocusLeft','User.FocusRight','User.FocusUp','User.FocusDown',
    'User.ResizeLeft','User.ResizeRight','User.ResizeUp','User.ResizeDown','User.ToggleZoom','User.ClosePane'
)

$actions = @(
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

$keybindings = @(
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

$reservedKeys = @($keybindings.keys)
$settings.actions = @($settings.actions | Where-Object { $_.id -notin $ids }) + $actions
$settings.keybindings = @($settings.keybindings | Where-Object {
    $_.id -notin $ids -and $_.keys -notin $reservedKeys
}) + $keybindings

$settings | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $settingsPath -Encoding utf8NoBOM
Write-Host 'Keybindings updated. Close and reopen Windows Terminal.' -ForegroundColor Green

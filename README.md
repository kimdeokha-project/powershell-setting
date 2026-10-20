# PowerShell & Windows Terminal Setting

Windows에서 PowerShell 7, Windows Terminal, Oh My Posh, Yazi, Neovim을 하나의 흐름으로 사용하는 개인 개발환경 설정입니다.

## 포함 기능

- PowerShell 7용 Oh My Posh 프롬프트
- PSReadLine 자동완성 및 히스토리 검색
- `ll`, `touch`, `mkcd` 등 Unix 스타일 보조 명령
- Git 단축 명령
- Git 상태가 표시되는 디렉터리 트리와 커밋 그래프
- Yazi 터미널 파일 관리자
- 고대비 Yazi 테마와 넓은 미리보기 레이아웃
- LazyVim 기반 Neovim 코드 편집 환경
- Yazi ↔ Neovim 양방향 파일 탐색 연동
- Pyright와 다중 언어 LSP, Treesitter 문법 강조, Tab 자동완성
- zoxide 디렉터리 빠른 이동
- Windows Terminal 탭 및 Vim 스타일 패널 조작
- 변경 전 PowerShell 프로필과 Windows Terminal 설정 자동 백업

## 요구 사항

- Windows 10 또는 Windows 11
- [PowerShell 7](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows)
- [Windows Terminal](https://learn.microsoft.com/windows/terminal/install)
- `winget`
- Git for Windows

PowerShell 7과 Windows Terminal이 없다면 먼저 설치합니다.

```powershell
winget install --id Microsoft.PowerShell --exact --source winget
winget install --id Microsoft.WindowsTerminal --exact --source winget
winget install --id JanDeDobbeleer.OhMyPosh --exact --source winget
```

설치 후 Windows Terminal의 PowerShell 7 탭에서 나머지 명령을 실행합니다.

## 설치 문제 해결: 도구가 없거나 프롬프트가 기본 모양일 때

**PowerShell 7 설치와 환경설정 완료는 별개입니다.** `$PROFILE` 파일이 존재하더라도 eza/Yazi/Neovim 등의 도구가 설치됐다는 뜻은 아닙니다. 특히 `install.ps1`의 도구 설치 단계에서 winget이 실패하면 뒤 단계는 실행되지 않을 수 있습니다.

### 1. 현재 환경 확인

PowerShell 7 탭에서 실행합니다.

```powershell
$PSVersionTable.PSVersion
$PROFILE
Test-Path $PROFILE
'git','winget','oh-my-posh','eza','yazi','zoxide','nvim','lazygit','fd','rg' | ForEach-Object {
    $cmd = Get-Command $_ -ErrorAction SilentlyContinue
    if ($cmd) { "[OK] $_" } else { "[MISSING] $_" }
}
'gst','gtree','gfiles','y','z','reload' | ForEach-Object {
    $cmd = Get-Command $_ -ErrorAction SilentlyContinue
    if ($cmd) { "[OK] $_" } else { "[MISSING] $_" }
}
```

### 2. winget의 msstore 인증서 오류 우회

`0x8a15005e` 또는 `원본을 검색하는 동안 실패함: msstore`가 표시되면 패키지 ID를 지정할 때 **`--source winget`**을 사용해 Store 원본 검색을 피합니다. 네트워크 인증서 검증을 비활성화하지 마세요.

```powershell
winget install --id JanDeDobbeleer.OhMyPosh --exact --source winget
winget install --id eza-community.eza --exact --source winget
winget install --id sxyazi.yazi --exact --source winget
winget install --id sharkdp.fd --exact --source winget
winget install --id BurntSushi.ripgrep.MSVC --exact --source winget
winget install --id junegunn.fzf --exact --source winget
winget install --id ajeetdsouza.zoxide --exact --source winget
winget install --id 7zip.7zip --exact --source winget
winget install --id jqlang.jq --exact --source winget
winget install --id Neovim.Neovim --exact --source winget
winget install --id JesseDuffield.lazygit --exact --source winget
winget install --id zig.zig --exact --source winget
```

> **주의:** 현재 `scripts/setup-git-tree.ps1`, `scripts/setup-terminal-workspace.ps1`, `scripts/setup-neovim.ps1` 내부의 winget 호출에는 아직 `--source winget` 옵션이 없습니다. 위 수동 설치가 완료돼도 전체 설치 스크립트의 원본 검색 오류가 재발할 수 있습니다. 안정적인 자동 설치를 위해서는 **스크립트 자체도 수정**해야 합니다.

### 3. 설치 상태와 프로필 적용 점검

새 PowerShell 7 터미널을 연 뒤 도구를 다시 점검합니다. `$PROFILE`이 실제로 가리키는 파일을 확인하고, 기존 프로필을 덮어쓰기 전에 백업 상태를 검토하세요.

```powershell
Test-Path $PROFILE
Get-Command oh-my-posh,eza,yazi,zoxide,nvim -ErrorAction SilentlyContinue
Get-Command gst,gtree,gfiles,y,z -ErrorAction SilentlyContinue
```

PowerShell의 현재 호스트 프로필과 스크립트의 대상 경로가 다른 경우 사용자 설정이 반영되지 않을 수 있습니다. Windows Terminal 설정 경로는 설치 방식에 따라 달라질 수 있으므로 `settings.json` 존재 여부도 확인하세요.

## 설치

저장소를 복제합니다.

```powershell
git clone https://github.com/kimdeokha-project/powershell-setting.git
cd powershell-setting
```

전체 환경을 한 번에 설치합니다.

```powershell
pwsh -NoProfile -File .\install.ps1
```

아래 개별 설치 명령은 필요한 구성만 다시 적용할 때 사용합니다.

현재 PowerShell 프로필을 구성합니다.

```powershell
pwsh -NoProfile -File .\scripts\setup-powershell.ps1
```

Yazi와 검색 도구를 설치하고 Windows Terminal을 구성합니다.

```powershell
pwsh -NoProfile -File .\scripts\setup-terminal-workspace.ps1
```

완료되면 Windows Terminal을 완전히 닫았다가 다시 실행합니다.

Neovim과 LazyVim 설정을 설치합니다.

```powershell
pwsh -NoProfile -File .\scripts\setup-neovim.ps1
```

터미널을 다시 시작한 뒤 `nvim`을 처음 실행하면 LazyVim 플러그인이 자동 설치됩니다.

## 단축키

| 기능 | 단축키 |
|---|---|
| 새 탭 | `Ctrl+T` |
| 좌우 분할 | `Ctrl+Shift+\` |
| 상하 분할 | `Ctrl+Shift+-` |
| 패널 닫기 | `Ctrl+W` |
| 패널 이동 | `Ctrl+Shift+H/J/K/L` |
| 패널 크기 조절 | `Alt+Shift+H/J/K/L` |
| 자동 방향 분할 | `Alt+Shift+D` |
| 현재 패널 확대/복원 | `Ctrl+Shift+Enter` |

`H/J/K/L` 방향은 Vim과 동일하게 왼쪽/아래/위/오른쪽입니다.

## 파일 탐색과 디렉터리 이동

```powershell
y
```

Yazi가 현재 디렉터리에서 열립니다. `q`로 종료하면 Yazi에서 선택한 디렉터리가 PowerShell의 현재 경로가 됩니다. 경로를 변경하지 않고 종료하려면 `Q`를 사용합니다.

최근 방문한 디렉터리는 zoxide로 빠르게 이동할 수 있습니다.

```powershell
z project
```

## Git 트리 보기

현재 폴더의 파일 구조와 각 파일의 Git 상태를 함께 표시합니다. 기본 깊이는 3단계입니다.

```powershell
tree
tree . 2
tree src 5
```

브랜치와 커밋 이력을 그래프로 표시합니다.

```powershell
gtree
```

변경된 파일만 간단히 확인합니다.

```powershell
gfiles
```

이 기능만 설치하거나 다시 적용하려면 다음을 실행합니다.

```powershell
pwsh -NoProfile -File .\scripts\setup-git-tree.ps1
```

## Neovim 통합

PowerShell에서 파일이나 프로젝트를 엽니다.

```powershell
nvim README.md
nvim .
```

Yazi에서 텍스트 또는 코드 파일에 Enter를 누르면 같은 터미널에서 Neovim으로 열립니다. Neovim에서는 다음 키를 사용합니다.

| 기능 | Neovim 단축키 |
|---|---|
| 현재 파일 위치에서 Yazi | `<Space>e` |
| 현재 작업 폴더에서 Yazi | `<Space>E` |
| 마지막 Yazi 세션 복귀 | `<Space>-` |
| 창 이동 | `Ctrl+H/J/K/L` |
| 창 크기 조절 | `Alt+Shift+H/J/K/L` |
| 저장 | `Ctrl+S` |
| 버퍼 닫기 | `<Space>q` |

Neovim 안에서 열린 Yazi는 `F1`로 전체 키 도움말을 확인할 수 있습니다. 선택 파일을 세로 분할로 열려면 `Ctrl+V`, 가로 분할은 `Ctrl+X`, 새 탭은 `Ctrl+T`를 사용합니다.

### 지원 언어와 편집 기능

| 언어/형식 | 기본 지원 |
|---|---|
| Python | Pyright, Ruff 연동, 타입 진단, 자동완성 |
| C/C++ | clangd, 헤더 이동, 진단, 자동완성 |
| C#/.NET | Roslyn 기반 기능, 프로젝트 탐색, 진단 |
| JavaScript/TypeScript | TypeScript 언어 서버, 자동 import, 진단 |
| Lua | lua-language-server 및 Neovim API 완성 |
| PowerShell | PowerShell Editor Services |
| JSON/YAML/TOML | 스키마 기반 완성 및 검증 |
| Markdown | 문법 강조와 문서 편집 지원 |

입력 중 자동완성 메뉴가 나타나며 `Tab`으로 선택 항목을 확정하고 `Shift+Tab`으로 이전 항목을 선택합니다. 함수 설명과 매개변수 도움말도 자동 표시됩니다. Treesitter와 Tokyo Night 테마가 키워드, 문자열, 함수, 타입, 주석 등을 색상으로 구분합니다.

Neovim 안에서 설치 및 연결 상태를 확인할 수 있습니다.

```vim
:Mason
:LspInfo
:checkhealth
```

### Yazi 화면만 다시 적용

선택 위치, 폴더, 파일 종류와 팝업의 대비를 높인 테마만 다시 적용할 수 있습니다.

```powershell
pwsh -NoProfile -File .\scripts\apply-yazi-appearance.ps1
```

적용 후 실행 중인 Yazi를 종료하고 `y`로 다시 실행합니다. 기존 Yazi 설정은 `.bak`으로 백업됩니다.

## 단축키만 다시 적용

전체 도구를 다시 설치하지 않고 Windows Terminal 단축키만 갱신하려면 다음을 실행합니다.

```powershell
pwsh -NoProfile -File .\scripts\update-terminal-keybindings.ps1
```

## 백업과 복구

스크립트는 파일을 변경하기 전에 같은 디렉터리에 타임스탬프가 포함된 `.bak` 파일을 만듭니다.

- PowerShell 프로필: `Documents\PowerShell\Microsoft.PowerShell_profile.ps1.*.bak`
- Windows Terminal: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json.*.bak`

복구하려면 터미널을 종료하고 원하는 백업 파일을 원래 파일명으로 복사합니다.

## 저장소 구조

```text
powershell-setting/
├─ README.md
├─ install.ps1
├─ config/
│  ├─ nvim/
│  └─ yazi/
└─ scripts/
   ├─ setup-powershell.ps1
   ├─ setup-git-tree.ps1
   ├─ setup-terminal-workspace.ps1
   ├─ apply-yazi-appearance.ps1
   ├─ setup-neovim.ps1
   └─ update-terminal-keybindings.ps1
```

## 참고

- Windows Terminal 설정은 사용자별 `settings.json`을 수정합니다.
- `Ctrl+W`는 PowerShell의 단어 삭제 기능보다 Windows Terminal의 패널 닫기 기능이 우선합니다.
- Yazi 파일 형식 감지를 위해 Git for Windows의 `file.exe`를 사용합니다.
- 스크립트는 개인 설정 파일을 포함하지 않으며 토큰이나 비밀번호를 저장하지 않습니다.

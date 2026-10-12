# PowerShell & Windows Terminal Setting

Windows에서 PowerShell 7, Windows Terminal, Oh My Posh, Yazi를 이용해 탭·분할 패널·터미널 파일 탐색 환경을 구성하는 개인 설정입니다.

## 포함 기능

- PowerShell 7용 Oh My Posh 프롬프트
- PSReadLine 자동완성 및 히스토리 검색
- `ll`, `touch`, `mkcd` 등 Unix 스타일 보조 명령
- Git 단축 명령
- Yazi 터미널 파일 관리자
- 고대비 Yazi 테마와 넓은 미리보기 레이아웃
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
winget install --id Microsoft.PowerShell --exact
winget install --id Microsoft.WindowsTerminal --exact
winget install --id JanDeDobbeleer.OhMyPosh --exact
```

설치 후 Windows Terminal의 PowerShell 7 탭에서 나머지 명령을 실행합니다.

## 설치

저장소를 복제합니다.

```powershell
git clone https://github.com/kimdeokha-project/powershell-setting.git
cd powershell-setting
```

현재 PowerShell 프로필을 구성합니다.

```powershell
pwsh -NoProfile -File .\scripts\setup-powershell.ps1
```

Yazi와 검색 도구를 설치하고 Windows Terminal을 구성합니다.

```powershell
pwsh -NoProfile -File .\scripts\setup-terminal-workspace.ps1
```

완료되면 Windows Terminal을 완전히 닫았다가 다시 실행합니다.

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
└─ scripts/
   ├─ setup-powershell.ps1
   ├─ setup-terminal-workspace.ps1
   ├─ apply-yazi-appearance.ps1
   └─ update-terminal-keybindings.ps1
```

## 참고

- Windows Terminal 설정은 사용자별 `settings.json`을 수정합니다.
- `Ctrl+W`는 PowerShell의 단어 삭제 기능보다 Windows Terminal의 패널 닫기 기능이 우선합니다.
- Yazi 파일 형식 감지를 위해 Git for Windows의 `file.exe`를 사용합니다.
- 스크립트는 개인 설정 파일을 포함하지 않으며 토큰이나 비밀번호를 저장하지 않습니다.

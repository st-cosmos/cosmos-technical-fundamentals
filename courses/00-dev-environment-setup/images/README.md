# 설치 가이드 스크린샷 목록

`docs/02-windows-setup.md`, `docs/03-macos-setup.md`, `slides/dev-environment-setup.md` 가 아래 파일명을
참조합니다. **같은 이름으로 이 폴더에 넣으면** 문서와 슬라이드(PDF)에 자동으로 들어갑니다.
권장 크기: 가로 1400px 이하, PNG. 개인정보(이메일·계정명)는 가려 주세요.

## Windows

| 파일명 | 장면 |
|--------|------|
| `win-01-download-zip.png` | GitHub 저장소 페이지의 **Code → Download ZIP** 버튼 |
| `win-02-security-warning.png` | `install-windows.cmd` 더블클릭 시 뜨는 보안 경고 — "이 파일을 실행하시겠습니까?" 또는 "Windows의 PC 보호"(추가 정보 → 실행) |
| `win-02-open-powershell.png` | 시작 메뉴에서 **PowerShell 7** 검색 결과 (검은 아이콘, pwsh) |
| `win-03-install-script.png` | `install-windows.cmd` 실행 중 검은 창 (`==> Git 설치` 등 진행 로그, UAC 창 포함하면 좋음) |
| `win-04-check-script.png` | `check-windows.cmd` 결과 표 (전부 `[OK]`) |
| `win-05-codex-login.png` | `codex login` 후 브라우저의 ChatGPT 로그인/승인 화면 + 터미널 성공 메시지 |
| `win-06-vscode-extensions.png` | VS Code 사이드바에 **PlatformIO 🛸** 아이콘과 Source Control 패널의 **Git Graph** 아이콘 |
| `win-07-terminal-default-profile.png` | Windows Terminal 설정 → 시작 → **기본 프로필: PowerShell** |

## macOS

| 파일명 | 장면 |
|--------|------|
| `mac-01-download-zip.png` | GitHub **Code → Download ZIP** |
| `mac-02-gatekeeper.png` | `install-macos.command` 더블클릭 시 Gatekeeper 경고 + 시스템 설정 → 개인정보 보호 및 보안 → **그래도 열기** 버튼 |
| `mac-02-open-terminal.png` | Spotlight(⌘+Space)에서 **터미널** 검색 |
| `mac-03-install-script.png` | `install-macos.command` 실행 중 터미널 창 (Homebrew 비밀번호 입력 또는 Xcode CLT 설치 창) |
| `mac-04-check-script.png` | `check-macos.command` 결과 (전부 `[OK]`) |
| `mac-05-codex-login.png` | `codex login` 브라우저 화면 + 터미널 성공 메시지 |
| `mac-06-vscode-extensions.png` | VS Code 에 PlatformIO 🛸 · Git Graph 아이콘 |

## 공통 (슬라이드용)

| 파일명 | 장면 |
|--------|------|
| `common-01-vscode-platformio-home.png` | VS Code 에서 PlatformIO 아이콘을 눌렀을 때의 **PIO Home** 화면 |
| `common-02-git-graph-view.png` | Git Graph 로 커밋 그래프를 연 모습 (아무 저장소) |

> 💡 파일이 아직 없어도 문서·슬라이드 빌드는 됩니다(이미지 자리만 비어 보임). 캡처가 준비되는 대로
> 채워 넣고 `npm run pdf -- 00-dev` 로 PDF 를 다시 만들면 됩니다.

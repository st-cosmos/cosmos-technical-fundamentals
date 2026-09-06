# 04. 확인과 문제 해결

## 한 줄 요약

> 확인 스크립트(`check-windows.cmd` / `check-macos.command` 더블클릭)는 도구마다 **버전을 출력해 ✅/❌** 를 표시합니다.
> ❌ 가 나오면 아래 표에서 해당 도구를 찾아 조치한 뒤 **다시 더블클릭**(터미널이면 **새 터미널에서**) 실행하세요.

## 1. 확인 스크립트가 보는 것

| 항목 | 확인 명령 | 기대 결과 |
|------|-----------|-----------|
| PowerShell 7 (Windows) | `pwsh -v` | `PowerShell 7.x` |
| Git | `git --version` | `git version 2.x` |
| VS Code | `code --version` | `1.xx` |
| Python | `python --version` (Win) / `python3 --version` (mac) | `Python 3.x` |
| uv | `uv --version` | `uv 0.x` |
| Codex CLI | `codex --version` | `codex-cli 0.x` |
| PlatformIO 확장 | `code --list-extensions` 에 `platformio.platformio-ide` | 포함 |
| Git Graph 확장 | `code --list-extensions` 에 `mhutchie.git-graph` | 포함 |
| Codex 로그인 (선택) | `codex login status` | 로그인됨 |

> 💡 직접 한 줄씩 쳐 봐도 됩니다. **명령을 쳤을 때 버전이 나오면 설치된 것**, "찾을 수 없다"(`not found`,
> `not recognized`)면 설치가 안 됐거나 PATH 에 없는 것입니다.

## 2. 가장 흔한 원인 — 터미널을 새로 안 열었다

설치 직후 같은 창에서는 새 프로그램을 못 찾는 경우가 많습니다. **터미널을 완전히 닫고 새로 열어** 다시
확인하세요. Windows 는 특히 **PowerShell 7(pwsh)** 로 새로 여세요. (더블클릭 실행은 매번 새 창이라 이 문제가 없습니다)

## 2-1. 더블클릭 실행이 안 될 때

| OS | 증상 | 조치 |
|----|------|------|
| Windows | `.cmd` 를 더블클릭하니 **"이 파일을 실행하시겠습니까?"** / **"Windows의 PC 보호"** | 인터넷에서 받은 파일에 붙는 표시일 뿐입니다. **실행** (PC 보호 창은 **추가 정보 → 실행**) |
| Windows | 더블클릭하니 **메모장**이 열림 | `.ps1` 을 눌렀습니다. **`.cmd`** 파일(`install-windows.cmd`)을 더블클릭하세요 |
| Windows | 창이 열렸다 **바로 닫힘** | `.cmd` 는 끝에 키 입력을 기다리므로 정상이면 안 닫힙니다. 터미널 방식(docs/02 2절)으로 실행해 오류 메시지를 확인하세요 |
| macOS | **"확인되지 않은 개발자"** / **"악성 코드가 없는지 확인할 수 없음"** 으로 열리지 않음 | **시스템 설정 → 개인정보 보호 및 보안** → 아래쪽 **"그래도 열기"** → 다시 더블클릭. (macOS 13 이하: control + 클릭 → 열기) |
| macOS | **"권한이 없어 실행할 수 없음"** | 브라우저로 파일만 따로 받으면 실행 권한이 빠집니다. 저장소 **ZIP 으로** 받거나, 터미널에서 `bash ~/Downloads/install-macos.command` 로 실행하세요 |
| macOS | 더블클릭하니 **텍스트 편집기**가 열림 | 파일 이름이 `.command` 로 끝나는지 확인하세요 (`.sh` 가 아님) |

## 3. 도구별 문제 해결

### Windows

| 증상 | 조치 |
|------|------|
| `winget` 을 찾을 수 없음 | Microsoft Store → **"앱 설치 관리자"** 업데이트. 또는 Store 에서 각 앱을 직접 설치 |
| (터미널 방식) 스크립트 실행이 차단됨 (`...실행할 수 없습니다`) | `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` 를 먼저 실행했는지 확인. 더블클릭(`.cmd`)은 이 설정이 필요 없음 |
| `python` 을 치면 Microsoft Store 가 열림 | 설정 → 앱 → **앱 실행 별칭** 에서 `python.exe`/`python3.exe` 의 "App Installer" 항목을 **끄기**. 그래도 안 되면 `winget install --id Python.Python.3.12` 재실행 |
| `code` 명령 없음 | VS Code 설치 후 새 터미널. 그래도 없으면 VS Code 재설치 시 "PATH에 추가" 옵션 확인 |
| `uv` 없음 | `winget install --id astral-sh.uv` 또는 `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 \| iex"` |
| `codex` 없음 (winget 에는 설치됐다고 나옴) | 개발자 모드가 꺼진 PC 에서 winget 이 `codex.exe` 링크를 못 만든 경우. **설치 스크립트를 다시 실행**하면 `codex.cmd` 를 만들어 줍니다. 새 터미널에서 확인 |
| `codex` 없음 (winget 에도 없음) | `winget install --id OpenAI.Codex` 재실행 후 설치 스크립트 재실행. 새 터미널 |
| PlatformIO 아이콘이 안 보임 | VS Code 를 켠 채 몇 분 대기(Core 설치). 하단 상태바 메시지 확인. 안 되면 확장 탭에서 **PlatformIO IDE** 재설치 |
| 확장이 설치 안 됨 | `code --install-extension platformio.platformio-ide` / `code --install-extension mhutchie.git-graph` 직접 실행 |

### macOS

| 증상 | 조치 |
|------|------|
| `brew` 없음 (설치 직후) | `eval "$(/opt/homebrew/bin/brew shellenv)"` 실행 후, 같은 줄을 `~/.zprofile` 에 추가 (`echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile`) |
| `git` 을 치면 "개발자 도구 설치" 창 | **설치** 를 눌러 Xcode Command Line Tools 설치 후 스크립트 재실행 |
| `code` 없음 | VS Code 안에서 `⌘ + Shift + P` → **Shell Command: Install 'code' command in PATH** |
| `codex` 없음 | `brew install codex`. 안 되면 `npm install -g @openai/codex` (Node.js 필요: `brew install node`) |
| VS Code 가 "확인되지 않은 개발자" 경고 | 시스템 설정 → 개인정보 보호 및 보안 → **확인 없이 열기** |
| 회사·학교 네트워크에서 다운로드 실패 | 휴대폰 핫스팟으로 시도 |

### 공통

| 증상 | 조치 |
|------|------|
| `codex login` 브라우저가 안 열림 | 터미널에 출력된 URL 을 복사해 브라우저에 직접 붙이기 |
| 다운로드가 매우 느림 | 정상일 수 있음(VS Code·PlatformIO 툴체인은 수백 MB). 네트워크 바꿔 보기 |

## 4. 다시 설치하고 싶을 때

설치 스크립트는 **여러 번 실행해도 안전**합니다. 이미 있는 것은 건너뛰고, 빠진 것만 설치합니다.
확장도 `--force` 로 다시 설치되므로 문제가 있으면 그냥 다시 실행하세요.

## 5. 다 됐다면

🎉 개발 환경이 갖춰졌습니다. 이제 [01-cli](../../01-cli/README.md) 에서 터미널 사용법부터 시작합니다.

> 📋 [`exercises/01-setup-checklist.md`](../exercises/01-setup-checklist.md) 에 체크리스트가 있습니다. 채워서
> 교육 담당자에게 보여 주면 확인이 끝납니다.

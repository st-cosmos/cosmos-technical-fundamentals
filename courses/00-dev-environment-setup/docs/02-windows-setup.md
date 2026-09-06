# 02. Windows 설치 가이드

## 한 줄 요약

> 홈 폴더에 **`workspace`** 폴더 만들기 → 저장소 ZIP 을 그 안에 풀기 → **`install-windows.cmd` 더블클릭** →
> **`check-windows.cmd` 더블클릭** 으로 검증 → 수동 설정 3가지(Git 이름·Codex 로그인·VS Code 첫 실행). 20~30분.
> 터미널을 아직 몰라도 됩니다 — **더블클릭 두 번**이면 설치가 끝납니다.

설치되는 것: PowerShell 7 · Git · VS Code · Python 3.12 · uv · Codex CLI · VS Code 확장(PlatformIO, Git Graph)

## 1. 작업 폴더 만들고 저장소 받기

동아리의 모든 자료와 프로젝트는 **홈 폴더 안의 `workspace` 폴더**에 둡니다. 앞으로 모든 강좌가 이 규칙을 따릅니다.

1. 탐색기에서 홈 폴더 `C:\Users\<내이름>` 을 열고 **새 폴더 → 이름 `workspace`**
2. GitHub 저장소 페이지 → 초록색 **Code** 버튼 → **Download ZIP** (아직 Git 이 없으므로 ZIP 으로)
3. 받은 ZIP 을 `workspace` 안에 풀고, 폴더 이름 끝의 `-main` 을 지웁니다. 최종 위치:

```
C:\Users\<내이름>\workspace\cosmos-technical-fundamentals\
```

![저장소 ZIP 다운로드](../images/win-01-download-zip.png)

> 💡 Git 설치가 끝난 뒤 02-git 강좌에서 `git clone` 으로 다시 받게 됩니다. 지금은 ZIP 으로 충분합니다.

## 2. 설치 스크립트 더블클릭

탐색기에서 `workspace\cosmos-technical-fundamentals\courses\00-dev-environment-setup\scripts` 로 들어가
**`install-windows.cmd`** 를 더블클릭합니다.

- 인터넷에서 받은 파일이라 **"이 파일을 실행하시겠습니까?"** 창이 뜹니다 → **실행**.
  **"Windows의 PC 보호"** 파란 창이면 **추가 정보 → 실행** 을 누릅니다.
- 검은 창이 열리고 winget 으로 도구를 하나씩 설치합니다. 도구마다 **UAC(사용자 계정 컨트롤) 창**이 뜨면 **예**.
- 이미 설치된 것은 건너뜁니다. 실패한 것은 마지막에 목록으로 알려 줍니다. 끝나면 **아무 키나 눌러** 창을 닫습니다.

![설치 파일 보안 경고](../images/win-02-security-warning.png)

![설치 스크립트 실행 화면](../images/win-03-install-script.png)

> ⏱️ 5~15분 걸립니다. PlatformIO 확장은 VS Code 를 처음 열 때 추가로 몇 분간 "PlatformIO Core 설치 중"
> 이 표시됩니다. 기다려 주세요.

> ⚠️ `winget` 을 찾을 수 없다는 오류가 나면 Microsoft Store 에서 **"앱 설치 관리자(App Installer)"** 를
> 업데이트한 뒤 다시 실행하세요.

### 터미널로 실행하려면 (선택)

시작 메뉴에서 **PowerShell** (파란 창) 을 열고:

```powershell
cd ~\workspace\cosmos-technical-fundamentals\courses\00-dev-environment-setup
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\install-windows.ps1
```

`~` 는 홈 폴더입니다. 둘째 줄은 **이 창에서만** 스크립트 실행을 허용합니다 (창을 닫으면 원래대로).

## 3. 확인 스크립트 더블클릭

설치 창을 닫은 뒤, 같은 폴더의 **`check-windows.cmd`** 를 더블클릭합니다. 새 창이 열리므로 방금 설치한
프로그램들이 바로 인식됩니다.

![확인 스크립트 결과](../images/win-04-check-script.png)

모든 줄이 `[OK]` 면 설치 완료입니다. `[MISSING]` 이 있으면 [04. 확인과 문제 해결](04-verify-and-troubleshoot.md) 을 보세요.

> 💡 터미널로 하려면: 시작 메뉴에서 **PowerShell 7** (검은 아이콘, `pwsh`) 을 **새로** 열고
> `cd ~\workspace\cosmos-technical-fundamentals\courses\00-dev-environment-setup` → `.\scripts\check-windows.ps1`.
> 새로 열어야 방금 설치한 프로그램이 PATH 에 반영됩니다.

## 4. 앞으로 쓸 터미널 — PowerShell 7

여기까지 됐으면 앞으로 터미널은 시작 메뉴의 **PowerShell 7** (검은 아이콘, `pwsh`) 을 씁니다.
아래 5~7절의 명령도 이 창에서 칩니다.

![시작 메뉴에서 PowerShell 7 검색](../images/win-02-open-powershell.png)

## 5. 수동 설정 ① — Git 이름과 이메일

커밋에 새겨질 이름과 이메일을 등록합니다. **이메일은 GitHub 계정과 같게** 하세요.

```powershell
git config --global user.name "홍길동"
git config --global user.email "gildong@example.com"
git config --global init.defaultBranch main
git config --global core.autocrlf true
```

(자세한 의미는 02-git 강좌의 [설치와 초기설정](../../02-git/docs/02-installation-and-initial-setup.md) 에서 다룹니다.)

## 6. 수동 설정 ② — Codex 로그인

```powershell
codex login
```

브라우저가 열리고 **ChatGPT 계정으로 로그인**하라고 합니다. 로그인하면 터미널에 성공 메시지가 뜹니다.

![Codex 로그인 브라우저 화면](../images/win-05-codex-login.png)

```powershell
codex login status      # "Logged in" 이면 성공
```

> 💡 Codex 사용법은 07-ai 강좌에서 배웁니다. 지금은 로그인만 해 둡니다.

## 7. 수동 설정 ③ — VS Code 첫 실행

1. 시작 메뉴에서 **Visual Studio Code** 실행
2. 왼쪽 사이드바 맨 아래쯤 **외계인 모양 🛸 아이콘(PlatformIO)** 이 보이는지 확인 — 처음엔 하단에
   "Installing PlatformIO Core" 가 몇 분 표시됩니다
3. 왼쪽 **Source Control(가지 모양)** 패널 상단에 **Git Graph 아이콘** 이 있는지 확인

![VS Code 에 PlatformIO 와 Git Graph 가 설치된 모습](../images/win-06-vscode-extensions.png)

## 8. (권장) Windows Terminal 기본 프로필을 PowerShell 7 로

**Windows Terminal** 을 열고 `Ctrl + ,`(설정) → **시작 → 기본 프로필** 을 **PowerShell** (7) 로 바꾸면,
앞으로 터미널을 열 때마다 자동으로 PowerShell 7 이 뜹니다.

![Windows Terminal 기본 프로필 설정](../images/win-07-terminal-default-profile.png)

## 완료 체크

- [ ] `check-windows.cmd` 전부 ✅
- [ ] `git config --global user.name` 에 내 이름이 나온다
- [ ] `codex login status` 가 로그인됨을 표시한다
- [ ] VS Code 에 PlatformIO 🛸 · Git Graph 아이콘이 보인다

➡️ 다음: [04. 확인과 문제 해결](04-verify-and-troubleshoot.md) · 그다음 강좌: [01-cli](../../01-cli/README.md)

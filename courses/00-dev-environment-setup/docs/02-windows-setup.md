# 02. Windows 설치 가이드

## 한 줄 요약

> **기본 PowerShell(파란 창)** 을 열고 → **설치 스크립트 1개** 실행 → **확인 스크립트** 로 검증 →
> 수동 설정 3가지(Git 이름·Codex 로그인·VS Code 첫 실행). 20~30분.

설치되는 것: PowerShell 7 · Git · VS Code · Python 3.12 · uv · Codex CLI · VS Code 확장(PlatformIO, Git Graph)

## 1. 이 저장소 받기

아직 Git 이 없으므로 **ZIP 으로** 받습니다.

1. GitHub 저장소 페이지 → 초록색 **Code** 버튼 → **Download ZIP**
2. 압축을 풀어 예를 들어 `C:\Users\<내이름>\cosmos-technical-fundamentals` 에 둡니다

![저장소 ZIP 다운로드](../images/win-01-download-zip.png)

> 💡 Git 설치가 끝난 뒤 02-git 강좌에서 `git clone` 으로 다시 받게 됩니다. 지금은 ZIP 으로 충분합니다.

## 2. PowerShell 열기

시작 메뉴에서 **PowerShell** 을 검색해 실행합니다. (파란 창 — 아직 5.1 입니다. 스크립트가 7 을 설치해 줍니다)

![시작 메뉴에서 PowerShell 검색](../images/win-02-open-powershell.png)

압축을 푼 폴더 안의 `courses\00-dev-environment-setup` 으로 이동합니다.

```powershell
cd C:\Users\<내이름>\cosmos-technical-fundamentals\courses\00-dev-environment-setup
```

> 💡 폴더 탐색기에서 해당 폴더를 열고, 빈 곳을 **Shift + 우클릭 → "여기에 PowerShell 창 열기"** 를
> 눌러도 됩니다. 주소창에 `powershell` 을 입력해도 그 폴더에서 열립니다.

## 3. 설치 스크립트 실행

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\install-windows.ps1
```

- 첫 줄은 **이 창에서만** 스크립트 실행을 허용합니다 (창을 닫으면 원래대로).
- 스크립트가 winget 으로 도구를 하나씩 설치합니다. 도구마다 **UAC(사용자 계정 컨트롤) 창**이 뜨면 **예**.
- 이미 설치된 것은 건너뜁니다. 실패한 것은 마지막에 목록으로 알려 줍니다.

![설치 스크립트 실행 화면](../images/win-03-install-script.png)

> ⏱️ 5~15분 걸립니다. PlatformIO 확장은 VS Code 를 처음 열 때 추가로 몇 분간 "PlatformIO Core 설치 중"
> 이 표시됩니다. 기다려 주세요.

> ⚠️ `winget` 을 찾을 수 없다는 오류가 나면 Microsoft Store 에서 **"앱 설치 관리자(App Installer)"** 를
> 업데이트한 뒤 다시 실행하세요.

## 4. 새 터미널 열고 확인

설치가 끝나면 **창을 닫고**, 이번엔 시작 메뉴에서 **PowerShell 7** (검은 아이콘, `pwsh`) 을 실행합니다.
새로 열어야 방금 설치한 프로그램들이 PATH 에 반영됩니다.

```powershell
cd C:\Users\<내이름>\cosmos-technical-fundamentals\courses\00-dev-environment-setup
.\scripts\check-windows.ps1
```

![PowerShell 7 에서 확인 스크립트 실행](../images/win-04-check-script.png)

모든 줄이 ✅ 면 설치 완료입니다. ❌ 가 있으면 [04. 확인과 문제 해결](04-verify-and-troubleshoot.md) 을 보세요.

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

- [ ] `check-windows.ps1` 전부 ✅
- [ ] `git config --global user.name` 에 내 이름이 나온다
- [ ] `codex login status` 가 로그인됨을 표시한다
- [ ] VS Code 에 PlatformIO 🛸 · Git Graph 아이콘이 보인다

➡️ 다음: [04. 확인과 문제 해결](04-verify-and-troubleshoot.md) · 그다음 강좌: [01-cli](../../01-cli/README.md)

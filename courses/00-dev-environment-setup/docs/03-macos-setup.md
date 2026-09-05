# 03. macOS 설치 가이드

## 한 줄 요약

> **터미널** 을 열고 → **설치 스크립트 1개** 실행 → **확인 스크립트** 로 검증 → 수동 설정 3가지
> (Git 이름·Codex 로그인·VS Code 첫 실행). 20~30분.

설치되는 것: Homebrew(없으면) · Xcode Command Line Tools(Git 포함, 없으면) · VS Code · uv · Codex CLI ·
VS Code 확장(PlatformIO, Git Graph)

> 💡 macOS 는 **터미널(zsh)·Git·Python 3** 이 기본으로 있어 설치 항목이 Windows 보다 적습니다.
> 파이썬 프로젝트용 Python 버전은 **uv 가 따로 관리**하므로 시스템 파이썬은 그대로 둡니다.

## 1. 이 저장소 받기

GitHub 저장소 페이지 → **Code** → **Download ZIP** → 압축 해제 (예: `~/cosmos-technical-fundamentals`)

![저장소 ZIP 다운로드](../images/mac-01-download-zip.png)

## 2. 터미널 열기

`⌘ + Space` → **터미널** 검색 → 실행. 압축을 푼 폴더로 이동합니다.

```bash
cd ~/cosmos-technical-fundamentals/courses/00-dev-environment-setup
```

![Spotlight 에서 터미널 검색](../images/mac-02-open-terminal.png)

## 3. 설치 스크립트 실행

```bash
bash scripts/install-macos.sh
```

- **Homebrew** 가 없으면 먼저 설치합니다. 이때 **관리자 비밀번호**를 묻고, Enter 를 한 번 눌러 진행합니다.
- **Xcode Command Line Tools** (Git 포함) 가 없으면 설치 창이 뜹니다. **설치** 를 누르고 끝나면 스크립트를
  **다시 실행**하세요.
- 나머지(VS Code · uv · Codex · 확장)는 자동으로 설치됩니다.

![설치 스크립트 실행 화면](../images/mac-03-install-script.png)

> ⚠️ 처음 Homebrew 를 설치한 경우 스크립트 끝에 안내되는 `eval "$(/opt/homebrew/bin/brew shellenv)"`
> 줄을 `~/.zprofile` 에 넣어야 새 터미널에서도 `brew` 가 됩니다. 스크립트가 자동으로 추가를 시도하고,
> 실패하면 메시지로 알려 줍니다.

## 4. 새 터미널 열고 확인

터미널을 **닫고 다시 열어** (PATH 갱신) 확인 스크립트를 실행합니다.

```bash
cd ~/cosmos-technical-fundamentals/courses/00-dev-environment-setup
bash scripts/check-macos.sh
```

![확인 스크립트 실행 결과](../images/mac-04-check-script.png)

모두 ✅ 면 완료. ❌ 가 있으면 [04. 확인과 문제 해결](04-verify-and-troubleshoot.md).

## 5. 수동 설정 ① — Git 이름과 이메일

```bash
git config --global user.name "홍길동"
git config --global user.email "gildong@example.com"   # GitHub 계정 이메일과 동일하게
git config --global init.defaultBranch main
git config --global core.autocrlf input
```

## 6. 수동 설정 ② — Codex 로그인

```bash
codex login
```

브라우저에서 **ChatGPT 계정으로 로그인**하면 터미널에 성공 메시지가 뜹니다.

![Codex 로그인 브라우저 화면](../images/mac-05-codex-login.png)

```bash
codex login status
```

## 7. 수동 설정 ③ — VS Code 첫 실행

1. Launchpad 또는 Spotlight 에서 **Visual Studio Code** 실행
   (처음 실행 시 "인터넷에서 다운로드한 앱" 경고가 뜨면 **열기**)
2. 사이드바에 **PlatformIO 🛸 아이콘** 확인 — 하단 "Installing PlatformIO Core" 가 끝날 때까지 몇 분 대기
3. **Source Control** 패널에 **Git Graph 아이콘** 확인

![VS Code 에 PlatformIO 와 Git Graph 가 설치된 모습](../images/mac-06-vscode-extensions.png)

> 💡 터미널에서 `code .` 를 치면 현재 폴더가 VS Code 로 열립니다. 이 명령이 안 되면 VS Code 안에서
> `⌘ + Shift + P` → **"Shell Command: Install 'code' command in PATH"** 를 실행하세요.

## 8. (ESP32 준비) USB 드라이버

최신 macOS 는 ESP32 보드의 USB 칩(CP2102/CH340)을 대부분 자동 인식합니다. 03-esp32 강좌에서 보드가
안 잡히면 그때 드라이버를 설치하면 됩니다. (해당 강좌 문서에 안내)

## 완료 체크

- [ ] `check-macos.sh` 전부 ✅
- [ ] `git config --global user.name` 에 내 이름이 나온다
- [ ] `codex login status` 가 로그인됨을 표시한다
- [ ] VS Code 에 PlatformIO 🛸 · Git Graph 아이콘이 보인다

➡️ 다음: [04. 확인과 문제 해결](04-verify-and-troubleshoot.md) · 그다음 강좌: [01-cli](../../01-cli/README.md)

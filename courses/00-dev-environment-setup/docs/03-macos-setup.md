# 03. macOS 설치 가이드

## 한 줄 요약

> 홈 폴더에 **`workspace`** 폴더 만들기 → 저장소 ZIP 을 그 안에 풀기 → **`install-macos.command` 더블클릭** →
> **`check-macos.command` 더블클릭** 으로 검증 → 수동 설정 3가지(Git 이름·Codex 로그인·VS Code 첫 실행). 20~30분.
> 터미널을 아직 몰라도 됩니다 — **더블클릭 두 번**이면 설치가 끝납니다.

설치되는 것: Homebrew(없으면) · Xcode Command Line Tools(Git 포함, 없으면) · VS Code · uv · Codex CLI ·
VS Code 확장(PlatformIO, Git Graph)

> 💡 macOS 는 **터미널(zsh)·Git·Python 3** 이 기본으로 있어 설치 항목이 Windows 보다 적습니다.
> 파이썬 프로젝트용 Python 버전은 **uv 가 따로 관리**하므로 시스템 파이썬은 그대로 둡니다.

## 1. 작업 폴더 만들고 저장소 받기

동아리의 모든 자료와 프로젝트는 **홈 폴더 안의 `workspace` 폴더**(`~/workspace`)에 둡니다. 앞으로 모든 강좌가
이 규칙을 따릅니다.

1. Finder 에서 홈 폴더(`⌘ + Shift + H`)를 열고 **새 폴더 → 이름 `workspace`**
2. GitHub 저장소 페이지 → **Code** → **Download ZIP**
3. 받은 ZIP 을 더블클릭해 풀고, 생긴 폴더를 `workspace` 안으로 옮긴 뒤 이름 끝의 `-main` 을 지웁니다. 최종 위치:

```
~/workspace/cosmos-technical-fundamentals/
```

![저장소 ZIP 다운로드](../images/mac-01-download-zip.png)

## 2. 설치 스크립트 더블클릭

Finder 에서 `workspace/cosmos-technical-fundamentals/courses/00-dev-environment-setup/scripts` 로 들어가
**`install-macos.command`** 를 더블클릭합니다.

- 처음엔 macOS 가 **"확인되지 않은 개발자"** 또는 **"악성 코드가 없는지 확인할 수 없음"** 이라며 막습니다.
  → **시스템 설정 → 개인정보 보호 및 보안** 으로 가서 아래쪽의 **"그래도 열기"** 를 누르고, 파일을 다시 더블클릭합니다.
  (macOS 13 이하에서는 파일을 **control + 클릭 → 열기** 로도 됩니다)
- 터미널 창이 열리고 설치가 진행됩니다. **Homebrew** 가 없으면 먼저 설치하며 **관리자 비밀번호**를 묻습니다.
  입력해도 화면에 표시되지 않으니 그냥 치고 Enter.
- **Xcode Command Line Tools** (Git 포함) 가 없으면 설치 창이 뜹니다. **설치** 를 누르고 끝나면 파일을 **다시 더블클릭**하세요.
- 나머지(VS Code · uv · Codex · 확장)는 자동으로 설치됩니다. 끝에 `[Process completed]` 가 보이면 창을 닫습니다.

![Gatekeeper 경고와 그래도 열기](../images/mac-02-gatekeeper.png)

![설치 스크립트 실행 화면](../images/mac-03-install-script.png)

> ⚠️ 처음 Homebrew 를 설치한 경우 스크립트 끝에 안내되는 `eval "$(/opt/homebrew/bin/brew shellenv)"`
> 줄을 `~/.zprofile` 에 넣어야 새 터미널에서도 `brew` 가 됩니다. 스크립트가 자동으로 추가를 시도하고,
> 실패하면 메시지로 알려 줍니다.

### 터미널로 실행하려면 (선택)

`⌘ + Space` → **터미널** 을 실행하고:

```bash
cd ~/workspace/cosmos-technical-fundamentals/courses/00-dev-environment-setup
bash scripts/install-macos.command
```

## 3. 확인 스크립트 더블클릭

같은 폴더의 **`check-macos.command`** 를 더블클릭합니다. (처음이면 2절과 같은 "그래도 열기" 를 한 번 더.)
새 터미널 창이 열리므로 방금 설치한 것이 바로 인식됩니다.

![확인 스크립트 실행 결과](../images/mac-04-check-script.png)

모두 `[OK]` 면 완료. `[MISSING]` 이 있으면 [04. 확인과 문제 해결](04-verify-and-troubleshoot.md).

> 💡 터미널로 하려면: 터미널을 **닫고 다시 열어**(PATH 갱신)
> `cd ~/workspace/cosmos-technical-fundamentals/courses/00-dev-environment-setup` → `bash scripts/check-macos.command`.

## 4. 앞으로 쓸 터미널

`⌘ + Space` → **터미널** 검색 → 실행. 아래 5~7절의 명령은 이 창에서 칩니다.

![Spotlight 에서 터미널 검색](../images/mac-02-open-terminal.png)

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

최신 macOS 는 ESP32 보드의 USB 칩(CP2102/CH340)을 대부분 자동 인식합니다. 06-esp32 강좌에서 보드가
안 잡히면 그때 드라이버를 설치하면 됩니다. (해당 강좌 문서에 안내)

## 완료 체크

- [ ] `check-macos.command` 전부 ✅
- [ ] `git config --global user.name` 에 내 이름이 나온다
- [ ] `codex login status` 가 로그인됨을 표시한다
- [ ] VS Code 에 PlatformIO 🛸 · Git Graph 아이콘이 보인다

➡️ 다음: [04. 확인과 문제 해결](04-verify-and-troubleshoot.md) · 그다음 강좌: [01-cli](../../01-cli/README.md)

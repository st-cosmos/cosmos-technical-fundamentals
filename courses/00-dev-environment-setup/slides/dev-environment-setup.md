---
marp: true
theme: cosmos
paginate: true
footer: "00 · 개발 환경 설정"
---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">COSMOS · 기술 기초 교육 00</div>

# 개발 환경 설정

<div class="rule"></div>

<div class="subtitle">더블클릭 한 번으로 도구 설치 · Windows / macOS</div>

<div class="meta">
PowerShell 7 · Git · VS Code · PlatformIO · Git Graph · Python · uv · Codex CLI<br>
대상: 개발 도구가 처음인 신입 부원 · 모든 강좌의 준비물
</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

---

## 오늘 할 것

1. **무엇을 왜** 설치하나 — 8가지 도구
2. **`workspace` 폴더** 만들고 저장소 받기 — 동아리 공통 규칙
3. **설치 스크립트 더블클릭** (Windows: winget / macOS: Homebrew)
4. **확인 스크립트 더블클릭** — 전부 ✅ 인지
5. **수동 설정 3가지** — Git 이름 · Codex 로그인 · VS Code 첫 실행

> 이 자료는 PDF 로 배포됩니다. 막히면 `docs/04` 문제 해결 표를 보세요.

---

## 설치하는 것

| 도구 | 쓰는 강좌 | Windows | macOS |
|------|-----------|:-------:|:-----:|
| PowerShell 7 | 01-cli | ✅ | 기본 터미널 |
| Git | 02-git | ✅ | 기본 포함 |
| VS Code + **PlatformIO** · **Git Graph** 확장 | 전체 · 03 · 02 | ✅ | ✅ |
| Python 3.12 | 05 · 06 | ✅ | 기본 포함 |
| **uv** | 05 · 06 | ✅ | ✅ |
| **Codex CLI** | 07-ai | ✅ | ✅ |

> 💡 하나씩 사이트에서 받지 않고 **패키지 관리자**(winget / brew)로 한 번에 — 업데이트도 한 줄.

---

<!-- _class: section -->
<div class="eyebrow">PART 1</div>

# Windows

<div class="lead-sub">workspace 폴더 → 더블클릭 설치 → 더블클릭 확인</div>

---

## Windows ① `workspace` 폴더 + 저장소 받기

1. 탐색기에서 홈 폴더 `C:\Users\<내이름>` 에 **새 폴더 `workspace`**
2. GitHub → **Code → Download ZIP** → `workspace` 안에 풀기 (폴더 끝 `-main` 삭제)

```
C:\Users\<내이름>\workspace\cosmos-technical-fundamentals\
```

> 📁 **규칙: 동아리 자료·프로젝트는 전부 `~/workspace` 안에.** 모든 강좌가 이 폴더 기준으로 안내합니다.

![w:900](../images/win-01-download-zip.png)

---

## Windows ② 설치 — 더블클릭

`courses\00-dev-environment-setup\scripts\` 안의 **`install-windows.cmd`** 더블클릭

- 보안 경고("실행하시겠습니까?" / "PC 보호") → **실행** (PC 보호는 추가 정보 → 실행)
- UAC 창이 뜨면 **예** · 이미 있는 건 건너뜀 · 5~15분 · 끝나면 아무 키나 눌러 닫기

![w:900](../images/win-03-install-script.png)

<div class="small">터미널로: PowerShell 에서 <code>Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass</code> 후 <code>.\scripts\install-windows.ps1</code></div>

---

## Windows ③ 확인 — 더블클릭

같은 폴더의 **`check-windows.cmd`** 더블클릭 — 새 창이라 방금 설치한 것이 바로 보임

![w:900](../images/win-04-check-script.png)

> 전부 `[OK]` 면 성공. `[MISSING]` 은 "조치" 열의 명령 실행 → 다시 더블클릭.
> 앞으로 터미널은 시작 메뉴의 **PowerShell 7 (pwsh)** 을 씁니다.

---

<!-- _class: section -->
<div class="eyebrow">PART 2</div>

# macOS

<div class="lead-sub">workspace 폴더 → 더블클릭 설치 → 더블클릭 확인</div>

---

## macOS ① `workspace` 폴더 + 저장소 받기

1. Finder 홈 폴더(`⌘ + Shift + H`)에 **새 폴더 `workspace`**
2. GitHub → **Code → Download ZIP** → 풀어서 `workspace` 안으로 (폴더 끝 `-main` 삭제)

```
~/workspace/cosmos-technical-fundamentals/
```

> 📁 **규칙: 동아리 자료·프로젝트는 전부 `~/workspace` 안에.** 모든 강좌가 이 폴더 기준으로 안내합니다.

![w:900](../images/mac-01-download-zip.png)

---

## macOS ② 설치 — 더블클릭

`courses/00-dev-environment-setup/scripts/` 안의 **`install-macos.command`** 더블클릭

- 처음엔 막힘 → **시스템 설정 → 개인정보 보호 및 보안 → 그래도 열기** → 다시 더블클릭
- Homebrew 가 없으면 먼저 설치 (**비밀번호** 입력 + Enter) · Xcode CLT 창이 뜨면 **설치** 후 **재실행**

![w:900](../images/mac-02-gatekeeper.png)

<div class="small">터미널로: <code>bash scripts/install-macos.command</code></div>

---

## macOS ③ 확인 — 더블클릭

같은 폴더의 **`check-macos.command`** 더블클릭 — 새 터미널 창이라 방금 설치한 것이 바로 보임

![w:900](../images/mac-04-check-script.png)

> 전부 `[OK]` 면 성공. 앞으로 터미널은 `⌘ + Space` → **터미널**.

---

<!-- _class: section -->
<div class="eyebrow">PART 3</div>

# 수동 설정 3가지

<div class="lead-sub">로그인·개인정보라 스크립트로 하지 않는 것</div>

---

## ① Git 이름과 이메일

커밋에 새겨지는 신원. **이메일은 GitHub 계정과 같게.**

```bash
git config --global user.name "홍길동"
git config --global user.email "gildong@example.com"
git config --global init.defaultBranch main
```

```bash
git config --global core.autocrlf true    # Windows
git config --global core.autocrlf input   # macOS
```

> 자세한 의미는 02-git 강좌에서.

---

## ② Codex 로그인

```bash
codex login          # 브라우저가 열림 → ChatGPT 계정으로 로그인
codex login status   # 로그인됨 확인
```

![w:850](../images/win-05-codex-login.png)

> 브라우저가 안 열리면 터미널의 URL 을 복사해 직접 열기. 사용법은 07-ai 강좌에서.

---

## ③ VS Code 첫 실행

- 사이드바 **PlatformIO 🛸** — 처음엔 "Installing PlatformIO Core" 몇 분 대기
- Source Control 패널의 **Git Graph** 아이콘

![w:900](../images/win-06-vscode-extensions.png)

---

## 막히면 — 가장 흔한 3가지

| 증상 | 해결 |
|------|------|
| 더블클릭이 막힘 | Win: 추가 정보 → **실행** · mac: 개인정보 보호 및 보안 → **그래도 열기** |
| 설치했는데 `command not found` | **터미널을 새로** 열기 (Windows 는 pwsh 로) |
| (Win) `python` 치면 Store 가 열림 | 설정 → 앱 → **앱 실행 별칭** 에서 python 항목 끄기 |
| (mac) 새 터미널에서 `brew` 없음 | `~/.zprofile` 에 `eval "$(/opt/homebrew/bin/brew shellenv)"` |

> 나머지는 `docs/04-verify-and-troubleshoot.md` 표 참고. 스크립트는 **여러 번 실행해도 안전**.

---

## 정리

- 동아리 자료·프로젝트는 전부 **`~/workspace`** 안에
- 도구 8가지를 **더블클릭 한 번**으로 — winget(Win) / Homebrew(mac)
- **확인 스크립트** 더블클릭 → 전부 ✅
- 수동 3가지: **git config** · **codex login** · **VS Code 첫 실행**
- 체크리스트(`exercises/01`)를 채우면 이 강좌 끝

<div class="small">다음 강좌: 01-cli — 방금 설치한 터미널을 손에 익힙니다.</div>

---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">준비 완료</div>

# 이제 시작해 봅시다 🚀

<div class="rule"></div>

<div class="subtitle">exercises/01 체크리스트 채우기 → 01-cli 로</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

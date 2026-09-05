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

<div class="subtitle">스크립트 한 번으로 도구 설치 · Windows / macOS</div>

<div class="meta">
PowerShell 7 · Git · VS Code · PlatformIO · Git Graph · Python · uv · Codex CLI<br>
대상: 개발 도구가 처음인 신입 부원 · 모든 강좌의 준비물
</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

---

## 오늘 할 것

1. **무엇을 왜** 설치하나 — 8가지 도구
2. **설치 스크립트** 실행 (Windows: winget / macOS: Homebrew)
3. **확인 스크립트** — 전부 ✅ 인지
4. **수동 설정 3가지** — Git 이름 · Codex 로그인 · VS Code 첫 실행

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

<div class="lead-sub">PowerShell → 스크립트 → 확인</div>

---

## Windows ① 저장소 받고 PowerShell 열기

1. GitHub → **Code → Download ZIP** → 압축 해제
2. 시작 메뉴에서 **PowerShell** 실행 (파란 창)
3. 폴더로 이동

```powershell
cd C:\Users\<내이름>\cosmos-technical-fundamentals\courses\00-dev-environment-setup
```

![w:900](../images/win-02-open-powershell.png)

---

## Windows ② 설치 스크립트

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\install-windows.ps1
```

- UAC 창이 뜨면 **예** · 이미 있는 건 건너뜀 · 5~15분
- 끝나면 **창을 닫고 PowerShell 7 (pwsh)** 을 새로 연다

![w:900](../images/win-03-install-script.png)

---

## Windows ③ 확인

```powershell
.\scripts\check-windows.ps1
```

![w:900](../images/win-04-check-script.png)

> 전부 `[OK]` 면 성공. `[MISSING]` 은 "조치" 열의 명령 실행 → 새 터미널에서 재확인.

---

<!-- _class: section -->
<div class="eyebrow">PART 2</div>

# macOS

<div class="lead-sub">터미널 → 스크립트 → 확인</div>

---

## macOS ① 저장소 받고 터미널 열기

1. GitHub → **Code → Download ZIP** → 압축 해제
2. `⌘ + Space` → **터미널**
3. 폴더로 이동

```bash
cd ~/cosmos-technical-fundamentals/courses/00-dev-environment-setup
```

![w:900](../images/mac-02-open-terminal.png)

---

## macOS ② 설치 스크립트

```bash
bash scripts/install-macos.sh
```

- Homebrew 가 없으면 먼저 설치 (**비밀번호** 입력 + Enter)
- Xcode CLT 설치 창이 뜨면 **설치** 후 스크립트 **재실행**
- 끝나면 터미널을 **새로 연다**

![w:900](../images/mac-03-install-script.png)

---

## macOS ③ 확인

```bash
bash scripts/check-macos.sh
```

![w:900](../images/mac-04-check-script.png)

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
| 설치했는데 `command not found` | **터미널을 새로** 열기 (Windows 는 pwsh 로) |
| (Win) `python` 치면 Store 가 열림 | 설정 → 앱 → **앱 실행 별칭** 에서 python 항목 끄기 |
| (mac) 새 터미널에서 `brew` 없음 | `~/.zprofile` 에 `eval "$(/opt/homebrew/bin/brew shellenv)"` |

> 나머지는 `docs/04-verify-and-troubleshoot.md` 표 참고. 스크립트는 **여러 번 실행해도 안전**.

---

## 정리

- 도구 8가지를 **스크립트 한 번**으로 — winget(Win) / Homebrew(mac)
- **확인 스크립트** 전부 ✅ → **새 터미널**에서!
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

# 00. 개발 환경 설정

동아리 신입 부원이 **가장 먼저** 하는 일 — 이후 모든 강좌(CLI · Git · ESP32 · 웹 · Python · AI)에서
쓰는 도구를 **한 번에 설치하고 확인**합니다. **Windows 와 macOS** 를 각각 안내하며, 가능한 것은
**스크립트 더블클릭 한 번**으로 끝내고, 스크립트로 어려운 부분(로그인·화면 설정)은 **사진과 함께**
따라갑니다. 신입 부원이 **모임 전에 미리** 혼자 설치해 올 수 있도록 만들어져 있습니다.

> 🎯 이 자료를 끝내면: 터미널에서 `git`, `python`, `uv`, `codex` 가 실행되고, VS Code 에
> PlatformIO · Git Graph 확장이 설치되어 있어 다음 강좌를 바로 시작할 수 있습니다.

## 설치하는 것

| 도구 | 용도 | Windows | macOS |
|------|------|:-------:|:-----:|
| **PowerShell 7** | 터미널 (01-cli) | ✅ | — (기본 터미널 사용) |
| **Git** | 버전 관리 (02-git) | ✅ | 기본 포함(Xcode CLT) |
| **VS Code** | 코드 편집기 (전 강좌) | ✅ | ✅ |
| **PlatformIO** (VS Code 확장) | ESP32 개발 (03-esp32) | ✅ | ✅ |
| **Git Graph** (VS Code 확장) | 커밋 그래프 보기 (02-git) | ✅ | ✅ |
| **Python 3.12** | 파이썬 (05-python) | ✅ | 기본 포함 (+ uv 가 관리) |
| **uv** | 파이썬 프로젝트·패키지 관리 (05·06) | ✅ | ✅ |
| **Codex CLI** | AI 코딩 에이전트 (07-ai) | ✅ | ✅ |

## 폴더 구조

```
00-dev-environment-setup/
├── docs/
│   ├── 01-overview.md              무엇을 왜 설치하나, 전체 흐름
│   ├── 02-windows-setup.md         Windows: 스크립트 실행 → 확인 → 수동 설정
│   ├── 03-macos-setup.md           macOS: 스크립트 실행 → 확인 → 수동 설정
│   └── 04-verify-and-troubleshoot.md  확인 스크립트 · 자주 막히는 문제
├── scripts/
│   ├── install-windows.cmd         Windows 일괄 설치 — 더블클릭용 (아래 .ps1 을 실행)
│   ├── check-windows.cmd           Windows 설치 확인 — 더블클릭용
│   ├── install-windows.ps1         Windows 일괄 설치 본체 (winget)
│   ├── check-windows.ps1           Windows 설치 확인 본체
│   ├── install-macos.command       macOS 일괄 설치 (Homebrew) — 더블클릭 가능
│   └── check-macos.command         macOS 설치 확인 — 더블클릭 가능
├── images/                         설치 가이드용 스크린샷 (파일명 목록: images/README.md)
├── exercises/
│   └── 01-setup-checklist.md       직접 설치하고 체크리스트 채우기
└── slides/
    └── dev-environment-setup.md    설치 가이드 슬라이드 (사진 포함 → PDF 배포용)
```

## 진행 순서

1. 📖 `docs/01` 무엇을 설치하는지 훑어보기 (5분)
2. 📁 홈 폴더에 **`workspace`** 폴더를 만들고 저장소 ZIP 을 그 안에 풀기 (동아리 공통 규칙)
3. 🪟 Windows 는 `docs/02`, 🍎 macOS 는 `docs/03` 를 따라 **설치 스크립트 더블클릭**
4. ✅ **확인 스크립트 더블클릭**으로 전부 설치됐는지 검증 (`docs/04` 문제 해결)
5. 🔐 수동 단계: **Codex 로그인**, **Git 이름/이메일 설정**, VS Code 첫 실행
6. 🧪 `exercises/01` 체크리스트 채우기 → 완료!

## 실행 요약

| | Windows | macOS |
|---|---------|-------|
| **더블클릭** (권장) | `scripts\install-windows.cmd` → `scripts\check-windows.cmd` | `scripts/install-macos.command` → `scripts/check-macos.command` |
| 첫 실행 시 보안 경고 | "실행하시겠습니까?" → **실행** (PC 보호 창은 추가 정보 → 실행) | 시스템 설정 → 개인정보 보호 및 보안 → **그래도 열기** |
| 터미널로 | 아래 PowerShell 블록 | 아래 bash 블록 |

```powershell
# Windows — 기본 PowerShell(파란 창)을 열고 이 폴더에서
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\install-windows.ps1
.\scripts\check-windows.ps1          # 새 PowerShell 7 창에서
```

```bash
# macOS — 터미널을 열고 이 폴더에서
bash scripts/install-macos.command
bash scripts/check-macos.command      # 새 터미널에서
```

스크립트는 저장소의 다른 파일에 의존하지 않아 **파일만 따로 받아 실행해도** 됩니다. (macOS 는 실행 권한 때문에 ZIP 권장)

> ⚠️ 스크립트는 **공식 패키지 관리자(winget / Homebrew)** 만 사용합니다. 무엇을 설치하는지는
> 스크립트 파일을 열어 직접 확인할 수 있습니다. (인터넷에서 받은 스크립트는 항상 내용을 보고 실행하는
> 습관을 들이세요.)

## 배포용 PDF

이 강좌의 슬라이드(`slides/dev-environment-setup.md`)는 **스크린샷을 포함한 설치 가이드**로, PDF 로
만들어 신입 부원에게 배포합니다. 저장소 최상위에서:

```bash
npm install
npm run pdf -- 00-dev
```

스크린샷 파일은 `images/` 에 두며, 필요한 파일 목록은 [`images/README.md`](images/README.md) 에 있습니다.

# 07. AI 로 개발하기 — Codex CLI

**AI 에이전트와 함께 코드를 짜는 방식(agentic coding)** 의 개념과 요령을 배우고, 터미널에서 쓰는 AI 코딩 에이전트
**Codex CLI** 로 실제 프로젝트에 기능을 더해 봅니다. 앞 강좌에서 만든 **LED 제어판과 LED 서버**가 실습 재료입니다.

> 🎯 이 자료를 끝내면: AI 에이전트에게 일을 **잘 시키는 요령**(구체적 목표·맥락·작게 쪼개기·검증·피드백)을 이해하고,
> Codex 로 코드를 만들고 고치고 검토하는 **"요청 → 검토 → 실행 → 피드백"** 흐름을 손에 익힐 수 있습니다.

## 누구를 위한 자료인가

- **대상**: AI 도구로 개발 생산성을 높이고 싶은 동아리 부원 (입문)
- **선수**: [00](../00-dev-environment-setup/README.md) (Codex CLI 설치·로그인), [01-cli](../01-cli/README.md), [02-git](../02-git/README.md).
  04·06 강좌를 마쳤으면 실습 02 가 훨씬 재미있습니다
- **도구**: **Codex CLI** (터미널), VS Code, 웹 브라우저, ChatGPT 계정

> ⚠️ AI 개발 도구는 **업데이트가 매우 빠릅니다.** 명령·화면·옵션 이름이 자료와 다를 수 있으니, 막히면 `codex --help` 와
> **공식 문서**(https://developers.openai.com/codex/cli) 를 함께 보세요.

## 폴더 구조

```
07-ai-assisted-development/
├── docs/
│   ├── 01-what-is-ai-development.md    에이전트 코딩 개념 · 잘 시키는 5가지 요령 · 한계와 책임
│   ├── 02-getting-started-with-codex.md  설치 확인 · 로그인 · 실행 · 승인 모드 · 첫 요청
│   ├── 03-working-with-codex.md        AGENTS.md · 맥락 주기 · diff 검토 · git 과 함께 · exec/review
│   └── 04-practical-workflow.md        실전 흐름: 기능 추가 · 버그 수정 · 검증 · 흔한 실수
├── exercises/
│   ├── 01-codex-led-panel.md           말로 시켜서 LED 제어판 만들기 (요청→검토→실행→피드백)
│   └── 02-codex-extend-server.md       06 의 LED 서버에 이력 API + 화면 추가 시키기 ★
├── examples/
│   └── led-panel/                      참고 완성본 — 디자인 시안(preview.png) → index.html·style.css·script.js
└── slides/
    └── ai-assisted-development.md
```

## 학습 순서

1. 🤖 `docs/01` AI 에이전트 코딩이 무엇이고 **어떻게 잘 시키는가**
2. 🧭 `docs/02` Codex CLI 실행·승인 모드·첫 요청 → **`exercises/01`** (LED 제어판을 말로 시켜 만들기)
3. 🧠 `docs/03` AGENTS.md 로 맥락 주기, diff 검토, git 과 함께 쓰기
4. 🛠️ `docs/04` 실전 흐름 → **`exercises/02`** ★ (06 강좌의 LED 서버에 기능 추가)

## 핵심 원칙 (한 줄)

> **AI 는 손을 빠르게 해 주는 도구. 무엇을 만들지 정하고, 결과가 맞는지 판단하고, 책임지는 것은 사람.**
> 기본기(01~06 강좌)가 있을수록 AI 를 더 잘 씁니다.

## 슬라이드

저장소 최상위에서 `npm run pdf -- 07-ai`

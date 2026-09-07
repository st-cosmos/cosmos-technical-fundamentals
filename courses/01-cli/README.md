# 01. CLI 기초 — 터미널 사용법

개발 도구(git · uv · codex · 서버 실행 …)는 대부분 **터미널에서 글자 명령**으로 다룹니다. 이 강좌는
터미널을 처음 여는 사람을 위해 **폴더를 오가고 만드는 기본 명령**, **절대 경로와 상대 경로**, 그리고
실습 서버 접속에 꼭 필요한 **내 PC IP 확인**을 다룹니다. Windows(PowerShell 7) 와 macOS(zsh) 를 함께 안내합니다.

> 🎯 이 자료를 끝내면: 터미널을 열어 원하는 폴더로 이동하고, 폴더·파일을 만들고 보고 지우며,
> 어떤 경로를 봐도 "어디를 가리키는지" 읽을 수 있고, `ipconfig` 로 내 IP 를 찾을 수 있습니다.

## 누구를 위한 자료인가

- **대상**: 터미널이 처음인 부원
- **선수**: [00-dev-environment-setup](../00-dev-environment-setup/README.md) 완료 (Windows 는 PowerShell 7 설치됨)
- **핵심 아이디어**: 터미널에서 하는 일은 **탐색기(Finder)에서 폴더를 여닫는 것과 똑같다**

## 폴더 구조

```
01-cli/
├── docs/
│   ├── 01-what-is-terminal.md        터미널·셸·OS 가 하는 일 · 프롬프트 읽기 · 명령의 생김새(프로그램·인자·옵션)
│   ├── 02-navigating-folders.md      pwd · ls · cd · mkdir — 폴더(서랍장) 비유
│   ├── 03-paths.md                   ★ 절대 경로 vs 상대 경로 — . .. ~ / \ 읽는 법
│   └── 04-network-ip.md              ipconfig / ifconfig — 내 PC IP 확인
├── exercises/
│   ├── 01-terminal-practice.md       폴더 만들고 오가기
│   └── 02-paths-practice.md          경로 읽기·쓰기 퀴즈 + IP 확인
└── slides/
    └── cli-basics.md
```

## 학습 순서

1. 💻 `docs/01` 터미널 열고 프롬프트 읽기
2. 📁 `docs/02` 4개 명령(`pwd`·`ls`·`cd`·`mkdir`) → **`exercises/01`**
3. 🧭 `docs/03` 절대/상대 경로 → **`exercises/02`** (여기가 핵심!)
4. 🌐 `docs/04` `ipconfig` 로 내 IP 확인 — ESP32·웹서버 실습에서 씀

## 슬라이드

저장소 최상위에서 `npm run pdf -- 01-cli`

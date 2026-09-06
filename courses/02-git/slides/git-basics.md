---
marp: true
theme: cosmos
paginate: true
footer: "02 · Git 기초"
---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">COSMOS · 기술 기초 교육 02</div>

# Git 기초

<div class="rule"></div>

<div class="subtitle">버전 관리부터 우리 팀 협업까지</div>

<div class="meta">
git-flow · rebase 기본 · GitHub<br>
대상: 개발팀 3~5인 · Windows / macOS
</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

---

## 오늘 다룰 것

1. Git이 **뭔지** — 버전 관리와 핵심 개념
2. 설치와 **초기 설정** (OS 혼재 팀 포인트)
3. **주요 명령어** — 매일 쓰는 흐름
4. **우리 팀 워크플로우** — git-flow + rebase + PR
5. ★ **Conflict(충돌)** 원인과 해결
6. **GitHub 협업 설정** (팀 리더용)

---

<!-- _class: section -->

<div class="eyebrow">PART 01</div>

# Git이란 무엇인가

---

## 버전 관리, 손으로 하면?

```
보고서_최종.docx
보고서_최종_v2.docx
보고서_진짜최종.docx
보고서_진짜최종_이번엔진짜.docx
```

- 뭐가 최신인지 모름 · 누가 뭘 바꿨는지 모름
- 과거로 못 돌아감 · 합치다 덮어씀

> **Git = 변경 이력을 자동 기록 + 여러 사람 작업을 안전하게 병합**

---

## 핵심 개념 4가지

| 개념 | 한 줄 | 비유 |
|------|------|------|
| **Repository** | 프로젝트 + 모든 이력 | 프로젝트 상자 |
| **Commit** | 특정 시점 스냅샷 | 게임 세이브 |
| **Branch** | 독립 작업선 | 평행우주 |
| **Remote** | 공유 저장소(GitHub) | 팀 클라우드 |

---

## Git ≠ GitHub

| | Git | GitHub |
|---|-----|--------|
| 정체 | 도구(프로그램) | 웹 서비스 |
| 역할 | 내 PC에서 버전 관리 | 저장소 호스팅 + 협업 |
| 비유 | 카메라 | 인스타그램 |

➡️ 커밋은 **내 컴퓨터에만** 저장. GitHub에 올리려면 **push** 필요!

---

## 전체 그림

```
   내 컴퓨터(로컬)                 GitHub(원격)
  작업 → add → commit  ──push──▶   공유 저장소
            로컬 저장소  ◀──pull──   (origin)
```

> 작업 → **add** → **commit** → **push** / **pull**
> 이 흐름이 Git 사용의 90%

---

<!-- _class: section -->

<div class="eyebrow">PART 02</div>

# 설치와 초기 설정

---

## 설치 확인 + Git Graph

Git 은 **00 강좌에서 이미 설치**했습니다. 확인만:

```bash
git --version   # git version 2.x
```

- VS Code **Git Graph** 확장(00 에서 설치) — 커밋·브랜치를 **그림으로**
- Source Control 패널 상단 **Git Graph 아이콘** → 오늘 내내 옆에 켜 두세요

> 터미널의 `git log --oneline --graph --all` 과 같은 내용을 그림으로 보는 것

---

## 공통 초기 설정 (1회)

```bash
git config --global user.name  "홍길동"
git config --global user.email "gildong@example.com"  # GitHub 이메일과 동일!
git config --global init.defaultBranch main
git config --global pull.rebase true                  # 우리 팀: rebase pull
```

**★ 줄바꿈 설정 (OS 혼재 팀 필수)**

```bash
# Windows
git config --global core.autocrlf true
# macOS / Linux
git config --global core.autocrlf input
```

---

<!-- _class: section -->

<div class="eyebrow">PART 03</div>

# 주요 명령어

---

## 막히면 항상 이 3개

```bash
git status                       # 지금 상태
git log --oneline --graph --all  # 이력 그래프
git diff                         # 변경 내용
```

> `git status`는 "지금 뭘 해야 하는지" 늘 알려줍니다.
> 📍 이 자료의 코드 블록 속 `# 지금 브랜치: xxx` = 그 명령을 치는 브랜치. `git status` 첫 줄 `On branch xxx` 와 맞는지 확인!

---

## 기본 흐름

```bash
# 1) 파일 수정
git add .                       # 2) 커밋 목록에 담기 (staging)
git commit -m "수량 0 이하 입력 방지"   # 3) 스냅샷 기록 (로컬)
git push                        # 4) GitHub에 올리기
```

```
작업 → add → Staging → commit → 로컬저장소 → push → GitHub
```

---

## 브랜치 · 되돌리기

```bash
# 지금 브랜치: main
git switch -c feature/login   # 새 브랜치 만들고 이동 → 지금 브랜치: feature/login
git switch main               # 이동           → 지금 브랜치: main

git restore 파일              # 수정 취소 (add 전)
git restore --staged 파일     # add 취소
git revert <커밋>             # 공유된 커밋 안전하게 되돌리기
```

> ⚠️ 공유된(push된) 이력엔 `reset`/`--amend` 대신 **`revert`**

---

<!-- _class: section -->

<div class="eyebrow">PART 04</div>

# 우리 팀 워크플로우

<div class="lead-sub">git-flow + rebase + PR</div>

---

## git-flow — 브랜치 역할

| 브랜치 | 역할 |
|--------|------|
| `main` | 출시된 안정 버전 |
| `develop` | 다음 릴리스 통합 |
| `feature/*` | 기능 하나 개발 |
| `release/*` | 출시 마무리 |
| `hotfix/*` | 긴급 버그 수정 |

> 일상은 결국: **develop에서 feature 따서 → PR → develop 병합**

---

## 매일 쓰는 흐름

```bash
git switch develop && git pull          # 1) 최신 develop
# 지금 브랜치: develop
git switch -c feature/123-cart-bug      # 2) 작업 브랜치
# 지금 브랜치: feature/123-cart-bug   ← 3)~5) 는 모두 여기서
git add . && git commit -m "..."        # 3) 작업 + 커밋
git push -u origin feature/123-cart-bug # 4) 올리기
# 5) GitHub에서 PR (develop ← feature) → 리뷰 → 병합
git switch develop && git pull          #    병합 후 develop 으로 돌아와서
# 지금 브랜치: develop
git branch -d feature/123-cart-bug      # 6) 정리
```

---

## merge vs rebase

```
merge:  갈라짐+합침 흔적(merge commit) 남음
   develop A─B───────M
                \   /
   feature       C─D

rebase: 내 커밋을 최신 위로 옮겨붙임 → 한 줄로 깔끔
   develop A─B─C'─D'
```

> 우리 팀은 **rebase 기본** — 이력이 직선이라 읽기 쉬움

---

## rebase 황금률 ⚠️

```bash
# 지금 브랜치: feature/123-cart-bug   ← 내 feature 에 서서!
git fetch origin                 # 원격 최신을 받아만 둠
git rebase origin/develop        # 최신 develop 위로 정리
git push --force-with-lease      # 이력 바뀌었으니 강제 푸시
```

1. **공유 브랜치(main/develop)는 rebase 금지** — 내 feature만
2. 강제 푸시는 **반드시 `--force-with-lease`** (그냥 `--force` ✕)
3. 막히면 `git rebase --abort`로 원상복구

---

<!-- _class: section -->

<div class="eyebrow">PART 05</div>

# Conflict(충돌) ★

<div class="lead-sub">가장 중요한 파트</div>

---

## 충돌은 에러가 아닙니다

> Git: "**두 사람이 같은 곳을 다르게 고쳤는데, 누가 맞는지 내가 못 정하겠어.
> 네가 정해줘.**"

**충돌 = 같은 파일의 같은 부분을 서로 다르게 바꿨을 때만** 발생

- 다른 파일 / 다른 줄 → Git이 자동 병합 (충돌 없음)
- Git은 절대 코드를 멋대로 버리지 않음

---

## 충돌 화면 읽는 법

```
<<<<<<< HEAD
    const total = price * quantity;            ← 내 쪽
=======
    const total = price * qty * (1 - discount); ← 상대 쪽
>>>>>>> feature/discount
```

- 위: 내 변경 / 아래: 상대 변경
- **마커(`<<<`, `===`, `>>>`)를 지우고** 올바른 코드만 남기기

---

## 해결 4단계

```bash
# 지금 상태: 내 feature 에서 rebase 진행 중 (git status 첫 줄이 알려줌)
# 1) 어디서 났나
git status

# 2) 파일 열어 직접 고치기 (둘 다 필요하면 합치기) + 마커 삭제

# 3) 해결 표시
git add 파일

# 4) 마무리
git rebase --continue   # rebase 중 (우리 팀 기본)
# git commit            # merge 중이었다면
```

> rebase는 충돌이 **여러 번** 날 수 있음 → 같은 절차 반복

---

## 막혔을 때 · 예방

**비상 탈출 — 시작 직전으로 깨끗이 복구**

```bash
git rebase --abort     # 또는 git merge --abort
```

**예방 습관**

- 자주 `pull` → develop과 격차 작게
- PR/브랜치 작게 유지
- 줄바꿈(CRLF/LF) 설정 통일 → 숨은 충돌 차단

---

<!-- _class: section -->

<div class="eyebrow">PART 06</div>

# GitHub 협업 설정

<div class="lead-sub">3~5인 팀</div>

---

## 꼭 켜둘 것

- **Branch protection** (`main`/`develop`)
  - PR 필수 · **리뷰 1명 이상 승인** · linear history
- **머지 방식 통일**: Squash(또는 Rebase)만, merge commit 끄기
- **머지된 브랜치 자동 삭제**
- **PR/이슈 템플릿 + CODEOWNERS** (저장소에 포함)

> 목표: main/develop 안 망치기 · 모든 변경 리뷰 거치기 · 이력 깔끔하게

---

<!-- _class: section -->

<div class="eyebrow">WRAP-UP</div>

# 정리

---

## 오늘의 핵심

- **흐름**: 작업 → add → commit → push / pull
- **우리 팀**: develop → feature → PR → 리뷰 → 병합 (**rebase 기본**)
- **충돌**: 에러 아님 · `status`로 확인 · 마커 지우고 `add` → `--continue`
- **막히면**: `--abort`로 되돌리고 물어보기

<span class="small">자세한 내용은 docs/ 폴더, 직접 해보기는 exercises/ 폴더</span>

---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">이제 실습</div>

# 직접 해봅시다 🛠️

<div class="rule"></div>

<div class="subtitle">exercises/ 의 3개 실습 — 첫 커밋 · 브랜치/rebase · 충돌 해결</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

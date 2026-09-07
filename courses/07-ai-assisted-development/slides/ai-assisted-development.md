---
marp: true
theme: cosmos
paginate: true
footer: "07 · AI 로 개발하기"
---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">COSMOS · 기술 기초 교육 07</div>

# AI 로 개발하기

<div class="rule"></div>

<div class="subtitle">에이전트 코딩 · Codex CLI 로 실제 프로젝트에 기능 추가</div>

<div class="meta">
에이전트 코딩 개념 · Codex CLI · AGENTS.md · 검토와 git<br>
대상: AI 개발 도구가 처음인 부원 · 01~06 기본기 위에서
</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

---

## 오늘 다룰 것

1. **AI 로 개발한다는 것** — 에이전트 코딩이란? 무엇이 달라지나
2. AI 에게 일을 **잘 시키는 요령** — 목표·맥락·작게·검증·피드백
3. **Codex CLI** — 실행 · 승인 모드 · 슬래시 명령 · 첫 요청
4. **Codex 와 일하는 법** — AGENTS.md · diff 검토 · git
5. **실전 흐름** — 기능 추가 · 버그 수정 · 테스트 · 리뷰

> ⚠️ AI 도구는 변화가 빠릅니다. 늘 **`codex --help`** 와 **공식 문서**를 함께 확인하세요.

---

<!-- _class: section -->
<div class="eyebrow">PART 1</div>

# AI 로 개발한다는 것

<div class="lead-sub">에이전트 코딩 개념과 요령</div>

---

## 무엇이 달라지나

```
[사람] 자연어로 요청  →  [AI 에이전트] 코드 생성·파일 수정·명령 실행
        ▲                                   │
        └──────  검토 / 수정 / 피드백  ◀──────┘
```

| 예전 | AI 에이전트와 함께 |
|------|--------------------|
| 한 줄씩 직접 타이핑 | **무엇을 원하는지** 설명하면 초안을 생성 |
| 문서·검색에서 찾기 | 맥락을 주면 코드·설명을 바로 제안 |
| 모든 걸 내가 검증 | 여전히 **내가 읽고 검증**(이건 그대로!) |

> AI 는 "더 빨리 가는 도구"이지, "생각을 대신해 주는 것"은 아닙니다. **방향과 판단, 책임은 사람.**

---

## AI 에게 일을 잘 시키는 5가지 요령

1. **목표를 구체적으로** — "버튼 추가" ❌ → "이름칸 옆 '켜기' 버튼, 누르면 표시등 켜고 이력에 추가" ✅
2. **맥락을 주기** — 파일·기술·제약. 반복되는 규칙은 **AGENTS.md** 로
3. **작게 쪼개기** — 한 번에 하나씩, "계획만 먼저"
4. **결과를 검증** — diff 읽고 **직접 실행**. "동작하는 것처럼 보인다 ≠ 맞다"
5. **틀리면 피드백** — "안 돼요" ❌ → 에러 **통째로** + 무엇이 어떻게 잘못됐는지 ✅

> 💡 핵심은 **"명확한 요청 → 확인 → 수정"** 의 반복. 좋은 동료에게 부탁하는 방식과 같다.

---

## 한계와 책임 · 보안

- **환각**: 없는 함수·라이브러리를 자신 있게 지어냄 → **실행해서** 확인
- **오래된 정보** · **맥락 모르는 결정** → AGENTS.md, 파일 지목
- **최종 책임은 사람** — 이해 못 한 코드는 "설명해줘" 후 받아들이기

🔒 **비밀정보(비번·키·토큰) 프롬프트에 넣지 않기** · 비공개 코드는 정책 확인 ·
에이전트의 **명령 실행 승인은 읽고** 결정 (삭제·설치·push)

---

<!-- _class: section -->
<div class="eyebrow">PART 2</div>

# Codex CLI

<div class="lead-sub">터미널에 사는 코딩 조수</div>

---

## 실행 — 프로젝트 폴더에서

```bash
codex --version && codex login status     # 00 강좌에서 설치·로그인 완료
cd ~/workspace/led-panel-codex             # 에이전트는 "지금 폴더"를 작업 공간으로 본다
codex                                     # 대화창(TUI)
codex "LED 제어판 index.html 만들어줘"     # 첫 요청을 바로
```

- 자연어 요청 → 파일 수정 → **바뀐 파일·diff 요약** → 명령 실행 시 **승인 요청 [y/n]**
- 나가기 `/quit`

> ⚠️ 홈(`~`)이나 저장소 최상위에서 실행하지 말 것 — **실습용 빈 폴더** 또는 **작업할 프로젝트 폴더**에서만

---

## 승인 모드와 샌드박스

| 축 | 값 | 의미 |
|----|----|------|
| **샌드박스** `-s` | `read-only` | 읽기만 — 설명·리뷰용 |
| | `workspace-write` (기본) | **폴더 안**만 수정, 그 밖·네트워크는 승인 |
| | `danger-full-access` | 제한 없음 — ✕ |
| **승인** `-a` | `on-request` (기본) | 필요할 때 물어봄 |

```bash
codex -s read-only        # 안전하게 시작: 코드 읽고 설명만
codex                     # 기본: 폴더 안 수정 OK, 위험한 건 물어봄  ← 실습 기본
```

> 승인 요청은 **명령을 읽고** 결정. 모르면 `n` → "이 명령이 왜 필요해?"

---

## 슬래시 명령 · 옵션

| 명령 | 하는 일 |
|------|---------|
| `/init` | **AGENTS.md** 초안 생성 |
| `/diff` | 지금까지 바뀐 내용 |
| `/review` | 현재 변경 코드 리뷰 |
| `/approvals` `/model` `/status` | 모드 · 모델 · 상태 |
| `/new` `/compact` `/quit` | 새 대화 · 맥락 줄이기 · 종료 |

```bash
codex -i preview.png "이 시안처럼 만들어줘"    # 이미지 첨부
codex exec "README 오타 고쳐줘"                # 대화 없이 한 번 실행
codex review                                   # 저장소 변경 리뷰
codex resume --last                            # 직전 대화 이어서
```

---

<!-- _class: section -->
<div class="eyebrow">PART 3</div>

# Codex 와 일하는 법

<div class="lead-sub">맥락 · 검토 · git</div>

---

## AGENTS.md — 프로젝트의 팀 규칙

```markdown
# LED 서버 프로젝트
## 기술·규칙
- Python 3.12, FastAPI. 패키지 관리는 **uv 만** (pip/venv 금지). 실행: uv run uvicorn main:app --reload
- 프론트는 순수 HTML/CSS/JS. 포인트 색 #6b4e9e
- 상태 모양 {on, by, time} 은 바꾸지 말 것 (ESP32 가 의존). app.mount("/") 는 맨 아래
## 작업 방식
- 고치기 전에 무엇을 바꿀지 한 줄로 먼저. 한 번에 한 기능.
```

- `/init` 으로 초안 → 우리 규칙 보강 → **git 커밋**
- 매번 반복하던 말을 파일로 → 일관된 결과, 팀원 누구나 같은 규칙

> 맥락 주는 다른 방법: **파일·함수 이름 지목** · **에러 통째로** · `-i` 이미지 · "…만 고쳐줘" 범위 제한

---

## 검토 → 커밋 — git 이 안전망

```
요청 → /diff (git diff) → 실행 확인 → git add . && git commit -m "..."
요청 → 검토 → 확인 → commit
```

**diff 체크리스트**
- 요청한 파일**만** 바뀌었나? · 요청한 동작이 들어 있나?
- 이해 안 되는 부분 → "한 줄씩 설명해줘" · 없는 라이브러리 → **실행**
- 마음에 안 들면 `git restore .`

> 시작 전 **`git init` + 첫 커밋** = 되돌릴 기준점. 기능 하나 = 커밋 하나. **push 는 직접.**

---

<!-- _class: section -->
<div class="eyebrow">PART 4</div>

# 실전 흐름

<div class="lead-sub">05 의 LED 서버에 "변경 이력" 추가</div>

---

## 기능 추가 — 계획 → 한 단계씩

```
› "변경 이력" 기능을 추가하려고 해 … 아직 고치지 말고 단계별 계획만 말해줘.
```
```
› 1단계만: main.py 에 history 리스트와 GET /api/history. set_led 에서 append. 다른 파일은 건드리지 마.
```
→ `/diff` → `uv run uvicorn` → `/docs` 로 확인 → **commit**
```
› 2단계: static/index.html 에 <ul id="history">, app.js 의 refresh() 가 /api/history 도 호출해 목록을 그리게.
```
→ `/diff` → 두 창 확인 → **commit**
```
› 이력 항목 앞에 켜짐/꺼짐 색 점을 붙여줘 (켜짐 #f5b301, 꺼짐 #cfc9dc).     ← 구체적 피드백
```

---

## 버그 수정 · 검증 · 리뷰

```
› 아래 오류가 났어. 고치기 전에 원인을 한 줄로 설명하고 고쳐줘.
  File "main.py", line 34, in get_history
    return history[-limit:][::-1]
  NameError: name 'limit' is not defined          ← Traceback 요약 말고 통째로
```

| 수준 | 방법 |
|------|------|
| 눈 | diff · 브라우저에서 눌러 보기 |
| 손 | `/docs` · 두 창 · `curl` |
| 코드 | "pytest 테스트 만들어줘" → `uv run pytest` |
| 리뷰 | `codex review` · `-s read-only "문제점 찾아줘"` |

> 테스트가 있으면 **다음 요청이 무언가를 망가뜨렸을 때 바로 드러난다.**

---

## 흔한 실수

| 실수 | 처방 |
|------|------|
| 한 번에 너무 많이 | "계획만" → 한 단계씩 → 커밋 |
| diff 안 보고 다음 요청 | 매번 `/diff` — 5초 |
| "안 돼요" | Traceback **통째로** + 재현 방법 |
| 이해 못 한 코드 커밋 | "한 줄씩 설명해줘" 먼저 |
| git 없이 시작 | `git init` + 첫 커밋 |
| 승인 안 읽고 y | 삭제·전역 설치·push 는 특히 읽기 |
| 홈/최상위에서 실행 | **프로젝트 폴더**에서만 |

---

## 실습으로 직접 해보기

- **실습 1**: Codex 로 **말로 시켜** LED 제어판 웹 페이지 만들기 — 요청 → `/diff` → 실행 → 피드백 → 커밋 (`exercises/01`)
  · 마지막엔 `-i preview.png` 로 시안대로 → `examples/led-panel` 과 비교
- **실습 2** ★: 05 의 **LED 서버**에 이력 API + 화면 추가 — git 안전망 · AGENTS.md · 계획 · 단계 · 테스트 · 버그 수정 · 리뷰 (`exercises/02`)

> 같은 "LED 제어판"을 03 에서는 **손으로**, 07 에서는 **말로**. 결과가 맞는지 **판단**할 수 있는 건 03~05 의 기본기 덕분.

---

## 정리

- AI 개발 = **명확한 요청 → 확인 → 수정** 의 반복. 판단과 책임은 사람이
- **Codex CLI**: 프로젝트 폴더에서 `codex` · 샌드박스 + 승인 · `/init` `/diff` `/review`
- **AGENTS.md** 로 규칙 · **git** 으로 안전망과 작은 커밋
- 실전: 계획 → 한 단계씩 → diff → 실행/테스트 → 커밋 · 에러는 통째로
- 도구는 빠르게 바뀐다 → `--help` 와 공식 문서

<div class="small">AI 는 손을 빠르게 해 주는 도구. 기본기(01~06)가 있을수록 더 잘 쓸 수 있어요.</div>

---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">감사합니다</div>

# 직접 시켜 봅시다 🚀

<div class="rule"></div>

<div class="subtitle">exercises/ 의 2개 실습으로 손에 익히기</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

# 04. 실전 워크플로우 — 기능 추가 · 버그 수정 · 검증 🛠️

## 한 줄 요약

> 실제 프로젝트에서 에이전트를 쓰는 흐름은 늘 같습니다. **준비(git·AGENTS.md) → 계획 → 작게 시키기 → 검토·실행 → 커밋**.
> 이 문서는 06 강좌의 LED 서버를 예로 **기능 추가**와 **버그 수정** 두 시나리오를 따라갑니다. (실습 02 의 뼈대)

## 1. 준비 — 안전망 먼저

```bash
cp -r courses/06-web-server-python/examples/02-led-api ~/projects/led-server   # 원본은 두고 복사본에서
cd ~/projects/led-server
git init && git add . && git commit -m "06 LED 서버 시작점"                    # 되돌릴 기준점
codex
› /init                                                                          # AGENTS.md 초안 → 규칙 보강 (03 문서 예시)
```

> 💡 **git 첫 커밋 = 안전망.** 무엇이 바뀌든 `git diff` 로 보이고 `git restore` 로 돌아갈 수 있습니다.

## 2. 시나리오 A — 기능 추가: "변경 이력 API 와 화면"

### ① 계획만 먼저

```
› LED 서버에 "변경 이력" 기능을 추가하려고 해. 서버는 이력을 리스트로 쌓고 GET /api/history 로 최근 10건을 돌려주고,
  웹 페이지 아래에 이력 목록을 보여 주면 돼. 아직 고치지 말고, 어떤 파일을 어떻게 바꿀지 단계별 계획만 말해줘.
```

에이전트가 "1) main.py 에 history 리스트와 라우트 2) static/index.html 에 ul 3) app.js 에 fetch…" 같은 계획을 냅니다.
**계획을 읽고** 이상하면 여기서 고칩니다. ("이력은 서버 메모리에만, 파일 저장은 하지 마")

### ② 1단계만 시키기

```
› 1단계만 해줘. main.py 의 set_led 에서 상태가 바뀔 때 history 리스트에 {on, by, time} 을 append 하고,
  GET /api/history 가 최근 10건을 최신순으로 돌려주게. 다른 파일은 건드리지 마.
```

### ③ 검토 → 실행 → 확인

```bash
› /diff                                   # main.py 만 바뀌었나? history 모양이 {on, by, time} 인가?
```

```bash
uv run uvicorn main:app --reload          # (에이전트가 띄우겠다고 하면 명령 읽고 승인해도 됨)
# 브라우저: /docs → PUT /api/led 두 번 → GET /api/history → 2건, 최신순?
```

이상 없으면:

```bash
git add . && git commit -m "이력 리스트 + GET /api/history 추가"
```

### ④ 2단계 — 화면

```
› 2단계. static/index.html 의 status 문장 아래에 <ul id="history"> 를 추가하고, static/app.js 의 refresh() 가
  GET /api/history 도 함께 호출해 "[시각] 이름 님이 LED를 켰/껐습니다" 형식으로 목록을 다시 그리게 해줘.
  기존 style.css 의 .list 스타일이 있으면 재사용하고, 없으면 최소한만 추가.
```

→ diff 검토 → 브라우저 두 창으로 확인 → 커밋.

### ⑤ 다듬기 (피드백)

```
› 이력이 새로고침 때 깜빡여. 목록을 통째로 지우고 다시 그리는 대신, 건수가 바뀌었을 때만 다시 그리게 해줘.
› 이력 항목에 켜짐/꺼짐 색 점을 앞에 붙여줘 (켜짐 #f5b301, 꺼짐 #cfc9dc).
```

"안 예뻐" ❌ 보다 **"무엇을, 어떻게"** ✅ 가 훨씬 빨리 고쳐집니다.

## 3. 시나리오 B — 버그 수정: "에러를 통째로 붙이기"

서버를 띄웠는데 이런 오류가 났다고 합시다.

```
  File "main.py", line 34, in get_history
    return history[-limit:][::-1]
NameError: name 'limit' is not defined
```

```
› 서버 실행 중 아래 오류가 났어. 원인을 설명하고 고쳐줘. 고치기 전에 무엇을 바꿀지 한 줄로 말해줘.

  File "main.py", line 34, in get_history
    return history[-limit:][::-1]
NameError: name 'limit' is not defined
```

- Traceback 은 **요약하지 말고 통째로** 붙입니다. 파일·줄 번호·오류 종류가 전부 단서입니다.
- "고치기 전에 설명" 을 요구하면, 엉뚱한 곳을 고치는 일이 줄고 **나도 배웁니다.**
- 고친 뒤 **같은 동작을 다시 실행**해 오류가 사라졌는지 확인하고 커밋.

### 재현 방법을 함께 주면 더 좋다

```
› 두 창을 열고 한 쪽에서 켜기를 누르면 다른 쪽 이력이 1초 뒤에 두 번 찍혀. static/app.js 의 refresh 를 보고 원인을 찾아줘.
  고치기 전에 원인 설명부터.
```

## 4. 검증 — "돌아가는 것처럼 보인다" 를 넘어서

| 수준 | 방법 |
|------|------|
| 눈으로 | diff 읽기, 브라우저에서 직접 눌러 보기 |
| 손으로 | `/docs` 에서 API 호출, 두 창 동기화 확인, `curl` |
| 코드로 | 에이전트에게 **테스트를 쓰게** 하기: "`GET /api/history` 가 최신순 10건을 돌려주는지 pytest 테스트를 `tests/test_history.py` 에 만들어줘" → `uv add --dev pytest` → `uv run pytest` |
| 리뷰 | `codex review` 또는 `-s read-only` 로 "이 변경의 문제점을 찾아줘" |

> 💡 테스트는 에이전트가 잘 씁니다. 그리고 **테스트가 있으면 다음 요청이 무언가를 망가뜨렸을 때 바로 드러납니다.**
> 기능 하나 추가할 때 테스트 하나 같이 시키는 습관을 들여 보세요.

## 5. 흔한 실수와 처방

| 실수 | 처방 |
|------|------|
| 한 번에 너무 많이 시킴 → 결과가 뒤죽박죽 | "계획만" → 한 단계씩 → 커밋 |
| diff 안 보고 다음 요청 | 매번 `/diff` 또는 `git diff`. 5초면 됨 |
| 에러를 "안 돼요" 로 전달 | Traceback **통째로** + 재현 방법 |
| 이해 못 한 코드를 그대로 커밋 | "한 줄씩 설명해줘" → 이해한 뒤 커밋 |
| git 없이 시작 | 되돌릴 방법이 없음. 시작 전 `git init` + 첫 커밋 |
| 승인 요청을 안 읽고 y | 파일 삭제·전역 설치·push 는 특히 읽기 |
| AGENTS.md 없이 매번 같은 규칙 설명 | 규칙을 파일로 → 일관된 결과 |
| 홈 폴더·저장소 최상위에서 codex 실행 | **프로젝트 폴더**에서만 |

## 6. 다른 강좌와 연결하기 🔗

| 연결 | 아이디어 |
|------|----------|
| **03 ESP32** | "`examples/06-wifi-led-client/src/main.cpp` 에 버튼(GPIO4)을 누르면 PUT /api/led 를 보내는 기능을 추가해줘" — PlatformIO 빌드로 검증 |
| **04 웹** | 04 의 정적 LED 제어판을 `-i preview.png` 시안대로 새 디자인으로 다시 만들게 하기 (`examples/led-panel` 참고) |
| **05 Python** | LED 이력 기록기에 `stats` 명령 추가, pytest 테스트 작성 |
| **06 서버** | WebSocket 버전에 접속자 목록, 이력 push 추가 (실습 04 도전 과제를 에이전트와) |
| **02 Git** | 커밋 메시지 작성, `codex review` 를 PR 전 셀프 리뷰로 |

## 정리

```
준비:  git init + 첫 커밋 · AGENTS.md
계획:  "아직 고치지 말고 단계 계획만"
실행:  한 단계씩 · 파일 지목 · 범위 제한
검토:  /diff → 실행 확인 → (테스트) → 커밋
수정:  에러 통째로 + 재현 방법 + "고치기 전에 원인 설명"
```

> 🎯 결과물보다 **흐름**이 핵심입니다. 이 흐름이 손에 익으면 어떤 AI 도구로 바뀌어도 같은 방식으로 일할 수 있습니다.

➡️ [실습 02. Codex 로 LED 서버 확장하기 ★](../exercises/02-codex-extend-server.md)

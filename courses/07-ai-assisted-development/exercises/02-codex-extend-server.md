# 실습 02. Codex 로 LED 서버 확장하기 ★

> [03. Codex 와 일하는 법](../docs/03-working-with-codex.md) 과 [04. 실전 워크플로우](../docs/04-practical-workflow.md) 를 먼저 읽으세요.
> 06 강좌의 LED 서버(`examples/02-led-api`)를 재료로 씁니다. (06 을 안 했어도 따라갈 수 있지만, 했으면 훨씬 재미있습니다)

## 🎯 목표

**실제 프로젝트**에 에이전트로 기능을 추가하는 전체 흐름 — **git 안전망 → AGENTS.md → 계획 → 한 단계씩 → diff 검토 →
실행 확인 → 테스트 → 커밋** — 을 처음부터 끝까지 경험합니다.

추가할 기능: **변경 이력** — 서버가 이력을 쌓고 `GET /api/history` 로 돌려주며, 웹 페이지 아래에 목록으로 표시.

## 🧰 준비

- Codex CLI, uv, 브라우저
- 06 강좌 예제 복사본 (원본은 건드리지 않음)

## 📝 단계별 따라하기

### 1단계 — 복사본 + git 안전망

```bash
cp -r courses/06-web-server-python/examples/02-led-api ~/projects/led-server    # 저장소 최상위에서
cd ~/projects/led-server
uv run uvicorn main:app --reload        # 원본이 동작하는지 먼저 확인 → Ctrl+C
git init
git add . && git commit -m "06 LED 서버 시작점"
```

### 2단계 — AGENTS.md

```bash
codex
› /init
```

초안이 생기면 열어서 **우리 규칙**을 보강합니다. (03 문서의 예시를 참고해 아래를 꼭 포함)

- uv 만 사용 (`uv run uvicorn main:app --reload`, `uv add`)
- 순수 HTML/CSS/JS, 포인트 색 `#6b4e9e`
- 상태 모양 `{on, by, time}` 은 바꾸지 말 것 (ESP32 가 의존)
- `app.mount("/")` 는 main.py 맨 아래 유지
- 한 번에 한 기능, 고치기 전에 무엇을 바꿀지 한 줄로 먼저 말하기

```bash
git add AGENTS.md && git commit -m "AGENTS.md 추가"
```

### 3단계 — 계획만 받기

```
› "변경 이력" 기능을 추가하려고 해. 서버는 상태가 바뀔 때마다 {on, by, time} 을 history 리스트에 쌓고
  GET /api/history 로 최근 10건을 최신순으로 돌려줘. 웹 페이지의 status 문장 아래에 이력 목록을 보여 주고 1초마다 갱신.
  아직 고치지 말고, 어떤 파일을 어떤 순서로 바꿀지 단계별 계획만 말해줘.
```

계획을 **읽습니다.** 이상한 점(예: 파일 저장, 새 라이브러리 추가)이 있으면 여기서 바로잡습니다.

### 4단계 — 서버 (1단계만)

```
› 계획의 1단계만 해줘: main.py 에 history 리스트와 GET /api/history 를 추가. set_led 에서 append.
  다른 파일은 건드리지 마.
```

검토·확인:

```
› /diff                       # main.py 만? history 항목이 {on, by, time}? 최신순 10건?
```

```bash
uv run uvicorn main:app --reload
# /docs → PUT /api/led 를 2~3번 → GET /api/history → 건수·순서 확인
```

```bash
git add . && git commit -m "이력 리스트 + GET /api/history"
```

### 5단계 — 화면 (2단계)

```
› 2단계: static/index.html 의 status 아래에 <ul id="history" class="list"> 를 추가하고, static/app.js 의 refresh() 가
  GET /api/history 도 호출해 "[시각] 이름 님이 LED를 켰/껐습니다" 로 목록을 그리게 해줘. style.css 엔 최소한의 .list 스타일만.
```

→ `/diff` → 브라우저 **두 창**으로 확인(한 쪽에서 누르면 다른 쪽 이력도 1초 안에 갱신) → 커밋.

### 6단계 — 테스트 시키기

```
› GET /api/history 가 최신순으로 최대 10건을 돌려주는지 확인하는 pytest 테스트를 tests/test_history.py 에 만들어줘.
  FastAPI 의 TestClient 를 쓰고, pytest 는 dev 의존성으로 uv add --dev 로 추가해줘.
```

→ 승인 요청(`uv add --dev pytest httpx` 등)을 **읽고** 승인 → `uv run pytest` → 통과 확인 → 커밋.

> 💡 테스트가 있으면 다음 요청이 무언가를 망가뜨렸을 때 바로 드러납니다.

### 7단계 — 일부러 버그 만들고 고치기

`main.py` 를 열어 `get_history` 의 변수 이름 하나를 일부러 틀리게 바꿉니다(예: `limit` → `limt`). 서버를 띄우거나
`uv run pytest` 를 돌려 **Traceback 을 받은 뒤**:

```
› 아래 오류가 났어. 고치기 전에 원인을 한 줄로 설명하고, 고쳐줘.
  (Traceback 통째로 붙이기)
```

→ 설명이 맞는지 보고 → 고친 뒤 `uv run pytest` 재실행 → 커밋.

### 8단계 — 리뷰 받기

```bash
codex review                              # 또는 대화 중 /review
codex -s read-only "main.py 와 static/app.js 를 읽고 개선점 3가지만 알려줘. 수정은 하지 마"
```

리뷰 결과 중 **동의하는 것만** 골라 다음 요청으로 반영합니다. (리뷰도 검증 대상)

## ✅ 확인

- [ ] `git log --oneline` 에 단계별 커밋이 4개 이상 있다
- [ ] `AGENTS.md` 에 프로젝트 규칙이 들어 있다
- [ ] `GET /api/history` 가 `/docs` 에서 최신순 10건을 돌려준다
- [ ] 두 브라우저 창에서 이력이 동기화된다
- [ ] `uv run pytest` 가 통과한다
- [ ] Traceback 을 붙여 버그를 고쳐 봤다
- [ ] `/diff` 를 **매 단계** 봤다

## 🆘 막히면

| 증상 | 해결 |
|------|------|
| 에이전트가 `pip install` 을 하려 함 | 승인 거절(`n`) → "AGENTS.md 대로 uv add 를 써줘". AGENTS.md 에 규칙이 있는지 확인 |
| `/` 가 JSON 만 보이거나 404 | `app.mount("/")` 가 맨 아래인지 — "mount 를 main.py 맨 아래로 옮겨줘" |
| 이력이 안 쌓임 | PUT 을 통해 바꿨는지(`/docs`), `set_led` 안에 append 가 있는지 `/diff` |
| 테스트가 import 오류 | `uv add --dev pytest httpx` 됐는지, `uv run pytest` 로 실행하는지 |
| 엉뚱한 파일이 바뀜 | `git restore <파일>` 후 "…만 고쳐줘" 로 범위 제한해 다시 |

## 🚀 더 해보기

- 이력을 `history.json` 파일에 저장해 서버를 재시작해도 유지 (05 강좌 `json.dump`)
- 06 실습 04 의 **WebSocket** 버전으로 바꾸기 — "polling 을 WebSocket 으로 바꿔줘, 06 강좌 examples/03-led-websocket 방식으로"
- **ESP32**: 03 강좌 `examples/06-wifi-led-client` 를 복사해 "버튼(GPIO4)을 누르면 PUT /api/led 를 보내게 해줘" → PlatformIO 로 빌드
- 커밋 메시지·README 갱신도 에이전트에게: "변경 내용에 맞게 README 의 API 표를 갱신해줘"

## 🎓 마무리

축하합니다! **실제 서버 프로젝트**에 AI 에이전트로 기능을 추가하고, 테스트하고, 버그를 고치고, 리뷰까지 받았습니다.
결과물보다 중요한 것은 **흐름** — 안전망(git) · 규칙(AGENTS.md) · 계획 · 작은 단계 · 검토 · 검증 · 커밋. 이 흐름은 도구가
바뀌어도 그대로 통합니다. 그리고 01~06 강좌의 **기본기**가 있어서 에이전트의 결과를 **판단**할 수 있었다는 점을 기억하세요.

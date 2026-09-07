---
marp: true
theme: cosmos
paginate: true
footer: "05 · 웹서버 (Python FastAPI)"
---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">COSMOS · 기술 기초 교육 05</div>

# 웹서버 — Python FastAPI

<div class="rule"></div>

<div class="subtitle">정적 파일 호스팅 · REST API · fetch/polling · WebSocket</div>

<div class="meta">
uv + FastAPI + uvicorn · 03 의 LED 제어판을 서버에<br>
대상: 03(웹 페이지)·04(파이썬) 를 마친 부원
</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

---

## 오늘 다룰 것

1. **HTTP 통신의 문법** — 메서드·상태코드·JSON
2. **정적 파일 호스팅** — FastAPI 로 LED 제어판 서빙, 다른 기기에서 접속
3. **REST API** — `GET/PUT /api/led`, `/docs` 로 테스트
4. **프론트 연동** — fetch · PUT · polling
5. **WebSocket** — 서버가 즉시 push

> 04 의 `led` 딕셔너리와 `set_led()` 가 **그대로 서버**가 됩니다. 마지막엔 두 창이 같은 LED 를 **즉시** 공유.
> 다음 06 강좌에서는 ESP32 가 **바로 이 서버**에 붙어 실제 LED 를 켭니다.

---

<!-- _class: section -->
<div class="eyebrow">PART 1</div>

# HTTP 통신의 문법

---

## 요청은 무엇으로 이루어지나

```
PUT /api/led HTTP/1.1                ← ① 메서드 + 경로
Host: localhost:8000                 ← ② 헤더
Content-Type: application/json
                                     ← (빈 줄)
{"on": true, "by": "철수"}            ← ③ 바디
```

| 메서드 | 우리 예제 | | 상태코드 | 뜻 |
|--------|-----------|-|----------|----|
| `GET` | LED 상태 보기 | | `200` | 성공 |
| `PUT` | LED 켜기/끄기 | | `404` | 없는 주소 |
| `POST` | (새 항목 추가) | | `422` | 보낸 JSON 형식 오류 |
| | | | `500` | 서버 코드 버그 |

> **주소는 명사**(`/api/led`), **동작은 메서드**(GET/PUT) — REST 감각. 데이터는 **JSON** = 파이썬 딕셔너리.

---

<!-- _class: section -->
<div class="eyebrow">PART 2</div>

# 정적 파일 호스팅

<div class="lead-sub">더블클릭 → http://</div>

---

## FastAPI 시작 — uv 그대로

```bash
uv init led-server && cd led-server
uv add fastapi "uvicorn[standard]"       # [standard] 에 WebSocket 포함
```

```python
from fastapi import FastAPI
app = FastAPI()

@app.get("/hello")
def hello():
    return {"message": "안녕, 서버!"}   # dict → 자동 JSON
```

```bash
uv run uvicorn main:app --reload         # http://localhost:8000/hello
```

> `main:app` = main.py 의 app 변수 · `--reload` 고치면 자동 재시작 · `--host 0.0.0.0` 다른 기기 허용

---

## static/ 폴더 서빙 — 03 의 LED 제어판을 서버에

```python
from fastapi.staticfiles import StaticFiles

app.mount("/", StaticFiles(directory="static", html=True), name="static")   # 맨 아래!
```

```
led-server/
├── main.py
└── static/  ← 04 examples/01-led-panel 의 index.html · style.css · app.js
```

- `http://localhost:8000/` → LED 제어판. 동작은 03 과 같지만 **주소가 http://**
- 같은 WiFi 의 폰·친구 노트북에서 `http://<내 IP>:8000` (`--host 0.0.0.0`)
- F12 Network: `/`, `style.css`, `app.js` 세 요청이 200 — **내 서버**의 응답

> ⚠️ `app.mount("/")` 는 **다른 라우트 뒤, 맨 마지막** — 먼저 두면 `/api/...` 를 가로챔

---

<!-- _class: section -->
<div class="eyebrow">PART 3</div>

# REST API

<div class="lead-sub">서버가 상태를 든다</div>

---

## GET / PUT `/api/led` — 04 의 딕셔너리가 그대로

```python
from datetime import datetime
from pydantic import BaseModel

led = {"on": False, "by": "아직 아무도", "time": "-"}   # 메모리 (서버 끄면 초기화)

class LedCommand(BaseModel):    # PUT 바디의 모양: {"on": true, "by": "철수"}
    on: bool
    by: str

@app.get("/api/led")            # 조회
def get_led(): return led

@app.put("/api/led")            # 변경 — 바디를 자동 검증해 cmd 로
def set_led(cmd: LedCommand):
    led.update(on=cmd.on, by=cmd.by, time=datetime.now().strftime("%H:%M:%S"))
    return led
```

> 04 의 `set_led(on, by)` 와 비교 — 인자가 `cmd` 로 묶였을 뿐. 타입 힌트가 **실제 검증**(틀리면 422)을 한다.

---

## `/docs` 에서 테스트 · 파라미터 3종

**http://localhost:8000/docs** → `PUT /api/led` → **Try it out** → `{"on": true, "by": "철수"}` → **Execute**
→ `GET /api/led` 로 바뀐 상태 확인. Postman 없이 끝.

```python
@app.get("/api/users/{user_id}")          # ① 경로: /api/users/3
def get_user(user_id: int): ...

@app.get("/api/history")                  # ② 쿼리: /api/history?limit=5
def get_history(limit: int = 10): ...

@app.put("/api/led")                      # ③ 바디: JSON → BaseModel
def set_led(cmd: LedCommand): ...
```

---

<!-- _class: section -->
<div class="eyebrow">PART 4</div>

# 프론트 ↔ 서버 연동

<div class="lead-sub">fetch · PUT · polling</div>

---

## 전체 그림

```
[브라우저 화면]                         [FastAPI 서버]
 이름 + 켜기/끄기                         led = {on, by, time}
        │  ① 켜기 클릭                          │
        ├─ PUT /api/led {on:true, by} ─────────▶│ ② time 붙여 저장
        │◀────────── {on, by, time} ────────────┤
        │  ③ 1초마다 반복(polling)                │
        ├─ GET /api/led ───────────────────────▶│
        │◀────────── {on, by, time} ────────────┤
        ④ 받은 상태로 화면(표시등 + 안내문) 갱신
```

> 03 의 `setLed()` 가 `new Date()` 로 **화면 안**에 기록하던 것을 → **서버에 PUT** 하고 **GET 으로 받아 그리기**로.

---

<!-- _class: dense -->

## fetch — GET 과 PUT

```js
async function fetchLed() {                      // 가져오기
  const res = await fetch("/api/led");           // ① 요청 → 응답 대기
  render(await res.json());                      // ② JSON → 객체 → 화면
}

async function setLed(on) {                      // 바꾸기
  const by = nameInput.value.trim() || "익명";
  await fetch("/api/led", {
    method: "PUT",
    headers: { "Content-Type": "application/json" },   // "JSON 보낸다"
    body: JSON.stringify({ on, by }),                  // 객체 → JSON 문자열
  });
  fetchLed();                                    // 누른 직후 바로 갱신
}

fetchLed();                                      // 처음 한 번
setInterval(fetchLed, 1000);                     // 1초마다 polling
```

> ⚠️ `body` 는 반드시 `JSON.stringify`, 헤더도 함께. 안 될 땐 **F12 Network** 부터.

---

<!-- _class: section -->
<div class="eyebrow">PART 5</div>

# WebSocket

<div class="lead-sub">1초마다 묻지 말고, 바뀌면 서버가 알려 준다</div>

---

## polling vs WebSocket

```
polling:    [브라우저] GET? → 200 … GET? → 200 … GET? → 200 …  (변화 없어도 계속)
WebSocket:  [브라우저] ══════════ 연결 유지 ══════════ [서버]
                       ◀── {"on":true,...}   (누가 바꾸면 즉시 push)
                       ──▶ {"on":false,"by":"철수"}   (버튼 → 바로 전송)
```

| | polling | WebSocket |
|---|---|---|
| 반영 지연 | 최대 1초 | **즉시** |
| 요청 수 | 변화 없어도 1초마다 | 변화 있을 때만 |
| 방향 | 브라우저가 시작 | **양방향** — 서버가 먼저 보냄 |

> 채팅·제어판·실시간 모니터링 = WebSocket. 장치(ESP32)는 REST polling 이 쉬움 → **섞어 쓴다**.
> 서버 쪽은 `async def` + `await` — "네트워크를 기다리는 함수 앞에 await". 여러 연결을 동시에 기다림.

---

## 서버 — `@app.websocket` + broadcast

```python
clients: set[WebSocket] = set()                    # 연결된 브라우저들

async def broadcast():                             # 모두에게 현재 상태 push
    for ws in list(clients):
        await ws.send_json(led)

@app.websocket("/ws")
async def websocket_endpoint(ws: WebSocket):
    await ws.accept();  clients.add(ws)
    await ws.send_json(led)                        # 접속 직후 현재 상태
    try:
        while True:
            data = await ws.receive_json()         # {"on":..,"by":..} 대기
            led.update(on=bool(data["on"]), by=data["by"], time=now())
            await broadcast()                      # PUT 핸들러에도 같은 한 줄
    except WebSocketDisconnect:
        clients.discard(ws)                        # 창을 닫으면
```

---

## 브라우저 — `new WebSocket`

```js
function connect() {
  ws = new WebSocket(`ws://${location.host}/ws`);
  ws.onmessage = (e) => render(JSON.parse(e.data));   // 서버 push → 화면
  ws.onclose = () => setTimeout(connect, 1000);        // 끊기면 재연결
}
connect();

function setLed(on) {
  const by = nameInput.value.trim() || "익명";
  ws.send(JSON.stringify({ on, by }));                 // fetch PUT 대신
}
```

> polling 의 `setInterval(fetchLed, 1000)` → `ws.onmessage` · `fetch(…PUT…)` → `ws.send(…)`.
> `render()` 는 **완전히 같음**. F12 → Network → **WS** → Messages 에서 ↑↓ 확인.

---

## 정리

- **정적 호스팅**: `app.mount("/", StaticFiles(...))` 맨 아래 — 더블클릭 페이지가 `http://` 로
- **API**: `led` 딕셔너리 + `@app.get`/`@app.put` + `BaseModel` 검증 + `/docs`
- **연동**: `fetch` GET/PUT + `JSON.stringify` + `setInterval` polling
- **WebSocket**: `@app.websocket` + `broadcast()` ↔ `new WebSocket` + `onmessage`/`send`
- 서버 규칙 `{on, by, time}` 은 04 기록기·06 ESP32 와 동일 — **한 서버, 여러 클라이언트**

<div class="small">실습: exercises/01 호스팅 → 02 API → 03 polling ★ → 04 WebSocket ★ · 다음: 06-esp32 (ESP32 가 이 서버를 읽음) → 07-ai (이 서버에 AI 로 기능 추가)</div>

---

<!-- _class: cover -->
<!-- _paginate: false -->
<!-- _footer: "" -->

<div class="eyebrow">이제 실습</div>

# 서버를 띄워 봅시다 🐍

<div class="rule"></div>

<div class="subtitle">exercises/ 의 4개 실습 — 두 창이 같은 LED 를 즉시 공유할 때까지</div>

<div class="brand">COSMOS TECHNICAL FUNDAMENTALS</div>

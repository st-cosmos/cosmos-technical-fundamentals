# 05. WebSocket — 진짜 실시간

## 한 줄 요약

> polling 은 "1초마다 물어보기". **WebSocket** 은 브라우저와 서버가 **연결을 계속 열어 두고** 양쪽이 아무 때나 메시지를 보내는
> 방식입니다. 누가 LED 를 바꾸면 서버가 **연결된 모든 창에 즉시 push** — 지연도 없고 불필요한 요청도 없습니다.

## 1. polling 의 한계

[04](04-frontend-integration.md)의 polling 은 단순하고 잘 동작하지만:

| | polling (GET 반복) | WebSocket |
|---|---|---|
| 반영 지연 | 최대 1초 (주기만큼) | **즉시** |
| 요청 수 | 아무 변화 없어도 1초마다 요청 | 변화가 있을 때만 메시지 |
| 연결 | 요청마다 새로 (HTTP) | **한 번 연결, 계속 유지** |
| 방향 | 브라우저 → 서버만 시작 가능 | **양방향** — 서버가 먼저 보낼 수 있음 |
| 복잡도 | 아주 쉬움 | 조금 더 (연결 관리) |

채팅·게임·실시간 대시보드·센서 모니터링처럼 "바뀌는 즉시 보여야" 하는 것에는 WebSocket 을 씁니다.

```
polling:    [브라우저] GET? → [서버] 200 …  GET? → 200 …  GET? → 200 … (변화 없어도 계속)
WebSocket:  [브라우저] ══════════ 연결 유지 ══════════ [서버]
                       ◀── {"on":true,...}  (누가 바꾸면 서버가 즉시 push)
                       ──▶ {"on":false,"by":"철수"}  (버튼 누르면 바로 전송)
```

## 2. 서버 — 연결 받기·브로드캐스트

FastAPI 는 WebSocket 을 기본 지원합니다. (`uvicorn[standard]` 에 필요한 라이브러리가 들어 있음)

```python
from fastapi import FastAPI, WebSocket, WebSocketDisconnect

app = FastAPI()
led = {"on": False, "by": "아직 아무도", "time": "-"}
clients: set[WebSocket] = set()          # 현재 연결된 브라우저들

async def broadcast():
    """연결된 모든 클라이언트에 현재 상태를 보낸다."""
    for ws in list(clients):
        try:
            await ws.send_json(led)
        except Exception:
            clients.discard(ws)          # 끊긴 연결은 정리

@app.websocket("/ws")
async def websocket_endpoint(ws: WebSocket):
    await ws.accept()                    # ① 연결 수락
    clients.add(ws)
    await ws.send_json(led)              # ② 접속 직후 현재 상태 한 번 보내기
    try:
        while True:
            data = await ws.receive_json()             # ③ 브라우저가 보낸 {"on":..,"by":..} 대기
            led["on"] = bool(data.get("on"))
            led["by"] = str(data.get("by") or "익명")
            led["time"] = datetime.now().strftime("%H:%M:%S")
            await broadcast()                          # ④ 모두에게 새 상태 push
    except WebSocketDisconnect:
        clients.discard(ws)              # ⑤ 창을 닫으면 여기로
```

| 부분 | 의미 |
|------|------|
| `@app.websocket("/ws")` | `ws://주소/ws` 로 오는 WebSocket 연결을 이 함수가 처리 |
| `async def` / `await` | 여러 연결을 **동시에** 기다리기 위한 비동기 문법. "기다리는 동안 다른 연결도 처리" |
| `await ws.accept()` | 연결 수락 (필수) |
| `await ws.receive_json()` | 메시지가 올 때까지 대기 → 딕셔너리 |
| `await ws.send_json(dict)` | 딕셔너리를 JSON 으로 보내기 |
| `WebSocketDisconnect` | 상대가 연결을 끊으면 발생하는 예외 |

> 💡 `async`/`await` 가 처음이라도 걱정 마세요. 이 예제에서는 **"네트워크를 기다리는 함수 앞에 await"** 라고만 이해하면
> 충분합니다. 지금까지 쓴 `def get_led()` 같은 일반 함수도 FastAPI 에서 그대로 섞어 쓸 수 있습니다.

### REST API 는 그대로 두기

`GET /api/led`·`PUT /api/led` 도 남겨 두면 **ESP32(polling)와 WebSocket 브라우저가 한 서버를 공유**합니다.
PUT 이 들어오면 `await broadcast()` 를 호출해 브라우저들도 즉시 갱신되게 합니다. (예제 코드 참고 — PUT 함수를 `async def` 로)

## 3. 브라우저 — WebSocket 객체

JS 에는 `WebSocket` 이 내장되어 있습니다. `fetch` 대신 이걸 씁니다.

```js
// 연결 (http → ws, https → wss). location.host 는 지금 페이지의 주소:포트
const ws = new WebSocket(`ws://${location.host}/ws`);

ws.onopen = () => console.log("연결됨");

ws.onmessage = (event) => {              // 서버가 push 할 때마다
  const led = JSON.parse(event.data);    // 문자열 → 객체
  render(led);                           // 04 문서의 render 그대로
};

ws.onclose = () => console.log("끊김");  // 서버가 죽거나 네트워크 문제

// 버튼 → 서버로 전송 (fetch PUT 대신)
function setLed(on) {
  const by = nameInput.value.trim() || "익명";
  ws.send(JSON.stringify({ on, by }));   // 객체 → JSON 문자열
}
```

| 04 (polling) | 05 (WebSocket) |
|---|---|
| `setInterval(fetchLed, 1000)` | `ws.onmessage = ...` (서버가 보낼 때 실행) |
| `fetch("/api/led", {method:"PUT", ...})` | `ws.send(JSON.stringify({on, by}))` |
| 응답 후 `fetchLed()` 재호출 | 필요 없음 — 서버가 모두에게 push |

`render()` 는 04 와 **완전히 같습니다.** 바뀐 건 "언제 어떻게 상태를 받느냐" 뿐.

### 끊기면 다시 붙기 (실전 팁)

```js
function connect() {
  const ws = new WebSocket(`ws://${location.host}/ws`);
  ws.onmessage = (e) => render(JSON.parse(e.data));
  ws.onclose = () => setTimeout(connect, 1000);   // 1초 뒤 재연결 시도
  return ws;
}
let ws = connect();
```

서버를 `--reload` 로 재시작하거나 WiFi 가 잠깐 끊겨도 자동으로 다시 붙습니다. 예제 코드에 들어 있습니다.

## 4. 눈으로 확인 — Network 탭의 WS

F12 → Network → **WS** 필터를 누르면 `ws` 연결 하나가 보이고, 클릭하면 **Messages** 탭에 오간 메시지가 **화살표(↑ 보냄, ↓ 받음)**
와 함께 실시간으로 쌓입니다. polling 때 1초마다 늘어나던 요청 목록이 사라진 것을 비교해 보세요.

## 5. 어떤 걸 언제 쓰나

| 상황 | 추천 |
|------|------|
| 상태가 가끔 바뀌고 1~2초 지연 OK (센서 값 보기) | polling — 단순함이 장점 |
| 바뀌는 즉시 모두에게 (채팅·제어판·알림) | **WebSocket** |
| 브라우저가 아닌 장치(ESP32) | HTTP GET/PUT 이 구현이 쉬움 (WebSocket 라이브러리도 있음) |
| 서버 → 브라우저 한 방향만 | Server-Sent Events(SSE) 도 선택지 |

> 💡 실무에서는 둘을 **섞어** 씁니다. 이 예제도 브라우저는 WebSocket, ESP32 는 REST polling 으로 같은 서버를 봅니다.

## 정리

| 서버 (FastAPI) | 브라우저 (JS) |
|---|---|
| `@app.websocket("/ws")` + `async def` | `new WebSocket("ws://host/ws")` |
| `await ws.accept()` | `ws.onopen` |
| `await ws.receive_json()` | `ws.send(JSON.stringify(obj))` |
| `await ws.send_json(led)` / `broadcast()` | `ws.onmessage = (e) => JSON.parse(e.data)` |
| `except WebSocketDisconnect` | `ws.onclose` → 재연결 |

## 🎓 마무리

정적 파일 호스팅 → REST API → fetch/polling → WebSocket — 웹서버의 한 바퀴를 모두 돌았습니다. 04 강좌의 화면, 05 강좌의
딕셔너리·함수, 그리고 여기의 서버가 한 앱으로 이어졌고, ESP32([03 강좌 docs/08](../../03-esp32-programming/docs/08-wifi-http-client.md))
까지 붙으면 웹과 하드웨어가 같은 서버를 공유합니다.

➡️ 실습: [`exercises/04-websocket.md`](../exercises/04-websocket.md) · 다음 강좌: [07-ai-assisted-development](../../07-ai-assisted-development/README.md)

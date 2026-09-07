# 실습 04. WebSocket 으로 실시간 반영 ★

> 🎯 목표: 실습 03 의 polling 을 **WebSocket** 으로 바꿔, 한 창에서 켜기/끄기를 누르면 **다른 창이 즉시** 바뀌게 한다.
> REST API 는 남겨 두어 ESP32(polling)도 함께 동작하게 한다.
>
> 📎 관련 문서: [docs/05-websocket.md](../docs/05-websocket.md) · 완성 코드: `examples/03-led-websocket/`

## 준비물

- [실습 03](03-led-control.md) 완성 프로젝트 (`led-server`: API + static)
- 브라우저 창 2개

## 전체 흐름

```
서버: /ws 엔드포인트 추가 → 접속 시 현재 상태 전송 → 메시지 받으면 상태 변경 + 모두에게 broadcast
브라우저: fetch/setInterval 제거 → new WebSocket → onmessage 로 render → 버튼은 ws.send
```

## 1단계. 서버에 WebSocket 추가

`main.py` 에 아래를 추가합니다. (기존 `led`, `LedCommand`, GET/PUT 은 그대로)

```python
from fastapi import FastAPI, WebSocket, WebSocketDisconnect

clients: set[WebSocket] = set()          # 연결된 브라우저들


async def broadcast():
    """연결된 모두에게 현재 상태 전송."""
    for ws in list(clients):
        try:
            await ws.send_json(led)
        except Exception:
            clients.discard(ws)


@app.websocket("/ws")
async def websocket_endpoint(ws: WebSocket):
    await ws.accept()
    clients.add(ws)
    await ws.send_json(led)                  # 접속 직후 현재 상태
    try:
        while True:
            data = await ws.receive_json()   # {"on": bool, "by": str}
            led["on"] = bool(data.get("on"))
            led["by"] = str(data.get("by") or "익명")
            led["time"] = datetime.now().strftime("%H:%M:%S")
            await broadcast()
    except WebSocketDisconnect:
        clients.discard(ws)
```

그리고 **PUT 도 브로드캐스트**하도록 `async def` 로 바꾸고 한 줄 추가합니다. (ESP32 나 `/docs` 에서 바꿔도 브라우저가 즉시 갱신)

```python
@app.put("/api/led")
async def set_led(cmd: LedCommand):
    led["on"] = cmd.on
    led["by"] = cmd.by
    led["time"] = datetime.now().strftime("%H:%M:%S")
    await broadcast()
    return led
```

> 📌 `app.mount("/")` 는 여전히 **맨 아래**. `/ws` 는 WebSocket 전용 경로라 mount 와 충돌하지 않지만, 순서 습관은 유지.

## 2단계. 브라우저 코드 바꾸기

`static/app.js`(또는 `index.html` 의 `<script>`)에서 **polling 부분을 지우고** WebSocket 으로 바꿉니다.

```js
const lamp = document.getElementById("lamp");
const status = document.getElementById("status");
const nameInput = document.getElementById("name");

function render(led) {                       // 실습 03 과 완전히 같음
  lamp.textContent = led.on ? "ON" : "OFF";
  lamp.className = "lamp " + (led.on ? "on" : "off");
  status.textContent =
    `마지막 변경: ${led.by} 님이 ${led.time} 에 LED를 ${led.on ? "켰습니다" : "껐습니다"}.`;
}

let ws;
function connect() {
  ws = new WebSocket(`ws://${location.host}/ws`);
  ws.onopen = () => console.log("WebSocket 연결됨");
  ws.onmessage = (e) => render(JSON.parse(e.data));   // 서버가 push → 화면 갱신
  ws.onclose = () => setTimeout(connect, 1000);        // 끊기면 1초 뒤 재연결
}
connect();

function setLed(on) {
  const by = nameInput.value.trim() || "익명";
  ws.send(JSON.stringify({ on, by }));                 // fetch PUT 대신
}
document.getElementById("on").addEventListener("click", () => setLed(true));
document.getElementById("off").addEventListener("click", () => setLed(false));
```

지운 것: `fetchLed()`, `setInterval(fetchLed, 1000)`, `fetch(..., {method: "PUT"})`.

## 3단계. 실행 · 두 창으로 확인

```bash
uv run uvicorn main:app --reload
```

1. 브라우저 창 **두 개**로 http://localhost:8000 접속
2. A 창에서 **켜기** → B 창이 **즉시**(눈에 띄는 지연 없이) ON 으로 바뀌면 성공 🎉
3. 실습 03 때와 비교: polling 은 최대 1초 지연이 있었고, Network 탭에 요청이 1초마다 쌓였음

## 4단계. Network 탭의 WS

F12 → Network → **WS** 필터 → `ws` 항목 클릭 → **Messages** 탭. 버튼을 누르면 ↑(보냄) 한 줄, 곧바로 ↓(받음) 한 줄이
쌓입니다. 다른 창에서 누르면 ↓ 만 쌓입니다. 1초마다 늘어나던 GET 요청은 **사라졌습니다.**

## 5단계. REST 와 공존 확인

`/docs` 에서 `PUT /api/led` 를 Execute 해 보세요. 브라우저 창들이 **즉시** 바뀝니다. (PUT 이 `broadcast()` 를 부르므로)
ESP32([06 강좌 docs/08](../../06-esp32-programming/docs/08-wifi-http-client.md))가 `GET /api/led` 를 polling 하는 것도 그대로 동작합니다.

## 확인

- [ ] 한 창의 클릭이 다른 창에 즉시 반영된다
- [ ] Network → WS → Messages 에 메시지가 오간다
- [ ] 서버를 재시작(`--reload` 저장)해도 브라우저가 자동으로 다시 붙는다 (`onclose` 재연결)
- [ ] `/docs` 의 PUT 도 브라우저에 즉시 반영된다

## 막히면?

| 증상 | 확인 |
|------|------|
| `WebSocket connection failed` | 주소가 `ws://`(https 면 `wss://`)인지, 서버에 `@app.websocket("/ws")` 있는지 |
| 서버 시작 시 WebSocket 라이브러리 오류 | `uv add "uvicorn[standard]"` 로 설치했는지 (`[standard]` 필수) |
| 첫 화면이 안 그려짐 | 접속 직후 `await ws.send_json(led)` 가 있는지 |
| 누르면 내 창만 바뀌고 남은 안 바뀜 | `broadcast()` 가 `clients` **전체**를 순회하는지 |
| `TypeError: object dict can't be used in 'await'` | `await` 는 `send_json`/`receive_json`/`broadcast()` 앞에만 |
| 창 닫았는데 서버 오류 로그 | `except WebSocketDisconnect` 로 감쌌는지 |

## 더 해보기 (도전 과제)

1. **접속자 수 표시**: `len(clients)` 를 상태에 넣어(`{"...", "viewers": 3}`) 화면에 "현재 3명 보고 있음"
2. **이력 함께 push**: 서버가 `history` 리스트(최근 10건)도 같이 보내고, 03 강좌처럼 `<ul>` 에 표시
3. **입장 알림**: 누가 접속하면 모두에게 `{"type": "join", ...}` 메시지 — 메시지에 `type` 필드를 두고 분기
4. **ESP32 를 WebSocket 클라이언트로**: `ArduinoWebsockets` 라이브러리로 polling 없이 즉시 반영 (심화)

## 🎓 마무리

축하합니다! **정적 파일 호스팅 → REST API → fetch/polling → WebSocket** — 웹서버 한 바퀴를 모두 돌았습니다.
03 의 화면과 04 의 파이썬이 서버로 이어졌고, 다음 06 의 ESP32 까지 같은 서버를 보게 됩니다.

➡️ 다음 강좌: [07-ai-assisted-development](../../07-ai-assisted-development/README.md) — 이 서버에 AI 에이전트로 기능을 더해 봅니다

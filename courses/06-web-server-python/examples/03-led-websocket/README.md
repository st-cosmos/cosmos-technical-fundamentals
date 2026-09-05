# 예제 03 — LED 제어판 WebSocket 버전 (실시간)

예제 02 의 polling(1초마다 GET)을 **WebSocket** 으로 바꿨습니다. 브라우저가 `/ws` 로 연결을 유지하고, 누가 LED 를 바꾸면
서버가 **연결된 모두에게 즉시** 새 상태를 보냅니다. REST API(`GET/PUT /api/led`)도 남겨 두어 ESP32(polling)와 `/docs`
테스트가 함께 동작하고, PUT 으로 바뀌어도 브라우저들에 즉시 반영됩니다.

## 실행

```bash
uv run uvicorn main:app --reload
```

<http://localhost:8000> 을 **창 2개**로 열고 한 쪽에서 켜기/끄기 → 다른 쪽이 **즉시** 바뀝니다.
F12 → Network → **WS** → `ws` 클릭 → **Messages** 에서 ↑(보냄) ↓(받음) 메시지를 볼 수 있습니다.

## 구조

```
03-led-websocket/
├── main.py              REST API + WebSocket(/ws) + broadcast + static mount
├── pyproject.toml
└── static/
    ├── index.html       예제 02 와 같은 화면 + 연결 상태 표시
    ├── style.css
    └── app.js           new WebSocket → onmessage 로 render, 버튼은 ws.send, 끊기면 재연결
```

## 예제 02 와 비교

| | 02 polling | 03 WebSocket |
|---|---|---|
| 상태 받기 | `setInterval(fetchLed, 1000)` | `ws.onmessage` (서버가 push) |
| 상태 바꾸기 | `fetch("/api/led", {method: "PUT"})` | `ws.send(JSON.stringify({on, by}))` |
| 반영 지연 | 최대 1초 | 즉시 |
| 요청 수 | 변화 없어도 1초마다 | 변화 있을 때만 |
| 서버 | `def` 함수 | `async def` + `await` (여러 연결 동시 대기) |

`render()` 함수는 두 예제가 **완전히 같습니다.** 바뀐 것은 "언제 어떻게 상태를 받느냐" 뿐.

## 메시지

| 방향 | 내용 |
|------|------|
| 서버 → 브라우저 | `{"on": true, "by": "철수", "time": "14:03:05", "viewers": 2}` (접속 직후·변경 시·접속자 수 변동 시) |
| 브라우저 → 서버 | `{"on": true, "by": "철수"}` (버튼 클릭) |

관련 실습: [`../../exercises/04-websocket.md`](../../exercises/04-websocket.md)

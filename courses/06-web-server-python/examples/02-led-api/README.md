# 예제 02 — LED API + 제어판 (GET/PUT + fetch + polling)

서버가 LED 상태 `{on, by, time}` 을 들고 **`GET /api/led`**(조회)·**`PUT /api/led`**(변경)에 응답합니다. 웹 페이지는
켜기/끄기를 **PUT** 으로 보내고 **1초마다 GET(polling)** 해서 "누가 언제 바꿨는지"를 표시합니다. 창을 2개 열어 서로 제어해 보세요.

> 🔗 **ESP32 와 공유하는 서버**입니다. 03-esp32-programming 의 선택 심화(`examples/06-wifi-led-client`)가 이 서버의
> `GET /api/led` 를 읽어 실제 LED 를 켜고 끕니다. 웹 페이지와 ESP32 는 같은 서버를 보는 여러 클라이언트.

## 실행

```bash
uv run uvicorn main:app --reload
```

브라우저에서 <http://localhost:8000> — **창을 2개** 열어 한 쪽에서 켜고/끄면 다른 쪽에도 1초 안에 반영됩니다.
API 테스트는 <http://localhost:8000/docs> 에서 **Try it out → Execute**.

ESP32 등 다른 기기에서 접속하려면 `uv run uvicorn main:app --host 0.0.0.0 --port 8000`.

## 구조

```
02-led-api/
├── main.py              FastAPI 서버 (API + 정적파일 서빙)
├── pyproject.toml
└── static/
    ├── index.html       이름 입력, 켜기/끄기 버튼, LED 표시등, 상태 문장
    ├── style.css
    └── app.js           fetch PUT + setInterval polling
```

## API

| 메서드 | 경로 | 호출 주체 | 동작 |
|--------|------|-----------|------|
| `GET` | `/api/led` | 웹 페이지(1초마다)·ESP32 | 현재 상태 `{on, by, time}` |
| `PUT` | `/api/led` | 웹 버튼 | 상태 변경. body `{"on": true, "by": "홍길동"}` → 서버가 `time` 을 붙여 저장 |

```bash
curl -X PUT http://localhost:8000/api/led -H "Content-Type: application/json" -d "{\"on\": true, \"by\": \"홍길동\"}"
```

## 동작 흐름

1. **켜기/끄기** → `PUT /api/led` (body `{on, by}`)
2. 서버가 시각을 붙여 상태를 저장 (`{on, by, time}`)
3. 모든 클라이언트(웹 창·ESP32)가 1초마다 `GET /api/led` 로 현재 상태를 받아 반영

> 💡 polling 은 가장 단순한 "실시간 흉내내기". 진짜 실시간은 예제 03 의 **WebSocket**.

관련 실습: [`../../exercises/02-led-api.md`](../../exercises/02-led-api.md) · [`../../exercises/03-led-control.md`](../../exercises/03-led-control.md)

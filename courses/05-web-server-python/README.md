# 05. 웹서버 — Python FastAPI

03 강좌에서 만든 LED 제어판(HTML/CSS/JS)을 **Python FastAPI 서버**에 올립니다. **정적 파일 호스팅**으로 페이지를 서빙하고,
**REST API** 로 서버가 LED 상태를 들게 하고, **fetch/polling** 으로 화면과 연결한 뒤, 마지막에 **WebSocket** 으로 진짜 실시간을
만듭니다. 이 서버는 다음 06 강좌에서 ESP32(WiFi 실습)가 그대로 재사용합니다.

> 🎯 이 자료를 끝내면: `uv run uvicorn` 으로 서버를 띄우고, 정적 파일을 서빙하고, GET/PUT API 를 만들어 `/docs` 에서 테스트하고,
> 브라우저 두 창이 **같은 LED 상태를 즉시 공유**하는 앱을 완성할 수 있습니다.

## 누구를 위한 자료인가

- **대상**: 웹 페이지(03)와 파이썬 기초(04)를 마친 부원
- **선수**: [03-web-application](../03-web-application/README.md), [04-python-programming](../04-python-programming/README.md) (uv · 딕셔너리 · 함수)
- **도구**: uv, VS Code, 크롬(F12 Network 탭)

## 폴더 구조

```
05-web-server-python/
├── docs/
│   ├── 01-http-basics.md              요청/응답 · 메서드 · 상태코드 · JSON · REST 감각
│   ├── 02-fastapi-static-hosting.md   ① FastAPI 시작 · uv run uvicorn · 정적 파일 호스팅
│   ├── 03-rest-api.md                 ② GET/PUT /api/led · pydantic · /docs · 파라미터
│   ├── 04-frontend-integration.md     ③ fetch · PUT · polling — 화면과 서버 연결
│   └── 05-websocket.md                ④ WebSocket — 서버가 즉시 push
├── exercises/
│   ├── 01-static-hosting.md           LED 제어판을 서버로 호스팅 + 다른 기기 접속
│   ├── 02-led-api.md                  GET/PUT API 만들고 /docs 로 테스트
│   ├── 03-led-control.md              fetch + polling 으로 두 창 동기화 ★
│   └── 04-websocket.md                polling → WebSocket ★
├── examples/
│   ├── 01-static-hosting/             최소 서버 + static/ (03 의 LED 제어판)
│   ├── 02-led-api/                    API + polling 제어판 — ESP32 와 공유하는 서버
│   └── 03-led-websocket/              WebSocket 실시간 버전 (+ REST 공존)
└── slides/
    └── web-server-python.md
```

## 학습 순서

1. 📖 `docs/01` HTTP 통신의 문법 — 메서드·상태코드·JSON
2. 📂 `docs/02` + **`exercises/01`** — FastAPI 시작, LED 제어판 **정적 호스팅**, 다른 기기에서 접속
3. 🔌 `docs/03` + **`exercises/02`** — **API** GET/PUT, `/docs` 테스트
4. 🔁 `docs/04` + **`exercises/03`** — fetch/PUT/polling 으로 두 창 동기화 ★
5. ⚡ `docs/05` + **`exercises/04`** — **WebSocket** 으로 즉시 반영 ★
6. 🔗 다음 06 강좌 [docs/08](../06-esp32-programming/docs/08-wifi-http-client.md) 에서 ESP32 가 **바로 이 서버**(02)에 붙어 실제 LED 를 켜고,
   [docs/09](../06-esp32-programming/docs/09-wifi-websocket-client.md) 에서는 03 의 WebSocket 서버에 붙어 즉시 반영됩니다

## 예제 실행

```bash
cd courses/05-web-server-python/examples/02-led-api
uv run uvicorn main:app --reload                       # http://localhost:8000
uv run uvicorn main:app --host 0.0.0.0 --port 8000     # 다른 기기(ESP32·폰)에서 접속 허용
```

`uv run` 이 가상환경·의존성을 자동 처리합니다. 처음 한 번은 다운로드로 수십 초 걸립니다.

## 데이터 규칙 (전 강좌 공통)

```
led = {"on": bool, "by": str, "time": "HH:MM:SS"}
GET  /api/led            → led
PUT  /api/led {on, by}   → 서버가 time 을 붙여 저장 → led
WS   /ws                 → 접속 시 led, 변경 시 모두에게 led push · 보낼 땐 {on, by}
```

04 강좌의 LED 이력 기록기, 06 강좌의 ESP32 펌웨어가 같은 모양을 씁니다.

## 슬라이드

저장소 최상위에서 `npm run pdf -- 06-web`

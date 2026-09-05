# 03. REST API — LED 상태 GET / PUT

## 한 줄 요약

> 서버가 **LED 상태 딕셔너리**를 들고, `GET /api/led`(조회)와 `PUT /api/led`(변경) 두 요청에 JSON 으로 응답합니다.
> 05 강좌의 `led` 딕셔너리와 `set_led()` 함수가 **그대로 API 가 되는** 것을 보게 됩니다. 테스트는 `/docs` 에서.

## 1. API 란?

**API (Application Programming Interface)** = 프로그램이 프로그램에게 요청하는 창구. 웹에서는 **"이 주소에 이 메서드로
요청하면 이런 JSON 을 돌려준다"** 는 약속입니다. 사람이 보는 HTML 페이지가 아니라 **데이터**를 주고받습니다.

| | 정적 파일 (02) | API (이 문서) |
|---|---|---|
| 요청 | `GET /index.html` | `GET /api/led`, `PUT /api/led` |
| 응답 | 파일 그대로 | 서버가 **계산한 JSON** |
| 누가 쓰나 | 브라우저 화면 | JS `fetch`, ESP32, 다른 서버 … |

## 2. 상태를 서버에 두기

05 강좌 LED 이력 기록기의 데이터를 그대로 가져옵니다.

```python
led = {"on": False, "by": "아직 아무도", "time": "-"}   # 메모리에 저장 (서버를 끄면 초기화)
```

> ⚠️ 변수에 두는 것이라 서버를 재시작하면 초기 상태로 돌아갑니다. 실습엔 충분하고, 실제 서비스라면 파일이나
> 데이터베이스에 저장합니다. (05 강좌의 `json.dump` 를 붙이면 끝 — 더 해보기)

## 3. GET — 조회

```python
@app.get("/api/led")
def get_led():
    return led          # dict → JSON  {"on": false, "by": "...", "time": "-"}
```

브라우저에서 `http://localhost:8000/api/led` 를 열면 JSON 이 그대로 보입니다. (브라우저 주소창 = GET 요청)

## 4. PUT — 변경 (바디로 데이터 받기)

바꾸려면 "켤지/끌지" 와 "누가" 를 **요청 바디(JSON)** 로 받아야 합니다. FastAPI 는 **pydantic 모델**로 받을 데이터의
**모양**을 선언하면 파싱·검증을 자동으로 해 줍니다.

```python
from datetime import datetime
from pydantic import BaseModel

class LedCommand(BaseModel):   # PUT 바디의 모양: {"on": true, "by": "철수"}
    on: bool
    by: str

@app.put("/api/led")
def set_led(cmd: LedCommand):
    led["on"] = cmd.on
    led["by"] = cmd.by
    led["time"] = datetime.now().strftime("%H:%M:%S")   # 시각은 서버가 붙인다
    return led
```

- `cmd: LedCommand` — 바디 JSON 이 `LedCommand` 모양인지 **자동 검증**. `on` 이 불리언이 아니면 서버가 알아서 `422` 오류 응답.
- **같은 주소 `/api/led`** 에 GET 과 PUT 을 따로 붙였습니다. REST 감각: 주소는 명사(자원), 메서드는 동사([01](01-http-basics.md)).
- 05 강좌 `set_led(on, by)` 함수와 비교해 보세요 — 인자가 `cmd` 하나로 묶였을 뿐 하는 일이 같습니다.

## 5. 전체 코드

```python
from datetime import datetime
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

led = {"on": False, "by": "아직 아무도", "time": "-"}

class LedCommand(BaseModel):
    on: bool
    by: str

@app.get("/api/led")
def get_led():
    return led

@app.put("/api/led")
def set_led(cmd: LedCommand):
    led["on"] = cmd.on
    led["by"] = cmd.by
    led["time"] = datetime.now().strftime("%H:%M:%S")
    return led
```

```bash
uv run uvicorn main:app --reload
```

## 6. `/docs` 에서 테스트 ★

**http://localhost:8000/docs** 를 열면 두 엔드포인트가 보입니다.

1. **`PUT /api/led`** 펼치기 → **Try it out** → 바디에 `{"on": true, "by": "철수"}` → **Execute**
2. 응답에 `{"on": true, "by": "철수", "time": "14:03:05"}` 가 오면 성공
3. **`GET /api/led`** → Execute → 방금 바꾼 상태가 보임

Postman 같은 별도 도구 없이 API 테스트가 끝납니다. 코드를 한 줄도 더 안 써도 문서가 생기는 것이 FastAPI 의 강점.

명령줄로도 가능합니다.

```bash
curl http://localhost:8000/api/led
curl -X PUT http://localhost:8000/api/led -H "Content-Type: application/json" -d "{\"on\": true, \"by\": \"철수\"}"
```

## 7. 파라미터 세 가지 — 경로 · 쿼리 · 바디

값을 받는 방법은 세 가지입니다.

```python
# ① 경로 파라미터: 주소의 일부 — /api/users/3
@app.get("/api/users/{user_id}")
def get_user(user_id: int):
    return {"user_id": user_id}

# ② 쿼리 파라미터: 주소 뒤 ?key=value — /api/history?limit=5
@app.get("/api/history")
def get_history(limit: int = 10):        # 기본값 주면 생략 가능
    return history[-limit:]

# ③ 바디: PUT/POST 로 실어 보낸 JSON (BaseModel 로 받으면 자동 검증) — 위의 set_led
```

| 종류 | 위치 | 쓰임 |
|------|------|------|
| 경로(path) | `/users/{id}` | 특정 자원 지목 |
| 쿼리(query) | `?limit=5` | 검색·필터·옵션 |
| 바디(body) | 요청 본문 JSON | 보내는 데이터 |

> 💡 함수 인자에 타입(`int`, `str`)이나 `BaseModel` 을 적으면 FastAPI 가 **자동으로 변환·검증**하고, 틀리면 알아서
> `422` 를 돌려줍니다. 05 강좌의 타입 힌트가 실제로 일하는 순간.

## 8. 정적 파일과 함께 — 순서 주의

02 문서의 정적 파일 서빙과 합칠 때, **API 라우트가 먼저, mount 가 맨 마지막**입니다.

```python
@app.get("/api/led") ...
@app.put("/api/led") ...

app.mount("/", StaticFiles(directory="static", html=True), name="static")   # 맨 아래!
```

## 정리

| 개념 | 코드 |
|------|------|
| 상태 | 모듈 변수 `led = {...}` (메모리) |
| 조회 | `@app.get("/api/led")` → `return led` |
| 변경 | `class LedCommand(BaseModel)` + `@app.put("/api/led")` + `cmd: LedCommand` |
| 시각 | `datetime.now().strftime("%H:%M:%S")` — 서버가 붙임 |
| 테스트 | `/docs` → Try it out → Execute |
| 파라미터 | 경로 `{id}` · 쿼리 `?k=v` · 바디 `BaseModel` |

## 다음 단계

API 가 생겼으니, 04 강좌의 LED 제어판 JS 가 `new Date()` 로 **화면 안에서만** 기록하던 것을 **`fetch` 로 서버에 PUT**
하고, **1초마다 GET** 해서 모두가 같은 상태를 보게 바꿉니다.

➡️ [04. 프론트와 서버 연동 — fetch · PUT · polling](04-frontend-integration.md)

> 🧪 실습: [`exercises/02-led-api.md`](../exercises/02-led-api.md)

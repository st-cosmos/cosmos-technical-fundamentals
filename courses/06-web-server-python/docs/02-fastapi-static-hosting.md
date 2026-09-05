# 02. FastAPI 시작 + 정적 파일 호스팅

## 한 줄 요약

> Python 라이브러리 **FastAPI** 로 몇 줄 만에 웹서버를 띄우고, **04 강좌에서 만든 LED 제어판(HTML/CSS/JS)을 이 서버가
> 내려주게** 합니다. 이것이 **정적 파일 호스팅** — "파일을 더블클릭해서 열던 페이지"가 "주소로 접속하는 웹 페이지"가 됩니다.

## 1. 정적 파일 호스팅이란?

04 강좌에서는 `index.html` 을 **더블클릭**해서 열었습니다. 주소창을 보면 `file:///C:/.../index.html` — 내 컴퓨터의 파일을
브라우저가 직접 읽은 것입니다. 다른 사람은 이 주소로 못 들어옵니다.

**웹서버**가 그 파일들을 들고 있다가, 누가 `http://서버주소/` 로 요청하면 `index.html` 을 **응답으로 보내 주면**, 같은 WiFi 의
누구나(그리고 ESP32 도) 접속할 수 있습니다.

```
[브라우저]  ── GET /            ─▶  [서버]  → static/index.html 을 응답
[브라우저]  ── GET /style.css   ─▶  [서버]  → static/style.css
[브라우저]  ── GET /app.js      ─▶  [서버]  → static/app.js
```

- **정적(static)** = 요청마다 내용이 바뀌지 않는 파일 (HTML·CSS·JS·이미지). 서버는 그냥 파일을 돌려줄 뿐.
- **동적(API)** = 요청을 받아 **계산해서** 응답 (다음 문서 [03](03-rest-api.md)).

## 2. uv 로 프로젝트 시작 + 의존성

05 강좌의 uv 흐름 그대로입니다.

```bash
uv init led-server
cd led-server
uv add fastapi "uvicorn[standard]"
```

| 패키지 | 역할 |
|--------|------|
| **fastapi** | 서버(라우팅·API)를 만드는 프레임워크 |
| **uvicorn** | 그 서버를 실제로 **실행**해 주는 엔진 (`[standard]` 에 WebSocket 지원 포함 — 05 문서에서 씀) |

> 💡 `uv add` 가 `.venv` 를 자동으로 만들어 설치까지 — `activate` 불필요. `uv.lock` 으로 버전 고정.

## 3. 최소 서버 — 5줄이면 끝

`main.py`:

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/hello")
def hello():
    return {"message": "안녕, 서버!"}
```

- `app = FastAPI()` : 서버 본체를 하나 만든다
- `@app.get("/hello")` : "주소 `/hello` 로 **GET** 요청이 오면 아래 함수를 실행해라" (**라우팅**)
- 함수가 돌려준 **딕셔너리는 자동으로 JSON** 으로 변환되어 응답됩니다 (05 강좌의 딕셔너리 = JSON)

## 4. 실행 — uv run

```bash
uv run uvicorn main:app --reload
```

- `main` = 파일 이름(`main.py`), `app` = 그 안의 변수 이름
- `--reload` = 코드를 고치면 **자동 재시작** (개발 중엔 항상 켜기)
- 끄기: 터미널에서 **Ctrl + C**

브라우저에서 **http://localhost:8000/hello** → `{"message":"안녕, 서버!"}` 🎉

> 💡 다른 기기(친구 노트북·ESP32)에서도 접속하게 하려면 `--host 0.0.0.0` 을 붙입니다.
> `uv run uvicorn main:app --reload --host 0.0.0.0 --port 8000` → 다른 기기에서 `http://<내 PC IP>:8000`
> ([01-cli IP 확인](../../01-cli/docs/04-network-ip.md))

## 5. 정적 파일 서빙 — LED 제어판 올리기

1. 프로젝트 안에 **`static`** 폴더를 만들고, 04 강좌의 `examples/01-led-panel/` 에 있는 `index.html`, `style.css`, `app.js`
   세 파일을 복사해 넣습니다.
2. `main.py` 에 두 줄을 추가합니다.

```python
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

app = FastAPI()

@app.get("/hello")
def hello():
    return {"message": "안녕, 서버!"}

# static/ 폴더를 "/" 에 서빙. html=True 면 "/" 요청에 static/index.html 을 돌려준다.
app.mount("/", StaticFiles(directory="static", html=True), name="static")
```

```
led-server/
├── main.py
├── pyproject.toml
└── static/
    ├── index.html
    ├── style.css
    └── app.js
```

이제 **http://localhost:8000/** 에서 LED 제어판이 열립니다. 더블클릭으로 열 때와 **똑같이 동작**하지만, 주소가 `http://` 로
바뀌었고 **같은 WiFi 의 다른 기기에서도** 열 수 있습니다.

> 📌 **`app.mount("/")` 는 다른 모든 라우트를 정의한 뒤 맨 아래에** 두세요. 위에서부터 매칭되기 때문에, `/` 마운트를
> 먼저 두면 `/hello` 나 `/api/...` 요청까지 가로챕니다. (다음 문서의 API 도 같은 규칙)

> 💡 `directory="static"` 은 **서버를 실행한 폴더 기준** 상대 경로입니다. 프로젝트 폴더에서 `uv run` 하세요.
> 어디서 실행해도 되게 하려면 `Path(__file__).parent / "static"` (예제 코드가 이 방식).

## 6. F12 Network 로 확인

새로고침하면 Network 탭에 `localhost`(document) · `style.css` · `app.js` 세 요청이 각각 `200` 으로 보입니다.
[01 문서](01-http-basics.md)에서 배운 요청/응답이 **내 서버**에 대해 일어나는 것입니다. 터미널에도 로그가 찍힙니다.

```
INFO:     127.0.0.1:52344 - "GET / HTTP/1.1" 200 OK
INFO:     127.0.0.1:52344 - "GET /style.css HTTP/1.1" 200 OK
```

## 7. 자동 문서 — `/docs`

**http://localhost:8000/docs** 에 접속하면 내가 만든 API(`/hello`)가 정리된 **대화형 문서**가 자동 생성됩니다.
다음 문서에서 API 를 만들면 여기서 버튼만 눌러 테스트할 수 있습니다. FastAPI 의 최고 장점.

## 정리

| 단계 | 명령 / 코드 |
|------|-------------|
| 프로젝트 시작 | `uv init led-server` → `uv add fastapi "uvicorn[standard]"` |
| 라우팅 | `@app.get("/hello")` + 함수 (dict → JSON) |
| 실행 | `uv run uvicorn main:app --reload` (다른 기기: `--host 0.0.0.0`) |
| 정적 파일 | `app.mount("/", StaticFiles(directory="static", html=True))` — **맨 아래** |
| 자동 문서 | `http://localhost:8000/docs` |

## 다음 단계

페이지는 떴지만 아직 "누가 켰는지" 는 **내 브라우저 안**에만 있습니다. 서버가 **상태를 들고** 조회·변경 요청에 응답하게
만드는 것이 **API** 입니다.

➡️ [03. REST API — LED 상태 GET / PUT](03-rest-api.md)

> 🧪 실습: [`exercises/01-static-hosting.md`](../exercises/01-static-hosting.md)

# 실습 01. FastAPI 로 LED 제어판 호스팅 (정적 파일)

> 🎯 목표: **FastAPI 서버를 띄우고**, 03 강좌에서 만든 LED 제어판(HTML/CSS/JS)을 그 서버가 내려주게 한다.
> 더블클릭으로 열던 페이지가 `http://localhost:8000/` 이 되고, **같은 WiFi 의 친구 폰에서도** 열린다.
>
> 📎 관련 문서: [docs/02-fastapi-static-hosting.md](../docs/02-fastapi-static-hosting.md) · 완성 코드: `examples/01-static-hosting/`

## 준비물

- **uv** (`uv --version`), VS Code, 크롬
- 03 강좌 `examples/01-led-panel/` 의 세 파일 (`index.html`, `style.css`, `app.js`) — 또는 직접 만든 것

## 전체 흐름

```
uv init → fastapi·uvicorn 추가 → main.py (5줄) → uv run 실행 → /hello 확인
   → static/ 폴더에 LED 제어판 복사 → mount 한 줄 → http://localhost:8000/
```

## 1단계. 프로젝트 시작

```bash
uv init led-server
cd led-server
uv add fastapi "uvicorn[standard]"
```

`pyproject.toml` 의 `dependencies` 에 두 패키지가 들어가고 `.venv` 가 생기면 OK.

## 2단계. 최소 서버

`main.py` 를 아래로 바꿉니다. (uv init 이 만든 내용은 지워도 됩니다)

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/hello")
def hello():
    return {"message": "안녕, 서버!"}
```

```bash
uv run uvicorn main:app --reload
```

브라우저: **http://localhost:8000/hello** → `{"message":"안녕, 서버!"}` 🎉
**http://localhost:8000/docs** 도 열어 보세요. `/hello` 가 문서에 나타납니다.

## 3단계. 정적 파일 올리기

1. `main.py` 옆에 **`static`** 폴더를 만듭니다.
2. 03 강좌의 `examples/01-led-panel/index.html`, `style.css`, `app.js` 를 `static/` 안으로 복사합니다.

```bash
mkdir static
# 저장소 최상위 기준 경로 예 — 본인 위치에 맞게
cp ../cosmos-technical-fundamentals/courses/03-web-application/examples/01-led-panel/*.* static/
```

3. `main.py` 에 정적 파일 서빙을 추가합니다.

```python
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

app = FastAPI()

@app.get("/hello")
def hello():
    return {"message": "안녕, 서버!"}

app.mount("/", StaticFiles(directory="static", html=True), name="static")   # 맨 아래!
```

`--reload` 덕분에 서버가 자동 재시작됩니다. **http://localhost:8000/** → LED 제어판! 켜기/끄기가 03 때와 똑같이 동작합니다.

## 4단계. Network 탭으로 보기

F12 → Network → F5. `localhost`(document) · `style.css` · `app.js` 세 요청이 `200` 으로 보이고, 서버 터미널에도
`"GET /style.css HTTP/1.1" 200 OK` 로그가 찍힙니다. **내 서버**가 파일을 응답한 것입니다.

## 5단계. 다른 기기에서 접속 ★

서버를 끄고(Ctrl+C) `--host 0.0.0.0` 으로 다시 띄웁니다.

```bash
uv run uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

내 PC 의 IP 를 확인([01-cli](../../01-cli/docs/04-network-ip.md))하고, **같은 WiFi 의 폰이나 친구 노트북**에서
`http://<내 IP>:8000` 을 열어 보세요. LED 제어판이 뜨면 성공! (안 되면 Windows 방화벽 허용 팝업 → **허용**)

> 💡 지금은 각자 화면이 **따로** 동작합니다(기록이 브라우저 안에만). 이걸 서버가 들고 모두가 같은 상태를 보게 하는 것이
> 실습 02·03.

## 확인

- [ ] `/hello` 가 JSON 을 돌려준다
- [ ] `/docs` 에 `/hello` 가 보인다
- [ ] `http://localhost:8000/` 에서 LED 제어판이 열리고 동작한다
- [ ] Network 탭에 세 파일 요청이 200 으로 보인다
- [ ] 다른 기기에서 `http://<내 IP>:8000` 으로 열었다

## 막히면?

| 증상 | 확인 |
|------|------|
| `uvicorn: command not found` | `uv run` 으로 실행했는지, `uv add` 했는지 |
| `/` 가 `{"detail":"Not Found"}` | `app.mount(...)` 줄이 있는지, `static/index.html` 경로·이름 |
| CSS 가 안 먹음 | `static/style.css` 가 있는지, `index.html` 의 `href="style.css"` |
| `/hello` 가 404 로 바뀜 | `app.mount("/")` 가 라우트 **아래**에 있는지 |
| 다른 기기에서 안 열림 | `--host 0.0.0.0`, 같은 WiFi, 방화벽, IP 재확인 |
| `Address already in use` | 다른 서버가 8000 사용 중 → 끄거나 `--port 8001` |

## 더 해보기

1. `static/` 에 이미지를 넣고 `index.html` 에 `<img src="logo.png">` 로 표시 (경로는 static 기준)
2. `/hello` 를 `/api/time` 으로 바꿔 현재 시각을 JSON 으로 돌려주기 (`datetime.now().strftime(...)`)
3. `http://localhost:8000/docs` 에서 `/api/time` 을 Execute 해 보기

➡️ 다음: [실습 02. LED API — GET / PUT](02-led-api.md)
